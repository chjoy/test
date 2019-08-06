-- SELECT * FROM rh_score_var_temp01;
DROP TABLE IF EXISTS rh_score_1;
CREATE TABLE rh_score_1 AS (
  SELECT
    DEBTORNAME,
    scaleAmtScore,
    industrycodeScore,
    areaNameScore,
    emScore,
    p01Score,
    p02Score,
    h01Score,
    p03Score,
    h02SCore,
    p04Score,
    n01Score,
    n02Score,
    amtRatioScore,
    rateScore,
    penaltyScore
  FROM
    (
      SELECT
        DEBTORNAME,
        CASE
        WHEN scaleAmt >= 10000
          THEN 5
        WHEN scaleAmt >= 1000
          THEN 4
        WHEN scaleAmt >= 100
          THEN 3
        WHEN scaleAmt >= 10
          THEN 2
        WHEN scaleAmt > 0
          THEN 1
        ELSE 0
        END        AS scaleAmtScore,
        CASE
        WHEN industrycode = '3030'
          THEN 1
        WHEN industrycode IN ('2020', '2010')
          THEN 2
        WHEN industrycode IN ('1010', '3010', '3060')
          THEN 3
        WHEN industrycode IN ('2040', '3040', '2030')
          THEN 4
        ELSE 5
        END        AS industrycodeScore,
        CASE
        WHEN areaName IN ('长沙')
          THEN 5
        WHEN areaName IN ('岳阳', '常德', '衡阳', '株洲')
          THEN 4
        WHEN areaName IN ('彬州', '永州', '益阳')
          THEN 3
        WHEN areaName IN ('怀化', '湘西州', '张家界')
          THEN 2
        ELSE 1
        END        AS areaNameScore,

        CASE
        WHEN em >= 9
          THEN 5
        WHEN em >= 6
          THEN 3
        WHEN em >= 3
          THEN 4
        WHEN em >= 1
          THEN 1
        WHEN em >= 0
          THEN 2
        ELSE 0
        END        AS emScore,
        CASE
        WHEN abs(p01) > 0.7
          THEN 5
        WHEN abs(p01) > 0.45
          THEN 4
        WHEN abs(p01) > 0.25
          THEN 3
        WHEN abs(p01) > 0.1
          THEN 2
        WHEN abs(p01) <= 0.1
          THEN 1
        ELSE 0
        END        AS p01Score,
        CASE
        WHEN abs(p02) > 0.7
          THEN 5
        WHEN abs(p02) > 0.45
          THEN 4
        WHEN abs(p02) > 0.25
          THEN 3
        WHEN abs(p02) > 0.1
          THEN 2
        WHEN abs(p02) <= 0.1
          THEN 1
        ELSE 0
        END        AS p02Score,
        CASE WHEN h01 > 0.6
          THEN 5
        WHEN h01 > 0.2
          THEN 4
        WHEN h01 > -0.2
          THEN 3
        WHEN h01 > -0.6
          THEN 2
        WHEN h01 >= -1
          THEN 1
        ELSE 0
        END        AS h01Score,

        CASE
        WHEN abs(p03) > 0.7
          THEN 5
        WHEN abs(p03) > 0.45
          THEN 4
        WHEN abs(p03) > 0.25
          THEN 3
        WHEN abs(p03) > 0.1
          THEN 2
        WHEN abs(p03) <= 0.1
          THEN 1
        ELSE 0
        END        AS p03Score,

        CASE WHEN h02 > 0.6
          THEN 5
        WHEN h02 > 0.2
          THEN 4
        WHEN h02 > -0.2
          THEN 3
        WHEN h02 > -0.6
          THEN 2
        WHEN h02 >= -1
          THEN 1
        ELSE 0
        END        AS h02Score,


        CASE
        WHEN abs(p04) > 0.7
          THEN 5
        WHEN abs(p04) > 0.45
          THEN 4
        WHEN abs(p04) > 0.25
          THEN 3
        WHEN abs(p04) > 0.1
          THEN 2
        WHEN abs(p04) <= 0.1
          THEN 1
        ELSE 0
        END        AS p04Score,

        CASE WHEN n01 = 0
          THEN 5
        WHEN n01 = 1
          THEN 4
        WHEN n01 = 2
          THEN 3
        WHEN n01 = 3
          THEN 2
        WHEN n01 >= 4
          THEN 1
        ELSE 0
        END        AS n01Score,

        CASE WHEN n02 = 0
          THEN 5
        WHEN n02 = 1
          THEN 4
        WHEN n02 = 2
          THEN 3
        WHEN n02 = 3
          THEN 2
        WHEN n02 >= 4
          THEN 1
        ELSE 0
        END        AS n02Score,

        CASE
        WHEN amtRatio >= 1.5
          THEN 5
        WHEN amtRatio >= 1.2
          THEN 4
        WHEN amtRatio >= 1
          THEN 3
        WHEN amtRatio >= 0.77
          THEN 2
        WHEN amtRatio < 0.77
          THEN 1
        ELSE 0
        END        AS amtRatioScore,

        CASE
        WHEN rate >= 0.5
          THEN 3
        WHEN rate >= 0.2
          THEN 4
        WHEN rate >= 0
          THEN 5
        WHEN rate >= -0.33
          THEN 2
        WHEN rate < -0.33
          THEN 1
        ELSE 0
        END        AS rateScore,
        CASE
        WHEN penalty_count > 0
          THEN -1
        ELSE 0 END AS penaltyScore
      FROM rh_score_var_temp01
    ) a
);
