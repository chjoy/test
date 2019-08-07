set @firstDate = '20181231';
set @sendDate = '20180101';
set @thirdDate = '20171231';
set @fourDate = '20170101';
set @industryCount = 22;
/**
与供应方（上游）关系稳定度
 匹配查询企业之过去12个月/13-24个月各行业付款次数之相关系数
 **/
drop table if EXISTS rh_debt_relation_tmp_1;
create table rh_debt_relation_tmp_1 as (

  select A.DEBTORNAME,B.Recv_industry,case when C.year_count is null then 0 else C.year_count end  as year_count ,case when D.year_count is null then 0 else D.year_count end as year_count1 from
    (select distinct entName as DEBTORNAME from entinfo)A join
    (select distinct Recv_industry from psdas_o_pay_fact )B left join
    (select DEBTORNAME,sum(Number) as year_count,Recv_industry
     from psdas_o_pay_fact
     where DEBTORNAME in (select entName from entinfo) and CONSDATE >= @fourDate and CONSDATE < @thirdDate group by DEBTORNAME,Recv_industry)C on B.Recv_industry = C.Recv_industry and A.DEBTORNAME = C.DEBTORNAME left join
    (select DEBTORNAME,sum(Number) as year_count,Recv_industry
     from psdas_o_pay_fact
     where  DEBTORNAME in (select entName from entinfo) and CONSDATE >= @sendDate and CONSDATE < @firstDate group by DEBTORNAME,Recv_industry)D on B.Recv_industry  = D.Recv_industry and A.DEBTORNAME = D.DEBTORNAME

);
ALTER TABLE rh_debt_relation_tmp_1 add index index_DEBTORNAME (DEBTORNAME);

drop table if EXISTS rh_debt_relation_tmp_2;
create table rh_debt_relation_tmp_2 as (

  select DEBTORNAME,sum(year_count)/@industryCount as x_avg,sum(year_count1)/@industryCount as y_avg
  from rh_debt_relation_tmp_1 group by DEBTORNAME

);
ALTER TABLE rh_debt_relation_tmp_2 add index index_DEBTORNAME (DEBTORNAME);
drop table if EXISTS rh_debt_relation_tmp_3;
create table rh_debt_relation_tmp_3 as (

  select A.DEBTORNAME as DEBTORNAME,sum((A.year_count-B.x_avg)*(A.year_count1-B.y_avg)) as mo,pow(sum((A.year_count-B.x_avg)*(A.year_count-B.x_avg))*sum((A.year_count1-B.y_avg)*(A.year_count1-B.y_avg)),1/2) as de
  from rh_debt_relation_tmp_1 A inner join rh_debt_relation_tmp_2 B on A.DEBTORNAME = B.DEBTORNAME group by A.DEBTORNAME

);
ALTER TABLE rh_debt_relation_tmp_3 add index index_DEBTORNAME (DEBTORNAME);
drop table if EXISTS rh_debt_relation_tmp_end;
create table rh_debt_relation_tmp_end as (
  select DEBTORNAME,case de when 0 then null else mo/de end as pearson from rh_debt_relation_tmp_3
);
ALTER TABLE rh_debt_relation_tmp_end add index index_DEBTORNAME (DEBTORNAME);
-- select * from rh_debt_relation_tmp_end;