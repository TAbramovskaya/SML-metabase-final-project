The sales table contains the following columns (information on sales):

DR_Dat – purchase date (yyyy-mm-dd)

DR_Tim – purchase time (hh:mm:ss)

DR_NChk – receipt number

DR_NDoc – cash register document number

DR_apt – store ID (FK → shops)

DR_Kkm – cash register ID

DR_TDoc – type of document (in the data, this field is always equal to "Розничная реализация" ("retail sale.")

DR_TPay – payment type (18 = cashless, 15 = cash)

DR_CDrugs – product code

DR_NDrugs – product name

DR_Suppl – supplier

DR_Prod – manufacturer

DR_Kol – quantity sold

DR_CZak – purchase (wholesale) price

DR_CRoz – retail price

DR_SDisc – discount amount

DR_CDisc – discount code

DR_BCDisc – discount barcode

DR_TabEmpl – employee ID (FK → employee)

DR_Pos – item position in the receipt

DR_VZak – type of purchase (1 = regular, 2 = online order)

Participation in the loyalty program is determined by the discount card, and its 
barcode is recorded in the DR_BCDisc column. We will check the proportion of valid 
cards and, based on that, decide how to handle these transactions and whether they
should be excluded from the analysis. (invalid_cards_overview)

The discount amount is represented as a positive value, which is then subtracted 
from the cost of the items in the transaction. Therefore, the total cost of goods 
sold in a single transaction is calculated as:
quantity sold × retail price – discount amount (DR_Kol × DR_CRoz – DR_SDisc).
We will check whether all of these values are indeed positive. 

We will also examine the difference between the purchase price and the retail price. 
If there are product groups where the retail price is higher than the wholesale price, 
these may be items that should be excluded from our analysis. (inconsistent_data_overview)

Among the valid cards, a few stand out due to anomalous behavior. Specifically, they 
account for a very large number of transactions and/or transactions are conducted across 
a large number of different pharmacies. (outliers_overview)