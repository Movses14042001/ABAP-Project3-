CLASS lhc_Purchase DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF purchase_status,
        Open     TYPE c LENGTH     1 VALUE  'O',
        Acsepted TYPE c LENGTH     1 VALUE  'A',
        Rejected TYPE c LENGTH     1 VALUE  'X',
      END OF purchase_status.

    METHODS recalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION Purchase~recalcTotalPrice.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Purchase~calculateTotalPrice.

    METHODS calculatePurchaseId FOR DETERMINE ON SAVE
      IMPORTING keys FOR Purchase~calculatePurchaseId.

    METHODS validateItem FOR VALIDATE ON SAVE
      IMPORTING keys FOR Purchase~validateItem.

    METHODS valideateUser FOR VALIDATE ON SAVE
      IMPORTING keys FOR Purchase~valideateUser.

    METHODS rejectPurch FOR MODIFY
      IMPORTING keys FOR ACTION Purchase~rejectPurch RESULT result.

    METHODS acseptPurch FOR MODIFY
      IMPORTING keys FOR ACTION Purchase~acseptPurch RESULT result.

    METHODS setInitialStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Purchase~setInitialStatus.

    METHODS get_instance_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Purchase RESULT result.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Purchase RESULT result.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Purchase~validateDates.


    METHODS is_update_granted IMPORTING has_before_image      TYPE abap_bool
                                        purchase_status       TYPE zbam1_purch_status
                              RETURNING VALUE(update_granted) TYPE abap_bool.

    METHODS is_delete_granted IMPORTING has_before_image      TYPE abap_bool
                                        purchase_status       TYPE zbam1_purch_status
                              RETURNING VALUE(delete_granted) TYPE abap_bool.

    METHODS is_create_granted RETURNING VALUE(create_granted) TYPE abap_bool.

ENDCLASS.

