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
                          sum(dr_sdisc) as discount_amount,
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
                      sum(receipt_total) as monetary,
                      sum(number_of_items) as items_purchased,
                      sum(discount_amount) as discount_amount
                  from regular_receipts
                  group by barcode),
     rfm_scores as (select
                        barcode,
                        recency,
                        frequency,
                        monetary,
                        items_purchased,
                        discount_amount,
                        case
                            when recency <= 8 then 1
                            when recency <= 20 then 2
                            else 3
                            end as r_score,
                        case
                            when frequency >= 7 then 0
                            when frequency >= 4 then 1
                            when frequency >= 2 then 2
                            else 3
                            end as f_score,
                        case
                            when monetary >= 5000 then 0
                            when monetary >= 1043 then 1
                            when monetary >= 471 then 2
                            else 3
                            end as m_score
                    from rfm_base)
select
    r_score::text || f_score::text || m_score::text as RFM,
    round(sum(monetary)::numeric / sum(frequency), 2) as average_receipt_total,
    round(sum(items_purchased)::numeric / sum(frequency), 2) as average_number_of_items,
    round(avg(discount_amount*100 / (monetary + discount_amount))::numeric, 2) as average_discount,
    count(*) as group_size
from rfm_scores
group by r_score, f_score, m_score
order by average_receipt_total desc, average_number_of_items desc, group_size desc;


-- For Generous Newcomers totals
/*
select
    'Generous Newcomers' as group_name,
    round(sum(monetary)::numeric / sum(frequency), 2) as average_receipt_total,
    round(sum(items_purchased)::numeric / sum(frequency), 2) as average_number_of_items,
    round(avg(discount_amount*100 / (monetary + discount_amount))::numeric, 2) as average_discount,
    count(*) as group_size
from rfm_scores
where r_score*100 + f_score*10  + m_score in (130, 230, 330, 220, 320, 120, 131, 231, 331);
*/


-- For the x21 cohort use query below
/*
select
    'x' || f_score::text || m_score::text as RFM,
    round(sum(monetary)::numeric / sum(frequency), 2) as average_receipt_total,
    round(sum(items_purchased)::numeric / sum(frequency), 2) as average_number_of_items,
    round(avg(discount_amount*100 / (monetary + discount_amount))::numeric, 2) as average_discount,
    count(*) as group_size
from rfm_scores
where f_score = 2 and m_score = 1
group by f_score, m_score
order by average_receipt_total desc, average_number_of_items desc, group_size desc;
*/

-- For Outstanding Customers totals
/*
select
    'Outstanding Customers' as group_name,
    round(sum(monetary)::numeric / sum(frequency), 2) as average_receipt_total,
    round(sum(items_purchased)::numeric / sum(frequency), 2) as average_number_of_items,
    round(avg(discount_amount*100 / (monetary + discount_amount))::numeric, 2) as average_discount,
    count(*) as group_size
from rfm_scores
where r_score*100 + f_score*10  + m_score in (110, 210, 321, 221, 121, 200);
*/


-- For Promising Newcomers totals
/*
select
    'Promising Newcomers' as group_name,
    round(sum(monetary)::numeric / sum(frequency), 2) as average_receipt_total,
    round(sum(items_purchased)::numeric / sum(frequency), 2) as average_number_of_items,
    round(avg(discount_amount*100 / (monetary + discount_amount))::numeric, 2) as average_discount,
    count(*) as group_size
from rfm_scores
where r_score*100 + f_score*10  + m_score in (332, 232, 132);
*/


-- For Pharmacy Friends totals
/*
select
    'Pharmacy Friends' as group_name,
    round(sum(monetary)::numeric / sum(frequency), 2) as average_receipt_total,
    round(sum(items_purchased)::numeric / sum(frequency), 2) as average_number_of_items,
    round(avg(discount_amount*100 / (monetary + discount_amount))::numeric, 2) as average_discount,
    count(*) as group_size
from rfm_scores
where r_score*100 + f_score*10  + m_score in (100, 101, 201, 111, 311, 211, 212, 112, 312, 213);
 */


-- For Neighborhood Customers totals
/*
select
    'Neighborhood Customers' as group_name,
    round(sum(monetary)::numeric / sum(frequency), 2) as average_receipt_total,
    round(sum(items_purchased)::numeric / sum(frequency), 2) as average_number_of_items,
    round(avg(discount_amount*100 / (monetary + discount_amount))::numeric, 2) as average_discount,
    count(*) as group_size
from rfm_scores
where r_score*100 + f_score*10  + m_score in (322, 222, 122, 223, 123, 323);
 */


-- For Customize Toolbar… totals
/*
select
    'Interested Visitors' as group_name,
    round(sum(monetary)::numeric / sum(frequency), 2) as average_receipt_total,
    round(sum(items_purchased)::numeric / sum(frequency), 2) as average_number_of_items,
    round(avg(discount_amount*100 / (monetary + discount_amount))::numeric, 2) as average_discount,
    count(*) as group_size
from rfm_scores
where r_score*100 + f_score*10  + m_score in (133, 333, 233);

 */