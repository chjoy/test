
set @firstDate = '20181231';
set @sendDate = '20180101';
set @thirdDate = '20171231';
set @fourDate = '20170101';

/**24个月 付款信息**/
drop table if exists rh_24MonthDebtData;
CREATE table rh_24MonthDebtData AS
  (
    SELECT t.DEBTORNAME,sum(t.AMT) as 24DebtTotalAmt,sum(t.NUMBER) as 24DebtTotalNumer,'24个月' from psdas_o_pay_fact t
    where t.DEBTORNAME in (select entName from entinfo) and t.CONSDATE>=@fourDate and t.CONSDATE<=@firstDate
    GROUP BY t.DEBTORNAME
  );
ALTER TABLE rh_24MonthDebtData add index index_dpt (DEBTORNAME);


/**12个月 付款信息 临时表**/
drop table if exists rh_12MonthDebtData;
create table rh_12MonthDebtData AS
  (

    SELECT t.DEBTORNAME,sum(t.amt) as 12DebtTotalAmt,sum(t.number) as 12DebtTotalNumer,'12个月' FROM psdas_o_pay_fact t
    where t.DEBTORNAME in (select entName from entinfo) and t.CONSDATE>=@sendDate and t.CONSDATE<=@firstDate
    GROUP BY t.DEBTORNAME
  );
ALTER TABLE rh_12MonthDebtData add index index_DEBTORNAME (DEBTORNAME);

/**24个月 收款信息 临时表 **/
drop table if exists rh_24MonthCrdtData;
CREATE table rh_24MonthCrdtData AS
  (
    SELECT t.CRDTORNAME,sum(t.AMT) as 24CreTotalAmt,sum(t.NUMBER) as 24CreTotalNumer,'24个月' from psdas_o_pay_fact t
    where t.CRDTORNAME in (select entName from entinfo) and t.CONSDATE>=@fourDate and t.CONSDATE<=@firstDate
    GROUP BY t.CRDTORNAME
  );
ALTER TABLE rh_24MonthCrdtData add index index_CRDTORNAME (CRDTORNAME);
/**12个月 收款信息 临时表**/
drop table if exists rh_12MonthCrdtData;
create table  rh_12MonthCrdtData AS
  (

    SELECT t.CRDTORNAME,sum(t.amt) as 12CreTotalAmt,sum(t.number) as 12CreTotalNumer,'12个月' FROM psdas_o_pay_fact t
    where t.CRDTORNAME in (select entName from entinfo) and t.CONSDATE>=@sendDate and t.CONSDATE<=@firstDate
    GROUP BY t.CRDTORNAME
  );
ALTER TABLE rh_12MonthCrdtData add index index_CRDTORNAME (CRDTORNAME);


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
drop table if exists rh_company_scale_temp;
create table rh_company_scale_temp as (
  select  a.DEBTORNAME,(a.24DebtTotalAmt+b.24CreTotalAmt)/24 as scaleAmt from rh_24MonthDebtData a left join rh_24MonthCrdtData b on a.DEBTORNAME = b.CRDTORNAME
);
ALTER TABLE rh_company_scale_temp add index index_DEBTORNAME (DEBTORNAME);
/**  企业行业
创建企业行业变量临时表   **/
drop table if exists rh_company_industry_info_temp;
create table rh_company_industry_info_temp AS
  (
    select DISTINCT * from (
                             SELECT DISTINCT t.DEBTORNAME as compname,t.Debt_industry as industrycode FROM psdas_o_pay_fact t where t.DEBTORNAME in (select entName from entinfo)
                             UNION
                             SELECT DISTINCT t.CRDTORNAME as compname,t.Recv_industry as industrycode FROM psdas_o_pay_fact t where t.CRDTORNAME in (select entName from entinfo)
                           ) as A
  );
ALTER TABLE rh_company_industry_info_temp add index index_compname (compname);
ALTER TABLE rh_company_industry_info_temp add index index_industrycode (industrycode);
-- select * from rh_company_industry_info_temp;

/** 企业地域查询 **/
/**select * from entinfo WHERE entName in (select @empname) ;
**/

