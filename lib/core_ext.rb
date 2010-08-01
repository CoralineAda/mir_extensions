require 'rubygems'
require 'singleton'

module CoreExt

  # String Extensions ==============================================================================

  String.class_eval do

    include ActionView::Helpers::NumberHelper

    # Usage: "3125552312".to_phone
    # Returns: 312-555-2313
    #
    # Usage: "3125552313".to_phone(:area_code => true)
    # Returns : (312) 555-2313
    #
    def to_phone(options = {})
      number_to_phone(self.to_i, options)
    end

  end

end

class ActionController::Base
  require 'mir_extensions'
  require 'socket'

  def self.local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end

  # Returns a sanitized column parameter suitable for SQL order-by clauses.
  def sanitize_by_param(allowed=[], default='id')
    sanitize_params params && params[:by], allowed, default
  end

  # Returns a sanitized direction parameter suitable for SQL order-by clauses.
  def sanitize_dir_param
    sanitize_params params && params[:dir], ['ASC', 'DESC'], 'ASC'
  end

  # Use this method to prevent SQL injection vulnerabilities by verifying that a user-provided
  # parameter is on a whitelist of allowed values.
  #
  # Accepts a value, a list of allowed values, and a default value.
  # Returns the value if allowed, otherwise the default.
  def sanitize_params(supplied='', allowed=[], default=nil)
    raise ArgumentError, "A default value is required." unless default
    return default if supplied.blank? || allowed.blank? || ! allowed.include?(supplied)
    return supplied
  end
end
