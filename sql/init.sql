-- =====================================================================
-- WAF 后端项目 完整数据库初始化脚本
-- 数据库：waf（字符集 utf8mb4 / 引擎 InnoDB）
-- 表前缀：waf_（与 config/database.json 中 mysql.default.pre="waf_" 一致）
-- 说明：仅建表与插入初始数据，不创建数据库（请先手动 CREATE DATABASE waf）
-- 用法：mysql -u waf -p waf < init.sql
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. 管理员表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(64) NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(64) NOT NULL DEFAULT '' COMMENT '密码MD5哈希（32位小写hex）',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `last_login_ip` varchar(64) NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- ---------------------------------------------------------------------
-- 2. 系统配置表（固定 id=1 单行）
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_system_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_timeout` int(11) NOT NULL DEFAULT 3600 COMMENT '会话超时时间（秒）',
  `global_enabled` int(11) NOT NULL DEFAULT 1 COMMENT '全局防护开关：1=开启 0=关闭',
  `raw_log_path` varchar(512) NOT NULL DEFAULT '' COMMENT '原始日志存储目录',
  `heartbeat_interval` int(11) NOT NULL DEFAULT 30 COMMENT '引擎心跳间隔（秒）',
  `ticket_validity` int(11) NOT NULL DEFAULT 300 COMMENT '票据有效期（秒）',
  `cc_default_threshold` int(11) NOT NULL DEFAULT 100 COMMENT 'CC默认请求次数阈值',
  `cc_default_window` int(11) NOT NULL DEFAULT 60 COMMENT 'CC默认时间窗口（秒）',
  `log_retention_days` int(11) NOT NULL DEFAULT 30 COMMENT '日志保留天数',
  `raw_log_batch_size` int(11) NOT NULL DEFAULT 5000 COMMENT '原始日志落库批量阈值（条数）',
  `raw_log_flush_seconds` int(11) NOT NULL DEFAULT 5 COMMENT '原始日志落库时间阈值（秒）',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- ---------------------------------------------------------------------
-- 3. 站点表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '站点名称',
  `domains` varchar(512) NOT NULL DEFAULT '' COMMENT '域名，多个逗号分隔',
  `listen_port` int(11) NOT NULL DEFAULT 0 COMMENT '监听端口',
  `upstreams` text COMMENT '上游服务器JSON数组：[{"addr":"ip:port","weight":1}]',
  `ssl_enabled` int(11) NOT NULL DEFAULT 0 COMMENT '是否启用SSL：1=是 0=否',
  `cert_path` varchar(512) NOT NULL DEFAULT '' COMMENT '证书路径',
  `key_path` varchar(512) NOT NULL DEFAULT '' COMMENT '私钥路径',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `log_enable` int(11) NOT NULL DEFAULT 1 COMMENT '是否记录原始日志：1=是 0=否',
  `waf_enable` int(11) NOT NULL DEFAULT 1 COMMENT '是否启用WAF防护：1=是 0=否',
  `defense_type` varchar(16) NOT NULL DEFAULT 'js' COMMENT '防护方式：js=JS挑战 captcha=人机验证',
  `challenge_template` varchar(32) NOT NULL DEFAULT 'slider' COMMENT '人机验证模板：slider/puzzle/captcha',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_listen_port` (`listen_port`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='站点配置表';

-- ---------------------------------------------------------------------
-- 4. 拦截页面模板表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(32) NOT NULL DEFAULT '' COMMENT '模板类型：block/silent_challenge/slider/captcha/puzzle/waiting_room/overload/server_error',
  `name` varchar(64) NOT NULL DEFAULT '' COMMENT '模板名称',
  `content` text COMMENT 'HTML模板内容（Go template语法）',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_type_status` (`type`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='拦截页面模板表';

-- ---------------------------------------------------------------------
-- 5. IP组表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_ip_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT 'IP组名称',
  `type` varchar(16) NOT NULL DEFAULT '' COMMENT '类型：cidr/single',
  `ip_list` text COMMENT 'IP/CIDR列表，换行分隔',
  `count` int(11) NOT NULL DEFAULT 0 COMMENT 'IP数量',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='IP组表';

-- ---------------------------------------------------------------------
-- 6. 白名单规则表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_whitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT 0 COMMENT '站点ID，0=全局',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '规则名称',
  `target` varchar(32) NOT NULL DEFAULT '' COMMENT '匹配目标：ip/uri/header/cookie/...',
  `operator` varchar(32) NOT NULL DEFAULT '' COMMENT '匹配方式：equal/contains/regex',
  `value` varchar(1024) NOT NULL DEFAULT '' COMMENT '匹配值',
  `field` varchar(64) NOT NULL DEFAULT '' COMMENT '子字段（header名/cookie名）',
  `skip_rule` int(11) NOT NULL DEFAULT 0 COMMENT '跳过自定义规则：1=是',
  `skip_challenge` int(11) NOT NULL DEFAULT 0 COMMENT '跳过人机验证：1=是',
  `skip_cc` int(11) NOT NULL DEFAULT 0 COMMENT '跳过CC防护：1=是',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序权重',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_status` (`site_id`, `status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='白名单规则表';

-- ---------------------------------------------------------------------
-- 7. 自定义规则表（合并原黑名单）
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_custom_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT 0 COMMENT '站点ID，0=全局',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '规则名称',
  `conditions` text COMMENT '条件组JSON列表',
  `action` varchar(32) NOT NULL DEFAULT '' COMMENT '动作：block/challenge/redirect/observe',
  `logic` varchar(16) NOT NULL DEFAULT 'and' COMMENT '条件组间逻辑：and/or',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序权重',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_status` (`site_id`, `status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自定义规则表';

-- ---------------------------------------------------------------------
-- 8. CC防护规则表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_cc_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT 0 COMMENT '站点ID，0=全局',
  `name` varchar(128) NOT NULL DEFAULT '' COMMENT '规则名称',
  `target` varchar(32) NOT NULL DEFAULT 'ip' COMMENT '统计维度：ip/session',
  `threshold` int(11) NOT NULL DEFAULT 100 COMMENT '请求次数阈值',
  `window` int(11) NOT NULL DEFAULT 60 COMMENT '时间窗口（秒）',
  `action` varchar(32) NOT NULL DEFAULT 'block' COMMENT '动作：block/challenge/waiting_room/pass/observe',
  `waiting_max_size` int(11) NOT NULL DEFAULT 0 COMMENT '等候室最大容量',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序权重',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_status` (`site_id`, `status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CC防护规则表';

-- ---------------------------------------------------------------------
-- 9. 安全凭证配置表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_credential_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT 0 COMMENT '站点ID，0=全局默认，>0=站点级覆盖',
  `rc4_key` varchar(64) NOT NULL DEFAULT '' COMMENT 'RC4加密密钥',
  `cookie_name` varchar(64) NOT NULL DEFAULT 'waf_challenge' COMMENT '下发凭证Cookie名称',
  `validity` int(11) NOT NULL DEFAULT 30 COMMENT '凭证有效期（分钟）',
  `cookie_scope` varchar(64) NOT NULL DEFAULT '' COMMENT 'Cookie作用域（仅站点级有效）',
  `use_global` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否继承全局默认（仅站点级）',
  `factor_ip` tinyint(1) NOT NULL DEFAULT 1 COMMENT '指纹因子：IP',
  `factor_ua` tinyint(1) NOT NULL DEFAULT 1 COMMENT '指纹因子：UA',
  `factor_ja4` tinyint(1) NOT NULL DEFAULT 1 COMMENT '指纹因子：JA4',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_id` (`site_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='安全凭证配置表';

-- ---------------------------------------------------------------------
-- 11. 人机验证记录表
-- 说明：该表无固定结构体，代码仅在 admin 端按 site_id 过滤、id DESC 分页查询
--       （app/admin/model/challenge_config/challenge_config.go GetChallengeRecords），
--       前端记录页按 client_ip 搜索并按 status(pass/fail/pending) 区分状态，
--       本表结构为依据查询/展示需求推断的合理结构。
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_challenge_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT 0 COMMENT '站点ID',
  `client_ip` varchar(64) NOT NULL DEFAULT '' COMMENT '客户端IP',
  `user_agent` varchar(512) NOT NULL DEFAULT '' COMMENT '客户端UA',
  `challenge_type` varchar(32) NOT NULL DEFAULT '' COMMENT '验证类型：silent/slider/captcha/puzzle',
  `status` varchar(16) NOT NULL DEFAULT 'pending' COMMENT '验证状态：pass=已通过 fail=未通过 pending=待验证',
  `detail` text COMMENT '详细记录（JSON）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_id` (`site_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='人机验证记录表';

-- ---------------------------------------------------------------------
-- 12. 访问统计表（按站点+小时聚合）
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_access_stats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT 0 COMMENT '站点ID',
  `hour` varchar(13) NOT NULL DEFAULT '' COMMENT '小时，格式 YYYY-MM-DD-HH',
  `req_count` int(11) NOT NULL DEFAULT 0 COMMENT '请求数',
  `block_count` int(11) NOT NULL DEFAULT 0 COMMENT '拦截数',
  `unique_uv` int(11) NOT NULL DEFAULT 0 COMMENT '独立访客数(IP+UA拼接去重)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_site_hour` (`site_id`, `hour`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='访问统计表(按站点+小时)';

-- ---------------------------------------------------------------------
-- 13. 攻击日志表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_attack_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL DEFAULT 0 COMMENT '站点ID',
  `site_name` varchar(128) NOT NULL DEFAULT '' COMMENT '站点名称',
  `attack_type` varchar(64) NOT NULL DEFAULT '' COMMENT '攻击类型',
  `action` varchar(32) NOT NULL DEFAULT '' COMMENT '处置动作：block/challenge/observe等',
  `client_ip` varchar(64) NOT NULL DEFAULT '' COMMENT '客户端IP',
  `method` varchar(16) NOT NULL DEFAULT '' COMMENT '请求方法',
  `uri` varchar(1024) NOT NULL DEFAULT '' COMMENT '请求URI',
  `ua` varchar(512) NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `referer` varchar(1024) NOT NULL DEFAULT '' COMMENT 'Referer',
  `rule_id` int(11) NOT NULL DEFAULT 0 COMMENT '命中规则ID',
  `rule_name` varchar(128) NOT NULL DEFAULT '' COMMENT '命中规则名称',
  `detail` text COMMENT '命中详情JSON',
  `req_id` varchar(64) NOT NULL DEFAULT '' COMMENT '请求ID',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT 'HTTP响应状态码',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_site_id` (`site_id`),
  KEY `idx_attack_type` (`attack_type`),
  KEY `idx_client_ip` (`client_ip`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='攻击日志表';

-- ---------------------------------------------------------------------
-- 14. 审计日志表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_audit_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `module` varchar(64) NOT NULL DEFAULT '' COMMENT '操作模块',
  `action` varchar(64) NOT NULL DEFAULT '' COMMENT '操作动作',
  `operator_id` int(11) NOT NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人名称',
  `target_id` varchar(64) NOT NULL DEFAULT '' COMMENT '操作对象ID',
  `before_data` text COMMENT '操作前数据',
  `after_data` text COMMENT '操作后数据',
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '操作IP',
  `req_id` varchar(64) NOT NULL DEFAULT '' COMMENT '请求ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_module` (`module`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='审计日志表';

-- ---------------------------------------------------------------------
-- 15. 引擎日志表（module+message 去重累加）
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_engine_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `level` varchar(16) NOT NULL DEFAULT '' COMMENT '级别：info/warn/error',
  `module` varchar(64) NOT NULL DEFAULT '' COMMENT '模块：tls/proxy/cache等',
  `message` varchar(512) NOT NULL DEFAULT '' COMMENT '日志消息',
  `detail` text COMMENT '详细内容JSON',
  `count` int(11) NOT NULL DEFAULT 1 COMMENT '重复次数',
  `first_seen` datetime NOT NULL COMMENT '首次出现时间',
  `last_seen` datetime NOT NULL COMMENT '最近出现时间',
  PRIMARY KEY (`id`),
  KEY `idx_module_message` (`module`, `message`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='引擎日志表';

-- ---------------------------------------------------------------------
-- 16. 日志分析批次表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_analysis_batch` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `start_time` datetime DEFAULT NULL COMMENT '分析开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '分析结束时间',
  `source` varchar(32) NOT NULL DEFAULT '' COMMENT '来源：disk/upload',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT '状态：pending/completed',
  `total_ips` int(11) NOT NULL DEFAULT 0 COMMENT 'IP总数',
  `total_reqs` int(11) NOT NULL DEFAULT 0 COMMENT '请求总数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='日志分析批次表';

-- ---------------------------------------------------------------------
-- 17. 分析IP聚合表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_analysis_ip` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `batch_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '分析批次ID',
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '客户端IP',
  `req_count` int(11) NOT NULL DEFAULT 0 COMMENT '请求数',
  `block_count` int(11) NOT NULL DEFAULT 0 COMMENT '拦截数',
  `qps` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT '平均QPS',
  `region_full` varchar(128) NOT NULL DEFAULT '' COMMENT 'IP归属地',
  `ua` varchar(512) NOT NULL DEFAULT '' COMMENT 'User-Agent',
  PRIMARY KEY (`id`),
  KEY `idx_batch_id` (`batch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分析IP聚合表';

-- ---------------------------------------------------------------------
-- 18. 分析明细表
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `waf_analysis_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `batch_id` bigint(20) NOT NULL DEFAULT 0 COMMENT '分析批次ID',
  `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '客户端IP',
  `ts` varchar(32) NOT NULL DEFAULT '' COMMENT '请求时间戳',
  `method` varchar(16) NOT NULL DEFAULT '' COMMENT '请求方法',
  `uri` varchar(1024) NOT NULL DEFAULT '' COMMENT '请求URI',
  `status` int(11) NOT NULL DEFAULT 0 COMMENT 'HTTP响应状态码',
  `ua` varchar(512) NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `referer` varchar(1024) NOT NULL DEFAULT '' COMMENT 'Referer',
  `blocked` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否被拦截：1=是 0=否',
  PRIMARY KEY (`id`),
  KEY `idx_batch_ip` (`batch_id`, `ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分析明细表';

-- =====================================================================
-- 初始数据
-- =====================================================================

-- 默认管理员：admin / admin123（密码为 admin123 的 MD5，32位小写hex）
INSERT INTO `waf_admin` (`username`, `password`, `status`, `create_time`)
VALUES ('admin', '0192023a7bbd73250516f069df18b500', 1, NOW());

-- 系统默认配置（固定 id=1）
INSERT INTO `waf_system_config`
  (`id`, `session_timeout`, `global_enabled`, `raw_log_path`, `heartbeat_interval`,
   `ticket_validity`, `cc_default_threshold`, `cc_default_window`, `log_retention_days`, `update_time`)
VALUES
  (1, 3600, 1, 'runtime/data/access', 30, 300, 100, 60, 30, NOW());

-- 8 类拦截页面模板初始数据
INSERT INTO `waf_template` (`type`, `name`, `content`, `status`, `create_time`, `update_time`) VALUES
('block', '拦截页',
'<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8"><title>访问被拦截</title></head><body style="font-family:sans-serif;text-align:center;padding-top:8%;background:#f5f5f5;color:#333"><h1 style="color:#d33">403 - 访问被拦截</h1><p>您的请求已被防火墙拦截</p><p>站点：{{.SiteName}}</p><p>原因：{{.Reason}}</p><p>请求ID：{{.RequestID}}</p><p>客户端IP：{{.ClientIP}}</p><p>时间：{{.Time}}</p></body></html>',
1, NOW(), NOW()),
('silent_challenge', '静默JS挑战页',
'<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8"><title>安全验证</title></head><body style="font-family:sans-serif;text-align:center;padding-top:10%;background:#f5f5f5;color:#333"><h1>安全验证中...</h1><p>正在执行静默JS挑战，请稍候自动跳转</p><p>请求ID：{{.RequestID}}</p><script>setTimeout(function(){location.reload();},3000);</script></body></html>',
1, NOW(), NOW()),
('slider', '滑块验证页',
'<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8"><title>滑块验证</title></head><body style="font-family:sans-serif;text-align:center;padding-top:10%;background:#f5f5f5;color:#333"><h1>滑块验证</h1><p>请拖动滑块完成验证</p><div style="width:300px;height:40px;line-height:40px;margin:20px auto;background:#e0e0e0;border-radius:4px;position:relative"><div style="width:60px;height:40px;background:#409eff;color:#fff;border-radius:4px;cursor:pointer">→</div></div><p>请求ID：{{.RequestID}}</p></body></html>',
1, NOW(), NOW()),
('captcha', '图形验证码页',
'<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8"><title>图形验证</title></head><body style="font-family:sans-serif;text-align:center;padding-top:10%;background:#f5f5f5;color:#333"><h1>图形验证码</h1><p>请输入验证码完成验证</p><p>请求ID：{{.RequestID}}</p></body></html>',
1, NOW(), NOW()),
('puzzle', '拼图验证页',
'<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8"><title>拼图验证</title></head><body style="font-family:sans-serif;text-align:center;padding-top:10%;background:#f5f5f5;color:#333"><h1>拼图验证</h1><p>请拖动滑块将拼图补齐</p><p>请求ID：{{.RequestID}}</p></body></html>',
1, NOW(), NOW()),
('waiting_room', '等候室排队页',
'<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8"><title>排队等待</title></head><body style="font-family:sans-serif;text-align:center;padding-top:10%;background:#f5f5f5;color:#333"><h1>系统繁忙，正在排队</h1><p>您的排位：{{.Position}}，前面还有 {{.FrontCount}} 位</p><p>请求ID：{{.RequestID}}</p></body></html>',
1, NOW(), NOW()),
('overload', '过载拦截页',
'<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8"><title>系统过载</title></head><body style="font-family:sans-serif;text-align:center;padding-top:10%;background:#f5f5f5;color:#333"><h1 style="color:#d33">系统过载</h1><p>当前访问量过大，请稍后重试</p><p>站点：{{.SiteName}}</p><p>请求ID：{{.RequestID}}</p></body></html>',
1, NOW(), NOW()),
('server_error', '源站不可用页',
'<!DOCTYPE html><html lang="zh-CN"><head><meta charset="utf-8"><title>源站不可用</title></head><body style="font-family:sans-serif;text-align:center;padding-top:10%;background:#f5f5f5;color:#333"><h1 style="color:#d33">502 - 源站不可用</h1><p>{{.Reason}}</p><p>站点：{{.SiteName}}</p><p>请求ID：{{.RequestID}}</p></body></html>',
1, NOW(), NOW());
