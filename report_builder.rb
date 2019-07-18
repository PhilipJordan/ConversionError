# gem 'json', '1.8.6'
# gem 'report_builder', '0.1.2'
require 'json'
require 'report_builder'
require 'fileutils'
# require_relative 'monkey_business'

# args_joined = ARGV.join(' ')




Dir::mkdir('final_product') unless File.directory?('final_product')
input_directory = 'output/'
output_directory = "final_product/"

puts "bundling reports from #{input_directory} into #{output_directory}"

date_string = ("chrome - #{Time.now.strftime('%m-%d-%y_%H-%M-%S')}")


ReportBuilder.configure do |config|
  config.json_path = input_directory
  config.report_path = "#{output_directory}/#{date_string} - Test Results"
  config.report_types = [:json, :html]
  config.report_tabs = [:Overview, :Features, :Scenarios, :Errors]
  config.report_title = "Report for #{date_string}"
end

ReportBuilder.build_report

# Will need to remove this when going back to multiple json files
# most_recent_file = Dir.glob("./#{input_directory}/*.json").max_by {|f| File.mtime(f)}
# FileUtils.cp most_recent_file, "#{output_directory}/#{date_string} - Test Results.json"

###  remove all json file created by cucumber ###
#FileUtils.rm_rf(Dir.glob('json_reports_qa_regression/*.json'))