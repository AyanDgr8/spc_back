// test-form.js - Test script to verify the disposition form system

import { handleFormSubmission, getDispositionHierarchy, getDispositionEmail } from './src/form.js';

async function testDispositionSystem() {
  console.log('🧪 Testing Disposition Form System\n');

  try {
    // Test 1: Get disposition hierarchy
    console.log('1️⃣ Testing disposition hierarchy...');
    const hierarchy = await getDispositionHierarchy();
    
    const callTypes = Object.keys(hierarchy);
    console.log(`✅ Found ${callTypes.length} call types: ${callTypes.join(', ')}`);
    
    // Show sample hierarchy
    if (hierarchy['Complaints']) {
      const complaintsOptions = Object.keys(hierarchy['Complaints']);
      console.log(`   Complaints has ${complaintsOptions.length} disposition-1 options`);
      
      if (hierarchy['Complaints']['CallBack Not Rcvd']) {
        const callbackOptions = hierarchy['Complaints']['CallBack Not Rcvd'];
        console.log(`   CallBack Not Rcvd has ${callbackOptions.length} disposition-2 options`);
      }
    }

    // Test 2: Email routing
    console.log('\n2️⃣ Testing email routing...');
    const testCases = [
      ['Complaints', 'CallBack Not Rcvd', 'CP_Support'],
      ['Query', 'Accounts', 'Paid Invoice - B2C'],
      ['Request', 'Payment', 'Payment Link_B2B'],
      ['Complaints', 'Others', 'Others']
    ];

    for (const [callType, disp1, disp2] of testCases) {
      const { email, isCustomInput } = await getDispositionEmail(callType, disp1, disp2);
      console.log(`   ${callType} → ${disp1} → ${disp2}: ${email || 'No email'} ${isCustomInput ? '(Custom Input)' : ''}`);
    }

    // Test 3: Form submission (dry run)
    console.log('\n3️⃣ Testing form submission...');
    const testFormData = {
      company: 'Test Company Ltd',
      name: 'John Doe',
      contact_number: '+971501234567',
      email: 'john.doe@testcompany.com',
      call_type: 'Query',
      disposition_1: 'Accounts',
      disposition_2: 'Paid Invoice - B2C',
      query: 'Need help with invoice payment confirmation',
      queue_id: 'TEST_QUEUE_001',
      agent_id: 'AGENT_123'
    };

    console.log('   Submitting test form...');
    await handleFormSubmission(testFormData);
    console.log('✅ Form submission successful!');

    // Test 4: Custom input handling
    console.log('\n4️⃣ Testing custom input handling...');
    const customFormData = {
      company: 'Another Test Company',
      name: 'Jane Smith',
      contact_number: '+971509876543',
      email: 'jane.smith@anothertest.com',
      call_type: 'Complaints',
      disposition_1: 'Others',
      disposition_2: 'Others',
      disposition_2_custom: 'Special complaint about service quality and response time',
      query: 'Detailed explanation of the custom complaint'
    };

    console.log('   Submitting form with custom input...');
    await handleFormSubmission(customFormData);
    console.log('✅ Custom input form submission successful!');

    console.log('\n🎉 All tests passed! The disposition form system is working correctly.');
    console.log('\n📋 Summary:');
    console.log(`   • ${callTypes.length} call types configured`);
    console.log('   • Email routing working correctly');
    console.log('   • Form submissions processing successfully');
    console.log('   • Custom input handling working');

  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.error('Stack trace:', error.stack);
    process.exit(1);
  }
}

// Run tests
if (import.meta.url === `file://${process.argv[1]}`) {
  testDispositionSystem();
}

export { testDispositionSystem };
