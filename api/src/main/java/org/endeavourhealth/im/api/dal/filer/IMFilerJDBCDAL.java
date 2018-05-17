package org.endeavourhealth.im.api.dal.filer;

import org.endeavourhealth.im.api.dal.ConnectionPool;
import org.endeavourhealth.im.api.models.Transaction;
import org.endeavourhealth.im.api.models.TransactionAction;
import org.endeavourhealth.im.api.models.TransactionComponent;
import org.endeavourhealth.im.api.models.TransactionTable;
import org.endeavourhealth.im.common.models.DbEntity;
import sun.reflect.generics.reflectiveObjects.NotImplementedException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IMFilerJDBCDAL implements IMFilerDAL {

    /**
     * Stores a transaction and its associated components in the transaction tables.
     *
     * @param transaction The transaction to store
     * @return An ordered list of generated db ids <pre>[transactionId, transactionComponentId, transactionComponentId...]</pre>
     */
    @Override
    public List<Long> store(Transaction transaction) throws Exception {
        List<Long> dbIds = new ArrayList<>();

        transaction.setId(storeTransaction(transaction));
        dbIds.add(transaction.getId());
        int order = 0;
        for (TransactionComponent transactionComponent: transaction.getComponentList()) {
            transactionComponent.setId(storeTransactionComponent(transaction.getId(), order++, transactionComponent));
            dbIds.add(transactionComponent.getId());
        }

        return dbIds;
    }

    /**
     * Applies a list of transactions, by id, and their associated components to the database
     * @param transactionIds List of transaction Ids to apply
     * @return A map of <pre>Transaction Component Id, Data Object Id</pre>
     */
    @Override
    public Map<Long, Long> apply(List<Long> transactionIds) throws Exception {
        for (Long id: transactionIds) {
            Transaction transaction = getTransaction(id);
            apply(transaction);
        }
        return null;
    }

    /**
     * Applies a transactions and its associated components to the database
     * @param transaction The transaction to apply
     * @return A map of <pre>Transaction Component Id, Data Object Id</pre>
     */
    @Override
    public Map<Long, Long> apply(Transaction transaction) throws Exception {
        Map<Long, Long> idMap = new HashMap<>();
        for(TransactionComponent transactionComponent: transaction.getComponentList()) {
            Long id = applyTransactionComponent(transaction, transactionComponent);
            idMap.put(transactionComponent.getId(), id);
        }

        return idMap;
    }

    @Override
    public Long storeAndApply(String owner, TransactionAction action, TransactionTable table, DbEntity entity) throws Exception {

        Transaction transaction = new Transaction()
                .setOwner(owner)
                .setAction(action)
                .addComponent(
                        new TransactionComponent()
                                .setTable(table)
                                .setData(entity)
                );

        List<Long> dbIds = this.store(transaction);

        Map<Long, Long> result = this.apply(transaction);

        return result.get(dbIds.get(1));
    }

    private Transaction getTransaction(Long id) {
        return null;
    }

    private Long storeTransaction(Transaction transaction) throws Exception {
        String sql = "INSERT INTO transaction " +
                "(owner, action) " +
                "VALUES " +
                "(?, ?) ";
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, transaction.getOwner());
            statement.setByte(2, transaction.getAction().getValue());
            statement.executeUpdate();
            ResultSet rs = statement.getGeneratedKeys();
            rs.next();
            return rs.getLong(1);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }

    private Long storeTransactionComponent(Long transactionId, Integer order, TransactionComponent transactionComponent) throws Exception {
        String sql = "INSERT INTO transaction_component " +
                "(`transaction_id`, `order`, `table_id`, `data`) " +
                "VALUES " +
                "(?, ?, ?, ?) ";
        Connection conn = ConnectionPool.InformationModel.pop();
        try (PreparedStatement statement = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, transactionId);
            statement.setInt(2, order);
            statement.setByte(3, transactionComponent.getTable().getValue());
            statement.setString(4, transactionComponent.getData());
            statement.executeUpdate();
            ResultSet rs = statement.getGeneratedKeys();
            rs.next();
            return rs.getLong(1);
        } finally {
            ConnectionPool.InformationModel.push(conn);
        }
    }


    private Long applyTransactionComponent(Transaction transaction, TransactionComponent transactionComponent) throws Exception {
        switch (transactionComponent.getTable()) {
            case CONCEPT:
                return applyTransactionComponent(transaction, transactionComponent, new ComponentFilerForConcepts());
            case MESSAGE:
                return applyTransactionComponent(transaction, transactionComponent, new ComponentFilerForMessages());
            case TASK:
                return applyTransactionComponent(transaction, transactionComponent, new ComponentFilerForTasks());
            case ATTRIBUTE_MODEL:
                return applyTransactionComponent(transaction, transactionComponent, new ComponentFilerForAttributeModels());
            case TERM_MAPPING:
                return applyTransactionComponent(transaction, transactionComponent, new ComponentFilerForTermMappings());
            default:
                throw new IllegalArgumentException("No component filer defined for the given type");
        }
    }

    private Long applyTransactionComponent(Transaction transaction, TransactionComponent transactionComponent, ComponentFiler componentFiler) throws Exception {
        switch (transaction.getAction()) {
            case CREATE:
                return componentFiler.create(transactionComponent);
            case UPDATE:
                componentFiler.update(transactionComponent);
            case DELETE:
                componentFiler.delete(transactionComponent);
        }
        return null;
    }
}
