Among valid numbers, unusual behavior is sometimes observed. For example, it also happens that different loyalty cards are used within a single receipt. Let’s take a look at one such receipt.

| receipt | position | card | price | discount\_code | drug\_code | drug\_name |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1903 | 1 | 200010017048 | 333 | 9 | 112034 | АМЕЛОТЕКС 15МГ. |
| 1903 | 2 | 200010017048 | 339 | 9 | 261404 | ВАЛСАРТАН 80МГ. |
| 1903 | 3 | 200000000042 | 135 | 939 | 339288 | ЛИНКОМИЦИН 250М |

Card 200000000042 appears in 73 transactions across 8 different pharmacies, whereas card 200010017048 appears only in these two transactions included in this receipt.

There are 3 687 receipts (8 066 transactions) in which two valid cards are listed at the same time. There are 18 such cards in total.

Let’s not forget that some of these cards may belong to normal customers, we wouldn’t want to exclude them, especially if they are our regular customers.

Before deciding what to do with these cards, let’s look at the top performers in terms of the number of receipts.

![](images/top_performers.png)

Card '200000000022' accounts for more than a quarter of all receipts. The top six cards with the highest number of receipts together accumulate over half of all receipts. We should also pay attention to how many different stores these cards were used in. I would assume that pharmacy employees might use certain cards to process orders placed, for example, by phone, or to adjust the discount amount for certain products. 

| rank | receipts | card | stores |
| :--- | :--- | :--- | :--- |
| 1 | 2000 | 200000000022 | 1 |
| 2 | 1032 | 200000000492 | 7 |
| 3 | 527 | 200000000024 | 7 |
| 4 | 82 | 200010000015 | 8 |
| 5 | 73 | 200000000042 | 8 |
| 6 | 47 | 200000000044 | 6 |

We highlight these first six cards. Cards with ids 2 through 6 have fewer transactions, but purchases were made at different stores. For example, for the second card, 200000000492, was active every day included in the dataset, there were 1032 transactions totaling 839 869.77 rubles, and transactions were conducted at multiple pharmacies on each working day.

| num\_active\_days | min\_recipts\_daily | avg\_recipts\_daily | max\_recipts\_daily | min\_dist\_stores\_daily |
| :--- | :--- | :--- | :--- | :--- |
| 39 | 14 | 26.5 | 35 | 4 |

Now, by combining these two issues — an excessively large number of transactions (6 cards) and the simultaneous appearance of two cards in a single receipt (18 cards) — we can cross-reference our lists of “suspicious” cards. Among the six cards, five also appear in the list of cards that appeared in receipts alongside other cards. These five cards account for 3 687 receipts with two cards (out of 3 748).

The remaining top cards by number of receipts do not show either diversity of stores or an unusually high number of receipts (visiting a pharmacy every day, without additional factors, is not beyond what we might expect from a regular customer).

Thus, we exclude these 6 top performers from the analysis.
