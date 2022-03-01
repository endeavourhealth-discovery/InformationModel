package org.endeavourhealth.im.imv2receiver;

import org.endeavourhealth.common.config.ConfigManagerException;

import java.io.IOException;
import java.sql.SQLException;

public class IM2Receiver {
    public static void main(String[] argv) throws ConfigManagerException, SQLException, IOException {
        new SetImporter().getSetFromIM2();
    }
}
