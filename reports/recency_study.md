Let’s take a look at how the score boundaries for recency were determined when dividing customers into three equal groups. (Explore the [SQL queries for this section](../sql/rfm_analysis/02_recency_study.sql).)

| r\_score | group\_size | min\_recency | max\_recency |
| :--- | :--- | :--- | :--- |
| 1 | 762 | 0 | 9 |
| 2 | 762 | 9 | 21 |
| 3 | 761 | 21 | 39 |

One third of the users made their most recent purchase no more than 10 days before the final date in the dataset. We have a six-week observation window, during which more than two thirds of all customers made their last purchase in the second half of the period. We consider this grouping appropriate.
