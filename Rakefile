$LOAD_PATH << '.'
$LOAD_PATH.unshift File.dirname(__FILE__) + "/lib"
require './schema/schema'
require 'rake/testtask'

task :default => ["test_data"]
task :schema  do
  puts "setting up database"
  setup_database
end

task :test_data => ["schema"] do
  puts "inserting test data"
  require './schema/load_rooms.rb'
  load_area "schema/areas/midgaard.are"
end

task :start  do
  load 'lib/socket_server.rb'
end

Rake::TestTask.new("run_test") { |t|
  t.pattern = 'test/*.rb'
  t.verbose = true
}

task :test => ["schema", "run_test"] do
end

Rake::TestTask.new("run_func_test") { |t|
  t.pattern = 'func_test/*.rb'
  t.verbose = true
}

task :func_test => ["test_data", "run_func_test"] do
end

