package org.endeavourhealth.im.models;

public class Version {
    private int major = 1;
    private Integer minor = 0;
    private Integer build = 0;

    public int getMajor() {
        return major;
    }

    public Version setMajor(int major) {
        this.major = major;
        return this;
    }

    public int getMinor() {
        return minor;
    }

    public Version setMinor(int minor) {
        this.minor = minor;
        return this;
    }

    public int getBuild() {
        return build;
    }

    public Version setBuild(int build) {
        this.build = build;
        return this;
    }

    public String toString() {
        String result = Integer.toString(this.major);

        if (this.minor != null)
            result += "." + this.minor.toString();
        else
            result += ".0";

        if (this.build != null)
            result += "." + this.build.toString();
        else
            result += ".0";

        return result;
    }

    public Version parse(String version) {
        if (version == null || version.isEmpty()) {
            this.major = this.minor = this.build = 0;
            return this;
        }

        String parts[] = version.split("\\.");
        if (parts.length == 0 || parts.length > 3)
            throw new IllegalArgumentException("Invalid version number [" + version + "] != n[.n[.n]]");

        this.major = Integer.parseInt(parts[0]);
        if (parts.length > 1)
            this.minor = Integer.parseInt(parts[1]);
        else
            this.minor = null;

        if (parts.length > 1)
            this.build = Integer.parseInt(parts[2]);
        else
            this.build = null;

        return this;
    }

    public static Version fromString(String version) {
        return new Version().parse(version);
    }
}
