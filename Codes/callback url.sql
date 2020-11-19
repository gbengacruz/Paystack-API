DECLARE
    l_url varchar2(2000);
    l_app number := v('APP_ID');
    l_session number := v('APP_SESSION');
BEGIN
     :P1_REFNO  := DBMS_RANDOM.string('x', 4)|| S_TRAN_REFERENCE.nextval ; --(sys_guid()) ;
        
            l_url := APEX_UTIL.PREPARE_URL(
        p_url => 'f?p=' || l_app || ':2:'||l_session||'::NO::',
        p_url_charset => 'UTF-8',
        p_checksum_type => 'SESSION');
        
        :P1_URL := 'https://r0mlg8oc0e1zzbk-dbdroplet01.adb.us-ashburn-1.oraclecloudapps.com'||l_url;
END;