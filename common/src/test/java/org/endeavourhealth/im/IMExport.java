package org.endeavourhealth.im;

import org.endeavourhealth.im.dal.InformationModelDAL;
import org.endeavourhealth.im.dal.InformationModelJDBCDAL;

public class IMExport {

    public static void main(String argv[]) throws Exception {
        InformationModelDAL db = new InformationModelJDBCDAL();
        db.generateRuntimeFiles();
    }
}
