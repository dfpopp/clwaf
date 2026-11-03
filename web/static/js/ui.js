/* ========================================
   WAF 管理员后台 UI 公共字典 & 格式化工具
   ======================================== */
(function () {
  const App = (window.App = window.App || {});

  /* 处置动作 */
  const ACTIONS = {
    block: '拦截',
    challenge: '人机验证',
    redirect: '302跳转',
    observe: '观察',
    waiting_room: '等候室排队',
    pass: '放行'
  };
  const ACTION_TAGS = {
    block: 'danger',
    challenge: 'warning',
    redirect: 'primary',
    observe: 'info',
    waiting_room: 'warning',
    pass: 'success'
  };

  /* 攻击类型。
   * 取值与引擎 block_reason / 挑战补记一一对应：
   *   custom_rule / cc / challenge / crawler_ip / sec_ch_ua / waiting_room_full。
   * 说明：js_challenge、api_challenge 落库前被收敛为 challenge（js/api 都是人机验证）；
   * 失败围栏入库、资源完整性失败等防御信号经 crawler_guard 入库后统一记为 crawler_ip；
   * sec_ch_ua（指纹头矛盾）为引擎历史直拦记录，展示为独立类型"指纹头矛盾"；
   * waiting_room 为历史旧键（引擎现写入 waiting_room_full），保留用于兼容历史数据。 */
  const ATTACK_TYPES = {
    custom_rule: '自定义规则',
    cc: 'CC攻击',
    challenge: '人机验证',
    waiting_room_full: '等候室：过载拦截',
    waiting_room: '等候室：过载拦截',
    crawler_ip: '爬虫IP拦截',
    sec_ch_ua: '指纹头矛盾',
    /* 内置攻击拦截 9 类（attack_type 落库为裸 category，与上面口径统一） */
    sql: '攻击：SQL注入',
    xss: '攻击：XSS跨站',
    lfi: '攻击：文件包含',
    cmdi: '攻击：命令注入',
    ssrf: '攻击：SSRF',
    ssti: '攻击：模板注入',
    deserial: '攻击：反序列化',
    infoleak: '攻击：信息泄露',
    shell: '攻击：WebShell',
    /* 协议层拦截 */
    uri_too_long: '协议层：URI超长'
  };
  const ATTACK_TAGS = {
    custom_rule: 'primary',
    cc: 'warning',
    challenge: 'danger',
    waiting_room_full: 'warning',
    waiting_room: 'warning',
    crawler_ip: 'danger',
    sec_ch_ua: 'danger',
    sql: 'danger',
    xss: 'danger',
    lfi: 'danger',
    cmdi: 'danger',
    ssrf: 'danger',
    ssti: 'danger',
    deserial: 'danger',
    infoleak: 'danger',
    shell: 'danger',
    uri_too_long: 'warning'
  };
  /* 页面自定义 tag 样式类（区别于上面的 ATTACK_TAGS/ACTION_TAGS：那两个是 Element Plus 的 type） */
  const ATTACK_TAG_CLASSES = {
    custom_rule: 'tag-custom',
    cc: 'tag-cc',
    challenge: 'tag-danger',
    waiting_room_full: 'tag-warning',
    waiting_room: 'tag-warning',
    crawler_ip: 'tag-danger',
    sec_ch_ua: 'tag-danger',
    sql: 'tag-danger',
    xss: 'tag-danger',
    lfi: 'tag-danger',
    cmdi: 'tag-danger',
    ssrf: 'tag-danger',
    ssti: 'tag-danger',
    deserial: 'tag-danger',
    infoleak: 'tag-danger',
    shell: 'tag-danger',
    uri_too_long: 'tag-warning'
  };
  /* 攻击类型 → 统一配色（权威色板，仪表盘/攻击日志页共用；新增类型只需加一处） */
  const ATTACK_COLORS = {
    custom_rule: '#2563eb',
    cc: '#9333ea',
    challenge: '#f59e0b',
    js_challenge: '#22d3ee',
    api_challenge: '#2dd4bf',
    waiting_room_full: '#0ea5e9',
    waiting_room: '#0ea5e9',
    crawler_ip: '#f43f5e',
    sec_ch_ua: '#fb7185',
    /* 内置攻击拦截 9 类 */
    sql: '#dc2626',
    xss: '#ea580c',
    lfi: '#a16207',
    cmdi: '#65a30d',
    ssrf: '#059669',
    ssti: '#14b8a6',
    deserial: '#6366f1',
    infoleak: '#64748b',
    shell: '#ec4899',
    uri_too_long: '#0891b2'
  };
  const ATTACK_COLOR_FALLBACK = '#94a3b8';

  /* 攻击类型展示别名：驼峰键为引擎历史写入值（2026-10-18 蛇形统一前落库），与蛇形键同义，归一展示；
     过渡期（历史数据滚出）结束后可移除 */
  function attackAlias(v) {
    switch (v) {
      case 'crawlerIp': return 'crawler_ip';
      case 'customRule': return 'custom_rule';
      case 'waitingRoom': return 'waiting_room_full';
    }
    return v;
  }
  const ACTION_TAG_CLASSES = {
    block: 'tag-act-block',
    challenge: 'tag-act-challenge',
    observe: 'tag-act-observe',
    waiting_room: 'tag-act-waiting_room',
    pass: 'tag-success'
  };

  /* 人机验证方式（注意两处取值风格不同：attack_log 用 silent_challenge，challenge_record 用 silent） */
  const CHALLENGE_TYPES = {
    silent: 'JS静默验证',
    silent_challenge: 'JS静默验证',
    slider: '滑块验证',
    captcha: '图形验证码',
    puzzle: '拼图验证'
  };
  /* 人机验证记录状态 */
  const CHALLENGE_STATUS = { pass: '通过', fail: '不通过', pending: '待验证' };
  const CHALLENGE_STATUS_CLASSES = { pass: 'status-pass', fail: 'status-fail', pending: 'status-pending' };
  const CHALLENGE_STATUS_ICONS = { pass: 'fa-circle-check', fail: 'fa-circle-xmark', pending: 'fa-clock' };

  /* 匹配目标（须与引擎 pkg/matcher getTargetValue 支持的目标一一对应，避免选了引擎不识别而静默失效） */
  const TARGETS = {
    ip: '源IP',
    uri: 'URI(含参数)',
    path: '路径(不含参数)',
    method: '请求方法',
    header: '请求头',
    cookie: 'Cookie',
    ua: 'User-Agent',
    referer: 'Referer',
    host: 'Host',
    query: '请求参数'
  };

  /* Pro 独占匹配目标（对齐 pkg/matcher/matcher_pro.go 注册表；免费版不展示，Pro 版带角标追加） */
  const TARGETS_PRO = {
    content_type: 'Content-Type',
    content_length: '内容长度',
    x_forwarded_for: 'X-Forwarded-For',
    body: '请求体',
    query_param: '查询参数'
  };

  /* 匹配算子 */
  const OPERATORS = {
    equal: '等于',
    not_equal: '不等于',
    contains: '包含',
    not_contains: '不包含',
    contains_i: '包含(忽略大小写)',
    regex: '正则匹配'
  };

  /* Pro 独占算子（对齐 pkg/matcher/matcher_pro.go 注册表；免费版不展示，Pro 版带角标追加）。
   * in/not_in 已从下拉移除（2026-10-21）：与等于/不等于的多值语义重复，前端统一用
   * 等于/不等于 + 标签输入；引擎保留 in/not_in 解析仅为兼容存量规则，新规则不再产生 */
  const OPERATORS_PRO = {
    exists: '存在',
    not_exists: '不存在',
    empty: '为空',
    len_equal: '长度等于',
    len_greater: '长度大于',
    len_less: '长度小于',
    prefix: '前缀匹配',
    suffix: '后缀匹配',
    val_greater: '数值大于',
    val_less: '数值小于'
  };

  /* 审计模块 */
  const AUDIT_MODULES = {
    site: '站点',
    whitelist: '白名单',
    cc: 'CC防护',
    ip_group: 'IP组',
    custom_rule: '自定义规则',
    cloud_rule: '平台规则',
    template: '模板',
    credential: '安全凭证',
    challenge: '人机验证',
    system: '系统设置',
    engine_log: '引擎日志',
    login: '登录'
  };

  /* 审计动作。
   * 由 app/admin/middleware/logger.go 从 API 路径 {module}/{action} 自动生成，
   * 字典需随新增接口同步补齐，避免表格显示英文原值。 */
  const AUDIT_ACTIONS = {
    create: '新增',
    update: '编辑',
    delete: '删除',
    import: '导入',
    sort: '排序',
    login: '登录',
    logout: '登出',
    switch: '切换',
    clean: '清理',
    save: '保存',
    import_disk: '磁盘导入',
    upload: '文件上传',
    cleanup_now: '立即清理',
    cleanup_stale: '清理残留',
    bypass: '临时放行',
    check_ref: '引用检查',
    toggle: '启停切换',
    sync: '同步',
    change_pwd: '修改密码'
  };

  /* 引擎日志级别 */
  const LOG_LEVELS = {
    info: '信息',
    warn: '警告',
    error: '错误',
    debug: '调试'
  };

  /* 通用：值→中文标签 */
  function lab(map, val, fallback) {
    if (val === undefined || val === null || val === '') return fallback || '-';
    return map[val] !== undefined ? map[val] : String(val);
  }

  /* 字典选项（供 el-select 使用） */
  function options(map, withEmpty) {
    const arr = Object.keys(map).map(function (k) {
      return { value: k, label: map[k] };
    });
    if (withEmpty) arr.unshift({ value: '', label: '全部' });
    return arr;
  }

  /* 基础字典 + Pro 独占字典合并：仅 Pro 构建（App.info.edition==='pro'）追加 Pro 项，
     免费版下拉不含 Pro 项（与 admin 保存校验、引擎免费构建不命中构成三层一致） */
  function withProOptions(base, pro, withEmpty) {
    const arr = options(base, withEmpty);
    if (App.info && App.info.edition === 'pro') {
      Object.keys(pro).forEach(function (k) {
        arr.push({ value: k, label: pro[k] + '（Pro）', pro: true });
      });
    }
    return arr;
  }

  /* 时间戳/时长格式化辅助 */
  function fmtTime(v) {
    if (!v) return '-';
    return String(v);
  }

  const U = {
    ACTIONS: ACTIONS,
    ACTION_TAGS: ACTION_TAGS,
    ATTACK_TYPES: ATTACK_TYPES,
    ATTACK_TAGS: ATTACK_TAGS,
    TARGETS: TARGETS,
    OPERATORS: OPERATORS,
    AUDIT_MODULES: AUDIT_MODULES,
    AUDIT_ACTIONS: AUDIT_ACTIONS,
    LOG_LEVELS: LOG_LEVELS,
    actionLabel: function (v) { return lab(ACTIONS, v); },
    actionTag: function (v) { return ACTION_TAGS[v] || 'info'; },
    attackLabel: function (v) { return lab(ATTACK_TYPES, attackAlias(v)); },
    attackTag: function (v) { return ATTACK_TAGS[attackAlias(v)] || 'info'; },
    targetLabel: function (v) { return lab(TARGETS, v) !== String(v) ? lab(TARGETS, v) : lab(TARGETS_PRO, v); },
    operatorLabel: function (v) { return lab(OPERATORS, v) !== String(v) ? lab(OPERATORS, v) : lab(OPERATORS_PRO, v); },
    auditModuleLabel: function (v) { return lab(AUDIT_MODULES, v, v); },
    auditActionLabel: function (v) { return lab(AUDIT_ACTIONS, v, v); },
    logLevel: function (v) { return lab(LOG_LEVELS, v, v); },
    /* 目标/算子下拉：免费版仅基础项；Pro 版追加 Pro 独占项并带（Pro）角标。
       依赖 App.info（/api/system/info）已加载——调用方在 loadInfo 完成后重新取值刷新下拉 */
    targetOptions: function (empty) { return withProOptions(TARGETS, TARGETS_PRO, empty); },
    operatorOptions: function (empty) { return withProOptions(OPERATORS, OPERATORS_PRO, empty); },
    actionOptions: function (empty) { return options(ACTIONS, empty); },
    attackOptions: function (empty) {
      const seen = {};
      const arr = [];
      Object.keys(ATTACK_TYPES).forEach(function (k) {
        if (k === 'sec_ch_ua') return; // 指纹头矛盾：10-13 起两级降级不拦截不入库、无新数据，筛选项与统计卡片移除；历史存量仅列表展示（标签映射保留）
        const label = ATTACK_TYPES[k];
        if (seen[label]) return; // 同名项合并：waiting_room 历史备份并入 waiting_room_full，下拉不出现两个"过载拦截"
        seen[label] = true;
        arr.push({ value: k, label: label });
      });
      if (empty) arr.unshift({ value: '', label: '全部' });
      return arr;
    },
    auditModuleOptions: function (empty) { return options(AUDIT_MODULES, empty); },
    auditActionOptions: function (empty) { return options(AUDIT_ACTIONS, empty); },

    /* ---- 攻击日志 / 人机验证记录页公用映射 ---- */
    /* 攻击类型 → 页面自定义 tag 类（区别于返回 EP type 的 attackTag） */
    attackTagClass: function (v) { return ATTACK_TAG_CLASSES[attackAlias(v)] || 'tag-other'; },
    /* 处置动作 → 页面自定义 tag 类 */
    actionTagClass: function (v) { return ACTION_TAG_CLASSES[v] || 'tag-other'; },
    /* 攻击类型 → 统一配色（权威色板 ATTACK_COLORS，未收录用兜底色） */
    attackColor: function (v) { return ATTACK_COLORS[attackAlias(v)] || ATTACK_COLOR_FALLBACK; },
    /* 验证方式中文（兼容 silent 与 silent_challenge 两种取值） */
    challengeTypeLabel: function (v) { return lab(CHALLENGE_TYPES, v); },
    /* 人机验证记录状态 */
    challengeStatusLabel: function (s) { return lab(CHALLENGE_STATUS, s); },
    challengeStatusClass: function (s) { return CHALLENGE_STATUS_CLASSES[s] || 'status-pending'; },
    challengeStatusIcon: function (s) { return CHALLENGE_STATUS_ICONS[s] || 'fa-clock'; },
    /* 站点名（sites 为站点列表，id=0 或空视作全局） */
    siteName: function (sites, id) {
      if (id === undefined || id === null || id === 0) return '全局';
      const s = (sites || []).find(function (x) { return String(x.id) === String(id); });
      return s ? s.name : id;
    },
    /* 挑战耗时：从 detail JSON 里取已知的时长字段 */
    challengeDuration: function (row) {
      try {
        const d = (row && typeof row.detail === 'string' && row.detail) ? JSON.parse(row.detail) : ((row && row.detail) || {});
        const keys = ['duration', 'cost', 'elapsed', 'time_cost', 'spend'];
        for (let i = 0; i < keys.length; i++) {
          const v = d[keys[i]];
          if (v !== undefined && v !== null && v !== '') return v + 's';
        }
      } catch (e) {}
      return '-';
    },

    /* CSV 导出 */
    downloadCsv: function (filename, headers, rows) {
      const esc = function (c) {
        if (c === null || c === undefined) return '';
        c = String(c);
        return '"' + c.replace(/"/g, '""') + '"';
      };
      let csv = headers.map(esc).join(',') + '\n';
      rows.forEach(function (r) {
        csv += r.map(esc).join(',') + '\n';
      });
      const blob = new Blob(['\uFEFF' + csv], { type: 'text/csv;charset=utf-8;' });
      const a = document.createElement('a');
      a.href = URL.createObjectURL(blob);
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(a.href);
    }
  };

  App.ui = U;
})();