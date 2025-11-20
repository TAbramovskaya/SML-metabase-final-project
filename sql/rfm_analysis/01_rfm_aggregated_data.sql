/*
 To begin, we will compile a table containing the receipts that will serve as the basis for the RFM analysis. To do this, we will first merge all missing NULL-transactions into their corresponding receipts (CTE all_receipts), then filter out the barcodes we identified as internal use only as well as any receipts whose barcode remained NULL after all processing steps (CTE regular_receipts).

 The CTE all_receipts contains information on all receipts present in the original database. To ensure the completeness of each receipt (as mentioned earlier, a single receipt can contain multiple barcodes), we use a partial PK (excluding the item number field dr_pos). As a result, for each receipt we obtain a set of dr_bcdisc values, and we want to select from this set the barcode we consider “regular.”

 We take advantage of the fact that the value 'NULL' in dr_bcdisc is always recorded as a string, so it is lexicographically greater than any numeric string. Initially, we attempt to exclude from this set all internal-use barcodes and 'NULL' (there are no receipts in the database containing more than two distinct numeric barcodes). If a receipt contains only internal-use barcodes and/or 'NULL', the receipt is assigned the minimal value among them.

 In the regular_receipts CTE, we filter out receipts that were assigned an internal-use or 'NULL' barcode.
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
                          where barcode not in (select bad_bc from internal_use_and_null))
select *
from regular_receipts;

/*
 We can check what proportion of receipts will ultimately form the basis for the analysis.
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
     excluded_receipts as (select *
                           from all_receipts
                           where barcode in (select bad_bc from internal_use_and_null))
select
    'Regular' as type,
    count(receipt_id) as receipts,
    sum(number_of_items) as transactions
from regular_receipts
union all
select
    'Excluded',
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
+--------+--------+------------+
|type    |receipts|transactions|
+--------+--------+------------+
|Regular |3886    |10256       |
|Excluded|17116   |34872       |
|Total   |21002   |45128       |
+--------+--------+------------+

The RFM analysis will be based on 18.5% of all receipts available in the dataset. This corresponds to 3 886 receipts, representing purchases made by 2 285 customers. Compared to the initial dataset, the analysis will be based on 10 256 transactions, which corresponds to slightly less than 22.7% of the entire dataset.
 */