CLASS lhc_Purchase IMPLEMENTATION.


  METHOD calculatePurchaseId.

    " check if purchaseID is already filled
    READ ENTITIES OF  zbam1_i_purchase IN LOCAL MODE
      ENTITY Purchase
        FIELDS ( PurchaseId ) WITH CORRESPONDING #( keys )
      RESULT DATA(purchases).

    " remove lines where purchaseID is already filled.
    DELETE purchases WHERE PurchaseId IS NOT INITIAL.

    " anything left ?
    CHECK purchases IS NOT INITIAL.

    " Select max purchase ID
    SELECT SINGLE
        FROM  zbam1_d_purch_a
        FIELDS MAX( purchase_id ) AS PurchaseID
        INTO @DATA(max_purchaseid).

    " Set the purchase ID
    MODIFY ENTITIES OF zbam1_i_purchase IN LOCAL MODE
    ENTITY Purchase
      UPDATE
        FROM VALUE #( FOR Purchase IN Purchases INDEX INTO i (
          %tky              = Purchase-%tky
          PurchaseId          = max_purchaseid + i
          %control-PurchaseId = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateItem.
    " Read relevant purchase instance data
    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
      ENTITY purchase
        FIELDS ( itemID ) WITH CORRESPONDING #( keys )
      RESULT DATA(purchases).

    DATA items TYPE SORTED TABLE OF zbam1_d_item_a WITH UNIQUE KEY item_id.

    " Optimization of DB select: extract distinct non-initial item IDs
    items = CORRESPONDING #( purchases DISCARDING DUPLICATES MAPPING item_id = itemID EXCEPT * ).
    DELETE items WHERE item_id IS INITIAL.
    IF items IS NOT INITIAL.
      " Check if item ID exist
      SELECT FROM zbam1_d_item_a FIELDS item_id
        FOR ALL ENTRIES IN @items
        WHERE item_id = @items-item_id
        INTO TABLE @DATA(items_db).
    ENDIF.


    LOOP AT purchases INTO DATA(purchase).
      " Clear state messages that might exist
      APPEND VALUE #(  %tky        = purchase-%tky
                       %state_area = 'VALIDATE_ITEM' )
        TO reported-purchase.

      IF purchase-itemID IS INITIAL OR NOT line_exists( items_db[ item_id = purchase-ItemId ] ).
        APPEND VALUE #(  %tky = purchase-%tky ) TO failed-purchase.

        APPEND VALUE #(  %tky        = purchase-%tky
                         %state_area = 'VALIDATE_ITEM'
                         %msg        = NEW zcm_bam1(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_bam1=>item_unknown
                                           itemid = purchase-ItemID )
                         %element-ItemID = if_abap_behv=>mk-on )
          TO reported-purchase.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD valideateUser.
    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
        ENTITY Purchase
          FIELDS ( UserId ) WITH CORRESPONDING #( keys )
        RESULT DATA(Purchases).

    DATA Users TYPE SORTED TABLE OF zbam1_d_user_a WITH UNIQUE KEY user_id.

    " Optimization of DB select: extract distinct non-initial user IDs
    Users = CORRESPONDING #( purchases DISCARDING DUPLICATES MAPPING user_id = UserId EXCEPT * ).
    DELETE users WHERE user_id IS INITIAL.
    IF users IS NOT INITIAL.
      " Check if user ID exist
      SELECT FROM zbam1_d_user_a FIELDS user_id
        FOR ALL ENTRIES IN @Users
        WHERE user_id = @users-user_id
        INTO TABLE @DATA(users_db).
    ENDIF.


    LOOP AT purchases INTO DATA(purchase).

      APPEND VALUE #(  %tky        = purchase-%tky
                       %state_area = 'VALIDATE_USER' )
        TO reported-Purchase.

      IF purchase-UserId IS INITIAL OR NOT line_exists( users_db[ user_id = purchase-UserId ] ).
        APPEND VALUE #(  %tky = purchase-%tky ) TO failed-purchase.

        APPEND VALUE #(  %tky        = purchase-%tky
                         %state_area = 'VALIDATE_USER'
                         %msg        = NEW zcm_bam1(
                                           severity   = if_abap_behv_message=>severity-error
                                           textid     = zcm_bam1=>user_unknown
                                           userid = purchase-UserID )
                         %element-UserID = if_abap_behv=>mk-on )
          TO reported-Purchase.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD acseptpurch.

    MODIFY ENTITIES OF zbam1_i_purchase IN LOCAL MODE
    ENTITY Purchase
     UPDATE
      FIELDS ( PurchaseStatus )
      WITH VALUE #( FOR key IN keys
                        ( %tky       = key-%tky
                         PurchaseStatus = purchase_status-acsepted ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
      ENTITY Purchase
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(Purchases).

    result = VALUE #( FOR purchase IN purchases
                        ( %tky   = purchase-%tky
                          %param = purchase ) ).

  ENDMETHOD.

  METHOD rejectpurch.

    MODIFY ENTITIES OF zbam1_i_purchase IN LOCAL MODE
    ENTITY Purchase
     UPDATE
      FIELDS ( PurchaseStatus )
      WITH VALUE #( FOR key IN keys
                        ( %tky       = key-%tky
                         PurchaseStatus = purchase_status-rejected ) )
      FAILED failed
      REPORTED reported.

    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
      ENTITY Purchase
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(Purchases).

    result = VALUE #( FOR purchase IN purchases
                        ( %tky   = purchase-%tky
                          %param = purchase ) ).


  ENDMETHOD.

  METHOD setinitialstatus.
    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
         ENTITY Purchase
           FIELDS ( PurchaseStatus ) WITH CORRESPONDING #( keys )
         RESULT DATA(Purchases).

    " Remove all purchase instance data with defined status
    DELETE Purchases WHERE PurchaseStatus IS NOT INITIAL.
    CHECK Purchases IS NOT INITIAL.


    MODIFY ENTITIES OF zbam1_i_purchase IN LOCAL MODE
    ENTITY Purchase
      UPDATE
        FIELDS ( PurchaseStatus )
        WITH VALUE #( FOR purchase IN Purchases
                      ( %tky        = purchase-%tky
                        PurchaseStatus = purchase_status-Open ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
      ENTITY Purchase
        FIELDS ( PurchaseStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(Purchases)
      FAILED failed.

    result =
      VALUE #(
        FOR Purchase IN Purchases
          LET is_accepted =   COND #( WHEN Purchase-PurchaseStatus = Purchase_status-acsepted
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_rejected =   COND #( WHEN Purchase-PurchaseStatus = Purchase_status-rejected
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                = Purchase-%tky
              %action-acseptPurch = is_accepted
              %action-rejectPurch = is_rejected
             ) ).

  ENDMETHOD.

  METHOD validatedates.

    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
       ENTITY Purchase
         FIELDS ( PurchaseID PurchaseDate DeliverDate ) WITH CORRESPONDING #( keys )
       RESULT DATA(Purchases).

    LOOP AT Purchases INTO DATA(Purchase).

      APPEND VALUE #(  %tky        = Purchase-%tky
                       %state_area = 'VALIDATE_DATES' )
        TO reported-Purchase.

      IF Purchase-DeliverDate < Purchase-PurchaseDate.
        APPEND VALUE #( %tky = Purchase-%tky ) TO failed-Purchase.
        APPEND VALUE #( %tky               = Purchase-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcm_bam1(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_bam1=>date_interval
                                                 purchasedate   = Purchase-PurchaseDate
                                                 deliverydate   = Purchase-DeliverDate
                                                 purchaseid     = Purchase-PurchaseId )
                        %element-PurchaseDate      = if_abap_behv=>mk-on
                        %element-DeliverDate   = if_abap_behv=>mk-on ) TO reported-Purchase.

      ELSEIF Purchase-PurchaseDate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky               = Purchase-%tky ) TO failed-Purchase.
        APPEND VALUE #( %tky               = Purchase-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %msg               = NEW zcm_bam1(
                                                 severity  = if_abap_behv_message=>severity-error
                                                 textid    = zcm_bam1=>begin_date_before_system_date
                                                 purchasedate = Purchase-PurchaseDate )
                        %element-PurchaseDate = if_abap_behv=>mk-on ) TO reported-Purchase.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD calculateTotalPrice.
    MODIFY ENTITIES OF zbam1_i_purchase IN LOCAL MODE
        ENTITY Purchase
          EXECUTE recalcTotalPrice
          FROM CORRESPONDING #( keys )
        REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).
  ENDMETHOD.

  METHOD get_authorizations.

    DATA: has_before_image    TYPE abap_bool,
          is_update_requested TYPE abap_bool,
          is_delete_requested TYPE abap_bool,
          update_granted      TYPE abap_bool,
          delete_granted      TYPE abap_bool.

    DATA: failed_Purchase LIKE LINE OF failed-Purchase.

    " Read the existing purchases
    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
      ENTITY Purchase
        FIELDS ( PurchaseStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(Purchases)
      FAILED failed.

    CHECK Purchases IS NOT INITIAL.


    SELECT FROM zbam1_d_purch_a
      FIELDS Purchase_uuid, purchase_status
      FOR ALL ENTRIES IN @Purchases
      WHERE purchase_uuid EQ @Purchases-PurchaseUUID
      ORDER BY PRIMARY KEY
      INTO TABLE @DATA(Purchases_before_image).

    is_update_requested = COND #( WHEN requested_authorizations-%update              = if_abap_behv=>mk-on OR
                                       requested_authorizations-%action-acseptpurch  = if_abap_behv=>mk-on OR
                                       requested_authorizations-%action-rejectpurch  = if_abap_behv=>mk-on OR
                                       requested_authorizations-%action-Prepare      = if_abap_behv=>mk-on OR
                                       requested_authorizations-%action-Edit         = if_abap_behv=>mk-on OR
                                       requested_authorizations-%assoc-_Orrder        = if_abap_behv=>mk-on
                                  THEN abap_true ELSE abap_false ).

    is_delete_requested = COND #( WHEN requested_authorizations-%delete = if_abap_behv=>mk-on
                                    THEN abap_true ELSE abap_false ).

    LOOP AT Purchases INTO DATA(Purchase).
      update_granted = delete_granted = abap_false.

      READ TABLE Purchases_before_image INTO DATA(Purchase_before_image)
           WITH KEY purchase_uuid = purchase-PurchaseUuid BINARY SEARCH.
      has_before_image = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).

      IF is_update_requested = abap_true.
        " Edit of an existing record -> check update authorization
        IF has_before_image = abap_true.
          update_granted = is_update_granted( has_before_image = has_before_image  purchase_status = Purchase_before_image-purchase_status ).
          IF update_granted = abap_false.
            APPEND VALUE #( %tky        = purchase-%tky
                            %msg        = NEW zcm_bam1( severity = if_abap_behv_message=>severity-error
                                                            textid   = zcm_bam1=>unauthorized )
                          ) TO reported-purchase.
          ENDIF.
          " Creation of a new record -> check create authorization
        ELSE.
          update_granted = is_create_granted( ).
          IF update_granted = abap_false.
            APPEND VALUE #( %tky        = Purchase-%tky
                            %msg        = NEW zcm_bam1( severity = if_abap_behv_message=>severity-error
                                                            textid   = zcm_bam1=>unauthorized )
                          ) TO reported-Purchase.
          ENDIF.
        ENDIF.
      ENDIF.

      IF is_delete_requested = abap_true.
        delete_granted = is_delete_granted( has_before_image = has_before_image  purchase_status = Purchase_before_image-purchase_status ).
        IF delete_granted = abap_false.
          APPEND VALUE #( %tky        = purchase-%tky
                          %msg        = NEW zcm_bam1( severity = if_abap_behv_message=>severity-error
                                                          textid   = zcm_bam1=>unauthorized )
                        ) TO reported-purchase.
        ENDIF.
      ENDIF.

      APPEND VALUE #( %tky = purchase-%tky

                      %update              = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                      %action-acseptpurch  = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                      %action-rejectpurch  = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                      %action-Prepare      = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                      %action-Edit         = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                      %assoc-_Orrder       = COND #( WHEN update_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )

                      %delete              = COND #( WHEN delete_granted = abap_true THEN if_abap_behv=>auth-allowed ELSE if_abap_behv=>auth-unauthorized )
                    )
        TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD is_create_granted.

    AUTHORITY-CHECK OBJECT 'ZBAM1AUT'
        ID 'PURCHSTAT' DUMMY
        ID 'ACTVT' FIELD '01'.
    create_granted = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).
    " Simulate full access - for testing purposes only! Needs to be removed for a productive implementation.
    create_granted = abap_true.
  ENDMETHOD.

  METHOD is_delete_granted.
    IF has_before_image = abap_true.
      AUTHORITY-CHECK OBJECT 'ZBAM1AUT'
        ID 'PURCHSTAT' FIELD purchase_status
        ID 'ACTVT' FIELD '06'.
    ELSE.
      AUTHORITY-CHECK OBJECT 'ZBAM1AUT'
        ID 'PURCHSTAT' DUMMY
        ID 'ACTVT' FIELD '06'.
    ENDIF.
    delete_granted = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).

    " Simulate full access - for testing purposes only! Needs to be removed for a productive implementation.
    delete_granted = abap_true.

  ENDMETHOD.

  METHOD is_update_granted.
    IF has_before_image = abap_true.
      AUTHORITY-CHECK OBJECT 'ZBAM1AUT'
        ID 'PURCHSTAT' FIELD purchase_status
        ID 'ACTVT' FIELD '02'.
    ELSE.
      AUTHORITY-CHECK OBJECT 'ZBAM1AUT'
        ID 'PURCHSTAT' DUMMY
        ID 'ACTVT' FIELD '02'.
    ENDIF.
    update_granted = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).

    " Simulate full access - for testing purposes only! Needs to be removed for a productive implementation.
    update_granted = abap_true.
  ENDMETHOD.

  METHOD recalcTotalPrice.
    TYPES: BEGIN OF ty_amount_per_currencycode,
             amount        TYPE zbam1_total_price,
             currency_code TYPE zbam1_currency_code,
           END OF ty_amount_per_currencycode.

    DATA: amount_per_currencycode TYPE STANDARD TABLE OF ty_amount_per_currencycode.

    " Read all relevant purchase instances.
    READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
         ENTITY purchase
            FIELDS ( ItemPrice ItemQount CurrencyCode )
            WITH CORRESPONDING #( keys )
         RESULT DATA(purchases).

    DELETE purchases WHERE CurrencyCode IS INITIAL.

    LOOP AT purchases ASSIGNING FIELD-SYMBOL(<purchase>).
      " Set the start for the calculation by adding the order fee.
      amount_per_currencycode = VALUE #( ( amount        = <purchase>-ItemPrice * <purchase>-ItemQount
                                           currency_code = <purchase>-CurrencyCode ) ).

      " Read all associated orders and add them to the total price.
      READ ENTITIES OF zbam1_i_purchase IN LOCAL MODE
        ENTITY purchase BY \_Orrder
          FIELDS ( PricePerOrer CurrencyCode )
        WITH VALUE #( ( %tky = <purchase>-%tky ) )
        RESULT DATA(orders).

      LOOP AT orders INTO DATA(order) WHERE CurrencyCode IS NOT INITIAL.
        COLLECT VALUE ty_amount_per_currencycode( amount        = order-PricePerOrer
                                                  currency_code = order-CurrencyCode ) INTO amount_per_currencycode.
      ENDLOOP.

      CLEAR <purchase>-TotalPrice.
      LOOP AT amount_per_currencycode INTO DATA(single_amount_per_currencycode).
        " If needed do a Currency Conversion
        IF single_amount_per_currencycode-currency_code = <purchase>-CurrencyCode.
          <purchase>-TotalPrice += single_amount_per_currencycode-amount.
        ELSE.
          /dmo/cl_flight_amdp=>convert_currency(
             EXPORTING
               iv_amount                   =  single_amount_per_currencycode-amount
               iv_currency_code_source     =  single_amount_per_currencycode-currency_code
               iv_currency_code_target     =  <purchase>-CurrencyCode
               iv_exchange_rate_date       =  cl_abap_context_info=>get_system_date( )
             IMPORTING
               ev_amount                   = DATA(total_Orrder_price_per_curr)
            ).
          <purchase>-TotalPrice += total_Orrder_price_per_curr.
        ENDIF.
      ENDLOOP.
    ENDLOOP.



    " write back the modified total_price of purchases
    MODIFY ENTITIES OF zbam1_i_purchase IN LOCAL MODE
      ENTITY purchase
        UPDATE FIELDS ( TotalPrice )
        WITH CORRESPONDING #( purchases ).
  ENDMETHOD.


ENDCLASS.
