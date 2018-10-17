require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'open-uri'
require 'app/scrapper'


Scrapper.new("http://annuaire-des-mairies.com/val-d-oise.html").perform

