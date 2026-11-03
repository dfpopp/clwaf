# WAF 管理员后台前端开发方案（对齐决议）

> 本文档用于记录 WAF 管理员后台前端开发前，与产品对齐的关键技术决议，防止后续遗忘。
> 状态：**方案已对齐，已按本文档落地**（实现以代码为准，本文档同步更新与代码的差异）。

## 一、已确定的决议（10 项）

### 1. 页面架构：iframe 方案（参照 daiAdmin）
- 采用 **iframe 多页**架构，与之前 daiAdmin 一致。
- 主框架页 `index.html`：完整头部 + 顶部栏 + 左侧菜单 + 内容区 iframe。
- 14 个业务模块各自为**独立的 .html 页面**，在内容区 iframe 中加载。
- 好处：头尾菜单只写一份（父框架），子页面保持简单，HTML 不写进 js 字符串。

### 2. 菜单结构：14 项 / 4 分组
| 分组 | 菜单项 |
|---|---|
| 概览 | 仪表盘 |
| 防护规则 | 白名单、自定义规则、人机验证、CC防护、IP组 |
| 系统配置 | 安全凭证、拦截页面模板、系统设置 |
| 日志审计 | 日志分析、攻击日志、审计日志、引擎错误日志 |

### 3. 登录认证：cookie 会话（加密 + 签名）
- 登录成功后下发 cookie `waf_session`（HttpOnly），后续请求浏览器自动携带。
- cookie 值**不存明文管理员信息**：`管理员id + username + 过期时间戳` 做 **RC4 加密 + base64**，再拼 **MD5 签名**，服务端可验签、防篡改、有过期校验。
- 密钥：`admin_session_secret`，放在 `config/custom.json`（已生成写入），**独立于引擎密钥** `waf_secret`，只后端读取、绝不进前端。
- 校验：auth 中间件读 cookie → 验签 → 解密 → 校验过期 → 注入 `operator_id/operator_name`；任一失败返回 `code:401`。

### 4. 统一请求层
- 所有接口**用表单编码**（`application/x-www-form-urlencoded`）提交，**不传 JSON body**（后端只解析表单）。
- 统一封装 `request()`：自动附带 cookie、统一解析 `{code, msg, data, count}`。
  - `code===200` → 成功，返回 data（列表时带出 count 供分页）
  - `code!==200` → 统一弹错误提示并中断（reject）
  - `code===401` → 统一跳登录页
- 所有页面只调该封装，不各自 fetch。

### 5. UI 对齐策略：前后端一起补齐
- 前端按 UI 原型做全。
- UI 有但后端缺失/空桩的接口，**后端一并补齐**。

### 6. 访问统计表：新增 `access_stats`
- 新表字段：`site_id, hour, req_count, block_count, unique_uv`
- 供仪表盘聚合出请求量/PV/UV/拦截量、24h 趋势、站点统计等。
- 旧数据由现有 cron 清理任务定期清理（如保留 30 天）。

### 7. 统计时机：延迟聚合（随日志批量落盘）
- 不实时累加。
- 在引擎原始日志**批量落盘时顺带聚合**（`app/wafEngine/service/raw_log/raw_log.go` 的 `flushBatch`），对这批日志按"站点+小时"聚合后累加进 `access_stats`。

### 8. UV 口径：IP + UA 去重
- 访客身份键 = `IP + UA` 去重计 UV（不是纯 IP 近似）。

### 9. 安全凭证配置：单独建表、带站点ID
- **单独建一张凭证配置表**，带 `site_id`，**`site_id=0` 表示全局默认**。
- 字段（建议）：`rc4_key`、`cookie_name`、`validity`（有效期分钟）、`factor_ip/factor_ua/factor_ja4`（因子开关）、站点级另有 `cookie_scope`（作用域）、`use_global`（是否继承全局）等。

### 10. 后端需补齐的接口/字段（已落地核对）
| 模块 | 补齐内容 | 落地情况 |
|---|---|---|
| 安全凭证 | 凭证配置的查询/保存接口（单独表 `waf_credential_config`、带 site_id，0=全局） | ✅ `/api/credential_config/get`、`/api/credential_config/save` |
| 仪表盘 | 真实统计（从 access_stats 聚合） | ✅ 未建独立 dashboard 模块，改由 `/api/access_stats/stats` + `/api/attack_log/stats|recent` 提供 |
| 日志分析 | 增加"上传原始日志文件"接口（.log/.json，解析入库） | ✅ `/api/analysis/upload`；磁盘导入 `/api/analysis/import_disk` 仍为空桩 |
| 站点/攻击日志 | 站点列表"今日请求数"从 access_stats 聚合（不加字段）；攻击日志/地图展示省份、城市 | ✅ 已实现（攻击日志查询时用 ip2region 实时解析） |

### 11. IP 地域归属地（离线库）
- **离线 IP 库**（效率优先、不要求百分百正确）。
- 在 `pkg/ip` 包内新增 `GetLocation(ip) (province, city)` 方法，读取离线库解析出省份/城市。
- 库文件：`pkg/ip/ip2region.xdb`，**已由助手下载放入**（已完成）。
- 日志入库时（引擎 attack_log 批量落库、raw_log 聚合 / analysis 入库）调用该方法，把省份/城市一并存下，供地图/日志展示。✅ 已实现——攻击日志在后台查询时用 `GetLocation` 实时解析展示，analysis 入库时写入 `analysis_ip.region_full`。
- 库文件缺失时不报错、归属地返回空，不影响运行。

## 二、后续待确认（可随时补充）
（暂无，以上 11 项已对齐）

## 三、执行备注
- 本方案文档与 WAF 需求文档（`WAF V1 单机版产品需求文档（定稿）.md`）配套，作为前端开发的实施依据。
- 后续若决议有变化，更新本文档并在顶部注明变更。
