-- =====================================================================
-- 白名单多条件列（M5，2026-10-18；对齐建议 §8.3/§8.4）
-- 存量行不动（两列 NULL/空 = 旧单条件语义，读端兼容）；Pro 两层条件组、免费一层多条件
-- =====================================================================

ALTER TABLE `waf_whitelist`
  ADD COLUMN `conditions` TEXT NULL COMMENT '多条件组JSON（[{"conditions":[{target,operator,value,field}]}]，与自定义规则同构；空=旧单条件）' AFTER `field`,
  ADD COLUMN `logic` VARCHAR(8) NOT NULL DEFAULT '' COMMENT '组间逻辑 and/or（空=or）' AFTER `conditions`;
