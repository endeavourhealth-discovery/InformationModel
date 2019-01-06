package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ConceptMockDAL;
import org.endeavourhealth.im.dal.TaskMockDAL;
import org.endeavourhealth.im.models.Attribute;
import org.endeavourhealth.im.models.Concept;
import org.endeavourhealth.im.models.Reference;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.*;


public class ConceptLogicTest {
    private ConceptMockDAL conceptMockDAL;
    private ConceptLogic conceptLogic;
    private TaskMockDAL taskMockDAL;
    private TaskLogic taskLogic;


    @Before
    public void setup() {
        taskMockDAL = new TaskMockDAL();
        taskLogic = new TaskLogic(taskMockDAL);
        conceptMockDAL = new ConceptMockDAL();
        conceptLogic = new ConceptLogic(conceptMockDAL, taskLogic);
    }

    @Test
    public void getId_Missing() throws Exception {
        conceptMockDAL.get_Result = null;
        Concept result = conceptLogic.get(-1L);
        assertTrue(conceptMockDAL.get_Called);
        assertNull(result);
    }

    @Test
    public void getId_Exists() throws Exception {
        conceptMockDAL.get_Result = new Concept();
        Concept result = conceptLogic.get(-1L);
        assertTrue(conceptMockDAL.get_Called);
        assertNotNull(result);
        assertEquals(conceptMockDAL.get_Result, result);
    }


    @Test
    public void getContextCreate_MissingContextNoCreate() throws Exception {
        conceptMockDAL.get_Result = null;
        Concept result = conceptLogic.get("NO_SUCH_CONTEXT");
        assertTrue(conceptMockDAL.getConceptByContext_Called);
        assertFalse(conceptMockDAL.saveConcept_Called);
        assertFalse(taskMockDAL.createTask_Called);
        assertNull(result);
    }

    @Test
    public void getContextCreate_MissingContextWithCreate() throws Exception {
        conceptMockDAL.get_Result = null;
        Concept result = conceptLogic.get("NO_SUCH_CONTEXT", true);
        assertTrue(conceptMockDAL.getConceptByContext_Called);
        assertTrue(conceptMockDAL.saveConcept_Called);
        assertTrue(taskMockDAL.createTask_Called);
        assertNotNull(result);
        assertEquals(conceptMockDAL.saveConcept_Value, result);
    }

    @Test
    public void getContextCreate_ExistingContextNoCreate() throws Exception {
        conceptMockDAL.getConceptByContext_Result = new Concept();
        Concept result = conceptLogic.get("EXISTING_CONTEXT");
        assertTrue(conceptMockDAL.getConceptByContext_Called);
        assertFalse(conceptMockDAL.saveConcept_Called);
        assertFalse(taskMockDAL.createTask_Called);
        assertNotNull(result);
        assertEquals(conceptMockDAL.getConceptByContext_Result, result);
    }

    @Test
    public void getContextCreate_ExistingContextWithCreate() throws Exception {
        conceptMockDAL.getConceptByContext_Result = new Concept();
        Concept result = conceptLogic.get("EXISTING_CONTEXT", true);
        assertTrue(conceptMockDAL.getConceptByContext_Called);
        assertFalse(conceptMockDAL.saveConcept_Called);
        assertFalse(taskMockDAL.createTask_Called);
        assertNotNull(result);
        assertEquals(conceptMockDAL.getConceptByContext_Result, result);
    }

    @Test
    public void saveConcept_new() throws Exception {
        Concept concept = new Concept()
            .setSuperclass(new Reference().setId(1L).setName("Concept"));
        conceptLogic.saveConcept(concept);
        assertTrue(conceptMockDAL.saveConcept_Called);
        assertTrue(conceptMockDAL.populateTct_Called);
    }

    @Test
    public void saveConcept_existing() throws Exception {
        Concept concept = new Concept()
            .setId(1000L);
        conceptLogic.saveConcept(concept);
        assertTrue(conceptMockDAL.saveConcept_Called);
        assertFalse(conceptMockDAL.populateTct_Called);
    }

    @Test
    public void getAttributes() throws Exception {
        conceptMockDAL.getAttributes_Result = new ArrayList<>(Arrays.asList(
            new Attribute().setConcept(new Reference(2L, "Child")).setAttribute(new Reference(10L, "New")),
            new Attribute().setConcept(new Reference(2L, "Child")).setAttribute(new Reference(11L, "Override")),
            new Attribute().setConcept(new Reference(1L, "Parent")).setAttribute(new Reference(11L, "Overridden")),
            new Attribute().setConcept(new Reference(1L, "Parent")).setAttribute(new Reference(12L, "Inherited"))
        ));
        List<Attribute> attributes = conceptLogic.getAttributes(2L, true);

        assertNotNull(attributes);
        assertEquals(3, attributes.size());
    }
}