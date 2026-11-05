<div align="center">

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="web/static/images/logo-dark.svg">
  <img src="web/static/images/logo.svg" alt="畅来WAF" width="320">
</picture>

# 畅来WAF

**新一代人机验证与纵深防御引擎**

Go 语言原生 · 不依赖 Nginx · 单文件部署 · 5 分钟接入

[官网](https://www.clwaf.com) ｜ [帮助文档](https://www.clwaf.com/help) ｜ [版本对比](https://www.clwaf.com/help/editions.html) ｜ [问题反馈](https://github.com/dfpopp/clwaf/issues)

</div>

---

## 它解决什么问题

大多数 WAF 解决的是「请求内容像不像攻击」。但增长更快的一类威胁不长这样：**请求完全合法，发请求的不是人。**

爬虫批量抓数据、脚本刷券刷短信、撞库试密码、自动化工具扫接口——这些请求里没有 `union select`，没有 `../`，参数格式全对，语义分析和规则匹配都找不出异常。它们的问题不在「说了什么」，而在「是谁在说」。

畅来WAF 在规则层之上加了一层客户端判定：**连接特征、交互行为、设备环境、会话凭证**四类信号交叉验证，单点伪造无效。过不去的是机器，过得去的是人。

> 判定项、阈值与权重不对外披露。公开这类参数等于替绕过者重新标价，对已在使用的站点不公平。

---

## 能力概览

### 01 攻击特征防护 · 9 类 114 条内置规则

命中即拦，不做全量扫描：

| 类别 | 条数 | 覆盖 |
|---|---|---|
| SQL 注入 | 20 | 联合查询、堆叠、布尔/时间盲注、报错注入、文件读写、`information_schema` 探测、OOB、`xp_cmdshell` |
| XSS 跨站 | 12 | script 标签、事件属性、伪协议、data URI、iframe |
| 命令注入 | 13 | 分隔符拼接、`$()`、反引号、`${IFS}`、base64 管道执行、反弹 shell |
| 文件包含 | 12 | `../`、`%2e%2e`、`/etc/passwd`、`.env`、`php://` `phar://`、`%00` 截断 |
| SSRF | 6 | 非 HTTP 协议、内网段、回环、链路本地、云元数据 `169.254.169.254` |
| 模板注入 | 14 | Jinja2 / SpEL / EL / JNDI / Smarty / Twig / Velocity / FreeMarker |
| 反序列化 | 12 | Java `rO0AB`、PHP `O:`、Python pickle、Ruby Marshal、`__proto__` |
| WebShell | 13 | 危险扩展名深检、PHP/ASP/Java 木马特征、`base64_decode+eval` |
| 信息泄露 | 12 | `.git` `.svn`、`.env`、备份文件、IDE 目录、swagger / actuator、`phpinfo.php` |

**匹配前先规范化**，顺序固定：

```
连续 URL 解码（≤4 层）→ HTML 实体解码 → 去除 /**/ 注释噪声
→ 去 NUL → 转小写 → 压缩空白 → 规则匹配
```

这一步比规则条数更决定实际效果——不做规范化的规则库，一个双层编码就能过。

规则正则启动时一次性编译，运行时只匹配不编译；命中即返，不再往下走。

### 02 人机验证 · 多层联合判定

不是「加个验证码」，是四类信号交叉：

| 层 | 判什么 |
|---|---|
| 连接特征 | 客户端声明的身份是否自洽 |
| 交互行为 | 交互过程是否呈现人类特征 |
| 设备环境 | 多次请求是否来自同一台设备 |
| 会话凭证 | 一次性令牌、计算挑战、动态等待 |

**四种挑战形态**：JS 挑战（静默）/ 滑块拼图 / 拼图 / 图形验证码。免费版含 JS 挑战与滑块拼图。

**JS 挑战延迟分档**：0 / 1 / 3 / 5 秒，站点级独立配置。真人无需额外操作，浏览器自动完成。

**0 秒档为「透明注入」**：内容直出、响应内注入采集脚本异步评分，首次访问零延迟感知；评分不过的客户端，下一次请求才会吃到完整挑战。适合内容页优先保证体验，登录等敏感接口建议配 1 秒以上档位或滑块。

验证通过后签发凭证，之后凭凭证免验证，可绑定 IP / UA / 指纹因子，有效期按站点配置。

### 03 计算挑战

对可疑流量下发计算任务：正常浏览器自动完成、用户无感知；批量脚本每一条请求都要付出真实算力成本。成本随请求量线性抬升，脚本的收益随之消失。

### 04 CC 与等候室

- CC 规则按 `ip` / `ip_uri` / `ip_ua` 三个维度计数，可设阈值、时间窗口与处置动作（拦截 / 观察 / 等候室 / 跳转 / 放行）
- 站点并发上限 + 全站应用级兜底：整站流量超限时进等候室，**排队而非直接拒绝**
- 等候室先进先出，同一客户端复用槽位（刷新不会重新排队），排到队首签发通行凭证
- 后台可查排队列表、手动插队、清理陈旧记录

### 05 爬虫治理 · 两套资产

**恶意爬虫 IP 库**：按入库原因分类（Cookie 过期 / 短期重复验证 / 多次验证失败 / 短时错误频繁 / 资源请求不完整 / 失败围栏 / 无 JS 执行 / 指纹头矛盾 / 后台手动），命中即拦，支持人工加白与解除。

**搜索引擎蜘蛛库**：对命中蜘蛛 UA 的来源做 rDNS 金标准回验——PTR 反解 → 官方后缀匹配 → 正向确认，通过者按 10 家引擎（baidu / bing / 360 / sogou / yisou / google / petal / apple / yandex / duckduckgo）分桶聚合为最简 CIDR。

真蜘蛛不会被误伤，这是爬虫治理里最容易做错的一环。

### 06 策略引擎

- **白名单**：11 类匹配目标 + 算子组合，命中后可**分别**跳过「规则 / 人机验证 / CC」——不用为了放行一个接口把整个防护关掉
- **自定义规则**：条件组 AND / OR 组合，动作支持 `block` / `challenge` / `redirect` / `observe`
  - `observe` 只记录不拦，用于上线前灰度。内置规则是恒拦截的，没有「仅记录」开关，灰度请用自定义规则或白名单
- **IP 组**：CIDR 或单 IP 批量管理，规则内以 `ip_group:<id>` 引用，删除前检查引用
- **生效方式**：配置写库即失效缓存，引擎 5 秒内读到新配置。站点增删、监听端口、证书均无需重启

### 07 观测

- 攻击日志：类型、IP、UA、URI、请求详情，含原始请求与解码后对比——**能直接看出是哪条规则、哪个变形触发的**
- 秒级 QPS 与攻击类型分布、请求维度 TopN（URI / IP / UA / Referer）、HLL 去重 UV
- 全操作审计日志

### 08 过载保护

站点并发上限 + 等候室削峰。队列满时渲染过载页（503 语义），而不是让源站被打死。

---

## 架构

四个进程，一个入口：

```
wafd            进程守护，唯一入口，托管三个子进程
 ├── waf        引擎：反向代理 + 规则 + 人机验证 + CC，接管站点流量
 ├── admin      本地后台：站点 / 规则 / 日志 / 统计，Go 单文件
 └── cron       定时任务：日志清理、统计聚合、等候室与人机记录清理
```

请求链路（顺序固定，命中即止）：

```
TCP 首字节嗅探分流 HTTP / HTTPS（同端口，按 SNI 发证）
  → SiteMatch     按 Host 匹配站点 + 按站点配置解析真实客户端 IP
  → Whitelist     命中打 skip_rule / skip_challenge / skip_cc 标记
  → UriLimit      URI 原始 >6KB 或解码后 >16KB 直接拦
  → AttackGuard   9 类内置攻击规则
  → CrawlerGuard  恶意爬虫 IP 库
  → CustomRule    自定义规则
  → Challenge     人机验证（凭证校验 / 渲染挑战页 / API 428）
  → CC            限频 + 等候室排队
  → ProxyHandler  反向代理回源（多源站按权重）
```

**依赖**：MySQL 8.0 + Redis。除此之外不需要任何第三方组件——畅来WAF 本身就是反向代理，不是 Nginx 模块，也不依赖 Nginx 才能运行。

---

## 快速开始

```bash
# 1. 下载 Releases 压缩包，解压到 /usr/local/waf
cd /usr/local/waf

# 2. 配置数据库（MySQL 8.0 + Redis）
vi config/database.json

# 3. 启动（首次启动自动建库并导入 sql/init.sql）
./wafctl.sh start
```

后台地址 `http://服务器IP:后台端口`，端口见 `config/app.json` 的 `admin.http.addr`（默认 `49463`）。
默认账号 `admin / admin123` —— **登录后第一件事是改密**。

`config/custom.json` 里的 `admin_session_secret` 与 `license_secret` 留空即可，首次启动自动生成写回；`platform_base_url` 为空时云平台相关功能自动禁用。

完整部署说明（systemd 自启、升级流程、端口建议）见包内 **《部署说明.txt》**，或 [帮助文档 · 安装部署](https://www.clwaf.com/help/install.html)。

### Nginx 已经占着 80 / 443？

标准做法是拆两块：Nginx 入口块监听 80/443，把流量转给 WAF 的高位端口；WAF 再回源到 Nginx 的源站块。

回源时 **`X-Forwarded-For` 必须用覆盖式 `$remote_addr`**，不能拼 `$proxy_add_x_forwarded_for`：

```nginx
# 入口块
location / {
    proxy_pass http://127.0.0.1:8080;                # WAF 监听端口
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $remote_addr;   # 覆盖，不是追加
    proxy_set_header X-Real-IP $remote_addr;
}
```

用 `$proxy_add_x_forwarded_for` 的后果：客户端自己带一个 XFF 头就能伪造来源 IP，CC 限频和 IP 黑名单全部失效。

完整配置与验证方法见 [帮助文档 · 接入第一个站点](https://www.clwaf.com/help/first-site.html)。

### CDN / 云 WAF 回源场景

流量经过 CDN 后，TCP 对端地址是 CDN 节点，不是真实客户端。站点配置里的 `client_ip_mode` 决定怎么取：

| 值 | 取值方式 |
|---|---|
| 1 | TCP 对端地址（无代理时用） |
| 2 | 取 XFF 中的第 N 个（配合 `client_ip_index`） |
| 3 | 取指定 Header |

填错的后果不是「IP 不准」这么轻——**全站用户会被当成同一个攻击者**，一次限频就把整站拦住。验证方法：发起一次测试攻击，看攻击日志里的 `client_ip` 是不是你自己的出口 IP。

同时把 CDN 回源段加进白名单，并按需勾选跳过规则 / 人机验证 / CC。

---

## 日常运维

```bash
./wafctl.sh start      # 启动（wafd 前台常驻，托管三个子进程）
./wafctl.sh status     # 三个进程状态：pid / 运行时长 / 累计自动重启
./wafctl.sh restart    # 全量重启三个子进程（wafd 不退出）
./wafctl.sh stop       # 停机（人为停机，子进程不会被自动拉起）
./wafctl.sh initdb     # 手动执行数据库初始化检查（连接排障 / 补导入）
```

**崩溃处理**：子进程崩溃自动重启；10 分钟内反复崩溃 3 次及以上进入指数退避（上限 30 分钟），稳定运行 10 分钟后恢复常规重启间隔。

**启动失败判定**：任一子进程连续 3 次启动后 10 秒内退出（典型原因：端口被占用、数据库不可达、配置错误），`wafd` 判定为不可恢复故障——停止全部进程并打印该子进程日志末尾，而不是无限重试空转。按提示修复后重新 `./wafctl.sh start`。

**日志位置**：

```
runtime/log/wafd/daemon.out.log    守护日志（子进程退出 / 重启 / 退避记录）
runtime/log/wafd/<名称>.out.log     子进程控制台输出（含 panic 堆栈）
runtime/log/engine|admin|cron/     各进程结构化业务日志
```

**升级流程**：`./wafctl.sh stop` → 覆盖二进制 → `./wafctl.sh start`。存量升级请勿对已有数据执行 `init.sql`，联系官方获取对应版本的升级 SQL。

**安全组**：云主机安全组只放行业务 80/443 与后台端口，**不要放行引擎高位端口**（如 8081）。`wafd` 控制通道仅监听 `127.0.0.1`，无需在防火墙放行。

---

## 免费版能力

**给什么**：9 类 114 条规则全量、人机验证（JS 挑战 + 滑块）、CC 与等候室、爬虫 IP 库、白名单与自定义规则。

**限什么**：

| 项 | 免费版 | 说明 |
|---|---|---|
| 防护站点 | 5 个 | |
| 单站点源站 | 1 个 | 多源站加权负载均衡为 Pro |
| 自定义规则 / 白名单 / IP 组 | 各 10 条 | 条件层级为单层多条件 |
| 人机验证形态 | JS 挑战 + 滑块拼图 | 拼图、图形验证码为 Pro |
| 统计报表 | 24 小时 | |
| 原始访问日志 | 不保存 | 离线保存与在线分析为 Pro |
| 云规则库 / 共享库 | 10 条 / 种子库 Top100 | |
| 告警通道 | **无** | 邮件与 Webhook 在规划中，未上线 |
| 在线升级 | **无** | 升级 = 替换二进制 + 重启 |
| 技术支持 | 技术论坛 | SLA 与工单支持为 Pro |

取舍原则：**核心防护不阉割，阉割的是规模和运维便利。** 这张表不写清楚，用户上手才发现，比不写更伤。

完整对照见 [帮助文档 · 免费版与 Pro](https://www.clwaf.com/help/editions.html)。

---

## 常见问题

**为什么引擎只有二进制，没有源码？**

规则库编译进二进制。源码公开等于把 114 条规则和判定逻辑一起交出去。这是产品的分发方式，不是没做完——本仓库提供前端资源、部署脚本和发行包，引擎以二进制形式分发。

**和 ModSecurity 有什么区别？**

ModSecurity 是 Nginx / Apache 的规则引擎模块，只做请求内容判定。畅来WAF 是独立反向代理进程，在规则层之外还有客户端判定层（人机验证 + 行为特征 + 设备环境），处理「请求合法但来者不是人」这一类。两者不在同一层。

**装 WAF 会不会拖慢站点？**

多一跳反向代理，延迟增量取决于回源链路。同机部署通常在一毫秒级，跨机部署看网络。规则正则在启动时一次性编译，运行时只匹配不编译。

**证书怎么配？**

站点证书在 WAF 上配置，热加载，5 秒生效。回源用 HTTPS 且源站是自签证书时，需在站点设置里勾选「跳过源站证书校验」。

**端口绑定失败为什么不自动重绑？**

已知限制，不是 bug。端口被占用后需要改配置并重启引擎。设计上不做自动重绑，避免与系统服务抢占端口。

**有告警吗？**

当前没有。邮件与 Webhook 在规划中。这也是免费版边界表里明确标注的一项。

**支持 API / App / 小程序走验证吗？**

支持。把这些路径配进站点的 `api_paths`，命中后走 `428 → 202 → 轮询` 协议，不会往 JSON 客户端里塞 HTML 挑战页。服务端调用和内部服务可以按需加白。

---

## 文档

| 章节 | 内容 |
|---|---|
| [开始之前](https://www.clwaf.com/help/overview.html) | 四个组成部分、完整处理链路、核心概念 |
| [安装部署](https://www.clwaf.com/help/install.html) | MySQL / Redis 依赖、配置、systemd 自启 |
| [首次登录](https://www.clwaf.com/help/first-login.html) | 必做三件事、后台导览 |
| [接入第一个站点](https://www.clwaf.com/help/first-site.html) | 监听端口与域名、源站配置、CDN 真实 IP |
| [防护配置](https://www.clwaf.com/help/defense.html) | 白名单三种 skip、凭证因子、CC、等候室 |
| [规则配置](https://www.clwaf.com/help/rules.html) | 9 类规则、规范化、自定义规则与 observe 灰度 |
| [爬虫治理](https://www.clwaf.com/help/crawler.html) | 两套爬虫资产、rDNS 回验 |
| [观测与排障](https://www.clwaf.com/help/monitoring.html) | 日志字段、误拦截排查四步法 |
| [授权与升级](https://www.clwaf.com/help/license.html) | 授权流程、宽限期、二进制替换升级 |
| [免费版与 Pro](https://www.clwaf.com/help/editions.html) | 完整差异对照 |

---

## 更新日志

见 [Releases](https://github.com/dfpopp/clwaf/releases)。每次发版注明：修了哪些规则、加了什么能力、是否有配置变更、怎么升级。

---

## 授权

免费版可免费用于商业与非商业用途，包括生产环境部署、内部使用、为客户部署。

允许原样分发发行包，须保留版权声明与《部署说明.txt》。不得对二进制进行逆向工程、反编译或去除授权校验；不得将本发行包作为另一产品的组成部分单独销售。

本软件按「现状」提供，不附带任何担保。安全产品无法保证百分之百拦截，生产环境部署前请完成充分测试。

商业支持与 Pro 版能力见 [官网](https://www.clwaf.com)。
