
-- 匹配查询企业之过去12个月/13-24个月各行业付款次数之相关系数

create table tmp_2_1 as (

  select A.DEBTORNAME,B.Recv_industry,case when C.year_count is null then 0 else c.year_count end  as year_count ,case when D.year_count is null then 0 else D.year_count end as year_count1 from
    (select distinct DEBTORNAME from psdas_o_pay_fact )A join
    (select distinct Recv_industry from psdas_o_pay_fact )B left join
    (select DEBTORNAME,sum(Number) as year_count,Recv_industry
     from psdas_o_pay_fact
     where CONSDATE >= '20170701' and CONSDATE < '20180701' group by DEBTORNAME,Recv_industry)C on B.Recv_industry = C.Recv_industry and A.DEBTORNAME = C.DEBTORNAME left join
    (select DEBTORNAME,sum(Number) as year_count,Recv_industry
     from psdas_o_pay_fact
     where  CONSDATE >= '20180701' and CONSDATE < '20190701' group by DEBTORNAME,Recv_industry)D on B.Recv_industry  = D.Recv_industry and A.DEBTORNAME = D.DEBTORNAME

);

create table tmp_2_2 as (

  select DEBTORNAME,sum(year_count)/22 as x_avg,sum(year_count1)/22 as y_avg
  from tmp_2_1 group by DEBTORNAME

);

create table tmp_2_3 as (

  select A.DEBTORNAME as DEBTORNAME,sum((A.year_count-B.x_avg)*(A.year_count1-B.y_avg)) as mo,pow(sum((A.year_count-B.x_avg)*(A.year_count-B.x_avg))*sum((A.year_count1-B.y_avg)*(A.year_count1-B.y_avg)),1/2) as de
  from tmp_2_1 A inner join tmp_2_2 B on A.DEBTORNAME = B.DEBTORNAME group by A.DEBTORNAME

);

create table tmp_2_4_end as (
  select DEBTORNAME,mo/de as pearson from tmp_2_3
)