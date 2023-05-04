-- Spojování tabulek pomocí JOIN

-- Úkol 1:

SELECT
	*
FROM czechia_price cp
INNER JOIN czechia_price_category cpc
	ON cp.`category_code` = cpc.`code`;
	
-- Úkol 2:

SELECT
	cp.`id`,
	cpc.`name`,
	cp.`value`
FROM czechia_price cp
INNER JOIN czechia_price_category cpc
	ON cp.`category_code` = cpc.`code`;
	
-- Úkol 3:

SELECT
	cp.*,
	cr.`name`
FROM czechia_price cp
LEFT JOIN czechia_region cr
	ON cp.`region_code` = cr.`code`;
	
-- Úkol 4:

SELECT
	cp.*,
	cr.`name`
FROM czechia_region cr
RIGHT JOIN czechia_price cp
	ON cr.`code` = cp.`region_code`;

-- Úkol 5:

SELECT
	cp.`id`,
	cp.`value`,
	cp.`value_type_code`,
	cpvt.`name`,
	cp.`unit_code`,
	cpu.`name`,
	cp.`calculation_code`,
	cpc.`name`,
	cp.`industry_branch_code`,
	cpib.`name`,
	cp.`payroll_year`,
	cp.`payroll_quarter`
FROM czechia_payroll cp
JOIN czechia_payroll_calculation cpc
	ON cp.`calculation_code` = cpc.`code`
JOIN czechia_payroll_industry_branch cpib
	ON cp.`industry_branch_code` = cpib.`code`
JOIN czechia_payroll_unit cpu
	ON cp.`unit_code` = cpu.`code`
JOIN czechia_payroll_value_type cpvt
	ON cp.`value_type_code` = cpvt.`code`;

-- Úkol 6:

SELECT
	cpib.*
FROM czechia_payroll_industry_branch cpib
JOIN czechia_payroll cp
    ON cpib.`code` = cp.`industry_branch_code`
WHERE `value_type_code` = 5958
ORDER BY `value` DESC
LIMIT 1;

-- Úkol 7:

SELECT
    cpc.`name` AS `food_category`,
    cp.`value` AS `price`,
    cpib.`name` AS `industry`,
    cpay.`value` AS `average_wages`,
    DATE_FORMAT(cp.`date_from`, '%e. %M %Y') AS `price_measured_from`,
    DATE_FORMAT(cp.`date_to`, '%e.%M.%Y') AS `price_measured_to`,
    cpay.`payroll_year`
FROM czechia_price cp
JOIN czechia_payroll cpay
    ON
    	YEAR(cp.`date_from`) = cpay.`payroll_year`
    	AND cpay.`value_type_code` = 5958
    	AND cp.`region_code` IS NULL
JOIN czechia_price_category cpc
    ON cp.`category_code` = cpc.`code`
JOIN czechia_payroll_industry_branch cpib
    ON cpay.`industry_branch_code` = cpib.`code`;

-- Úkol 8:

SELECT
	hp.`name` AS `provider`,
	cr.`name` AS `region`,
	cr2.`name` AS `residence_region`,
	cd.`name` AS `district`,
	cd2.`name` AS `residence_district`
FROM healthcare_provider hp
LEFT JOIN czechia_region cr
	ON hp.`region_code` = cr.`code`
LEFT JOIN czechia_region cr2
	ON hp.`residence_region_code` = cr2.`code`
LEFT JOIN czechia_district cd
	ON hp.`district_code` = cd.`code`
LEFT JOIN czechia_district cd2
	ON hp.`residence_district_code` = cd2.`code`;

-- Úkol 9:

SELECT
	hp.`name` AS `provider`,
	cr.`name` AS `region`,
	cr2.`name` AS `residence_region`,
	cd.`name` AS `district`,
	cd2.`name` AS `residence_district`
FROM healthcare_provider hp
LEFT JOIN czechia_region cr
	ON hp.`region_code` = cr.`code`
LEFT JOIN czechia_region cr2
	ON hp.`residence_region_code` = cr2.`code`
LEFT JOIN czechia_district cd
	ON hp.`district_code` = cd.`code`
LEFT JOIN czechia_district cd2
	ON hp.`residence_district_code` = cd2.`code`
WHERE
	`region_code` != `residence_region_code`
	AND `district_code` != `residence_district_code`;

-- Kartézský součin a CROSS JOIN

-- Úkol 1:

SELECT
	*
FROM
	czechia_price cp,
	czechia_price_category cpc
WHERE cp.`category_code` = cpc.`code`;

-- Úkol 2:

SELECT
	*
FROM czechia_price cp
CROSS JOIN czechia_price_category cpc
	ON cp.`category_code` = cpc.`code`;


-- Úkol 3:

SELECT
	cr.`name` `first_region`,
	cr2.`name` `second_region`
