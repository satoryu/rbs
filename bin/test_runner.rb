#!/usr/bin/env ruby

$LOAD_PATH << File.join(__dir__, "../lib")

require "set"

IS_RUBY_27 = Gem::Version.new(RUBY_VERSION).yield_self do |ruby_version|
  Gem::Version.new('2.7.0') <= ruby_version &&
    ruby_version <= Gem::Version.new('2.8.0')
end

unless IS_RUBY_27
  STDERR.puts "⚠️⚠️⚠️⚠️ stdlib test assumes Ruby 2.7 but RUBY_VERSION==#{RUBY_VERSION} ⚠️⚠️⚠️⚠️"
end

KNOWN_FAILS = %w(dbm).map do |lib|
  /cannot load such file -- #{lib}/
end

ARGV.each do |arg|
  begin
    load arg
  rescue LoadError => exn
    if KNOWN_FAILS.any? {|pat| pat =~ exn.message }
      STDERR.puts "Loading #{arg} failed, ignoring it: #{exn.inspect}"
    else
      raise
    end
  end
end
