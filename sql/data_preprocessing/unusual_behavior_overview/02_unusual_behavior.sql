/*
 Among valid barcodes, unusual behavior is sometimes observed. For example, it also happens that different loyalty cards are used within a single receipt. Let’s take a look at one such receipt.
 */

select
    dr_nchk as receipt,
    dr_pos as position,
    dr_bcdisc as barcode,
    dr_croz * dr_kol as price,
    dr_cdisc as discount_code,
    dr_cdrugs as drug_code,
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
+-------+--------+------------+-----+-------------+---------+---------------+
|receipt|position|barcode     |price|discount_code|drug_code|drug_name      |
+-------+--------+------------+-----+-------------+---------+---------------+
|1903   |1       |200010017048|333  |9            |112034   |АМЕЛОТЕКС 15МГ.|
|1903   |2       |200010017048|339  |9            |261404   |ВАЛСАРТАН 80МГ.|
|1903   |3       |200000000042|135  |939          |339288   |ЛИНКОМИЦИН 250М|
+-------+--------+------------+-----+-------------+---------+---------------+

 Card 200000000042 appears in 73 transactions across 8 different pharmacies, whereas card 200010017048 appears only in these two transactions included in this receipt.

 In total, there are 18 cards that appeared in the same receipt simultaneously.
 ('200000000022', '200000000492', '200000000024', '200010000015', '200000000042', '200010018869', '200010027390', '200010020351', '200010007376', '200010022634', '200010000007', '200010016458', '200010001032', '200010000888', '200010000008', '200010026840', '200010013481', '200010017048')

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



