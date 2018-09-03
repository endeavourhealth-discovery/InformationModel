package org.endeavourhealth.im.common.models;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Transaction extends DbEntity<Transaction> {
    private Date dateTime;
    private String version;
    private String owner;
    private TransactionAction action;
    private List<TransactionComponent> componentList = new ArrayList();

    public Date getDateTime() {
        return dateTime;
    }

    public Transaction setDateTime(Date dateTime) {
        this.dateTime = dateTime;
        return this;
    }

    public String getVersion() {
        return version;
    }

    public Transaction setVersion(String version) {
        this.version = version;
        return this;
    }

    public String getOwner() {
        return owner;
    }

    public Transaction setOwner(String owner) {
        this.owner = owner;
        return this;
    }

    public TransactionAction getAction() {
        return action;
    }

    public Transaction setAction(TransactionAction action) {
        this.action = action;
        return this;
    }

    public List<TransactionComponent> getComponentList() {
        return componentList;
    }

    public Transaction setComponentList(List<TransactionComponent> componentList) {
        this.componentList = componentList;
        return this;
    }

    public Transaction addComponent(TransactionComponent component) {
        this.componentList.add(component);
        return this;
    }
}
