@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase interface view'
define root view entity ZBAM1_I_PURCHASE
  as select from zbam1_d_purch_a as Purchase


  /* Associations */
  composition [0..*] of ZBAM1_I_ORDER as _Orrder
  association to ZBAM1_I_ITEM         as _Item     on $projection.ItemId = _Item.ItemId
  association to ZBAM1_I_USER         as _User     on $projection.UserId = _User.UserId
  association to I_Currency           as _Currency on $projection.CurrencyCode = _Currency.Currency
 
{

  key purchase_uuid   as PurchaseUuid,
      purchase_id     as PurchaseId,
      item_id         as ItemId,
      user_id         as UserId,
      item_qount      as ItemQount,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      total_price     as TotalPrice,
      currency_code   as CurrencyCode,
      purchase_status as PurchaseStatus,
      purchase_date   as PurchaseDate,
      delivery_date   as Deliverdate,
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
      _Orrder,
      _Item,
      _User,
      _Currency,
      _Item.ItemPrice
}
