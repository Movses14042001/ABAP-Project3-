@EndUserText.label: 'Order projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZBAM1_C_ORDER as projection on ZBAM1_I_ORDER as Orrder
 {
    key OrderUuid,
    
    PurchaseUuid,
    
    @Search.defaultSearchElement: true
     @EndUserText.label: 'Order'
    OrderId,
    
    @Consumption.valueHelpDefinition: [{entity : { name : 'ZBAM1_I_EMPLOYEE' , element : 'EmployeeID' } }]
    @ObjectModel.text.element: ['PersonName']
    @Search.defaultSearchElement: true
     @EndUserText.label: 'Employee'
    EmployeeId,
    
    @EndUserText.label: 'Order Fee'
    @Semantics.amount.currencyCode: 'CurrencyCode'
    PricePerOrer,
    
     @EndUserText.label: 'Address'
    OrderAddress,
    
     @Consumption.valueHelpDefinition: [{entity : { name : 'I_Currency' , element : 'Currency' } }]
    CurrencyCode,
    
    Description,
    
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    /* Associations */
    _Currency,
    _Employee,
    
    _Employee.PersonName,
    
    _Purchase : redirected to parent ZBAM1_C_PURCHASE
}
