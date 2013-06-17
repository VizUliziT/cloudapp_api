require "httparty"
require "yaml" unless defined?(YAML)
YAML::ENGINE.yamler = "syck" if defined?(YAML::ENGINE) && RUBY_VERSION < "2.0.0"

["base", "drop", "account", "gift_card", "client", "multipart", "httparty", "core_ext", "response_error"].each do |inc|
  require File.join(File.dirname(__FILE__), "cloudapp", inc)
end

# A simple Ruby wrapper for the CloudApp API. Uses HTTParty and provides
# two alternative interfaces for interracting with the API.
# An ActiveResource-like interface is provided alongside a simple client interface.
module CloudApp
  
  # Version number
  VERSION = "0.3.1"
  
  # Sets the authentication credentials in a class variable
  #
  # @param [String] email cl.ly username
  # @param [String] password cl.ly password
  # @return [Hash] authentication credentials
  def CloudApp.authenticate(email, password)
    Base.authenticate(email, password)
  end
      
end
