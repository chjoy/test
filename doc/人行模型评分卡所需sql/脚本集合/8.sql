DROP TABLE IF EXISTS rh_score_2;
CREATE TABLE rh_score_2 AS (
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
  as score
  FROM rh_score_1
)