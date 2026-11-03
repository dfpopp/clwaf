/* ========================================
   主题配置管理
   功能：深浅色切换、主题色自定义、布局切换、状态持久化
   ======================================== */

const ThemeManager = (function () {
  const STORAGE_KEY = 'admin_theme_config';

  const defaultConfig = {
    theme: 'light',
    themeColor: '#409EFF',
    layout: 'vertical',
    sidebarCollapsed: false
  };

  let config = { ...defaultConfig };

  /* 预设主题色 */
  const presetColors = [
    { label: '默认蓝', value: '#409EFF' },
    { label: '成功绿', value: '#67C23A' },
    { label: '警告橙', value: '#E6A23C' },
    { label: '危险红', value: '#F56C6C' },
    { label: '信息灰', value: '#909399' }
  ];

  /* 从 localStorage 加载配置 */
  function loadConfig() {
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) {
        config = { ...defaultConfig, ...JSON.parse(saved) };
      }
    } catch (e) {
      config = { ...defaultConfig };
    }
  }

  /* 保存配置到 localStorage */
  function saveConfig() {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(config));
    } catch (e) {
      console.warn('主题配置保存失败');
    }
  }

  /* 应用主题到 DOM */
  function applyTheme() {
    const root = document.documentElement;
    root.setAttribute('data-theme', config.theme);
    applyThemeColor(config.themeColor);
    notifyIframe();
  }

  /* 解析颜色字符串（支持 hex 和 rgba 格式） */
  function parseColor(color) {
    if (typeof color !== 'string') return { r: 64, g: 158, b: 255 };
    color = color.trim();
    /* hex 格式: #RRGGBB */
    if (color.charAt(0) === '#') {
      return {
        r: parseInt(color.slice(1, 3), 16),
        g: parseInt(color.slice(3, 5), 16),
        b: parseInt(color.slice(5, 7), 16)
      };
    }
    /* rgba 格式: rgba(r, g, b, a) 或 rgb(r, g, b) */
    var match = color.match(/rgba?\(([^)]+)\)/);
    if (match) {
      var parts = match[1].split(',').map(function (s) { return parseFloat(s.trim()); });
      return { r: parts[0], g: parts[1], b: parts[2] };
    }
    return { r: 64, g: 158, b: 255 };
  }

  /* 计算主题色梯度 */
  function generateColorPalette(color) {
    var rgb = parseColor(color);
    var r = rgb.r, g = rgb.g, b = rgb.b;

    function mix(weight) {
      var nr = Math.round(r + (255 - r) * weight);
      var ng = Math.round(g + (255 - g) * weight);
      var nb = Math.round(b + (255 - b) * weight);
      return '#' + [nr, ng, nb].map(function (v) { return v.toString(16).padStart(2, '0'); }).join('');
    }

    function darken(weight) {
      var nr = Math.round(r * (1 - weight));
      var ng = Math.round(g * (1 - weight));
      var nb = Math.round(b * (1 - weight));
      return '#' + [nr, ng, nb].map(function (v) { return v.toString(16).padStart(2, '0'); }).join('');
    }

    return {
      light3: mix(0.3),
      light5: mix(0.5),
      light7: mix(0.7),
      light8: mix(0.8),
      light9: mix(0.9),
      dark2: darken(0.2)
    };
  }

  /* 应用主题色 */
  function applyThemeColor(color) {
    const root = document.documentElement;
    const palette = generateColorPalette(color);
    root.style.setProperty('--theme-color', color);
    root.style.setProperty('--theme-color-light-3', palette.light3);
    root.style.setProperty('--theme-color-light-5', palette.light5);
    root.style.setProperty('--theme-color-light-7', palette.light7);
    root.style.setProperty('--theme-color-light-8', palette.light8);
    root.style.setProperty('--theme-color-light-9', palette.light9);
    root.style.setProperty('--theme-color-dark-2', palette.dark2);
    root.style.setProperty('--el-color-primary', color);
    root.style.setProperty('--el-color-primary-light-3', palette.light3);
    root.style.setProperty('--el-color-primary-light-5', palette.light5);
    root.style.setProperty('--el-color-primary-light-7', palette.light7);
    root.style.setProperty('--el-color-primary-light-8', palette.light8);
    root.style.setProperty('--el-color-primary-light-9', palette.light9);
    root.style.setProperty('--el-color-primary-dark-2', palette.dark2);
  }

  /* 切换深浅色模式 */
  function toggleTheme() {
    config.theme = config.theme === 'light' ? 'dark' : 'light';
    saveConfig();
    applyTheme();
    return config.theme;
  }

  /* 设置主题色 */
  function setThemeColor(color) {
    config.themeColor = color;
    saveConfig();
    applyThemeColor(color);
    notifyIframe();
  }

  /* 切换布局模式 */
  function setLayout(layout) {
    config.layout = layout;
    saveConfig();
  }

  /* 切换侧边栏收缩状态 */
  function toggleSidebar() {
    config.sidebarCollapsed = !config.sidebarCollapsed;
    saveConfig();
    return config.sidebarCollapsed;
  }

  /* 获取当前配置 */
  function getConfig() {
    return { ...config };
  }

  /* 初始化 */
  function init() {
    loadConfig();
    applyTheme();
  }

  function isMobile() {
    return window.innerWidth <= 768;
  }

  function shouldCollapseSidebar() {
    return window.innerWidth <= 1400;
  }

  function setSidebarCollapsed(collapsed) {
    config.sidebarCollapsed = collapsed;
    saveConfig();
    return config.sidebarCollapsed;
  }

  /* 通知 iframe 子页面主题变化 */
  function notifyIframe() {
    try {
      const iframe = document.querySelector('#contentFrame') || document.querySelector('.content-frame');
      if (iframe && iframe.contentWindow) {
        const palette = generateColorPalette(config.themeColor);
        iframe.contentWindow.postMessage({
          action: 'theme_change',
          theme: config.theme,
          themeColor: config.themeColor,
          palette: palette
        }, '*');
      }
    } catch (e) {
      // 跨域忽略
    }
  }

  return {
    init,
    getConfig,
    toggleTheme,
    setThemeColor,
    setLayout,
    toggleSidebar,
    setSidebarCollapsed,
    isMobile,
    shouldCollapseSidebar,
    notifyIframe,
    presetColors,
    generateColorPalette
  };
})();
