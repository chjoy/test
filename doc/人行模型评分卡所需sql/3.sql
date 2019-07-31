
-- 匹配查询企业之过去12个月/13-24个月各付款人名称付款次数的相关系数

create table tmp_3_1 as (

  select B.*,C.year_count as year_count1 from
    (select distinct CRDTORNAME,DEBTORNAME from psdas_o_pay_fact where CRDTORNAME in ('长沙冰风之洋酒业有限公司','长沙烁铪信息科技有限公司','长沙万印通印刷材料有限公司','湖南天穗农业科技有限公司','湖南博林高科股份有限公司','湖南汇富医疗器械有限公司','湖南紫博纸业有限责任公司','长沙民顺纸业有限公司','长沙祥利儿童用品有限公司','湖南攀辰图书发行有限公司','长沙市日晖百货贸易有限公司','长沙三高文化传播有限公司','长沙市丰都日用品贸易有限公司','长沙市雨花区静瑞达洗化用品有限公司','长沙沂蒙货物运输有限公司','长沙澳莱服装贸易有限公司','湖南博源医药有限公司','湖南劲帆食品贸易有限公司','怀化弘达汽车销售有限公司','长沙景程家具有限公司'
    ))A left join
    (select CRDTORNAME,sum(Number) as year_count,DEBTORNAME
     from psdas_o_pay_fact
     where CONSDATE >= '20170701' and CONSDATE < '20180701' group by CRDTORNAME,DEBTORNAME)B on A.CRDTORNAME = B.CRDTORNAME and A.DEBTORNAME = B.DEBTORNAME left join
    (select CRDTORNAME,sum(Number) as year_count,DEBTORNAME
     from psdas_o_pay_fact
     where  CONSDATE >= '20180701' and CONSDATE < '20190701' group by CRDTORNAME,DEBTORNAME)C on A.DEBTORNAME  = C.DEBTORNAME and A.CRDTORNAME = C.CRDTORNAME

);

create table tmp_3_2 as (

  select CRDTORNAME,sum(year_count)/count(year_count) as x_avg,sum(year_count1)/count(year_count) as y_avg
  from tmp_3_1 group by CRDTORNAME

);

create table tmp_3_3 as (

  select A.CRDTORNAME as CRDTORNAME,sum((A.year_count-B.x_avg)*(A.year_count1-B.y_avg)) as mo,pow(sum((A.year_count-B.x_avg)*(A.year_count-B.x_avg))*sum((A.year_count1-B.y_avg)*(A.year_count1-B.y_avg)),1/2) as de
  from tmp_3_1 A inner join tmp_3_2 B on A.CRDTORNAME = B.CRDTORNAME group by A.CRDTORNAME

);

create table tmp_3_4_end as (
  select CRDTORNAME,mo/de as pearson from tmp_3_3
);