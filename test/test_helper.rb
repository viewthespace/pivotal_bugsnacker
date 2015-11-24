require 'pivotal_bugsnacker'
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require 'vcr'


VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
end
