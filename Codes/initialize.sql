declare
l_clob clob;
p_body Clob;
l_buffer varchar2(32767);
l_amount number;
l_offset number;
begin

apex_web_service.g_request_headers(1).name := 'Authorization';
apex_web_service.g_request_headers(1).value := 'Bearer ***************************';
apex_web_service.g_request_headers(2).name := 'Content-Type';
apex_web_service.g_request_headers(2).value := 'application/json';
p_body := '{"reference": "'||:P1_REFNO||'", "amount": '||:P1_AMOUNT||', "email": "'||:P1_EMAIL||'","callback_url":"'||:P1_URL||'" }' ;
l_clob := apex_web_service.make_rest_request(
p_url => 'https://api.paystack.co/transaction/initialize',
p_http_method => 'POST',
p_body => p_body /*,
p_wallet_path => 'file:c:\wallet',
p_wallet_pwd => 'password'*/);
l_amount := 32000;
l_offset := 1;

begin

For i In (SELECT authorization_url, access_code, reference
FROM XMLTABLE(
'/json/row'
PASSING APEX_JSON.to_xmltype('['||l_clob||']')
COLUMNS
authorization_url VARCHAR2(500) PATH '/row/data/authorization_url',
access_code VARCHAR2(500) PATH '/row/data/access_code',
reference VARCHAR2(500) PATH '/row/data/reference')) loop
:P1_PAY_URL := i.authorization_url ;
-----log transaction with a procedure 
end loop;
exception
when others then
apex_error.add_error (
p_message => 'Payment gateway not available',
p_display_location => apex_error.c_on_error_page );
end;
END;
