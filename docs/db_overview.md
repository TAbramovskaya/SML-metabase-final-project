The analysis will be conducted based on the **`sales`** table.

The sales table contains the following columns (information on sales):

- **`DR_Dat`** – purchase date (`date`, yyyy-mm-dd)
- **`DR_Tim`** – purchase time (`time`, hh:mm:ss)
- **`DR_NChk`** – receipt number (`integer`)
- **`DR_NDoc`** – cash register document number (`integer`)
- **`DR_apt`** – store ID number (`integer`)
- **`DR_Kkm`** – cash register ID number (`integer`)
- **`DR_TDoc`** – type of document (`varchar`, in the data, this field is always equal to "Розничная реализация" which means "retail sale")
- **`DR_TPay`** – payment type (`integer`, 18 = cashless, 15 = cash)
- **`DR_CDrugs`** – product code (`integer`)
- **`DR_NDrugs`** – product name (`varchar`)
- **`DR_Suppl`** – supplier (`varchar`)
- **`DR_Prod`** – manufacturer (`varchar`)
- **`DR_Kol`** – quantity sold (`double precision`)
- **`DR_CZak`** – wholesale price (`double precision`)
- **`DR_CRoz`** – retail price (`double precision`)
- **`DR_SDisc`** – discount amount (`double precision`)
- **`DR_CDisc`** – discount code (`text`)
- **`DR_BCDisc`** – discount barcode (`text`)
- **`DR_TabEmpl`** – employee ID (`integer`)
- **`DR_Pos`** – item position in the receipt (`integer`)
- **`DR_VZak`** – type of purchase (`integer`, 1 = regular, 2 = online order)

The primary key in the sales table is the combination of fields `(DR_Dat, DR_Tim, DR_NChk, DR_NDoc, DR_apt, DR_Kkm, DR_TabEmpl, DR_Pos)`. 

When a customer with a discount card (`DR_BCDisc`) makes a purchase, multiple entries are added to the table — one for each unique product name (defined by `DR_CDrugs` and `DR_NDrugs`) — all sharing the same key tuple values except for the last one, `DR_Pos`, which indicates the sequential number of the item within the receipt.

The discount amount is applied once to the total cost of the specified item for the entire quantity purchased, that is, the cost of goods within a transaction including the discount is calculated as **`DR_CRoz × DR_Kol – DR_SDisc`** (retail price×quantity sold - discount amount).



