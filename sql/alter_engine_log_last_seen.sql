-- 引擎日志表补 last_seen 索引：
-- cron 清理按 `last_seen < ?` 条件分批删除（app/cron/model/engineLog），
-- 缺索引时每批 DELETE 都会全表扫描，表越大越慢。
-- 在线上执行一次：
ALTER TABLE `waf_engine_log` ADD KEY `idx_last_seen` (`last_seen`);
