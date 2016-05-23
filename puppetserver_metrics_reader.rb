$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"

require 'puppetserver_metrics_reader'

options = {}
options[:input_file] = ARGV.pop
unless options[:input_file]
  puts "Must specify an input file"
  puts "Usage: #{$0} <input file>"
  exit
end

p = Puppetserver_metrics_reader.new
p.load_json options[:input_file]

p.jruby_summary
p.http_summary
p.profiler_summary
p.status_summary
