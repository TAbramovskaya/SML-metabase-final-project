/*
 Among valid barcodes, unusual behavior is sometimes observed. For example, it also happens that different barcodes are used within a single receipt. Let’s take a look at one such receipt.
 */

select
    dr_dat as date,
    dr_tim as time,
    dr_nchk as receipt,
    dr_pos as item_number,
    dr_bcdisc as barcode,
    dr_cdisc as discount_code,
    left(dr_ndrugs, 15) as drug_name
from sales
where dr_dat = '2022-05-15'::date
  and dr_tim = '17:21:31'::time
  and sales.dr_nchk = 1903
  and dr_ndoc = 13001738
  and dr_apt = 13
  and dr_kkm = 22576;

/*
 Result:
+----------+--------+-------+-----------+------------+-------------+---------------+
|date      |time    |receipt|item_number|barcode     |discount_code|drug_name      |
+----------+--------+-------+-----------+------------+-------------+---------------+
|2022-05-15|17:21:31|1903   |1          |200010017048|9            |АМЕЛОТЕКС 15МГ.|
|2022-05-15|17:21:31|1903   |2          |200010017048|9            |ВАЛСАРТАН 80МГ.|
|2022-05-15|17:21:31|1903   |3          |200000000042|939          |ЛИНКОМИЦИН 250М|
+----------+--------+-------+-----------+------------+-------------+---------------+

 Barcode 200000000042 appears in 73 transactions across 8 different stores, whereas barcode 200010017048 appears only in these two transactions included in this receipt. We may assume that some barcodes (like “the forty-second” in the example receipt) might be used by pharmacy staff together with a customer’s barcode. As we will see later, some barcodes appear an unusually high number of times.

TODO!! There are 3 687 receipts (8 066 transactions) in which two barcodes are listed at the same time. There are 18 such barcodes in total.
('200000000022', '200000000492', '200000000024', '200010000015', '200000000042', '200010018869', '200010027390', '200010020351', '200010007376', '200010022634', '200010000007', '200010016458', '200010001032', '200010000888', '200010000008', '200010026840', '200010013481', '200010017048')

 Some of them show typical activity, while others show patterns that do not align with the expected “normal customer behavior.”

 They account for 8 251 transactions across 3 748 receipts.
 */

select
    count(*) as num_transactions,
    count(distinct (dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl)) as num_receipts
from sales
where dr_bcdisc in
      ('200000000022', '200000000492', '200000000024', '200010000015', '200000000042', '200010018869', '200010027390',
       '200010020351', '200010007376', '200010022634', '200010000007', '200010016458', '200010001032', '200010000888',
       '200010000008', '200010026840', '200010013481', '200010017048');

/*
 Result:
+----------------+------------+
|num_transactions|num_receipts|
+----------------+------------+
|8251            |3748        |
+----------------+------------+
 */



