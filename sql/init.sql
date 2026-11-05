/*
 Navicat Premium Data Transfer

 Source Server         : 新亿企飞
 Source Server Type    : MySQL
 Source Server Version : 80036
 Source Host           : 115.190.223.189:3306
 Source Schema         : waf

 Target Server Type    : MySQL
 Target Server Version : 80036
 File Encoding         : 65001

 Date: 04/11/2026 15:03:54
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for waf_access_min_stats
-- ----------------------------
DROP TABLE IF EXISTS `waf_access_min_stats`;
CREATE TABLE `waf_access_min_stats`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID(0=全部/未匹配站点)',
  `bucket` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '10分钟粒度桶 YYYY-MM-DD HH:MM(分钟对齐到10的倍数)',
  `req_count` int NOT NULL DEFAULT 0 COMMENT '访问计数',
  `block_count` int NOT NULL DEFAULT 0 COMMENT '拦截计数',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_site_bucket`(`site_id` ASC, `bucket` ASC) USING BTREE,
  INDEX `idx_bucket`(`bucket` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '实时访问统计(10分钟粒度)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_access_stats
-- ----------------------------
DROP TABLE IF EXISTS `waf_access_stats`;
CREATE TABLE `waf_access_stats`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID',
  `hour` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '小时，格式 YYYY-MM-DD-HH',
  `req_count` int NOT NULL DEFAULT 0 COMMENT '请求数',
  `block_count` int NOT NULL DEFAULT 0 COMMENT '拦截数',
  `page_count` int NOT NULL DEFAULT 0 COMMENT '页面请求量（200且响应为HTML页面，不去重）',
  `unique_uv` int NOT NULL DEFAULT 0 COMMENT '独立访客数(IP+UA拼接去重)',
  `unique_ip` int NOT NULL DEFAULT 0 COMMENT '小时去重独立IP数（折线图趋势用）',
  `challenge_pass_count` int NOT NULL DEFAULT 0 COMMENT '人机验证通过数',
  `challenge_fail_count` int NOT NULL DEFAULT 0 COMMENT '人机验证拦截数',
  `cc_count` int NOT NULL DEFAULT 0 COMMENT 'CC拦截数',
  `zsec_inject_count` int NOT NULL DEFAULT 0 COMMENT '0秒挑战注入数（nonce签发）',
  `zsec_submit_count` int NOT NULL DEFAULT 0 COMMENT '0秒挑战提交数（评分包到达）',
  `zsec_pass_count` int NOT NULL DEFAULT 0 COMMENT '0秒挑战通过数（评分达标发凭证）',
  `zsec_upgrade_count` int NOT NULL DEFAULT 0 COMMENT '0秒挑战升级数（低分/沉默写升级标记）',
  `zsec_silent_count` int NOT NULL DEFAULT 0 COMMENT '0秒挑战沉默数（零回传判定）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_site_hour`(`site_id` ASC, `hour` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '访问统计表(按站点+小时)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_admin
-- ----------------------------
DROP TABLE IF EXISTS `waf_admin`;
CREATE TABLE `waf_admin`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '密码MD5哈希（32位小写hex）',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `last_login_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '最后登录IP',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of waf_admin
-- ----------------------------
INSERT INTO `waf_admin` VALUES (1, 'admin', '0192023a7bbd73250516f069df18b500', 1, '', '2026-11-01 22:52:21', '2026-08-21 09:02:48');

-- ----------------------------
-- Table structure for waf_analysis_batch
-- ----------------------------
DROP TABLE IF EXISTS `waf_analysis_batch`;
CREATE TABLE `waf_analysis_batch`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `start_time` datetime NULL DEFAULT NULL COMMENT '分析开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '分析结束时间',
  `source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源：disk/upload',
  `status` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '状态：pending/completed',
  `total_ips` int NOT NULL DEFAULT 0 COMMENT 'IP总数',
  `total_reqs` int NOT NULL DEFAULT 0 COMMENT '请求总数',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '日志分析批次表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_analysis_detail
-- ----------------------------
DROP TABLE IF EXISTS `waf_analysis_detail`;
CREATE TABLE `waf_analysis_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `batch_id` bigint NOT NULL DEFAULT 0 COMMENT '分析批次ID',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '客户端IP',
  `ts` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '请求时间戳',
  `method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '请求方法',
  `uri` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求URI',
  `status` int NOT NULL DEFAULT 0 COMMENT 'HTTP响应状态码',
  `ua` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `referer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'Referer',
  `blocked` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否被拦截：1=是 0=否',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_batch_ip`(`batch_id` ASC, `ip` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '分析明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_analysis_ip
-- ----------------------------
DROP TABLE IF EXISTS `waf_analysis_ip`;
CREATE TABLE `waf_analysis_ip`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `batch_id` bigint NOT NULL DEFAULT 0 COMMENT '分析批次ID',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '客户端IP',
  `req_count` int NOT NULL DEFAULT 0 COMMENT '请求数',
  `block_count` int NOT NULL DEFAULT 0 COMMENT '拦截数',
  `qps` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '平均QPS',
  `region_full` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'IP归属地',
  `ua` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'User-Agent',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_batch_id`(`batch_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '分析IP聚合表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_attack_log
-- ----------------------------
DROP TABLE IF EXISTS `waf_attack_log`;
CREATE TABLE `waf_attack_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID',
  `site_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '站点名称',
  `attack_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '攻击类型',
  `challenge_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '验证子类型：silent_challenge/slider/captcha/puzzle',
  `is_api` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否API接口请求：1=API(WebView打开挑战) 0=Web',
  `action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '处置动作：block/challenge/observe等',
  `client_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '客户端IP',
  `method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '请求方法',
  `uri` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '请求URI',
  `ua` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `referer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'Referer',
  `headers` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '完整请求头JSON',
  `detail` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '拦截请求参数快照JSON（内置攻击拦截，值已脱敏截断，误报反馈用）',
  `rule_id` int NOT NULL DEFAULT 0 COMMENT '命中规则ID',
  `rule_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '命中规则名称',
  `req_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '请求ID',
  `status` int NOT NULL DEFAULT 0 COMMENT 'HTTP响应状态码',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_client_ip`(`client_ip` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_challenge_type`(`challenge_type` ASC) USING BTREE,
  INDEX `idx_site_create`(`site_id` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_attack_type_create`(`attack_type` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_create_client`(`create_time` ASC, `client_ip` ASC) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC, `attack_type` ASC) USING BTREE,
  INDEX `idx_attack_type`(`attack_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '攻击日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_audit_log
-- ----------------------------
DROP TABLE IF EXISTS `waf_audit_log`;
CREATE TABLE `waf_audit_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `module` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '操作模块',
  `action` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '操作动作',
  `operator_id` int NOT NULL DEFAULT 0 COMMENT '操作人ID',
  `operator_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '操作人名称',
  `target_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '操作对象ID',
  `before_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作前数据',
  `after_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作后数据',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '操作IP',
  `req_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '请求ID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_module`(`module` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '审计日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_cc_rule
-- ----------------------------
DROP TABLE IF EXISTS `waf_cc_rule`;
CREATE TABLE `waf_cc_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID，0=全局',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `target` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ip' COMMENT '统计维度：ip/session',
  `conditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '匹配条件组JSON（[{\"conditions\":[{target,operator,value,field}],\"logic\":\"and|or\"}]，与自定义规则同构；空=无条件）',
  `logic` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '组间逻辑 and/or（空=or）',
  `threshold` int NOT NULL DEFAULT 100 COMMENT '请求次数阈值',
  `window` int NOT NULL DEFAULT 60 COMMENT '时间窗口（秒）',
  `action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'block' COMMENT '动作：block/challenge/waiting_room/pass/observe/redirect',
  `scope` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'all' COMMENT '适用范围：all=全部 nocred=仅无凭证 cred=仅持凭证',
  `redirect_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '302重定向跳转地址（action=redirect 时使用）',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序权重',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_site_status`(`site_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sort`(`sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'CC防护规则表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for waf_challenge_record
-- ----------------------------
DROP TABLE IF EXISTS `waf_challenge_record`;
CREATE TABLE `waf_challenge_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID',
  `client_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '客户端IP',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '客户端UA',
  `headers` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '完整请求头JSON',
  `challenge_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '验证类型：silent/slider/captcha/puzzle',
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '触发请求路径',
  `is_api` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否API接口请求：1=API(WebView打开挑战) 0=Web',
  `req_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '请求ID（触发请求）',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending' COMMENT '验证状态：pass=已通过 fail=未通过 pending=待验证',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '详细记录（JSON）',
  `diag` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '诊断明细（失败原因/锚点探针/标定数据）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_status_create`(`status` ASC, `create_time` ASC) USING BTREE,
  INDEX `idx_req_id`(`req_id` ASC) USING BTREE,
  INDEX `idx_create_time_id`(`create_time` ASC, `id` ASC) USING BTREE,
  INDEX `idx_ip_ct_id`(`client_ip` ASC, `create_time` ASC, `id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '人机验证记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_cloud_rule
-- ----------------------------
DROP TABLE IF EXISTS `waf_cloud_rule`;
CREATE TABLE `waf_cloud_rule`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `platform_id` bigint NOT NULL COMMENT '平台侧规则ID（唯一映射，续期/重拉去重键）',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '平台规则名',
  `rule_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '规则类型：whitelist=平台白名单 custom=平台拦截',
  `condition_groups` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '条件组JSON（与本地规则同构）',
  `logic` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '组间逻辑：and/or（空=or）',
  `action` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'custom 型处置动作（block/observe/redirect 等）',
  `skip_rule` tinyint NOT NULL DEFAULT 0 COMMENT 'whitelist 型：命中后跳过自定义规则',
  `skip_challenge` tinyint NOT NULL DEFAULT 0 COMMENT 'whitelist 型：命中后跳过人机验证',
  `skip_cc` tinyint NOT NULL DEFAULT 0 COMMENT 'whitelist 型：命中后跳过CC',
  `min_edition` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'free' COMMENT '平台标注最低适用版本（free/pro）',
  `weight` int NOT NULL DEFAULT 0 COMMENT '平台权重（展示排序）',
  `enabled` tinyint NOT NULL DEFAULT 1 COMMENT '本地启停（平台下发默认启用，停用立即生效）',
  `sync_ver` bigint NOT NULL DEFAULT 0 COMMENT '平台侧规则版本（增量同步游标）',
  `create_time` datetime NULL DEFAULT NULL,
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_platform_id`(`platform_id` ASC) USING BTREE,
  INDEX `idx_type_enabled`(`rule_type` ASC, `enabled` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '云平台规则（只读物化，来源=platform）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for waf_crawler_ip
-- ----------------------------
DROP TABLE IF EXISTS `waf_crawler_ip`;
CREATE TABLE `waf_crawler_ip`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '来源IP（IPv4/IPv6）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=拦截 0=停用',
  `source` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'expired_challenge' COMMENT 'expired_challenge=程序自动 manual=后台手动',
  `reason` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '入库原因: cookie_expired=Cookie过期 short_interval=短期重复通过 nonce_fail=多次验证失败 err_freq=短时错误频繁 asset_missing=资源请求不完整 manual=后台手动',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_ip`(`ip` ASC) USING BTREE,
  INDEX `idx_status_id`(`status` ASC, `id` ASC) USING BTREE,
  INDEX `idx_update_time`(`update_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '爬虫IP库（命中即拦截，白名单优先放行）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_crawler_shared
-- ----------------------------
DROP TABLE IF EXISTS `waf_crawler_shared`;
CREATE TABLE `waf_crawler_shared`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `start_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '段起始 IPv4',
  `end_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '段结束 IPv4（=start_ip 即独立 IP）',
  `start_num` bigint UNSIGNED NOT NULL COMMENT 'start_ip 数值（INET_ATON，区间重叠删除/点查走索引）',
  `end_num` bigint UNSIGNED NOT NULL COMMENT 'end_ip 数值',
  `first_seen` datetime NULL DEFAULT NULL COMMENT '平台侧首次发现时间',
  `source_count` int NOT NULL DEFAULT 1 COMMENT '平台聚合的来源实例数',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '本地启停：1=启用拦截 0=停用',
  `update_time` datetime NULL DEFAULT NULL,
  `last_active` datetime NULL DEFAULT NULL COMMENT '平台侧段级最后活跃时间（活跃度生命周期，引擎每日清理按此淘汰）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_seg`(`start_ip` ASC, `end_ip` ASC) USING BTREE,
  INDEX `idx_range`(`start_num` ASC, `end_num` ASC) USING BTREE,
  INDEX `idx_last_active`(`last_active` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '平台爬虫共享库（只读段存储，来源=platform，契约v2）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for waf_credential_config
-- ----------------------------
DROP TABLE IF EXISTS `waf_credential_config`;
CREATE TABLE `waf_credential_config`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID，0=全局默认，>0=站点级覆盖',
  `rc4_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'RC4加密密钥',
  `cookie_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'waf_challenge' COMMENT '下发凭证Cookie名称',
  `validity` int NOT NULL DEFAULT 30 COMMENT '凭证有效期（分钟）',
  `cookie_scope` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'Cookie作用域（仅站点级有效）',
  `use_global` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否继承全局默认（仅站点级）',
  `factor_salt` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '因子随机串（拼入因子指纹）',
  `factor_ip` tinyint(1) NOT NULL DEFAULT 1 COMMENT '指纹因子：IP',
  `factor_ua` tinyint(1) NOT NULL DEFAULT 1 COMMENT '指纹因子：UA',
  `factor_ja4` tinyint(1) NOT NULL DEFAULT 1 COMMENT '指纹因子：JA4',
  `pass_score` int NOT NULL DEFAULT 80 COMMENT '颁发凭证分数阈值(0~100)',
  `env_weights` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '环境分权重JSON:{\"anchor\":33,\"scr\":6,\"cv\":29,\"ua\":6,\"wgl\":10,\"acf\":10,\"tz\":2,\"lng\":2,\"tp\":2}',
  `tier_sec_low` int NOT NULL DEFAULT 1 COMMENT '低危档等待时长(秒)',
  `tier_sec_med` int NOT NULL DEFAULT 3 COMMENT '中危档等待时长(秒)',
  `tier_sec_high` int NOT NULL DEFAULT 5 COMMENT '高危档等待时长(秒)',
  `min_stay_ms` int NOT NULL DEFAULT 600 COMMENT '最小停留(毫秒,防瞬时脚本)',
  `force_wgl` tinyint(1) NOT NULL DEFAULT 1 COMMENT '强制验证WebGL指纹(wgl)：1=为空直接拒绝并提示；0=为空放行给半权(有值仍必复验)',
  `force_acf` tinyint(1) NOT NULL DEFAULT 1 COMMENT '强制验证音频指纹(acf)：1=为空直接拒绝并提示；0=为空放行给半权(有值仍必复验)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '安全凭证配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_custom_rule
-- ----------------------------
DROP TABLE IF EXISTS `waf_custom_rule`;
CREATE TABLE `waf_custom_rule`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID，0=全局',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `conditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '条件组JSON列表',
  `action` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '动作：block/challenge/redirect/observe',
  `logic` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'and' COMMENT '条件组间逻辑：and/or',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序权重',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_site_status`(`site_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sort`(`sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '自定义规则表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_dedup_stats
-- ----------------------------
DROP TABLE IF EXISTS `waf_dedup_stats`;
CREATE TABLE `waf_dedup_stats`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID（0=全部站点汇总行）',
  `granularity` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'hour' COMMENT 'hour=小时级(留48h) day=天级(留30天)',
  `bucket` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'hour=YYYY-MM-DD-HH；day=YYYY-MM-DD',
  `req_ip_sketch` text CHARACTER SET ascii COLLATE ascii_bin NULL COMMENT '请求IP去重草图（HLL 16384字节的hex，32768字符）',
  `uv_sketch` text CHARACTER SET ascii COLLATE ascii_bin NULL COMMENT '独立访客UV(IP|UA)去重草图（hex）',
  `attack_ip_sketch` text CHARACTER SET ascii COLLATE ascii_bin NULL COMMENT '攻击IP去重草图（hex）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_site_gran_bucket`(`site_id` ASC, `granularity` ASC, `bucket` ASC) USING BTREE,
  INDEX `idx_bucket`(`granularity` ASC, `bucket` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '去重统计表（请求IP/UV/攻击IP 三指标横向 HLL）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_engine_log
-- ----------------------------
DROP TABLE IF EXISTS `waf_engine_log`;
CREATE TABLE `waf_engine_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `level` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '级别：info/warn/error',
  `module` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '模块：tls/proxy/cache等',
  `message` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '日志消息',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '详细内容JSON',
  `count` int NOT NULL DEFAULT 1 COMMENT '重复次数',
  `first_seen` datetime NOT NULL COMMENT '首次出现时间',
  `last_seen` datetime NOT NULL COMMENT '最近出现时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_module_message`(`module` ASC, `message` ASC) USING BTREE,
  INDEX `idx_last_seen`(`last_seen` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '引擎日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_ip_group
-- ----------------------------
DROP TABLE IF EXISTS `waf_ip_group`;
CREATE TABLE `waf_ip_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'IP组名称',
  `type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '类型：cidr/single',
  `ip_list` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'IP/CIDR列表，换行分隔',
  `count` int NOT NULL DEFAULT 0 COMMENT 'IP数量',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'IP组表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_request_dim_stats
-- ----------------------------
DROP TABLE IF EXISTS `waf_request_dim_stats`;
CREATE TABLE `waf_request_dim_stats`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID(0=全局)',
  `time_cutoff` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '小时时间粒度，格式 YYYY-MM-DD-HH',
  `dimension` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '维度枚举：ip/url/ua/referer/host/country/province/status',
  `dim_key_hash` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '维度值定长xxhash(64bit hex)，唯一索引去重键',
  `dim_key` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '维度原值(截断后)，用于展示',
  `count` int NOT NULL DEFAULT 0 COMMENT '该维度该站点该小时的请求数，Upsert 时 SQL 级原子累加',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_site_time_dim_hash`(`site_id` ASC, `time_cutoff` ASC, `dimension` ASC, `dim_key_hash` ASC) USING BTREE,
  INDEX `idx_dim_time_hash_count`(`dimension` ASC, `time_cutoff` ASC, `dim_key_hash` ASC, `count` ASC) USING BTREE,
  INDEX `idx_time_cutoff`(`time_cutoff` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '请求维度统计表(按站点+小时+维度)' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_site
-- ----------------------------
DROP TABLE IF EXISTS `waf_site`;
CREATE TABLE `waf_site`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '站点名称',
  `domains` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '域名，多个逗号分隔',
  `listen_port` int NOT NULL DEFAULT 0 COMMENT '监听端口',
  `upstreams` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '上游服务器JSON数组：[{\"addr\":\"ip:port\",\"weight\":1}]',
  `api_paths` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'API接口路径JSON数组',
  `ssl_enabled` int NOT NULL DEFAULT 0 COMMENT '是否启用SSL：1=是 0=否',
  `cert_path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '证书路径',
  `key_path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '私钥路径',
  `logo_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '站点Logo URL',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '备注',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `log_enable` int NOT NULL DEFAULT 1 COMMENT '是否记录原始日志：1=是 0=否',
  `waf_enable` int NOT NULL DEFAULT 1 COMMENT '是否启用WAF防护：1=是 0=否',
  `defense_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'js' COMMENT '防护方式：js=JS挑战 captcha=人机验证',
  `challenge_template` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'slider' COMMENT '人机验证模板：slider/puzzle/captcha',
  `page_templates` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '按站点页面模板JSON映射：{模板类型:模板ID}，空/0=使用默认模板（仅Pro生效）',
  `js_delay` int NOT NULL DEFAULT 1 COMMENT 'JS挑战时长(秒,1/3/5单选)',
  `upstream_skip_verify` tinyint NOT NULL DEFAULT 0 COMMENT '跳过上游https证书校验 0否 1是(内网自签证书时开)',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `client_ip_mode` tinyint NOT NULL DEFAULT 0 COMMENT '1=取RemoteAddr(默认) 2=取X-Forwarded-For第N个 3=取指定Header',
  `client_ip_index` int NOT NULL DEFAULT 1 COMMENT 'XFF取第几个(1=真实客户端)',
  `client_ip_header` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '指定Header名',
  `upload_paths` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '上传目录(逗号分隔多值,shell文件名校验仅对命中目录深检,空=全局扫)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_listen_port`(`listen_port` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '站点配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_sync_state
-- ----------------------------
DROP TABLE IF EXISTS `waf_sync_state`;
CREATE TABLE `waf_sync_state`  (
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '同步对象名（crawler_shared/cloud_rule）',
  `ver` bigint NOT NULL DEFAULT 0 COMMENT '已同步到的平台版本',
  `update_time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '同步进度版本' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for waf_system_config
-- ----------------------------
DROP TABLE IF EXISTS `waf_system_config`;
CREATE TABLE `waf_system_config`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_timeout` int NOT NULL DEFAULT 3600 COMMENT '会话超时时间（秒）',
  `global_enabled` int NOT NULL DEFAULT 1 COMMENT '全局防护开关：1=开启 0=关闭',
  `raw_log_path` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '原始日志存储目录',
  `heartbeat_interval` int NOT NULL DEFAULT 30 COMMENT '引擎心跳间隔（秒）',
  `ticket_validity` int NOT NULL DEFAULT 300 COMMENT '票据有效期（秒）',
  `waiting_cookie_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'waf_waiting' COMMENT '等候室通行凭证Cookie名',
  `cc_default_threshold` int NOT NULL DEFAULT 100 COMMENT 'CC默认请求次数阈值',
  `cc_default_window` int NOT NULL DEFAULT 60 COMMENT 'CC默认时间窗口（秒）',
  `cc_waiting_max_size` int NOT NULL DEFAULT 1000 COMMENT 'CC等候室最大容量（坐席数）',
  `cc_waiting_floor_rate` int NOT NULL DEFAULT 5 COMMENT '等候室保底放行速率（人/秒）',
  `cc_waiting_pass_rate` int NOT NULL DEFAULT 0 COMMENT '等候室保底放行速率（人/秒）：0=未配置引擎默认5',
  `log_retention_days` int NOT NULL DEFAULT 30 COMMENT '日志保留天数',
  `raw_log_retention_days` int NOT NULL DEFAULT 30 COMMENT '原始日志文件保留天数',
  `disk_clean_threshold` int NOT NULL DEFAULT 80 COMMENT '日志磁盘清理阈值（百分比）',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `waf_url_prefix` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'waf' COMMENT '引擎专属URL前缀，人机/排队等自产接口与静态/上传资源统一挂载其下',
  `challenge_max_sessions` int NOT NULL DEFAULT 50000 COMMENT '挑战会话数量硬上限',
  `zsec_pass_score` int NOT NULL DEFAULT 60 COMMENT '0秒JS挑战评分通过阈值（百分制扣分制，默认60）',
  `legacy_policy` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'guide' COMMENT '老内核访客处置策略：guide=引导升级 / ie_captcha=IE专项验证',
  `cc_site_window` int NOT NULL DEFAULT 1 COMMENT 'CC每站点时间窗口（秒）',
  `cc_site_rate` int NOT NULL DEFAULT 10000 COMMENT 'CC每站点请求速率阈值',
  `attack_log_retention_days` int NOT NULL DEFAULT 30 COMMENT '攻击日志保留天数',
  `audit_log_retention_days` int NOT NULL DEFAULT 30 COMMENT '审计日志保留天数',
  `engine_log_retention_days` int NOT NULL DEFAULT 30 COMMENT '引擎日志保留天数',
  `raw_log_batch_size` int NOT NULL DEFAULT 5000 COMMENT '原始日志批量落盘条数',
  `raw_log_flush_seconds` int NOT NULL DEFAULT 5 COMMENT '原始日志批量落盘间隔（秒）',
  `max_conn` int NOT NULL DEFAULT 10000 COMMENT '站点最大并发连接数',
  `req_timeout` int NOT NULL DEFAULT 30 COMMENT '回源请求超时（秒）',
  `stats_agg_interval` int NOT NULL DEFAULT 5 COMMENT '访问统计数据聚合间隔（秒）',
  `challenge_record_retention_days` int NOT NULL DEFAULT 3 COMMENT '人机验证明细记录保留天数',
  `dim_stats_retention_days` int NOT NULL DEFAULT 30 COMMENT '请求维度统计(request_dim_stats)保留天数',
  `dedup_hour_retention_hours` int NOT NULL DEFAULT 48 COMMENT '去重统计小时行保留小时数（24h视图数据源+天级汇总自愈窗口）',
  `dedup_day_retention_days` int NOT NULL DEFAULT 30 COMMENT '去重统计天级行保留天数（7d/30d视图数据源）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_template
-- ----------------------------
DROP TABLE IF EXISTS `waf_template`;
CREATE TABLE `waf_template`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '模板类型：block/silent_challenge/slider/captcha/puzzle/waiting_room/overload/server_error/ie_captcha',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '模板名称',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'HTML模板内容（Go template语法）',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否默认模板：1=出厂默认（同类型唯一，全局兜底） 0=自定义',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type_status`(`type` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '拦截页面模板表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of waf_template
-- ----------------------------
INSERT INTO `waf_template` VALUES (1, 'block', '拦截页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<title>访问被拦截</title>\n<style>\n*{margin:0;padding:0;box-sizing:border-box}\nbody{font-family:-apple-system,\"Segoe UI\",\"PingFang SC\",\"Microsoft YaHei\",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}\n.box{max-width:400px;width:100%;text-align:center}\n.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}\nh1{font-size:20px;margin-bottom:10px;font-weight:700}\n.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}\n.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}\n.msg.ok{color:#4ade80}\n.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}\n.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}\n.row:last-child{border-bottom:0}\n.row .k{color:#5c6b7d}\n.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}\n.tip{font-size:12px;color:#5c6b7d}\n.tip code{font-family:Consolas,monospace;color:#8b98a9}\n.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}\n.box{max-width:480px;width:100%}.info{margin-top:4px}</style>\n</head>\n<body>\n<div class=\"box\">\n  {{if not .LogoURL}}<div class=\"icon\" style=\"background:rgba(239,68,68,0.12)\"><svg viewBox=\"0 0 24 24\" width=\"38\" height=\"38\" fill=\"none\" stroke=\"#ef4444\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z\"/></svg></div>{{end}}\n  {{if .LogoURL}}<div class=\"logo\"><img src=\"{{.LogoURL}}\" alt=\"logo\"></div>{{end}}\n  <h1>访问已被拦截</h1>\n  <p class=\"desc\">您的请求被网站防护系统拦截，如有疑问请联系站点管理员。</p>\n  <div class=\"info\">\n    <div class=\"row\"><span class=\"k\">站点名称</span><span class=\"v\">{{.SiteName}}</span></div>\n    <div class=\"row\"><span class=\"k\">拦截原因</span><span class=\"v\">{{.Reason}}</span></div>\n    <div class=\"row\"><span class=\"k\">客户端IP</span><span class=\"v\">{{.ClientIP}}</span></div>\n    <div class=\"row\"><span class=\"k\">拦截时间</span><span class=\"v\">{{.Time}}</span></div>\n  </div>\n  <div class=\"tip\" style=\"text-align:center\">请求编号：{{.RequestID}}</div>\n</div>\n<script>\n(function(){\nvar P=(window.__WAF_PREVIEW__===1)||(/[?&]preview=1/.test(window.location.search));\nvar C=window.__c||\'\';\nvar LIVE=(!P)&&!!C&&(C.indexOf(\'{\')<0);\nvar K=\'waf#2026$collect\';\nfunction ep(n){return \'/waf-cha\'+\'llenge/\'+n;}\nfunction post(n,kv,ok,fail){\n  var q=[];\n  for(var k in kv){q.push(encodeURIComponent(k)+\'=\'+encodeURIComponent(kv[k]));}\n  var x=new XMLHttpRequest();\n  x.open(\'POST\',ep(n),true);\n  x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');\n  x.onreadystatechange=function(){\n    if(x.readyState!==4)return;\n    var j=null;try{j=JSON.parse(x.responseText);}catch(e){}\n    if(x.status>=200&&x.status<400&&j){if(ok)ok(j);}else{if(fail)fail();}\n  };\n  x.send(q.join(\'&\'));\n}\nfunction b64x(s){\n  var u=unescape(encodeURIComponent(s)),o=\'\';\n  for(var i=0;i<u.length;i++){o+=String.fromCharCode(u.charCodeAt(i)^K.charCodeAt(i%K.length));}\n  return btoa(o);\n}\nfunction chash(){\n  try{\n    var cv=document.createElement(\'canvas\');cv.width=220;cv.height=40;\n    var g=cv.getContext(\'2d\');\n    g.textBaseline=\'top\';g.font=\'15px Arial\';g.fillStyle=\'#f60\';g.fillRect(0,0,110,20);\n    g.fillStyle=\'#069\';g.fillText(\'WAF~#\\u4e2d\\u6587@258\',2,2);\n    g.fillStyle=\'rgba(102,204,0,0.7)\';g.fillText(\'WAF~#\\u4e2d\\u6587@258\',4,17);\n    var d=cv.toDataURL(),h=0;\n    for(var i=0;i<d.length;i++){h=(h*31+d.charCodeAt(i))|0;}\n    return (h>>>0).toString(16);\n  }catch(e){return \'\';}\n}\nfunction wgl(){\n  try{\n    var cv=document.createElement(\'canvas\');\n    var gl=cv.getContext(\'webgl\')||cv.getContext(\'experimental-webgl\');\n    if(!gl)return [\'\',\'\'];\n    var di=gl.getExtension(\'WEBGL_debug_renderer_info\');\n    return di?[gl.getParameter(di.UNMASKED_VENDOR_WEBGL),gl.getParameter(di.UNMASKED_RENDERER_WEBGL)]:[gl.getParameter(gl.VENDOR),gl.getParameter(gl.RENDERER)];\n  }catch(e){return [\'\',\'\'];}\n}\nfunction collect(){\n  var w=wgl(),n=navigator;\n  return{ua:n.userAgent,lg:n.language,ls:(n.languages||[]).join(\',\'),pl:n.platform,\n    hc:n.hardwareConcurrency||0,dm:n.deviceMemory||0,wd:n.webdriver===true?1:0,\n    sw:screen.width,sh:screen.height,cd:screen.colorDepth,dpr:window.devicePixelRatio||1,\n    tz:(window.Intl&&Intl.DateTimeFormat().resolvedOptions().timeZone)||\'\',tp:n.maxTouchPoints||0,\n    ce:n.cookieEnabled?1:0,pn:(n.plugins||[]).length,ch:window.chrome?1:0,\n    hd:/HeadlessChrome/i.test(n.userAgent)?1:0,ph:(window.callPhantom||window._phantom)?1:0,\n    sl:(window.__nightmare||window.domAutomation||window.domAutomationController)?1:0,\n    np:(window.Notification&&Notification.permission)||\'\',gv:w[0],gr:w[1],cv:chash(),ts:Date.now()};\n}\nfunction report(){\n  if(!LIVE)return;\n  var q=[\'cid=\'+encodeURIComponent(C),\'d=\'+encodeURIComponent(b64x(JSON.stringify(collect())))];\n  try{\n    var x=new XMLHttpRequest();\n    x.open(\'POST\',\'/waf-co\'+\'llect\',true);\n    x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');\n    x.send(q.join(\'&\'));\n  }catch(e){}\n}\nfunction guard(){\n  if(P)return;\n  window.addEventListener(\'keydown\',function(e){\n    var k=e.key;\n    if(k===\'F12\'||k===123||(e.ctrlKey&&e.shiftKey&&(k===\'I\'||k===\'J\'||k===\'C\'))){e.preventDefault();e.stopPropagation();return false;}\n  },true);\n  window.addEventListener(\'contextmenu\',function(e){e.preventDefault();return false;});\n  var win=window;\n  if(window.top!==window&&window.parent&&window.parent.outerWidth)win=window.parent;\n  var hits=0,dead=false;\n  function kill(){\n    if(dead)return;dead=true;\n    try{document.body.innerHTML=\'\';}catch(e){}\n    (function st(){requestAnimationFrame(function(){debugger;requestAnimationFrame(st);});})();\n  }\n  setInterval(function(){\n    var ow=win.outerWidth,iw=win.innerWidth,oh=win.outerHeight,ih=win.innerHeight;\n    if(ow-iw>50||oh-ih>135){hits++;if(hits>=2)kill();}else{hits=0;}\n  },500);\n}\nfunction demo(){\n  var m={\'{{.SiteName}}\':\'官网主站\',\'{{.RequestID}}\':\'Req-20260818-001234\',\'{{.Reason}}\':\'SQL注入特征匹配\',\'{{.ClientIP}}\':\'203.0.113.45\',\'{{.Time}}\':\'2026-08-18 14:30:00\',\'{{.Position}}\':\'12\',\'{{.FrontCount}}\':\'8\'};\n  try{\n    var w=document.createTreeWalker(document.body,4,null,false);\n    while(w.nextNode()){\n      var t=w.currentNode,v=t.nodeValue;\n      if(v&&v.indexOf(\'{\'+\'{\')>-1)t.nodeValue=v.replace(/\\{\\{\\.\\w+\\}\\}/g,function(x){return m[x]||x;});\n    }\n  }catch(e){}\n}\nguard();demo();try{report();}catch(e){}\nSTART(LIVE,C,P,post);\n});\nfunction START(LIVE,C,P,post){}\n</script>\n</body>\n</html>', 1, 1, '2026-08-21 09:02:48', '2026-10-30 00:58:52');
INSERT INTO `waf_template` VALUES (2, 'silent_challenge', '静默JS挑战页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<script>(function(){var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement(\'canvas\').getContext(\'2d\');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(ok)return;try{var x=new XMLHttpRequest();x.open(\'POST\',\'/{{.WafUrlPrefix}}/challenge/legacy?rid={{.RequestID}}\',true);x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');x.onreadystatechange=function(){if(x.readyState!==4)return;try{var j=JSON.parse(x.responseText);if(j&&j.code===200){if(j.action===\'ie_captcha\'){location.reload();return;}if(j.url&&j.url.charAt(0)===\'/\'&&j.url.charAt(1)!==\'/\')location.replace(j.url);}}catch(e){}};x.send(\'back=\'+encodeURIComponent(location.pathname+location.search));}catch(e){}})();</script>\n<title>安全验证</title>\n<style>\n*{margin:0;padding:0;box-sizing:border-box}\nbody{font-family:-apple-system,\"Segoe UI\",\"PingFang SC\",\"Microsoft YaHei\",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}\n.box{max-width:400px;width:100%;text-align:center}\n.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}\nh1{font-size:20px;margin-bottom:10px;font-weight:700}\n.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}\n.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}\n.msg.ok{color:#4ade80}\n.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}\n.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}\n.row:last-child{border-bottom:0}\n.row .k{color:#5c6b7d}\n.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}\n.tip{font-size:12px;color:#5c6b7d}\n.tip code{font-family:Consolas,monospace;color:#8b98a9}\n.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}\n.box{max-width:360px}\n.spin{width:56px;height:56px;margin:0 auto 18px;border:3px solid rgba(251,191,36,0.15);border-top-color:#fbbf24;border-radius:50%;animation:rot 1s linear infinite}\n@keyframes rot{to{transform:rotate(360deg)}}\n.okmark{display:none;width:56px;height:56px;margin:0 auto 18px;border-radius:50%;background:rgba(34,197,94,0.15);align-items:center;justify-content:center}\n</style>\n</head>\n<body>\n<div class=\"box\">\n  <div class=\"spin\" id=\"spin\"></div>\n  <div class=\"okmark\" id=\"okMark\"><svg viewBox=\"0 0 24 24\" width=\"30\" height=\"30\" fill=\"none\" stroke=\"#4ade80\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"20 6 9 17 4 12\"/></svg></div>\n  {{if .LogoURL}}<div class=\"logo\"><img src=\"{{.LogoURL}}\" alt=\"logo\"></div>{{end}}\n  <h1 id=\"title\">正在安全验证</h1>\n  <p class=\"desc\" id=\"desc\">请稍候，系统正在验证您的浏览器环境...</p>\n  <!-- 加载缓慢提示：老设备/网络差时资源加载慢一直被转圈，易被误当成\"WAF挂了\"。满6秒仍未完成验证就亮出该卡片。\n       主题自适应：改下方 --sh-* 三个变量即可适配浅色/深色模板（琥珀色强调在明暗背景下均清晰）。\n       仅改显示，不影响主验证流程；验证通过 $ok() 会把 #spin 隐藏，此卡片不会出现。#slowHint 默认隐藏。 -->\n  <style>\n  .slowhint{--sh-bg:rgba(251,191,36,.08);--sh-hi:#fbbf24;--sh-ln:rgba(251,191,36,.4);display:none;align-items:flex-start;gap:10px;text-align:left;margin:0 0 16px;padding:12px 14px 12px 11px;background:var(--sh-bg);border:1px solid var(--sh-ln);border-left:3px solid var(--sh-hi);border-radius:8px;animation:shp 1.6s ease-in-out infinite}\n  .slowhint.on{display:flex}\n  @keyframes shp{0%,100%{border-color:var(--sh-ln);box-shadow:0 0 0 0 rgba(251,191,36,0)}50%{border-color:var(--sh-hi);box-shadow:0 0 0 3px rgba(251,191,36,.14)}}\n  .slowhint-ic{flex:0 0 auto;width:20px;height:20px;margin-top:1px;border-radius:50%;background:var(--sh-hi);color:#1b2128;font-weight:700;font-size:13px;display:flex;align-items:center;justify-content:center}\n  .slowhint-t{font-weight:600;font-size:13px;color:inherit;margin-bottom:2px}\n  .slowhint-d{font-size:12px;color:inherit;opacity:.75;line-height:1.6}\n  </style>\n  <div class=\"slowhint\" id=\"slowHint\">\n    <span class=\"slowhint-ic\">!</span>\n    <div>\n      <div class=\"slowhint-t\">检测到加载缓慢</div>\n      <div class=\"slowhint-d\">当前网络较差或设备 CPU、内存占用较高，导致验证资源加载缓慢。若长时间无法通过，请手动刷新页面后再试。</div>\n    </div>\n  </div>\n  <script>\n  (function(){try{var s=document.getElementById(\'spin\'),h=document.getElementById(\'slowHint\');if(!s||!h)return;window.setTimeout(function(){try{if(getComputedStyle(s).display===\'none\')return;h.className=\'slowhint on\';}catch(e){}},6000);}catch(e){}})();\n  </script>\n  <div class=\"info\">\n    <div class=\"row\"><span class=\"k\">站点名称</span><span class=\"v\">{{.SiteName}}</span></div>\n    <div class=\"row\"><span class=\"k\">触发时间</span><span class=\"v\">{{.Time}}</span></div>\n  </div>\n  <div class=\"tip\">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>\n</div>\n<script>\nwindow.__APP = {\n  a: \'{{.RequestID}}\',\n  b: \'{{.Nonce}}\',\n  p: { h:\'{{.PoWChallenge}}\', b:{{.PoWDifficulty}} },\n  u: \'{{.WafUrlPrefix}}\',\n};\n</script>\n<script>\n(function () {\n  var app = window.__APP;\n  var q=\'?reqID=\'+encodeURIComponent((app&&app.a)||\'\')+\'&v=\'+Math.floor(Math.random()*99999);\n  var s=document.createElement(\'script\');\n  s.src=\'/\'+(app&&app.u||\'waf\')+\'/assets/tongji/1.js\'+q;\n  document.head.appendChild(s);\n})();\n</script>\n</body>\n</html>', 1, 1, '2026-08-21 09:02:48', '2026-10-30 00:59:02');
INSERT INTO `waf_template` VALUES (3, 'slider', '滑块验证页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<script>(function(){var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement(\'canvas\').getContext(\'2d\');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(ok)return;try{var x=new XMLHttpRequest();x.open(\'POST\',\'/{{.WafUrlPrefix}}/challenge/legacy?rid={{.RequestID}}\',true);x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');x.onreadystatechange=function(){if(x.readyState!==4)return;try{var j=JSON.parse(x.responseText);if(j&&j.code===200){if(j.action===\'ie_captcha\'){location.reload();return;}if(j.url&&j.url.charAt(0)===\'/\'&&j.url.charAt(1)!==\'/\')location.replace(j.url);}}catch(e){}};x.send(\'back=\'+encodeURIComponent(location.pathname+location.search));}catch(e){}})();</script>\n<title>人机验证</title>\n<style>\n*{margin:0;padding:0;box-sizing:border-box}\nbody{font-family:-apple-system,\"Segoe UI\",\"PingFang SC\",\"Microsoft YaHei\",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}\n.box{max-width:400px;width:100%;text-align:center}\n.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}\nh1{font-size:20px;margin-bottom:10px;font-weight:700}\n.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}\n.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}\n.msg.ok{color:#4ade80}\n.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}\n.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}\n.row:last-child{border-bottom:0}\n.row .k{color:#5c6b7d}\n.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}\n.tip{font-size:12px;color:#5c6b7d}\n.tip code{font-family:Consolas,monospace;color:#8b98a9}\n.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}\n.slider-box{width:100%;height:48px;background:#1e293b;border:1px solid #334155;border-radius:24px;position:relative;overflow:hidden;margin-bottom:6px;touch-action:none;user-select:none;-webkit-user-select:none}\n.slider-track{position:absolute;left:0;top:0;height:100%;background:linear-gradient(90deg,rgba(139,92,246,0.2),rgba(139,92,246,0.4));border-radius:24px;width:0}\n.slider-track.ok{background:linear-gradient(90deg,rgba(34,197,94,0.3),rgba(34,197,94,0.55))}\n.slider-btn{position:absolute;top:4px;left:4px;width:40px;height:40px;background:linear-gradient(135deg,#8b5cf6,#6d28d9);border-radius:50%;display:flex;align-items:center;justify-content:center;cursor:grab;color:#fff}\n.slider-btn:active{cursor:grabbing}\n.slider-btn.ok{background:linear-gradient(135deg,#22c55e,#16a34a)}\n.slider-text{position:absolute;left:0;top:0;width:100%;height:100%;display:flex;align-items:center;justify-content:center;font-size:12px;color:#64748b;pointer-events:none}\n</style>\n</head>\n<body>\n<div class=\"box\">\n  {{if not .LogoURL}}<div class=\"icon\" id=\"iconBox\" style=\"background:rgba(139,92,246,0.12)\"><svg viewBox=\"0 0 24 24\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#8b5cf6\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"18 8 22 12 18 16\"/><polyline points=\"6 8 2 12 6 16\"/><line x1=\"2\" y1=\"12\" x2=\"22\" y2=\"12\"/></svg></div>{{end}}\n  {{if .LogoURL}}<div class=\"logo\"><img src=\"{{.LogoURL}}\" alt=\"logo\"></div>{{end}}\n  <h1>请完成验证</h1>\n  <p class=\"desc\">拖动滑块完成验证，确认您是正常用户。</p>\n  <div class=\"slider-box\" id=\"slBox\">\n    <div class=\"slider-track\" id=\"slTrack\"></div>\n    <div class=\"slider-text\" id=\"slText\">拖动滑块验证</div>\n    <div class=\"slider-btn\" id=\"slBtn\"><svg viewBox=\"0 0 24 24\" width=\"16\" height=\"16\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"18 8 22 12 18 16\"/><polyline points=\"6 8 2 12 6 16\"/><line x1=\"2\" y1=\"12\" x2=\"22\" y2=\"12\"/></svg></div>\n  </div>\n  <div class=\"msg\" id=\"msg\"></div>\n  <div class=\"info\">\n    <div class=\"row\"><span class=\"k\">站点名称</span><span class=\"v\">{{.SiteName}}</span></div>\n    <div class=\"row\"><span class=\"k\">触发时间</span><span class=\"v\">{{.Time}}</span></div>\n  </div>\n  <div class=\"tip\">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>\n</div>\n<script>\nwindow.__APP = {\n  a: \'{{.RequestID}}\',\n  b: \'{{.Nonce}}\',\n  p: { h:\'{{.PoWChallenge}}\', b:{{.PoWDifficulty}} },\n  u: \'{{.WafUrlPrefix}}\',\n};\n</script>\n<script>\n(function () {\n  var app = window.__APP;\n  var q=\'?reqID=\'+encodeURIComponent((app&&app.a)||\'\')+\'&v=\'+Math.floor(Math.random()*99999);\n  var s=document.createElement(\'script\');\n  s.src=\'/\'+(app&&app.u||\'waf\')+\'/assets/tongji/2.js\'+q;\n  document.head.appendChild(s);\n})();\n</script>\n</body>\n</html>', 1, 1, '2026-08-21 09:02:48', '2026-10-30 00:59:10');
INSERT INTO `waf_template` VALUES (4, 'captcha', '图形验证码页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<script>(function(){var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement(\'canvas\').getContext(\'2d\');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(ok)return;try{var x=new XMLHttpRequest();x.open(\'POST\',\'/{{.WafUrlPrefix}}/challenge/legacy?rid={{.RequestID}}\',true);x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');x.onreadystatechange=function(){if(x.readyState!==4)return;try{var j=JSON.parse(x.responseText);if(j&&j.code===200){if(j.action===\'ie_captcha\'){location.reload();return;}if(j.url&&j.url.charAt(0)===\'/\'&&j.url.charAt(1)!==\'/\')location.replace(j.url);}}catch(e){}};x.send(\'back=\'+encodeURIComponent(location.pathname+location.search));}catch(e){}})();</script>\n<title>人机验证</title>\n<style>\n*{margin:0;padding:0;box-sizing:border-box}\nbody{font-family:-apple-system,\"Segoe UI\",\"PingFang SC\",\"Microsoft YaHei\",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}\n.box{max-width:400px;width:100%;text-align:center}\n.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}\nh1{font-size:20px;margin-bottom:10px;font-weight:700}\n.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}\n.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}\n.msg.ok{color:#4ade80}\n.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}\n.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}\n.row:last-child{border-bottom:0}\n.row .k{color:#5c6b7d}\n.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}\n.tip{font-size:12px;color:#5c6b7d}\n.tip code{font-family:Consolas,monospace;color:#8b98a9}\n.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}\n.captcha-box{width:100%;background:#1e293b;border:1px solid #334155;border-radius:10px;padding:16px;margin-bottom:14px}\n.code-img{width:160px;height:52px;margin:0 auto 12px;display:block;cursor:pointer}\n.code-img img{width:100%;height:100%;border-radius:6px;object-fit:cover;display:block;border:1px solid #334155}\n.captcha-input-row{display:flex;gap:8px}\n.form-input{flex:1;background:#0f172a;border:1px solid #334155;border-radius:8px;color:#e6edf3;font-size:15px;letter-spacing:4px;text-align:center;padding:10px;outline:none;font-family:inherit}\n.form-input:focus{border-color:#22c55e}\n.form-input.err{border-color:#ef4444;animation:shake .4s}\n@keyframes shake{0%,100%{transform:translateX(0)}25%{transform:translateX(-6px)}75%{transform:translateX(6px)}}\n.captcha-refresh{width:44px;height:44px;flex-shrink:0;background:#1e293b;border:1px solid #334155;border-radius:8px;color:#8b98a9;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all .15s}\n.captcha-refresh:hover{color:#4ade80;border-color:#22c55e}\n.captcha-refresh.busy svg{animation:spin .8s linear infinite}\n@keyframes spin{to{transform:rotate(360deg)}}\n.ver-btn{width:100%;background:linear-gradient(135deg,#22c55e,#16a34a);color:#fff;border:0;padding:12px;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer;transition:opacity .2s;font-family:inherit;display:flex;align-items:center;justify-content:center;gap:6px}\n.ver-btn:hover{opacity:.9}\n.ver-btn:disabled{opacity:.6;cursor:not-allowed}\n.ver-btn.ok{background:linear-gradient(135deg,#16a34a,#15803d)}\n</style>\n</head>\n<body>\n<div class=\"box\">\n  {{if not .LogoURL}}<div class=\"icon\" id=\"iconBox\" style=\"background:rgba(34,197,94,0.12)\"><svg viewBox=\"0 0 24 24\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#22c55e\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect x=\"3\" y=\"3\" width=\"18\" height=\"18\" rx=\"2\" ry=\"2\"/><circle cx=\"8.5\" cy=\"8.5\" r=\"1.5\"/><polyline points=\"21 15 16 10 5 21\"/></svg></div>{{end}}\n  {{if .LogoURL}}<div class=\"logo\"><img src=\"{{.LogoURL}}\" alt=\"logo\"></div>{{end}}\n  <h1>请完成验证</h1>\n  <p class=\"desc\">请输入图形中的字符，确认您是正常用户。</p>\n  <div class=\"captcha-box\">\n    <div class=\"code-img\" id=\"capImgWrap\" title=\"点击刷新\"><img id=\"capImg\" alt=\"captcha\"></div>\n    <div class=\"captcha-input-row\">\n      <input type=\"text\" class=\"form-input\" id=\"codeInput\" placeholder=\"请输入验证码\" maxlength=\"4\" autocomplete=\"off\" autocapitalize=\"off\">\n      <button class=\"captcha-refresh\" id=\"refreshBtn\" title=\"换一张\" type=\"button\"><svg viewBox=\"0 0 24 24\" width=\"16\" height=\"16\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"23 4 23 10 17 10\"/><polyline points=\"1 20 1 14 7 14\"/><path d=\"M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15\"/></svg></button>\n    </div>\n  </div>\n  <button class=\"ver-btn\" id=\"verifyBtn\" type=\"button\"><svg viewBox=\"0 0 24 24\" width=\"14\" height=\"14\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"20 6 9 17 4 12\"/></svg> 验证</button>\n  <div class=\"msg\" id=\"msg\"></div>\n  <div class=\"info\">\n    <div class=\"row\"><span class=\"k\">站点名称</span><span class=\"v\">{{.SiteName}}</span></div>\n    <div class=\"row\"><span class=\"k\">触发时间</span><span class=\"v\">{{.Time}}</span></div>\n  </div>\n  <div class=\"tip\">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>\n</div>\n\n<script>\nwindow.__APP = {\n  a: \'{{.RequestID}}\',\n  b: \'{{.Nonce}}\',\n  p: { h:\'{{.PoWChallenge}}\', b:{{.PoWDifficulty}} },\n  u: \'{{.WafUrlPrefix}}\'\n};\n</script>\n<script>\n(function () {\n  var app = window.__APP;\n  var q=\'?reqID=\'+encodeURIComponent((app&&app.a)||\'\')+\'&v=\'+Math.floor(Math.random()*99999);\n  var s=document.createElement(\'script\');\n  s.src=\'/\'+(app&&app.u||\'waf\')+\'/assets/tongji/4.js\'+q;\n  document.head.appendChild(s);\n})();\n</script>\n</body>\n</html>', 1, 1, '2026-08-21 09:02:48', '2026-10-30 00:59:17');
INSERT INTO `waf_template` VALUES (5, 'puzzle', '拼图验证页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<script>(function(){var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement(\'canvas\').getContext(\'2d\');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(ok)return;try{var x=new XMLHttpRequest();x.open(\'POST\',\'/{{.WafUrlPrefix}}/challenge/legacy?rid={{.RequestID}}\',true);x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');x.onreadystatechange=function(){if(x.readyState!==4)return;try{var j=JSON.parse(x.responseText);if(j&&j.code===200){if(j.action===\'ie_captcha\'){location.reload();return;}if(j.url&&j.url.charAt(0)===\'/\'&&j.url.charAt(1)!==\'/\')location.replace(j.url);}}catch(e){}};x.send(\'back=\'+encodeURIComponent(location.pathname+location.search));}catch(e){}})();</script>\n<title>人机验证</title>\n<style>\n*{margin:0;padding:0;box-sizing:border-box}\nbody{font-family:-apple-system,\"Segoe UI\",\"PingFang SC\",\"Microsoft YaHei\",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}\n.box{max-width:400px;width:100%;text-align:center}\n.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}\nh1{font-size:20px;margin-bottom:10px;font-weight:700}\n.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}\n.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}\n.msg.ok{color:#4ade80}\n.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}\n.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}\n.row:last-child{border-bottom:0}\n.row .k{color:#5c6b7d}\n.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}\n.tip{font-size:12px;color:#5c6b7d}\n.tip code{font-family:Consolas,monospace;color:#8b98a9}\n.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}\n/* 拼图几何与引擎一致：底图364x204、拼图块44x44、缺口Y=78（固定）。拼块图为引擎裁出的独立44x44图，居中显示无需偏移 */\n.puzz-panel{position:relative;width:364px;height:204px;margin:0 auto 14px;border:1px solid #334155;border-radius:8px;overflow:hidden;background:#0f172a;touch-action:none;user-select:none;-webkit-user-select:none}\n.puzz-bg{position:absolute;left:0;top:0;width:364px;height:204px;pointer-events:none}\n.puzz-piece{position:absolute;left:0;top:78px;width:44px;height:44px;background-repeat:no-repeat;background-position:center;background-size:100% 100%;box-shadow:0 2px 10px rgba(0,0,0,0.5);pointer-events:none}\n.puzz-piece.ok{outline:2px solid #22c55e;outline-offset:-2px}\n.slider-box{width:100%;height:48px;background:#1e293b;border:1px solid #334155;border-radius:24px;position:relative;overflow:hidden;margin-bottom:6px;touch-action:none;user-select:none;-webkit-user-select:none}\n.slider-track{position:absolute;left:0;top:0;height:100%;background:linear-gradient(90deg,rgba(139,92,246,0.2),rgba(139,92,246,0.4));border-radius:24px;width:0}\n.slider-track.ok{background:linear-gradient(90deg,rgba(34,197,94,0.3),rgba(34,197,94,0.55))}\n.slider-btn{position:absolute;top:4px;left:4px;width:40px;height:40px;background:linear-gradient(135deg,#8b5cf6,#6d28d9);border-radius:50%;display:flex;align-items:center;justify-content:center;cursor:grab;color:#fff}\n.slider-btn:active{cursor:grabbing}\n.slider-btn.ok{background:linear-gradient(135deg,#22c55e,#16a34a)}\n.slider-text{position:absolute;left:0;top:0;width:100%;height:100%;display:flex;align-items:center;justify-content:center;font-size:12px;color:#64748b;pointer-events:none}\n</style>\n</head>\n<body>\n<div class=\"box\">\n  {{if not .LogoURL}}<div class=\"icon\" id=\"iconBox\" style=\"background:rgba(139,92,246,0.12)\"><svg viewBox=\"0 0 24 24\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#8b5cf6\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"18 8 22 12 18 16\"/><polyline points=\"6 8 2 12 6 16\"/><line x1=\"2\" y1=\"12\" x2=\"22\" y2=\"12\"/></svg></div>{{end}}\n  {{if .LogoURL}}<div class=\"logo\"><img src=\"{{.LogoURL}}\" alt=\"logo\"></div>{{end}}\n  <h1>请完成验证</h1>\n  <p class=\"desc\">拖动下方滑块，将拼图块对准缺口位置，完成验证。</p>\n  <div class=\"puzz-panel\" id=\"panel\">\n    <img class=\"puzz-bg\" id=\"bg\" alt=\"puzzle\">\n    <div class=\"puzz-piece\" id=\"piece\"></div>\n  </div>\n  <div class=\"slider-box\" id=\"slBox\">\n    <div class=\"slider-track\" id=\"slTrack\"></div>\n    <div class=\"slider-text\" id=\"slText\">拖动滑块，对准缺口</div>\n    <div class=\"slider-btn\" id=\"slBtn\"><svg viewBox=\"0 0 24 24\" width=\"16\" height=\"16\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"18 8 22 12 18 16\"/><polyline points=\"6 8 2 12 6 16\"/><line x1=\"2\" y1=\"12\" x2=\"22\" y2=\"12\"/></svg></div>\n  </div>\n  <div class=\"msg\" id=\"msg\"></div>\n  <div class=\"info\">\n    <div class=\"row\"><span class=\"k\">站点名称</span><span class=\"v\">{{.SiteName}}</span></div>\n    <div class=\"row\"><span class=\"k\">触发时间</span><span class=\"v\">{{.Time}}</span></div>\n  </div>\n  <div class=\"tip\">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>\n</div>\n\n<script>\nwindow.__APP = {\n  a: \'{{.RequestID}}\',\n  b: \'{{.Nonce}}\',\n  p: { h:\'{{.PoWChallenge}}\', b:{{.PoWDifficulty}} },\n  u: \'{{.WafUrlPrefix}}\'\n};\n</script>\n<script>\n(function () {\n  var app = window.__APP;\n  var q=\'?reqID=\'+encodeURIComponent((app&&app.a)||\'\')+\'&v=\'+Math.floor(Math.random()*99999);\n  var s=document.createElement(\'script\');\n  s.src=\'/\'+(app&&app.u||\'waf\')+\'/assets/tongji/3.js\'+q;\n  document.head.appendChild(s);\n})();\n</script>\n</body>\n</html>', 1, 1, '2026-08-21 09:02:48', '2026-10-30 00:59:25');
INSERT INTO `waf_template` VALUES (6, 'waiting_room', '等候室排队页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<title>排队等候</title>\n<style>\n*{margin:0;padding:0;box-sizing:border-box}\nbody{font-family:-apple-system,\"Segoe UI\",\"PingFang SC\",\"Microsoft YaHei\",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}\n.box{max-width:400px;width:100%;text-align:center}\n.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}\nh1{font-size:20px;margin-bottom:10px;font-weight:700}\n.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}\n.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}\n.msg.ok{color:#4ade80}\n.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}\n.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}\n.row:last-child{border-bottom:0}\n.row .k{color:#5c6b7d}\n.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}\n.tip{font-size:12px;color:#5c6b7d}\n.tip code{font-family:Consolas,monospace;color:#8b98a9}\n.logo{text-align:center;margin-bottom:16px}\n.logo img{max-width:120px;max-height:48px;border-radius:4px}\n.box{max-width:400px}\n.queue-card{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:12px;padding:22px 18px;margin-bottom:16px}\n.queue-pos{font-size:44px;font-weight:700;color:#60a5fa;line-height:1.1;margin-bottom:4px}\n.queue-sub{font-size:12px;color:#8b98a9;margin-bottom:16px}\n.qbar{height:6px;background:#1e293b;border-radius:3px;overflow:hidden}\n.qbar i{display:block;height:100%;background:linear-gradient(90deg,#3b82f6,#60a5fa);border-radius:3px;transition:width .6s}\n.qrow{display:flex;justify-content:space-between;font-size:12px;color:#5c6b7d;margin-top:10px}\n</style>\n</head>\n<body>\n<div class=\"box\">\n  {{if not .LogoURL}}<div class=\"icon\" style=\"background:rgba(96,165,250,0.12)\"><svg viewBox=\"0 0 24 24\" width=\"28\" height=\"28\" fill=\"none\" stroke=\"#60a5fa\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"12\" cy=\"12\" r=\"10\"/><polyline points=\"12 6 12 12 16 14\"/></svg></div>{{end}}\n  {{if .LogoURL}}<div class=\"logo\"><img src=\"{{.LogoURL}}\" alt=\"logo\"></div>{{end}}\n  <h1>排队等候中</h1>\n  <p class=\"desc\">{{.QueueReason}}，您已进入等候室，页面将自动刷新。</p>\n  <div class=\"queue-card\">\n    <div class=\"queue-pos\" id=\"queuePos\">{{.Position}}</div>\n    <div class=\"queue-sub\">您的排队序号</div>\n    <div class=\"qbar\"><i style=\"width:35%\"></i></div>\n    <div class=\"qrow\"><span>前方 <b id=\"queueFront\">{{.FrontCount}}</b> 人</span><span>预计稍候</span></div>\n  </div>\n  <div class=\"info\">\n    <div class=\"row\"><span class=\"k\">站点名称</span><span class=\"v\">{{.SiteName}}</span></div>\n    <div class=\"row\"><span class=\"k\">触发时间</span><span class=\"v\">{{.Time}}</span></div>\n  </div>\n  <div class=\"tip\">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>\n</div>\n<script>window.__q=\'{{.QueueID}}\';</script>\n<script>\n(function(){\nvar P=(window.__WAF_PREVIEW__===1)||(/[?&]preview=1/.test(window.location.search));\nvar C=window.__c||\'\';\nvar LIVE=(!P)&&!!C&&(C.indexOf(\'{\')<0);\nvar K=\'waf#2026$collect\';\nfunction ep(n){return \'/\'+\'{{.WafUrlPrefix}}\'+\'/challenge/\'+n;}\nfunction post(n,kv,ok,fail){\n  var q=[];\n  for(var k in kv){q.push(encodeURIComponent(k)+\'=\'+encodeURIComponent(kv[k]));}\n  var x=new XMLHttpRequest();\n  x.open(\'POST\',ep(n),true);\n  x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');\n  x.onreadystatechange=function(){\n    if(x.readyState!==4)return;\n    var j=null;try{j=JSON.parse(x.responseText);}catch(e){}\n    if(x.status>=200&&x.status<400&&j){if(ok)ok(j);}else{if(fail)fail();}\n  };\n  x.send(q.join(\'&\'));\n}\nfunction b64x(s){\n  var u=unescape(encodeURIComponent(s)),o=\'\';\n  for(var i=0;i<u.length;i++){o+=String.fromCharCode(u.charCodeAt(i)^K.charCodeAt(i%K.length));}\n  return btoa(o);\n}\nfunction chash(){\n  try{\n    var cv=document.createElement(\'canvas\');cv.width=220;cv.height=40;\n    var g=cv.getContext(\'2d\');\n    g.textBaseline=\'top\';g.font=\'15px Arial\';g.fillStyle=\'#f60\';g.fillRect(0,0,110,20);\n    g.fillStyle=\'#069\';g.fillText(\'WAF~#u4e2du6587@258\',2,2);\n    g.fillStyle=\'rgba(102,204,0,0.7)\';g.fillText(\'WAF~#u4e2du6587@258\',4,17);\n    var d=cv.toDataURL(),h=0;\n    for(var i=0;i<d.length;i++){h=(h*31+d.charCodeAt(i))|0;}\n    return (h>>>0).toString(16);\n  }catch(e){return \'\';}\n}\nfunction wgl(){\n  try{\n    var cv=document.createElement(\'canvas\');\n    var gl=cv.getContext(\'webgl\')||cv.getContext(\'experimental-webgl\');\n    if(!gl)return [\'\',\'\'];\n    var di=gl.getExtension(\'WEBGL_debug_renderer_info\');\n    return di?[gl.getParameter(di.UNMASKED_VENDOR_WEBGL),gl.getParameter(di.UNMASKED_RENDERER_WEBGL)]:[gl.getParameter(gl.VENDOR),gl.getParameter(gl.RENDERER)];\n  }catch(e){return [\'\',\'\']}\n}\nfunction collect(){\n  var w=wgl(),n=navigator;\n  return{ua:n.userAgent,lg:n.language,ls:(n.languages||[]).join(\',\'),pl:n.platform,hc:n.hardwareConcurrency||0,dm:n.deviceMemory||0,wd:n.webdriver===true?1:0,sw:screen.width,sh:screen.height,cd:screen.colorDepth,dpr:window.devicePixelRatio||1,tz:(window.Intl&&Intl.DateTimeFormat().resolvedOptions().timeZone)||\'\',tp:n.maxTouchPoints||0,ce:n.cookieEnabled?1:0,pn:(n.plugins||[]).length,ch:window.chrome?1:0,hd:/HeadlessChrome/i.test(n.userAgent)?1:0,ph:(window.callPhantom||window._phantom)?1:0,sl:(window.__nightmare||window.domAutomation||window.domAutomationController)?1:0,np:(window.Notification&&Notification.permission)||\'\',gv:w[0],gr:w[1],cv:chash(),ts:Date.now()};\n}\nfunction report(){\n  if(!LIVE)return;\n  var q=[\'cid=\'+encodeURIComponent(C),\'d=\'+encodeURIComponent(b64x(JSON.stringify(collect())))];\n  try{\n    var x=new XMLHttpRequest();\n    x.open(\'POST\',\'/\'+\'{{.WafUrlPrefix}}\'+\'/collect\',true);\n    x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');\n    x.send(q.join(\'&\'));\n  }catch(e){}\n}\nfunction guard(){\n  if(P)return;\n  window.addEventListener(\'keydown\',function(e){\n    var k=e.key;\n    if(k===\'F12\'||k===123||(e.ctrlKey&&e.shiftKey&&(k===\'I\'||k===\'J\'||k===\'C\'))){e.preventDefault();e.stopPropagation();return false;}\n  },true);\n  window.addEventListener(\'contextmenu\',function(e){e.preventDefault();return false;});\n  var win=window;\n  if(window.top!==window&&window.parent&&window.parent.outerWidth)win=window.parent;\n  var hits=0,dead=false;\n  function kill(){\n    if(dead)return;dead=true;\n    try{document.body.innerHTML=\'\';}catch(e){}\n    (function st(){requestAnimationFrame(function(){debugger;requestAnimationFrame(st);});})();\n  }\n  setInterval(function(){\n    var ow=win.outerWidth,iw=win.innerWidth,oh=win.outerHeight,ih=win.innerHeight;\n    if(ow-iw>50||oh-ih>135){hits++;if(hits>=2)kill();}else{hits=0;}\n  },500);\n}\nfunction demo(){\n  var m={\'{{.SiteName}}\':\'官网主站\',\'{{.RequestID}}\':\'Req-20260818-001234\',\'{{.Reason}}\':\'SQL注入特征匹配\',\'{{.ClientIP}}\':\'203.0.113.45\',\'{{.Time}}\':\'2026-08-18 14:30:00\',\'{{.Position}}\':\'12\',\'{{.QueueReason}}\':\'应用级访问阈值\'};\n  try{\n    var w=document.createTreeWalker(document.body,4,null,false);\n    while(w.nextNode()){\n      var t=w.currentNode,v=t.nodeValue;\n      if(v&&v.indexOf(\'{\'+ \'{\')>-1)t.nodeValue=v.replace(/\\{\\{\\.\\w+\\}\\}/g,function(x){return m[x]||x;});\n    }\n  }catch(e){}\n}\nguard();demo();try{report();}catch(e){}\nSTART(LIVE,C,P,post);\n})();\nfunction START(LIVE,C,P,post){\n  var q=window.__q;\n  if(!q)return;\n  var pos=document.getElementById(\'queuePos\'),front=document.getElementById(\'queueFront\');\n  function poll(){\n    var xhr=new XMLHttpRequest();\n    xhr.open(\'GET\',\'/\'+\'{{.WafUrlPrefix}}\'+\'/waiting/status?queue_id=\'+encodeURIComponent(q),true);\n    xhr.onload=function(){\n      if(xhr.status!==200){setTimeout(poll,1000);return;}\n      var j;\n      try{j=JSON.parse(xhr.responseText);}catch(e){setTimeout(poll,1000);return;}\n      if(j&&j.code===200&&j.ready){window.location.reload();return;}\n      if(j&&typeof j.position===\'number\'){\n        if(pos)pos.textContent=j.position;\n        if(front)front.textContent=j.position;\n      }\n      setTimeout(poll,1000);\n    };\n    xhr.onerror=function(){setTimeout(poll,1000);};\n    xhr.send();\n  }\n  setTimeout(poll,500);\n}\n</script>\n</body>\n</html>', 1, 1, '2026-08-21 09:02:48', '2026-10-30 00:59:32');
INSERT INTO `waf_template` VALUES (7, 'overload', '过载拦截页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<title>服务繁忙</title>\n<style>\n*{margin:0;padding:0;box-sizing:border-box}\nbody{font-family:-apple-system,\"Segoe UI\",\"PingFang SC\",\"Microsoft YaHei\",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}\n.box{max-width:400px;width:100%;text-align:center}\n.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}\nh1{font-size:20px;margin-bottom:10px;font-weight:700}\n.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}\n.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}\n.msg.ok{color:#4ade80}\n.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}\n.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}\n.row:last-child{border-bottom:0}\n.row .k{color:#5c6b7d}\n.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}\n.tip{font-size:12px;color:#5c6b7d}\n.tip code{font-family:Consolas,monospace;color:#8b98a9}\n.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}\n</style>\n</head>\n<body>\n<div class=\"box\" style=\"max-width:480px\">\n  {{if not .LogoURL}}<div class=\"icon\" style=\"width:84px;height:84px;background:rgba(251,191,36,0.12)\"><svg viewBox=\"0 0 24 24\" width=\"38\" height=\"38\" fill=\"none\" stroke=\"#fbbf24\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2\"/><circle cx=\"9\" cy=\"7\" r=\"4\"/><path d=\"M23 21v-2a4 4 0 0 0-3-3.87\"/><path d=\"M16 3.13a4 4 0 0 1 0 7.75\"/></svg></div>{{end}}\n  {{if .LogoURL}}<div class=\"logo\"><img src=\"{{.LogoURL}}\" alt=\"logo\"></div>{{end}}\n  <h1 style=\"font-size:22px\">服务繁忙，请稍后再试</h1>\n  <p class=\"desc\">当前排队人数已达上限，您暂时无法进入等候室。<br>请稍后重新访问，给您带来不便敬请谅解。</p>\n  <div class=\"info\">\n<div class=\"row\"><span class=\"k\">站点名称</span><span class=\"v\">{{.SiteName}}</span></div>\n    <div class=\"row\"><span class=\"k\">触发时间</span><span class=\"v\">{{.Time}}</span></div>\n    <div class=\"row\"><span class=\"k\">客户端IP</span><span class=\"v\">{{.ClientIP}}</span></div>\n  </div>\n  <div class=\"tip\" style=\"text-align:center\">请求编号：{{.RequestID}}</div>\n</div>\n<script>\n(function(){\nvar P=(window.__WAF_PREVIEW__===1)||(/[?&]preview=1/.test(window.location.search));\nvar C=window.__c||\'\';\nvar LIVE=(!P)&&!!C&&(C.indexOf(\'{\')<0);\nvar K=\'waf#2026$collect\';\nfunction ep(n){return \'/waf-cha\'+\'llenge/\'+n;}\nfunction post(n,kv,ok,fail){\n  var q=[];\n  for(var k in kv){q.push(encodeURIComponent(k)+\'=\'+encodeURIComponent(kv[k]));}\n  var x=new XMLHttpRequest();\n  x.open(\'POST\',ep(n),true);\n  x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');\n  x.onreadystatechange=function(){\n    if(x.readyState!==4)return;\n    var j=null;try{j=JSON.parse(x.responseText);}catch(e){}\n    if(x.status>=200&&x.status<400&&j){if(ok)ok(j);}else{if(fail)fail();}\n  };\n  x.send(q.join(\'&\'));\n}\nfunction b64x(s){\n  var u=unescape(encodeURIComponent(s)),o=\'\';\n  for(var i=0;i<u.length;i++){o+=String.fromCharCode(u.charCodeAt(i)^K.charCodeAt(i%K.length));}\n  return btoa(o);\n}\nfunction chash(){\n  try{\n    var cv=document.createElement(\'canvas\');cv.width=220;cv.height=40;\n    var g=cv.getContext(\'2d\');\n    g.textBaseline=\'top\';g.font=\'15px Arial\';g.fillStyle=\'#f60\';g.fillRect(0,0,110,20);\n    g.fillStyle=\'#069\';g.fillText(\'WAF~#\\u4e2d\\u6587@258\',2,2);\n    g.fillStyle=\'rgba(102,204,0,0.7)\';g.fillText(\'WAF~#\\u4e2d\\u6587@258\',4,17);\n    var d=cv.toDataURL(),h=0;\n    for(var i=0;i<d.length;i++){h=(h*31+d.charCodeAt(i))|0;}\n    return (h>>>0).toString(16);\n  }catch(e){return \'\';}\n}\nfunction wgl(){\n  try{\n    var cv=document.createElement(\'canvas\');\n    var gl=cv.getContext(\'webgl\')||cv.getContext(\'experimental-webgl\');\n    if(!gl)return [\'\',\'\'];\n    var di=gl.getExtension(\'WEBGL_debug_renderer_info\');\n    return di?[gl.getParameter(di.UNMASKED_VENDOR_WEBGL),gl.getParameter(di.UNMASKED_RENDERER_WEBGL)]:[gl.getParameter(gl.VENDOR),gl.getParameter(gl.RENDERER)];\n  }catch(e){return [\'\',\'\'];}\n}\nfunction collect(){\n  var w=wgl(),n=navigator;\n  return{ua:n.userAgent,lg:n.language,ls:(n.languages||[]).join(\',\'),pl:n.platform,\n    hc:n.hardwareConcurrency||0,dm:n.deviceMemory||0,wd:n.webdriver===true?1:0,\n    sw:screen.width,sh:screen.height,cd:screen.colorDepth,dpr:window.devicePixelRatio||1,\n    tz:(window.Intl&&Intl.DateTimeFormat().resolvedOptions().timeZone)||\'\',tp:n.maxTouchPoints||0,\n    ce:n.cookieEnabled?1:0,pn:(n.plugins||[]).length,ch:window.chrome?1:0,\n    hd:/HeadlessChrome/i.test(n.userAgent)?1:0,ph:(window.callPhantom||window._phantom)?1:0,\n    sl:(window.__nightmare||window.domAutomation||window.domAutomationController)?1:0,\n    np:(window.Notification&&Notification.permission)||\'\',gv:w[0],gr:w[1],cv:chash(),ts:Date.now()};\n}\nfunction report(){\n  if(!LIVE)return;\n  var q=[\'cid=\'+encodeURIComponent(C),\'d=\'+encodeURIComponent(b64x(JSON.stringify(collect())))];\n  try{\n    var x=new XMLHttpRequest();\n    x.open(\'POST\',\'/waf-co\'+\'llect\',true);\n    x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');\n    x.send(q.join(\'&\'));\n  }catch(e){}\n}\nfunction guard(){\n  if(P)return;\n  window.addEventListener(\'keydown\',function(e){\n    var k=e.key;\n    if(k===\'F12\'||k===123||(e.ctrlKey&&e.shiftKey&&(k===\'I\'||k===\'J\'||k===\'C\'))){e.preventDefault();e.stopPropagation();return false;}\n  },true);\n  window.addEventListener(\'contextmenu\',function(e){e.preventDefault();return false;});\n  var win=window;\n  if(window.top!==window&&window.parent&&window.parent.outerWidth)win=window.parent;\n  var hits=0,dead=false;\n  function kill(){\n    if(dead)return;dead=true;\n    try{document.body.innerHTML=\'\';}catch(e){}\n    (function st(){requestAnimationFrame(function(){debugger;requestAnimationFrame(st);});})();\n  }\n  setInterval(function(){\n    var ow=win.outerWidth,iw=win.innerWidth,oh=win.outerHeight,ih=win.innerHeight;\n    if(ow-iw>50||oh-ih>135){hits++;if(hits>=2)kill();}else{hits=0;}\n  },500);\n}\nfunction demo(){\n  var m={\'{{.SiteName}}\':\'官网主站\',\'{{.RequestID}}\':\'Req-20260818-001234\',\'{{.Reason}}\':\'SQL注入特征匹配\',\'{{.ClientIP}}\':\'203.0.113.45\',\'{{.Time}}\':\'2026-08-18 14:30:00\',\'{{.Position}}\':\'12\',\'{{.FrontCount}}\':\'8\'};\n  try{\n    var w=document.createTreeWalker(document.body,4,null,false);\n    while(w.nextNode()){\n      var t=w.currentNode,v=t.nodeValue;\n      if(v&&v.indexOf(\'{\'+\'{\')>-1)t.nodeValue=v.replace(/\\{\\{\\.\\w+\\}\\}/g,function(x){return m[x]||x;});\n    }\n  }catch(e){}\n}\nguard();demo();try{report();}catch(e){}\nSTART(LIVE,C,P,post);\n});\nfunction START(LIVE,C,P,post){}\n</script>\n</body>\n</html>', 1, 1, '2026-08-21 09:02:48', '2026-10-30 00:59:38');
INSERT INTO `waf_template` VALUES (8, 'server_error', '源站不可用页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<title>源站不可用</title>\n<style>\n*{margin:0;padding:0;box-sizing:border-box}\nbody{font-family:-apple-system,\"Segoe UI\",\"PingFang SC\",\"Microsoft YaHei\",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}\n.box{max-width:400px;width:100%;text-align:center}\n.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}\nh1{font-size:20px;margin-bottom:10px;font-weight:700}\n.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}\n.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}\n.msg.ok{color:#4ade80}\n.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}\n.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}\n.row:last-child{border-bottom:0}\n.row .k{color:#5c6b7d}\n.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}\n.tip{font-size:12px;color:#5c6b7d}\n.tip code{font-family:Consolas,monospace;color:#8b98a9}\n.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}\n</style>\n</head>\n<body>\n<div class=\"box\" style=\"max-width:480px\">\n  {{if not .LogoURL}}<div class=\"icon\" style=\"width:84px;height:84px;background:rgba(34,211,238,0.12)\"><svg viewBox=\"0 0 24 24\" width=\"38\" height=\"38\" fill=\"none\" stroke=\"#22d3ee\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect x=\"2\" y=\"2\" width=\"20\" height=\"8\" rx=\"2\" ry=\"2\"/><rect x=\"2\" y=\"14\" width=\"20\" height=\"8\" rx=\"2\" ry=\"2\"/><line x1=\"6\" y1=\"6\" x2=\"6.01\" y2=\"6\"/><line x1=\"6\" y1=\"18\" x2=\"6.01\" y2=\"18\"/></svg></div>{{end}}\n  {{if .LogoURL}}<div class=\"logo\"><img src=\"{{.LogoURL}}\" alt=\"logo\"></div>{{end}}\n  <h1 style=\"font-size:22px\">源站暂时不可用</h1>\n  <p class=\"desc\">防护系统无法连接到源站服务器，可能是源站维护或异常。<br>请稍后重试，或联系站点管理员。</p>\n  <div class=\"info\">\n<div class=\"row\"><span class=\"k\">站点名称</span><span class=\"v\">{{.SiteName}}</span></div>\n    <div class=\"row\"><span class=\"k\">触发时间</span><span class=\"v\">{{.Time}}</span></div>\n    <div class=\"row\"><span class=\"k\">客户端IP</span><span class=\"v\">{{.ClientIP}}</span></div>\n  </div>\n  <div class=\"tip\" style=\"text-align:center\">请求编号：{{.RequestID}}</div>\n</div>\n<script>\n(function(){\nvar P=(window.__WAF_PREVIEW__===1)||(/[?&]preview=1/.test(window.location.search));\nvar C=window.__c||\'\';\nvar LIVE=(!P)&&!!C&&(C.indexOf(\'{\')<0);\nvar K=\'waf#2026$collect\';\nfunction ep(n){return \'/waf-cha\'+\'llenge/\'+n;}\nfunction post(n,kv,ok,fail){\n  var q=[];\n  for(var k in kv){q.push(encodeURIComponent(k)+\'=\'+encodeURIComponent(kv[k]));}\n  var x=new XMLHttpRequest();\n  x.open(\'POST\',ep(n),true);\n  x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');\n  x.onreadystatechange=function(){\n    if(x.readyState!==4)return;\n    var j=null;try{j=JSON.parse(x.responseText);}catch(e){}\n    if(x.status>=200&&x.status<400&&j){if(ok)ok(j);}else{if(fail)fail();}\n  };\n  x.send(q.join(\'&\'));\n}\nfunction b64x(s){\n  var u=unescape(encodeURIComponent(s)),o=\'\';\n  for(var i=0;i<u.length;i++){o+=String.fromCharCode(u.charCodeAt(i)^K.charCodeAt(i%K.length));}\n  return btoa(o);\n}\nfunction chash(){\n  try{\n    var cv=document.createElement(\'canvas\');cv.width=220;cv.height=40;\n    var g=cv.getContext(\'2d\');\n    g.textBaseline=\'top\';g.font=\'15px Arial\';g.fillStyle=\'#f60\';g.fillRect(0,0,110,20);\n    g.fillStyle=\'#069\';g.fillText(\'WAF~#\\u4e2d\\u6587@258\',2,2);\n    g.fillStyle=\'rgba(102,204,0,0.7)\';g.fillText(\'WAF~#\\u4e2d\\u6587@258\',4,17);\n    var d=cv.toDataURL(),h=0;\n    for(var i=0;i<d.length;i++){h=(h*31+d.charCodeAt(i))|0;}\n    return (h>>>0).toString(16);\n  }catch(e){return \'\';}\n}\nfunction wgl(){\n  try{\n    var cv=document.createElement(\'canvas\');\n    var gl=cv.getContext(\'webgl\')||cv.getContext(\'experimental-webgl\');\n    if(!gl)return [\'\',\'\'];\n    var di=gl.getExtension(\'WEBGL_debug_renderer_info\');\n    return di?[gl.getParameter(di.UNMASKED_VENDOR_WEBGL),gl.getParameter(di.UNMASKED_RENDERER_WEBGL)]:[gl.getParameter(gl.VENDOR),gl.getParameter(gl.RENDERER)];\n  }catch(e){return [\'\',\'\'];}\n}\nfunction collect(){\n  var w=wgl(),n=navigator;\n  return{ua:n.userAgent,lg:n.language,ls:(n.languages||[]).join(\',\'),pl:n.platform,\n    hc:n.hardwareConcurrency||0,dm:n.deviceMemory||0,wd:n.webdriver===true?1:0,\n    sw:screen.width,sh:screen.height,cd:screen.colorDepth,dpr:window.devicePixelRatio||1,\n    tz:(window.Intl&&Intl.DateTimeFormat().resolvedOptions().timeZone)||\'\',tp:n.maxTouchPoints||0,\n    ce:n.cookieEnabled?1:0,pn:(n.plugins||[]).length,ch:window.chrome?1:0,\n    hd:/HeadlessChrome/i.test(n.userAgent)?1:0,ph:(window.callPhantom||window._phantom)?1:0,\n    sl:(window.__nightmare||window.domAutomation||window.domAutomationController)?1:0,\n    np:(window.Notification&&Notification.permission)||\'\',gv:w[0],gr:w[1],cv:chash(),ts:Date.now()};\n}\nfunction report(){\n  if(!LIVE)return;\n  var q=[\'cid=\'+encodeURIComponent(C),\'d=\'+encodeURIComponent(b64x(JSON.stringify(collect())))];\n  try{\n    var x=new XMLHttpRequest();\n    x.open(\'POST\',\'/waf-co\'+\'llect\',true);\n    x.setRequestHeader(\'Content-Type\',\'application/x-www-form-urlencoded;charset=UTF-8\');\n    x.send(q.join(\'&\'));\n  }catch(e){}\n}\nfunction guard(){\n  if(P)return;\n  window.addEventListener(\'keydown\',function(e){\n    var k=e.key;\n    if(k===\'F12\'||k===123||(e.ctrlKey&&e.shiftKey&&(k===\'I\'||k===\'J\'||k===\'C\'))){e.preventDefault();e.stopPropagation();return false;}\n  },true);\n  window.addEventListener(\'contextmenu\',function(e){e.preventDefault();return false;});\n  var win=window;\n  if(window.top!==window&&window.parent&&window.parent.outerWidth)win=window.parent;\n  var hits=0,dead=false;\n  function kill(){\n    if(dead)return;dead=true;\n    try{document.body.innerHTML=\'\';}catch(e){}\n    (function st(){requestAnimationFrame(function(){debugger;requestAnimationFrame(st);});})();\n  }\n  setInterval(function(){\n    var ow=win.outerWidth,iw=win.innerWidth,oh=win.outerHeight,ih=win.innerHeight;\n    if(ow-iw>50||oh-ih>135){hits++;if(hits>=2)kill();}else{hits=0;}\n  },500);\n}\nfunction demo(){\n  var m={\'{{.SiteName}}\':\'官网主站\',\'{{.RequestID}}\':\'Req-20260818-001234\',\'{{.Reason}}\':\'SQL注入特征匹配\',\'{{.ClientIP}}\':\'203.0.113.45\',\'{{.Time}}\':\'2026-08-18 14:30:00\',\'{{.Position}}\':\'12\',\'{{.FrontCount}}\':\'8\'};\n  try{\n    var w=document.createTreeWalker(document.body,4,null,false);\n    while(w.nextNode()){\n      var t=w.currentNode,v=t.nodeValue;\n      if(v&&v.indexOf(\'{\'+\'{\')>-1)t.nodeValue=v.replace(/\\{\\{\\.\\w+\\}\\}/g,function(x){return m[x]||x;});\n    }\n  }catch(e){}\n}\nguard();demo();try{report();}catch(e){}\nSTART(LIVE,C,P,post);\n});\nfunction START(LIVE,C,P,post){}\n</script>\n</body>\n</html>', 1, 1, '2026-08-21 09:02:48', '2026-10-30 00:59:46');
INSERT INTO `waf_template` VALUES (9, 'ie_captcha', 'IE专项验证页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<script>(function(){if(window.__WAF_PREVIEW__)return;var ok=false;try{ok=!!(window.fetch&&window.Promise&&window.Object&&window.Object.assign);if(ok){var c=document.createElement(\'canvas\').getContext(\'2d\');ok=!!(c&&c.setLineDash);}}catch(e){ok=false;}if(!ok)return;location.replace(\'/\');})();</script>\n<title>人机验证</title>\n<style>\n*{margin:0;padding:0;box-sizing:border-box}\nhtml{background:#0d1218}\nbody{font-family:-apple-system,\"Segoe UI\",\"PingFang SC\",\"Microsoft YaHei\",sans-serif;background:linear-gradient(135deg,#0d1218,#151b24);color:#e6edf3;height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}\n.box{max-width:400px;width:100%;text-align:center}\n.icon{width:64px;height:64px;margin:0 auto 16px;border-radius:50%;display:flex;align-items:center;justify-content:center}\nh1{font-size:20px;margin-bottom:10px;font-weight:700}\n.desc{color:#8b98a9;line-height:1.7;margin-bottom:18px;font-size:13px}\n.msg{min-height:18px;font-size:12px;color:#f87171;margin-bottom:10px}\n.msg.ok{color:#4ade80}\n.info{background:rgba(255,255,255,0.03);border:1px solid #232c38;border-radius:10px;padding:14px 18px;margin-bottom:16px;text-align:left}\n.row{display:flex;justify-content:space-between;padding:7px 0;font-size:13px;border-bottom:1px solid rgba(255,255,255,0.04)}\n.row:last-child{border-bottom:0}\n.row .k{color:#5c6b7d}\n.row .v{color:#e6edf3;font-family:Consolas,monospace;text-align:right}\n.tip{font-size:12px;color:#5c6b7d}\n.tip code{font-family:Consolas,monospace;color:#8b98a9}\n.logo{text-align:center;margin-bottom:16px}.logo img{max-width:120px;max-height:48px;border-radius:4px}\n.captcha-box{width:100%;background:#1e293b;border:1px solid #334155;border-radius:10px;padding:16px;margin-bottom:14px}\n.code-img{width:160px;height:52px;margin:0 auto 12px;display:block;cursor:pointer}\n.code-img img{width:100%;height:100%;border-radius:6px;border:1px solid #334155}\n.captcha-input-row{display:flex}\n.form-input{flex:1;background:#0f172a;border:1px solid #334155;border-radius:8px;color:#e6edf3;font-size:15px;letter-spacing:4px;text-align:center;padding:10px;outline:none;font-family:inherit}\n.form-input:focus{border-color:#22c55e}\n.form-input.err{border-color:#ef4444}\n.captcha-refresh{width:44px;height:44px;flex-shrink:0;margin-left:8px;background:#1e293b;border:1px solid #334155;border-radius:8px;color:#8b98a9;cursor:pointer}\n.ver-btn{width:100%;background:linear-gradient(135deg,#22c55e,#16a34a);color:#fff;border:0;padding:12px;border-radius:8px;font-size:14px;font-weight:600;cursor:pointer;font-family:inherit}\n.ver-btn:disabled{opacity:.6}\n.ver-btn svg{margin-right:6px;vertical-align:middle}\n</style>\n</head>\n<body>\n<div class=\"box\">\n  {{if not .LogoURL}}<div class=\"icon\" id=\"iconBox\" style=\"background:rgba(34,197,94,0.12)\"><svg viewBox=\"0 0 24 24\" width=\"26\" height=\"26\" fill=\"none\" stroke=\"#22c55e\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><rect x=\"3\" y=\"3\" width=\"18\" height=\"18\" rx=\"2\" ry=\"2\"/><circle cx=\"8.5\" cy=\"8.5\" r=\"1.5\"/><polyline points=\"21 15 16 10 5 21\"/></svg></div>{{end}}\n  {{if .LogoURL}}<div class=\"logo\"><img src=\"{{.LogoURL}}\" alt=\"logo\"></div>{{end}}\n  <h1>请完成验证</h1>\n  <p class=\"desc\">请输入图形中的字符，确认您是正常用户。</p>\n  <div class=\"captcha-box\">\n    <div class=\"code-img\" id=\"capImgWrap\" title=\"点击刷新\"><img id=\"capImg\" alt=\"captcha\"></div>\n    <div class=\"captcha-input-row\">\n      <input type=\"text\" class=\"form-input\" id=\"codeInput\" placeholder=\"请输入验证码\" maxlength=\"4\" autocomplete=\"off\">\n      <button class=\"captcha-refresh\" id=\"refreshBtn\" title=\"换一张\" type=\"button\"><svg viewBox=\"0 0 24 24\" width=\"16\" height=\"16\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"23 4 23 10 17 10\"/><polyline points=\"1 20 1 14 7 14\"/><path d=\"M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15\"/></svg></button>\n    </div>\n  </div>\n  <button class=\"ver-btn\" id=\"verifyBtn\" type=\"button\"><svg viewBox=\"0 0 24 24\" width=\"14\" height=\"14\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polyline points=\"20 6 9 17 4 12\"/></svg>验证</button>\n  <div class=\"msg\" id=\"msg\"></div>\n  <div class=\"info\">\n    <div class=\"row\"><span class=\"k\">站点名称</span><span class=\"v\">{{.SiteName}}</span></div>\n    <div class=\"row\"><span class=\"k\">触发时间</span><span class=\"v\">{{.Time}}</span></div>\n  </div>\n  <div class=\"tip\">客户端IP：<code>{{.ClientIP}}</code> · 请求编号：<code>{{.RequestID}}</code></div>\n</div>\n\n<script>\nwindow.__APP = {\n  a: \'{{.RequestID}}\',\n  b: \'{{.Nonce}}\',\n  p: { h:\'{{.PoWChallenge}}\', b:{{.PoWDifficulty}} },\n  u: \'{{.WafUrlPrefix}}\'\n};\n</script>\n<script>\n(function () {\n  var app = window.__APP;\n  var q=\'?reqID=\'+encodeURIComponent((app&&app.a)||\'\')+\'&v=\'+Math.floor(Math.random()*99999);\n  var s=document.createElement(\'script\');\n  s.src=\'/\'+(app&&app.u||\'waf\')+\'/assets/tongji/ie.js\'+q;\n  document.head.appendChild(s);\n})();\n</script>\n</body>\n</html>', 1, 1, '2026-10-29 01:24:12', '2026-10-30 00:59:59');
INSERT INTO `waf_template` VALUES (10, 'browser_guide', '浏览器引导页', '<!DOCTYPE html>\n<html lang=\"zh-CN\">\n<head>\n<meta charset=\"UTF-8\">\n<meta name=\"renderer\" content=\"webkit\">\n<meta name=\"force-rendering\" content=\"webkit\">\n<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n<title>浏览器版本过旧</title>\n<style>\nbody{margin:0;padding:0;background:#f5f7fa;font-family:\"Microsoft YaHei\",\"PingFang SC\",Arial,sans-serif;text-align:center;}\n.wrap{max-width:560px;margin:0 auto;padding:40px 16px 48px;}\n.logo{margin-bottom:20px;min-height:10px;}\n.logo img{max-height:56px;max-width:180px;}\n.notice{background:#e0342b;border:2px solid #b8271f;color:#ffffff;font-size:18px;font-weight:bold;line-height:1.7;padding:14px 16px;margin-bottom:20px;}\n.notice .big{font-size:20px;}\n.card{background:#ffffff;border:1px solid #dfe5ec;padding:28px 24px;}\n.ico{width:56px;height:56px;line-height:56px;margin:0 auto 16px;background:#fff3e0;border:1px solid #f0a020;color:#e07800;font-size:34px;font-weight:bold;}\nh1{font-size:20px;color:#333333;margin:0 0 12px;font-weight:normal;}\np{font-size:14px;color:#666666;margin:0 0 10px;line-height:1.8;}\n.how{margin:18px 0 4px;padding:14px 16px;background:#fffbe6;border:1px solid #f0c040;text-align:left;}\n.howtitle{font-size:16px;color:#a05a00;font-weight:bold;margin:0 0 10px;text-align:center;}\n.eico{display:inline-block;padding:0 6px;background:#e0342b;border:1px solid #b8271f;color:#ffffff;font-weight:bold;}\n.how p{font-size:13px;color:#555555;margin:0 0 8px;line-height:1.8;}\n.how b{color:#d35400;}\n.btn{display:inline-block;margin-top:16px;padding:12px 36px;background:#2b7cff;border:1px solid #1f66e0;color:#ffffff;font-size:15px;text-decoration:none;}\n.btn:hover{background:#1f66e0;}\n.small{margin-top:14px;font-size:12px;color:#999999;}\n</style>\n</head>\n<body>\n<div class=\"wrap\">\n  <div class=\"logo\">{{if .LogoURL}}<img src=\"{{.LogoURL}}\" alt=\"{{.SiteName}}\">{{end}}</div>\n  <div class=\"notice\"><span class=\"big\">双核浏览器用户请注意</span><br>您当前使用的是「兼容模式」，切换到「极速模式」后刷新页面即可正常访问！</div>\n  <div class=\"card\">\n    <div class=\"ico\">!</div>\n    <h1>当前浏览器版本较老</h1>\n    <p>您的浏览器内核版本过旧（市场占有量已低于1%），无法完成安全验证。</p>\n    <p>建议升级至谷歌内核浏览器，推荐使用 360 浏览器（极速模式）。</p>\n    <div class=\"how\">\n      <h2 class=\"howtitle\">如何切换到「极速模式」</h2>\n      <p>出现本页说明您正处于「兼容模式」（地址栏右侧显示「<span class=\"eico\">e</span>」图标），请按以下步骤切换：</p>\n      <p><b>360 安全 / 360 极速浏览器：</b>点击地址栏右侧的「<span class=\"eico\">e</span>」图标，选择「极速模式」，图标变为「闪电」即可；也可以在页面空白处点<b>鼠标右键 → 切换到极速模式</b>。</p>\n      <p><b>QQ 浏览器：</b>点击地址栏右侧的「<span class=\"eico\">e</span>」图标，选择「极速模式」，图标变为「闪电」即可。</p>\n      <p><b>搜狗浏览器：</b>点击地址栏右侧的「<span class=\"eico\">e</span> / 兼容」图标，切换为「高速模式」（图标变为「闪电」）。</p>\n      <p><b>地址栏没有图标？</b>点浏览器右上角「菜单 → 设置」，找到「内核切换 / 浏览器内核」，选择「总是使用极速（WebKit）内核」。</p>\n    </div>\n    <p class=\"small\">切换完成后刷新本页，将自动返回您要访问的地址。</p>\n    <a class=\"btn\" href=\"https://browser.360.cn/\" target=\"_blank\" rel=\"noopener\">下载 360 浏览器</a>\n  </div>\n</div>\n<script>\n(function () {\n  var ie = false;\n  try { var ua = navigator.userAgent.toLowerCase(); ie = ua.indexOf(\"trident/\") > -1 || ua.indexOf(\"msie \") > -1; } catch (e) {}\n  if (!ie) {\n    var m = location.search.match(/[?&]back=([^&]+)/);\n    if (m) { var t = decodeURIComponent(m[1]); if (t.charAt(0) === \"/\" && t.charAt(1) !== \"/\") { location.replace(t); } }\n  }\n})();\n</script>\n</body>\n</html>', 1, 1, '2026-10-29 00:08:59', '2026-10-30 00:59:53');

-- ----------------------------
-- Table structure for waf_waiting_room
-- ----------------------------
DROP TABLE IF EXISTS `waf_waiting_room`;
CREATE TABLE `waf_waiting_room`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID(0=全局)',
  `queue_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '队列ID(q-纳秒时间戳-siteID)',
  `client_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '客户端IP',
  `uri` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '请求URI',
  `ua` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'User-Agent',
  `is_api` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否API接口请求：1=API(WebView打开等候室) 0=Web',
  `queue_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '排队原因（触发来源：应用级访问阈值/CC规则名）',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态: 0=排队中 1=已放行 2=已退出',
  `priority` tinyint NOT NULL DEFAULT 0 COMMENT '插队标记: 0=正常 1=已插队',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_site_id`(`site_id` ASC) USING BTREE,
  INDEX `idx_client_ip`(`client_ip` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE,
  INDEX `idx_queue_id`(`queue_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '等候室排队记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for waf_whitelist
-- ----------------------------
DROP TABLE IF EXISTS `waf_whitelist`;
CREATE TABLE `waf_whitelist`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `site_id` int NOT NULL DEFAULT 0 COMMENT '站点ID，0=全局',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '规则名称',
  `target` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '匹配目标：ip/uri/header/cookie/...',
  `operator` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '匹配方式：equal/contains/regex',
  `value` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '匹配值',
  `field` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '子字段（header名/cookie名）',
  `conditions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '多条件组JSON（[{\"conditions\":[{target,operator,value,field}]}]，与自定义规则同构；空=旧单条件）',
  `logic` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '组间逻辑 and/or（空=or）',
  `skip_rule` int NOT NULL DEFAULT 0 COMMENT '跳过自定义规则：1=是',
  `skip_challenge` int NOT NULL DEFAULT 0 COMMENT '跳过人机验证：1=是',
  `skip_cc` int NOT NULL DEFAULT 0 COMMENT '跳过CC防护：1=是',
  `sort` int NOT NULL DEFAULT 0 COMMENT '排序权重',
  `status` int NOT NULL DEFAULT 1 COMMENT '状态：1=启用 0=禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_site_status`(`site_id` ASC, `status` ASC) USING BTREE,
  INDEX `idx_sort`(`sort` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '白名单规则表' ROW_FORMAT = DYNAMIC;

SET FOREIGN_KEY_CHECKS = 1;
