#!/usr/bin/env ruby

require 'sqlite3'

require_relative '../src/app_constants'

database = SQLite3::Database.new(DATABASE_NAME)

database.execute("DELETE FROM tasks;")