INSERT IGNORE INTO concept
(document, id, name, description)
VALUES
(1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
(1, 'CM_ProblemSignificance', @scm, 'CM_ProblemSignificance', 'Problem significance', 'Problem significance'),
(1, 'CM_ResultReferenceRange', @scm, 'CM_ResultReferenceRange', 'Result reference range', 'Reference range for a result');
