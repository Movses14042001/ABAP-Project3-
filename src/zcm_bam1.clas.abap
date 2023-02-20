CLASS zcm_bam1 DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_abap_behv_message.


    CONSTANTS:
      BEGIN OF date_interval,
        msgid TYPE symsgid VALUE 'ZCL_BAM1_MESSAGE',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'PURCHASEDATE',
        attr2 TYPE scx_attrname VALUE 'DELIVERYDATE',
        attr3 TYPE scx_attrname VALUE 'ORDERID',
        attr4 TYPE scx_attrname VALUE 'PURCHASESID',
      END OF date_interval .
    CONSTANTS:
      BEGIN OF begin_date_before_system_date,
        msgid TYPE symsgid VALUE 'ZCL_BAM1_MESSAGE',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'PURCHASEDATE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF begin_date_before_system_date .
    CONSTANTS:
      BEGIN OF item_unknown,
        msgid TYPE symsgid VALUE 'ZCL_BAM1_MESSAGE',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'ITEMID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF item_unknown .
    CONSTANTS:
      BEGIN OF user_unknown,
        msgid TYPE symsgid VALUE 'ZCL_BAM1_MESSAGE',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'USERID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF user_unknown .
    CONSTANTS:
      BEGIN OF employee_unknown,
        msgid TYPE symsgid VALUE 'ZCL_BAM1_MESSAGE',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'EMPLOYEEID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF employee_unknown .
    CONSTANTS:
      BEGIN OF unauthorized,
        msgid TYPE symsgid VALUE 'ZCL_BAM1_MESSAGE',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF unauthorized .

    METHODS constructor
      IMPORTING
        severity     TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid       LIKE if_t100_message=>t100key OPTIONAL
        previous     TYPE REF TO cx_root OPTIONAL
        purchasedate TYPE zbam1_order_date OPTIONAL
        deliverydate TYPE zbam1_delivery_date OPTIONAL
        purchaseid   TYPE zbam1_purchase_id OPTIONAL
        itemid       TYPE zbam1_item_id OPTIONAL
        userid       TYPE zbam1_user_id OPTIONAL
        orderid      TYPE zbam1_order_id OPTIONAL
        employeeid   TYPE zbam1_employee_id OPTIONAL.



    DATA   employeeid    TYPE zbam1_employee_id READ-ONLY.
    DATA   purchasedate     TYPE zbam1_order_date READ-ONLY.
    DATA   deliverydate  TYPE zbam1_delivery_date READ-ONLY.
    DATA   purchaseid    TYPE zbam1_purchase_id READ-ONLY.
    DATA   itemid        TYPE zbam1_item_id READ-ONLY.
    DATA   userid        TYPE zbam1_user_id READ-ONLY.
    DATA   orderid        TYPE zbam1_order_id READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCM_BAM1 IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.



    me->if_abap_behv_message~m_severity = severity.

    me->purchasedate    = purchasedate.
    me->deliverydate = deliverydate.
    me->purchaseid   = |{ purchaseid ALPHA = OUT }|.
    me->orderid      = |{ orderid ALPHA = OUT }|.
    me->userid       = |{ userid ALPHA = OUT }|.
    me->itemid       = |{ itemid ALPHA = OUT }|.
    me->employeeid   = |{ employeeid ALPHA = OUT }|.
  ENDMETHOD.
ENDCLASS.
