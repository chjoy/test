DROP TABLE IF EXISTS rh_score_var_temp01;
CREATE TABLE rh_score_var_temp01 AS (
  SELECT
    a.DEBTORNAME,
    cast(a.scaleAmt / 10000.00 AS SIGNED) AS scaleAmt,
    b.industrycode,
    c.areaName,
    TIMESTAMPDIFF(MONTH, d.em, now()) / 12   em,
    e.pearson                                p01,
    f.pearson                                p02,
    g.hindex                                 h01,
    h.pearson                                p03,
    i.hindex                                 h02,
    j.pearson                                p04,
    k.num                                    n01,
    l.num                                    n02,
    m.amtRatio,
    n.rate
  FROM rh_company_scale_temp a
    LEFT JOIN rh_company_industry_info_temp b ON a.DEBTORNAME = b.compname
    LEFT JOIN entinfo c ON a.DEBTORNAME = c.entName
    LEFT JOIN rh_company_age_temp d ON a.DEBTORNAME = d.DEBTORNAME
    LEFT JOIN rh_crdt_relation_tmp_end e ON a.DEBTORNAME = e.CRDTORNAME
    LEFT JOIN rh_debt_relation_tmp_end f ON a.DEBTORNAME = f.DEBTORNAME
    LEFT JOIN rh_money_zjtx_debt_temp g ON a.DEBTORNAME = g.DEBTORNAME
    LEFT JOIN rh_money_zjwd_debt_temp_end h ON a.DEBTORNAME = h.CRDTORNAME
    LEFT JOIN rh_money_zjtx_crdt_temp i ON a.DEBTORNAME = i.CRDTORNAME
    LEFT JOIN rh_money_ziwd_crdt_temp_end j ON a.DEBTORNAME = j.DEBTORNAME
    LEFT JOIN rh_money_change_debt01_temp k ON a.DEBTORNAME = k.DEBTORNAME
    LEFT JOIN rh_money_change_crdt02_temp l ON a.DEBTORNAME = l.CRDTORNAME
    LEFT JOIN rh_money_scale_temp m ON a.DEBTORNAME = m.DEBTORNAME
    LEFT JOIN rh_cash_flow_temp n ON a.DEBTORNAME = n.CRDTORNAME
);



