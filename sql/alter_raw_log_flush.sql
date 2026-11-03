-- ==========================================================
-- 增量脚本：原始日志落库阈值（批量条数 / 时间秒数）
-- 适用：已导入过 init.sql 的环境
-- Idempotent：列不存在时才会执行
-- ==========================================================

USE `waf`;

SET @dbname = DATABASE();

SET @col_batch = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = 'waf_system_config' AND COLUMN_NAME = 'raw_log_batch_size'
);
SET @sql1 = IF(@col_batch = 0,
  'ALTER TABLE `waf_system_config` ADD COLUMN `raw_log_batch_size` int(11) NOT NULL DEFAULT 5000 COMMENT ''原始日志落库批量阈值（条数）'' AFTER `log_retention_days`',
  'SELECT 1');
PREPARE stmt1 FROM @sql1;
EXECUTE stmt1;
DEALLOCATE PREPARE stmt1;

SET @col_sec = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = 'waf_system_config' AND COLUMN_NAME = 'raw_log_flush_seconds'
);
SET @sql2 = IF(@col_sec = 0,
  'ALTER TABLE `waf_system_config` ADD COLUMN `raw_log_flush_seconds` int(11) NOT NULL DEFAULT 5 COMMENT ''原始日志落库时间阈值（秒）'' AFTER `raw_log_batch_size`',
  'SELECT 1');
PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;