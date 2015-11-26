require 'test_helper'

module PivotalBugsnacker
  describe EventMemory do
    before do
      EventMemory.forget!
    end

    describe '#last_received' do
      it 'stores the last received as a Time' do
        VCR.use_cassette('event_memory_last_received', record: :none) do
          errors = Bugsnag.errors(per_page: 5)
          errors.each do |error|
            EventMemory.remember! error
          end
          error = errors.first
          EventMemory.remember_last_received!
          EventMemory.last_received.must_equal error.last_received
        end
      end


    end


  end
end
