/* IE 专项验证脚本（老内核方案 docs/0924/IE11兼容性技术方案_2026-10-28.md §6.2 P2，I5）。
 * 纯 ES5 + XHR，IE11/Trident 可执行；不含画布锚点/acf/envX 采集（IE 分支明确不做，
 * 硬门=验证码文本+PoW+IE 探针画像，服务端 legacyProbeGate 校验）。
 * 同源段（勿手改，防与服务端漂移）：$proto 键名派生段（$s0src/$shf/$ci/$up/$os/$cat/cs/$proto）
 * 与 sha256/PoW 段（K/WK/SB/R/blk/sh/prep/slv/lz + pw setTimeout 时间预算分片）逐字节取自
 * silent.js —— 键名派生与 PoW 语义必须与服务端 derive.DeriveParamNames / VerifyPoW 一致。
 * 占位符（引擎 ServeTongjiJs 下发时填充，脱离会话独立拉取拿不到有效键名/种子，无法预填答案）：
 *   __SEED__=会话签名种子（$shf 键名派生）；__WDM__=PoW 慢机提示窗口(ms)；
 *   __KEY_D__=行为载荷随机提交键（服务端 postField 'd' 还原）。
 */
(function(){'use strict';
/* ---- IE11 兼容垫片：Math.imul / TypedArray.prototype.fill（$shf/$slv 依赖，老内核可能缺失） ---- */
(function(){if(!Math.imul){Math.imul=function(a,b){var ah=(a>>>16)&0xFFFF,al=a&0xFFFF,bh=(b>>>16)&0xFFFF,bl=b&0xFFFF;return((al*bl)+(((ah*bl+al*bh)<<16)>>>0))|0;};}function pf(v,s,e){var n=this.length;s=(s==null)?0:((s<0)?Math.max(n+s,0):s);e=(e==null)?n:((e<0)?Math.max(n+e,0):Math.min(e,n));for(var i=s;i<e;i++)this[i]=v;return this;}if(window.Uint8Array&&!window.Uint8Array.prototype.fill)window.Uint8Array.prototype.fill=pf;if(window.Int32Array&&!window.Int32Array.prototype.fill)window.Int32Array.prototype.fill=pf;})();
var $app=window.__APP||{},$rid=$app.a||'',$nid=$app.b||'',$pfx=$app.u||'waf';
var $live=!!$rid&&$rid.indexOf('{')<0&&!window.__WAF_PREVIEW__;
function $s0src(){var u='',i,c;function add(x){x=String(x);for(i=0;i<x.length;i++){c=x.charAt(i).toLowerCase();if((c>='a'&&c<='z')||(c>='0'&&c<='9')){if(u.indexOf(c)<0)u+=c;}}}add(new Date(0).toUTCString());add(String(Math.PI));add(String(Math.E));add(String(1/3));add(String(0.1+0.2));add(Object.prototype.toString.call([]));add(Object.prototype.toString.call({}));add(String(NaN));add(String(Infinity));add(String(-Infinity));for(var lc=97;lc<=122;lc++)add(String.fromCharCode(lc));for(var dc=48;dc<=57;dc++)add(String.fromCharCode(dc));return u;}
var $S0=$s0src(),$seed=__SEED__||'waf#2026$collect';
function $shf(s){var x=0x9E3779B9,i,t,j;for(i=0;i<$seed.length;i++)x=(Math.imul(x^$seed.charCodeAt(i),2654435761))>>>0;if(!x)x=0x85EBCA6B;function nxt(){x^=x<<13;x^=x>>>17;x^=x<<5;return(x>>>0);}var a=s.split('');for(i=a.length-1;i>0;i--){j=nxt()%(i+1);t=a[i];a[i]=a[j];a[j]=t;}return a.join('');}
var $A2=$shf($S0);
function $ci(ch){var i=$S0.indexOf(ch);return i<0?ch:$A2.charAt(i);}
function $up(ch){return $ci(ch).toUpperCase();}
function $os(ch,n){return String.fromCharCode(ch.charCodeAt(0)+n);}
function $cat(a){var o='',i=0;for(;i<a.length;i++)o+=a[i];return o;}
function cs(a){var o='',i=0;for(;i<a.length;i++)o+=String.fromCharCode(a[i]);return o;}
function $proto(){var pW=$cat([$ci('p'),$ci('o'),$os($ci('t'),3)]);return{a:'/'+$pfx+'/'+cs([99,104,97,108,108,101,110,103,101])+'/'+cs([119,97,105,116]),b:'/'+$pfx+'/'+cs([99,104,97,108,108,101,110,103,101])+'/'+cs([118,101,114,105,102,121]),c:$cat([$ci('r'),$ci('e'),$os($ci('p'),1),$up($ci('i')),$up($ci('d'))]),d:pW,e:$cat([$ci('n'),$ci('o'),$ci('n'),$ci('c'),$ci('e')]),f:$cat([pW,$up($ci('s'))]),g:$cat([pW,$up($ci('e'))]),h:cs([119,101,98,100,114,105,118,101,114]),i:cs([111,110,116,111,117,99,104,115,116,97,114,116]),j:cs([99,100,99,95]),k:cs([36,99,100,99]),l:cs([78,111,116,105,102,105,99,97,116,105,111,110]),m:cs([70,105,108,101,82,101,97,100,101,114]),n:cs([79,102,102,108,105,110,101,65,117,100,105,111,67,111,110,116,101,120,116]),o:cs([119,101,98,107,105,116,79,102,102,108,105,110,101,65,117,100,105,111,67,111,110,116,101,120,116]),p:cs([99,114,101,97,116,101,73,109,97,103,101,66,105,116,109,97,112]),q:cs([99,109,120]),r:cs([74,83,79,78]),s:cs([115,116,114,105,110,103,105,102,121]),t:cs([98,116,111,97]),u:cs([99,97,110,118,97,115]),v:cs([85,84,67])};}
var K=new Int32Array([0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2]);var WK=new Int32Array(64),SB={d:new Uint8Array(128),H:new Int32Array(8),o:new Uint8Array(32)};
function R(x,n){return((x>>>n)|(x<<(32-n)))>>>0;}
function blk(H,b,o){var W=WK,i,j;for(i=0;i<16;i++){j=o+i*4;W[i]=((b[j]<<24)|(b[j+1]<<16)|(b[j+2]<<8)|b[j+3])|0;}for(i=16;i<64;i++){var s0=R(W[i-15],7)^R(W[i-15],18)^(W[i-15]>>>3),s1=R(W[i-2],17)^R(W[i-2],19)^(W[i-2]>>>10);W[i]=(W[i-16]+s0+W[i-7]+s1)|0;}var a=H[0],bq=H[1],c=H[2],d2=H[3],e=H[4],f=H[5],g=H[6],h=H[7];for(i=0;i<64;i++){var S0=R(a,2)^R(a,13)^R(a,22),maj=(a&bq)^(a&c)^(bq&c),t2=(S0+maj)|0,S1=R(e,6)^R(e,11)^R(e,25),cs2=(e&f)^(~e&g),t1=(h+S1+cs2+K[i]+W[i])|0;h=g;g=f;f=e;e=(d2+t1)|0;d2=c;c=bq;bq=a;a=(t1+t2)|0;}H[0]=(H[0]+a)|0;H[1]=(H[1]+bq)|0;H[2]=(H[2]+c)|0;H[3]=(H[3]+d2)|0;H[4]=(H[4]+e)|0;H[5]=(H[5]+f)|0;H[6]=(H[6]+g)|0;H[7]=(H[7]+h)|0;}
function sh(msg){var u=unescape(encodeURIComponent(msg)),l=u.length,bl=l*8,pl=(l+9+63)&~63,d=new Uint8Array(pl),i;for(i=0;i<l;i++)d[i]=u.charCodeAt(i);d[l]=0x80;d[pl-4]=(bl>>>24)&0xFF;d[pl-3]=(bl>>>16)&0xFF;d[pl-2]=(bl>>>8)&0xFF;d[pl-1]=bl&0xFF;var H=new Int32Array([0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]);for(var off=0;off<pl;off+=64)blk(H,d,off);var o=new Uint8Array(32);for(i=0;i<8;i++){o[i*4]=(H[i]>>>24)&0xFF;o[i*4+1]=(H[i]>>>16)&0xFF;o[i*4+2]=(H[i]>>>8)&0xFF;o[i*4+3]=H[i]&0xFF;}return o;}
function prep(ch){var p=ch.length,P=p+1,d=new Uint8Array(P),i,nl=P>>6,t=P&63,H=new Int32Array([0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]);for(i=0;i<p;i++)d[i]=ch.charCodeAt(i);d[p]=58;for(var off=0;off<nl*64;off+=64)blk(H,d,off);return{H:H,t:t,A:d,p0:P};}
function slv(pr,n){var d=SB.d,H=SB.H,o=SB.o,t=pr.t,i,m=n,nb=1;while(m>=10){m=(m/10)|0;nb++;}for(i=t;i<t+8;i++)d[i]=0;m=n;for(i=nb-1;i>=0;i--){d[t+i]=48+m%10;m=(m/10)|0;}d[t+nb]=0x80;var bl=(pr.p0+nb)*8,se=((t+nb+9+63)&~63)>>6;d.fill(0,t+nb+1,se*64-4);d[se*64-4]=(bl>>>24)&0xFF;d[se*64-3]=(bl>>>16)&0xFF;d[se*64-2]=(bl>>>8)&0xFF;d[se*64-1]=bl&0xFF;H.set(pr.H);for(i=0;i<se*64;i+=64)blk(H,d,i);for(i=0;i<8;i++){o[i*4]=(H[i]>>>24)&0xFF;o[i*4+1]=(H[i]>>>16)&0xFF;o[i*4+2]=(H[i]>>>8)&0xFF;o[i*4+3]=H[i]&0xFF;}return o;}
function lz(b){var n=0;for(var i=0;i<b.length;i++){if(b[i]===0){n+=8;continue;}if(b[i]<2)n+=7;else if(b[i]<4)n+=6;else if(b[i]<8)n+=5;else if(b[i]<16)n+=4;else if(b[i]<32)n+=3;else if(b[i]<64)n+=2;else if(b[i]<128)n+=1;break;}return n;}
/* pw = pow.go bPowTimeout 同款（setTimeout 时间预算分片，step 带 try-catch 兜底防断链假死），
 * 命名沿用 silent.js 无 $ 前缀版本。慢机（Chakra+老硬件）靠分片让出保持页面可响应，
 * __WDM__ 窗口内未完成仅提示不重载，杜绝"看门狗刷新→重算"假死循环。 */
function pw(ch,bits,cb){if(typeof cb!=='function')return;if(typeof bits!=='number'||bits<=0){cb('0');return;}var pr=prep(ch),n=0,i,q=pr.p0-pr.t;for(i=0;i<pr.t;i++)SB.d[i]=pr.A[q+i];function step(){var et=Date.now()+130;try{while(n<1<<22){if(lz(slv(pr,n))>=bits){cb(n);return;}n++;if(Date.now()>=et){setTimeout(step,0);return;}}}catch(e){}cb('0');}setTimeout(step,0);}
/* ---- IE 真实性探针画像（§6.3 校验项4）：随 verify 提交，服务端 legacyProbeGate 硬门比对。
 * 探针全 ES5：IE 专属对象存在性 + 现代 API 缺失性 + documentMode 范围；
 * cc_on（JScript 条件编译）仅作画像留证，服务端不作硬门（边界差异防误伤真 IE11）。 ---- */
function probeP(){var o={dm:0,cc:0,ax:0,im:0,sm:0,nf:0,np:0,nd:0};try{o.dm=document.documentMode||0;}catch(e){}try{if(window.ActiveXObject)o.ax=1;}catch(e){}try{if(window.MSInputMethodContext)o.im=1;}catch(e){}try{if(window.styleMedia)o.sm=1;}catch(e){}try{if(typeof window.fetch!=='function')o.nf=1;}catch(e){}try{if(typeof window.Promise!=='function')o.np=1;}catch(e){}try{var _c=document.createElement('canvas').getContext('2d');if(!(_c&&_c.setLineDash))o.nd=1;}catch(e){o.nd=1;}try{o.cc=(eval('/*@cc_on!@*/false'))?1:0;}catch(e){}return o;}
/* ---- 键入节奏采集（§6.3 校验项6，软门留证）：keydown 间隔序列，IE11 无 e.key（keyCode 体系） ---- */
var KEY=[],lastKT=0;
function krec(){var t=Date.now();if(lastKT){KEY.push(t-lastKT);if(KEY.length>96)KEY.splice(0,KEY.length-96);}lastKT=t;}
/* ---- XHR 传输（IE 无 fetch/Promise）：4 判就绪，非 JSON 响应视为异常走 fail ---- */
function xhr(u,b,ok,fail){var x=new XMLHttpRequest();x.open('POST',u,true);x.setRequestHeader('Content-Type','application/x-www-form-urlencoded;charset=UTF-8');x.onreadystatechange=function(){if(x.readyState!==4)return;var t='';try{t=x.responseText||'';}catch(e){}var j=null,c0=t.charAt(0);if(c0==='{'||c0==='['){try{j=JSON.parse(t);}catch(e){}}if(j){ok(j);}else{fail();}};try{x.send(b);}catch(e){fail();}}
function enc2(k,v){return encodeURIComponent(k)+'='+encodeURIComponent(v);}
function getEl(id){return document.getElementById(id);}
function msg(t,good){var el=getEl('msg');if(!el)return;el.textContent=t||'';el.className=good?'msg ok':'msg';}
function setImage(){var im=getEl('capImg');if(im)im.src='/'+$pfx+'/challenge/image?reqID='+encodeURIComponent($rid)+'&v='+Math.floor(Math.random()*999999);}
/* 换一张必须走服务端 /challenge/refresh（更换会话答案）后再拉新图；仅刷 img.src 答案不变 */
function refreshImg(){var x=new XMLHttpRequest();x.open('GET','/'+$pfx+'/challenge/refresh?reqID='+encodeURIComponent($rid),true);x.onreadystatechange=function(){if(x.readyState!==4)return;setImage();};try{x.send();}catch(e){setImage();}}
var $P=null,$S={ans:'',ts:0,te:0,done:false,ready:false,busy:false,t0:Date.now()};
function btnState(){var b=getEl('verifyBtn');if(b)b.disabled=!($S.ready&&$S.done);}
/* 接口A 轮询（与现有挑战同协议）：ready 即点亮提交按钮；400=会话死亡/短封，停止并提示 */
function $poll(){xhr($P.a,enc2($P.c,$rid),function(j){if(j&&j.ready){$S.ready=true;btnState();return;}if(j&&j.code===400){msg((j&&j.msg)||'验证已过期，请刷新页面后重试');return;}setTimeout($poll,250+Math.floor(Math.random()*300));},function(){setTimeout($poll,400);});}
/* 接口B 提交：五键（c/d/e/f/g）按 $proto 会话派生命名 + 固定名 code + __KEY_D__ 随机键行为载荷
 * （p=探针画像 k=键入间隔 t=耗时）。失败处置：403=围栏满次提示后刷新；其余失败显示原因后
 * 自动刷新页面换新会话（reload 不计失败，防批量试探由 IP+UA 30s 窗口兜底）——避免用户在
 * 临近过期的旧会话上继续操作撞"会话已过期"死胡同。严禁定时自动重发 verify：30s 窗口 5 次
 * verify 失败即入爬虫库。 */
function $submit(){if($S.busy)return;if(!$S.ready||!$S.done){setTimeout($submit,150);return;}$S.busy=true;btnState();var inp=getEl('codeInput'),code=inp?inp.value:'';var items=[enc2($P.c,$rid),enc2($P.d,$S.ans),enc2($P.e,$nid),enc2($P.f,String($S.ts)),enc2($P.g,String($S.te)),enc2('code',code)];items.push(enc2('__KEY_D__',JSON.stringify({p:probeP(),k:KEY.join(','),t:Date.now()-$S.t0})));xhr($P.b,items.join('&'),function(j){$S.busy=false;btnState();if(j&&j.code===200){okUI();return;}if(j&&j.code===403){msg('失败次数过多，IP 已被限制，请稍后重新访问');setTimeout(function(){window.location.reload();},800);return;}msg((j&&j.msg)||'验证未通过，页面即将刷新，请重新输入');setTimeout(function(){window.location.reload();},1200);},function(){$S.busy=false;btnState();msg('网络异常，请稍后重试');});}
function okUI(){msg('验证通过，正在进入网站…',true);var b=getEl('verifyBtn');if(b)b.disabled=true;setTimeout(function(){window.location.reload();},800);}
function boot(){$P=$proto();setImage();var inp=getEl('codeInput');if(inp)inp.onkeydown=krec;var rb=getEl('refreshBtn');if(rb)rb.onclick=function(){refreshImg();msg('');};var cw=getEl('capImgWrap');if(cw)cw.onclick=function(){refreshImg();msg('');};var vb=getEl('verifyBtn');if(vb)vb.onclick=$submit;if($app.p&&$app.p.h&&$app.p.b){$S.ts=Date.now();pw($app.p.h,$app.p.b,function(sol){$S.ans=String(sol);$S.te=Date.now();$S.done=true;msg('');btnState();});setTimeout(function(){if(!$S.done)msg('正在进行校验计算，请稍候…');},__WDM__);}else{$S.done=true;}$poll();btnState();}
if($live){boot();}
})();
