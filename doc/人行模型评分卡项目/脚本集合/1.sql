SET @firstDate = '20181231';
SET @sendDate = '20180101';
SET @thirdDate = '20171231';
SET @fourDate = '20170101';

/**24个月 付款信息**/
DROP TABLE IF EXISTS rh_24MonthDebtData;
CREATE TABLE rh_24MonthDebtData AS
  (
    SELECT
      t.DEBTORNAME,
      sum(t.AMT)    AS 24DebtTotalAmt,
      sum(t.NUMBER) AS 24DebtTotalNumer,
      '24个月'
    FROM psdas_o_pay_fact t
    WHERE t.DEBTORNAME IN (SELECT entName
                           FROM entinfo) AND t.CONSDATE >= @fourDate AND t.CONSDATE <= @firstDate
    GROUP BY t.DEBTORNAME
  );
ALTER TABLE rh_24MonthDebtData
  ADD INDEX index_dpt (DEBTORNAME);


/**12个月 付款信息 临时表**/
DROP TABLE IF EXISTS rh_12MonthDebtData;
CREATE TABLE rh_12MonthDebtData AS
  (

    SELECT
      t.DEBTORNAME,
      sum(t.amt)    AS 12DebtTotalAmt,
      sum(t.number) AS 12DebtTotalNumer,
      '12个月'
    FROM psdas_o_pay_fact t
    WHERE t.DEBTORNAME IN (SELECT entName
                           FROM entinfo) AND t.CONSDATE >= @sendDate AND t.CONSDATE <= @firstDate
    GROUP BY t.DEBTORNAME
  );
ALTER TABLE rh_12MonthDebtData
  ADD INDEX index_DEBTORNAME (DEBTORNAME);

/**24个月 收款信息 临时表 **/
DROP TABLE IF EXISTS rh_24MonthCrdtData;
CREATE TABLE rh_24MonthCrdtData AS
  (
    SELECT
      t.CRDTORNAME,
      sum(t.AMT)    AS 24CreTotalAmt,
      sum(t.NUMBER) AS 24CreTotalNumer,
      '24个月'
    FROM psdas_o_pay_fact t
    WHERE t.CRDTORNAME IN (SELECT entName
                           FROM entinfo) AND t.CONSDATE >= @fourDate AND t.CONSDATE <= @firstDate
    GROUP BY t.CRDTORNAME
  );
ALTER TABLE rh_24MonthCrdtData
  ADD INDEX index_CRDTORNAME (CRDTORNAME);
/**12个月 收款信息 临时表**/
DROP TABLE IF EXISTS rh_12MonthCrdtData;
CREATE TABLE rh_12MonthCrdtData AS
  (

    SELECT
      t.CRDTORNAME,
      sum(t.amt)    AS 12CreTotalAmt,
      sum(t.number) AS 12CreTotalNumer,
      '12个月'
    FROM psdas_o_pay_fact t
    WHERE t.CRDTORNAME IN (SELECT entName
                           FROM entinfo) AND t.CONSDATE >= @sendDate AND t.CONSDATE <= @firstDate
    GROUP BY t.CRDTORNAME
  );
ALTER TABLE rh_12MonthCrdtData
  ADD INDEX index_CRDTORNAME (CRDTORNAME);


/**
select * from rh_24MonthDebtData;
select * from rh_12MonthDebtData;
select * from rh_24MonthCrdtData;
select * from rh_12MonthCrdtData;

**/

/**drop table rh_24MonthDebtData;
drop table rh_12MonthDebtData;
drop table rh_24MonthCrdtData;
drop table rh_12MonthCrdtData;**/

/* 企业规模
过去24个月企业入账金额跟出账金额的平均值 */
DROP TABLE IF EXISTS rh_company_scale_temp;
CREATE TABLE rh_company_scale_temp AS (
  SELECT
    a.DEBTORNAME,
    (a.24DebtTotalAmt + b.24CreTotalAmt) / 24 AS scaleAmt
  FROM rh_24MonthDebtData a LEFT JOIN rh_24MonthCrdtData b ON a.DEBTORNAME = b.CRDTORNAME
);
ALTER TABLE rh_company_scale_temp
  ADD INDEX index_DEBTORNAME (DEBTORNAME);
