/**
 * 全局重写fetch，自动添加X-Requested-With头
 * 使后端request()->isAjax()能正确识别fetch请求
 */
(function () {
  let originalFetch = window.fetch;
  window.fetch = function (input, init) {
    init = init || {};
    if (!init.headers) {
      init.headers = new Headers();
    }
    if (init.headers instanceof Headers) {
      if (!init.headers.has('X-Requested-With')) {
        init.headers.set('X-Requested-With', 'XMLHttpRequest');
      }
    } else if (Array.isArray(init.headers)) {
      let hasHeader = init.headers.some(function (h) { return h[0] === 'X-Requested-With'; });
      if (!hasHeader) {
        init.headers.push(['X-Requested-With', 'XMLHttpRequest']);
      }
    } else if (typeof init.headers === 'object') {
      if (!init.headers['X-Requested-With']) {
        init.headers['X-Requested-With'] = 'XMLHttpRequest';
      }
    }
    return originalFetch.call(this, input, init).then(function (response) {
      if (response.status === 401) {
        let loginUrl = response.headers.get('Login-Url');
        if (loginUrl) {
          window.top.location.href = loginUrl;
        } else {
          window.top.location.href = '/admin/login/index';
        }
        return Promise.reject(new Error('未登录，正在跳转登录页'));
      }
      return response;
    });
  };
})();

/**
 * 跨iframe弹窗通信工具
 * 子页面通过此工具与父页面（index.html）通信，实现弹窗的打开、关闭和列表刷新
 */
let DialogBridge = {
  /* 打开弹窗 */
  open: function (options) {
    window.parent.postMessage({
      action: 'creat_dialog',
      id: options.id || ('dlg_' + Date.now()),
      title: options.title || '弹窗',
      url: options.url,
      width: options.width || '600px',
      height: options.height || '400px',
      fullscreen: options.fullscreen || false
    }, '*');
  },

  /* 关闭弹窗 */
  close: function (options) {
    window.parent.postMessage({
      action: 'close_dialog',
      id: options.id,
      msg: options.msg || '',
      refresh: options.refresh !== false,
      parent_dialog_id: options.parent_dialog_id || null
    }, '*');
  },

  /* 确认弹窗（由父页面弹出ElMessageBox.confirm） */
  confirm: function (options) {
    window.parent.postMessage({
      action: 'confirm',
      title: options.title || '确认',
      content: options.content || '确定执行此操作吗？',
      operat: options.operat,
      ids: options.ids
    }, '*');
  }
};

/**
 * 子页面列表刷新注册
 * 子页面在mounted时调用此方法，将onSearch方法暴露给父页面
 * 父页面关闭弹窗后可通过 iframe.contentWindow.onSearch() 刷新列表
 */
function registerListRefresh(onSearchFn) {
  window.onSearch = onSearchFn;
}

/**
 * 权限判断函数
 * 在视图层调用，判断当前管理员是否拥有指定权限
 * 超级管理员直接返回true
 *
 * @param {string} controller 控制器名，如 'Admin'
 * @param {string} action 方法名，如 'add'
 * @returns {boolean} 有权限返回true，无权限返回false
 *
 * 使用示例：
 *   v-if="hasPerm('Admin', 'add')"
 *   v-if="hasPerm('Role', 'delete')"
 */
function hasPerm(controller, action) {
  if (window.__IS_SUPER__ === 1) {
    return true;
  }
  let key = controller + '/' + action;
  let perms = window.__ADMIN_PERMISSIONS__ || [];
  return perms.indexOf(key) !== -1;
}

/**
 * 主题色变更监听（来自主框架页的 postMessage）
 * 子页面（iframe 内）接收主框架页发送的主题色变化并应用
 */
(function () {
  var STORAGE_KEY = 'admin_theme_config';

  function applyThemeConfig(data) {
    var root = document.documentElement;
    // 深浅色模式
    root.setAttribute('data-theme', data.theme || 'light');
    // 主题色及其梯度
    if (data.themeColor) {
      root.style.setProperty('--theme-color', data.themeColor);
      root.style.setProperty('--el-color-primary', data.themeColor);
    }
    if (data.palette) {
      root.style.setProperty('--theme-color-light-3', data.palette.light3);
      root.style.setProperty('--theme-color-light-5', data.palette.light5);
      root.style.setProperty('--theme-color-light-7', data.palette.light7);
      root.style.setProperty('--theme-color-light-8', data.palette.light8);
      root.style.setProperty('--theme-color-light-9', data.palette.light9);
      root.style.setProperty('--theme-color-dark-2', data.palette.dark2);
      root.style.setProperty('--el-color-primary-light-3', data.palette.light3);
      root.style.setProperty('--el-color-primary-light-5', data.palette.light5);
      root.style.setProperty('--el-color-primary-light-7', data.palette.light7);
      root.style.setProperty('--el-color-primary-light-8', data.palette.light8);
      root.style.setProperty('--el-color-primary-light-9', data.palette.light9);
      root.style.setProperty('--el-color-primary-dark-2', data.palette.dark2);
    }
  }

  // 初始化：从 localStorage 读取主题配置
  try {
    var saved = localStorage.getItem(STORAGE_KEY);
    if (saved) {
      var config = JSON.parse(saved);
      applyThemeConfig({
        theme: config.theme || 'light',
        themeColor: config.themeColor || '#409EFF'
      });
    }
  } catch (e) {}

  // 监听主框架页的主题变更通知
  window.addEventListener('message', function (e) {
    if (!e.data || e.data.action !== 'theme_change') return;
    applyThemeConfig(e.data);
  });
})();
