/*
 Let’s look at the distribution of customers with invalid (null) cards and valid cards
 by day. Since we have no way to distinguish between invalid cards (it’s possible that
 some invalid transactions were made by the same person), we will also count valid
 cards not by the number of unique customers per day, but by the number of purchases
 made with a valid card per day.
 */

select
    dr_dat,
    count(dr_bcdisc) filter (where dr_bcdisc = 'NULL') as null_cards,
    count(dr_bcdisc) filter (where dr_bcdisc != 'NULL') as valid_cards
from sales
group by dr_dat
order by dr_dat;

/*
 Result:
    +----------+----------+-----------+
    |dr_dat    |null_cards|valid_cards|
    +----------+----------+-----------+
    |2022-05-01|604       |263        |
    |2022-05-02|659       |398        |
    |2022-05-03|670       |423        |
    |2022-05-04|712       |478        |
    |2022-05-05|682       |507        |
    |2022-05-06|742       |554        |
    |2022-05-07|793       |381        |
    |2022-05-08|739       |352        |
    |2022-05-10|632       |380        |
    |2022-05-11|728       |496        |
    |2022-05-12|680       |440        |
    |2022-05-13|611       |590        |
    |2022-05-14|694       |414        |
    |2022-05-15|592       |442        |
    |2022-05-16|740       |587        |
    |2022-05-17|792       |458        |
    |2022-05-18|669       |526        |
    |2022-05-19|717       |550        |
    |2022-05-20|739       |571        |
    |2022-05-21|685       |459        |
    |2022-05-22|611       |366        |
    |2022-05-23|699       |596        |
    |2022-05-24|764       |505        |
    |2022-05-25|734       |522        |
    |2022-05-26|671       |437        |
    |2022-05-27|733       |461        |
    |2022-05-28|775       |361        |
    |2022-05-29|641       |432        |
    |2022-05-30|615       |540        |
    |2022-05-31|686       |505        |
    |2022-06-01|733       |430        |
    |2022-06-02|669       |419        |
    |2022-06-03|782       |510        |
    |2022-06-04|657       |318        |
    |2022-06-05|550       |226        |
    |2022-06-06|760       |493        |
    |2022-06-07|772       |470        |
    |2022-06-08|734       |546        |
    |2022-06-09|726       |530        |
    +----------+----------+-----------+
 */