/**  企业行业
创建企业行业变量临时表   **/
DROP TABLE IF EXISTS rh_company_industry_info_temp0;
CREATE TABLE rh_company_industry_info_temp0 AS
  (
    SELECT
      compname,
      industrycode,
      sum(count) AS count
    FROM (
           SELECT
             t.DEBTORNAME    AS compname,
             t.Debt_industry AS industrycode,
             count(1)        AS count
           FROM psdas_o_pay_fact t
           WHERE t.DEBTORNAME IN (SELECT entName
                                  FROM entinfo)
           GROUP BY t.DEBTORNAME, t.Debt_industry
           UNION
           SELECT
             t.CRDTORNAME    AS compname,
             t.Recv_industry AS industrycode,
             count(1)        AS count
           FROM psdas_o_pay_fact t
           WHERE t.CRDTORNAME IN (SELECT entName
                                  FROM entinfo)
           GROUP BY t.CRDTORNAME, t.Recv_industry
         ) AS A
    GROUP BY compname, industrycode
  );


DROP TABLE IF EXISTS rh_company_industry_info_temp;
CREATE TABLE rh_company_industry_info_temp AS
  (
    SELECT
      A.compname,
      A.industrycode
    FROM rh_company_industry_info_temp0 A
      INNER JOIN (SELECT
                    compname,
                    max(count) AS count
                  FROM rh_company_industry_info_temp0
                  GROUP BY compname) B ON A.compname = B.compname AND A.count = B.count
  );
ALTER TABLE rh_company_industry_info_temp
  ADD INDEX index_compname (compname);
ALTER TABLE rh_company_industry_info_temp
  ADD INDEX index_industrycode (industrycode);

/** 企业地域查询 **/
/**select * from entinfo WHERE entName in (select @empname) ;
**/

/** 企业经营年限临时表  **/
DROP TABLE IF EXISTS rh_company_age_temp;
CREATE TABLE rh_company_age_temp AS
  (
    SELECT
      DEBTORNAME,
      min(CONSDATE) AS em
    FROM psdas_o_pay_fact
    WHERE DEBTORNAME IN (SELECT entName
                         FROM entinfo)
    GROUP BY DEBTORNAME
  );
ALTER TABLE rh_company_age_temp
  ADD INDEX index_DEBTORNAME (DEBTORNAME);

/**
资金投向集中度 付款方向
匹配查询企业之过去12个月/13-24个月各付款人名称付款金额的集中指数
**/
DROP TABLE IF EXISTS rh_lastTwelveMonDebtRatio;
CREATE TABLE rh_lastTwelveMonDebtRatio AS (-- 先算12个月 企业付款比例的最大值
  SELECT
    DEBTORNAME,
    MAX(MAMT) AS debtratio
  FROM (
         SELECT
           A.DEBTORNAME    DEBTORNAME,
           A.CRDTORNAME,
           A.AAMT / B.BAMT MAMT
         FROM (
                SELECT
                  DEBTORNAME,
                  CRDTORNAME,
                  SUM(AMT) AAMT
                FROM psdas_o_pay_fact
                WHERE DEBTORNAME IN (SELECT entName
                                     FROM entinfo) AND CONSDATE >= @sendDate AND CONSDATE <= @firstDate
                GROUP BY DEBTORNAME, CRDTORNAME) A
           , (
               SELECT
                 DEBTORNAME,
                 SUM(AMT) BAMT
               FROM psdas_o_pay_fact
               WHERE DEBTORNAME IN (SELECT entName
                                    FROM entinfo) AND CONSDATE >= @sendDate AND CONSDATE <= @firstDate
               GROUP BY DEBTORNAME) B
         WHERE A.DEBTORNAME = B.DEBTORNAME
       ) C
  GROUP BY DEBTORNAME
);
ALTER TABLE rh_lastTwelveMonDebtRatio
  ADD INDEX index_DEBTORNAME (DEBTORNAME);

