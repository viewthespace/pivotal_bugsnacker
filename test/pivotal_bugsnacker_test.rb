require 'test_helper'


describe PivotalBugsnacker do

  before do
    PivotalBugsnacker::EventMemory::REDIS.flushdb
  end

  it 'updates stories in pivotal' do
    VCR.use_cassette('bugsnack', record: :none) do
      PivotalBugsnacker.bugsnack!(pages: 1, per_page: 5)
      PivotalBugsnacker::Bugsnag.each_error(pages: 1, per_page: 5) do |error|
        PivotalBugsnacker::EventMemory.remember?(error).must_equal true
      end
    end
  end

end
