## Student Finder App ##
# This file has to be launched from the terminal to get started
#

APP_ROOT = File.dirname(__FILE__)

# require "#{APP_ROOT}/lib/guide"
# require File.join(APP_ROOT, 'lib', 'catalog')
# require File.join(APP_ROOT, 'lib', 'catalog.rb')

$:.unshift(File.join(APP_ROOT, 'lib'))
require 'catalog'

catalog = Catalog.new('registry.txt')
catalog.launch!