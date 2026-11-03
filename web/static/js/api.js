/* ========================================
   WAF 管理员后台 统一请求封装 & API 定义
   - 统一表单提交（后端仅解析 x-www-form-urlencoded / multipart）
   - 统一 code/msg/data 解析，code!==200 统一 toast 报错
   - code===401 统一跳转登录页
   - 全局对象 App.api，且作为 Vue3 插件注入 $api
   ======================================== */
(function () {
  const App = (window.App = window.App || {});
  const EP = () => (window.ElementPlus ? window.ElementPlus : null);

  /* 全局提示（懒取 ElementPlus，未加载时降级 console） */
  function message(msg, type) {
    const el = EP();
    if (el && el.ElMessage) {
      return el.ElMessage({ message: msg, type: type || 'error' });
    }
    console[type === 'error' ? 'error' : type || 'log'](msg);
  }

  /* 跳转登录页 */
  function toLogin() {
    const loginPath = '/login.html';
    const cur = window.location.pathname;
    if (cur.indexOf('/login.html') >= 0) return;
    if (window.top && window.top !== window.self) {
      try {
        window.top.location.href = loginPath;
      } catch (e) {
        window.location.href = loginPath;
      }
    } else {
      window.location.href = loginPath;
    }
  }

  /* 布尔/数字字段清洗：供后端 0/1 int 使用 */
  function to01(v) {
    return v ? 1 : 0;
  }

  /**
   * 统一请求（返回 json 全量，供内部使用）。
   * @param {string} url 如 "/api/site/list"
   * @param {object} params 请求参数；数组/对象会被 JSON 序列化
   * @param {object} options { method, formData:Boolean }
   * @returns {Promise<object>} 返回完整 json { code, msg, data, count }
   */
  function requestRaw(url, params, options) {
    options = options || {};
    const method = (options.method || 'POST').toUpperCase();
    const body = buildBody(params, options);

    return fetch(url, {
      method: method,
      credentials: 'same-origin',
      headers: body ? { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' } : {},
      body: body
    })
      .then(function (res) {
        return res.json().catch(function () {
          return { code: 500, msg: '响应解析失败', data: null };
        });
      })
      .then(function (json) {
        const code = json && json.code;
        const msg = (json && json.msg) || '请求失败';
        if (code === 200) {
          return json;
        }
        if (code === 401) {
          toLogin();
          return Promise.reject({ code: code, msg: msg });
        }
        message(msg);
        return Promise.reject({ code: code, msg: msg, data: json ? json.data : null });
      });
  }

  /**
   * 统一请求（业务快捷：仅返回 data 字段）。
   * @param {string} url
   * @param {object} params
   * @returns {Promise<any>} 返回 data 字段
   */
  function request(url, params, options) {
    return requestRaw(url, params, options).then(function (json) {
      return json.data;
    });
  }

  /* 构造表单体：空值剔除，对象/数组 JSON 序列化 */
  function buildBody(params, options) {
    if (!params) return null;
    const sp = new URLSearchParams();
    Object.keys(params).forEach(function (k) {
      let v = params[k];
      if (v === undefined || v === null) return;
      if (Array.isArray(v)) {
        // 数组：默认逗号拼接（后端 sort ids 用逗号分隔）；jsonArray=true 时序列化为 JSON
        v = options.jsonArray === true ? JSON.stringify(v) : v.join(',');
      } else if (typeof v === 'object') {
        // 普通对象一律序列化为 JSON，避免误走 join 抛错
        v = JSON.stringify(v);
      }
      sp.append(k, v);
    });
    const s = sp.toString();
    return s || null;
  }

  /* 列表请求：返回 { list, count } */
  function requestList(url, params, options) {
    return requestRaw(url, params, options).then(function (json) {
      return { list: json.data || [], count: json.count || 0 };
    });
  }

  /* ============ 各模块 API 分组 ============ */
  const api = {
    common: {
      login: function (username, password) {
        return request('/api/common/login', { username: username, password: password });
      },
      logout: function () {
        return request('/api/common/logout', {});
      },
      changePwd: function (oldPassword, newPassword) {
        return request('/api/common/change_pwd', { old_password: oldPassword, new_password: newPassword });
      }
    },
    site: {
      list: function (page, pageSize) {
        return requestList('/api/site/list', { page: page, page_size: pageSize });
      },
      info: function (id) {
        return request('/api/site/info', { id: id });
      },
      save: function (data) {
        return request('/api/site/save', data);
      },
      remove: function (id) {
        return request('/api/site/delete', { id: id });
      },
      uploadLogo: function (file) {
        // 上传站点Logo图片（multipart/form-data），返回 { url: '/upload/logo/xxx.png' }
        const fd = new FormData();
        fd.append('file', file);
        return fetch('/api/site/upload_logo', { method: 'POST', credentials: 'same-origin', body: fd })
          .then(function (res) { return res.json(); })
          .then(function (json) {
            if (json && json.code === 200) return json.data;
            if (json && json.code === 401) { toLogin(); return Promise.reject({ code: 401 }); }
            message((json && json.msg) || 'Logo上传失败');
            return Promise.reject({ code: json ? json.code : 500 });
          });
      },
      uploadCert: function (siteId, kind, file) {
        // 上传单个SSL证书/私钥PEM（kind=cert|key），后端写盘 web/upload/cert 并回填对应路径
        const fd = new FormData();
        fd.append('site_id', siteId);
        fd.append('kind', kind);
        fd.append('file', file);
        return fetch('/api/site/upload_cert', { method: 'POST', credentials: 'same-origin', body: fd })
          .then(function (res) { return res.json(); })
          .then(function (json) {
            if (json && json.code === 200) return json.data;
            if (json && json.code === 401) { toLogin(); return Promise.reject({ code: 401 }); }
            message((json && json.msg) || '证书上传失败');
            return Promise.reject({ code: json ? json.code : 500 });
          });
      }
    },
    whitelist: {
      list: function (page, pageSize, siteId) {
        return requestList('/api/whitelist/list', { page: page, page_size: pageSize, site_id: siteId || 0 });
      },
      info: function (id) {
        return request('/api/whitelist/info', { id: id });
      },
      save: function (data) {
        return request('/api/whitelist/save', data);
      },
      remove: function (id) {
        return request('/api/whitelist/delete', { id: id });
      },
      sort: function (ids) {
        return request('/api/whitelist/sort', { ids: ids.join(',') });
      }
    },
    crawlerIp: {
      list: function (page, pageSize, keyword, source, reason) {
        return requestList('/api/crawler_ip/list', { page: page, page_size: pageSize, keyword: keyword || '', source: source || '', reason: reason || '' });
      },
      info: function (id) {
        return request('/api/crawler_ip/info', { id: id });
      },
      stats: function () {
        return request('/api/crawler_ip/stats', {});
      },
      reportStatus: function () {
        return request('/api/crawler_ip/report_status', {});
      },
      save: function (data) {
        return request('/api/crawler_ip/save', data);
      },
      toggle: function (id, status) {
        return request('/api/crawler_ip/toggle', { id: id, status: status });
      },
      remove: function (id) {
        return request('/api/crawler_ip/delete', { id: id });
      }
    },
    cc: {
      list: function (page, pageSize, siteId) {
        return requestList('/api/cc/list', { page: page, page_size: pageSize, site_id: siteId || 0 });
      },
      info: function (id) {
        return request('/api/cc/info', { id: id });
      },
      save: function (data) {
        return request('/api/cc/save', data);
      },
      remove: function (id) {
        return request('/api/cc/delete', { id: id });
      },
      sort: function (ids) {
        return request('/api/cc/sort', { ids: ids.join(',') });
      }
    },
    ipGroup: {
      list: function (page, pageSize) {
        return requestList('/api/ip_group/list', { page: page, page_size: pageSize });
      },
      info: function (id) {
        return request('/api/ip_group/info', { id: id });
      },
      save: function (data) {
        return request('/api/ip_group/save', data);
      },
      remove: function (id) {
        return request('/api/ip_group/delete', { id: id });
      },
      checkRef: function (id) {
        return request('/api/ip_group/check_ref', { id: id });
      }
    },
    customRule: {
      list: function (page, pageSize, siteId) {
        return requestList('/api/custom_rule/list', { page: page, page_size: pageSize, site_id: siteId || 0 });
      },
      info: function (id) {
        return request('/api/custom_rule/info', { id: id });
      },
      save: function (data) {
        return request('/api/custom_rule/save', data);
      },
      remove: function (id) {
        return request('/api/custom_rule/delete', { id: id });
      },
      sort: function (ids) {
        return request('/api/custom_rule/sort', { ids: ids.join(',') });
      }
    },
    template: {
      list: function () {
        return request('/api/template/list', {});
      },
      save: function (id, content, name) {
        return request('/api/template/save', { id: id, content: content, name: name || '' });
      },
      /* 新建/删除自定义模板（Pro 独占接口，免费构建 404） */
      create: function (type, name) {
        return request('/api/template/create', { type: type, name: name });
      },
      remove: function (id) {
        return request('/api/template/delete', { id: id });
      }
    },
    credential: {
      config: function (siteId) {
        return request('/api/credential/config', { site_id: siteId || 0 });
      },
      save: function (data) {
        return request('/api/credential/save', data);
      }
    },
    credentialConfig: {
      get: function (siteId) {
        return request('/api/credential_config/get', { site_id: siteId || 0 });
      },
      save: function (data) {
        return request('/api/credential_config/save', data);
      }
    },
    challenge: {
      records: function (params) {
        return request('/api/challenge/records', params || {});
      }
    },
    analysis: {
      importDisk: function (startTime, endTime) {
        return request('/api/analysis/import_disk', { start_time: startTime, end_time: endTime });
      },
      upload: function (file) {
        // 上传原始日志文件（multipart/form-data）
        const fd = new FormData();
        fd.append('file', file);
        return fetch('/api/analysis/upload', { method: 'POST', credentials: 'same-origin', body: fd })
          .then(function (res) { return res.json(); })
          .then(function (json) {
            if (json && json.code === 200) return json.data;
            if (json && json.code === 401) { toLogin(); return Promise.reject({ code: 401 }); }
            message((json && json.msg) || '上传失败');
            return Promise.reject({ code: json ? json.code : 500 });
          });
      },
      batches: function (page, pageSize) {
        return requestList('/api/analysis/batches', { page: page, page_size: pageSize });
      },
      overview: function (batchId) {
        return request('/api/analysis/overview', { batch_id: batchId });
      },
      ipList: function (batchId, params) {
        return requestList('/api/analysis/ip_list', Object.assign({ batch_id: batchId, page: params.page || 1, page_size: params.pageSize || 20 }, params.filters || {}));
      },
      ipTop: function (batchId, limit) {
        return request('/api/analysis/top', { batch_id: batchId, limit: limit || 10 });
      },
      ipDetail: function (batchId, ip, page, pageSize) {
        return requestList('/api/analysis/ip_detail', { batch_id: batchId, ip: ip, page: page, page_size: pageSize });
      },
      deleteBatch: function (batchId) {
        return request('/api/analysis/delete_batch', { batch_id: batchId });
      }
    },
    attackLog: {
      list: function (params) {
        return requestList('/api/attack_log/list', params);
      },
      detail: function (id) {
        return request('/api/attack_log/detail', { id: id });
      },
      /* stats：params 传 site_id / start_time / end_time（datetimerange 口径） */
      stats: function (params) {
        return request('/api/attack_log/stats', params || {});
      },
      /* 流式导出 CSV，返回 Blob（后端按 attack_log_export_limit 限制行数） */
      export: function (params) {
        return fetch('/api/attack_log/export', {
          method: 'POST',
          credentials: 'same-origin',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
          body: buildBody(params)
        }).then(function (res) {
          const ct = res.headers.get('content-type') || '';
          if (!res.ok || ct.indexOf('json') >= 0) {
            return res.json().catch(() => ({})).then(function (j) {
              throw new Error((j && j.msg) || '导出失败');
            });
          }
          return res.blob();
        });
      }
    },
    accessStats: {
      stats: function (siteId, range) {
        return request('/api/access_stats/stats', { site_id: siteId || 0, range: range || '' });
      }
    },
    requestStats: {
      dim: function (siteId, range) {
        return request('/api/request_stats/dim', { site_id: siteId || 0, range: range || '' });
      },
      qps: function (siteId) {
          return request('/api/request_stats/qps', { site_id: siteId || 0 });
        },
        minute: function (siteId, range) {
          return request('/api/request_stats/minute', { site_id: siteId || 0, range: range || '' });
        }
    },
    waitingRoom: {
      list: function (params) {
        return requestList('/api/waiting_room/list', params);
      },
      stats: function () {
        return request('/api/waiting_room/stats', {});
      },
      bypass: function (queueId) {
        return request('/api/waiting_room/bypass', { queue_id: queueId });
      },
      cleanupNow: function () {
        return request('/api/waiting_room/cleanup_now', {});
      },
      cleanupStale: function () {
        return request('/api/waiting_room/cleanup_stale', {});
      }
    },
    auditLog: {
      list: function (params) {
        return requestList('/api/audit_log/list', params);
      },
      detail: function (id) {
        return request('/api/audit_log/detail', { id: id });
      }
    },
    engineLog: {
      list: function (params) {
        return requestList('/api/engine_log/list', params);
      },
      detail: function (id) {
        return request('/api/engine_log/detail', { id: id });
      }
    },
    license: {
      activate: function (code) {
        return request('/api/license/activate', { code: code });
      },
      status: function () {
        return request('/api/license/status', {});
      }
    },
    metrics: {
      get: function (params) {
        return request('/api/metrics/get', params || {});
      },
      defense: function (params) {
        return request('/api/metrics/defense', params || {});
      }
    },
    system: {
      info: function () {
        return request('/api/system/info', {});
      },
      config: function () {
        return request('/api/system/config', {});
      },
      save: function (data) {
        return request('/api/system/save', data);
      },
      cleanupNow: function () {
        return request('/api/system/cleanup_now', {});
      }
    }
  };

  App.api = api;
  App.request = request;
  App.requestList = requestList;
  App.to01 = to01;
  App.uiMessage = message;

  /* 版本与授权信息缓存：App.loadInfo() 启动时拉取一次 /api/system/info，
     各页经 App.info 读取（页脚品牌版本/edition 徽标、升级 Pro 入口、edition 显隐与配额提示） */
  App.info = null;
  App.loadInfo = function () {
    return api.system.info().then(function (info) {
      App.info = info || null;
      return App.info;
    }).catch(function () {
      return null;
    });
  };

  /* Vue3 插件：app.use(App) 后可通过 this.$api 访问 */
  App.install = function (app) {
    app.config.globalProperties.$api = api;
    app.config.globalProperties.$one = to01;
  };

  if (window.onApiError) {
    window.onApiError = null;
  }
  window.addEventListener('unhandledrejection', function (e) {
    // 已由 request 内 toast 处理的错误无需再处理
  });
})();