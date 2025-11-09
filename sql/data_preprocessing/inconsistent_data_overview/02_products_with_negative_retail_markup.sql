/*
 Let’s examine whether there are product groups with a retail markup.
 */

select distinct
    dr_ndrugs as product_name,
    dr_kol as quantity_sold,
    dr_croz as retail_price,
    dr_czak as wholesale_price,
    dr_sdisc as discount_amount,
    dr_cdisc as discount_code,
    dr_bcdisc as discount_barcode
from sales
where dr_czak > dr_croz
group by dr_ndrugs,
         dr_kol,
         dr_croz,
         dr_czak,
         dr_sdisc,
         dr_cdisc,
         dr_bcdisc;

/*
 Result:
    +------------------+-------------+------------+---------------+---------------+-------------+----------------+
    |product_name      |quantity_sold|retail_price|wholesale_price|discount_amount|discount_code|discount_barcode|
    +------------------+-------------+------------+---------------+---------------+-------------+----------------+
    |Карта LOYALITY 25Р|1            |25          |59.67          |0              |NULL         |NULL            |
    +------------------+-------------+------------+---------------+---------------+-------------+----------------+

 A negative retail markup occurs only for a single product, “Loyalty Card.” Presumably,
 purchasing this item through retail is one way to start using the benefits of the
 loyalty program. Therefore, it’s not surprising that these transactions are associated
 only with invalid customer cards. A total of 52 such cards were sold during the period
 under consideration:
 */

 select
    count(dr_ndrugs)
from sales
 where dr_ndrugs = 'Карта LOYALITY 25Р';

/*
 Result:
    +-----+
    |count|
    +-----+
    |52   |
    +-----+

 */