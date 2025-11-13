/*
 Let’s examine how many distinct receipts are present in the data in total; how many of them include a valid loyalty card and how many contain a NULL card. To count them, we use the primary key without the positions (dr_pos) field.
 */

select
    count(distinct (dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl)) as total,
    count(distinct (dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl))
        filter (where dr_bcdisc = 'NULL') as null_receipts,
    count(distinct (dr_dat, dr_tim, dr_nchk, dr_ndoc, dr_apt, dr_kkm, dr_tabempl))
        filter (where dr_bcdisc != 'NULL') as valid_receipts
from sales;

/*
 Result:
    +-----+-------------+--------------+
    |total|null_receipts|valid_receipts|
    +-----+-------------+--------------+
    |21002|14184        |7606          |
    +-----+-------------+--------------+

 We see that the sum of valid and 'NULL' receipts does not equal the total. This means that some receipts contain both items purchased with a valid loyalty card and items for which no discount was applied.

 We can assume that certain product categories are not eligible for discounts. Let’s take a look at one of these receipts as an example.
 */

select
    dr_nchk as receipt,
    dr_pos as position,
    dr_bcdisc as card,
    dr_croz * dr_kol as price,
    dr_cdisc as discount_code,
    dr_cdrugs as drug_code,
    left(dr_ndrugs, 15) as drug_name
from sales
where dr_dat = '2022-05-29'::date
  and dr_tim = '10:08:06'::time
  and sales.dr_nchk = 2297
  and dr_ndoc = 11004981
  and dr_apt = 11
  and dr_kkm = 23925;

/*
 Result:
+-------+--------+------------+-----+-------------+---------+---------------+
|receipt|position|card        |price|discount_code|drug_code|drug_name      |
+-------+--------+------------+-----+-------------+---------+---------------+
|2297   |1       |NULL        |395  |NULL         |4260     |ВИБРОЦИЛ 15МЛ. |
|2297   |2       |NULL        |455  |NULL         |76754    |РЕННИ №24 ТАБ.Ж|
|2297   |3       |200000000024|259  |30           |83115    |РОКС ЗУБ.ПАСТА |
|2297   |4       |200000000024|256  |30           |27561    |РОКС ЗУБ.ПАСТА |
|2297   |5       |NULL        |121  |NULL         |72392    |СНУП 0,1% 90МКГ|
|2297   |6       |NULL        |121  |NULL         |72392    |СНУП 0,1% 90МКГ|
|2297   |7       |NULL        |446  |NULL         |31       |ТАНТУМ ВЕРДЕ 0,|
+-------+--------+------------+-----+-------------+---------+---------------+



