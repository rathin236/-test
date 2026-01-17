{% docs data_entity_company %}

`DataEntityCompanySK` is the surrogate key corresponding to the Cooke company. 
See `ERPx_MFDataEntityCompany` for the list of company names.

| DataEntityCompanySK | CompanyID | CompanyName |
| ------------------- | ----------| ----------- |
| 1                   | TNS       | True North Salmon Co |
| 3                   | OTOO      | Ocean To Ocean |
| 4                   | CASL      | Cooke Scotland |
| 5                   | ISI       | Icicle Seafoods |
| 6                   | TFC       | The Fish Company |
| 7                   | WFC       | Wanchese Fish Company |
| 8                   | CSPI      | Cooke Seafood Panama |
| 9                   | TNSF      | True North Seafood |

{% enddocs %}


{% docs order_status %}

The status of the order. See `ERPx_SOOrderStatus` for more details.

| OrderStatusSK | OrderStatusName |
| ------------- | ----------- |
| 0             | Pending |
| 1             | New |
| 2             | Released |
| 3             | In Process |
| 4             | Staging |
| 5             | Loading |
| 6             | Shipping |
| 7             | Approved |
| 8             | Ready To Post |
| 9             | Posted |
| 10            | Void |

{% enddocs %}

{% docs item_type %}

The type of the item. See `ERPx_IMItemType` for more details.

| ItemTypeSK | Description |
| -----------| ----------- |
| 1          | Sales Inventory |
| 2          | Discontinued |
| 3          | Kit |
| 4          | Misc Charges |
| 5          | Services |
| 6          | Flat Fee |
| 7          | Tax |

{% enddocs %}

{% docs order_type %}

The type of the order. See `ERPx_SOOrderType` for more details.

| OrderTypeSK | OrderTypeName |
| ------------| ----------- |
| 1           | Quote |
| 2           | Order |
| 3           | Invoice |
| 4           | Return |
| 5           | Price Adjustment |
| 6           | Directed Transfer |

{% enddocs %}

{% docs fivetran_deleted %}

Boolean - `TRUE`, or `FALSE`
Fivetran does a soft delete - to ensure you only have records that current records (not deleted),
add the following to your sql statement:

```sql
where coalesce(_fivetran_deleted, false) = false
```

{% enddocs %}

{% docs mf_currency %}

| CurrencySK | CurrencyID | CurrencyDescription |
| ---------- | ---------- | ------------------- |
| 1          | Z-AUD      | Australian Dollars  |
| 2          | GBP        | British Pound Sterling |       
| 3          | CAD        | Canadian dollars    |
| 4          | Z-C$       | Canadian Dollars    |
| 5          | Z-EURO     | European Euro       |
| 6          | Z-NZD      | New Zealand Dollars |     
| 7          | Z-UK       | Pound               |      
| 8          | Z-SGD      | Singapore Dollar    |      
| 9          | Z-SA       | South African Rand  |      
| 10         | USD        | US Dollars          |       
| 11         | Z-US$      | US Dollars          |      
| 12         | Z-EUR      | European Euro       |      
| 13         | JPY        | Japanese Yen        |      
| 14         | NOK        | Norwegian Kroner    |      
| 15         | CNY        | China Yuan Renminbi |      
| 16         | CNH        | China Yuan Renminbi |      
| 17         | ARS        | Argentine Peso      |      
| 18         | CLP        | Pesos Chilenos      |      
| 19         | AUD        | Australian Dollars  |      

{% enddocs %}