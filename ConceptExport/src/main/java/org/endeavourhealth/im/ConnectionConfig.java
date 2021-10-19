package org.endeavourhealth.im;

public class ConnectionConfig {
    private String url;
    private String username;
    private String password;

    public String getUrl() {
        return url;
    }

    public ConnectionConfig setUrl(String url) {
        this.url = url;
        return this;
    }

    public String getUsername() {
        return username;
    }

    public ConnectionConfig setUsername(String username) {
        this.username = username;
        return this;
    }

    public String getPassword() {
        return password;
    }

    public ConnectionConfig setPassword(String password) {
        this.password = password;
        return this;
    }
}