/** 企业经营年限临时表  **/
drop table if exists rh_company_age_temp;
create table rh_company_age_temp AS
  (
    select DEBTORNAME,min(CONSDATE) as em from psdas_o_pay_fact  where DEBTORNAME in (select entName from entinfo) group by DEBTORNAME
  );
ALTER TABLE rh_company_age_temp add index index_DEBTORNAME (DEBTORNAME);

/**
资金投向集中度 付款方向
匹配查询企业之过去12个月/13-24个月各付款人名称付款金额的集中指数
**/
drop table if exists rh_lastTwelveMonDebtRatio;
create table rh_lastTwelveMonDebtRatio as(-- 先算12个月 企业付款比例的最大值
  SELECT DEBTORNAME,MAX(MAMT) as debtratio FROM (
                                                  SELECT A.DEBTORNAME DEBTORNAME ,A.CRDTORNAME,A.AAMT/B.BAMT MAMT FROM (
                                                                                                                         SELECT DEBTORNAME,CRDTORNAME,SUM(AMT) AAMT
                                                                                                                         FROM psdas_o_pay_fact
                                                                                                                         where DEBTORNAME in (select entName from entinfo) and CONSDATE>=@sendDate and CONSDATE<=@firstDate
                                                                                                                         GROUP BY DEBTORNAME,CRDTORNAME) A
                                                    ,(
                                                       SELECT DEBTORNAME ,SUM(AMT) BAMT
                                                       FROM psdas_o_pay_fact
                                                       where DEBTORNAME in (select entName from entinfo) and CONSDATE>=@sendDate and CONSDATE<=@firstDate
                                                       GROUP BY DEBTORNAME) B
                                                  WHERE A.DEBTORNAME = B.DEBTORNAME
                                                ) C GROUP BY DEBTORNAME
);
ALTER TABLE rh_lastTwelveMonDebtRatio add index index_DEBTORNAME (DEBTORNAME);

drop table if exists rh_thirteenToTwentyFourDebtRatio;
create table rh_thirteenToTwentyFourDebtRatio as(-- 计算13-24月 企业付款比例的最大值
  SELECT DEBTORNAME,MAX(MAMT) as debtratio FROM (
                                                  SELECT A.DEBTORNAME DEBTORNAME ,A.CRDTORNAME,A.AAMT/B.BAMT MAMT FROM (
                                                                                                                         SELECT DEBTORNAME,CRDTORNAME,SUM(AMT) AAMT
                                                                                                                         FROM psdas_o_pay_fact
                                                                                                                         where DEBTORNAME in (select entName from entinfo) and CONSDATE>=@fourDate and CONSDATE<=@thirdDate
                                                                                                                         GROUP BY DEBTORNAME,CRDTORNAME) A
                                                    ,(
                                                       SELECT DEBTORNAME ,SUM(AMT) BAMT
                                                       FROM psdas_o_pay_fact
                                                       where DEBTORNAME in (select entName from entinfo) and CONSDATE>=@fourDate and CONSDATE<=@thirdDate
                                                       GROUP BY DEBTORNAME) B
                                                  WHERE A.DEBTORNAME = B.DEBTORNAME
                                                ) C GROUP BY DEBTORNAME
);
ALTER TABLE rh_thirteenToTwentyFourDebtRatio add index index_DEBTORNAME (DEBTORNAME);
/**
资金投向集中度 付款方向
根据付款的两个比例计算集中度 **/
drop table if exists rh_money_zjtx_debt_temp;
create table rh_money_zjtx_debt_temp as (
  select tm.DEBTORNAME,tm.debtratio-tt.debtratio as hindex from rh_lastTwelveMonDebtRatio tm left join rh_thirteenToTwentyFourDebtRatio tt on tm.DEBTORNAME = tt.DEBTORNAME
);
ALTER TABLE rh_money_zjtx_debt_temp add index index_DEBTORNAME (DEBTORNAME);

