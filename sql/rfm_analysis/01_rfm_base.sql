/*
 Recency (how recently a customer made a purchase). Since we are working with a limited dataset, we will treat the last day in the dataset as the zero point for recency. For each customer, we will determine the minimum number of days between their purchases and this date. We use smaller group number for more recent activity (any customer from Group 1 did his/her most recent purchase after any customer from Group 3).

 Frequency (how often they buy). As we observed during data preparation, multiple reciepts on the same day are very rare (for regular customers). Therefore, we will measure purchase frequency based on the number of reciepts, rather than the number of calendar days. We use smaller group number for higher frequency (Group 1 uses store more often than Group 3).

 Monetary value (how much they spend). We use smaller group number for users with bigger purchases (Group 1 spends more than Group 3).
 */

/*
To begin, we will compile a table containing the receipts that will serve as the basis for the RFM analysis. To do this, we will first merge all missing NULL-transactions into their corresponding receipts (CTE all_receipts), then filter out the barcodes we identified as outliers as well as any receipts whose barcode remained NULL after all processing steps (CTE regular_receipts).
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
                                 '200000000042', '200000000044', 'NULL'))
select *
from regular_receipts;

/*
 We can check what proportion of receipts will ultimately form the basis for the analysis.
 */

with all_receipts as (select
                          dr_dat as purchase_date,
                          coalesce(min(dr_bcdisc) filter (where dr_bcdisc not in
                                                                ('200000000022', '200000000492', '200000000024',
                                                                 '200010000015', '200000000042', '200000000044',
                                                                 'NULL')),
                                   min(dr_bcdisc)) as barcode,
                          dr_nchk as receipt_id,
                          round(sum(dr_kol * dr_croz - dr_sdisc)::numeric, 2) as receipt_total,
                          count(*) as number_of_items
                      from sales
                      group by dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl),
     regular_receipts as (select *
                          from all_receipts
                          where barcode not in
                                ('200000000022', '200000000492', '200000000024', '200010000015',
                                 '200000000042', '200000000044', 'NULL')),
     excluded_receipts as (select *
                           from all_receipts
                           where barcode in
                                 ('200000000022', '200000000492', '200000000024', '200010000015',
                                  '200000000042', '200000000044', 'NULL'))
select
    'Regular receipts' as type,
    count(receipt_id) as receipts,
    sum(number_of_items) as transactions
from regular_receipts
union all
select
    'Excluded receipts',
    count(receipt_id),
    sum(number_of_items)
from excluded_receipts
union all
select
    'Total',
    count(receipt_id),
    sum(number_of_items)
from all_receipts;

/*
 Result:
+-----------------+--------+------------+
|type             |receipts|transactions|
+-----------------+--------+------------+
|Regular receipts |3886    |10256       |
|Excluded receipts|17116   |34872       |
|Total            |21002   |45128       |
+-----------------+--------+------------+

The RFM analysis will be based on 18.5% of all receipts available in the dataset. This corresponds to 3 886 receipts, representing purchases made by 2 285 customers. Compared to the initial dataset, the analysis will be based on 10 256 transactions, which corresponds to slightly less than 22.7% of the entire dataset.
 */
