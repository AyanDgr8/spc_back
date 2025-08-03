-- New Disposition Schema for Customer Service Form
-- This schema supports cascading dropdowns: Call Type → Disposition-1 → Disposition-2

CREATE DATABASE IF NOT EXISTS spcform;
USE spcform;

-- Updated forms table to support new disposition structure
CREATE TABLE IF NOT EXISTS forms_new (
  id INT AUTO_INCREMENT PRIMARY KEY,
  company VARCHAR(200) NOT NULL,
  name VARCHAR(100) NOT NULL,
  contact_number VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  call_type VARCHAR(50) NOT NULL,
  disposition_1 VARCHAR(100) NOT NULL,
  disposition_2 VARCHAR(100) NOT NULL,
  disposition_2_custom TEXT NULL, -- For "Others" option
  query TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Call center fields (optional)
  queue_id VARCHAR(100) NULL,
  queue_name VARCHAR(100) NULL,
  agent_id VARCHAR(100) NULL,
  agent_ext VARCHAR(100) NULL,
  caller_id_name VARCHAR(100) NULL,
  caller_id_number VARCHAR(100) NULL,
  
  INDEX idx_call_type (call_type),
  INDEX idx_disposition_1 (disposition_1),
  INDEX idx_disposition_2 (disposition_2),
  INDEX idx_created_at (created_at)
);

-- Table to store disposition hierarchy and email mappings
CREATE TABLE IF NOT EXISTS disposition_config (
  id INT AUTO_INCREMENT PRIMARY KEY,
  call_type VARCHAR(50) NOT NULL,
  disposition_1 VARCHAR(100) NOT NULL,
  disposition_2 VARCHAR(100) NOT NULL,
  email_address VARCHAR(255) NOT NULL,
  is_custom_input BOOLEAN DEFAULT FALSE, -- TRUE for "Others" options
  
  UNIQUE KEY unique_disposition (call_type, disposition_1, disposition_2),
  INDEX idx_call_type (call_type),
  INDEX idx_disposition_1 (disposition_1)
);

-- Insert all disposition configurations with email mappings
INSERT INTO disposition_config (call_type, disposition_1, disposition_2, email_address, is_custom_input) VALUES

-- COMPLAINTS → CallBack Not Rcvd
('Complaints', 'CallBack Not Rcvd', 'CP_Support', 'cp.support@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'SPC Plus', 'services@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'Guide', 'guide@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'MComplaince', 'compliance@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'Application', 'application@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'Existing B2C Support', 'cx@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'New Business set up', 'cx@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'New Channel Partner', 'cp.support@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'Renewals', 'renewals@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'Visa support- B2B', 'cp.support@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'Visa support- B2C', 'cx@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'Channel Partner Dispute', 'cp.support@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'Employee / Employer_B2B', 'cx@spcfz.ae', FALSE),
('Complaints', 'CallBack Not Rcvd', 'Employee / Employer _B2C', 'cx@spcfz.ae', FALSE),

-- COMPLAINTS → Reason for Rejection
('Complaints', 'Reason for Rejection', 'Company setup B2C', 'cx@spcfz.ae', FALSE),
('Complaints', 'Reason for Rejection', 'Establishment card Rejection -B2B', 'cp.support@spcfz.ae', FALSE),
('Complaints', 'Reason for Rejection', 'Establishment card Rejection -B2C', 'cx@spcfz.ae', FALSE),
('Complaints', 'Reason for Rejection', 'VISAs rejection_B2C', 'cx@spcfz.ae', FALSE),
('Complaints', 'Reason for Rejection', 'VISAs rejection_B2B', 'cp.support@spcfz.ae', FALSE),

-- COMPLAINTS → Others
('Complaints', 'Others', 'Others', '', TRUE),

-- QUERY → Accounts
('Query', 'Accounts', 'Paid Invoice - B2C', 'cx@spcfz.ae', FALSE),
('Query', 'Accounts', 'Paid Invoice - B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'Accounts', 'Overstay fine - B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'Accounts', 'Overstay fine - B2C', 'cx@spcfz.ae', FALSE),
('Query', 'Accounts', 'Payment link - B2C', 'cx@spcfz.ae', FALSE),
('Query', 'Accounts', 'Payment link - B2B', 'cp.support@spcfz.ae', FALSE),