DROP TABLE IF EXISTS rh_thirteenToTwentyFourDebtRatio;
CREATE TABLE rh_thirteenToTwentyFourDebtRatio AS (-- 计算13-24月 企业付款比例的最大值
  SELECT
    DEBTORNAME,
    MAX(MAMT) AS debtratio
  FROM (
         SELECT
           A.DEBTORNAME    DEBTORNAME,
           A.CRDTORNAME,
           A.AAMT / B.BAMT MAMT
         FROM (
                SELECT
                  DEBTORNAME,
                  CRDTORNAME,
                  SUM(AMT) AAMT
                FROM psdas_o_pay_fact
                WHERE DEBTORNAME IN (SELECT entName
                                     FROM entinfo) AND CONSDATE >= @fourDate AND CONSDATE <= @thirdDate
                GROUP BY DEBTORNAME, CRDTORNAME) A
           , (
               SELECT
                 DEBTORNAME,
                 SUM(AMT) BAMT
               FROM psdas_o_pay_fact
               WHERE DEBTORNAME IN (SELECT entName
                                    FROM entinfo) AND CONSDATE >= @fourDate AND CONSDATE <= @thirdDate
               GROUP BY DEBTORNAME) B
         WHERE A.DEBTORNAME = B.DEBTORNAME
       ) C
  GROUP BY DEBTORNAME
);
ALTER TABLE rh_thirteenToTwentyFourDebtRatio
  ADD INDEX index_DEBTORNAME (DEBTORNAME);
/**
资金投向集中度 付款方向
根据付款的两个比例计算集中度 **/
DROP TABLE IF EXISTS rh_money_zjtx_debt_temp;
CREATE TABLE rh_money_zjtx_debt_temp AS (
  SELECT
    tm.DEBTORNAME,
    tm.debtratio - tt.debtratio AS hindex
  FROM rh_lastTwelveMonDebtRatio tm LEFT JOIN rh_thirteenToTwentyFourDebtRatio tt ON tm.DEBTORNAME = tt.DEBTORNAME
);
ALTER TABLE rh_money_zjtx_debt_temp
  ADD INDEX index_DEBTORNAME (DEBTORNAME);

/**
资金投向集中度 收款方向
匹配查询企业之过去12个月/13-24个月各收款人名称付款金额的集中指数
**/
DROP TABLE IF EXISTS rh_lastTwelveMonCrdtRatio;
CREATE TABLE rh_lastTwelveMonCrdtRatio AS (-- 先算12个月 企业收款比例的最大值
  SELECT
    CRDTORNAME,
    MAX(MAMT) AS crdtratio
  FROM (
         SELECT
           A.CRDTORNAME    CRDTORNAME,
           A.DEBTORNAME,
           A.AAMT / B.BAMT MAMT
         FROM (
                SELECT
                  CRDTORNAME,
                  DEBTORNAME,
                  SUM(AMT) AAMT
                FROM psdas_o_pay_fact
                WHERE CRDTORNAME IN (SELECT entName
                                     FROM entinfo) AND CONSDATE >= @sendDate AND CONSDATE <= @firstDate
                GROUP BY CRDTORNAME, DEBTORNAME) A
           , (
               SELECT
                 CRDTORNAME,
                 SUM(AMT) BAMT
               FROM psdas_o_pay_fact
               WHERE CRDTORNAME IN (SELECT entName
                                    FROM entinfo) AND CONSDATE >= @sendDate AND CONSDATE <= @firstDate
               GROUP BY CRDTORNAME) B
         WHERE A.CRDTORNAME = B.CRDTORNAME
       ) C
  GROUP BY CRDTORNAME
);
ALTER TABLE rh_lastTwelveMonCrdtRatio
  ADD INDEX index_CRDTORNAME (CRDTORNAME);
