@EndUserText.label: 'Item interface view'
@AccessControl.authorizationCheck: #CHECK
define view entity ZBAM1_I_ITEM
  as select from zbam1_d_item_a as Item



  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency


{
  key item_id         as ItemId,
      item_title      as ItemTitle,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      item_price      as ItemPrice,
      currency_code   as CurrencyCode,
      item_company    as ItemCompany,
      description     as Description,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,

      /* Public associations */
      _Currency
}
