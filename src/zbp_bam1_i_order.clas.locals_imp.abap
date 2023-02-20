CLASS lhc_Orrder DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.



    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Orrder~calculateTotalPrice.


    METHODS calculateOrderId FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Orrder~calculateOrderId.

    METHODS valideateEmployee FOR VALIDATE ON SAVE
      IMPORTING keys FOR Orrder~valideateEmployee.




ENDCLASS.

CLASS lhc_Orrder IMPLEMENTATION.

  METHOD calculateorderid.

DATA max_orderid TYPE zbam1_order_id.
    DATA update TYPE TABLE FOR UPDATE zbam1_i_purchase\\Orrder.


    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
    ENTITY Orrder BY \_Purchase
      FIELDS ( PurchaseUUID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(Purchases).


    LOOP AT Purchases INTO DATA(Purchase).
      READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
        ENTITY Purchase BY \_Orrder
          FIELDS ( OrderID )
        WITH VALUE #( ( %tky = Purchase-%tky ) )
        RESULT DATA(Orders).

      max_orderid ='000000'.
      LOOP AT Orders INTO DATA(Order).
        IF order-OrderID > max_orderid.
          max_orderid = order-OrderID.
        ENDIF.
      ENDLOOP.


      LOOP AT Orders INTO order WHERE OrderId IS INITIAL.
        max_orderid += 1.
        APPEND VALUE #( %tky      = order-%tky
                        OrderId = max_orderid
                      ) TO update.
      ENDLOOP.
    ENDLOOP.


    MODIFY ENTITIES OF zbam1_i_purchase IN LOCAL MODE
    ENTITY Orrder
      UPDATE FIELDS ( OrderId ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD calculatetotalprice.

    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
    ENTITY Orrder BY \_Purchase
      FIELDS ( PurchaseUUID )
      WITH CORRESPONDING #( keys )
      RESULT DATA(Purchases)
      FAILED DATA(read_failed).

    " Trigger calculation of the total price
    MODIFY ENTITIES OF zbam1_i_purchase IN LOCAL MODE
    ENTITY Purchase
      EXECUTE recalcTotalPrice
      FROM CORRESPONDING #( Purchases )
    REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).
  ENDMETHOD.

  METHOD valideateEmployee.
  READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
        ENTITY Orrder
          FIELDS ( EmployeeId ) WITH CORRESPONDING #( keys )
        RESULT DATA(Orders).

    DATA employees TYPE SORTED TABLE OF zbam1_d_emp_a WITH UNIQUE KEY employee_id.

    " Optimization of DB select: extract distinct non-initial employee IDs
    employees = CORRESPONDING #( Orders DISCARDING DUPLICATES MAPPING employee_id = EmployeeId EXCEPT * ).
    DELETE employees WHERE employee_id IS INITIAL.
    IF employees IS NOT INITIAL.
      " Check if employee ID exist
      SELECT FROM zbam1_d_emp_a FIELDS employee_id
        FOR ALL ENTRIES IN @employees
        WHERE employee_id = @employees-employee_id
        INTO TABLE @DATA(emp_db).
    ENDIF.


    LOOP AT Orders INTO DATA(Order).

      APPEND VALUE #(  %tky        = Order-%tky
                       %state_area = 'VALIDATE_EMPLOYEE' )
        TO reported-orrder.

      IF Order-employeeid IS INITIAL OR NOT line_exists( emp_db[ employee_id = order-employeeid ] ).
        APPEND VALUE #(  %tky = Order-%tky ) TO failed-orrder.

        APPEND VALUE #(  %tky        = Order-%tky
                         %state_area = 'VALIDATE_EMPLOYEE'
                         %msg        = NEW zcm_bam1(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_bam1=>employee_unknown
                                           employeeid = Order-employeeid )
                         %element-employeeid = if_abap_behv=>mk-on )
          TO reported-Orrder.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
