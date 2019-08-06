DROP TABLE IF EXISTS rh_score_end;
CREATE TABLE rh_score_end AS (
  SELECT
    DEBTORNAME,
    scaleAmtScore * 1.5 +
    industrycodeScore +
    areaNameScore +
    emScore +
    p01Score +
    p02Score +
    h01Score +
    p03Score +
    h02SCore +
    p04Score +
    n01Score * 1.5 +
    n02Score * 1.5 +
    amtRatioScore +
    rateScore * 1.5
      AS score1,
    DEBTORNAME,
    scaleAmtScore * 1.5 +
    industrycodeScore +
    areaNameScore +
    emScore +
    p01Score +
    p02Score +
    h01Score +
    p03Score +
    h02SCore +
    p04Score +
    n01Score * 1.5 +
    n02Score * 1.5 +
    amtRatioScore * 1.5 +
    rateScore * 1.5
      AS score2,
    DEBTORNAME,
    scaleAmtScore * 1.5 +
    industrycodeScore +
    areaNameScore +
    emScore * 1.2 +
    p01Score +
    p02Score +
    h01Score +
    p03Score * 1.2 +
    h02SCore * 1.2 +
    p04Score +
    n01Score * 1.5 +
    n02Score * 1.5 +
    amtRatioScore * 1.2 +
    rateScore * 1.5
      AS score3
  FROM rh_score_1
);
