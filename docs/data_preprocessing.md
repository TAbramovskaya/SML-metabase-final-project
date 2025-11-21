## Handling NULLs

Participation in the discount program is determined by the loyalty card barcode, recorded in the `DR_BCDisc` field. For some transactions, this field has the string value `'NULL'`. It turns out that within a single receipt, some items may be sold with a discount (and the corresponding transaction will include the customer’s barcode number), while other items are sold without a discount — for these, `'NULL'` will be recorded in the receipt.

Thus, **not all transactions with `'NULL'` in the `DR_BCDisc` field are unidentifiable**; some can still be accounted for using the primary key that identifies the receipt. See a complete analysis of [how we are going to treat 'NULL's](null_barcodes_overview.md). 

## Unusual behaviour of certain barcodes

We also notice some outliers — **six barcodes account for more than half of all receipts** available in the dataset. Take a look at a full analysis of this fact, along with other [Unusual behavior](unusual_behavior_overview.md) of certain barcodes.

## Inconsistent data

The discount amount is represented as a positive value, which is then subtracted from the cost of the items in the transaction. Therefore, the total cost of goods sold in a single transaction is calculated as: quantity sold × retail price – discount amount (`DR_Kol × DR_CRoz – DR_SDisc`). Very rarely, **we observe negative discounts or negative quantities sold** in the data. We will also examine the difference between the wholesale price and the retail price. If there are product groups where the retail price is higher than the wholesale price, these may be items that should be excluded from our analysis. See [Inconsistent data](inconsistent_data_overview.md) overview for more details.

## Dataset for RFM analysis

Look at the [RFM Aggregated data](rfm_aggregated_data.md) section to explore share of transactions and receipts included in the analysis. Or proceed directly to explore [RFM Calculation Methodology](rfm_calculation_methodology.md). 