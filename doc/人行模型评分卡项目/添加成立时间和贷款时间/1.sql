-- entinfo添加字段
ALTER TABLE `entinfo` ADD COLUMN `loanDate` date COMMENT '贷款时间' , ADD COLUMN `esDate` date COMMENT '成立日期', ADD COLUMN `ifBad` TINYINT COMMENT '是否坏样本';









