/* 由 tools/gen-default-templates.js 从 sql/init.sql waf_template 种子行生成，勿手改；重生成：node tools/gen-default-templates.js */
const DEFAULT_TEMPLATES = {
  block: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>访问被拦截</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.box{max-width:400px;width:100%;text-align:center}
.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
h1{font-size:20px;margin-bottom:10px;font-weight:700}
.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}
.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}
.msg.ok{color:#4ade80}
.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}
.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}
.row:last-child{border-bottom:0}
.row .k{color:#5c6b7d}
.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}
.tip{font-size:12px;color:#5c6b7d}
.tip code{font-family:Consolas,monospace;color:#8b98a9}
.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}
.box{max-width:480px;width:100%}.info{margin-top:4px}</style>
</head>
<body>
<div class="box">
  {{if not .LogoURL}}<div class="icon" style="background:rgba(239,68,68,0.12)"><svg viewBox="0 0 24 24" width="38" height="38" fill="none" stroke="#ef4444" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></div>{{end}}
  {{if .LogoURL}}<div class="logo"><img src="{{.LogoURL}}" alt="logo"></div>{{end}}
  <h1>访问已被拦截</h1>
  <p class="desc">您的请求被网站防护系统拦截，如有疑问请联系站点管理员。</p>
  <div class="info">
    <div class="row"><span class="k">站点名称</span><span class="v">{{.SiteName}}</span></div>
    <div class="row"><span class="k">拦截原因</span><span class="v">{{.Reason}}</span></div>
    <div class="row"><span class="k">客户端IP</span><span class="v">{{.ClientIP}}</span></div>
    <div class="row"><span class="k">拦截时间</span><span class="v">{{.Time}}</span></div>
  </div>
  <div class="tip" style="text-align:center">请求编号：{{.RequestID}}</div>
</div>
<script>
(function(){
var P=(window.__WAF_PREVIEW__===1)||(/[?&]preview=1/.test(window.location.search));
var C=window.__c||'';
var LIVE=(!P)&&!!C&&(C.indexOf('{')<0);
var K='waf#2026$collect';
function ep(n){return '/waf-cha'+'llenge/'+n;}
function post(n,kv,ok,fail){
  var q=[];
  for(var k in kv){q.push(encodeURIComponent(k)+'='+encodeURIComponent(kv[k]));}
  var x=new XMLHttpRequest();
  x.open('POST',ep(n),true);
  x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
  x.onreadystatechange=function(){
    if(x.readyState!==4)return;
    var j=null;try{j=JSON.parse(x.responseText);}catch(e){}
    if(x.status>=200&&x.status<400&&j){if(ok)ok(j);}else{if(fail)fail();}
  };
  x.send(q.join('&'));
}
function b64x(s){
  var u=unescape(encodeURIComponent(s)),o='';
  for(var i=0;i<u.length;i++){o+=String.fromCharCode(u.charCodeAt(i)^K.charCodeAt(i%K.length));}
  return btoa(o);
}
function chash(){
  try{
    var cv=document.createElement('canvas');cv.width=220;cv.height=40;
    var g=cv.getContext('2d');
    g.textBaseline='top';g.font='15px Arial';g.fillStyle='#f60';g.fillRect(0,0,110,20);
    g.fillStyle='#069';g.fillText('WAF~#\\u4e2d\\u6587@258',2,2);
    g.fillStyle='rgba(102,204,0,0.7)';g.fillText('WAF~#\\u4e2d\\u6587@258',4,17);
    var d=cv.toDataURL(),h=0;
    for(var i=0;i<d.length;i++){h=(h*31+d.charCodeAt(i))|0;}
    return (h>>>0).toString(16);
  }catch(e){return '';}
}
function wgl(){
  try{
    var cv=document.createElement('canvas');
    var gl=cv.getContext('webgl')||cv.getContext('experimental-webgl');
    if(!gl)return ['',''];
    var di=gl.getExtension('WEBGL_debug_renderer_info');
    return di?[gl.getParameter(di.UNMASKED_VENDOR_WEBGL),gl.getParameter(di.UNMASKED_RENDERER_WEBGL)]:[gl.getParameter(gl.VENDOR),gl.getParameter(gl.RENDERER)];
  }catch(e){return ['',''];}
}
function collect(){
  var w=wgl(),n=navigator;
  return{ua:n.userAgent,lg:n.language,ls:(n.languages||[]).join(','),pl:n.platform,
    hc:n.hardwareConcurrency||0,dm:n.deviceMemory||0,wd:n.webdriver===true?1:0,
    sw:screen.width,sh:screen.height,cd:screen.colorDepth,dpr:window.devicePixelRatio||1,
    tz:(window.Intl&&Intl.DateTimeFormat().resolvedOptions().timeZone)||'',tp:n.maxTouchPoints||0,
    ce:n.cookieEnabled?1:0,pn:(n.plugins||[]).length,ch:window.chrome?1:0,
    hd:/HeadlessChrome/i.test(n.userAgent)?1:0,ph:(window.callPhantom||window._phantom)?1:0,
    sl:(window.__nightmare||window.domAutomation||window.domAutomationController)?1:0,
    np:(window.Notification&&Notification.permission)||'',gv:w[0],gr:w[1],cv:chash(),ts:Date.now()};
}
function report(){
  if(!LIVE)return;
  var q=['cid='+encodeURIComponent(C),'d='+encodeURIComponent(b64x(JSON.stringify(collect())))];
  try{
    var x=new XMLHttpRequest();
    x.open('POST','/waf-co'+'llect',true);
    x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    x.send(q.join('&'));
  }catch(e){}
}
function guard(){
  if(P)return;
  window.addEventListener('keydown',function(e){
    var k=e.key;
    if(k==='F12'||k===123||(e.ctrlKey&&e.shiftKey&&(k==='I'||k==='J'||k==='C'))){e.preventDefault();e.stopPropagation();return false;}
  },true);
  window.addEventListener('contextmenu',function(e){e.preventDefault();return false;});
  var win=window;
  if(window.top!==window&&window.parent&&window.parent.outerWidth)win=window.parent;
  var hits=0,dead=false;
  function kill(){
    if(dead)return;dead=true;
    try{document.body.innerHTML='';}catch(e){}
    (function st(){requestAnimationFrame(function(){debugger;requestAnimationFrame(st);});})();
  }
  setInterval(function(){
    var ow=win.outerWidth,iw=win.innerWidth,oh=win.outerHeight,ih=win.innerHeight;
    if(ow-iw>50||oh-ih>135){hits++;if(hits>=2)kill();}else{hits=0;}
  },500);
}
function demo(){
  var m={'{{.SiteName}}':'官网主站','{{.RequestID}}':'Req-20260818-001234','{{.Reason}}':'SQL注入特征匹配','{{.ClientIP}}':'203.0.113.45','{{.Time}}':'2026-08-18 14:30:00','{{.Position}}':'12','{{.FrontCount}}':'8'};
  try{
    var w=document.createTreeWalker(document.body,4,null,false);
    while(w.nextNode()){
      var t=w.currentNode,v=t.nodeValue;
      if(v&&v.indexOf('{'+'{')>-1)t.nodeValue=v.replace(/\\{\\{\\.\\w+\\}\\}/g,function(x){return m[x]||x;});
    }
  }catch(e){}
}
guard();demo();try{report();}catch(e){}
START(LIVE,C,P,post);
});
function START(LIVE,C,P,post){}
</script>
</body>
</html>`,
  silent_challenge: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<script>(function(){var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement('canvas').getContext('2d');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(ok)return;try{var x=new XMLHttpRequest();x.open('POST','/{{.WafUrlPrefix}}/challenge/legacy?rid={{.RequestID}}',true);x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');x.onreadystatechange=function(){if(x.readyState!==4)return;try{var j=JSON.parse(x.responseText);if(j&&j.code===200){if(j.action==='ie_captcha'){location.reload();return;}if(j.url&&j.url.charAt(0)==='/'&&j.url.charAt(1)!=='/')location.replace(j.url);}}catch(e){}};x.send('back='+encodeURIComponent(location.pathname+location.search));}catch(e){}})();</script>
<title>安全验证</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.box{max-width:400px;width:100%;text-align:center}
.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
h1{font-size:20px;margin-bottom:10px;font-weight:700}
.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}
.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}
.msg.ok{color:#4ade80}
.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}
.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}
.row:last-child{border-bottom:0}
.row .k{color:#5c6b7d}
.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}
.tip{font-size:12px;color:#5c6b7d}
.tip code{font-family:Consolas,monospace;color:#8b98a9}
.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}
.box{max-width:360px}
.spin{width:56px;height:56px;margin:0 auto 18px;border:3px solid rgba(251,191,36,0.15);border-top-color:#fbbf24;border-radius:50%;animation:rot 1s linear infinite}
@keyframes rot{to{transform:rotate(360deg)}}
.okmark{display:none;width:56px;height:56px;margin:0 auto 18px;border-radius:50%;background:rgba(34,197,94,0.15);align-items:center;justify-content:center}
</style>
</head>
<body>
<div class="box">
  <div class="spin" id="spin"></div>
  <div class="okmark" id="okMark"><svg viewBox="0 0 24 24" width="30" height="30" fill="none" stroke="#4ade80" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg></div>
  {{if .LogoURL}}<div class="logo"><img src="{{.LogoURL}}" alt="logo"></div>{{end}}
  <h1 id="title">正在安全验证</h1>
  <p class="desc" id="desc">请稍候，系统正在验证您的浏览器环境...</p>
  <!-- 加载缓慢提示：老设备/网络差时资源加载慢一直被转圈，易被误当成"WAF挂了"。满6秒仍未完成验证就亮出该卡片。
       主题自适应：改下方 --sh-* 三个变量即可适配浅色/深色模板（琥珀色强调在明暗背景下均清晰）。
       仅改显示，不影响主验证流程；验证通过 $ok() 会把 #spin 隐藏，此卡片不会出现。#slowHint 默认隐藏。 -->
  <style>
  .slowhint{--sh-bg:rgba(251,191,36,.08);--sh-hi:#fbbf24;--sh-ln:rgba(251,191,36,.4);display:none;align-items:flex-start;gap:10px;text-align:left;margin:0 0 16px;padding:12px 14px 12px 11px;background:var(--sh-bg);border:1px solid var(--sh-ln);border-left:3px solid var(--sh-hi);border-radius:8px;animation:shp 1.6s ease-in-out infinite}
  .slowhint.on{display:flex}
  @keyframes shp{0%,100%{border-color:var(--sh-ln);box-shadow:0 0 0 0 rgba(251,191,36,0)}50%{border-color:var(--sh-hi);box-shadow:0 0 0 3px rgba(251,191,36,.14)}}
  .slowhint-ic{flex:0 0 auto;width:20px;height:20px;margin-top:1px;border-radius:50%;background:var(--sh-hi);color:#1b2128;font-weight:700;font-size:13px;display:flex;align-items:center;justify-content:center}
  .slowhint-t{font-weight:600;font-size:13px;color:inherit;margin-bottom:2px}
  .slowhint-d{font-size:12px;color:inherit;opacity:.75;line-height:1.6}
  </style>
  <div class="slowhint" id="slowHint">
    <span class="slowhint-ic">!</span>
    <div>
      <div class="slowhint-t">检测到加载缓慢</div>
      <div class="slowhint-d">当前网络较差或设备 CPU、内存占用较高，导致验证资源加载缓慢。若长时间无法通过，请手动刷新页面后再试。</div>
    </div>
  </div>
  <script>
  (function(){try{var s=document.getElementById('spin'),h=document.getElementById('slowHint');if(!s||!h)return;window.setTimeout(function(){try{if(getComputedStyle(s).display==='none')return;h.className='slowhint on';}catch(e){}},6000);}catch(e){}})();
  </script>
  <div class="info">
    <div class="row"><span class="k">站点名称</span><span class="v">{{.SiteName}}</span></div>
    <div class="row"><span class="k">触发时间</span><span class="v">{{.Time}}</span></div>
  </div>
  <div class="tip">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>
</div>
<script>
window.__APP = {
  a: '{{.RequestID}}',
  b: '{{.Nonce}}',
  p: { h:'{{.PoWChallenge}}', b:{{.PoWDifficulty}} },
  u: '{{.WafUrlPrefix}}',
};
</script>
<script>
(function () {
  var app = window.__APP;
  var q='?reqID='+encodeURIComponent((app&&app.a)||'')+'&v='+Math.floor(Math.random()*99999);
  var s=document.createElement('script');
  s.src='/'+(app&&app.u||'waf')+'/assets/tongji/1.js'+q;
  document.head.appendChild(s);
})();
</script>
</body>
</html>`,
  slider: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<script>(function(){var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement('canvas').getContext('2d');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(ok)return;try{var x=new XMLHttpRequest();x.open('POST','/{{.WafUrlPrefix}}/challenge/legacy?rid={{.RequestID}}',true);x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');x.onreadystatechange=function(){if(x.readyState!==4)return;try{var j=JSON.parse(x.responseText);if(j&&j.code===200){if(j.action==='ie_captcha'){location.reload();return;}if(j.url&&j.url.charAt(0)==='/'&&j.url.charAt(1)!=='/')location.replace(j.url);}}catch(e){}};x.send('back='+encodeURIComponent(location.pathname+location.search));}catch(e){}})();</script>
<title>人机验证</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.box{max-width:400px;width:100%;text-align:center}
.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
h1{font-size:20px;margin-bottom:10px;font-weight:700}
.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}
.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}
.msg.ok{color:#4ade80}
.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}
.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}
.row:last-child{border-bottom:0}
.row .k{color:#5c6b7d}
.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}
.tip{font-size:12px;color:#5c6b7d}
.tip code{font-family:Consolas,monospace;color:#8b98a9}
.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}
.slider-box{width:100%;height:48px;background:#1e293b;border:1px solid #334155;border-radius:24px;position:relative;overflow:hidden;margin-bottom:6px;touch-action:none;user-select:none;-webkit-user-select:none}
.slider-track{position:absolute;left:0;top:0;height:100%;background:linear-gradient(90deg,rgba(139,92,246,0.2),rgba(139,92,246,0.4));border-radius:24px;width:0}
.slider-track.ok{background:linear-gradient(90deg,rgba(34,197,94,0.3),rgba(34,197,94,0.55))}
.slider-btn{position:absolute;top:4px;left:4px;width:40px;height:40px;background:linear-gradient(135deg,#8b5cf6,#6d28d9);border-radius:50%;display:flex;align-items:center;justify-content:center;cursor:grab;color:#fff}
.slider-btn:active{cursor:grabbing}
.slider-btn.ok{background:linear-gradient(135deg,#22c55e,#16a34a)}
.slider-text{position:absolute;left:0;top:0;width:100%;height:100%;display:flex;align-items:center;justify-content:center;font-size:12px;color:#64748b;pointer-events:none}
</style>
</head>
<body>
<div class="box">
  {{if not .LogoURL}}<div class="icon" id="iconBox" style="background:rgba(139,92,246,0.12)"><svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="#8b5cf6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="18 8 22 12 18 16"/><polyline points="6 8 2 12 6 16"/><line x1="2" y1="12" x2="22" y2="12"/></svg></div>{{end}}
  {{if .LogoURL}}<div class="logo"><img src="{{.LogoURL}}" alt="logo"></div>{{end}}
  <h1>请完成验证</h1>
  <p class="desc">拖动滑块完成验证，确认您是正常用户。</p>
  <div class="slider-box" id="slBox">
    <div class="slider-track" id="slTrack"></div>
    <div class="slider-text" id="slText">拖动滑块验证</div>
    <div class="slider-btn" id="slBtn"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="18 8 22 12 18 16"/><polyline points="6 8 2 12 6 16"/><line x1="2" y1="12" x2="22" y2="12"/></svg></div>
  </div>
  <div class="msg" id="msg"></div>
  <div class="info">
    <div class="row"><span class="k">站点名称</span><span class="v">{{.SiteName}}</span></div>
    <div class="row"><span class="k">触发时间</span><span class="v">{{.Time}}</span></div>
  </div>
  <div class="tip">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>
</div>
<script>
window.__APP = {
  a: '{{.RequestID}}',
  b: '{{.Nonce}}',
  p: { h:'{{.PoWChallenge}}', b:{{.PoWDifficulty}} },
  u: '{{.WafUrlPrefix}}',
};
</script>
<script>
(function () {
  var app = window.__APP;
  var q='?reqID='+encodeURIComponent((app&&app.a)||'')+'&v='+Math.floor(Math.random()*99999);
  var s=document.createElement('script');
  s.src='/'+(app&&app.u||'waf')+'/assets/tongji/2.js'+q;
  document.head.appendChild(s);
})();
</script>
</body>
</html>`,
  captcha: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<script>(function(){var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement('canvas').getContext('2d');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(ok)return;try{var x=new XMLHttpRequest();x.open('POST','/{{.WafUrlPrefix}}/challenge/legacy?rid={{.RequestID}}',true);x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');x.onreadystatechange=function(){if(x.readyState!==4)return;try{var j=JSON.parse(x.responseText);if(j&&j.code===200){if(j.action==='ie_captcha'){location.reload();return;}if(j.url&&j.url.charAt(0)==='/'&&j.url.charAt(1)!=='/')location.replace(j.url);}}catch(e){}};x.send('back='+encodeURIComponent(location.pathname+location.search));}catch(e){}})();</script>
<title>人机验证</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.box{max-width:400px;width:100%;text-align:center}
.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
h1{font-size:20px;margin-bottom:10px;font-weight:700}
.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}
.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}
.msg.ok{color:#4ade80}
.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}
.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}
.row:last-child{border-bottom:0}
.row .k{color:#5c6b7d}
.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}
.tip{font-size:12px;color:#5c6b7d}
.tip code{font-family:Consolas,monospace;color:#8b98a9}
.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}
.captcha-box{width:100%;background:#1e293b;border:1px solid #334155;border-radius:10px;padding:16px;margin-bottom:14px}
.code-img{width:160px;height:52px;margin:0 auto 12px;display:block;cursor:pointer}
.code-img img{width:100%;height:100%;border-radius:6px;object-fit:cover;display:block;border:1px solid #334155}
.captcha-input-row{display:flex;gap:8px}
.form-input{flex:1;background:#0f172a;border:1px solid #334155;border-radius:8px;color:#e6edf3;font-size:15px;letter-spacing:4px;text-align:center;padding:10px;outline:none;font-family:inherit}
.form-input:focus{border-color:#22c55e}
.form-input.err{border-color:#ef4444;animation:shake .4s}
@keyframes shake{0%,100%{transform:translateX(0)}25%{transform:translateX(-6px)}75%{transform:translateX(6px)}}
.captcha-refresh{width:44px;height:44px;flex-shrink:0;background:#1e293b;border:1px solid #334155;border-radius:8px;color:#8b98a9;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .15s}
.captcha-refresh:hover{color:#4ade80;border-color:#22c55e}
.captcha-refresh.busy svg{animation:spin .8s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}
.ver-btn{width:100%;background:linear-gradient(135deg,#22c55e,#16a34a);color:#fff;border:0;padding:12px;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer;transition:opacity .2s;font-family:inherit;display:flex;align-items:center;justify-content:center;gap:6px}
.ver-btn:hover{opacity:.9}
.ver-btn:disabled{opacity:.6;cursor:not-allowed}
.ver-btn.ok{background:linear-gradient(135deg,#16a34a,#15803d)}
</style>
</head>
<body>
<div class="box">
  {{if not .LogoURL}}<div class="icon" id="iconBox" style="background:rgba(34,197,94,0.12)"><svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="#22c55e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg></div>{{end}}
  {{if .LogoURL}}<div class="logo"><img src="{{.LogoURL}}" alt="logo"></div>{{end}}
  <h1>请完成验证</h1>
  <p class="desc">请输入图形中的字符，确认您是正常用户。</p>
  <div class="captcha-box">
    <div class="code-img" id="capImgWrap" title="点击刷新"><img id="capImg" alt="captcha"></div>
    <div class="captcha-input-row">
      <input type="text" class="form-input" id="codeInput" placeholder="请输入验证码" maxlength="4" autocomplete="off" autocapitalize="off">
      <button class="captcha-refresh" id="refreshBtn" title="换一张" type="button"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg></button>
    </div>
  </div>
  <button class="ver-btn" id="verifyBtn" type="button"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg> 验证</button>
  <div class="msg" id="msg"></div>
  <div class="info">
    <div class="row"><span class="k">站点名称</span><span class="v">{{.SiteName}}</span></div>
    <div class="row"><span class="k">触发时间</span><span class="v">{{.Time}}</span></div>
  </div>
  <div class="tip">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>
</div>

<script>
window.__APP = {
  a: '{{.RequestID}}',
  b: '{{.Nonce}}',
  p: { h:'{{.PoWChallenge}}', b:{{.PoWDifficulty}} },
  u: '{{.WafUrlPrefix}}'
};
</script>
<script>
(function () {
  var app = window.__APP;
  var q='?reqID='+encodeURIComponent((app&&app.a)||'')+'&v='+Math.floor(Math.random()*99999);
  var s=document.createElement('script');
  s.src='/'+(app&&app.u||'waf')+'/assets/tongji/4.js'+q;
  document.head.appendChild(s);
})();
</script>
</body>
</html>`,
  puzzle: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<script>(function(){var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement('canvas').getContext('2d');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(ok)return;try{var x=new XMLHttpRequest();x.open('POST','/{{.WafUrlPrefix}}/challenge/legacy?rid={{.RequestID}}',true);x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');x.onreadystatechange=function(){if(x.readyState!==4)return;try{var j=JSON.parse(x.responseText);if(j&&j.code===200){if(j.action==='ie_captcha'){location.reload();return;}if(j.url&&j.url.charAt(0)==='/'&&j.url.charAt(1)!=='/')location.replace(j.url);}}catch(e){}};x.send('back='+encodeURIComponent(location.pathname+location.search));}catch(e){}})();</script>
<title>人机验证</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.box{max-width:400px;width:100%;text-align:center}
.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
h1{font-size:20px;margin-bottom:10px;font-weight:700}
.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}
.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}
.msg.ok{color:#4ade80}
.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}
.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}
.row:last-child{border-bottom:0}
.row .k{color:#5c6b7d}
.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}
.tip{font-size:12px;color:#5c6b7d}
.tip code{font-family:Consolas,monospace;color:#8b98a9}
.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}
/* 拼图几何与引擎一致：底图364x204、拼图块44x44、缺口Y=78（固定）。拼块图为引擎裁出的独立44x44图，居中显示无需偏移 */
.puzz-panel{position:relative;width:364px;height:204px;margin:0 auto 14px;border:1px solid #334155;border-radius:8px;overflow:hidden;background:#0f172a;touch-action:none;user-select:none;-webkit-user-select:none}
.puzz-bg{position:absolute;left:0;top:0;width:364px;height:204px;pointer-events:none}
.puzz-piece{position:absolute;left:0;top:78px;width:44px;height:44px;background-repeat:no-repeat;background-position:center;background-size:100% 100%;box-shadow:0 2px 10px rgba(0,0,0,0.5);pointer-events:none}
.puzz-piece.ok{outline:2px solid #22c55e;outline-offset:-2px}
.slider-box{width:100%;height:48px;background:#1e293b;border:1px solid #334155;border-radius:24px;position:relative;overflow:hidden;margin-bottom:6px;touch-action:none;user-select:none;-webkit-user-select:none}
.slider-track{position:absolute;left:0;top:0;height:100%;background:linear-gradient(90deg,rgba(139,92,246,0.2),rgba(139,92,246,0.4));border-radius:24px;width:0}
.slider-track.ok{background:linear-gradient(90deg,rgba(34,197,94,0.3),rgba(34,197,94,0.55))}
.slider-btn{position:absolute;top:4px;left:4px;width:40px;height:40px;background:linear-gradient(135deg,#8b5cf6,#6d28d9);border-radius:50%;display:flex;align-items:center;justify-content:center;cursor:grab;color:#fff}
.slider-btn:active{cursor:grabbing}
.slider-btn.ok{background:linear-gradient(135deg,#22c55e,#16a34a)}
.slider-text{position:absolute;left:0;top:0;width:100%;height:100%;display:flex;align-items:center;justify-content:center;font-size:12px;color:#64748b;pointer-events:none}
</style>
</head>
<body>
<div class="box">
  {{if not .LogoURL}}<div class="icon" id="iconBox" style="background:rgba(139,92,246,0.12)"><svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="#8b5cf6" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="18 8 22 12 18 16"/><polyline points="6 8 2 12 6 16"/><line x1="2" y1="12" x2="22" y2="12"/></svg></div>{{end}}
  {{if .LogoURL}}<div class="logo"><img src="{{.LogoURL}}" alt="logo"></div>{{end}}
  <h1>请完成验证</h1>
  <p class="desc">拖动下方滑块，将拼图块对准缺口位置，完成验证。</p>
  <div class="puzz-panel" id="panel">
    <img class="puzz-bg" id="bg" alt="puzzle">
    <div class="puzz-piece" id="piece"></div>
  </div>
  <div class="slider-box" id="slBox">
    <div class="slider-track" id="slTrack"></div>
    <div class="slider-text" id="slText">拖动滑块，对准缺口</div>
    <div class="slider-btn" id="slBtn"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="18 8 22 12 18 16"/><polyline points="6 8 2 12 6 16"/><line x1="2" y1="12" x2="22" y2="12"/></svg></div>
  </div>
  <div class="msg" id="msg"></div>
  <div class="info">
    <div class="row"><span class="k">站点名称</span><span class="v">{{.SiteName}}</span></div>
    <div class="row"><span class="k">触发时间</span><span class="v">{{.Time}}</span></div>
  </div>
  <div class="tip">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>
</div>

<script>
window.__APP = {
  a: '{{.RequestID}}',
  b: '{{.Nonce}}',
  p: { h:'{{.PoWChallenge}}', b:{{.PoWDifficulty}} },
  u: '{{.WafUrlPrefix}}'
};
</script>
<script>
(function () {
  var app = window.__APP;
  var q='?reqID='+encodeURIComponent((app&&app.a)||'')+'&v='+Math.floor(Math.random()*99999);
  var s=document.createElement('script');
  s.src='/'+(app&&app.u||'waf')+'/assets/tongji/3.js'+q;
  document.head.appendChild(s);
})();
</script>
</body>
</html>`,
  waiting_room: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>排队等候</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.box{max-width:400px;width:100%;text-align:center}
.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
h1{font-size:20px;margin-bottom:10px;font-weight:700}
.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}
.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}
.msg.ok{color:#4ade80}
.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}
.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}
.row:last-child{border-bottom:0}
.row .k{color:#5c6b7d}
.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}
.tip{font-size:12px;color:#5c6b7d}
.tip code{font-family:Consolas,monospace;color:#8b98a9}
.logo{text-align:center;margin-bottom:16px}
.logo img{max-width:120px;max-height:48px;border-radius:4px}
.box{max-width:400px}
.queue-card{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:12px;padding:22px 18px;margin-bottom:16px}
.queue-pos{font-size:44px;font-weight:700;color:#60a5fa;line-height:1.1;margin-bottom:4px}
.queue-sub{font-size:12px;color:#8b98a9;margin-bottom:16px}
.qbar{height:6px;background:#1e293b;border-radius:3px;overflow:hidden}
.qbar i{display:block;height:100%;background:linear-gradient(90deg,#3b82f6,#60a5fa);border-radius:3px;transition:width .6s}
.qrow{display:flex;justify-content:space-between;font-size:12px;color:#5c6b7d;margin-top:10px}
</style>
</head>
<body>
<div class="box">
  {{if not .LogoURL}}<div class="icon" style="background:rgba(96,165,250,0.12)"><svg viewBox="0 0 24 24" width="28" height="28" fill="none" stroke="#60a5fa" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></div>{{end}}
  {{if .LogoURL}}<div class="logo"><img src="{{.LogoURL}}" alt="logo"></div>{{end}}
  <h1>排队等候中</h1>
  <p class="desc">当前访问人数较多，您已进入等候室，页面将自动刷新。</p>
  <div class="queue-card">
    <div class="queue-pos" id="queuePos">{{.Position}}</div>
    <div class="queue-sub">您的排队序号</div>
    <div class="qbar"><i style="width:35%"></i></div>
    <div class="qrow"><span>前方 <b id="queueFront">{{.FrontCount}}</b> 人</span><span>预计稍候</span></div>
  </div>
  <div class="info">
    <div class="row"><span class="k">站点名称</span><span class="v">{{.SiteName}}</span></div>
    <div class="row"><span class="k">触发时间</span><span class="v">{{.Time}}</span></div>
  </div>
  <div class="tip">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>
</div>
<script>window.__q='{{.QueueID}}';</script>
<script>
(function(){
var P=(window.__WAF_PREVIEW__===1)||(/[?&]preview=1/.test(window.location.search));
var C=window.__c||'';
var LIVE=(!P)&&!!C&&(C.indexOf('{')<0);
var K='waf#2026$collect';
function ep(n){return '/'+'{{.WafUrlPrefix}}'+'/challenge/'+n;}
function post(n,kv,ok,fail){
  var q=[];
  for(var k in kv){q.push(encodeURIComponent(k)+'='+encodeURIComponent(kv[k]));}
  var x=new XMLHttpRequest();
  x.open('POST',ep(n),true);
  x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
  x.onreadystatechange=function(){
    if(x.readyState!==4)return;
    var j=null;try{j=JSON.parse(x.responseText);}catch(e){}
    if(x.status>=200&&x.status<400&&j){if(ok)ok(j);}else{if(fail)fail();}
  };
  x.send(q.join('&'));
}
function b64x(s){
  var u=unescape(encodeURIComponent(s)),o='';
  for(var i=0;i<u.length;i++){o+=String.fromCharCode(u.charCodeAt(i)^K.charCodeAt(i%K.length));}
  return btoa(o);
}
function chash(){
  try{
    var cv=document.createElement('canvas');cv.width=220;cv.height=40;
    var g=cv.getContext('2d');
    g.textBaseline='top';g.font='15px Arial';g.fillStyle='#f60';g.fillRect(0,0,110,20);
    g.fillStyle='#069';g.fillText('WAF~#u4e2du6587@258',2,2);
    g.fillStyle='rgba(102,204,0,0.7)';g.fillText('WAF~#u4e2du6587@258',4,17);
    var d=cv.toDataURL(),h=0;
    for(var i=0;i<d.length;i++){h=(h*31+d.charCodeAt(i))|0;}
    return (h>>>0).toString(16);
  }catch(e){return '';}
}
function wgl(){
  try{
    var cv=document.createElement('canvas');
    var gl=cv.getContext('webgl')||cv.getContext('experimental-webgl');
    if(!gl)return ['',''];
    var di=gl.getExtension('WEBGL_debug_renderer_info');
    return di?[gl.getParameter(di.UNMASKED_VENDOR_WEBGL),gl.getParameter(di.UNMASKED_RENDERER_WEBGL)]:[gl.getParameter(gl.VENDOR),gl.getParameter(gl.RENDERER)];
  }catch(e){return ['','']}
}
function collect(){
  var w=wgl(),n=navigator;
  return{ua:n.userAgent,lg:n.language,ls:(n.languages||[]).join(','),pl:n.platform,hc:n.hardwareConcurrency||0,dm:n.deviceMemory||0,wd:n.webdriver===true?1:0,sw:screen.width,sh:screen.height,cd:screen.colorDepth,dpr:window.devicePixelRatio||1,tz:(window.Intl&&Intl.DateTimeFormat().resolvedOptions().timeZone)||'',tp:n.maxTouchPoints||0,ce:n.cookieEnabled?1:0,pn:(n.plugins||[]).length,ch:window.chrome?1:0,hd:/HeadlessChrome/i.test(n.userAgent)?1:0,ph:(window.callPhantom||window._phantom)?1:0,sl:(window.__nightmare||window.domAutomation||window.domAutomationController)?1:0,np:(window.Notification&&Notification.permission)||'',gv:w[0],gr:w[1],cv:chash(),ts:Date.now()};
}
function report(){
  if(!LIVE)return;
  var q=['cid='+encodeURIComponent(C),'d='+encodeURIComponent(b64x(JSON.stringify(collect())))];
  try{
    var x=new XMLHttpRequest();
    x.open('POST','/'+'{{.WafUrlPrefix}}'+'/collect',true);
    x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    x.send(q.join('&'));
  }catch(e){}
}
function guard(){
  if(P)return;
  window.addEventListener('keydown',function(e){
    var k=e.key;
    if(k==='F12'||k===123||(e.ctrlKey&&e.shiftKey&&(k==='I'||k==='J'||k==='C'))){e.preventDefault();e.stopPropagation();return false;}
  },true);
  window.addEventListener('contextmenu',function(e){e.preventDefault();return false;});
  var win=window;
  if(window.top!==window&&window.parent&&window.parent.outerWidth)win=window.parent;
  var hits=0,dead=false;
  function kill(){
    if(dead)return;dead=true;
    try{document.body.innerHTML='';}catch(e){}
    (function st(){requestAnimationFrame(function(){debugger;requestAnimationFrame(st);});})();
  }
  setInterval(function(){
    var ow=win.outerWidth,iw=win.innerWidth,oh=win.outerHeight,ih=win.innerHeight;
    if(ow-iw>50||oh-ih>135){hits++;if(hits>=2)kill();}else{hits=0;}
  },500);
}
function demo(){
  var m={'{{.SiteName}}':'官网主站','{{.RequestID}}':'Req-20260818-001234','{{.Reason}}':'SQL注入特征匹配','{{.ClientIP}}':'203.0.113.45','{{.Time}}':'2026-08-18 14:30:00','{{.Position}}':'12','{{.FrontCount}}':'8'};
  try{
    var w=document.createTreeWalker(document.body,4,null,false);
    while(w.nextNode()){
      var t=w.currentNode,v=t.nodeValue;
      if(v&&v.indexOf('{'+ '{')>-1)t.nodeValue=v.replace(/\\{\\{\\.\\w+\\}\\}/g,function(x){return m[x]||x;});
    }
  }catch(e){}
}
guard();demo();try{report();}catch(e){}
START(LIVE,C,P,post);
})();
function START(LIVE,C,P,post){
  var q=window.__q;
  if(!q)return;
  var pos=document.getElementById('queuePos'),front=document.getElementById('queueFront');
  function poll(){
    var xhr=new XMLHttpRequest();
    xhr.open('GET','/'+'{{.WafUrlPrefix}}'+'/waiting/status?queue_id='+encodeURIComponent(q),true);
    xhr.onload=function(){
      if(xhr.status!==200){setTimeout(poll,1000);return;}
      var j;
      try{j=JSON.parse(xhr.responseText);}catch(e){setTimeout(poll,1000);return;}
      if(j&&j.code===200&&j.ready){window.location.reload();return;}
      if(j&&typeof j.position==='number'){
        if(pos)pos.textContent=j.position;
        if(front)front.textContent=j.position;
      }
      setTimeout(poll,1000);
    };
    xhr.onerror=function(){setTimeout(poll,1000);};
    xhr.send();
  }
  setTimeout(poll,500);
}
</script>
</body>
</html>`,
  overload: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>服务繁忙</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.box{max-width:400px;width:100%;text-align:center}
.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
h1{font-size:20px;margin-bottom:10px;font-weight:700}
.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}
.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}
.msg.ok{color:#4ade80}
.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}
.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}
.row:last-child{border-bottom:0}
.row .k{color:#5c6b7d}
.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}
.tip{font-size:12px;color:#5c6b7d}
.tip code{font-family:Consolas,monospace;color:#8b98a9}
.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}
</style>
</head>
<body>
<div class="box" style="max-width:480px">
  {{if not .LogoURL}}<div class="icon" style="width:84px;height:84px;background:rgba(251,191,36,0.12)"><svg viewBox="0 0 24 24" width="38" height="38" fill="none" stroke="#fbbf24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg></div>{{end}}
  {{if .LogoURL}}<div class="logo"><img src="{{.LogoURL}}" alt="logo"></div>{{end}}
  <h1 style="font-size:22px">服务繁忙，请稍后再试</h1>
  <p class="desc">当前排队人数已达上限，您暂时无法进入等候室。<br>请稍后重新访问，给您带来不便敬请谅解。</p>
  <div class="info">
<div class="row"><span class="k">站点名称</span><span class="v">{{.SiteName}}</span></div>
    <div class="row"><span class="k">触发时间</span><span class="v">{{.Time}}</span></div>
    <div class="row"><span class="k">客户端IP</span><span class="v">{{.ClientIP}}</span></div>
  </div>
  <div class="tip" style="text-align:center">请求编号：{{.RequestID}}</div>
</div>
<script>
(function(){
var P=(window.__WAF_PREVIEW__===1)||(/[?&]preview=1/.test(window.location.search));
var C=window.__c||'';
var LIVE=(!P)&&!!C&&(C.indexOf('{')<0);
var K='waf#2026$collect';
function ep(n){return '/waf-cha'+'llenge/'+n;}
function post(n,kv,ok,fail){
  var q=[];
  for(var k in kv){q.push(encodeURIComponent(k)+'='+encodeURIComponent(kv[k]));}
  var x=new XMLHttpRequest();
  x.open('POST',ep(n),true);
  x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
  x.onreadystatechange=function(){
    if(x.readyState!==4)return;
    var j=null;try{j=JSON.parse(x.responseText);}catch(e){}
    if(x.status>=200&&x.status<400&&j){if(ok)ok(j);}else{if(fail)fail();}
  };
  x.send(q.join('&'));
}
function b64x(s){
  var u=unescape(encodeURIComponent(s)),o='';
  for(var i=0;i<u.length;i++){o+=String.fromCharCode(u.charCodeAt(i)^K.charCodeAt(i%K.length));}
  return btoa(o);
}
function chash(){
  try{
    var cv=document.createElement('canvas');cv.width=220;cv.height=40;
    var g=cv.getContext('2d');
    g.textBaseline='top';g.font='15px Arial';g.fillStyle='#f60';g.fillRect(0,0,110,20);
    g.fillStyle='#069';g.fillText('WAF~#\\u4e2d\\u6587@258',2,2);
    g.fillStyle='rgba(102,204,0,0.7)';g.fillText('WAF~#\\u4e2d\\u6587@258',4,17);
    var d=cv.toDataURL(),h=0;
    for(var i=0;i<d.length;i++){h=(h*31+d.charCodeAt(i))|0;}
    return (h>>>0).toString(16);
  }catch(e){return '';}
}
function wgl(){
  try{
    var cv=document.createElement('canvas');
    var gl=cv.getContext('webgl')||cv.getContext('experimental-webgl');
    if(!gl)return ['',''];
    var di=gl.getExtension('WEBGL_debug_renderer_info');
    return di?[gl.getParameter(di.UNMASKED_VENDOR_WEBGL),gl.getParameter(di.UNMASKED_RENDERER_WEBGL)]:[gl.getParameter(gl.VENDOR),gl.getParameter(gl.RENDERER)];
  }catch(e){return ['',''];}
}
function collect(){
  var w=wgl(),n=navigator;
  return{ua:n.userAgent,lg:n.language,ls:(n.languages||[]).join(','),pl:n.platform,
    hc:n.hardwareConcurrency||0,dm:n.deviceMemory||0,wd:n.webdriver===true?1:0,
    sw:screen.width,sh:screen.height,cd:screen.colorDepth,dpr:window.devicePixelRatio||1,
    tz:(window.Intl&&Intl.DateTimeFormat().resolvedOptions().timeZone)||'',tp:n.maxTouchPoints||0,
    ce:n.cookieEnabled?1:0,pn:(n.plugins||[]).length,ch:window.chrome?1:0,
    hd:/HeadlessChrome/i.test(n.userAgent)?1:0,ph:(window.callPhantom||window._phantom)?1:0,
    sl:(window.__nightmare||window.domAutomation||window.domAutomationController)?1:0,
    np:(window.Notification&&Notification.permission)||'',gv:w[0],gr:w[1],cv:chash(),ts:Date.now()};
}
function report(){
  if(!LIVE)return;
  var q=['cid='+encodeURIComponent(C),'d='+encodeURIComponent(b64x(JSON.stringify(collect())))];
  try{
    var x=new XMLHttpRequest();
    x.open('POST','/waf-co'+'llect',true);
    x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    x.send(q.join('&'));
  }catch(e){}
}
function guard(){
  if(P)return;
  window.addEventListener('keydown',function(e){
    var k=e.key;
    if(k==='F12'||k===123||(e.ctrlKey&&e.shiftKey&&(k==='I'||k==='J'||k==='C'))){e.preventDefault();e.stopPropagation();return false;}
  },true);
  window.addEventListener('contextmenu',function(e){e.preventDefault();return false;});
  var win=window;
  if(window.top!==window&&window.parent&&window.parent.outerWidth)win=window.parent;
  var hits=0,dead=false;
  function kill(){
    if(dead)return;dead=true;
    try{document.body.innerHTML='';}catch(e){}
    (function st(){requestAnimationFrame(function(){debugger;requestAnimationFrame(st);});})();
  }
  setInterval(function(){
    var ow=win.outerWidth,iw=win.innerWidth,oh=win.outerHeight,ih=win.innerHeight;
    if(ow-iw>50||oh-ih>135){hits++;if(hits>=2)kill();}else{hits=0;}
  },500);
}
function demo(){
  var m={'{{.SiteName}}':'官网主站','{{.RequestID}}':'Req-20260818-001234','{{.Reason}}':'SQL注入特征匹配','{{.ClientIP}}':'203.0.113.45','{{.Time}}':'2026-08-18 14:30:00','{{.Position}}':'12','{{.FrontCount}}':'8'};
  try{
    var w=document.createTreeWalker(document.body,4,null,false);
    while(w.nextNode()){
      var t=w.currentNode,v=t.nodeValue;
      if(v&&v.indexOf('{'+'{')>-1)t.nodeValue=v.replace(/\\{\\{\\.\\w+\\}\\}/g,function(x){return m[x]||x;});
    }
  }catch(e){}
}
guard();demo();try{report();}catch(e){}
START(LIVE,C,P,post);
});
function START(LIVE,C,P,post){}
</script>
</body>
</html>`,
  ie_captcha: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<script>(function(){if(window.__WAF_PREVIEW__)return;var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement('canvas').getContext('2d');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(!ok)return;location.replace('/');})();</script>
<title>人机验证</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html{background:#0d1218}
body{font-family:-apple-system,"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.box{max-width:400px;width:100%;text-align:center}
.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
h1{font-size:20px;margin-bottom:10px;font-weight:700}
.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}
.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}
.msg.ok{color:#4ade80}
.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}
.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}
.row:last-child{border-bottom:0}
.row .k{color:#5c6b7d}
.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}
.tip{font-size:12px;color:#5c6b7d}
.tip code{font-family:Consolas,monospace;color:#8b98a9}
.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}
.captcha-box{width:100%;background:#1e293b;border:1px solid #334155;border-radius:10px;padding:16px;margin-bottom:14px}
.code-img{width:160px;height:52px;margin:0 auto 12px;display:block;cursor:pointer}
.code-img img{width:100%;height:100%;border-radius:6px;border:1px solid #334155}
.captcha-input-row{display:flex}
.form-input{flex:1;background:#0f172a;border:1px solid #334155;border-radius:8px;color:#e6edf3;font-size:15px;letter-spacing:4px;text-align:center;padding:10px;outline:none;font-family:inherit}
.form-input:focus{border-color:#22c55e}
.form-input.err{border-color:#ef4444}
.captcha-refresh{width:44px;height:44px;flex-shrink:0;margin-left:8px;background:#1e293b;border:1px solid #334155;border-radius:8px;color:#8b98a9;cursor:pointer}
.ver-btn{width:100%;background:linear-gradient(135deg,#22c55e,#16a34a);color:#fff;border:0;padding:12px;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer;font-family:inherit}
.ver-btn:disabled{opacity:.6}
.ver-btn svg{margin-right:6px;vertical-align:middle}
</style>
</head>
<body>
<div class="box">
  {{if not .LogoURL}}<div class="icon" id="iconBox" style="background:rgba(34,197,94,0.12)"><svg viewBox="0 0 24 24" width="26" height="26" fill="none" stroke="#22c55e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg></div>{{end}}
  {{if .LogoURL}}<div class="logo"><img src="{{.LogoURL}}" alt="logo"></div>{{end}}
  <h1>请完成验证</h1>
  <p class="desc">请输入图形中的字符，确认您是正常用户。</p>
  <div class="captcha-box">
    <div class="code-img" id="capImgWrap" title="点击刷新"><img id="capImg" alt="captcha"></div>
    <div class="captcha-input-row">
      <input type="text" class="form-input" id="codeInput" placeholder="请输入验证码" maxlength="4" autocomplete="off">
      <button class="captcha-refresh" id="refreshBtn" title="换一张" type="button"><svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></svg></button>
    </div>
  </div>
  <button class="ver-btn" id="verifyBtn" type="button"><svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>验证</button>
  <div class="msg" id="msg"></div>
  <div class="info">
    <div class="row"><span class="k">站点名称</span><span class="v">{{.SiteName}}</span></div>
    <div class="row"><span class="k">触发时间</span><span class="v">{{.Time}}</span></div>
  </div>
  <div class="tip">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>
</div>

<script>
window.__APP = {
  a: '{{.RequestID}}',
  b: '{{.Nonce}}',
  p: { h:'{{.PoWChallenge}}', b:{{.PoWDifficulty}} },
  u: '{{.WafUrlPrefix}}'
};
</script>
<script>
(function () {
  var app = window.__APP;
  var q='?reqID='+encodeURIComponent((app&&app.a)||'')+'&v='+Math.floor(Math.random()*99999);
  var s=document.createElement('script');
  s.src='/'+(app&&app.u||'waf')+'/assets/tongji/ie.js'+q;
  document.head.appendChild(s);
})();
</script>
</body>
</html>`,
  server_error: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>源站不可用</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:-apple-system,"Segoe UI","PingFang SC","Microsoft YaHei",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.box{max-width:400px;width:100%;text-align:center}
.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}
h1{font-size:20px;margin-bottom:10px;font-weight:700}
.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}
.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}
.msg.ok{color:#4ade80}
.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}
.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}
.row:last-child{border-bottom:0}
.row .k{color:#5c6b7d}
.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}
.tip{font-size:12px;color:#5c6b7d}
.tip code{font-family:Consolas,monospace;color:#8b98a9}
.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}
</style>
</head>
<body>
<div class="box" style="max-width:480px">
  {{if not .LogoURL}}<div class="icon" style="width:84px;height:84px;background:rgba(34,211,238,0.12)"><svg viewBox="0 0 24 24" width="38" height="38" fill="none" stroke="#22d3ee" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="8" rx="2" ry="2"/><rect x="2" y="14" width="20" height="8" rx="2" ry="2"/><line x1="6" y1="6" x2="6.01" y2="6"/><line x1="6" y1="18" x2="6.01" y2="18"/></svg></div>{{end}}
  {{if .LogoURL}}<div class="logo"><img src="{{.LogoURL}}" alt="logo"></div>{{end}}
  <h1 style="font-size:22px">源站暂时不可用</h1>
  <p class="desc">防护系统无法连接到源站服务器，可能是源站维护或异常。<br>请稍后重试，或联系站点管理员。</p>
  <div class="info">
<div class="row"><span class="k">站点名称</span><span class="v">{{.SiteName}}</span></div>
    <div class="row"><span class="k">触发时间</span><span class="v">{{.Time}}</span></div>
    <div class="row"><span class="k">客户端IP</span><span class="v">{{.ClientIP}}</span></div>
  </div>
  <div class="tip" style="text-align:center">请求编号：{{.RequestID}}</div>
</div>
<script>
(function(){
var P=(window.__WAF_PREVIEW__===1)||(/[?&]preview=1/.test(window.location.search));
var C=window.__c||'';
var LIVE=(!P)&&!!C&&(C.indexOf('{')<0);
var K='waf#2026$collect';
function ep(n){return '/waf-cha'+'llenge/'+n;}
function post(n,kv,ok,fail){
  var q=[];
  for(var k in kv){q.push(encodeURIComponent(k)+'='+encodeURIComponent(kv[k]));}
  var x=new XMLHttpRequest();
  x.open('POST',ep(n),true);
  x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
  x.onreadystatechange=function(){
    if(x.readyState!==4)return;
    var j=null;try{j=JSON.parse(x.responseText);}catch(e){}
    if(x.status>=200&&x.status<400&&j){if(ok)ok(j);}else{if(fail)fail();}
  };
  x.send(q.join('&'));
}
function b64x(s){
  var u=unescape(encodeURIComponent(s)),o='';
  for(var i=0;i<u.length;i++){o+=String.fromCharCode(u.charCodeAt(i)^K.charCodeAt(i%K.length));}
  return btoa(o);
}
function chash(){
  try{
    var cv=document.createElement('canvas');cv.width=220;cv.height=40;
    var g=cv.getContext('2d');
    g.textBaseline='top';g.font='15px Arial';g.fillStyle='#f60';g.fillRect(0,0,110,20);
    g.fillStyle='#069';g.fillText('WAF~#\\u4e2d\\u6587@258',2,2);
    g.fillStyle='rgba(102,204,0,0.7)';g.fillText('WAF~#\\u4e2d\\u6587@258',4,17);
    var d=cv.toDataURL(),h=0;
    for(var i=0;i<d.length;i++){h=(h*31+d.charCodeAt(i))|0;}
    return (h>>>0).toString(16);
  }catch(e){return '';}
}
function wgl(){
  try{
    var cv=document.createElement('canvas');
    var gl=cv.getContext('webgl')||cv.getContext('experimental-webgl');
    if(!gl)return ['',''];
    var di=gl.getExtension('WEBGL_debug_renderer_info');
    return di?[gl.getParameter(di.UNMASKED_VENDOR_WEBGL),gl.getParameter(di.UNMASKED_RENDERER_WEBGL)]:[gl.getParameter(gl.VENDOR),gl.getParameter(gl.RENDERER)];
  }catch(e){return ['',''];}
}
function collect(){
  var w=wgl(),n=navigator;
  return{ua:n.userAgent,lg:n.language,ls:(n.languages||[]).join(','),pl:n.platform,
    hc:n.hardwareConcurrency||0,dm:n.deviceMemory||0,wd:n.webdriver===true?1:0,
    sw:screen.width,sh:screen.height,cd:screen.colorDepth,dpr:window.devicePixelRatio||1,
    tz:(window.Intl&&Intl.DateTimeFormat().resolvedOptions().timeZone)||'',tp:n.maxTouchPoints||0,
    ce:n.cookieEnabled?1:0,pn:(n.plugins||[]).length,ch:window.chrome?1:0,
    hd:/HeadlessChrome/i.test(n.userAgent)?1:0,ph:(window.callPhantom||window._phantom)?1:0,
    sl:(window.__nightmare||window.domAutomation||window.domAutomationController)?1:0,
    np:(window.Notification&&Notification.permission)||'',gv:w[0],gr:w[1],cv:chash(),ts:Date.now()};
}
function report(){
  if(!LIVE)return;
  var q=['cid='+encodeURIComponent(C),'d='+encodeURIComponent(b64x(JSON.stringify(collect())))];
  try{
    var x=new XMLHttpRequest();
    x.open('POST','/waf-co'+'llect',true);
    x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');
    x.send(q.join('&'));
  }catch(e){}
}
function guard(){
  if(P)return;
  window.addEventListener('keydown',function(e){
    var k=e.key;
    if(k==='F12'||k===123||(e.ctrlKey&&e.shiftKey&&(k==='I'||k==='J'||k==='C'))){e.preventDefault();e.stopPropagation();return false;}
  },true);
  window.addEventListener('contextmenu',function(e){e.preventDefault();return false;});
  var win=window;
  if(window.top!==window&&window.parent&&window.parent.outerWidth)win=window.parent;
  var hits=0,dead=false;
  function kill(){
    if(dead)return;dead=true;
    try{document.body.innerHTML='';}catch(e){}
    (function st(){requestAnimationFrame(function(){debugger;requestAnimationFrame(st);});})();
  }
  setInterval(function(){
    var ow=win.outerWidth,iw=win.innerWidth,oh=win.outerHeight,ih=win.innerHeight;
    if(ow-iw>50||oh-ih>135){hits++;if(hits>=2)kill();}else{hits=0;}
  },500);
}
function demo(){
  var m={'{{.SiteName}}':'官网主站','{{.RequestID}}':'Req-20260818-001234','{{.Reason}}':'SQL注入特征匹配','{{.ClientIP}}':'203.0.113.45','{{.Time}}':'2026-08-18 14:30:00','{{.Position}}':'12','{{.FrontCount}}':'8'};
  try{
    var w=document.createTreeWalker(document.body,4,null,false);
    while(w.nextNode()){
      var t=w.currentNode,v=t.nodeValue;
      if(v&&v.indexOf('{'+'{')>-1)t.nodeValue=v.replace(/\\{\\{\\.\\w+\\}\\}/g,function(x){return m[x]||x;});
    }
  }catch(e){}
}
guard();demo();try{report();}catch(e){}
START(LIVE,C,P,post);
});
function START(LIVE,C,P,post){}
</script>
</body>
</html>`,
  browser_guide: `<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="renderer" content="webkit">
<meta name="force-rendering" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>浏览器版本过旧</title>
<style>
body{margin:0;padding:0;background:#f5f7fa;font-family:"Microsoft YaHei","PingFang SC",Arial,sans-serif;text-align:center;}
.wrap{max-width:560px;margin:0 auto;padding:40px 16px 48px;}
.logo{margin-bottom:20px;min-height:10px;}
.logo img{max-height:56px;max-width:180px;}
.notice{background:#e0342b;border:2px solid #b8271f;color:#ffffff;font-size:18px;font-weight:bold;line-height:1.7;padding:14px 16px;margin-bottom:20px;}
.notice .big{font-size:20px;}
.card{background:#ffffff;border:1px solid #dfe5ec;padding:28px 24px;}
.ico{width:56px;height:56px;line-height:56px;margin:0 auto 16px;background:#fff3e0;border:1px solid #f0a020;color:#e07800;font-size:34px;font-weight:bold;}
h1{font-size:20px;color:#333333;margin:0 0 12px;font-weight:normal;}
p{font-size:14px;color:#666666;margin:0 0 10px;line-height:1.8;}
.how{margin:18px 0 4px;padding:14px 16px;background:#fffbe6;border:1px solid #f0c040;text-align:left;}
.howtitle{font-size:16px;color:#a05a00;font-weight:bold;margin:0 0 10px;text-align:center;}
.eico{display:inline-block;padding:0 6px;background:#e0342b;border:1px solid #b8271f;color:#ffffff;font-weight:bold;}
.how p{font-size:13px;color:#555555;margin:0 0 8px;line-height:1.8;}
.how b{color:#d35400;}
.btn{display:inline-block;margin-top:16px;padding:12px 36px;background:#2b7cff;border:1px solid #1f66e0;color:#ffffff;font-size:15px;text-decoration:none;}
.btn:hover{background:#1f66e0;}
.small{margin-top:14px;font-size:12px;color:#999999;}
</style>
</head>
<body>
<div class="wrap">
  <div class="logo">{{if .LogoURL}}<img src="{{.LogoURL}}" alt="{{.SiteName}}">{{end}}</div>
  <div class="notice"><span class="big">双核浏览器用户请注意</span><br>您当前使用的是「兼容模式」，切换到「极速模式」后刷新页面即可正常访问！</div>
  <div class="card">
    <div class="ico">!</div>
    <h1>当前浏览器版本较老</h1>
    <p>您的浏览器内核版本过旧（市场占有量已低于1%），无法完成安全验证。</p>
    <p>建议升级至谷歌内核浏览器，推荐使用 360 浏览器（极速模式）。</p>
    <div class="how">
      <h2 class="howtitle">如何切换到「极速模式」</h2>
      <p>出现本页说明您正处于「兼容模式」（地址栏右侧显示「<span class="eico">e</span>」图标），请按以下步骤切换：</p>
      <p><b>360 安全 / 360 极速浏览器：</b>点击地址栏右侧的「<span class="eico">e</span>」图标，选择「极速模式」，图标变为「闪电」即可；也可以在页面空白处点<b>鼠标右键 → 切换到极速模式</b>。</p>
      <p><b>QQ 浏览器：</b>点击地址栏右侧的「<span class="eico">e</span>」图标，选择「极速模式」，图标变为「闪电」即可。</p>
      <p><b>搜狗浏览器：</b>点击地址栏右侧的「<span class="eico">e</span> / 兼容」图标，切换为「高速模式」（图标变为「闪电」）。</p>
      <p><b>地址栏没有图标？</b>点浏览器右上角「菜单 → 设置」，找到「内核切换 / 浏览器内核」，选择「总是使用极速（WebKit）内核」。</p>
    </div>
    <p class="small">切换完成后刷新本页，将自动返回您要访问的地址。</p>
    <a class="btn" href="https://browser.360.cn/" target="_blank" rel="noopener">下载 360 浏览器</a>
  </div>
</div>
<script>
(function () {
  var ie = false;
  try { var ua = navigator.userAgent.toLowerCase(); ie = ua.indexOf("trident/") > -1 || ua.indexOf("msie ") > -1; } catch (e) {}
  if (!ie) {
    var m = location.search.match(/[?&]back=([^&]+)/);
    if (m) { var t = decodeURIComponent(m[1]); if (t.charAt(0) === "/" && t.charAt(1) !== "/") { location.replace(t); } }
  }
})();
</script>
</body>
</html>
`,
};
