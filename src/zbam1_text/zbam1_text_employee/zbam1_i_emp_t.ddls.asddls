@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Text interface view'



define view entity ZBAM1_I_EMP_T as select from zbam1_d_emp_t {
    @Semantics.language: true
    key spras as Spras,
    key employee_id as EmployeeId,
    @Semantics.text: true
    first_name as FirstName,
    @Semantics.text: true
    last_name as LastName
}
