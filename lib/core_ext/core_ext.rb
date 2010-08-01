require 'rubygems'
require 'singleton'
require 'controller_extensions'
require 'helper_extensions'
require 'soap/header/simplehandler'

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

class String

  # Bring in support for view helpers
#     include MirExtensions::CoreExt::String::NumberHelper

  # General methods

  def capitalize_words
    self.downcase.gsub(/\b([a-z])/) { $1.capitalize }.gsub( "'S", "'s" )
  end

  # Address methods

  def expand_address_abbreviations
    _address = self.strip.capitalize_words

    # NOTE: DO NOT rearrange the replace sequences; order matters!

    # streets
    _address.gsub!( /\b(ave|av)\.?\b/i, 'Avenue ' )
    _address.gsub!( /\b(blvd|blv|bld|bl)\.?\b/i, 'Boulevard ' )
    _address.gsub!( /\bcr\.?\b/i, 'Circle ' )
    _address.gsub!( /\bctr\.?\b/i, 'Center ' )
    _address.gsub!( /\b(crt|ct)\.?\b/i, 'Court ' )
    _address.gsub!( /\bdr\.?\b/i, 'Drive ' )
    _address.gsub!( /\b(expressw|expw|expy)\.?\b/i, 'Expressway ' )
    _address.gsub!( /\bfrwy\.?\b/i, 'Freeway ' )
    _address.gsub!( /\bhwy\.?\b/i, 'Highway ' )
    _address.gsub!( /\bln\.?\b/i, 'Lane ' )
    _address.gsub!( /\b(prkwy|pkwy|pkw|pky)\.?\b/i, 'Parkway ' )
    _address.gsub!( /\bpk\.?\b/i, 'Pike ' )
    _address.gsub!( /\bplz\.?\b/i, 'Plaza ' )
    _address.gsub!( /\bpl\.?\b/i, 'Place ' )
    _address.gsub!( /\brd\.?\b/i, 'Road ' )
    _address.gsub!( /\b(rte|rt)\.?\b/i, 'Route ' )
    _address.gsub!( /\bste\.?\b/i, 'Suite ' )
    _address.gsub!( /\bst\.?\b/i, 'Street ' )
    _address.gsub!( /\btrpk\.?\b/i, 'Turnpike ' )
    _address.gsub!( /\btr\.?\b/i, 'Trail ' )

    # directions
    _address.gsub!( /\bN\.?e\.?\b/i, 'Northeast ' )
    _address.gsub!( /\bS\.?e\.?\b/i, 'Southeast ' )
    _address.gsub!( /\bS\.?w\.?\b/i, 'Southwest ' )
    _address.gsub!( /\bN\.?w\.?\b/i, 'Northwest ' )
    _address.gsub!( /\bN\.?\b/, 'North ' )
    _address.gsub!( /\bE\.?\b/, 'East ' )
    _address.gsub!( /\bS\.?\b/, 'South ' )
    _address.gsub!( /\bW\.?\b/, 'West ' )
    _address.gsub!( '.', '' )
    _address.gsub!( / +/, ' ' )
    _address.strip
  end

  def formatted_phone
    if self
      # remove non-digit characters
      _self = self.gsub(/[\(\) -]+/, '')
      # format as phone if 10 digits are left
      return number_to_phone(_self, :area_code => true ) if !! (_self =~ /[0-9]{10}/)
    end

    self
  end

  def formatted_zip
    return if self.blank?
    self.gsub!( /[\(\) -]+/, '' )
    self.size == 9 ? "#{self[0 .. 4]}-#{self[5 .. -1]}" : self
  end

  # Time methods

  def to_12_hour_time
    (self == '0' || self.blank?) ? nil : Time.parse( "#{self[0..-3]}:#{self[-2..-1]}" ).to_s( :time ).gsub(/^0/, '')
  end

  # URL methods

  # Prefixes the given url with 'http://'.
  def add_http_prefix
    return if self.blank?
    _uri = self.to_uri
    return self if _uri.nil? || _uri.is_a?(URI::FTP) || _uri.is_a?(URI::HTTP) || _uri.is_a?(URI::HTTPS) || _uri.is_a?(URI::LDAP) || _uri.is_a?(URI::MailTo)
    "http://#{self}"
  end

  # Returns true if a given string begins with http:// or https://.
  def has_http?
    !! (self =~ /^http[s]?:\/\/.+/)
  end

  # Returns true if a given string has a trailing slash.
  def has_trailing_slash?
    !! (self =~ /\/$/)
  end

  # Returns true if a given string refers to an HTML page.
  def is_page?
    !! (self =~ /\.htm[l]?$/)
  end

  # Returns the host from a given URL string; returns nil if the string is not a valid URL.
  def to_host
    _uri = self.to_uri
    _uri ? _uri.host : nil
  end

  # Returns a URI for the given string; nil if the string is invalid.
  def to_uri
    begin
      _uri = URI.parse self
    rescue URI::InvalidURIError
      _uri = nil
    end

    _uri
  end

  # Returns true if the given string is a valid URL.
  def valid_http_url?
    self.scan(/:\/\//).size == 1 && self.to_uri.is_a?(URI::HTTP)
  end

end

# Array Extensions ===============================================================================
class Array
  def mean
    self.inject(0){ |sum, x| sum += x } / self.size.to_f
  end

  def count
    self.size
  end

end

# Enumerable Extensions ==========================================================================
module Enumerable
  def to_histogram
    inject(Hash.new(0)) { |h,x| h[x] += 1; h }
  end
end

# Fixnum Extensions ==============================================================================
class Fixnum

  # Given a number of seconds, convert into a string like HH:MM:SS
  def to_hrs_mins_secs
    _now = DateTime.now
    _d = Date::day_fraction_to_time((_now + self.seconds) - _now)
    "#{sprintf('%02d',_d[0])}:#{sprintf('%02d',_d[1])}:#{sprintf('%02d',_d[2])}"
  end
end

# Float Extensions ===============================================================================
class Float
  def to_nearest_tenth
    sprintf("%.1f", self).to_f
  end
end

# Hash Extensions ================================================================================
class Hash
  def to_params
    params = ''
    stack = []

    each do |k, v|
      if v.is_a?(Hash)
        stack << [k,v]
      elsif v.is_a?(Array)
        stack << [k,Hash.from_array(v)]
      else
        params << "#{k}=#{v}&"
      end
    end

    stack.each do |parent, hash|
      hash.each do |k, v|
        if v.is_a?(Hash)
          stack << ["#{parent}[#{k}]", v]
        else
          params << "#{parent}[#{k}]=#{v}&"
        end
      end
    end

    params.chop!
    params
  end

  def to_sql( operator = 'AND' )
    _sql = self.keys.map do |_key|
      _value = self[_key].is_a?(Fixnum) ? self[_key] : "'#{self[_key]}'"
      self[_key].nil? ? '1 = 1' : "#{_key} = #{_value}"
    end
    _sql * " #{operator} "
  end

  def self.from_array(array = [])
    h = Hash.new
    array.size.times{ |t| h[t] = array[t] }
    h
  end

end

# SOAP Extensions ================================================================================
class Header < SOAP::Header::SimpleHandler
  def initialize(tag, value)
    super(XSD::QName.new(nil, tag))
    @tag = tag
    @value = value
  end

  def on_simple_outbound
    @value
  end
end

