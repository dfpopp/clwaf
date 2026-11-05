-- =====================================================================
-- 云平台对接表（M4，2026-10-18；契约源：《云平台对接接口规范.md》）
-- 三表：平台爬虫共享库 / 云平台规则 / 同步进度版本（KV）
-- 执行方式：低峰执行，幂等（重复执行无副作用）
-- =====================================================================

-- 平台爬虫共享库（只读物化，来源 source=platform；免费版拉取侧按 TopN 截断）
CREATE TABLE IF NOT EXISTS `waf_crawler_shared` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `ip` VARCHAR(64) NOT NULL COMMENT '爬虫IP（唯一）',
  `reason` VARCHAR(32) NOT NULL DEFAULT '' COMMENT '平台聚合的高置信原因',
  `first_seen` DATETIME DEFAULT NULL COMMENT '平台侧首次发现时间',
  `source_count` INT NOT NULL DEFAULT 1 COMMENT '平台聚合的来源实例数',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '本地启停：1=启用拦截 0=停用',
  `update_time` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台爬虫共享库（只读，来源=platform）';

-- 云平台规则（只读物化，source=platform；本地启停经 enabled 列管理）
-- condition_groups 与本地自定义规则 conditions JSON 同构：[{"conditions":[{target,operator,value,field}]}]
CREATE TABLE IF NOT EXISTS `waf_cloud_rule` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `platform_id` BIGINT NOT NULL COMMENT '平台侧规则ID（唯一映射，续期/重拉去重键）',
  `name` VARCHAR(128) NOT NULL COMMENT '平台规则名',
  `rule_type` VARCHAR(16) NOT NULL COMMENT '规则类型：whitelist=平台白名单 custom=平台拦截',
  `condition_groups` TEXT COMMENT '条件组JSON（与本地规则同构）',
  `logic` VARCHAR(8) NOT NULL DEFAULT '' COMMENT '组间逻辑：and/or（空=or）',
  `action` VARCHAR(16) NOT NULL DEFAULT '' COMMENT 'custom 型处置动作（block/observe/redirect 等）',
  `skip_rule` TINYINT NOT NULL DEFAULT 0 COMMENT 'whitelist 型：命中后跳过自定义规则',
  `skip_challenge` TINYINT NOT NULL DEFAULT 0 COMMENT 'whitelist 型：命中后跳过人机验证',
  `skip_cc` TINYINT NOT NULL DEFAULT 0 COMMENT 'whitelist 型：命中后跳过CC',
  `min_edition` VARCHAR(8) NOT NULL DEFAULT 'free' COMMENT '平台标注最低适用版本（free/pro）',
  `weight` INT NOT NULL DEFAULT 0 COMMENT '平台权重（展示排序）',
  `enabled` TINYINT NOT NULL DEFAULT 1 COMMENT '本地启停（平台下发默认启用，停用立即生效）',
  `sync_ver` BIGINT NOT NULL DEFAULT 0 COMMENT '平台侧规则版本（增量同步游标）',
  `create_time` DATETIME DEFAULT NULL,
  `update_time` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_platform_id` (`platform_id`),
  KEY `idx_type_enabled` (`rule_type`, `enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='云平台规则（只读物化，来源=platform）';

-- 同步进度版本（KV 小表；爬虫共享库/云规则拉取游标，INSERT 初始化后按 UPSERT 自增）
CREATE TABLE IF NOT EXISTS `waf_sync_state` (
  `name` VARCHAR(64) NOT NULL COMMENT '同步对象名（crawler_shared/cloud_rule）',
  `ver` BIGINT NOT NULL DEFAULT 0 COMMENT '已同步到的平台版本',
  `update_time` DATETIME DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='同步进度版本';

-- 进度行初始化（幂等：已存在则跳过）
INSERT IGNORE INTO `waf_sync_state` (`name`, `ver`, `update_time`)
VALUES ('crawler_shared', 0, NOW()), ('cloud_rule', 0, NOW());
