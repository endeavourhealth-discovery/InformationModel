package org.endeavourhealth.im.api.logic;

import com.fasterxml.jackson.databind.JsonNode;
import org.endeavourhealth.common.cache.ObjectMapperPool;
import org.endeavourhealth.im.api.dal.ConceptDAL;
import org.endeavourhealth.im.api.dal.ConceptJDBCDAL;
import org.endeavourhealth.im.common.models.ConceptRule;
import org.endeavourhealth.im.common.models.ConceptRuleSet;
import org.endeavourhealth.im.common.models.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ConceptLogic {
    private ConceptDAL dal;

    public ConceptLogic() {
        this.dal = new ConceptJDBCDAL();
    }
    protected ConceptLogic(ConceptDAL dal) {
        this.dal = dal;
    }

    public ConceptSummaryList getMRU() throws Exception {
        return dal.getMRU();
    }

    public ConceptSummaryList search(String searchTerm) throws Exception {
        return dal.search(searchTerm);
    }

    public Concept get(Long id) throws Exception {
        return this.dal.get(id);
    }

    public Concept get(String context) throws Exception {
        return this.dal.getConceptByContext(context);
    }

    public ConceptBundle getBundle(Long id) throws Exception {
        return new ConceptBundle()
            .setConcept(this.dal.get(id))
            .setAttributes(this.getAttributes(id))
            .setRelated(this.getRelated(id))
            .setRuleSets(this.getRuleSets(id));
    }

    public List<Attribute> getAttributes(Long id) throws Exception {
        return this.dal.getAttributes(id);
    }

    public List<RelatedConcept> getRelated(Long id) throws Exception {
        List<RelatedConcept> result = new ArrayList<>();
        result.addAll(this.getRelatedTargets(id));
        result.addAll(this.getRelatedSources(id));
        return result;
    }

    public List<RelatedConcept> getRelatedTargets(Long id) throws Exception {
        return this.dal.getRelatedTargets(id);
    }

    public List<RelatedConcept> getRelatedSources(Long id) throws Exception {
        return this.dal.getRelatedSources(id);
    }

    public List<ConceptReference> getRelationships() throws Exception {
        return this.dal.getRelationships();
    }

    public List<ConceptRuleSet> getRuleSets(Long id) throws Exception {
        return this.dal.getConceptRuleSets(id, null);
    }

    public Long save(Concept concept) throws Exception {
        concept.setId(this.dal.save(concept));
        return concept.getId();
    }

    public Long save(RelatedConcept relatedConcept) throws Exception {
        relatedConcept.setId(this.dal.save(relatedConcept));
        return relatedConcept.getId();
    }

    public void save(ConceptBundle conceptBundle) throws Exception {
        if (conceptBundle.getConcept().getAutoTemplate())
            generateTemplate(conceptBundle);

        Long conceptId = this.dal.save(conceptBundle.getConcept());

        for(Attribute att: conceptBundle.getAttributes()) {
            if (att.getConceptId() == null)
                att.setConceptId(conceptId);

            if (att.getId() == null) {
                // Dynamic created attribute concept
                System.out.println("Need to save attribute!");
            }
            this.dal.save(att);
        }

        for(RelatedConcept rel : conceptBundle.getRelated()) {
            if (rel.getTargetId() == null)
                rel.setTargetId(conceptId);
            else if (rel.getSourceId() == null)
                rel.setSourceId(conceptId);
            this.dal.save(rel);
        }

        for(Long attId: conceptBundle.getDeletedAttributeIds())
            this.dal.deleteAttribute(attId);

        for(Long relId: conceptBundle.getDeletedRelatedIds())
            this.dal.deleteRelationship(relId);
    }

    private void generateTemplate(ConceptBundle conceptBundle) {
        StringBuilder sb = new StringBuilder();

        for(Attribute att: conceptBundle.getAttributes()) {
            Long attributeType = att.getConceptId();
            if (ConceptBaseType.NUMERIC.getId().equals(attributeType)) {
                sb.append("    <label for='att_"+att.getAttributeId()+"'>"+att.getAttribute().getFullName()+"</label>" +
                    "    <div class='input-group'>" +
                    "      <input class='form-control' id='conceptType' type='number' value='{{getAttributeValue(" + att.getAttributeId() + ")}}' name='att_"+att.getAttributeId()+"' readonly>" +
                    "    </div>");
            } else if (ConceptBaseType.DATE_TIME.getId().equals(attributeType)) {

            } else if (ConceptBaseType.CODE.getId().equals(attributeType)) {

            } else if (ConceptBaseType.TEXT.getId().equals(attributeType)) {

            } else if (ConceptBaseType.BOOLEAN.getId().equals(attributeType)) {

            } else if (ConceptBaseType.CODEABLE_CONCEPT.getId().equals(attributeType)) {

            } else {

            }
        }
        conceptBundle.getConcept().setTemplate(sb.toString());
    }

    public CalculationResult calculate(String json) throws Exception {
        JsonNode object = ObjectMapperPool.getInstance().readTree(json);

        String resourceType = object.has("resourceType") ? object.get("resourceType").textValue() : null;

        CalculationResult result = new CalculationResult();

        ConceptReference rootConcept = new ConceptReference().setId(1L).setText("Concept");

        return calculateChild(resourceType, object, rootConcept, result);  // Call with root "Concept"
    }

    private CalculationResult calculateChild(String resourceType, JsonNode object, ConceptReference concept, CalculationResult result) throws Exception {
        List<ConceptRuleSet> ruleSets = this.dal.getConceptRuleSets(concept.getId(), resourceType);
        result.getStackTrace().add(concept);

        // If no rulesets then we're at the bottom so have found the concept
        if (ruleSets == null || ruleSets.isEmpty()) {
            result.setResult(this.dal.get(concept.getId()));
            result.setStatus(0);    // OK
            return result;
        }

        // Otherwise, find matching child
        for(ConceptRuleSet ruleSet: ruleSets) {
            if (meetsCriteria(object, ruleSet))
                return calculateChild(resourceType, object, ruleSet.getTarget(), result);
        }

        Concept c = this.dal.get(concept.getId());
        System.out.println("Its a new/unknown type of " + c.getFullName() + " (" + c.getContext() + ")");
        result.setResult(c);
        result.setStatus(1); // Create draft concept/task
        return null;    // TODO: Create draft concept or task
    }

    private Boolean meetsCriteria(JsonNode object, ConceptRuleSet ruleSet) {
        for (ConceptRule rule: ruleSet.getRules()) {
           if(testRule(object, rule) == false)
               return false;
        }
        return true;
    }

    private Boolean testRule(JsonNode object, ConceptRule rule) {
        try {
            String value = getNodeValue(object, rule.getProperty());
            System.out.println(value);

            return compare(value, rule.getValue(), rule.getComparator());
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    private String getNodeValue(JsonNode object, String path) {
        JsonNode find = object;
        String[] nodes = path.split("\\.");

        for (String node : nodes) {
            find = find.get(node);

            if (find == null)
                throw new IllegalArgumentException("Path not found ["+path+"]");
        }

        return find.textValue();
    }

    private Boolean compare(String val1, String val2, String comparator) {
        if ("=".equals(comparator))
            return val1.equals(val2);
        if ("<".equals(comparator))
            return val1.compareTo(val2) < 0;
        if ("<=".equals(comparator))
            return val1.compareTo(val2) <= 0;
        if (">".equals(comparator))
            return val1.compareTo(val2) > 0;
        if (">=".equals(comparator))
            return val1.compareTo(val2) >= 0;
        if ("in".equals(comparator)) {
            List<String> vals = Arrays.asList(val2.split(","));
            return vals.contains(val1);
        }

        throw new IllegalArgumentException("Unknown comparator ["+comparator+"]");
    }
    /*

















    public boolean validateAndCreateDraft(ConceptReference ref) throws Exception {
        return validateAndCreateDraft(ref, false);
    }

    public boolean validateAndCreateDraftWithTask(ConceptReference ref) throws Exception {
        return validateAndCreateDraft(ref, true);
    }

    private boolean validateAndCreateDraft(ConceptReference ref, boolean createTaskIfInvalid) throws Exception {
        if (ref == null || ref.getId() != null || ref.getContext() == null || ref.getContext().isEmpty())
            return true;

        Concept concept = dal.getConceptByContext(ref.getContext());
        if (concept != null) {
            ref.setId(concept.getId());
            return true;
        } else {
            Long id = dal.createDraftConcept(ref.getContext());
            if (createTaskIfInvalid)
                new TaskLogic().createTask("(AUTO) - " + ref.getContext(), TaskType.ATTRIBUTE_MODEL, id);
            ref.setId(id);
            return false;
        }
    }

    public List<ConceptSummary> getSummaries(Integer page) throws Exception {
        return this.dal.getSummaries(page);
    }









    public List<ConceptSummary> search(String criteria) throws Exception {
        return this.dal.search(criteria);
    }



    public List<ConceptSummary> getAttributeOf(Long id) throws Exception {
        return this.dal.getAttributeOf(id);
    }


    public Long addAttribute(Long conceptId, Long attributeId) throws Exception {
        return this.dal.saveAttribute(conceptId, attributeId);
    }

    public Long addRelationship(Long sourceId, Long targetId, Long relationshipId) throws Exception {
        return this.dal.saveRelationship(sourceId, targetId, relationshipId);
    }
*/
}