FROM czechia_region cr
CROSS JOIN czechia_region cr2
WHERE cr.`code` != cr2.`code`;

-- Množinové operace

-- Úkol 1:

SELECT
	`category_code`,
	`value`
FROM czechia_price cp
WHERE `region_code` = 'CZ064'
UNION ALL
SELECT
	`category_code`,
	`value`
FROM czechia_price cp2
WHERE `region_code` = 'CZ010';

-- Úkol 2:

SELECT
	`category_code`,
	`value`
FROM czechia_price cp
WHERE `region_code` = 'CZ064'
UNION
SELECT
	`category_code`,
	`value`
FROM czechia_price cp2
WHERE `region_code` = 'CZ010';

-- Úkol 3:

SELECT
	*
FROM (
	SELECT
		`code`,
		`name`,
		'region' AS `country_part`
	FROM czechia_region cr
	UNION
	SELECT
		`code`,
		`name`,
		'district' AS `country_part`
	FROM czechia_district cd
) AS `coutry_parts`
ORDER BY `code`;

-- Úkol 4:

SELECT
	`category_code`,
	`value`
FROM czechia_price cp
WHERE `region_code` = 'CZ010'
INTERSECT
SELECT
	`category_code`,
	`value`
FROM czechia_price cp2
WHERE `region_code` = 'CZ064';

-- Úkol 5:

SELECT
	cpib.*,
	cp.`id`,
	cp.`value`
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib
	ON cp.`industry_branch_code` = cpib.`code`
WHERE value IN (
	SELECT
		`value`
	FROM czechia_payroll cp2
	WHERE `industry_branch_code` = 'A'
	INTERSECT
	SELECT
		`value`
	FROM czechia_payroll cp3
	WHERE `industry_branch_code` = 'B'
);

-- Úkol 6:

SELECT
	`category_code`,
	`value`
FROM czechia_price cp
WHERE `region_code` = 'CZ064'
EXCEPT
SELECT
	`category_code`,
	`value`
FROM czechia_price cp2
WHERE `region_code` = 'CZ010';

-- Úkol 7:

SELECT
	`category_code`,
	`value`
FROM czechia_price cp
WHERE `region_code` = 'CZ010'
INTERSECT
SELECT
	`category_code`,
	`value`
FROM czechia_price cp2
WHERE `region_code` = 'CZ064';

(SELECT
	`category_code`,
	`value`
FROM czechia_price cp
WHERE `region_code` = 'CZ064'
EXCEPT
SELECT
	`category_code`,
	`value`
FROM czechia_price cp2
WHERE `region_code` = 'CZ010')
INTERSECT
(SELECT
	`category_code`,
	`value`
FROM czechia_price cp3
WHERE `region_code` = 'CZ010'
EXCEPT
SELECT
	`category_code`,
	`value`
FROM czechia_price cp4
WHERE `region_code` = 'CZ064'); 

-- Common Table Expression

-- Úkol 1:

WITH high_price AS (
	SELECT
		`category_code` AS `code`
	FROM czechia_price cp
	WHERE `value` > 150
)
SELECT
	DISTINCT cpc.`name`
FROM high_price hp
JOIN czechia_price_category cpc
	ON hp.`code` = cpc.`code`;

-- Úkol 2:

WITH not_completed_provider_info_district AS (
	SELECT
		DISTINCT `district_code`
	FROM healthcare_provider hp
	WHERE
		`phone` IS NULL
		AND `fax` IS NULL
		AND `email` IS NULL
		AND `provider_type` = 'Samost. ordinace všeob. prakt. lékaře'
)
SELECT
	*
FROM czechia_district
WHERE `code` NOT IN (
	SELECT
		*
	FROM not_completed_provider_info_district
);

-- Úkol 3:

WITH large_gdp_area AS (
	SELECT
		*
	FROM economies e
	WHERE `GDP` > 70000000000
)
SELECT
	round(avg(`taxes`), 2) AS `taxes_average`
FROM large_gdp_area e
;

-- BONUSOVÁ CVIČENÍ

-- Countries: JOIN

-- Úkol 1:

SELECT
	c.`country`,
	c.`capital_city`,
	c.`population`,
	r.`religion`,
	r.`population`
FROM countries c
JOIN religions r
	ON
		c.`country` = r.`country`
		AND r.`year` = 2020;

-- Úkol 2:

SELECT
	c.`country`,
	c.`capital_city`,
	c.`independence_date`,
	e.`year`,
	round(e.`GDP` / 1000000) `GDP_mil_dollars`,
	e.`population`,
	e.`gini`,
	e.`taxes`
FROM countries c
JOIN economies e
	ON c.`country` = e.`country`
WHERE c.`independence_date` <= e.`year`;

-- Úkol 3:

SELECT
	c.`country`,
	c.`population`
