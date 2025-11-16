Let’s take a look at how the score boundaries for monetary were determined when dividing customers into three equal groups. (Explore the [SQL queries for this section](../sql/rfm_analysis/04_monetary_study.sql).)

| m\_score | group\_size | min\_monetary | max\_monetary |
| :--- | :--- | :--- | :--- |
| 1 | 762 | 1123 | 32058 |
| 2 | 762 | 389 | 1122 |
| 3 | 761 | 24 | 388 |

The median monetary value is 659 RUB, average -- 745.5 RUB. We can see that the highest spending values differ from the median by two orders of magnitude.

We will rely on publicly available research from the analytical company RNC Pharma. According to their analytics, in the first seven months of 2025, Russians spent more than 900 RUB per month on purchasing medicinal products ([RNC Pharma blogpost about average per capita spending on the purchase of medicines](https://rncph.ru/blog/150925/)). Note that RNC Pharma analysts distinguish between purchases of medicines and non-medicinal products offered by pharmacies (parapharmaceuticals: cosmetics, food supplements, etc).

The average receipt for medicines in the available 2025 data is 618.5 RUB, while in 2022 the average receipt for medicines was 462.7 RUB ([blogpost about average one-time purchase in pharmacies in 2022 - 2025](https://rncph.ru/blog/201025/)). 

![](images/rnc_pharma_one_time_purchase_average.png)

We will make a very rough assumption that the pharmacy visitation patterns did not change significantly, and we will interpolate the 2025 proportions to 2022. Overall, the trend appears stable — see the [blogpost about dynamics (monthly) of the average one-time purchase 2023-2025](https://rncph.ru/blog/170425/).

Thus, we will assume that in 2022 the monthly spending on medicinal products is approximately 673.3 RUB.

From the referenced reports, we also see that the average receipt including parapharmaceuticals in 2022 was 1.3 times higher, at 601.8 RUB, but we also see that parapharmaceutical sales are stagnating over the years covered. So by inflating monthly spending on medicinal products by the same factor (1.3 x 673.3 RUB = 875.7 RUB), we are likely overestimating average monthly (medicinal products + parapharmaceuticals) spending in pharmacies in 2022.

In our transactions, we record total customer spending, including parapharmaceuticals, and our observation period is longer than one month. We have made very rough assumptions, so the estimates above should not be interpreted literally, however, they allow us to assess the order of magnitude. Based on our data, the average spending over six weeks is 745.5 RUB -- using this observed average as a reference point is fully justified.

Let’s define Group 0 as customers who spent more than or equal to 5 000 RUB, and divide the remaining customers into three approximately equal groups.
 
| m\_score | group\_size | min\_monetary | max\_monetary |
| :--- | :--- | :--- | :--- |
| 0 | 85 | 5014 | 32058 |
| 1 | 734 | 1043 | 4995 |
| 2 | 733 | 371 | 1043 |
| 3 | 733 | 24 | 371 |
