The discount amount is represented as a positive value, which is then subtracted from the cost of the items in the transaction. Therefore, the total cost of goods sold in a single transaction is calculated as: quantity sold × retail price – discount amount (DR_Kol × DR_CRoz – DR_SDisc). 

Among all transactions, only five have either a negative quantity or a negative discount amount. There are no transactions with negative total values.

| quantity\_sold | discount\_amount | discount\_barcode |
| :--- | :--- | :--- |
| 1 | -0.01 | NULL |
| -1 | -102 | NULL |
| -1 | 0 | NULL |
| -1 | 0 | NULL |
| -1 | -470 | NULL |

Among these orders, those with a negative quantity -1, the corresponding receipts consist of a single item, and the loyalty card is recorded as 'NULL'. In transactions with a positive quantity but a negative discount, card 200000000492 is used, which we exclude in our analysis (see [unusual_behavior_overview.md](unusual_behavior_overview.md)).

A negative retail markup occurs only for a single product, “Loyalty Card.” 

| product\_name | retail\_price | wholesale\_price | discount\_amount | discount\_barcode |
| :--- | :--- | :--- | :--- | :--- |
| Карта LOYALITY 25Р | 25 | 59.67 | 0 | NULL |

Presumably, purchasing this item through retail is one way to start using the benefits of the loyalty program. Therefore, it’s not surprising that these transactions are associated only with invalid customer cards. 

Thus, no further actions or decisions are required regarding this issue.
