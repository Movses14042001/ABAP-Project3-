CLASS zcl_generate_purch_data_zbam1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GENERATE_PURCH_DATA_ZBAM1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA ipurchase TYPE TABLE OF zbam1_d_purch_a.
    DATA Iitem TYPE TABLE OF zbam1_d_item_a.
    DATA Iuser TYPE TABLE OF zbam1_d_user_a.
    DATA Iemp TYPE TABLE OF zbam1_d_emp_a.
    DATA Istatt TYPE TABLE OF ZBAM1_D_user_T.
    DATA empt TYPE TABLE OF ZBAM1_D_emp_T.

*   fill internal purchase table (ipurchase)
*    ipurchase = VALUE #(
*
*
*
*
*
*
*
*
*      (  purchase_id = '0000014'  item_id  = '070001'  user_id  = '000001' purchase_uuid = '02D5290E591A1EDA11115057FD946624' item_qount = '000000124'
*       total_price =  '750.00' currency_code = 'USD' purchase_status = 'a'
*        description = 'mv' created_by = 'MUSTERMANN' created_at = '20190612133945.5960060' last_changed_by = 'MUSTERFRAU' last_changed_at = '20190702105400.3647680' )
*      ( purchase_id = '00000001'  item_id  = '070005' user_id  = '000002' purchase_uuid = '02D1360E594C1EDA44115057FD946624' item_qount = '00000103'
*      total_price = '650.00' currency_code = 'USD'  purchase_status = 'a'
*        description = 'Enter your comments here'  created_by = 'MUSTERMANN' created_at = '20190613111129.2391370' last_changed_by = 'MUSTERMANN' last_changed_at = '20190711140753.1472620' )
*      ( purchase_id = '00000003'  item_id  = '000011' user_id  = '000003' purchase_uuid = '0315290E594C1EDA73115057FD946624'  item_qount = '00000200'
*       total_price = '800.00' currency_code = 'USD'  purchase_status = 'a'
*        description = 'Enter your comments here'  created_by = 'MUSTERFRAU' created_at = '20190613105654.4296640' last_changed_by = 'MUSTERFRAU' last_changed_at = '20190613111041.2251330' )
*    ).