DROP TABLE IF EXISTS rh_thirteenToTwentyFourCrdtRatio;
CREATE TABLE rh_thirteenToTwentyFourCrdtRatio AS (-- 计算13-24月 企业付款比例的最大值
  SELECT
    CRDTORNAME,
    MAX(MAMT) AS crdtratio
  FROM (
         SELECT
           A.CRDTORNAME    CRDTORNAME,
           A.DEBTORNAME,
           A.AAMT / B.BAMT MAMT
         FROM (
                SELECT
                  CRDTORNAME,
                  DEBTORNAME,
                  SUM(AMT) AAMT
                FROM psdas_o_pay_fact
                WHERE CRDTORNAME IN (SELECT entName
                                     FROM entinfo) AND CONSDATE >= @fourDate AND CONSDATE <= @thirdDate
                GROUP BY CRDTORNAME, DEBTORNAME) A
           , (
               SELECT
                 CRDTORNAME,
                 SUM(AMT) BAMT
               FROM psdas_o_pay_fact
               WHERE CRDTORNAME IN (SELECT entName
                                    FROM entinfo) AND CONSDATE >= @fourDate AND CONSDATE <= @thirdDate
               GROUP BY CRDTORNAME) B
         WHERE A.CRDTORNAME = B.CRDTORNAME
       ) C
  GROUP BY CRDTORNAME
);
ALTER TABLE rh_thirteenToTwentyFourCrdtRatio
  ADD INDEX index_CRDTORNAME (CRDTORNAME);
/**
资金投向集中度 收款方向
根据付款的两个比例计算集中度 **/
DROP TABLE IF EXISTS rh_money_zjtx_crdt_temp;
CREATE TABLE rh_money_zjtx_crdt_temp AS (
  SELECT
    tm.CRDTORNAME,
    tm.crdtratio - tt.crdtratio AS hindex
  FROM rh_lastTwelveMonCrdtRatio tm LEFT JOIN rh_thirteenToTwentyFourCrdtRatio tt ON tm.CRDTORNAME = tt.CRDTORNAME
);
ALTER TABLE rh_money_zjtx_crdt_temp
  ADD INDEX index_CRDTORNAME (CRDTORNAME);
/** 资金异动临时表
匹配查询企业之每月收款金额大于1.5倍过去12个月收款金额标准差的月份数
**/

/**过去12个月每月付款总金额 临时表 **/
DROP TABLE IF EXISTS rh_12PerMonthDebtData_temp;
CREATE TABLE rh_12PerMonthDebtData_temp AS
  (
    SELECT
      t.DEBTORNAME,
      SUBSTRING(t.CONSDATE, 1, 6) consmonth,
      sum(t.AMT)    AS            totalamt,
      sum(t.NUMBER) AS            totalnumer,
      '每个月'
    FROM psdas_o_pay_fact t
    WHERE t.DEBTORNAME IN (SELECT entName
                           FROM entinfo) AND t.CONSDATE >= @sendDate AND t.CONSDATE <= @firstDate
    GROUP BY t.DEBTORNAME, SUBSTRING(t.CONSDATE, 1, 6)
  );
ALTER TABLE rh_12PerMonthDebtData_temp
  ADD INDEX index_DEBTORNAME (DEBTORNAME);
/**过去12个月每月收款总金额 临时表 **/
DROP TABLE IF EXISTS rh_12PerMonthCredtData_temp;
CREATE TABLE rh_12PerMonthCredtData_temp AS
  (
    SELECT
      t.CRDTORNAME,
      SUBSTRING(t.CONSDATE, 1, 6),
      sum(t.AMT)    AS totalamt,
      sum(t.NUMBER) AS totalnumer,
      '每个月'
    FROM psdas_o_pay_fact t
    WHERE t.CRDTORNAME IN (SELECT entName
                           FROM entinfo) AND t.CONSDATE >= @sendDate AND t.CONSDATE <= @firstDate
    GROUP BY t.CRDTORNAME, SUBSTRING(t.CONSDATE, 1, 6)
  );
ALTER TABLE rh_12PerMonthCredtData_temp
  ADD INDEX index_CRDTORNAME (CRDTORNAME);
-- select * from rh_12PerMonthCredtData_temp;
-- select * from rh_12PerMonthCredtData_temp;

