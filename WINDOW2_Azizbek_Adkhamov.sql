WITH sales_subcategories AS (
    SELECT
        p.prod_subcategory as subcategory,
        t.calendar_year as year,
        SUM(s.amount_sold) as total_sales
    FROM
        sh.sales s
    JOIN
        sh.times t ON s.time_id = t.time_id
    JOIN
        sh.products p on s.prod_id = p.prod_id
    WHERE
        t.calendar_year between 1997 and 2001
    GROUP BY
        p.prod_subcategory,
        t.calendar_year
),

sales_difference AS (
    SELECT
        subcategory,
        year,
        total_sales - LAG(total_sales) OVER (PARTITION BY subcategory ORDER BY year) as sales_difference
    FROM
        sales_subcategories
)

SELECT
    subcategory
FROM
    sales_difference
WHERE
    year between 1998 and 2001
GROUP BY
    subcategory
HAVING
    MIN(sales_difference) > 0;
