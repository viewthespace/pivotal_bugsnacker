require 'test_helper'
require 'pry-byebug'

module PivotalBugsnacker

  class MockStory < Struct.new(:name)

    def save
    end

  end

  describe StoryUpdater do


    let(:error) do
      OpenStruct.new({
        users_affected: 3,
        last_received: "2015-11-23T21:22:39.184Z",
        occurrences: 5
      })
    end

    describe 'no data already on story' do
      let(:story) do
        MockStory.new("Reminders mailer does not handle deals with only an office park")
      end

      it 'updates the story name with important information' do
        StoryUpdater.new(story:story, error: error).update!
        story.name.must_equal "[users:3,last_received:11/23/2015 04:22PM,occurrences:5] Reminders mailer does not handle deals with only an office park"
      end

    end

    describe 'some data on story' do
      let(:story) do
        MockStory.new "[users:2,last_received:11/22/2015 04:22PM,occurrences:3] Reminders mailer does not handle deals with only an office park"
      end

      it 'updates the story name with important information' do
        StoryUpdater.new(story:story, error: error).update!
        story.name.must_equal "[users:3,last_received:11/23/2015 04:22PM,occurrences:5] Reminders mailer does not handle deals with only an office park"
      end

    end


    describe 'no user affected data' do

      before do
        error.users_affected = nil
      end

      describe 'story has no data on it yet' do


        let(:story) do
          MockStory.new("Reminders mailer does not handle deals with only an office park")
        end

        it 'leaves users as na' do
          StoryUpdater.new(story:story, error: error).update!
          story.name.must_equal "[users:na,last_received:11/23/2015 04:22PM,occurrences:5] Reminders mailer does not handle deals with only an office park"
        end

      end

      describe 'story already has data on it' do

        let(:story) do
          MockStory.new("[users:na,last_received:11/22/2015 04:22PM,occurrences:5] Reminders mailer does not handle deals with only an office park")
        end


        it 'leaves users as na' do
          StoryUpdater.new(story:story, error: error).update!
          story.name.must_equal "[users:na,last_received:11/23/2015 04:22PM,occurrences:5] Reminders mailer does not handle deals with only an office park"
        end

      end

    end

  end
end