/** 资金异动付款方向01临时表
简化算法：匹配查询企业之每月付款金额大于1.5倍过去12个月付款金额平均值的月份数**/
DROP TABLE IF EXISTS rh_money_change_debt01_temp;
CREATE TABLE rh_money_change_debt01_temp AS (
  SELECT
    tp.DEBTORNAME,
    sum(if(tp.totalamt > (tm.12DebtTotalAmt / 12 * 1.5), 1, 0)) AS num
  FROM rh_12PerMonthDebtData_temp tp
    LEFT JOIN rh_12MonthDebtData tm
      ON tp.DEBTORNAME = tm.DEBTORNAME
  GROUP BY tp.DEBTORNAME
);
ALTER TABLE rh_money_change_debt01_temp
  ADD INDEX index_DEBTORNAME (DEBTORNAME);
/** 资金异动收款方向02临时表
简化算法：匹配查询企业之每月收款金额大于1.5倍过去12个月付款金额平均值的月份数**/
DROP TABLE IF EXISTS rh_money_change_crdt02_temp;
CREATE TABLE rh_money_change_crdt02_temp AS (
  SELECT
    tp.CRDTORNAME,
    sum(if(tp.totalamt > (tm.12CreTotalAmt / 12 * 1.5), 1, 0)) AS num
  FROM rh_12PerMonthCredtData_temp tp
    LEFT JOIN rh_12MonthCrdtData tm
      ON tp.CRDTORNAME = tm.CRDTORNAME
  GROUP BY tp.CRDTORNAME
);
ALTER TABLE rh_money_change_crdt02_temp
  ADD INDEX index_CRDTORNAME (CRDTORNAME);
-- select * from rh_money_change_debt01_temp;
-- select * from rh_money_change_crdt02_temp;

/**
资金规模变化(趋势）
匹配查询企业之过去12个月/13-24个月总交易金额（总收款金额+总付款金额）的比值
**/
DROP TABLE IF EXISTS rh_money_scale_temp;
CREATE TABLE rh_money_scale_temp AS
  SELECT
    a.DEBTORNAME,
    a.12amt/ (b.24amt-12amt
) amtRatio FROM
(
SELECT a.DEBTORNAME, a.12DebtTotalAmt+b.12CreTotalAmt 12amt FROM rh_12MonthDebtData a LEFT JOIN rh_12MonthCrdtData b ON a.DEBTORNAME = b.CRDTORNAME
)a LEFT JOIN
(
SELECT a.DEBTORNAME, a.24DebtTotalAmt+b.24CreTotalAmt 24amt FROM rh_24MonthDebtData a LEFT JOIN rh_24MonthCrdtData b ON a.DEBTORNAME = b.CRDTORNAME
) b ON a.DEBTORNAME = b.DEBTORNAME;
ALTER TABLE rh_money_scale_temp
  ADD INDEX index_DEBTORNAME (DEBTORNAME);
-- select * from rh_money_scale_temp ;-- 资金规模变化(趋势）

/**
现金流趋势
匹配查询企业之过去12个月总交易净额（总收款金额-总付款金额）的比率
**/
DROP TABLE IF EXISTS rh_cash_flow_temp;
CREATE TABLE rh_cash_flow_temp AS (
  SELECT
    a.CRDTORNAME,
    if(
        b .12DebtTotalAmt=0, -9999, (a.12CreTotalAmt-b.12DebtTotalAmt) / b.12DebtTotalAmt) rate FROM rh_12MonthCrdtData a LEFT JOIN rh_12MonthDebtData b ON a.CRDTORNAME = b.DEBTORNAME
);
ALTER TABLE rh_cash_flow_temp
  ADD INDEX index_CRDTORNAME (CRDTORNAME);

-- 统计行政处罚次数
DROP TABLE IF EXISTS rh_penalty_count;
CREATE TABLE rh_penalty_count AS (
  SELECT
    ent_name,
    sum(count) AS penalty_count
  FROM
    (SELECT
       ent_name,
       count(id) AS count
     FROM qcc_basic_penalty
     GROUP BY ent_name
     UNION ALL
     SELECT
       ent_name,
       count(id) AS count
     FROM qcc_basic_penalty_credit_china
     GROUP BY ent_name) AS A
  GROUP BY ent_name
);