FROM countries c
LEFT JOIN economies e
	ON
		c.`country` = e.`country`
		AND e.`year` = 2018
WHERE e.`country` IS NULL
ORDER BY c.`population` DESC;

-- Úkol 4:

SELECT
	a.`country`,
	a.`life_exp_1970`,
	b.`life_exp_2015`,
	round(b.`life_exp_2015` / a.`life_exp_1970`, 2) `life_exp_ratio`
FROM (
	SELECT
		le.`country`,
		le.`life_expectancy` `life_exp_1970`
	FROM life_expectancy le
	WHERE `year` = 1970
) a
JOIN (
	SELECT
		le2.`country`,
		le2.`life_expectancy` `life_exp_2015`
	FROM life_expectancy le2
	WHERE `year` = 2015
) b
	ON a.`country` = b.`country`;

-- Úkol 5:

SELECT
	e.`country`,
	e.`year`,
	e2.`year` `year_prev`,
	round((e.`GDP` - e2.`GDP`) / e2.`GDP` * 100, 2) `GDP_growth_percent`,
	round((e.`population` - e2.`population`) / e2.`population`  * 100, 2) `pop_growth_percent`
FROM economies e
JOIN economies e2
	ON
		e.`country` = e2.`country`
		AND e.`year` = e2.`year` + 1;

-- Úkol 6:

SELECT
	r.`country`,
	r.`religion`,
	r.`population`,
	r2.`total_population_2020`,
	round(r.`population` / r2.`total_population_2020` * 100, 2) `religion_share_2020`
FROM religions r
JOIN (
	SELECT
		`country`,
		`year`,
		sum(`population`) `total_population_2020`
	FROM religions r
	WHERE `year` = 2020
	GROUP BY `country`
) r2
	ON
		r.`country` = r2.`country`
		AND r.`year` = r2.`year`
		AND r.`population` > 0;

-- COVID-19: JOIN

-- Úkol 1a:

CREATE OR REPLACE VIEW v_lookup_table_null AS
	SELECT
		*
	FROM lookup_table lt
	WHERE `province` IS NULL;

-- Úkol 1b:

SELECT
	*
FROM covid19_basic cb
LEFT JOIN v_lookup_table_null vltn
	ON cb.`country` = vltn.`country`;

-- Úkol 2:

SELECT
	cb.`date`,
	cb.`country`,
	cb.`confirmed` `cumulative_confirmed`,
	cb.`deaths` `cumulative_deaths`,
	cb.`recovered` `cumulative_recovered`,
	cbd.`confirmed` `new_confirmed`,
	cbd.`deaths` `new_deaths`,
	cbd.`recovered` `new_recovered`
FROM covid19_basic cb
LEFT JOIN covid19_basic_differences cbd
	ON
		cb.`country` = cbd.`country`
		AND cb.`date` = cbd.`date`;

-- Úkol 3:

SELECT
	cdu.*,
	cdud.`confirmed` `confirmed_diff`
FROM covid19_detail_us cdu
LEFT JOIN covid19_detail_us_differences cdud
	ON
		cdu.`date` = cdud.`date`
		AND cdu.`country` = cdud.`country`
		AND cdu.`province` = cdud.`province`
		AND cdu.`admin2` = cdud.`admin2`;

-- Úkol 4:

SELECT
	*
FROM covid19_detail_us cdu
LEFT JOIN covid19_detail_us_differences cdud
	ON
		cdu.`date` = cdud.`date`
		AND cdu.`country` = cdud.`country`
		AND cdu.`province` = cdud.`province`
		AND cdu.`admin2` = cdud.`admin2`
LEFT JOIN lookup_table lt
	ON
		cdu.`country` = lt.`country`
		AND cdu.`province` = lt.`province`
		AND cdu.`admin2` = lt.`admin2`;

-- Úkol 5:

SELECT
	*
FROM covid19_detail_global cdg
LEFT JOIN covid19_detail_global_differences cdgd
	ON
		cdg.`date` = cdgd.`date`
		AND cdg.`country` = cdgd.`country`
		AND cdg.`province` = cdgd.`province`;

-- Úkol 6:

SELECT
	*
FROM covid19_detail_global cdg
LEFT JOIN covid19_detail_global_differences cdgd
	ON
		cdg.`date` = cdgd.`date`
		AND cdg.`country` = cdgd.`country`
		AND cdg.`province` = cdgd.`province`
LEFT JOIN lookup_table lt
	ON
		cdg.`country` = lt.`country`
		AND cdg.`province` = cdgd.`province`;

-- Úkol 7:

SELECT
	cb.`date`,
	cb.`country`,
	round(cb.`confirmed` * 1000000 / lt.`population`) `confirmed_per_mil`
FROM covid19_basic cb
LEFT JOIN lookup_table lt
	ON cb.`country` = lt.`country`