/**
资金投向集中度 收款方向
匹配查询企业之过去12个月/13-24个月各收款人名称付款金额的集中指数
**/
drop table if exists rh_lastTwelveMonCrdtRatio;
create table rh_lastTwelveMonCrdtRatio as(-- 先算12个月 企业收款比例的最大值
  SELECT CRDTORNAME,MAX(MAMT) as crdtratio FROM (
                                                  SELECT A.CRDTORNAME CRDTORNAME,A.DEBTORNAME,A.AAMT/B.BAMT MAMT FROM (
                                                                                                                        SELECT CRDTORNAME,DEBTORNAME,SUM(AMT) AAMT
                                                                                                                        FROM psdas_o_pay_fact
                                                                                                                        where CRDTORNAME in (select entName from entinfo) and CONSDATE>=@sendDate and CONSDATE<=@firstDate
                                                                                                                        GROUP BY CRDTORNAME,DEBTORNAME) A
                                                    ,(
                                                       SELECT CRDTORNAME ,SUM(AMT) BAMT
                                                       FROM psdas_o_pay_fact
                                                       where CRDTORNAME in (select entName from entinfo) and CONSDATE>=@sendDate and CONSDATE<=@firstDate
                                                       GROUP BY CRDTORNAME) B
                                                  WHERE A.CRDTORNAME = B.CRDTORNAME
                                                ) C GROUP BY CRDTORNAME
);
ALTER TABLE rh_lastTwelveMonCrdtRatio add index index_CRDTORNAME (CRDTORNAME);
drop table if exists rh_thirteenToTwentyFourCrdtRatio;
create table rh_thirteenToTwentyFourCrdtRatio as( -- 计算13-24月 企业付款比例的最大值
  SELECT CRDTORNAME,MAX(MAMT) as crdtratio FROM (
                                                  SELECT A.CRDTORNAME CRDTORNAME,A.DEBTORNAME,A.AAMT/B.BAMT MAMT FROM (
                                                                                                                        SELECT CRDTORNAME,DEBTORNAME,SUM(AMT) AAMT
                                                                                                                        FROM psdas_o_pay_fact
                                                                                                                        where CRDTORNAME in (select entName from entinfo) and CONSDATE>=@fourDate and CONSDATE<=@thirdDate
                                                                                                                        GROUP BY CRDTORNAME,DEBTORNAME) A
                                                    ,(
                                                       SELECT CRDTORNAME ,SUM(AMT) BAMT
                                                       FROM psdas_o_pay_fact
                                                       where CRDTORNAME in (select entName from entinfo) and CONSDATE>=@fourDate and CONSDATE<=@thirdDate
                                                       GROUP BY CRDTORNAME) B
                                                  WHERE A.CRDTORNAME = B.CRDTORNAME
                                                ) C GROUP BY CRDTORNAME
);
ALTER TABLE rh_thirteenToTwentyFourCrdtRatio add index index_CRDTORNAME (CRDTORNAME);
/**
资金投向集中度 收款方向
根据付款的两个比例计算集中度 **/
drop table if exists rh_money_zjtx_crdt_temp;
create table rh_money_zjtx_crdt_temp as (
  select tm.CRDTORNAME,tm.crdtratio-tt.crdtratio as hindex from rh_lastTwelveMonCrdtRatio tm left join rh_thirteenToTwentyFourCrdtRatio tt on tm.CRDTORNAME = tt.CRDTORNAME
);
ALTER TABLE rh_money_zjtx_crdt_temp add index index_CRDTORNAME (CRDTORNAME);
/** 资金异动临时表
匹配查询企业之每月收款金额大于1.5倍过去12个月收款金额标准差的月份数
**/

/**过去12个月每月付款总金额 临时表 **/
drop table if exists rh_12PerMonthDebtData_temp;
CREATE table rh_12PerMonthDebtData_temp AS
  (
    SELECT t.DEBTORNAME,SUBSTRING(t.CONSDATE,1,6) consmonth ,sum(t.AMT) as totalamt,sum(t.NUMBER) as totalnumer,'每个月' from psdas_o_pay_fact t
    where t.DEBTORNAME in (select entName from entinfo) and t.CONSDATE>=@sendDate and t.CONSDATE<=@firstDate
    GROUP BY t.DEBTORNAME,SUBSTRING(t.CONSDATE , 1 , 6)
  );
