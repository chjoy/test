create table tmp_2_1 as (

  select B.*,C.year_count as year_count1 from
    (select distinct Recv_industry from psdas_o_pay_fact )A left join
    (select DEBTORNAME,sum(Number) as year_count,Recv_industry
     from psdas_o_pay_fact
     where CONSDATE >= '20170701' and CONSDATE < '20180701' group by DEBTORNAME,Recv_industry)B on A.Recv_industry = B.Recv_industry left join
    (select DEBTORNAME,sum(Number) as year_count,Recv_industry
     from psdas_o_pay_fact
     where  CONSDATE >= '20180701' and CONSDATE < '20190701' group by DEBTORNAME,Recv_industry)C on B.Recv_industry  = C.Recv_industry and B.DEBTORNAME = C.DEBTORNAME

);

create table tmp_2_2 as (

  select DEBTORNAME,sum(year_count)/20 as x_avg,sum(year_count1)/20 as y_avg
  from tmp_2_1 group by DEBTORNAME

);

create table tmp_2_3 as (

  select A.DEBTORNAME as DEBTORNAME,sum((A.year_count-B.x_avg)*(A.year_count1-B.y_avg)) as mo,pow(sum((A.year_count-B.x_avg)*(A.year_count-B.x_avg))*sum((A.year_count1-B.y_avg)*(A.year_count1-B.y_avg)),1/2) as de
  from tmp_2_1 A inner join tmp_2_2 B on A.DEBTORNAME = B.DEBTORNAME group by A.DEBTORNAME

);
-- select @x_avg := sum(year_count)/20 from tmp_1_1;

-- select @y_avg := sum(year_count1)/20 from tmp_1_1;

-- select @mo:=sum((year_count-@x_avg)*(year_count1-@y_avg)) from tmp_1_1 group by CRDTORNAME;

-- select @de := pow(sum((year_count-@x_avg)*(year_count-@x_avg))*sum((year_count1-@y_avg)*(year_count1-@y_avg)),1/2) from tmp_1_1 group by CRDTORNAME;

create table tmp_2_4_end as (
  select DEBTORNAME,mo/de as pearson from tmp_2_3
)