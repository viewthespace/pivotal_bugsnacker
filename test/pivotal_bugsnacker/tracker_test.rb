require 'test_helper'

module PivotalBugsnacker

  describe Tracker do

    let(:error){
      OpenStruct.new({:id=>"564a53f515766f1ee3d30192", :last_message=>"undefined method `street_address' for nil:NilClass", :class=>"NoMethodError", :occurrences=>3839, :release_stages=>{:production=>3839}, :last_context=>"sidekiq#mailer", :resolved=>false, :first_received=>"2015-11-16T22:08:53.000Z", :last_received=>"2015-11-23T17:21:10.650Z", :severity=>"error", :comments=>1, :app_versions=>{}, :url=>"https://api.bugsnag.com/errors/564a53f515766f1ee3d30192", :events_url=>"https://api.bugsnag.com/errors/564a53f515766f1ee3d30192/events", :html_url=>"https://bugsnag.com/vts-1/www-dot-viewthespace-dot-com/errors/564a53f515766f1ee3d30192", :comments_url=>"https://api.bugsnag.com/errors/564a53f515766f1ee3d30192/comments", :created_issue_url=>"https://www.pivotaltracker.com/story/show/108294132"})
    }

    it 'returns the tracker story' do
      Tracker.story_for_error(error).wont_be_nil
    end

  end


end
