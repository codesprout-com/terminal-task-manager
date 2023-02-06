#!/usr/bin/env ruby

require 'sqlite3'

require_relative '../src/app_constants'

database = SQLite3::Database.new(DATABASE_NAME)

database.execute <<-SQL
  CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    priority INTEGER,
    name VARCHAR(200),
    date DATE
  );
SQL