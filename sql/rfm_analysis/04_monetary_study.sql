/*
 Let’s take a look at how the score boundaries for monetary were determined when dividing customers into three equal groups. A full explanation of how CTEs below are constructed can be found at the beginning of the sql/rfm_analysis/01_rfm_base.sql
 */

with internal_use_and_null as (select
                                   unnest(array ['200000000022', '200000000492', '200000000024',
                                       '200010000015', '200000000042', '200000000044', 'NULL']) as bad_bc),
     all_receipts as (select
                          dr_dat as purchase_date,
                          coalesce(min(dr_bcdisc)
                                   filter (where dr_bcdisc not in (select bad_bc from internal_use_and_null)),
                                   min(dr_bcdisc)) as barcode,
                          dr_nchk as receipt_id,
                          round(sum(dr_kol * dr_croz - dr_sdisc)::numeric, 2) as receipt_total,
                          count(*) as number_of_items
                      from sales
                      group by dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl),
     regular_receipts as (select *
                          from all_receipts
                          where barcode not in (select bad_bc from internal_use_and_null)),
     rfm_base as (select
                      barcode,
                      '2022-06-09'::date - max(purchase_date) as recency,
                      count(receipt_id) as frequency,
                      sum(receipt_total) as monetary
                  from regular_receipts
                  group by barcode),
     monetary_scores as (select
                             barcode,
                             monetary,
                             ntile(3) over (order by monetary desc) as m_score
                         from rfm_base)
select
    m_score,
    count(barcode) as group_size,
    min(monetary) as min_monetary,
    max(monetary) as max_monetary
from monetary_scores
group by m_score
order by m_score;

/*
 Result:
+-------+----------+------------+------------+
|m_score|group_size|min_monetary|max_monetary|
+-------+----------+------------+------------+
|1      |762       |1123        |32058       |
|2      |762       |389         |1122        |
|3      |761       |24          |388         |
+-------+----------+------------+------------+

 The median monetary value is 659 RUB, average -- 745.5 RUB. We can see that the highest spending values differ from the median by two orders of magnitude.

 We will rely on publicly available research from the analytical company RNC Pharma. According to their analytics, in the first seven months of 2025, Russians spent more than 900 RUB per month on purchasing medicinal products ([RNC Pharma blogpost about average per capita spending on the purchase of medicines](https://rncph.ru/blog/150925/)). Note that RNC Pharma analysts distinguish between purchases of medicines and non-medicinal products offered by pharmacies (parapharmaceuticals).

 The average receipt for medicines in the available 2025 data is 618.5 RUB, while in 2022 the average receipt for medicines was 462.7 RUB ([blogpost about average one-time purchase in pharmacies in 2022 - 2025](https://rncph.ru/blog/201025/)). From the cited report, we also see that parapharmaceutical sales are stagnating.

![](images/rnc_pharma_one_time_purchase_average.png)

 We will make a very rough assumption that, apart from inflation, the structure of receipts, pharmacy visitation patterns, and other factors did not change significantly, and we will interpolate the 2025 proportions to 2022. Overall, the trend appears stable — see the [blogpost about dynamics (monthly) of the average one-time purchase 2023-2025](https://rncph.ru/blog/170425/).

 Thus, we will assume that in 2022 the monthly spending is approximately 673.3 RUB.

  From the referenced reports, we also see that the average receipt including parapharmaceuticals in 2022 was 1.3 times higher, at 601.8 RUB, but we also see that parapharmaceutical sales are stagnating over the years covered. So by inflating monthly spending on medicinal products by the same factor (1.3 x 673.3 RUB = 875.7 RUB), we are likely overestimating total monthly spending in pharmacies in 2022.

  In our transactions, we record total customer spending, including parapharmaceuticals, and our observation period is longer than one month. Based on the available data, the average spending over six weeks is 745.5 RUB. We have made very rough assumptions, so the estimates above should not be interpreted literally, however, they allow us to assess the order of magnitude. In my view, using our observed average as a reference point is fully justified.

 Let’s define Group 0 as customers who spent more than or equal to 5 000 RUB, and divide the remaining customers into three approximately equal groups.
 */

with internal_use_and_null as (select
                                   unnest(array ['200000000022', '200000000492', '200000000024',
                                       '200010000015', '200000000042', '200000000044', 'NULL']) as bad_bc),
     all_receipts as (select
                          dr_dat as purchase_date,
                          coalesce(min(dr_bcdisc)
                                   filter (where dr_bcdisc not in (select bad_bc from internal_use_and_null)),
                                   min(dr_bcdisc)) as barcode,
                          dr_nchk as receipt_id,
                          round(sum(dr_kol * dr_croz - dr_sdisc)::numeric, 2) as receipt_total,
                          count(*) as number_of_items
                      from sales
                      group by dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl),
     regular_receipts as (select *
                          from all_receipts
                          where barcode not in (select bad_bc from internal_use_and_null)),
     rfm_base as (select
                      barcode,
                      '2022-06-09'::date - max(purchase_date) as recency,
                      count(receipt_id) as frequency,
                      sum(receipt_total) as monetary
                  from regular_receipts
                  group by barcode),
     monetary_scores as (select
                             barcode,
                             monetary,
                             case
                                 when monetary >= 5000 then 0
                                 when monetary >= 1043 then 1
                                 when monetary >= 471 then 2
                                 else 3
                                 end as m_score
                         from rfm_base)
select
    m_score,
    count(barcode) as group_size,
    min(monetary) as min_monetary,
    max(monetary) as max_monetary
from monetary_scores
group by m_score
order by m_score;

/*
 Result:
+-------+----------+------------+------------+
|m_score|group_size|min_monetary|max_monetary|
+-------+----------+------------+------------+
|0      |85        |5014        |32058       |
|1      |734       |1043        |4995        |
|2      |733       |371         |1043        |
|3      |733       |24          |371         |
+-------+----------+------------+------------+

 We set the lower bounds at 5014, 1043, and 3718 for Groups 0, 1 and 2, respectively.
 */