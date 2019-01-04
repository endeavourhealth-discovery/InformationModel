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
    public void getId_Missing() {
        try {
            conceptMockDAL.conceptResult = null;
            Concept result = conceptLogic.get(-1L);
            assertTrue(conceptMockDAL.getCalled);
            assertNull(result);
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void getId_Exists() {
        try {
            conceptMockDAL.conceptResult = new Concept();
            Concept result = conceptLogic.get(-1L);
            assertTrue(conceptMockDAL.getCalled);
            assertNotNull(result);
            assertEquals(conceptMockDAL.conceptResult, result);
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }


    @Test
    public void getContextCreate_MissingContextNoCreate() {
        try {
            conceptMockDAL.conceptResult = null;
            Concept result = conceptLogic.get("NO_SUCH_CONTEXT");
            assertTrue(conceptMockDAL.getConceptByContextCalled);
            assertFalse(conceptMockDAL.saveConceptCalled);
            assertFalse(taskMockDAL.createTaskCalled);
            assertNull(result);
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void getContextCreate_MissingContextWithCreate() {
        try {
            conceptMockDAL.conceptResult = null;
            Concept result = conceptLogic.get("NO_SUCH_CONTEXT", true);
            assertTrue(conceptMockDAL.getConceptByContextCalled);
            assertTrue(conceptMockDAL.saveConceptCalled);
            assertTrue(taskMockDAL.createTaskCalled);
            assertNotNull(result);
            assertEquals(conceptMockDAL.saveConceptValue, result);

        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void getContextCreate_ExistingContextNoCreate() {
        try {
            conceptMockDAL.conceptResult = new Concept();
            Concept result = conceptLogic.get("EXISTING_CONTEXT");
            assertTrue(conceptMockDAL.getConceptByContextCalled);
            assertFalse(conceptMockDAL.saveConceptCalled);
            assertFalse(taskMockDAL.createTaskCalled);
            assertNotNull(result);
            assertEquals(conceptMockDAL.conceptResult, result);

        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void getContextCreate_ExistingContextWithCreate() {
        try {
            conceptMockDAL.conceptResult = new Concept();
            Concept result = conceptLogic.get("EXISTING_CONTEXT", true);
            assertTrue(conceptMockDAL.getConceptByContextCalled);
            assertFalse(conceptMockDAL.saveConceptCalled);
            assertFalse(taskMockDAL.createTaskCalled);
            assertNotNull(result);
            assertEquals(conceptMockDAL.conceptResult, result);

        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void saveConcept_new() {
        try {
            Concept concept = new Concept()
                .setSuperclass(new Reference().setId(1L).setName("Concept"));
            conceptLogic.saveConcept(concept);
            assertTrue(conceptMockDAL.saveConceptCalled);
            assertTrue(conceptMockDAL.populateTctCalled);
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void saveConcept_existing() {
        try {
            Concept concept = new Concept()
                .setId(1000L);
            conceptLogic.saveConcept(concept);
            assertTrue(conceptMockDAL.saveConceptCalled);
            assertFalse(conceptMockDAL.populateTctCalled);
        } catch (Exception e) {
            fail(e.getMessage());
        }
    }

    @Test
    public void getAttributes() {
        try {
            conceptMockDAL.getAttributesResult = new ArrayList<>(Arrays.asList(
                new Attribute().setConcept(new Reference(2L, "Child")).setAttribute(new Reference(10L, "New")),
                new Attribute().setConcept(new Reference(2L, "Child")).setAttribute(new Reference(11L, "Override")),
                new Attribute().setConcept(new Reference(1L, "Parent")).setAttribute(new Reference(11L, "Overridden")),
                new Attribute().setConcept(new Reference(1L, "Parent")).setAttribute(new Reference(12L, "Inherited"))
            ));
            List<Attribute> attributes = conceptLogic.getAttributes(2L, true);

            assertNotNull(attributes);
            assertEquals(3, attributes.size());

        } catch (Exception e) {
            fail(e.getMessage());
        }
    }
}