*
    iitem = VALUE #(
    ( client = '100' item_id = '1' item_price = '80' currency_code = 'USD'  item_title = 'NoteBook' description = 'Computer For a education' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330'
item_company = 'Best Shop i.i.o.' )
    ( client = '100' item_id = '2' item_price = '120' currency_code = 'USD'  item_title = 'Book' description = 'Smart book for samrt people' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330'
item_company = 'New Market' )
    ( client = '100' item_id = '3' item_price = '10' currency_code = 'USD'  item_title = 'Bread' description = 'Bread from the best matrials' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330'
item_company = 'SUPPERGOODS.' )
    ( client = '100' item_id = '4' item_price = '44' currency_code = 'USD'  item_title = 'Notepad' description = 'Smart Writing Set ' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330'
item_company = 'Bets Goods' )
    ( client = '100' item_id = '5' item_price = '60' currency_code = 'USD'  item_title = 'Pen' description = 'Waterman Hemisphere Rollerball' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330'
item_company = 'Alenmarket i.i.o.' )
     ).
    iuser = VALUE #(
    ( client = '100'  user_id = '1' birth_of_date = '19890613105654.4296640'   email = 'TestUSer@gmail.com'  created_by = 'MovsesBagh' phone_number = '009884348311313' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at =
'20190613111041.2251330'  user_address = 'Cecilia Chapman711-2880 Nulla St.')
    ( client = '100' user_id = '2'  birth_of_date = '19890613105654.4296640'   email = 'TestUSer@gmail.com'  created_by = 'MovsesBagh' phone_number = '009884348311313' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at =
'20190613111041.2251330' user_address = 'Celeste Slater606-3727 Ullamcorper')
    ( client = '100' user_id = '3'  birth_of_date = '19890613105654.4296640'   email = 'TestUSer@gmail.com'  created_by = 'MovsesBagh' phone_number = '009884348311313' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at =
'20190613111041.2251330' user_address = 'Theodore Lowe')
    ( client = '100' user_id = '4'  birth_of_date = '19890613105654.4296640'   email = 'TestUSer@gmail.com'  created_by = 'MovsesBagh' phone_number = '009884348311313' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at =
'20190613111041.2251330' user_address = 'Ap #651-8679 Sodales' )
    ( client = '100' user_id = '5'  birth_of_date = '19890613105654.4296640'   email = 'TestUSer@gmail.com'  created_by = 'MovsesBagh' phone_number = '009884348311313' created_at = '19890613105654.4296640' last_changed_by = 'MovsesBagh' last_changed_at =
'20190613111041.2251330' user_address = 'Ap #696-3279 Viverra')
     ).






    Istatt  = VALUE #(

    ( client = '100'  user_id = '1' spras = 'EN'  first_name = 'Artem'  last_name = 'Hakobyan')
    ( client = '100' user_id = '2' spras = 'EN'  first_name = 'Leva'  last_name = 'Smernov')
    ( client = '100' user_id = '3' spras = 'EN'  first_name = 'Leon'  last_name = 'Arturov')
    ( client = '100' user_id = '4' spras = 'EN'  first_name = 'Sergey'  last_name = 'Gromov')
    ( client = '100' user_id = '5' spras = 'EN'  first_name = 'Aaram'  last_name = 'Gevorgyan')
    ).



    empt  = VALUE #(

        ( client = '100'  employee_id = '1' spras = 'EN'  first_name = 'Levon'  last_name = 'Hakobyan')
        ( client = '100' employee_id = '2' spras = 'EN'  first_name = 'Artem'  last_name = 'Smernov')
        ( client = '100' employee_id = '3' spras = 'EN'  first_name = 'Lyuba'  last_name = 'Smernova')
        ( client = '100' employee_id = '4' spras = 'EN'  first_name = 'Artur'  last_name = 'Gromov')
        ( client = '100' employee_id = '5' spras = 'EN'  first_name = 'Sergey'  last_name = 'Levonyan')
        ).


    Iemp = VALUE #(
       ( client = '100'  employee_id = '1' birth_of_date = '19890613105654.4296640'  currency_code = 'USD' email = 'TestUSer@gmail.com' price_per_order = '90' created_by = 'MovsesBagh' phone_number = '009884348311313' created_at = '19890613105654.4296640'
    last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330' )
       ( client = '100'  employee_id = '2' birth_of_date = '19990610105654.4296640'  currency_code = 'USD' email = 'User1231@gmail.com' price_per_order = '90' created_by = 'MovsesBagh' phone_number = '141414151313151' created_at = '19890613105654.4296640'
    last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330' )
       ( client = '100'  employee_id = '3' birth_of_date = '19591010105654.4296640'  currency_code = 'USD' email = 'GUI12131@gmail.com' price_per_order = '90' created_by = 'MovsesBagh' phone_number = '124151131542144' created_at = '19890613105654.4296640'
    last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330' )
     ( client = '100'  employee_id = '4' birth_of_date = '20060613105654.4296640'  currency_code = 'USD' email = 'MovsesBghd@gmail.com' price_per_order = '90' created_by = 'MovsesBagh' phone_number = '098141414831313' created_at = '19890613105654.4296640'
  last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330')
     ( client = '100'  employee_id = '5' birth_of_date = '20010613105654.4296640'  currency_code = 'USD' email = 'NewUser@gmail.com' price_per_order = '90' created_by = 'MovsesBagh' phone_number = '098141414147113' created_at = '19890613105654.4296640'
  last_changed_by = 'MovsesBagh' last_changed_at = '20190613111041.2251330' )
     ).


    DELETE FROM zbam1_d_user_a.
    DELETE FROM zbam1_d_user_t.

    DELETE FROM zbam1_d_emp_a.
    DELETE FROM zbam1_d_emp_t.

    DELETE FROM zbam1_d_item_a.



*   insert the new table entries
    INSERT zbam1_d_item_a  FROM TABLE  @iitem.
    INSERT zbam1_d_user_a  FROM TABLE  @iuser.
    INSERT zbam1_d_user_T  FROM TABLE  @Istatt.
    INSERT zbam1_d_emp_T   FROM TABLE  @empt.
    INSERT zbam1_d_emp_a   FROM TABLE  @iemp.

*   output the result as a console message
    out->write( |{ sy-dbcnt } purchase entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
