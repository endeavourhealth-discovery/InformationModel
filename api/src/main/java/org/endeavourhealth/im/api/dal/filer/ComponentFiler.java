package org.endeavourhealth.im.api.dal.filer;

import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.api.models.TransactionComponent;
import org.endeavourhealth.im.common.models.DbEntity;

import java.util.Collections;
import java.util.List;

public abstract class ComponentFiler {
    public abstract Long create(TransactionComponent transactionComponent) throws Exception;
    public abstract void update(TransactionComponent transactionComponent) throws Exception;
    public abstract void delete(TransactionComponent transactionComponent) throws Exception;

    String getParamList(List<String> fieldList) {
        List<String> paramList = Collections.nCopies(fieldList.size(), "?");
        return String.join(",", paramList);
    }

    String getUpdateList(List<String> fields) {
        return String.join("=? ,", fields) + "=? ";
    }


    DbEntity getDbEntity(TransactionComponent transactionComponent) throws java.io.IOException {
        return ObjectMapperPool.getInstance().readValue(transactionComponent.getData(), DbEntity.class);
    }
}
