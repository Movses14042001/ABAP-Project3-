@EndUserText.label: 'Employee interface view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define view entity ZBAM1_I_EMPLOYEE
  as select from zbam1_d_emp_a as Employee
  association [0..1] to ZBAM1_I_EMP_T  as _emptext on  _emptext.Spras = $session.system_language
                                                   and _emptext.EmployeeId = $projection.EmployeeId

  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
{



  key employee_id     as EmployeeId,
      email           as Email,
      birth_of_date   as BirthOfDate,
      @Semantics.amount.currencyCode : 'CurrencyCode'
      price_per_order as PricePerOrer,
      currency_code   as CurrencyCode,
      phone_number    as PhoneNumber,
      @Semantics.user.createdBy: true
      created_by      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at      as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,
      /* Public associations */
      _Currency,
      _emptext.LastName as PersonName
}
