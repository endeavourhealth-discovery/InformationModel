package org.endeavourhealth.im.common.models;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.endeavourhealth.common.cache.ObjectMapperPool;

public class TransactionComponent extends DbEntity<TransactionComponent> {
    private TransactionTable table;
    private String data;

    public TransactionTable getTable() {
        return table;
    }

    public TransactionComponent setTable(TransactionTable table) {
        this.table = table;
        return this;
    }

    public String getData() {
        return data;
    }

    public TransactionComponent setData(DbEntity entity) throws JsonProcessingException {
        this.data = ObjectMapperPool.getInstance().writeValueAsString(entity);
        return this;
    }
}
