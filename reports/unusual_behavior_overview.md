Among valid barcodes, unusual behavior is sometimes observed. For example, it also happens that different barcodes are used within a single receipt. Let’s take a look at one such receipt.

| date | time | receipt | item\_number | barcode | discount\_code | drug\_name |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 2022-05-15 | 17:21:31 | 1903 | 1 | 200010017048 | 9 | АМЕЛОТЕКС 15МГ. |
| 2022-05-15 | 17:21:31 | 1903 | 2 | 200010017048 | 9 | ВАЛСАРТАН 80МГ. |
| 2022-05-15 | 17:21:31 | 1903 | 3 | 200000000042 | 939 | ЛИНКОМИЦИН 250М |


Barcode 200000000042 appears in 73 transactions across 8 different stores, whereas barcode 200010017048 appears only in these two transactions included in this receipt. We may assume that some barcodes (like “the forty-second” in the example receipt) might be used by pharmacy staff together with a customer’s barcode. As we will see later, some barcodes appear an unusually high number of times.

There are 41 receipts in which two barcodes are listed at the same time. There are 18 such barcodes in total.

|                |                |                |                |                |                |
|:---------------|:---------------|:---------------|:---------------|:---------------|:---------------|
| '200000000022' | '200000000492' | '200000000024' | '200010000015' | '200000000042' | '200010018869' |
| '200010027390' | '200010020351' | '200010007376' | '200010022634' | '200010000007' | '200010016458' |
| '200010001032' | '200010000888' | '200010000008' | '200010026840' | '200010013481' | '200010017048' |

Some of them show typical activity, while others show patterns that do not align with the expected “normal customer behavior.”

Before deciding how to handle these barcodes, let’s look at the top performers in terms of the number of receipts.

![](images/top_performers.png)

Barcode '200000000022' accounts for more than a quarter of all receipts (and 2000 transactions totaling 1 529 558.10RUB). The top six cards with the highest number of receipts together accumulate over half of all receipts. We should also pay attention to how many different stores these cards were used in. I would also assume that pharmacy employees might use certain cards to process orders placed, for example, by phone. 

| rank | receipts | card | different\_stores |
| :--- | :--- | :--- | :--- |
| 1 | 2000 | 200000000022 | 1 |
| 2 | 1032 | 200000000492 | 7 |
| 3 | 527 | 200000000024 | 7 |
| 4 | 82 | 200010000015 | 8 |
| 5 | 73 | 200000000042 | 8 |
| 6 | 47 | 200000000044 | 6 |

We highlight these first six barcodes. Barcodes with ranks 2 through 6 have fewer transactions, but purchases were made at different stores. For example, for the second barcode, 200000000492, was active every day included in the dataset, there were 1032 transactions totaling 839 869.77RUB, and transactions were conducted at multiple pharmacies on each working day.

| num\_active\_days | min\_recipts\_daily | avg\_recipts\_daily | max\_recipts\_daily | min\_dist\_stores\_daily |
| :--- | :--- | :--- | :--- | :--- |
| 39 | 14 | 26.5 | 35 | 4 |

Now, by combining these two issues — an excessively large number of transactions (6 barcodes) and the simultaneous appearance of two barcodes in a single receipt (18 cards) — we can cross-reference our lists of “suspicious” barcodes. Among the six cards, five also appear in the list of 18.

The remaining top performing barcodes do not show either diversity of stores or an unusually high number of receipts (visiting a pharmacy every day, without additional factors, is not beyond what we might expect from a regular customer).

Thus, we say that these 6 top performers are "internal-use" barcodes, and we exclude them from the analysis.
