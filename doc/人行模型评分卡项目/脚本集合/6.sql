
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
    n.rate,
    o.penalty_count
  FROM entinfo c LEFT JOIN rh_company_scale_temp a ON a.DEBTORNAME = c.entName
    LEFT JOIN rh_company_industry_info_temp b ON c.entName = b.compname
    LEFT JOIN rh_company_age_temp d ON c.entName = d.DEBTORNAME
    LEFT JOIN rh_crdt_relation_tmp_end e ON c.entName = e.CRDTORNAME
    LEFT JOIN rh_debt_relation_tmp_end f ON c.entName = f.DEBTORNAME
    LEFT JOIN rh_money_zjtx_debt_temp g ON c.entName = g.DEBTORNAME
    LEFT JOIN rh_money_zjwd_debt_temp_end h ON c.entName = h.CRDTORNAME
    LEFT JOIN rh_money_zjtx_crdt_temp i ON c.entName = i.CRDTORNAME
    LEFT JOIN rh_money_ziwd_crdt_temp_end j ON c.entName = j.DEBTORNAME
    LEFT JOIN rh_money_change_debt01_temp k ON c.entName = k.DEBTORNAME
    LEFT JOIN rh_money_change_crdt02_temp l ON c.entName = l.CRDTORNAME
    LEFT JOIN rh_money_scale_temp m ON c.entName = m.DEBTORNAME
    LEFT JOIN rh_cash_flow_temp n ON c.entName = n.CRDTORNAME
    LEFT JOIN rh_penalty_count o ON c.entName = o.ent_name
);




