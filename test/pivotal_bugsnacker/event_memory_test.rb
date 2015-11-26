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
          EventMemory.last_received.must_equal Time.parse(error.last_received)
        end
      end

      it 'does not store null' do
        after = Time.now
        EventMemory::REDIS['most_recent_received'] = after.to_s
        EventMemory.remember_last_received!
        EventMemory.last_received.wont_be_nil
        EventMemory.last_received.to_i.must_equal after.to_i
      end

    end


  end
end
