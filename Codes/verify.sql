DECLARE
    l_clob   CLOB;
    p_body   CLOB;
    l_buffer VARCHAR2(32767);
    l_amount NUMBER;
    l_offset NUMBER;
-- v_tran v_transactions%ROWTYPE;
-- v_err v_99_ssu_log%ROWTYPE;
BEGIN
    apex_web_service.g_request_headers(1).name := 'Authorization';
    apex_web_service.g_request_headers(1).value := 'Bearer ********************';
    apex_web_service.g_request_headers(2).name := 'Content-Type';
    apex_web_service.g_request_headers(2).value := 'application/json';
    l_clob := apex_web_service.make_rest_request(p_url => 'https://api.paystack.co/transaction/verify/' || :p1_refno, p_http_method => 'GET'
    , p_body => p_body);

    l_amount := 32000;
    l_offset := 1;
    BEGIN
        FOR i IN (
            SELECT
                amount,
                status,
                reference
            FROM
                XMLTABLE ( '/json/row'
                        PASSING apex_json.to_xmltype('['
                                                     || l_clob
                                                     || ']')
                    COLUMNS
                        amount VARCHAR2(500) PATH '/row/data/amount',
                        status VARCHAR2(500) PATH '/row/data/status',
                        reference VARCHAR2(500) PATH '/row/data/reference'
                )
        ) LOOP
            IF i.status = 'success' THEN
                :p2_sta := i.status;
                :p2_refno := i.reference;
                :p2_amt := to_char(i.amount / 100, '999G999G999G999G990D00');
----- update transaction  status with a procedure
            ELSE
                :p2_sta_x := i.status;
                :p2_refno_x := i.reference;
                :p2_amt_x := to_char(i.amount / 100, '999G999G999G999G990D00');
            END IF;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'Payment gateway not available', p_display_location => apex_error.c_on_error_page);
    END;

END;
