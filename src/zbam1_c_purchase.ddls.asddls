@EndUserText.label: 'Purchase projection view'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['PurchaseId']

define root view entity ZBAM1_C_PURCHASE
  as projection on ZBAM1_I_PURCHASE as Purchase
{
  key PurchaseUuid,
     
      @EndUserText.label: 'Purchase'
      PurchaseId,
      
      @Consumption.valueHelpDefinition: [{entity : { name : 'ZBAM1_I_ITEM' , element : 'ItemId' } }]
      @ObjectModel.text.element: ['ItemTitle']
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Item'
      ItemId,
       @Search.defaultSearchElement: true
      _Item.ItemTitle as ItemTitle,
      
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @EndUserText.label: 'Item Price'
      ItemPrice,
      
      @EndUserText.label: 'Purchase Date'
      PurchaseDate,
      
      @EndUserText.label: 'Delivery Date'
      Deliverdate,
      
      @Consumption.valueHelpDefinition: [{entity : { name : 'ZBAM1_I_USER' , element : 'UserId' } }]
      @ObjectModel.text.element: ['PersonName']
      @Search.defaultSearchElement: true
      @EndUserText.label: 'User'
      UserId,
      
      ItemQount,
      @EndUserText.label: 'Total Price'
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      
      @Consumption.valueHelpDefinition: [{entity : { name : 'I_Currency' , element : 'Currency' } }]
      CurrencyCode,
      
      @EndUserText.label: 'Status'
      PurchaseStatus,
      
      Description,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      
      /* Associations */
      _Currency,
      _Item,
      
      _Orrder : redirected to composition child ZBAM1_C_ORDER,
      
      _User.PersonName

}