WHERE
	cb.`country` IN ('Czechia', 'Germany')
	AND lt.`province` IS NULL
ORDER BY cb.`date` DESC, lt.`country`;

-- Úkol 8:

SELECT
	cb.`country`,
	round(cb.`confirmed` * 1000000 / lt.`population`) `confirmed_per_mil`
FROM covid19_basic cb
LEFT JOIN lookup_table lt
	ON cb.`country` = lt.`country`
WHERE
	`date` = '2020-08-30'
	AND lt.`province` IS NULL
ORDER BY `confirmed_per_mil`;

-- Úkol 9:

SELECT
	cb.`date`,
	round(sum(cb.`confirmed`) * 1000000 / sum(lt.`population`), 2) `confirmed_per_milion`
FROM covid19_basic cb
LEFT JOIN lookup_table lt
	ON cb.`country` = lt.`country`
WHERE lt.`province` IS NULL
GROUP BY cb.`date`;

-- Úkol 10:

SELECT
	cb.*,
	lt.`population`
FROM lookup_table lt
INNER JOIN covid19_basic cb
	ON lt.`country` = cb.`country`
WHERE
	lt.`population` < 1000000
	AND lt.`province` IS NULL;

-- Úkol 11:

SELECT
    dates.`date`,
    countries.`country`
FROM (
    SELECT
    	DISTINCT `date`
    FROM covid19_basic cb
) dates
CROSS JOIN (
    SELECT DISTINCT
        `country`
    FROM covid19_basic cb2
) countries;

-- Úkol 12:

SELECT
    dates.`date`,
    countries.`country`,
    CASE
		WHEN diff.`confirmed` IS NULL THEN 0
        ELSE diff.`confirmed`
    END AS confirmed
FROM (
	SELECT
        DISTINCT `date`
    FROM covid19_basic cb
) dates
CROSS JOIN (
	SELECT
		DISTINCT `country`
    FROM covid19_basic cb2
) countries
LEFT JOIN covid19_basic_differences diff
	ON
		dates.`date` = diff.`date`
		AND countries.`country` = diff.`country`;

-- COVID-19: pokračování JOIN

-- Úkol 1:

SELECT
	cdgd.`country`,
	cdgd.`province`,
	cdgd.`date`,
	CASE
		WHEN weekday(cdgd.`date`) IN (5, 6) THEN 1
		ELSE 0
	END AS `weekend`,
	cdgd.`confirmed`,
	lt.`population`,
	round(cdgd.`confirmed` * 1000000 / lt.`population`, 2) `cases_per_million`
FROM covid19_detail_global_differences cdgd
JOIN lookup_table lt
	ON
		cdgd.`country` = lt.`country`
		AND cdgd.`province` = lt.`province`
		AND cdgd.`country` = 'United Kingdom'
ORDER BY
	cdgd.`province`, 
	cdgd.`date` DESC;

-- Úkol 2:

SELECT
	cz.`date`,
	CASE
		WHEN weekday(cz.`date`) IN (5, 6) THEN 1
		ELSE 0
	END `weekend`,
	round(cz.`confirmed_czech` * 100000 / cz.`population`) `confirmed_czech`,
	round(sc.`confirmed_scotland` * 100000 / sc.`population`) `confirmed_scotland`
FROM (
	SELECT
		cbd.`country`,
		cbd.`date`,
		cbd.`confirmed` `confirmed_czech`,
		lt.`population`
	FROM covid19_basic_differences cbd
	JOIN lookup_table lt
		ON cbd.`country` = lt.`country`
		AND cbd.`country` = 'Czechia'
		AND cbd.`date` >= date_add(current_date(), INTERVAL -14 DAY)
) cz
JOIN (
	SELECT
		cdgd.`country`,
		cdgd.`date`,
		cdgd.`confirmed` `confirmed_scotland`,
		lt2.`population`
	FROM covid19_detail_global_differences cdgd
	JOIN lookup_table lt2
		ON cdgd.`province` = lt2.`province`
		AND cdgd.`province` = 'Scotland'
) sc
	ON cz.`date` = sc.`date`
ORDER BY cz.`date` DESC;

-- Úkol 3:

SELECT
	cb.`date`,
	cb.`country`,
	cb.`confirmed`,
	w.`max_temp`
FROM covid19_basic cb
JOIN (
	SELECT
		substr(`date`, 1, 10) `date_only`,
		max(`temp`) `max_temp`,
		CASE
			WHEN `city` = 'Prague' THEN 'Czechia'
		END `country`
	FROM weather w
	GROUP BY
		`city`,
		`date_only`
) w
	ON cb.`country` = w.`country`
	AND cb.`date` = w.`date_only`
	AND cb.`country` = 'Czechia'
	AND month(cb.`date`) = 10;