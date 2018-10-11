package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ConceptDAL;
import org.endeavourhealth.im.dal.ConceptJDBCDAL;
import org.endeavourhealth.im.models.*;
import sun.reflect.generics.reflectiveObjects.NotImplementedException;

import java.util.ArrayList;
import java.util.List;

public class ConceptLogic {
    private ConceptDAL dal;

    public ConceptLogic() {
        this.dal = new ConceptJDBCDAL();
    }
    protected ConceptLogic(ConceptDAL dal) {
        this.dal = dal;
    }

    public Concept get(Long id) throws Exception {
        return this.dal.get(id);
    }

    public Concept get(String context) throws Exception {
        return this.dal.getConceptByContext(context);
    }

    public List<ConceptSummary> getMRU(Boolean includeDeprecated) throws Exception {
        return this.dal.getMRU(includeDeprecated);
    }

    public List<ConceptSummary> search(String term, Boolean includeDeprecated, Long superclass) throws Exception {
        return this.dal.search(term, includeDeprecated, superclass);
    }

    public List<RelatedConcept> getRelated(Long id, Boolean includeDeprecated) throws Exception {
        return this.dal.getRelated(id, includeDeprecated);
    }

    public List<Attribute> getAttributes(Long id, Boolean includeDeprecated) throws Exception {
        List<Long> ids = new ArrayList<>();
        List<Attribute> result = new ArrayList<>();
        Long attConcept = id;

        while (attConcept != null) {
            result.addAll(this.dal.getAttributes(id, attConcept, includeDeprecated));

            // Get superclass attributes
            Concept concept = this.dal.get(attConcept);
            if (concept == null)
                throw new IndexOutOfBoundsException("Couldnt load concept " + attConcept);

            attConcept = concept.getSuperclass().getId();

            // Cyclic protection
            if (attConcept == 1 || ids.contains(attConcept))
                attConcept = null;
            else
                ids.add(attConcept);

        }

        return result;
    }

    public Long saveConcept(Concept concept) throws Exception {
        return this.dal.saveConcept(concept);
    }

    public void saveConceptBundle(Bundle bundle) throws Exception {
        this.dal.saveConceptBundle(bundle);
    }

    public void saveRelationship(RelatedConcept relatedConcept) throws Exception {
        throw new NotImplementedException();
    }

    public List<Synonym> getSynonyms(Long id) throws Exception {
        return this.dal.getSynonyms(id);
    }
}
