$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"

require 'puppetserver_metrics_reader'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"

  opts.on('--json FILE','Input file') { |v| options[:input_file] = v }
  opts.on('-h','--help','Prints this help text') do
    puts opts
    exit
  end

end.parse!

p = Puppetserver_metrics_reader.new
p.load_json options[:input_file]

p.jruby_summary
p.http_summary
p.profiler_summary
p.status_summary
