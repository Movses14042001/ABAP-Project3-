@EndUserText.label: 'User interface view'
@AccessControl.authorizationCheck: #CHECK

define view entity ZBAM1_I_USER as select from zbam1_d_user_a as User
association [0..1] to ZBAM1_I_USER_T  as _usertext on  _usertext.Spras = $session.system_language
                                                   and _usertext.UserId = $projection.UserId
{
    key user_id as UserId,
    phone_number as PhoneNumber,
    email as Email,
    birth_of_date as BirthOfDate,
    user_address as UserAddress,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    
    _usertext.LastName as PersonName
}
