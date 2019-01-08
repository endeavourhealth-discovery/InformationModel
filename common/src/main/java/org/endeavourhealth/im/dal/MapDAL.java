package org.endeavourhealth.im.dal;

import org.endeavourhealth.im.models.Concept;

public interface MapDAL {
    Concept getByCodeAndScheme(String code, Long scheme);
}
