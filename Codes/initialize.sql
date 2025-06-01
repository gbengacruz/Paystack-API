DECLARE
    l_clob   CLOB;
    p_body   CLOB;
    l_buffer VARCHAR2(32767);
    l_amount NUMBER;
    l_offset NUMBER;
BEGIN
    apex_web_service.g_request_headers(1).name := 'Authorization';
    apex_web_service.g_request_headers(1).value := 'Bearer ***************************';
    apex_web_service.g_request_headers(2).name := 'Content-Type';
    apex_web_service.g_request_headers(2).value := 'application/json';
    p_body := '{"reference": "'
              || :p1_refno
              || '", "amount": '
              || :p1_amount
              || ', "email": "'
              || :p1_email
              || '","callback_url":"'
              || :p1_url
              || '" }';

    l_clob := apex_web_service.make_rest_request(p_url => 'https://api.paystack.co/transaction/initialize', p_http_method => 'POST', p_body => p_body /*,
p_wallet_path => 'file:c:\wallet',
p_wallet_pwd => 'password'*/);

    l_amount := 32000;
    l_offset := 1;
    BEGIN
        FOR i IN (
            SELECT
                authorization_url,
                access_code,
                reference
            FROM
                XMLTABLE ( '/json/row'
                        PASSING apex_json.to_xmltype('['
                                                     || l_clob
                                                     || ']')
                    COLUMNS
                        authorization_url VARCHAR2(500) PATH '/row/data/authorization_url',
                        access_code VARCHAR2(500) PATH '/row/data/access_code',
                        reference VARCHAR2(500) PATH '/row/data/reference'
                )
        ) LOOP
            :p1_pay_url := i.authorization_url;
-----log transaction with a procedure 
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'Payment gateway not available', p_display_location => apex_error.c_on_error_page);
    END;

END;
