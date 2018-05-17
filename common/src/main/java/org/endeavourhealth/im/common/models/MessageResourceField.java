package org.endeavourhealth.im.common.models;

public class MessageResourceField extends DbEntity<MessageResourceField> {
    private String name;
    private String value;
    private ConceptReference scheme = new ConceptReference();

    public String getName() {
        return name;
    }

    public MessageResourceField setName(String name) {
        this.name = name;
        return this;
    }

    public String getValue() {
        return value;
    }

    public MessageResourceField setValue(String value) {
        this.value = value;
        return this;
    }

    public ConceptReference getScheme() {
        return scheme;
    }

    public MessageResourceField setScheme(ConceptReference scheme) {
        this.scheme = scheme;
        return this;
    }
}
