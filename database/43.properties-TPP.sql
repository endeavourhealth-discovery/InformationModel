INSERT IGNORE INTO concept
(document, id, name, description)
VALUES
(1, 'CM_DiscoveryCode', 'Discovery code', 'Discovery (core) coding scheme ');

SELECT @scm := dbid FROM concept WHERE id = 'CM_DiscoveryCode';

INSERT IGNORE INTO concept
(document, id, scheme, code, name, description)
VALUES
-- GENERAL/GLOBAL --
(1, 'DM_ReferralServiceOffered', @scm, 'DM_ReferralServiceOffered', 'Referral Service Offered', 'Referral Service Offered'),
(1, 'DM_ReferralRecipient', @scm, 'DM_ReferralRecipient', 'Referral Recipient', 'Referral Recipient');
