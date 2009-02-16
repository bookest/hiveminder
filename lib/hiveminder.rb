require 'activeresource'
require 'cgi'
require 'shellwords'

module Hiveminder
  # Set the SID used to login to Hiveminder.
  def self.sid=(sid)
    Base.sid = sid
  end

  # Set the Logger instance used for logging.
  def self.logger=(logger)
    Base.logger = logger
  end

  class Base < ActiveResource::Base #:nodoc:
    self.site = "http://hiveminder.com"
    @@cookie = nil

    def self.sid= (sid)
      @@cookie = CGI::Cookie.new('JIFTY_SID_HIVEMINDER', sid).to_s
    end

    def self.headers
      headers = super
      headers.update("Cookie" =>  @@cookie) if @@cookie
      headers
    end

    def self.query_string(options)
      "/#{options.collect.join('/')}" unless options.nil? || options.empty?
    end

    def self.element_path(id, prefix_options = {}, query_options = nil)
      if query_options.nil?
        prefix_options, query_options = split_options(prefix_options)
      end
      "/=/model#{prefix(prefix_options)}#{collection_name}/id/#{id}#{query_string(query_options)}.#{format.extension}"
    end

    # Searching for resources using the __order_by psuedo-column is
    # the best way I could come up with to retrieve all of the
    # resources in a collection using a GET.
    #
    # See <http://hiveminder.com/=/help/search>.
    def self.collection_path(prefix_options = {}, query_options = nil)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "/=/search#{prefix(prefix_options)}#{collection_name}/__order_by/id#{query_string(query_options)}.#{format.extension}"
    end

    def self.instantiate_collection(collection, prefix_options = {})
      collection = [ collection ] unless collection.kind_of? Array
      super(collection.collect { |data| data["value"] }, prefix_options)
    end
  end

  class Task < Base
    include Shellwords
    self.collection_name = 'Task'

    def tags
      attributes['tags'] ||= nil
      @tags ||= attributes['tags'].blank? ? [] : shellwords(attributes['tags'])
    end
  end
end
