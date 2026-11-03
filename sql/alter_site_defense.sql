-- ==========================================================
-- 增量脚本：站点防护方式 + 移除废弃的挑战配置表
-- 适用：已导入过 init.sql 的环境
-- 说明：
--   1) waf_template 表已含 slider/puzzle/captcha/silent_challenge 模板，
--      无需重复导入。
--   2) waf_challenge_config 表已被废弃（配置并入站点表），执行 DROP。
-- ==========================================================

-- 1. 站点表新增防护方式字段（Idempotent：列不存在时才会执行）
USE `waf`;

SET @dbname = DATABASE();

SET @col_defense = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = 'waf_site' AND COLUMN_NAME = 'defense_type'
);
SET @sql1 = IF(@col_defense = 0,
  'ALTER TABLE `waf_site` ADD COLUMN `defense_type` varchar(16) NOT NULL DEFAULT ''js'' COMMENT ''防护方式：js=JS挑战 captcha=人机验证'' AFTER `waf_enable`',
  'SELECT 1');
PREPARE stmt1 FROM @sql1;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;

SET @col_tpl = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = 'waf_site' AND COLUMN_NAME = 'challenge_template'
);
SET @sql2 = IF(@col_tpl = 0,
  'ALTER TABLE `waf_site` ADD COLUMN `challenge_template` varchar(32) NOT NULL DEFAULT ''slider'' COMMENT ''人机验证模板：slider/puzzle/captcha'' AFTER `defense_type`',
  'SELECT 1');
PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- 2. 删除废弃的人机验证配置表
DROP TABLE IF EXISTS `waf_challenge_config`;