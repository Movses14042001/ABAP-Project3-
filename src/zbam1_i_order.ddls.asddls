@EndUserText.label: 'Order interface view'
@AccessControl.authorizationCheck: #CHECK
define view entity ZBAM1_I_ORDER as select from zbam1_d_order_a as Orrder
 

  /* Associations */
  association to parent ZBAM1_I_PURCHASE  as _Purchase   on $projection.PurchaseUuid = _Purchase.PurchaseUuid
  association to ZBAM1_I_EMPLOYEE  as _Employee   on $projection.EmployeeId = _Employee.EmployeeId
  association to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
 


{

    key order_uuid as OrderUuid,
    purchase_uuid as PurchaseUuid,
    order_id as OrderId,
    employee_id as EmployeeId,
    order_address as OrderAddress,
//    @Semantics.amount.currencyCode : 'CurrencyCode'
//    order_fee as OrderFee,
//    @Semantics.amount.currencyCode : 'CurrencyCode'
//    total_price as TotalPrice,
    currency_code as CurrencyCode,
    description as Description,
//    order_status as OrderStatus,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,


 /* Public associations */
      _Purchase,
      _Employee,
      _Currency,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      _Employee.PricePerOrer
 }
   
