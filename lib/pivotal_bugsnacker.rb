require "pivotal_bugsnacker/version"

require 'rubygems'
require 'bundler/setup'
require 'bugsnag/api'
require 'tracker_api'

module PivotalBugsnacker

  def self.bugsnack!
    Bugsnag.each_bug do |bug|
    end
  end


  module Bugsnag

    class << self

      def each_error
        errors = client.errors(project.id, per_page: 30)
        last_response = client.last_response
        count = 0
        loop do
          count+=1
          errors.each{ |error| yield error }
          break if errors.nil? || errors.length < 30 || count > 10
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
