-- Script to move Appreciation entry to the bottom of disposition_config table
USE spcform;

-- First, delete the existing Appreciation entry
DELETE FROM disposition_config 
WHERE call_type = 'Appreciation' 
  AND disposition_1 = 'General' 
  AND disposition_2 = 'General Appreciation';

-- Re-insert the Appreciation entry at the bottom (it will get the highest ID)
INSERT INTO disposition_config (call_type, disposition_1, disposition_2, email_address, is_custom_input) VALUES
('Appreciation', 'General', 'General Appreciation', 'info@spcfz.ae', FALSE);

-- Drop and recreate the disposition_hierarchy view to ensure proper ordering
DROP VIEW IF EXISTS disposition_hierarchy;

CREATE VIEW disposition_hierarchy AS
SELECT DISTINCT 
  call_type,
  disposition_1,
  disposition_2,
  email_address,
  is_custom_input
FROM disposition_config
ORDER BY 
  CASE 
    WHEN call_type = 'Appreciation' THEN 'ZZZZ' -- Force Appreciation to appear last
    ELSE call_type 
  END,
  disposition_1, 
  disposition_2;

-- Verify the changes
SELECT 'disposition_config table:' as table_name;
SELECT * FROM disposition_config 
WHERE call_type = 'Appreciation' 
ORDER BY id DESC 
LIMIT 1;

SELECT 'disposition_hierarchy view:' as view_name;
SELECT * FROM disposition_hierarchy 
WHERE call_type = 'Appreciation';
