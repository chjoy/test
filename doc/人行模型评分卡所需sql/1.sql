create table tmp_1_1 as (

  select B.*,C.year_count as year_count1 from
    (select distinct Debt_industry from psdas_o_pay_fact )A left join
    (select CRDTORNAME,sum(Number) as year_count,Debt_industry
     from psdas_o_pay_fact
     where CONSDATE >= '20170701' and CONSDATE < '20180701' group by CRDTORNAME,Debt_industry)B on A.Debt_industry = B.Debt_industry left join
    (select CRDTORNAME,sum(Number) as year_count,Debt_industry
     from psdas_o_pay_fact
     where  CONSDATE >= '20180701' and CONSDATE < '20190701' group by CRDTORNAME,Debt_industry)C on B.Debt_industry  = C.Debt_industry and B.CRDTORNAME = C.CRDTORNAME

);

create table tmp_1_2 as (

  select CRDTORNAME,sum(year_count)/20 as x_avg,sum(year_count1)/20 as y_avg
  from tmp_1_1 group by CRDTORNAME

);

create table tmp_1_3 as (

  select A.CRDTORNAME as CRDTORNAME,sum((A.year_count-B.x_avg)*(A.year_count1-B.y_avg)) as mo,pow(sum((A.year_count-B.x_avg)*(A.year_count-B.x_avg))*sum((A.year_count1-B.y_avg)*(A.year_count1-B.y_avg)),1/2) as de
  from tmp_1_1 A inner join tmp_1_2 B on A.CRDTORNAME = B.CRDTORNAME group by A.CRDTORNAME

);
-- select @x_avg := sum(year_count)/20 from tmp_1_1;

-- select @y_avg := sum(year_count1)/20 from tmp_1_1;

-- select @mo:=sum((year_count-@x_avg)*(year_count1-@y_avg)) from tmp_1_1 group by CRDTORNAME;

-- select @de := pow(sum((year_count-@x_avg)*(year_count-@x_avg))*sum((year_count1-@y_avg)*(year_count1-@y_avg)),1/2) from tmp_1_1 group by CRDTORNAME;

create table tmp_1_4_end as (
  select CRDTORNAME,mo/de as pearson from tmp_1_3
);