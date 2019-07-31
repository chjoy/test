create table tmp_1_1 as (

  select A.CRDTORNAME,B.Debt_industry,case when C.year_count is null then 0 else c.year_count end  as year_count ,case when D.year_count is null then 0 else D.year_count end as year_count1 from
    (select distinct CRDTORNAME from psdas_o_pay_fact )A join
    (select distinct Debt_industry from psdas_o_pay_fact )B left join
    (select CRDTORNAME,sum(Number) as year_count,Debt_industry
     from psdas_o_pay_fact
     where CONSDATE >= '20170701' and CONSDATE < '20180701' group by CRDTORNAME,Debt_industry)C on B.Debt_industry = C.Debt_industry and C.CRDTORNAME = A.CRDTORNAME left join
    (select CRDTORNAME,sum(Number) as year_count,Debt_industry
     from psdas_o_pay_fact
     where  CONSDATE >= '20180701' and CONSDATE < '20190701' group by CRDTORNAME,Debt_industry)D on B.Debt_industry  = D.Debt_industry and D.CRDTORNAME = A.CRDTORNAME

);

create table tmp_1_2 as (
  -- 付款人行业维度表的数据量为22
  select CRDTORNAME,sum(year_count)/22 as x_avg,sum(year_count1)/22 as y_avg
  from tmp_1_1 group by CRDTORNAME

);

create table tmp_1_3 as (

  select A.CRDTORNAME as CRDTORNAME,sum((A.year_count-B.x_avg)*(A.year_count1-B.y_avg)) as mo,pow(sum((A.year_count-B.x_avg)*(A.year_count-B.x_avg))*sum((A.year_count1-B.y_avg)*(A.year_count1-B.y_avg)),1/2) as de
  from tmp_1_1 A inner join tmp_1_2 B on A.CRDTORNAME = B.CRDTORNAME group by A.CRDTORNAME

);

create table tmp_1_4_end as (
  select CRDTORNAME,mo/de as pearson from tmp_1_3
);