/*
 Here is a full explanation of how the basis for the analysis is constructed.

 The CTE all_receipts contains information on all receipts present in the original database. To ensure the completeness of each receipt (as mentioned earlier, a single receipt can contain multiple barcodes), we use a partial PK (excluding the item number field dr_pos). As a result, for each receipt we obtain a set of dr_bcdisc values, and we want to select from this set the barcode we consider “regular.”

 We take advantage of the fact that the value 'NULL' in dr_bcdisc is always recorded as a string, so it is lexicographically greater than any numeric string. Initially, we attempt to exclude from this set all internal-use barcodes and 'NULL' (there are no receipts in the database containing more than two distinct numeric barcodes). If a receipt contains only internal-use barcodes and/or 'NULL', the receipt is assigned the minimal value among them.

 In the regular_receipts CTE, we filter out receipts that were assigned an internal-use or 'NULL' barcode.

 The rfm_base CTE prepares customer-level information — we identify each customer by their barcode, group receipts assigned to the same barcode, and compute the RFM characteristics: recency (the number of days from the last purchase to June 9, 2022), frequency (the number of receipts), and monetary (the total amount across all receipts).

 The boundaries for group assignment in the rfm_scores CTE were discussed separately.
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
    barcode,
    recency,
    r_score,
    frequency,
    f_score,
    monetary,
    m_score
from rfm_scores
order by recency, frequency desc, monetary desc;
