For the selected groups, we will additionally calculate the average receipt amount and the average number of items per receipt (within the group).

The average receipt (including parapharmaceuticals) in 2022 was 601.8 RUB (see the [RNC Pharma blogpost about average one-time purchase in pharmacies in 2022 - 2025](https://rncph.ru/blog/201025/), in Russian). 

![](images/rnc_pharma_one_time_purchase_average.png)

We also know that in 2025 customers purchased, on average, 2.4–3 packages per month (see the [RNC Pharma blogpost about average per capita spending on the purchase of medicines](https://rncph.ru/blog/150925/), in Russian).

## Generous Customers

Let’s start with a group of super performers by average receipt. They are characterized by a low frequency, but a high average receipt (at least three times higher than the 2022 average) and a relatively high number of items per receipt.

| rfm | average\_receipt\_total | average\_number\_of\_items | average_discount | group\_size |
|:----|:------------------------|:---------------------------|:-----------------|:------------|
| 130 | 12255.25                | 9                          | 4.99             | 4           |
| 230 | 6644.33                 | 6.33                       | 4.85             | 3           |
| 330 | 6006.89                 | 9.89                       | 4.91             | 9           |
| 220 | 3337.68                 | 4.9                        | 4.53             | 14          |
| 320 | 3297.92                 | 7.08                       | 4.32             | 5           |
| 120 | 2563.62                 | 3.69                       | 4.7              | 15          |
| 131 | 2056.24                 | 3.93                       | 5.02             | 70          |
| 231 | 1984.45                 | 4.61                       | 5.08             | 82          |
| 331 | 1968.3                  | 4.46                       | 5.2              | 136         |

We can see that groups x30, x31, and x20 (with all possible recency values) fall into this category. The largest share consists of customers in group x31. These appear to be customers who visit the pharmacy due to a particular one-off circumstance (we see large number of items in the receipt), who do not visit often (we see a small group of 34 people who came 2 or 3 times, the rest only once), but who do not economize on medical products when needed. We will call this group the Generous Customers. 

These customers should be encouraged to return for future purchases. A limited-time special offer can be proposed, and they should also be introduced to the pharmacy’s extended assortment. 

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Generous Customers | 2450.81 | 4.64 | 5.07 | 334 |

## Outstanding Customers

Next is the group of regular customers with an average receipt above, or even up to an order of magnitude higher than, the 2022 average.

| rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| 110 | 1920.48 | 3.52 | 5.82 | 15 |
| 210 | 1326.93 | 3.6 | 5.13 | 3 |
| 321 | 964.14 | 2.89 | 5.16 | 60 |
| 221 | 938.57 | 3.15 | 5.35 | 130 |
| 121 | 935.23 | 3.07 | 5.22 | 164 |

Groups x10 and x21 fall into this category (Group 310 is empty). These are our regular customers who visit the pharmacy 2 to 3 times within 6 weeks (18 of them came 4–6 times). The frequency of this group shows consistent pharmacy visits. We also observe a high average receipt amount, but unlike the Generous Customers, the average number of items per receipt is below 4. Most likely, they purchase fewer non-medical products.

A special note should be made about group x21. 

| rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| x21 | 941.06 | 3.07 | 5.26 | 354 |

These are our key customers with high potential. They are willing to spend and demonstrate strong loyalty to the pharmacy. Our task is to increase the number of items in their receipts by offering them a wider range of non-medical products.

We will also include groups 100 and 200 here (group 300 is empty). They visit the pharmacy very frequently, have a high average receipt amount, and a very high monetary value (over 5,000 rubles). These are customers who live nearby and have high demand for medical products.

| rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| 200 | 812.53 | 2.63 | 5.25 | 4 |
| 100 | 670.97 | 2.41 | 5.15 | 13 |

We will call this entire group "Outstanding Customers." 

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Outstanding Customers | 945.26 | 2.97 | 5.28 | 389 |

## Promising Customers

The next set brings together customers from the x32 groups. These are customers who visited the pharmacy only once but made a purchase with a relatively high average receipt amount. These are Promising Customers whom we would like to bring back to the store. 

| rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| 332 | 817.3 | 2.85 | 5.27 | 102 |
| 132 | 812.86 | 2.3 | 5.46 | 37 |
| 232 | 798.92 | 2.7 | 5.64 | 64 |

We can see that they have a high discount percentage (compare this to the Generous Customers, who also visited only once, but whose discounts were lower or around 5%). This indicates that many of the items in their receipt were discounted, meaning these customers are interested in the promotions and discounts offered by the pharmacy.

A limited-time special offer can be proposed, and they should also be introduced to the pharmacy’s extended assortment. We will call this group Promising Customers. Together with Generous Customers they form a strong potential to expand the Outstanding group.

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Promising Customers | 810.7 | 2.7 | 5.42 | 203 |

## Pharmacy Friends

Next, we will identify a group of customers who visit us regularly. Their average receipt amount is small, but they show medium or high monetary values. 

| rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| 111 | 620.25 | 2.61 | 5.96 | 52 |
| 311 | 580.14 | 1.8 | 5.37 | 5 |
| 211 | 565.64 | 2.5 | 5.71 | 21 |
| 101 | 461.72 | 2.24 | 5.31 | 11 |
| 322 | 382.44 | 2.56 | 4.97 | 27 |
| 222 | 365.72 | 2.6 | 5.16 | 53 |
| 122 | 337.7 | 2.33 | 5.66 | 47 |
| 201 | 292.86 | 1.86 | 7.25 | 1 |

They also tend to purchase discounted items. They visit frequently enough that weekly promotion newsletters for certain product categories are likely to be well received by them. We will call this group Pharmacy Friends.

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Pharmacy Friends | 484.43 | 2.47 | 5.51 | 217 |

## Neighborhood Customers

The next group demonstrates ordinary, need-based use of the pharmacy. We will call this group Neighborhood Customers.

| rfm | average\_receipt\_total | average\_number\_of\_items | average_discount | group\_size |
|:----|:------------------------|:---------------------------|:-----------------|:------------|
| 322 | 342.88                  | 2.31                       | 5.22             | 41          |
| 222 | 331.08                  | 2.5                        | 5.21             | 78          |
| 122 | 294.14                  | 2.18                       | 5.51             | 77          |
| 223 | 155.25                  | 1.5                        | 5.17             | 51          |
| 123 | 150.84                  | 1.76                       | 4.97             | 52          |

These customers most likely find it convenient to visit this pharmacy; the majority of them came in no more than three weeks ago, and they probably do not have a consistent need for medicinal products. Special offers are unlikely to bring these customers back to the pharmacy. It may not even be worth bothering them with promotional messages.

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Neighborhood Customers | 187.15 | 1.76 | 5.13 | 213 |

## Interested Visitors

The final group is a large one of one-time visitors who popped in for a pack of paracetamol or ibuprofen.

| rfm | average\_receipt\_total | average\_number\_of\_items | discount | group\_size |
|:----|:------------------------|:---------------------------|:---------|:------------|
| 333 | 220.09                  | 1.84                       | 4.94     | 359         |
| 133 | 218.17                  | 1.79                       | 4.72     | 181         |
| 233 | 211.06                  | 1.85                       | 4.91     | 227         |

Nevertheless, they agreed to buy a loyalty card, so we will call this group the Interested Visitors. We do not know their behavior when they need a larger quantity of medications. We can provide them with an extended promotional mailing in the hope that some of them will choose to return. Our task is to  remind them that they once visited our pharmacy. A short survey could also be sent to them.

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Interested Visitors | 276.21 | 1.99 | 4.94 | 929 |

##SQL Verification  

All the SQL queries used in this section are available in the [GitHub repository](https://github.com/TAbramovskaya/SML-metabase-final-project/blob/main/sql/rfm_analysis/06_average_receipt_by_group.sql) for review and verification.