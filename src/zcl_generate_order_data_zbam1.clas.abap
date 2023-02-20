CLASS zcl_generate_order_data_zbam1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GENERATE_ORDER_DATA_ZBAM1 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA iorder TYPE TABLE OF zbam1_d_order_a.

*   fill internal travel table (iorder)
    iorder = VALUE #(
      ( order_uuid = '02D5290E594C1EDA93815057FD946624' order_id = '00000022' employee_id = '070001' purchase_uuid = '02D5290E591A1EDA11115057FD946624'  order_fee = '60.00'
       total_price =  '750.00' currency_code = 'USD' order_address  = '113 east new york ave brighton beach nj'
        description = 'mv' order_status = '1' created_by = 'MUSTERMANN' created_at = '20190612133945.5960060' last_changed_by = 'MUSTERFRAU' last_changed_at = '20190702105400.3647680' )
      ( order_uuid = '02D5290E594C1EDA93815C50CD7AE62A' order_id = '00000106' employee_id = '070005' purchase_uuid = '02D6660E594C1EDA11115057FD946624' order_fee = '17.00'
      total_price = '650.00' currency_code = 'USD' order_address  = '113 east new york ave brighton beach nj'
        description = 'Enter your comments here' order_status = '1' created_by = 'MUSTERMANN' created_at = '20190613111129.2391370' last_changed_by = 'MUSTERMANN' last_changed_at = '20190711140753.1472620' )
      ( order_uuid = '02D5290E594C1EDA93858EED2DA2EB0B' order_id = '00000103' employee_id = '000011' purchase_uuid = '02D5290E594C1EDA73115057FD946624'  order_fee = '17.00'
       total_price = '800.00' currency_code = 'AFN' order_address  = '113 east new york ave brighton beach nj'
        description = 'Enter your comments here' order_status = '1' created_by = 'MUSTERFRAU' created_at = '20190613105654.4296640' last_changed_by = 'MUSTERFRAU' last_changed_at = '20190613111041.2251330' )
    ).

*   delete existing entries in the database table
    DELETE FROM zbam1_d_order_a.

*   insert the new table entries
    INSERT zbam1_d_order_a FROM TABLE @iorder.

*   output the result as a console message
    out->write( |{ sy-dbcnt }order entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
