/*
 Here is a full explanation of how the basis for the analysis is constructed.

 The CTE all_receipts contains information on all receipts present in the original database. To ensure the completeness of each receipt (as mentioned earlier, a single receipt can contain multiple barcodes), we use a partial PK (excluding the item number field dr_pos). As a result, for each receipt we obtain a set of dr_bcdisc values, and we want to select from this set the barcode we consider “regular.”

 We take advantage of the fact that the value 'NULL' in dr_bcdisc is always recorded as a string, so it is lexicographically greater than any numeric string. Initially, we attempt to exclude from this set all internal-use barcodes and 'NULL' (there are no receipts in the database containing more than two distinct numeric barcodes). If a receipt contains only internal-use barcodes and/or 'NULL', the receipt is assigned the minimal value among them.

 In the regular_receipts CTE, we filter out receipts that were assigned an internal-use or 'NULL' barcode.

 The rfm_base CTE prepares customer-level information — we identify each customer by their barcode, group receipts assigned to the same barcode, and compute the RFM characteristics: recency (the number of days from the last purchase to June 9, 2022), frequency (the number of receipts), and monetary (the total amount across all receipts).

 The boundaries for group assignment in the rfm_scores CTE were discussed separately.
 */

with all_receipts as (select
                          dr_dat as purchase_date,
                          coalesce(min(dr_bcdisc) filter (where dr_bcdisc not in
                                                                ('200000000022', '200000000492', '200000000024',
                                                                 '200010000015', '200000000042', '200000000044',
                                                                 'NULL')),
                                   min(dr_bcdisc)) as barcode,
                          dr_nchk as receipt_id,
                          round(sum(dr_kol * dr_croz - dr_sdisc)::numeric, 2) as receipt_total
                      from sales
                      group by dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl),
     regular_receipts as (select *
                          from all_receipts
                          where barcode not in
                                ('200000000022', '200000000492', '200000000024', '200010000015',
                                 '200000000042', '200000000044', 'NULL')),
     rfm_base as (select
                      barcode,
                      '2022-06-09'::date - max(purchase_date) as recency,
                      count(receipt_id) as frequency,
                      sum(receipt_total) as monetary
                  from regular_receipts
                  group by barcode),
     rfm_scores as (select
                        barcode,
                        recency,
                        frequency,
                        monetary,
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
                            else ntile(3) over (partition by (monetary < 5000) order by monetary desc)
                            end as m_score
                    from rfm_base)
/* select
    barcode,
    recency,
    r_score,
    frequency,
    f_score,
    monetary,
    m_score
from rfm_scores
order by recency, frequency desc, monetary desc;*/
select
    count(barcode) as cohort_size,
    r_score::text || f_score::text || m_score::text as cohort_segment
from rfm_scores
group by r_score, f_score, m_score
order by  r_score, f_score, m_score;
/*
 Result:
+-----------+--------------+
|cohort_size|cohort_segment|
+-----------+--------------+
|13         |100           |
|11         |101           |
|15         |110           |
|52         |111           |
|11         |112           |
|15         |120           |
|166        |121           |
|98         |122           |
|32         |123           |
|4          |130           |
|70         |131           |
|93         |132           |
|156        |133           |
|4          |200           |
|1          |201           |
|3          |210           |
|21         |211           |
|3          |212           |
|14         |220           |
|131        |221           |
|100        |222           |
|29         |223           |
|3          |230           |
|82         |231           |
|149        |232           |
|195        |233           |
|5          |311           |
|1          |312           |
|5          |320           |
|60         |321           |
|48         |322           |
|15         |323           |
|9          |330           |
|135        |331           |
|230        |332           |
|306        |333           |
+-----------+--------------+



 */