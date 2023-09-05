INSERT IGNORE INTO concept
(document, id, name, description)
VALUES
    (1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'DM_AppointmentLocationType', @scm, 'DM_AppointmentLocationType', 'Appointment location type', 'The type of the location the appointment is at')           -- Property Only    Added 5/9/23
;
