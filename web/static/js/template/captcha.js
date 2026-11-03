(function () {
  var APP = window.__APP || {};
  var C = APP.a || '', NONCE = APP.b || '';
  var WAFU = APP.u || 'waf';
  var IS_LIVE = !!C && C.indexOf('{') < 0 && !window.__WAF_PREVIEW__;
  var ANCHOR = __ANCHOR__;
  var FONT = 'cmx', FONT_URL = __FONT__;
  var VKEY = '/' + WAFU + '/' + ['ch', 'all', 'enge'].join('') + '/verify';
  var WKEY = '/' + WAFU + '/' + ['ch', 'all', 'enge'].join('') + '/wait';
  var imageEP = '/' + WAFU + '/challenge/image';
  var refreshEP = '/' + WAFU + '/challenge/refresh';
  var AE_SPEC = __AE__;
  function autoEv(){
    var w=(navigator.webdriver===true)?1:0, c=0, d=0, s=0, wx=0, m=0, t=0, dwv=-1, dhv=-1, ohv=-1, ihv=-1, owv=-1, iwv=-1;
    try{ c = (/Headless|HeadlessChrome|PhantomJS|jsdom|Playwright/i.test(navigator.userAgent)?1:0); }catch(e){}
    try{ var dw=(window.outerWidth-window.innerWidth), dh=(window.outerHeight-window.innerHeight); dwv=dw; dhv=dh; ohv=window.outerHeight; ihv=window.innerHeight; owv=window.outerWidth; iwv=window.innerWidth; if(!(((navigator.maxTouchPoints)||0)>0||('ontouchstart' in window))){ d=(dw>260||dh>260)?1:0; } }catch(e){}
    try{ var gn=Object.getOwnPropertyNames(window), si=0, gi; for(gi=0;gi<gn.length;gi++){ if(gn[gi].indexOf('cdc_')===0||gn[gi].indexOf('$cdc')===0) si++; } s=si; }catch(e){}
    try{
      var own = Object.prototype.hasOwnProperty.call(navigator, 'webdriver');
      var pd = Object.getOwnPropertyDescriptor(Navigator.prototype, 'webdriver');
      var nat = !!(pd && pd.get && (/\[native code\]/.test(Function.prototype.toString.call(pd.get))));
      wx = (own || !pd || !nat) ? 1 : 0;
    }catch(e){}
    try{
      if(!('Notification' in window)) m++;
      if(!('FileReader' in window)) m++;
      if(!('OfflineAudioContext' in window) && !('webkitOfflineAudioContext' in window)) m++;
      if(!('createImageBitmap' in window)) m++;
      if(!navigator.plugins || !navigator.plugins.length) m++;
    }catch(e){}
    try{
      if(AE_SPEC && AE_SPEC.t && !(/\[native code\]/.test(String(Function.prototype.toString)))) t=1;
    }catch(e){}
    return {w:w, c:c, d:d, s:s, wx:wx, m:m, t:t, dw:dwv, dh:dhv, oh:ohv, ih:ihv, ow:owv, iw:iwv};
  }
  function _cc(){var i,o='',a=arguments;for(i=0;i<a.length;i++)o+=String.fromCharCode(a[i]);return o;}
  function _gp(o,p){var v=o,i;for(i=0;i<p.length;i++){if(v===null||v===void 0){return void 0;}v=v[p[i]];}return v;}
  function _mkP(ob){var j=_gp(window,[_cc(74,83,79,78),_cc(115,116,114,105,110,103,105,102,121)]);return b64x(j(ob));}
  var powKc=new Int32Array([0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]),powWk=new Int32Array(64),powSb={d:new Uint8Array(128),H:new Int32Array(8),o:new Uint8Array(32)};
  function powRf(x,n){return((x>>>n)|(x<<(32-n)))>>>0;}
  function powBlk(H,b,o){var W=powWk,i,j;for(i=0;i<16;i++){j=o+i*4;W[i]=((b[j]<<24)|(b[j+1]<<16)|(b[j+2]<<8)|b[j+3])|0;}for(i=16;i<64;i++){var s0=powRf(W[i-15],7)^powRf(W[i-15],18)^(W[i-15]>>>3),s1=powRf(W[i-2],17)^powRf(W[i-2],19)^(W[i-2]>>>10);W[i]=(W[i-16]+s0+W[i-7]+s1)|0;}var a=H[0],bq=H[1],c=H[2],d2=H[3],e=H[4],f=H[5],g=H[6],h=H[7];for(i=0;i<64;i++){var S0=powRf(a,2)^powRf(a,13)^powRf(a,22),maj=(a&bq)^(a&c)^(bq&c),t2=(S0+maj)|0,S1=powRf(e,6)^powRf(e,11)^powRf(e,25),cs2=(e&f)^(~e&g),t1=(h+S1+cs2+powKc[i]+W[i])|0;h=g;g=f;f=e;e=(d2+t1)|0;d2=c;c=bq;bq=a;a=(t1+t2)|0;}H[0]=(H[0]+a)|0;H[1]=(H[1]+bq)|0;H[2]=(H[2]+c)|0;H[3]=(H[3]+d2)|0;H[4]=(H[4]+e)|0;H[5]=(H[5]+f)|0;H[6]=(H[6]+g)|0;H[7]=(H[7]+h)|0;}
  function sha256Sync(msg){var u=unescape(encodeURIComponent(msg)),l=u.length,bl=l*8,pl=(l+9+63)&~63,d=new Uint8Array(pl),i;for(i=0;i<l;i++)d[i]=u.charCodeAt(i);d[l]=0x80;d[pl-4]=(bl>>>24)&0xFF;d[pl-3]=(bl>>>16)&0xFF;d[pl-2]=(bl>>>8)&0xFF;d[pl-1]=bl&0xFF;var H=new Int32Array([0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]);for(var off=0;off<pl;off+=64)powBlk(H,d,off);var o=new Uint8Array(32);for(i=0;i<8;i++){o[i*4]=(H[i]>>>24)&0xFF;o[i*4+1]=(H[i]>>>16)&0xFF;o[i*4+2]=(H[i]>>>8)&0xFF;o[i*4+3]=H[i]&0xFF;}return o;}
  function powPrep(ch){var p=ch.length,P=p+1,d=new Uint8Array(P),i,nl=P>>6,t=P&63,H=new Int32Array([0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]);for(i=0;i<p;i++)d[i]=ch.charCodeAt(i);d[p]=58;for(var off=0;off<nl*64;off+=64)powBlk(H,d,off);return{H:H,t:t,A:d,p0:P};}
  function powSlv(pr,n){var d=powSb.d,H=powSb.H,o=powSb.o,t=pr.t,i,m=n,nb=1;while(m>=10){m=(m/10)|0;nb++;}for(i=t;i<t+8;i++)d[i]=0;m=n;for(i=nb-1;i>=0;i--){d[t+i]=48+m%10;m=(m/10)|0;}d[t+nb]=0x80;var bl=(pr.p0+nb)*8,se=((t+nb+9+63)&~63)>>6;d.fill(0,t+nb+1,se*64-4);d[se*64-4]=(bl>>>24)&0xFF;d[se*64-3]=(bl>>>16)&0xFF;d[se*64-2]=(bl>>>8)&0xFF;d[se*64-1]=bl&0xFF;H.set(pr.H);for(i=0;i<se*64;i+=64)powBlk(H,d,i);for(i=0;i<8;i++){o[i*4]=(H[i]>>>24)&0xFF;o[i*4+1]=(H[i]>>>16)&0xFF;o[i*4+2]=(H[i]>>>8)&0xFF;o[i*4+3]=H[i]&0xFF;}return o;}
  function clzbBytes(b){var n=0,i;for(i=0;i<b.length;i++){if(b[i]===0){n+=8;continue;}if(b[i]<2)n+=7;else if(b[i]<4)n+=6;else if(b[i]<8)n+=5;else if(b[i]<16)n+=4;else if(b[i]<32)n+=3;else if(b[i]<64)n+=2;else if(b[i]<128)n+=1;break;}return n;}
  function solvePow(ch,bits,cb){if(typeof cb!=='function')return;if(typeof bits!=='number'||bits<=0){cb('0');return;}var pr=powPrep(ch),n=0,i,q=pr.p0-pr.t;for(i=0;i<pr.t;i++)powSb.d[i]=pr.A[q+i];function step(){var et=Date.now()+130;while(n<1<<22){if(clzbBytes(powSlv(pr,n))>=bits){cb(n);return;}n++;if(Date.now()>=et){setTimeout(step,0);return;}}cb('0');}setTimeout(step,0);}
  function tohex(b){var s='';for(var i=0;i<b.length;i++)s+=('0'+(b[i]&255).toString(16)).slice(-2);return s;}
  var K = __SEED__ || 'waf#2026$collect';
  var nonceDeadline = Date.now() + 55000;
  function b64x(s){var u=unescape(encodeURIComponent(s)),o='';for(var i=0;i<u.length;i++){o+=String.fromCharCode(u.charCodeAt(i)^K.charCodeAt(i%K.length));}return btoa(o);}
  function failMsg(){ return (Date.now() > nonceDeadline) ? '验证失败，请刷新页面重试' : '验证失败，请重试'; }
  var AUDIO_SPEC = __AUDIO__;
  var _acf='', acfReady=true;
  (function(){
    try{
      if(!AUDIO_SPEC||!AUDIO_SPEC.n||!AUDIO_SPEC.d||!AUDIO_SPEC.d.length) return;
      var N=AUDIO_SPEC.n, D=AUDIO_SPEC.d;
      var ctx=new (window.OfflineAudioContext||window.webkitOfflineAudioContext)(1,N,44100);
      var buf=ctx.createBuffer(1,N,44100);
      var ch=buf.getChannelData(0);
      for(var i=0;i<N;i++) ch[i]=(D[i]||0)/32768;
      var src=ctx.createBufferSource(); src.buffer=buf; src.connect(ctx.destination); src.start(0);
      acfReady=false;
      ctx.startRendering().then(function(out){
        var od=out.getChannelData(0),hsh=5381,j,v,s16;
        for(j=0;j<od.length;j++){
          v=Math.max(-1,Math.min(1,od[j]));
          s16=Math.round(v*32768)&0xFFFF;
          hsh=((hsh<<5)+hsh)^(s16&0xFF);
          hsh=((hsh<<5)+hsh)^((s16>>8)&0xFF);
        }
        hsh=hsh>>>0;
        var s=hsh.toString(16); while(s.length<8) s='0'+s;
        _acf=s; acfReady=true;
      }).catch(function(){ acfReady=true; });
    }catch(e){ acfReady=true; }
  })();
  var CAN_SPEC = __CANVAS__;
  var PROBES = __PROBES__;
  var WGL_SPEC = __WGL__;
  function djHash(data){ var h=5381>>>0,i; for(i=0;i<data.length;i+=4){ h=((h*33)^data[i])>>>0; h=((h*33)^data[i+1])>>>0; h=((h*33)^data[i+2])>>>0; } var s=h.toString(16); while(s.length<8)s='0'+s; return s; }
  function rgb255(c){ c=(''+c).replace('#',''); if(c.length===3){ c=c[0]+c[0]+c[1]+c[1]+c[2]+c[2]; } return [parseInt(c.substr(0,2),16)||0, parseInt(c.substr(2,2),16)||0, parseInt(c.substr(4,2),16)||0]; }
  function render2D(spec){
    var cv=document.createElement('canvas'); cv.width=spec.w; cv.height=spec.h;
    var g=cv.getContext('2d'); g.fillStyle='#fff'; g.fillRect(0,0,spec.w,spec.h);
    var i,r,s0=spec.r||[];
    for(i=0;i<s0.length;i++){ r=s0[i]; if(!r)continue; g.fillStyle=r.c||'#000'; g.fillRect(r.x,r.y,r.w,r.h); }
    return cv;
  }
  var _RGL=null;
  function renderWgl(spec){
    try{
      var cv=document.createElement('canvas'); cv.width=spec.w; cv.height=spec.h;
      var gl=cv.getContext('webgl')||cv.getContext('experimental-webgl'); if(!gl) return null; _RGL=gl;
      gl.viewport(0,0,spec.w,spec.h);
      gl.disable(gl.DEPTH_TEST); gl.disable(gl.BLEND); gl.disable(gl.SCISSOR_TEST);
      gl.clearColor(1,1,1,1); gl.clear(gl.COLOR_BUFFER_BIT);
      try{ gl.disable(0x809D); }catch(e){}
      var W=spec.w,H=spec.h, i,r,s0=spec.r||[];
      for(i=0;i<s0.length;i++){ r=s0[i]; if(!r)continue;
        gl.enable(gl.SCISSOR_TEST);
        gl.scissor(r.x, H-(r.y+r.h), r.w, r.h);
        var _cc=rgb255(r.c||'#000');
        gl.clearColor(_cc[0]/255,_cc[1]/255,_cc[2]/255,1);
        gl.clear(gl.COLOR_BUFFER_BIT);
      }
      gl.disable(gl.SCISSOR_TEST);
      var px=new Uint8Array(W*H*4); gl.readPixels(0,0,W,H,gl.RGBA,gl.UNSIGNED_BYTE,px);
      return px;
    }catch(e){ return null; }
  }
  function tzVal(){
    var tz='UTC';
    try{
      var I=_gp(window,[_cc(73,110,116,108)]);
      var F=I&&I[_cc(68,97,116,101,84,105,109,101,70,111,114,109,97,116)];
      var dt=F?new F():null;
      var t=dt?dt[_cc(114,101,115,111,108,118,101,100,79,112,116,105,111,110,115)]()[_cc(116,105,109,101,90,111,110,101)]:null;
      if(t) tz=t;
    }catch(e){}
    return tz+'|'+(-(new Date().getTimezoneOffset()));
  }
  function lngVal(){
    try{
      var N=_gp(window,[_cc(110,97,118,105,103,97,116,111,114)]);
      var L=N&&N[_cc(108,97,110,103,117,97,103,101,115)];
      var l1=N&&N[_cc(108,97,110,103,117,97,103,101)];
      var ls=(L&&L.length)?L:[l1||''];
      return ls.join(',');
    }catch(e){ return ''; }
  }
  function envD(){
    var S=_gp(window,[_cc(115,99,114,101,101,110)]);
    var DPR=_gp(window,[_cc(100,101,118,105,99,101,80,105,120,101,108,82,97,116,105,111)])||1;
    var N=_gp(window,[_cc(110,97,118,105,103,97,116,111,114)]);
    var _pv0=''+S[_cc(119,105,100,116,104)]+'x'+S[_cc(104,101,105,103,104,116)]+'x'+S[_cc(99,111,108,111,114,68,101,112,116,104)]+'x'+DPR;
    var _pv1=N[_cc(117,115,101,114,65,103,101,110,116)];
    var _pv2=tzVal();
    var _pv3=lngVal();
    var _pv4=String(N[_cc(109,97,120,84,111,117,99,104,80,111,105,110,116,115)]||0);
    var o={};
    var _pp=[_pv0,_pv1,_pv2,_pv3,_pv4];
    var _ps=__KORDER__;
    var _pi; for(_pi=0;_pi<_ps.length;_pi++){ o[_ps[_pi][0]]=_pp[_ps[_pi][1]]; }
    var spec=CAN_SPEC;
    if(spec&&spec.w&&spec.h&&document.createElement('canvas').getContext) o.cv=djHash(render2D(spec).getContext('2d').getImageData(0,0,spec.w,spec.h).data);
    if(WGL_SPEC&&WGL_SPEC.w&&WGL_SPEC.h){ var px=renderWgl(WGL_SPEC); if(px) o.wgl=djHash(px); }
    if(_RGL){ try{ var _gv=_RGL.getParameter(0x9246); var _gr=_RGL.getParameter(0x9245); if(_gr!=null) o.gpu=String(_gv||'')+'#'+String(_gr); }catch(e){} }
    if(AUDIO_SPEC&&AUDIO_SPEC.n&&_acf) o.acf=_acf;
    if(o.cv) o.bd=tohex(sha256Sync(tohex(sha256Sync(N[_cc(117,115,101,114,65,103,101,110,116)]))+'|'+o.cv));
    return o;
  }
  function anchorRender(spec){
    var cv=document.createElement('canvas'); cv.width=spec.w; cv.height=spec.h;
    var g=cv.getContext('2d');
    g.fillStyle='#fff'; g.fillRect(0,0,spec.w,spec.h);
    var i, rt, rs=spec.r||[];
    for(i=0;i<rs.length;i++){ rt=rs[i]; if(!rt) continue; g.fillStyle=rt.c||'#000'; g.fillRect(rt.x,rt.y,rt.w,rt.h); }
    var ops=spec.ops||[], op, lg;
    for(i=0;i<ops.length;i++){
      op=ops[i]; if(!op) continue;
      if(op.k==='rot'){
        g.save(); g.translate(op.x+op.w/2, op.y+op.h/2);
        g.rotate((op.a||0)*Math.PI/180); g.fillStyle=op.c1||'#000';
        g.fillRect(-op.w/2,-op.h/2,op.w,op.h); g.restore();
      } else if(op.k==='grad'){
        lg=(op.ax===1) ? g.createLinearGradient(0,op.y,0,op.y+op.h) : g.createLinearGradient(op.x,0,op.x+op.w,0);
        if(op.gs&&op.gs.length>1){ for(var gi=0;gi<op.gs.length;gi++){ lg.addColorStop(op.gs[gi].p/1000,op.gs[gi].c); } }
        else { lg.addColorStop(0,op.c1||'#000'); lg.addColorStop(1,op.c2||'#fff'); }
        g.fillStyle=lg; g.fillRect(op.x,op.y,op.w,op.h);
      } else if(op.k==='comp'){
        g.save(); g.globalCompositeOperation=op.cm||'multiply'; g.globalAlpha=(op.m||1000)/1000;
        g.fillStyle=op.c1||'#000'; g.fillRect(op.x,op.y,op.w,op.h); g.restore();
      } else if(op.k==='dash'){
        g.save(); g.beginPath(); g.setLineDash([op.dh||12, op.dg||8]);
        g.lineWidth=op.h; g.strokeStyle=op.c1||'#000';
        g.moveTo(op.x, op.y+op.h/2); g.lineTo(op.x+op.w, op.y+op.h/2);
        g.stroke(); g.restore();
      } else if(op.k==='disk'){
        g.save(); g.beginPath(); g.arc(op.x+op.w/2, op.y+op.h/2, Math.min(op.w,op.h)/2, 0, Math.PI*2);
        g.clip(); g.fillStyle=op.c1||'#000'; g.fillRect(op.x,op.y,op.w,op.h); g.restore();
      } else if(op.k==='xform'){
        g.save(); g.setTransform(1,0,(op.sk||0)/1000,1,op.x,op.y);
        g.fillStyle=op.c1||'#000'; g.fillRect(0,0,op.w,op.h); g.restore();
      } else if(op.k==='rgrad'){
        var rg=g.createRadialGradient(op.x+op.w/2,op.y+op.h/2,0,op.x+op.w/2,op.y+op.h/2,Math.min(op.w,op.h)/2);
        if(op.gs&&op.gs.length>1){ for(var gi=0;gi<op.gs.length;gi++){ rg.addColorStop(op.gs[gi].p/1000,op.gs[gi].c); } }
        else { rg.addColorStop(0,op.c1||'#000'); rg.addColorStop(1,op.c2||'#fff'); }
        g.fillStyle=rg; g.fillRect(op.x,op.y,op.w,op.h);
      } else if(op.k==='poly'){
        g.save(); g.beginPath();
        var pts=op.pts||[];
        for(var pi=0;pi<pts.length;pi++){ if(pi===0){g.moveTo(pts[pi][0],pts[pi][1]);}else{g.lineTo(pts[pi][0],pts[pi][1]);} }
        g.closePath(); g.clip(); g.fillStyle=op.c1||'#000'; g.fillRect(op.x,op.y,op.w,op.h); g.restore();
      } else if(op.k==='alpha'){
        g.save(); g.globalAlpha=(op.m||1000)/1000; g.fillStyle=op.c1||'#000';
        g.fillRect(op.x,op.y,op.w,op.h); g.restore();
      } else if(op.k==='text'){
        g.font=(op.f||op.h)+'px '+FONT; g.textBaseline='top'; g.textAlign='left';
        if(op.c2){ var lg=(op.ax===1)?g.createLinearGradient(0,op.y,0,op.y+op.h):g.createLinearGradient(op.x,0,op.x+op.w,0); lg.addColorStop(0,op.c1); lg.addColorStop(1,op.c2); g.fillStyle=lg; } else { g.fillStyle=op.c1||'#000'; }
        g.fillText(op.s||'', op.x, op.y);
      }
    }
    return cv;
  }
  function hexToInt(h){ if(!h) return 0; h=(''+h).replace('#',''); if(h.length===3){ h=h[0]+h[0]+h[1]+h[1]+h[2]+h[2]; } return (h.length===6)?parseInt(h,16):0; }
  function anchorFeats(spec, d){
    var w=spec.w, h=spec.h, out=[], i, j, x, y, a, op;
    var pure=[0xFFFFFF], rt, rs=spec.r||[], ops=spec.ops||[];
    for(i=0;i<rs.length;i++){ rt=rs[i]; if(rt&&rt.c) pure.push(hexToInt(rt.c)); }
    for(i=0;i<ops.length;i++){ op=ops[i]; if(!op)continue; if(op.c1)pure.push(hexToInt(op.c1)); if(op.c2)pure.push(hexToInt(op.c2)); if(op.gs){for(var gi=0;gi<op.gs.length;gi++){ if(op.gs[gi]&&op.gs[gi].c) pure.push(hexToInt(op.gs[gi].c)); }} }
    var nb=4, bw=Math.ceil(w/nb), bh=Math.ceil(h/nb), x0,x1,y0,y1;
    for(var by=0;by<nb;by++){
      y0=by*bh; y1=Math.min((by+1)*bh,h);
      for(var bx=0;bx<nb;bx++){
        x0=bx*bw; x1=Math.min((bx+1)*bw,w);
        var sB=0,sB2=0,cnt=0,be=0;
        for(y=y0;y<y1;y++){ a=(y*w+x0)*4;
          for(x=x0;x<x1;x++){ var b=d[a]+d[a+1]+d[a+2]; sB+=b; sB2+=b*b; cnt++; a+=4; }
        }
        for(y=y0;y<y1;y++){ a=(y*w+x0)*4;
          for(x=x0;x<x1-1;x++){ if(d[a]!==d[a+4]||d[a+1]!==d[a+5]||d[a+2]!==d[a+6]) be++; a+=4; }
        }
        if(cnt<1)cnt=1;
        var bm=Math.floor(sB/cnt);
        var nu=sB2*cnt-sB*sB; if(nu<0)nu=0;
        var bv=Math.floor(nu/(cnt*cnt*64));
        out.push({n:'bm',v:bm}); out.push({n:'be',v:be}); out.push({n:'bv',v:bv});
      }
    }
    var edge=0;
    for(y=0;y<h;y++){ a=(y*w)*4;
      for(x=0;x<w-1;x++){ if(d[a]!==d[a+4]||d[a+1]!==d[a+5]||d[a+2]!==d[a+6]) edge++; a+=4; }
    }
    out.push({n:'aa', v:Math.floor(edge*100/(w*h))});
    var md=0;
    for(i=0;i<d.length;i+=4){ var pv=(d[i]<<16)|(d[i+1]<<8)|d[i+2]; var isP=false;
      for(j=0;j<pure.length;j++){ if(pv===pure[j]){isP=true;break;} }
      if(!isP) md++;
    }
    out.push({n:'md', v:Math.floor(md*1000/(w*h))});
    for(i=0;i<ops.length;i++){ op=ops[i]; if(!op||op.k!=='text'||!op.s)continue;
      var tc=hexToInt(op.c1), tr=(tc>>16)&255, tg=(tc>>8)&255, tb=tc&255, tk=0;
      var tyb=op.y+op.h, txb=op.x+op.w;
      for(y=(op.y>0?op.y:0); y<tyb&&y<h; y++){ for(x=(op.x>0?op.x:0); x<txb&&x<w; x++){
        var q=(y*w+x)*4; if(Math.abs(d[q]-tr)<=48&&Math.abs(d[q+1]-tg)<=48&&Math.abs(d[q+2]-tb)<=48) tk++;
      }}
      out.push({n:'tk', v:tk});
    }
    for(i=0;i<ops.length;i++){ for(j=i+1;j<ops.length;j++){ var A=ops[i],B=ops[j];
      var ix0=Math.max(A.x,B.x), iy0=Math.max(A.y,B.y), ix1=Math.min(A.x+A.w,B.x+B.w), iy1=Math.min(A.y+A.h,B.y+B.h);
      if(ix0<0)ix0=0; if(iy0<0)iy0=0; if(ix1>w)ix1=w; if(iy1>h)iy1=h;
      if(ix1<=ix0||iy1<=iy0) continue;
      var sb=0,cc=0;
      for(y=iy0;y<iy1;y++){ for(x=ix0;x<ix1;x++){ var q2=(y*w+x)*4; sb+=d[q2]+d[q2+1]+d[q2+2]; cc++; } }
      out.push({n:'ov', v:cc?Math.floor(sb/cc):0});
    }}
    return out;
  }
  var FONT_READY = false;
  async function ensureFont(){
    if(FONT_READY) return;
    try{
      if(typeof FontFace === 'function'){
        var ff = new FontFace(FONT, 'url("' + FONT_URL + '")');
        await ff.load();
        document.fonts.add(ff);
        if(document.fonts && document.fonts.ready){ try{ await document.fonts.ready; }catch(e2){} }
      } else if(document.fonts && document.fonts.load){
        await document.fonts.load('20px "' + FONT + '"');
      }
    }catch(e){
      try{ if(document.fonts && document.fonts.load){ await document.fonts.load('20px "' + FONT + '"'); } }catch(e2){}
    }
    FONT_READY = true;
  }
  async function anchorRenderData(){
    var spec=CAN_SPEC;
    if(!spec||!spec.w||!spec.h) return null;
    await ensureFont();
    var cv=anchorRender(spec), d=cv.getContext('2d').getImageData(0,0,spec.w,spec.h).data;
    var f=anchorFeats(spec,d), p=[], i, px, o;
    for(i=0;i<PROBES.length;i++){
      px=PROBES[i]; if(!px||isNaN(px.x)||isNaN(px.y)) continue;
      if(px.x<0||px.y<0||px.x>=spec.w||px.y>=spec.h) continue;
      o=(px.y*spec.w+px.x)*4;
      p.push({x:px.x, y:px.y, r:(d[o]<<16)|(d[o+1]<<8)|d[o+2]});
    }
    if(!p.length) return null;
    var w = p.length ? (p.length + ':' + p[0].x + ':' + p[0].y) : '';
    return {f:f, p:p, w:w};
  }
  async function anchorPayload(){
    var d = await ANCHOR_PRE;
    if(!d){ d = await anchorRenderData(); }
    if(!d) return null;
    return {f:d.f, p:d.p, a:_acf, w:d.w, au:autoEv()};
  }
  var ANCHOR_PRE = ANCHOR ? anchorRenderData() : null;
  var img = document.getElementById('capImg'), wrap = document.getElementById('capImgWrap'),
      input = document.getElementById('codeInput'), btn = document.getElementById('refreshBtn'),
      verifyBtn = document.getElementById('verifyBtn'), msg = document.getElementById('msg');
  function postForm(url, kv, ok, fail){
    var q=[]; for (var k in kv){ q.push(encodeURIComponent(k)+'='+encodeURIComponent(kv[k])); }
    fetch(url, { method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'}, body:q.join('&') })
      .then(function(r){ return r.text().then(function(t){ var c=t.charAt(0); if(c==='{'||c==='['){ try{return JSON.parse(t);}catch(e){return {__html:true};} } document.open(); document.write(t); document.close(); return {__html:true}; }); })
      .then(ok).catch(fail || function(){});
  }
  function setMsg(t, ok) { msg.textContent = t || ''; msg.className = ok ? 'msg ok' : 'msg'; }
  function loadImg() {
    if (!IS_LIVE) { input.placeholder = '预览模式'; return; }
    img.src = imageEP + '?reqID=' + encodeURIComponent(C) + '&ts=' + Date.now();
    img.onerror = function () { setMsg('验证码图片加载失败，请点击换一张'); };
  }
  function refreshCAP() {
    if (!IS_LIVE) return;
    btn.classList.add('busy');
    fetch(refreshEP + '?reqID=' + encodeURIComponent(C))
      .then(function (r) { return r.json(); })
      .then(function () { btn.classList.remove('busy'); setMsg(''); loadImg(); })
      .catch(function () { btn.classList.remove('busy'); setMsg('刷新失败，请重试'); });
  }
  function shake() { input.classList.remove('err'); void input.offsetWidth; input.classList.add('err'); input.focus(); }
  var busy = false, serverReady = false;
  var btFocused = false, btKeys = 0, btBack = 0, btPaste = false, btPrevTs = 0, btIntervals = [], btFocusTs = 0;
  input.addEventListener('focus', function () { btFocused = true; btFocusTs = Date.now(); });
  input.addEventListener('input', function () { btKeys++; });
  input.addEventListener('keydown', function (e) {
    if (e.key === 'Backspace') btBack++;
    var now = Date.now(); if (btPrevTs) btIntervals.push(now - btPrevTs); btPrevTs = now;
  });
  input.addEventListener('paste', function () { btPaste = true; });
  function btPayload(codeLen) {
    return { n: btKeys, d: btFocused ? (Date.now() - btFocusTs) : 0, f: btFocused ? 1 : 0,
             b: btBack, p: btPaste ? 1 : 0, i: btIntervals.slice(0, 16), l: codeLen };
  }
  function startWait() {
    (function tick() {
      postForm(WKEY, { reqID: C }, function (j) {
        if (j && j.__html) { return; }
        if (j && j.code === 400) { setMsg((j.msg) || '请求过于频繁，请稍后重试'); return; }
        if (j && j.ready) { serverReady = true; return; }
        setTimeout(tick, 200 + Math.floor(Math.random() * 300));
      }, function () { setTimeout(tick, 300); });
    }());
  }
  async function submit() {
    var code = input.value.replace(/\s/g, '');
    if (!IS_LIVE) { setMsg('预览模式，演示通过', 1); return; }
    if (!code) { shake(); return; }
    if (busy) return; busy = true; verifyBtn.disabled = true;
    if (!serverReady) { busy = false; verifyBtn.disabled = false; setMsg('正在确认时限，请稍候...'); setTimeout(submit, 150); return; }
    if (!powSol) { busy = false; verifyBtn.disabled = false; setMsg('正在计算验证，请稍候...'); setTimeout(submit, 500); return; }
    if (!acfReady) { busy = false; setTimeout(submit, 80); return; }
    var pr = await anchorPayload();
    if (!pr) { busy = false; verifyBtn.disabled = false; setMsg('验证环境加载失败，请刷新'); return; }
    var bt = JSON.stringify(btPayload(code.length));
    postForm(VKEY, { reqID: C, code: code, bt: bt, pow: powSol, powS: String(powStartTs), powE: String(powEndTs), nonce: NONCE, "__KEY_D__": _mkP(envD()), "__KEY_AH__": _mkP(pr) }, function (j) {
        busy = false; verifyBtn.disabled = false;
        if (j && j.__html) { return; }
        if (j && j.code === 200) {
          verifyBtn.classList.add('ok'); setMsg('验证通过，正在跳转...', 1);
          setTimeout(function () { window.location.reload(); }, 800);
        } else if (j && j.code === 403) {
          setMsg((j.msg) || failMsg()); setTimeout(function () { window.location.reload(); }, 400);
        } else if (j && j.code === 201) {
          setMsg((j.msg) || '请稍候再试'); input.value = ''; loadImg();
        } else {
          setMsg((j && j.msg) || '验证码错误'); input.value = ''; shake(); loadImg();
        }
      }, function () { busy = false; verifyBtn.disabled = false; setMsg('网络异常，请重试'); });
  }
  verifyBtn.addEventListener('click', submit);
  input.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); submit(); } });
  wrap.addEventListener('click', refreshCAP);
  btn.addEventListener('click', function (e) { e.stopPropagation(); refreshCAP(); });
  var powSol = '', powStartTs = 0, powEndTs = 0;
  if (IS_LIVE) {
    if (APP.p && APP.p.h && APP.p.b) {
      powStartTs = Date.now();
      solvePow(APP.p.h, APP.p.b, function (sol) { powSol = String(sol); powEndTs = Date.now(); });
    }
    startWait();
  }
  loadImg();
})();
