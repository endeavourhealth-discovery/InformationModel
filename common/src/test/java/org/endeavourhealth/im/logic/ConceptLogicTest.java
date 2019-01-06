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


    @Before
    public void setup() {
        taskMockDAL = new TaskMockDAL();
        conceptMockDAL = new ConceptMockDAL();
        conceptLogic = new ConceptLogic(conceptMockDAL, taskMockDAL);
    }

    @Test
    public void getContextCreate_MissingContextNoCreate() throws Exception {
        conceptMockDAL.get_Result = null;
        Concept result = conceptLogic.get("NO_SUCH_CONTEXT", false);
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
        Concept result = conceptLogic.get("EXISTING_CONTEXT", false);
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

    @Test
    public void saveAttribute_OwnAttribute() throws Exception {
        Attribute attribute = new Attribute()
            .setId(1L)
            .setConcept(new Reference(10L, "Own Attribute"))
            .setInheritance((byte)0);

        conceptLogic.saveAttribute(10L, attribute);

        assertEquals(1L, attribute.getId().longValue());
        assertEquals((byte)0, attribute.getInheritance().byteValue());
        assertTrue(conceptMockDAL.saveAttribute_Called);
    }

    @Test
    public void saveAttribute_InheritedAttribute() throws Exception {
        Attribute attribute = new Attribute()
            .setId(1L)
            .setConcept(new Reference(10L, "Inherited Attribute"))
            .setInheritance((byte)0);

        conceptLogic.saveAttribute(20L, attribute);

        assertNull(attribute.getId());
        assertEquals((byte)2, attribute.getInheritance().byteValue());
        assertTrue(conceptMockDAL.saveAttribute_Called);
    }

}