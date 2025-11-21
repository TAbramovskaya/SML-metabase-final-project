For the selected groups, we will additionally calculate the average receipt amount and the average number of items per receipt (within the group).

The average receipt (including parapharmaceuticals) in 2022 was 601.8 RUB (see the [RNC Pharma blogpost about average one-time purchase in pharmacies in 2022 - 2025](https://rncph.ru/blog/201025/), in Russian). 

![](images/rnc_pharma_one_time_purchase_average.png)

We also know that in 2025 customers purchased, on average, 2.4–3 packages per month (see the [RNC Pharma blogpost about average per capita spending on the purchase of medicines](https://rncph.ru/blog/150925/), in Russian).

## Generous Customers

Let’s start with a group of super performers by average receipt. They are characterized by a low frequency, but a high average receipt (at least three times higher than the 2022 average) and a relatively high number of items per receipt.

??? abstract "Click to expand the table"

    | rfm | average\_receipt\_total | average\_number\_of\_items | average_discount | group\_size |
    |:----|:------------------------|:---------------------------|:-----------------|:------------|
    | 130 | 12255.25 | 9 | 4.99 | 4 |
    | 230 | 6644.33 | 6.33 | 4.85 | 3 |
    | 330 | 6006.89 | 9.89 | 4.91 | 9 |
    | 320 | 3569.7 | 6.9 | 4.32 | 5 |
    | 220 | 3447.65 | 4.77 | 4.53 | 14 |
    | 120 | 2639.18 | 3.81 | 4.7 | 15 |
    | 131 | 2070.88 | 3.97 | 5.05 | 69 |
    | 331 | 1989.12 | 4.47 | 5.22 | 133 |
    | 231 | 1984.45 | 4.61 | 5.08 | 82 |

We can see that groups x30, x31, and x20 (with all possible recency values) fall into this category. The largest share consists of customers in group x31. These appear to be customers who visit the pharmacy due to a particular one-off circumstance (we see large number of items in the receipt), who do not visit often (we see a small group of 34 people who came 2 or 3 times, the rest only once), but who do not economize on medical products when needed. We will call this group the Generous Customers. 

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Generous Customers | 2391.88 | 4.64 | 5.07 | 334 |

## Outstanding Customers

Next is the group of regular customers with an average receipt above, or even up to an order of magnitude higher than, the 2022 average.

??? abstract "Click to expand the table"

    | rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
    | :--- | :--- | :--- | :--- | :--- |
    | 110 | 1956.47 | 3.59 | 5.82 | 15 |
    | 210 | 1326.93 | 3.6 | 5.13 | 3 |
    | 321 | 984.26 | 2.89 | 5.16 | 60 |
    | 121 | 962.65 | 3.14 | 5.22 | 164 |
    | 221 | 962.37 | 3.19 | 5.35 | 130 |

Groups x10 and x21 fall into this category (Group 310 is empty). These are our regular customers who visit the pharmacy 2 to 3 times within 6 weeks (18 of them came 4–6 times). The frequency of this group shows consistent pharmacy visits. We also observe a high average receipt amount, but unlike the Generous Customers, the average number of items per receipt is below 4. Most likely, they purchase fewer non-medical products.

A special note should be made about group x21. 

| rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| x21 | 966.21 | 3.11 | 5.26 | 354 |

These are our key customers with high potential. They are willing to spend and demonstrate strong loyalty to the pharmacy. 

We will also include groups 100 and 200 here (group 300 is empty). They visit the pharmacy very frequently, have a high average receipt amount, and a very high monetary value (over 5,000 rubles). These are customers who live nearby and have high demand for medical products.

??? abstract "Click to expand the table"

    | rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
    | :--- | :--- | :--- | :--- | :--- |
    | 200 | 906.87 | 2.71 | 5.25 | 4 |
    | 100 | 761.04 | 2.59 | 5.15 | 13 |

We will call this entire group "Outstanding Customers." 

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Outstanding Customers | 999.71 | 3.11 | 5.28 | 389 |

## Promising Customers

The next set brings together customers from the x32 groups. These are customers who visited the pharmacy only once but made a purchase with a relatively high average receipt amount. These are Promising Customers whom we would like to bring back to the store. 

??? abstract "Click to expand the table"

    | rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
    | :--- | :--- | :--- | :--- | :--- |
    | 332 | 817.3 | 2.85 | 5.27 | 102 |
    | 132 | 812.86 | 2.3 | 5.46 | 37 |
    | 232 | 798.92 | 2.7 | 5.64 | 64 |

We can see that they have a high discount percentage (compare this to the Generous Customers, who also visited only once, but whose discounts were lower or around 5%). This indicates that many of the items in their receipt were discounted, meaning these customers are interested in the promotions and discounts offered by the pharmacy.

We will call this group Promising Customers. Together with Generous Customers they form a strong potential to expand the Outstanding group.

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Promising Customers | 810.7 | 2.7 | 5.42 | 203 |

## Pharmacy Friends

Next, we will identify a group of customers who visit us regularly. Their average receipt amount is small, but they show medium or high monetary values. 

??? abstract "Click to expand the table"

    | rfm | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
    | :--- | :--- | :--- | :--- | :--- |
    | 111 | 623.27 | 2.63 | 5.96 | 52 |
    | 311 | 580.14 | 1.8 | 5.37 | 5 |
    | 211 | 575.81 | 2.55 | 5.71 | 21 |
    | 101 | 469.49 | 2.25 | 5.31 | 11 |
    | 322 | 390.94 | 2.58 | 4.97 | 27 |
    | 222 | 374.12 | 2.55 | 5.16 | 53 |
    | 122 | 352.81 | 2.34 | 5.66 | 47 |
    | 201 | 292.86 | 1.86 | 7.25 | 1 |

They also tend to purchase discounted items. 

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Pharmacy Friends | 460.03 | 2.49 | 5.51 | 217 |

## Neighborhood Customers

The next group demonstrates ordinary, need-based use of the pharmacy. We will call this group Neighborhood Customers.

??? abstract "Click to expand the table"

    | rfm | average\_receipt\_total | average\_number\_of\_items | average_discount | group\_size |
    |:----|:------------------------|:---------------------------|:-----------------|:------------|
    | 212 | 231.75 | 2.75 | 6.61 | 1 |
    | 112 | 207.31 | 1.5 | 4.4 | 8 |
    | 223 | 192.63 | 1.75 | 5.2 | 77 |
    | 123 | 190.07 | 1.81 | 5.07 | 85 |
    | 323 | 189.3 | 1.71 | 5.14 | 36 |
    | 313 | 149.25 | 1.5 | 6.57 | 1 |
    | 113 | 122.3 | 1.57 | 5.34 | 3 |
    | 213 | 112.75 | 1.63 | 5.95 | 2 |

These customers most likely find it convenient to visit this pharmacy; the majority of them came in no more than three weeks ago, and they probably do not have a consistent need for medicinal products. 

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Neighborhood Customers | 189.83 | 1.76 | 5.13 | 213 |

## Interested Visitors

The final group is a large one of one-time visitors who popped in for a pack of paracetamol or ibuprofen.

??? abstract "Click to expand the table"

    | rfm | average\_receipt\_total | average\_number\_of\_items | discount | group\_size |
    |:----|:------------------------|:---------------------------|:---------|:------------|
    | 333 | 280.04 | 1.96 | 4.95 | 436 |
    | 233 | 275.43 | 2.1 | 5 | 280 |
    | 133 | 269.4 | 1.91 | 4.86 | 213 |

Nevertheless, they agreed to buy a loyalty card, so we will call this group the Interested Visitors.

| group\_name | average\_receipt\_total | average\_number\_of\_items | average\_discount | group\_size |
| :--- | :--- | :--- | :--- | :--- |
| Interested Visitors | 276.21 | 1.99 | 4.94 | 929 |

##SQL Verification  

All the SQL queries used in this section are available in the [GitHub repository](https://github.com/TAbramovskaya/SML-metabase-final-project/blob/main/sql/rfm_analysis/06_average_receipt_by_group.sql) for review and verification.