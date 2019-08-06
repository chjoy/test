
set @firstDate = '20181231';
set @sendDate = '20180101';
set @thirdDate = '20171231';
set @fourDate = '20170101';
set @industryCount = 22;
/**
资金来源稳定度
匹配查询企业之过去12个月/13-24个月各收款人名称收款金额的相关系数
**/
drop table if EXISTS rh_money_ziwd_crdt_temp_1;
create table rh_money_ziwd_crdt_temp_1 as (

  select B.*,C.year_count as year_count1 from
    (select distinct CRDTORNAME,DEBTORNAME from psdas_o_pay_fact WHERE DEBTORNAME in (select entName from entinfo))A left join
    (select CRDTORNAME,sum(Number) as year_count,DEBTORNAME
     from psdas_o_pay_fact
     where DEBTORNAME in (select entName from entinfo) and CONSDATE >= @fourDate and CONSDATE <= @thirdDate group by CRDTORNAME,DEBTORNAME)B on A.CRDTORNAME = B.CRDTORNAME and A.DEBTORNAME = B.DEBTORNAME left join
    (select CRDTORNAME,sum(Number) as year_count,DEBTORNAME
     from psdas_o_pay_fact
     where DEBTORNAME in (select entName from entinfo) and CONSDATE >= @sendDate and CONSDATE <= @firstDate group by CRDTORNAME,DEBTORNAME)C on A.DEBTORNAME  = C.DEBTORNAME and A.CRDTORNAME = C.CRDTORNAME

);
ALTER TABLE rh_money_ziwd_crdt_temp_1 add index index_CRDTORNAME (CRDTORNAME);
ALTER TABLE rh_money_ziwd_crdt_temp_1 add index index_DEBTORNAME (DEBTORNAME);

drop table if EXISTS rh_money_ziwd_crdt_temp_2;
create table rh_money_ziwd_crdt_temp_2 as (

  select DEBTORNAME,sum(year_count)/count(year_count) as x_avg,sum(year_count1)/count(year_count) as y_avg
  from rh_money_ziwd_crdt_temp_1 group by DEBTORNAME

);
ALTER TABLE rh_money_ziwd_crdt_temp_2 add index index_DEBTORNAME (DEBTORNAME);

drop table if EXISTS rh_money_ziwd_crdt_temp_3;
create table rh_money_ziwd_crdt_temp_3 as (

  select A.DEBTORNAME as DEBTORNAME,sum((A.year_count-B.x_avg)*(A.year_count1-B.y_avg)) as mo,pow(sum((A.year_count-B.x_avg)*(A.year_count-B.x_avg))*sum((A.year_count1-B.y_avg)*(A.year_count1-B.y_avg)),1/2) as de
  from rh_money_ziwd_crdt_temp_1 A inner join rh_money_ziwd_crdt_temp_2 B on A.DEBTORNAME = B.DEBTORNAME group by A.DEBTORNAME

);
ALTER TABLE rh_money_ziwd_crdt_temp_3 add index index_DEBTORNAME (DEBTORNAME);

drop table if EXISTS rh_money_ziwd_crdt_temp_end;
create table rh_money_ziwd_crdt_temp_end as (
  select DEBTORNAME,case de when 0 then null else mo/de end as pearson from rh_money_ziwd_crdt_temp_3
);
ALTER TABLE rh_money_ziwd_crdt_temp_end add index index_DEBTORNAME (DEBTORNAME);
-- select * from rh_money_ziwd_crdt_temp_end;