-- QUERY → Application
('Query', 'Application', 'Expedite application - B2C', 'cx@spcfz.ae', FALSE),
('Query', 'Application', 'Expedite application - B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'Application', 'Ref/Cred Note fr App_B2C', 'cx@spcfz.ae', FALSE),
('Query', 'Application', 'Ref/Cred Note fr App_B2B', 'cp.support@spcfz.ae', FALSE),

-- QUERY → SPC Plus
('Query', 'SPC Plus', 'Custom Code', 'services@spcfz.ae', FALSE),
('Query', 'SPC Plus', 'De- registeration of corporate tax', 'services@spcfz.ae', FALSE),
('Query', 'SPC Plus', 'Dependant Visa', 'services@spcfz.ae', FALSE),
('Query', 'SPC Plus', 'Corporate Tax', 'services@spcfz.ae', FALSE),
('Query', 'SPC Plus', 'Po Box', 'services@spcfz.ae', FALSE),
('Query', 'SPC Plus', 'Tourist Visa/ Visit visa - New / Cancel', 'services@spcfz.ae', FALSE),
('Query', 'SPC Plus', 'Bank Account', 'services@spcfz.ae', FALSE),
('Query', 'SPC Plus', 'EID Delivery', 'services@spcfz.ae', FALSE),

-- QUERY → Office related
('Query', 'Office related', 'Meeting Room booking - B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'Office related', 'Meeting Room booking - B2C', 'cx@spcfz.ae', FALSE),
('Query', 'Office related', 'Collection of EID_B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'Office related', 'Collection of EID_B2C', 'cx@spcfz.ae', FALSE),
('Query', 'Office related', 'Forgot belongings_B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'Office related', 'Forgot belongings_B2C', 'cx@spcfz.ae', FALSE),
('Query', 'Office related', 'Office space timing_B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'Office related', 'Office space timing_B2C', 'cx@spcfz.ae', FALSE),

-- QUERY → VISA
('Query', 'VISA', 'Dependent VISA', 'services@spcfz.ae', FALSE),
('Query', 'VISA', 'Emp & investor VISA_B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'VISA', 'Emp & investor VISA_B2C', 'cx@spcfz.ae', FALSE),
('Query', 'VISA', 'VISA Alloctn - 25+_B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'VISA', 'VISA Alloctn - 25+_B2C', 'cx@spcfz.ae', FALSE),
('Query', 'VISA', 'Employment Contract_B2B', 'cp.support@spcfz.ae', FALSE),
('Query', 'VISA', 'Employment Contract_B2C', 'cx@spcfz.ae', FALSE),

-- QUERY → Others
('Query', 'Others', 'Others', '', TRUE),

-- REQUEST → Company cancellation
('Request', 'Company cancellation', 'Suspended company_B2B', 'cp.support@spcfz.ae', FALSE),
('Request', 'Company cancellation', 'Suspended company_B2C', 'renewals@spcfz.ae', FALSE),
('Request', 'Company cancellation', 'Expired company_ B2B - More than 5 days', 'renewals@spcfz.ae', FALSE),
('Request', 'Company cancellation', 'Expired company_ B2B', 'cp.support@spcfz.ae', FALSE),
('Request', 'Company cancellation', 'Expired company_ B2C', 'renewals@spcfz.ae', FALSE),
('Request', 'Company cancellation', 'Valid Company_B2B', 'cp.support@spcfz.ae', FALSE),
('Request', 'Company cancellation', 'Valid Company_B2C', 'renewals@spcfz.ae', FALSE),

-- REQUEST → Migration
('Request', 'Migration', 'B2B to B2B', 'cp.support@spcfz.ae', FALSE),
('Request', 'Migration', 'B2B to B2C', 'cp.support@spcfz.ae', FALSE),
('Request', 'Migration', 'B2C to B2B', 'cx@spcfz.ae', FALSE),

-- REQUEST → Name Check
('Request', 'Name Check', 'Name Check_B2B', 'cp.support@spcfz.ae', FALSE),
('Request', 'Name Check', 'Name Check_B2C', 'cx@spcfz.ae', FALSE),

-- REQUEST → Payment
('Request', 'Payment', 'Payment Invoices_B2B', 'cp.support@spcfz.ae', FALSE),
('Request', 'Payment', 'Payment Invoices_B2C', 'cx@spcfz.ae', FALSE),
('Request', 'Payment', 'Payment Link _B2B', 'cp.support@spcfz.ae', FALSE),
('Request', 'Payment', 'Payment Link_B2C', 'cx@spcfz.ae', FALSE),

-- REQUEST → PO BOX number
('Request', 'PO BOX number', 'PO BOX number_B2B', 'cp.support@spcfz.ae', FALSE),
('Request', 'PO BOX number', 'PO BOX number_B2C', 'cx@spcfz.ae', FALSE),

-- REQUEST → Guide
('Request', 'Guide', 'Application submission', 'guide@spcfz.ae', FALSE),

-- REQUEST → Others
('Request', 'Others', 'Others', '', TRUE),

-- APPRECIATION 
('Appreciation', 'General', 'General Appreciation', 'info@spcfz.ae', FALSE);

-- View to get disposition hierarchy for frontend
CREATE VIEW disposition_hierarchy AS
SELECT DISTINCT 
  call_type,
  disposition_1,
  disposition_2,
  email_address,
  is_custom_input
FROM disposition_config
ORDER BY call_type, disposition_1, disposition_2;
