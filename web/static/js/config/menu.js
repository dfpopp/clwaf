/* ========================================
   菜单配置（WAF 管理员后台）
   定义后台管理系统的菜单分组、路由映射、图标配置
   ======================================== */

const MenuConfig = (function () {
  /* 菜单数据：
     带 items 的为可折叠分组（一级菜单，点击展开子项）；
     不带 items 的为直达项（一级菜单，点击直接跳转）；
     edition: 'pro' 的项仅 Pro 构建渲染（index.html 按 /api/system/info 过滤，免费版隐藏） */
  const groups = [
    { id: 'dashboard', title: '仪表盘', icon: 'Odometer', path: 'dashboard.html' },
    { id: 'site', title: '站点管理', icon: 'Platform', path: 'site/index.html' },
    { id: 'waiting_room', title: '等候室', icon: 'Clock', path: 'waiting_room/list.html' },
    {
      id: 'protection',
      title: '防护规则',
      icon: 'Lock',
      items: [
        { id: 'whitelist', title: '白名单', icon: 'CircleCheck', path: 'whitelist/index.html' },
        { id: 'crawler_ip', title: '爬虫IP库', icon: 'Aim', path: 'crawler_ip/index.html' },
        { id: 'custom_rule', title: '自定义规则', icon: 'Document', path: 'custom_rule/index.html' },
        { id: 'challenge', title: '人机验证', icon: 'User', path: 'challenge/index.html' },
        { id: 'cc', title: 'CC防护', icon: 'Timer', path: 'cc/index.html' },
        { id: 'ip_group', title: 'IP组', icon: 'Collection', path: 'ip_group/index.html' }
      ]
    },
    {
      id: 'config',
      title: '系统配置',
      icon: 'Setting',
      items: [
        { id: 'credential', title: '安全凭证', icon: 'Key', path: 'credential/index.html' },
        { id: 'template', title: '拦截页面模板', icon: 'Files', path: 'template/index.html' },
        { id: 'license', title: '授权管理', icon: 'Stamp', path: 'license/index.html', edition: 'pro' },
        { id: 'system', title: '系统设置', icon: 'Setting', path: 'system/index.html' }
      ]
    },
    {
      id: 'logs',
      title: '日志审计',
      icon: 'Tickets',
      items: [
        { id: 'analysis', title: '日志分析', icon: 'DataAnalysis', path: 'analysis/index.html' },
        { id: 'metrics', title: '指标分析', icon: 'TrendCharts', path: 'metrics/index.html', edition: 'pro' },
        { id: 'defense', title: '防线运营', icon: 'Stopwatch', path: 'defense/index.html', edition: 'pro' },
        { id: 'attack_log', title: '攻击日志', icon: 'Warning', path: 'attack_log/index.html' },
        { id: 'audit_log', title: '审计日志', icon: 'Tickets', path: 'audit_log/index.html' },
        { id: 'engine_log', title: '引擎错误日志', icon: 'Notification', path: 'engine_log/index.html' }
      ]
    }
  ];

  /* 面包屑映射 */
  const breadcrumbMap = {
    'dashboard': ['仪表盘'],
    'site': ['站点管理'],
    'site_edit': ['站点管理'],
    'waiting_room': ['等候室'],
    'whitelist': ['防护规则', '白名单'],
    'crawler_ip': ['防护规则', '爬虫IP库'],
    'custom_rule': ['防护规则', '自定义规则'],
    'challenge': ['防护规则', '人机验证'],
    'cc': ['防护规则', 'CC防护'],
    'ip_group': ['防护规则', 'IP组'],
    'credential': ['系统配置', '安全凭证'],
    'template': ['系统配置', '拦截页面模板'],
    'license': ['系统配置', '授权管理'],
    'system': ['系统配置', '系统设置'],
    'analysis': ['日志审计', '日志分析'],
    'metrics': ['日志审计', '指标分析'],
    'defense': ['日志审计', '防线运营'],
    'attack_log': ['日志审计', '攻击日志'],
    'audit_log': ['日志审计', '审计日志'],
    'engine_log': ['日志审计', '引擎错误日志']
  };

  /* 获取当前页面ID（基于当前文件名） */
  function getCurrentPageId() {
    const path = window.location.pathname;
    let filename = path.substring(path.lastIndexOf('/') + 1).replace('.html', '');
    // edit.html 归为站点编辑
    if (filename === 'edit') return 'site_edit';
    return filename;
  }

  /* 获取面包屑 */
  function getBreadcrumb(pageId) {
    const id = pageId || getCurrentPageId();
    return breadcrumbMap[id] || ['未知页面'];
  }

  /* 根据菜单项ID找到对应菜单项（含直达项与分组内子项） */
  function findMenu(pageId) {
    const id = pageId || getCurrentPageId();
    for (const g of groups) {
      if (g.items) {
        const item = g.items.find(i => i.id === id);
        if (item) return item;
      } else if (g.id === id) {
        return g;
      }
    }
    return null;
  }

  /* 根据菜单项ID找到所属分组ID（直达项返回自身；子项返回其分组） */
  function getGroupId(pageId) {
    const id = pageId || getCurrentPageId();
    for (const g of groups) {
      if (g.items) {
        if (g.items.some(i => i.id === id)) return g.id;
      } else if (g.id === id) {
        return g.id;
      }
    }
    return null;
  }

  return {
    groups,
    breadcrumbMap,
    getCurrentPageId,
    getBreadcrumb,
    findMenu,
    getGroupId
  };
})();