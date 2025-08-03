// setup-database.js - Script to initialize the new disposition database schema

import mysql from 'mysql2/promise';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function setupDatabase() {
  let connection;
  
  try {
    // Connect to MySQL server (without specifying database)
    connection = await mysql.createConnection({
      host: process.env.MYSQL_HOST || 'localhost',
      user: process.env.MYSQL_USER || 'root',
      password: process.env.MYSQL_PASSWORD || '',
      port: process.env.MYSQL_PORT || 3306,
      multipleStatements: true
    });

    console.log('Connected to MySQL server');

    // Create database if it doesn't exist
    await connection.execute('CREATE DATABASE IF NOT EXISTS spcform');
    console.log('✓ Database spcform created/verified');

    // Close and reconnect with the database specified
    await connection.end();
    
    connection = await mysql.createConnection({
      host: process.env.MYSQL_HOST || 'localhost',
      user: process.env.MYSQL_USER || 'root',
      password: process.env.MYSQL_PASSWORD || '',
      port: process.env.MYSQL_PORT || 3306,
      database: 'spcform',
      multipleStatements: true
    });

    console.log('Connected to spcform database');

    // Read and execute the schema file
    const schemaPath = path.join(__dirname, 'src', 'disposition_schema.sql');
    const schema = fs.readFileSync(schemaPath, 'utf8');
    
    // Remove the USE statement and comments, split into individual statements
    const cleanedSchema = schema
      .replace(/USE\s+\w+\s*;/gi, '') // Remove USE statements
      .replace(/--.*$/gm, '') // Remove single-line comments
      .replace(/\/\*[\s\S]*?\*\//g, ''); // Remove multi-line comments
    
    const statements = cleanedSchema
      .split(';')
      .map(stmt => stmt.trim())
      .filter(stmt => stmt.length > 0);

    console.log(`Executing ${statements.length} SQL statements...`);

    for (const statement of statements) {
      try {
        await connection.execute(statement);
        const preview = statement.length > 50 ? statement.substring(0, 50) + '...' : statement;
        console.log('✓ Executed:', preview);
      } catch (error) {
        if (error.code === 'ER_TABLE_EXISTS_ERROR' || error.code === 'ER_DUP_ENTRY') {
          const preview = statement.length > 50 ? statement.substring(0, 50) + '...' : statement;
          console.log('⚠ Skipped (already exists):', preview);
        } else {
          const preview = statement.length > 50 ? statement.substring(0, 50) + '...' : statement;
          console.error('✗ Error executing:', preview);
          console.error('Error:', error.message);
        }
      }
    }

    // Verify the setup
    const [tables] = await connection.execute("SHOW TABLES");
    console.log('\n📊 Database tables:');
    tables.forEach(table => {
      console.log(`  - ${Object.values(table)[0]}`);
    });

    const [configCount] = await connection.execute('SELECT COUNT(*) as count FROM disposition_config');
    console.log(`\n📋 Disposition configurations: ${configCount[0].count} entries`);

    const [hierarchyPreview] = await connection.execute(`
      SELECT call_type, COUNT(*) as disposition_count 
      FROM disposition_config 
      GROUP BY call_type 
      ORDER BY call_type
    `);
    
    console.log('\n🌳 Disposition hierarchy:');
    hierarchyPreview.forEach(row => {
      console.log(`  - ${row.call_type}: ${row.disposition_count} options`);
    });

    console.log('\n✅ Database setup completed successfully!');
    console.log('\nNext steps:');
    console.log('1. Start the backend server: cd backend && node src/form.js');
    console.log('2. Start the frontend: cd frontend/new_form && npm start');
    console.log('3. Test the form at http://localhost:3000');

  } catch (error) {
    console.error('❌ Database setup failed:', error.message);
    process.exit(1);
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

// Run the setup
if (import.meta.url === `file://${process.argv[1]}`) {
  setupDatabase();
}

export { setupDatabase };
