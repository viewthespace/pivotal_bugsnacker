require 'test_helper'

module PivotalBugsnacker

  describe Bugsnag do

    describe 'retreive erorrs after a certain time' do

      it 'only returns errors from the last 10 minutes' do
        VCR.use_cassette('errors_after', record: :none) do
          time = Time.parse('2015-11-26 12:08:25 -0500')
          errors = Bugsnag.each_error(after: time) do |error|
            Time.parse(error.last_received).must_be :>, time
          end
        end
      end

      it 'can handle after being nil' do
        VCR.use_cassette('errors_after_is_nil', record: :new_episodes) do
          Bugsnag.each_error(pages:1, per_page: 2, after: nil){ }
        end
      end



    end

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

