#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

###
### Datamapper
###
require 'data_mapper'

###
### Local libraries
###
require 'lib/config'
require 'lib/emailer'
require 'lib/parser'
require 'lib/models'

module SimpleTrend

  class Main
    def initialize
      puts "Using Database: #{Config::DATABASE}"

      DataMapper.setup :default, "sqlite://#{Config::DATABASE}"

      ###
      ### The difference here is that auto_migrate! will clear all the data from the database;
      ### the auto_upgrade! methods tries to reconcile what’s in the database already with the
      ### changes you want to make. 
      ### 
      #DataMapper.auto_migrate! 
      DataMapper.auto_upgrade!

      # Nmap Scan the target
      output_file = "/tmp/test.xml"
      range = "10.0.0.0/24"
      `nmap -oX #{output_file} #{range}`

      # Parse & Store
      NmapParser.new.parse_and_compare(output_file)
      NmapParser.new.parse_and_store(output_file)
    end
  end
end

SimpleTrend::Main.new