
-- 匹配查询企业之过去12个月/13-24个月各收款人名称收款金额的相关系数

create table tmp_4_1 as (

  select B.*,C.year_count as year_count1 from
    (select distinct CRDTORNAME,DEBTORNAME from psdas_o_pay_fact )A left join
    (select CRDTORNAME,sum(Number) as year_count,DEBTORNAME
     from psdas_o_pay_fact
     where CONSDATE >= '20170701' and CONSDATE < '20180701' group by CRDTORNAME,DEBTORNAME)B on A.CRDTORNAME = B.CRDTORNAME and A.DEBTORNAME = B.DEBTORNAME left join
    (select CRDTORNAME,sum(Number) as year_count,DEBTORNAME
     from psdas_o_pay_fact
     where  CONSDATE >= '20180701' and CONSDATE < '20190701' group by CRDTORNAME,DEBTORNAME)C on A.DEBTORNAME  = C.DEBTORNAME and A.CRDTORNAME = C.CRDTORNAME

);

create table tmp_4_2 as (

  select DEBTORNAME,sum(year_count)/count(year_count) as x_avg,sum(year_count1)/count(year_count) as y_avg
  from tmp_3_1 group by DEBTORNAME

);

create table tmp_4_3 as (

  select A.DEBTORNAME as DEBTORNAME,sum((A.year_count-B.x_avg)*(A.year_count1-B.y_avg)) as mo,pow(sum((A.year_count-B.x_avg)*(A.year_count-B.x_avg))*sum((A.year_count1-B.y_avg)*(A.year_count1-B.y_avg)),1/2) as de
  from tmp_3_1 A inner join tmp_4_2 B on A.DEBTORNAME = B.DEBTORNAME group by A.DEBTORNAME

);
-- select @x_avg := sum(year_count)/20 from tmp_1_1;

-- select @y_avg := sum(year_count1)/20 from tmp_1_1;

-- select @mo:=sum((year_count-@x_avg)*(year_count1-@y_avg)) from tmp_1_1 group by CRDTORNAME;

-- select @de := pow(sum((year_count-@x_avg)*(year_count-@x_avg))*sum((year_count1-@y_avg)*(year_count1-@y_avg)),1/2) from tmp_1_1 group by CRDTORNAME;

create table tmp_4_4_end as (
  select DEBTORNAME,mo/de as pearson from tmp_4_3
);