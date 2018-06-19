package org.endeavourhealth.im.api.logic;

import org.endeavourhealth.im.api.dal.MessageDAL;
import org.endeavourhealth.im.api.dal.MessageJDBCDAL;
import org.endeavourhealth.im.common.models.*;

import java.util.Map;

public class MessageLogic {
    /*
    private MessageDAL dal;

    public MessageLogic() {
        this.dal = new MessageJDBCDAL();
    }

    protected MessageLogic(MessageDAL dal) {
        this.dal = dal;
    }

    public boolean isValidAndMapped(Message message) throws Exception {

        getOrCreateMessageConcepts(message);

        getOrCreateMessageAndContents(message);

        if (allMappingsExist(message))
            return true;

        checkAndCreateMessageMappingTask(message);
        return false;
    }

    private void getOrCreateMessageConcepts(Message message) throws Exception {
        ConceptLogic conceptLogic = new ConceptLogic();
        AttributeModelLogic attributeModelLogic = new AttributeModelLogic();

        conceptLogic.validateAndCreateDraft(message.getSourceSystem());
        conceptLogic.validateAndCreateDraft(message.getMessageType());

        for (MessageResource res: message.getResources()) {
            attributeModelLogic.validateAndCreateDraftWithTask(res.getResourceType());
            for (MessageResourceField field: res.getFields()) {
                conceptLogic.validateAndCreateDraft(field.getScheme());
            }
        }
    }

    private void getOrCreateMessageAndContents(Message message) throws Exception {
        getOrCreateMessage(message);

        for (MessageResource res : message.getResources()) {
            getOrCreateMessageResource(message.getId(), res);

            for (MessageResourceField field : res.getFields())
                getOrCreateMessageResourceField(res.getId(), field);
        }
    }

    private boolean getOrCreateMessage(Message message) throws Exception {
        if (message.getId() != null)
            return false;

        Long messageId = dal.getMessageId(
            message.getSourceSystem().getId(),
            message.getMessageType().getId(),
            message.getVersion()
        );

        if (messageId != null) {
            message.setId(messageId);
            return false;
        } else {
            dal.saveMessage(message);
            return true;
        }
    }

    private boolean getOrCreateMessageResource(Long messageId, MessageResource messageResource) throws Exception {
        if (messageResource.getId() != null)
            return false;

        Long resourceId = dal.getResourceId(messageId, messageResource.getResourceType().getId());

        if (resourceId != null) {
            messageResource.setId(resourceId);
            return false;
        } else {
            dal.saveMessageResource(messageId, messageResource);
            return true;
        }
    }

    private boolean getOrCreateMessageResourceField(Long resourceId, MessageResourceField field) throws Exception {
        if (field.getId() != null)
            return false;

        Long fieldId = dal.getFieldId(resourceId, field.getName());
        if (fieldId != null) {
            field.setId(fieldId);
            return false;
        } else {
            dal.saveMessageResourceField(resourceId, field);
            return true;
        }
    }

    private boolean allMappingsExist(Message message) {
        MappingLogic mappingLogic = new MappingLogic();
        for(MessageResource messageResource : message.getResources()) {
            Map<Long, Long> fieldConceptMap = mappingLogic.getResourceFieldMaps(messageResource.getId());
            for (MessageResourceField field: messageResource.getFields()) {
                if (!fieldConceptMap.containsKey(field.getId()))
                    return false;
            }
        }

        return true;
    }

    private void checkAndCreateMessageMappingTask(Message message) throws Exception {
        TaskLogic taskLogic = new TaskLogic();
        Long taskId = taskLogic.getTaskIdByTypeAndResourceId(TaskType.MESSAGE_MAPPINGS, message.getId());

        if (taskId == null) {
            taskLogic.createTask("Incomplete map", TaskType.MESSAGE_MAPPINGS, message.getId());
        }
    }
    */
}
