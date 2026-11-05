-- 访问统计表 access_stats（框架表前缀为 waf_，实际表名 waf_access_stats）
-- 按 站点+小时 聚合统计，供仪表盘 Dashboard 与日志分析使用
CREATE TABLE IF NOT EXISTS `waf_access_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
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
