SELECT
    cust_id,
    cust_first_name,
    cust_last_name,
    sales_channel,
    sales_year,
    total_sales,
    sales_rank
FROM (
    SELECT
        c.cust_id,
        c.cust_first_name,
        c.cust_last_name,
        ch.channel_desc AS sales_channel,
        t.calendar_year AS sales_year,
        ROUND(SUM(s.amount_sold), 2) AS total_sales,
        RANK() OVER (
            PARTITION BY ch.channel_desc, t.calendar_year
            ORDER BY SUM(s.amount_sold) DESC
        ) as sales_rank
    FROM
        sh.sales s
    JOIN
        sh.channels ch ON s.channel_id = ch.channel_id
    JOIN
        sh.customers c ON s.cust_id = c.cust_id
    JOIN
        sh.times t ON s.time_id = t.time_id
    WHERE t.calendar_year IN (1998, 1999, 2001)
    GROUP BY
        c.cust_id,
        c.cust_first_name,
        c.cust_last_name,
        ch.channel_desc,
        t.calendar_year
) subquery
WHERE
    sales_rank <= 300
ORDER BY
    sales_year,
    sales_channel,
    sales_rank;
