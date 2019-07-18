

desc 'purges files, runs cucumber and then builds report'
task :doit do
  #purge output files
  FileUtils.rm_rf(Dir['./output/*'])
  # Dir.glob('./output/*').each {|file| file.delete }
  
  `cucumber`
  
  `ruby -e $stdout.sync=true;$stderr.sync=true;load($0=ARGV.shift) report_builder.rb`
  
  
end