package org.endeavourhealth.im.api.dal.filer;

import org.endeavourhealth.im.api.models.Transaction;
import org.endeavourhealth.im.api.models.TransactionAction;
import org.endeavourhealth.im.api.models.TransactionTable;
import org.endeavourhealth.im.common.models.DbEntity;

import java.util.List;
import java.util.Map;

public interface IMFilerDAL {
    List<Long> store(Transaction transaction) throws Exception;
    Map<Long, Long> apply(List<Long> transactionId) throws Exception;
    Map<Long, Long> apply(Transaction transaction) throws Exception;
    Long storeAndApply(String owner, TransactionAction action, TransactionTable table, DbEntity entity) throws Exception;
}
