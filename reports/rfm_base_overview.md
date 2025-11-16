 We will compile a table containing the receipts that will serve as the basis for the RFM analysis. To do this, we will first merge all missing NULL-transactions into their corresponding receipts, then filter out the barcodes we identified as outliers as well as any receipts whose barcode remained NULL after all processing steps.

We can check what proportion of receipts will ultimately form the basis for the analysis.

The RFM analysis will be based on 18.5% of all receipts available in the dataset. This corresponds to 3 886 receipts, representing purchases made by 2 285 customers.
![](images/excluded_and_regular_receipts_proportion.png)

Compared to the initial dataset, the analysis will be based on 10 256 transactions, which corresponds to slightly less than 22.7% of the entire dataset.
![](images/excluded_and_regular_transactions_proportion.png)