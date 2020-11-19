declare
l_clob clob;
p_body Clob;
l_buffer varchar2(32767);
l_amount number;
l_offset number;
-- v_tran v_transactions%ROWTYPE;
-- v_err v_99_ssu_log%ROWTYPE;
begin

apex_web_service.g_request_headers(1).name := 'Authorization';
apex_web_service.g_request_headers(1).value := 'Bearer ********************';
apex_web_service.g_request_headers(2).name := 'Content-Type';
apex_web_service.g_request_headers(2).value := 'application/json';
l_clob := apex_web_service.make_rest_request(
p_url => 'https://api.paystack.co/transaction/verify/'||:P1_REFNO,
p_http_method => 'GET',
p_body => p_body);
l_amount := 32000;
l_offset := 1;
begin
For i In (SELECT amount, status, reference
FROM XMLTABLE(
'/json/row'
PASSING APEX_JSON.to_xmltype('['||l_clob||']')
COLUMNS
amount VARCHAR2(500) PATH '/row/data/amount',
status VARCHAR2(500) PATH '/row/data/status',
reference VARCHAR2(500) PATH '/row/data/reference')) loop
IF i.status = 'success' THEN
:P2_STA := i.status ;
:P2_REFNO := i.reference;
:P2_AMT := TO_CHAR(i.amount/100, '999G999G999G999G990D00');
--v_tran.PAYMENT_REFERENCE := i.reference;
-- PK_TRANSACTIONS.PC_TRANSACTIONS_PYMT(v_tran,v_err);
ELSE
:P2_STA_X := i.status ;
:P2_REFNO_X := i.reference;
:P2_AMT_X := TO_CHAR(i.amount/100, '999G999G999G999G990D00');
END IF;
end loop;
exception
when others then
apex_error.add_error (
p_message => 'Payment gateway not available',
p_display_location => apex_error.c_on_error_page );
end;
END;
