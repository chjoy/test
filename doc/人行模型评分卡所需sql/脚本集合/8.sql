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
      AS score
  FROM rh_score_1
);

DROP TABLE IF EXISTS rh_score_3;
CREATE TABLE rh_score_3 AS (
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
    amtRatioScore * 1.5 +
    rateScore * 1.5
      AS score
  FROM rh_score_1
);

DROP TABLE IF EXISTS rh_score_4;
CREATE TABLE rh_score_4 AS (
  SELECT
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
      AS score
  FROM rh_score_1
);
