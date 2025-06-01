DECLARE
    l_url     VARCHAR2(2000);
    l_app     NUMBER := v('APP_ID');
    l_session NUMBER := v('APP_SESSION');
BEGIN
    :p1_refno := dbms_random.string('x', 4)
                 || s_tran_reference.nextval; --(sys_guid()) ;

    l_url := apex_util.prepare_url(p_url => 'f?p='
                                            || l_app
                                            || ':2:'
                                            || l_session
                                            || '::NO::', p_url_charset => 'UTF-8', p_checksum_type => 'SESSION');

    :p1_url := 'https://r0mlg8oc0e1zzbk-dbdroplet01.adb.us-ashburn-1.oraclecloudapps.com' || l_url; ---replace with your url base
END;
