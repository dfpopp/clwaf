-- =====================================================================
-- 攻击日志枚举值蛇形归一（对齐 docs/0924/待升级改造建议.md §4.3，2026-10-18）
-- 背景：引擎写入的枚举值统一为蛇形（snake_case），本脚本归一历史存量，
--       使后台按蛇形键搜索/统计能命中历史数据。
-- 执行要求：低峰执行；执行前备份；幂等（重复执行无副作用）。
-- 注意：仅归一 waf_attack_log；waf_raw_log.reason 保留原貌不迁移（排障口径）；
--       waf_request_dim_stats.dim_key 的历史驼峰值不迁移（crc64 hash 无法 SQL 重算），
--       由前端过渡期别名归一保证展示正确，随 30 天保留期自然滚出。
-- =====================================================================

-- 攻击类型：爬虫IP拦截（驼峰 → 蛇形）
UPDATE `waf_attack_log` SET `attack_type` = 'crawler_ip' WHERE `attack_type` = 'crawlerIp';

-- 攻击类型：自定义规则（驼峰 → 蛇形）
UPDATE `waf_attack_log` SET `attack_type` = 'custom_rule' WHERE `attack_type` = 'customRule';

-- 攻击类型：等候室过载（驼峰旧键 → 现行蛇形键）
UPDATE `waf_attack_log` SET `attack_type` = 'waiting_room_full' WHERE `attack_type` = 'waitingRoom';

-- 处置动作：等候室排队（驼峰 → 蛇形；防御性归一，等候室入队常态不落攻击日志）
UPDATE `waf_attack_log` SET `action` = 'waiting_room' WHERE `action` = 'waitingRoom';
