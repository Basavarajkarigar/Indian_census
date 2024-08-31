-- number of rows in dataset
select count(*) from dataset11
select count(*) from dataset2


-- dataset for jharkhand and bihar
select * from dataset11 d1
join dataset2 d2 on d2.state= d1.state
where d1.state in ('jharkhand' and 'bihar')

-- population of India
select sum(population) from dataset2

-- avg growth 
select state, round(avg(growth),2) as avg_growth from dataset11 
group by state
order by avg_growth

-- avg sex ratio
select state,round(avg(sex_ratio),2) as avg_sex_ratio from dataset11
group by state
order by avg_sex_ratio desc

-- avg literacy rate
select state,round(avg(literacy),2) as avg_literacy from dataset11
group by state
order by avg_literacy desc

-- top 3 state showing highest growth ratio
select state, round(avg(growth),2) as growth_rate from dataset11
group by state
order by avg(growth) desc
limit 3

-- bottom 3 state showing lowest sex ratio
select state,round(avg(sex_ratio),2) as avg_sex_ratio from dataset11
group by state
order by avg_sex_ratio asc
limit 3

-- top and bottom 3 states in literacy state
WITH RankedStates AS (
    SELECT state, avg(literacy) as avg_literacy,
           RANK() OVER (ORDER BY avg(literacy) DESC) AS rank_desc,
           RANK() OVER (ORDER BY avg(literacy) ASC) AS rank_asc
    FROM dataset11
    group by state
)
select state, avg_literacy, 'top' as category from RankedStates
where rank_desc <= 3
UNION ALL
select state, avg_literacy, 'bottom' as category from RankedStates
where rank_asc <= 3

-- states starting with letter a
select distinct(state) from dataset11
where state like 'a%' 

-- total males and females
SELECT 
    d.state,
    SUM(d.males) total_males,
    SUM(d.females) total_females
FROM
    (SELECT 
        c.district,
            c.state state,
            ROUND(c.population / (c.sex_ratio + 1), 0) males,
            ROUND((c.population * c.sex_ratio) / (c.sex_ratio + 1), 0) females
    FROM
        (SELECT 
        a.district,
            a.state,
            a.sex_ratio / 1000 sex_ratio,
            b.population
    FROM
        dataset11 a
    INNER JOIN dataset2 b ON a.district = b.district) c) d
GROUP BY d.state;


-- total literacy rate
SELECT 
    c.state,
    SUM(literate_people) total_literate_pop,
    SUM(illiterate_people) total_lliterate_pop
FROM
    (SELECT 
        d.district,
            d.state,
            ROUND(d.literacy_ratio * d.population, 0) literate_people,
            ROUND((1 - d.literacy_ratio) * d.population, 0) illiterate_people
    FROM
        (SELECT 
        a.district,
            a.state,
            a.literacy / 100 literacy_ratio,
            b.population
    FROM
        dataset11 a
    INNER JOIN dataset2 b ON a.district = b.district) d) c
GROUP BY c.state

-- population in previous census
SELECT 
    SUM(m.previous_census_population) previous_census_population,
    SUM(m.current_census_population) current_census_population
FROM
    (SELECT 
        e.state,
            SUM(e.previous_census_population) previous_census_population,
            SUM(e.current_census_population) current_census_population
    FROM
        (SELECT 
        d.district,
            d.state,
            ROUND(d.population / (1 + d.growth), 0) previous_census_population,
            d.population current_census_population
    FROM
        (SELECT 
        a.district, a.state, a.growth growth, b.population
    FROM
        dataset11 a
    INNER JOIN dataset2 b ON a.district = b.district) d) e
    GROUP BY e.state) m












WITH RankedStates AS (
    SELECT state, literacy,
           RANK() OVER (ORDER BY literacy DESC) AS rank_desc,
           RANK() OVER (ORDER BY literacy ASC) AS rank_asc
    FROM dataset11
)
-- Top 3 states
SELECT state, literacy AS top_avg_literacy, 'Top' AS category
FROM RankedStates
WHERE rank_desc <= 3

UNION ALL

-- Bottom 3 states
SELECT state, literacy AS bottom_avg_literacy, 'Bottom' AS category
FROM RankedStates
WHERE rank_asc <= 3;



