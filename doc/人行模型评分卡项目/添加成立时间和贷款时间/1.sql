-- entinfo添加字段
ALTER TABLE `entinfo` ADD COLUMN `loanDate` varchar(20) COMMENT '贷款时间' , ADD COLUMN `esDate` VARCHAR(20) COMMENT '成立日期', ADD COLUMN `ifBad` TINYINT COMMENT '是否坏样本';









