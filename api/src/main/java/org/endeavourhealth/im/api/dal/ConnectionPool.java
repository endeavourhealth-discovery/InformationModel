package org.endeavourhealth.im.api.dal;

public class ConnectionPool {
    public static final ConnectionCache InformationModel = new ConnectionCache("database");
    public static final ConnectionCache Snomed = new ConnectionCache("snomed");
}
