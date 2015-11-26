require 'test_helper'

module PivotalBugsnacker
  describe EventMemory do
    before do
      EventMemory.forget!
    end

    describe '#last_received' do
      it 'stores the last received as a Time' do
        VCR.use_cassette('event_memory_last_received', record: :new_episodes) do
          error = Bugsnag.errors.first
          EventMemory.remember! error
          EventMemory.remember_last_received!
          EventMemory.last_received.must_equal error.last_received
        end
      end


    end


  end
end