ALTER TABLE rh_12PerMonthDebtData_temp add index index_DEBTORNAME (DEBTORNAME);
/**过去12个月每月收款总金额 临时表 **/
drop table if exists rh_12PerMonthCredtData_temp;
CREATE table rh_12PerMonthCredtData_temp AS
  (
    SELECT t.CRDTORNAME,SUBSTRING(t.CONSDATE , 1 , 6) ,sum(t.AMT) as totalamt,sum(t.NUMBER) as totalnumer,'每个月' from psdas_o_pay_fact t
    where t.CRDTORNAME in (select entName from entinfo) and t.CONSDATE>=@sendDate and t.CONSDATE<=@firstDate
    GROUP BY t.CRDTORNAME,SUBSTRING(t.CONSDATE , 1 , 6)
  );
ALTER TABLE rh_12PerMonthCredtData_temp add index index_CRDTORNAME (CRDTORNAME);
-- select * from rh_12PerMonthCredtData_temp;
-- select * from rh_12PerMonthCredtData_temp;

/** 资金异动付款方向01临时表
简化算法：匹配查询企业之每月付款金额大于1.5倍过去12个月付款金额平均值的月份数**/
drop table if exists rh_money_change_debt01_temp;
create table  rh_money_change_debt01_temp as(
  select tp.DEBTORNAME ,sum(if(tp.totalamt>(tm.12DebtTotalAmt/12*1.5),1,0)) as num
  from rh_12PerMonthDebtData_temp tp
    left join rh_12MonthDebtData tm
      on tp.DEBTORNAME = tm.DEBTORNAME
  group BY tp.DEBTORNAME
);
ALTER TABLE rh_money_change_debt01_temp add index index_DEBTORNAME (DEBTORNAME);
/** 资金异动收款方向02临时表
简化算法：匹配查询企业之每月收款金额大于1.5倍过去12个月付款金额平均值的月份数**/
drop table if exists rh_money_change_crdt02_temp;
create table rh_money_change_crdt02_temp as(
  select tp.CRDTORNAME ,sum(if(tp.totalamt>(tm.12CreTotalAmt/12*1.5),1,0)) as num
  from rh_12PerMonthCredtData_temp tp
    left join rh_12MonthCrdtData tm
      on tp.CRDTORNAME = tm.CRDTORNAME
  group BY tp.CRDTORNAME
);
ALTER TABLE rh_money_change_crdt02_temp add index index_CRDTORNAME (CRDTORNAME);
-- select * from rh_money_change_debt01_temp;
-- select * from rh_money_change_crdt02_temp;

/**
资金规模变化(趋势）
匹配查询企业之过去12个月/13-24个月总交易金额（总收款金额+总付款金额）的比值
**/
drop table if exists rh_money_scale_temp;
create table rh_money_scale_temp as
  select a.DEBTORNAME,a.12amt/(b.24amt-12amt) amtRatio from
(
select a.DEBTORNAME,a.12DebtTotalAmt+b.12CreTotalAmt 12amt from rh_12MonthDebtData a left join rh_12MonthCrdtData b on a.DEBTORNAME = b.CRDTORNAME
)a left join
(
select a.DEBTORNAME,a.24DebtTotalAmt+b.24CreTotalAmt 24amt from rh_24MonthDebtData a left join rh_24MonthCrdtData b on a.DEBTORNAME = b.CRDTORNAME
) b on a.DEBTORNAME = b.DEBTORNAME
;
ALTER TABLE rh_money_scale_temp add index index_DEBTORNAME (DEBTORNAME);
-- select * from rh_money_scale_temp ;-- 资金规模变化(趋势）

/**
现金流趋势
匹配查询企业之过去12个月总交易净额（总收款金额-总付款金额）的比率
**/
drop table if exists rh_cash_flow_temp;
create table rh_cash_flow_temp as (
  select a.CRDTORNAME, if(b.12DebtTotalAmt=0,-9999,(a.12CreTotalAmt-b.12DebtTotalAmt)/b.12DebtTotalAmt) rate from rh_12MonthCrdtData a left join rh_12MonthDebtData b on a.CRDTORNAME = b.DEBTORNAME
);
ALTER TABLE rh_cash_flow_temp add index index_CRDTORNAME (CRDTORNAME);