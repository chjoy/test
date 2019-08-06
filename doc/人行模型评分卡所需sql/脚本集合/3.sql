set @firstDate = '20181231';
set @sendDate = '20180101';
set @thirdDate = '20171231';
set @fourDate = '20170101';
set @industryCount = 22;

/** 与买方（下游）关系稳定度
 匹配查询企业之过去12个月/13-24个月各行业收款次数之相关系数
 **/
drop table if EXISTS rh_crdt_relation_tmp_1;
create table rh_crdt_relation_tmp_1 as (
  select A.CRDTORNAME,B.Debt_industry,case when C.year_count is null then 0 else C.year_count end  as year_count ,case when D.year_count is null then 0 else D.year_count end as year_count1 from
    (select distinct entName as CRDTORNAME from entinfo)A join
    (select distinct Debt_industry from psdas_o_pay_fact )B left join
    (select CRDTORNAME,sum(Number) as year_count,Debt_industry
     from psdas_o_pay_fact
     where CRDTORNAME in (select entName from entinfo) and CONSDATE >= @fourDate and CONSDATE <= @thirdDate group by CRDTORNAME,Debt_industry)C on B.Debt_industry = C.Debt_industry and C.CRDTORNAME = A.CRDTORNAME left join
    (select CRDTORNAME,sum(Number) as year_count,Debt_industry
     from psdas_o_pay_fact
     where CRDTORNAME in (select entName from entinfo) and CONSDATE >= @sendDate and CONSDATE <= @firstDate group by CRDTORNAME,Debt_industry)D on B.Debt_industry  = D.Debt_industry and D.CRDTORNAME = A.CRDTORNAME
);
ALTER TABLE rh_crdt_relation_tmp_1 add index index_CRDTORNAME (CRDTORNAME);

drop table if EXISTS rh_crdt_relation_tmp_2;
create table rh_crdt_relation_tmp_2 as (
  -- 付款人行业维度表的数据量为22
  select CRDTORNAME,sum(year_count)/@industryCount as x_avg,sum(year_count1)/@industryCount as y_avg
  from rh_crdt_relation_tmp_1 group by CRDTORNAME

);
ALTER TABLE rh_crdt_relation_tmp_2 add index index_CRDTORNAME (CRDTORNAME);
drop table if EXISTS rh_crdt_relation_tmp_3;
create table rh_crdt_relation_tmp_3 as (

  select A.CRDTORNAME as CRDTORNAME,sum((A.year_count-B.x_avg)*(A.year_count1-B.y_avg)) as mo,pow(sum((A.year_count-B.x_avg)*(A.year_count-B.x_avg))*sum((A.year_count1-B.y_avg)*(A.year_count1-B.y_avg)),1/2) as de
  from rh_crdt_relation_tmp_1 A inner join rh_crdt_relation_tmp_2 B on A.CRDTORNAME = B.CRDTORNAME group by A.CRDTORNAME

);
ALTER TABLE rh_crdt_relation_tmp_3 add index index_CRDTORNAME (CRDTORNAME);

drop table if EXISTS rh_crdt_relation_tmp_end;
/** 与买方（下游）关系稳定度 **/
create table rh_crdt_relation_tmp_end as (
  select CRDTORNAME,case de when 0 then null else mo/de end as pearson from rh_crdt_relation_tmp_3
);
ALTER TABLE rh_crdt_relation_tmp_end add index index_CRDTORNAME (CRDTORNAME);
-- select * from rh_crdt_relation_tmp_end ;