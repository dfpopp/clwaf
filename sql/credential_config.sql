-- 安全凭证配置表
-- 说明：表前缀 waf_ 与 config/database.json 中 mysql.default.pre 保持一致；
--       代码中 model 表名为 credential_config，实际物理表为 waf_credential_config。
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
