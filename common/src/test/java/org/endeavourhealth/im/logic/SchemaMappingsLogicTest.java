package org.endeavourhealth.im.logic;

import org.endeavourhealth.im.dal.ConceptMockDAL;
import org.endeavourhealth.im.dal.SchemaMappingsMockDAL;
import org.endeavourhealth.im.dal.TaskMockDAL;
import org.endeavourhealth.im.models.Attribute;
import org.endeavourhealth.im.models.Reference;
import org.endeavourhealth.im.models.SchemaMapping;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.*;

public class SchemaMappingsLogicTest {
    private SchemaMappingsMockDAL schemaMappingsMockDAL;
    private SchemaMappingsLogic schemaMappingsLogic;
    private ConceptMockDAL conceptMockDAL;
    private ConceptLogic conceptLogic;
    private TaskMockDAL taskMockDAL;

    @Before
    public void setUp() {
        taskMockDAL = new TaskMockDAL();
        conceptMockDAL = new ConceptMockDAL();
        conceptLogic = new ConceptLogic(conceptMockDAL, taskMockDAL);
        schemaMappingsMockDAL = new SchemaMappingsMockDAL();
        schemaMappingsLogic = new SchemaMappingsLogic(schemaMappingsMockDAL, conceptLogic);
    }

    @Test
    public void getSchemaMappings() throws Exception {
        conceptMockDAL.getAttributes_Result = new ArrayList<>(Arrays.asList(
            new Attribute().setId(1L).setConcept(new Reference(2L, "Child")).setAttribute(new Reference(10L, "New")),
            new Attribute().setId(2L).setConcept(new Reference(2L, "Child")).setAttribute(new Reference(11L, "Override")),
            new Attribute().setId(3L).setConcept(new Reference(1L, "Parent")).setAttribute(new Reference(11L, "Overridden")),
            new Attribute().setId(4L).setConcept(new Reference(1L, "Parent")).setAttribute(new Reference(12L, "Inherited"))
        ));

        schemaMappingsMockDAL.getSchemaMappings_Result =  new ArrayList<>(Arrays.asList(
            new SchemaMapping().setAttribute(new Reference(1L, "New")),
            new SchemaMapping().setAttribute(new Reference(3L, "Overridden"))
        ));

        List<SchemaMapping> result = schemaMappingsLogic.getSchemaMappings(1L);

        assertNotNull(result);
        assertEquals(3, result.size());
    }
}