require 'test_helper'

module PivotalBugsnacker

  describe Bugsnag do

    describe '#errors' do
      it 'retrieves 1 errors from bugsnag' do
        VCR.use_cassette('bugsnag_errors', record: :none) do
          errors = Bugsnag.errors(pages: 1, per_page: 1)
          errors.length.must_equal 1
        end
      end

      it 'retrieves 4 errors from bugsnag' do
        VCR.use_cassette('bugsnag_errors', record: :none) do
          errors = Bugsnag.errors(pages: 2, per_page: 2)
          errors.length.must_equal 4
        end
      end
    end


  end

end

