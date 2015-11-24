require "pivotal_bugsnacker/version"

require 'rubygems'
require 'bundler/setup'
require 'bugsnag/api'
require 'tracker_api'

module PivotalBugsnacker

  class StoryUpdater

    def initialize(story:, error:)
      @story = story
      @error = error
    end

    def update!
      @story.name.gsub! /^\[users:\d+.last_received:.*,occurrences:\d+\]\s*/, ''
      @story.name = "[users:#{@error.users_affected},last_received:#{@error.last_received},occurrences:#{@error.occurrences}] #{@story.name}"
      @story.save
    end

  end

  class << self
    def bugsnack! pages:200, per_page: 30
      Bugsnag.each_error do |error|
        story = Tracker.story_for_error(error)
        StoryUpdater.new(story: story, error: error).update! if story
      end
    end


  end

  module Tracker

    INBOX="1373502"
    LANDLORD="1440014"
    BROKER="1440012"
    LANDLORD_SUPPORT="1447966"
    BROKER_SUPPORT="1447964"
    DASI="1271502"
    DASI_SUPPORT="1448386"
    INTEGRATIONS="1239852"
    INTEGRATIONS_SUPPORT="1452152"
    PROJECT_IDS = [ INBOX, LANDLORD, BROKER, LANDLORD_SUPPORT, BROKER_SUPPORT, DASI, DASI_SUPPORT, INTEGRATIONS, INTEGRATIONS_SUPPORT ].freeze


    class << self

      def story_for_error error
        if error.created_issue_url
          story_id = error.created_issue_url.split('/').last
          story = nil
          projects.each{|p| story = story_in_project(p, story_id); break if story}
          story
        end
      end

      private

      def client
        @client ||= TrackerApi::Client.new token: (ENV['TRACKER_TOKEN'] || raise("missing TRACKER_TOKEN"))
      end

      def story_in_project(tracker_project, id)
        tracker_project.story(id)
      rescue TrackerApi::Error
      end

      def projects
        @projects ||= PROJECT_IDS.map{ |project_id|  client.project(project_id) }
      end

    end


  end


  module Bugsnag

    class << self

      def errors pages: 1, per_page: 1
        errors = []
        each_error pages: pages, per_page: per_page do |error|
          errors << error
        end
        errors
      end

      def each_error pages:10, per_page: 30
        errors = client.errors(project.id, per_page: per_page, most_recent_event: true)
        last_response = client.last_response
        count = 0
        loop do
          count+=1
          errors.each{ |error| yield error }
          break if errors.nil? || errors.length < per_page || count >= pages
          last_response = last_response.rels[:next].get
          errors = last_response.data || []
        end
      end

      private

      def project
        @project ||= client.projects.find{|p| p.name == 'www.viewthespace.com'}
      end

      def client
        @client ||= ::Bugsnag::Api::Client.new(auth_token: ENV['BUGSNAG_DEPLOY_API_KEY'])
      end

    end

  end

end
