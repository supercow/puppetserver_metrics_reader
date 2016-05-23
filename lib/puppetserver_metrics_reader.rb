require 'json'
require 'optparse'
require 'terminal-table'

class Puppetserver_metrics_reader

  def initialize
    @ms_threshold = 1
  end

  def load_json json_file
    f = File.read json_file
    @metrics = JSON.load f
    load_stats
  end

  def load_stats
    @jruby_stats = @metrics['pe-jruby-metrics']['status']['experimental']['metrics']
    @master_stats = @metrics['pe-master']['status']['experimental']['http-metrics']
    @profiler_stats = @metrics['pe-puppet-profiler']['status']['experimental']
    @memory_stats= @metrics['status-service']['status']['experimental']['jvm-metrics']
  end

  def profiler_summary
    catalog = @profiler_stats['catalog-metrics'].select do |m|
      m['metric'] == 'static_compile'
    end
    functions = @profiler_stats['function-metrics'].sort do |l,r|
      r['mean'] <=> l['mean']
    end
    resources = @profiler_stats['resource-metrics'].sort do |l,r|
      r['mean'] <=> l['mean']
    end

    rows = []
    catalog[0].each do |name,metric|
      rows << [name,metric] if name != 'metric'
    end
    puts Terminal::Table.new(
      :title => 'Catalog Compilation Summary',
      :rows => rows
    )

    rows = []
    functions.first(5).each do |f|
      rows << [f['function'],f['mean']]
    end
    puts Terminal::Table.new(
      :title => 'Top 5 Functions in ms',
      :rows => rows
    )

    classes = resources.select { |m| m['resource'] =~ /^Class\[/ }
    classes.sort! { |l,r| r['mean'] <=> l['mean'] }
    rows = []
    classes.first(10).each do |f|
      rows << [f['resource'],f['mean']]
    end
    puts Terminal::Table.new(
      :title => 'Top 10 Classes in ms',
      :rows => rows
    )

  end

  def status_summary
  end

  def jruby_summary
    metrics = @jruby_stats.select do |name,value|
      value.is_a? Numeric
    end

    rows = []
    metrics.each do |name,value|
      rows << [name,value]
    end

    puts Terminal::Table.new(
      :title => 'JRuby Status Summary',
      :rows => rows
    )
  end

  def http_summary
    http_high = @master_stats.sort do |l,r|
      r['mean'] <=> l['mean']
    end

    http_high.select! do |m|
      m['mean'] >= @ms_threshold and m['route-id'] != 'total'
    end

    rows = []
    http_high.each do |m|
      rows << [m['route-id'],m['mean']]
    end
    rows << ['All requests',@master_stats.select{|m| m['route-id'] == 'total'}[0]['mean']]

    puts Terminal::Table.new(
      :title => 'HTTP Metrics Summary',
      :headings => ['Endpoint','Mean time (ms)'],
      :rows => rows
    )
  end

end
