require "pivotal_bugsnacker/version"

require 'rubygems'
require 'bundler/setup'
require 'bugsnag/api'
require 'tracker_api'
require 'redis'

module PivotalBugsnacker

  class StoryUpdater

    def initialize(story:, error:)
      @story = story
      @error = error
    end

    def update!
      @story.name.gsub! /^\[users:(\d+|na),last_received:.*,occurrences:\d+\]\s*/, ''
      @story.name = "[users:#{users_affected},last_received:#{last_received},occurrences:#{occurrences}] #{@story.name}"
      @story.save
    end

    private

    def occurrences
      @error.occurrences
    end

    def users_affected
      @error.users_affected || 'na'
    end

    def last_received
      DateTime.parse(@error.last_received).new_offset(etc_offset).strftime(date_time_format)
    end

    def etc_offset
      Rational -5, 24
    end

    def date_time_format
      "%m/%d/%Y %I:%M%p"
    end


  end

  module EventMemory

    REDIS = ENV['REDIS_URL'] ? Redis.new(url: ENV["REDIS_URL"]) : Redis.new

    class << self

      def remember!(error)
        REDIS.sadd('event_ids', error.most_recent_event.id) if error.most_recent_event
      end

      def remember?(error)
        REDIS.sismember('event_ids', error.most_recent_event.id) if error.most_recent_event
      end

    end

  end


  class << self

    DEFAULT_PER_PAGE = ENV.fetch('DEFAULT_PAGE_SIZE', 30).to_i
    DEFAULT_PAGES = ENV.fetch('DEFAULT_PAGES', 50).to_i


    def bugsnack! pages: DEFAULT_PAGES, per_page: DEFAULT_PER_PAGE
      Bugsnag.each_error(pages: pages, per_page: per_page) do |error|
        puts "processing: #{error.html_url}"
        unless EventMemory.remember?(error)
          story = Tracker.story_for_error(error)
          if story
            puts "updating story #{story.name}"
            StoryUpdater.new(story: story, error: error).update!
          end
          EventMemory.remember!(error)
        end
      end
    end

    private

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
        @client ||= ::Bugsnag::Api::Client.new(auth_token: ENV['BUGSNAG_API_KEY'])
      end

    end

  end

end
