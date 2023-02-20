@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Text interface view'


define view entity ZBAM1_I_USER_T as select from zbam1_d_user_t {
    @Semantics.language: true
    key spras as Spras,
    key user_id as UserId,
    @Semantics.text: true
    first_name as FirstName,
    @Semantics.text: true
    last_name as LastName
}
