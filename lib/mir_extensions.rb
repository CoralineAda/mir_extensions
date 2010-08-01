require 'singleton'
require 'core_ext'
require 'friendly_id'

module MirExtensions

  include FriendlyId
  
  # Constants ======================================================================================
  
  MONTHS = {0 => "JAN", 1 => "FEB", 2 => "MAR", 3 => "APR", 4 => "MAY", 5 => "JUN", 6 => "JUL", 7 => "AUG", 8 => "SEP", 9 => "OCT", 10 => "NOV", 11 => "DEC"}

  STATE_CODES = { 'Alabama' => 'AL', 'Alaska' => 'AK', 'Arizona' => 'AZ', 'Arkansas' => 'AR', 'California' => 'CA', 'Colorado' => 'CO', 'Connecticut' => 'CT', 'Delaware' => 'DE', 'Florida' => 'FL', 'Georgia' => 'GA', 'Hawaii' => 'HI', 'Idaho' => 'ID', 'Illinois' => 'IL', 'Indiana' => 'IN', 'Iowa' => 'IA', 'Kansas' => 'KS', 'Kentucky' => 'KY', 'Louisiana' => 'LA', 'Maine' => 'ME', 'Maryland' => 'MD', 'Massachusetts' => 'MA', 'Michigan' => 'MI', 'Minnesota' => 'MN', 'Mississippi' => 'MS', 'Missouri' => 'MO', 'Montana' => 'MT', 'Nebraska' => 'NE', 'Nevada' => 'NV', 'New Hampshire' => 'NH', 'New Jersey' => 'NJ', 'New Mexico' => 'NM', 'New York' => 'NY', 'North Carolina' => 'NC', 'North Dakota' => 'ND', 'Ohio' => 'OH', 'Oklahoma' => 'OK', 'Oregon' => 'OR', 'Pennsylvania' => 'PA', 'Puerto Rico' => 'PR', 'Rhode Island' => 'RI', 'South Carolina' => 'SC', 'South Dakota' => 'SD', 'Tennessee' => 'TN', 'Texas' => 'TX', 'Utah' => 'UT', 'Vermont' => 'VT', 'Virginia' => 'VA', 'Washington' => 'WA', 'Washington DC' => 'DC', 'West Virginia' => 'WV', 'Wisconsin' => 'WI', 'Wyoming' => 'WY', 'Alberta' => 'AB', 'British Columbia' => 'BC', 'Manitoba' => 'MB', 'New Brunswick' => 'NB', 'Newfoundland and Labrador' => 'NL', 'Northwest Territories' => 'NT', 'Nova Scotia' => 'NS', 'Nunavut' => 'NU', 'Ontario' => 'ON', 'Prince Edward Island' => 'PE', 'Quebec' => 'QC', 'Saskatchewan' => 'SK', 'Yukon' => 'YT' }

  # General Utility Methods ========================================================================

  def self.canonical_url(url)
    (url + '/').gsub(/\/\/$/,'/')
  end

  def self.month_name_for(number)
    MONTHS[number]
  end

  def self.normalize_slug(text)
    _normalized = text.gsub(/[\W]/u, ' ').strip.gsub(/\s+/u, '-').gsub(/-\z/u, '').downcase.to_s
    _normalized.gsub!(/[-]+/, '-') # truncate multiple -
    _normalized
  end
  
  def self.state_code_for(state_name)
    STATE_CODES[state_name]
  end
  
  def self.state_name_for(abbreviation)
    STATE_CODES.invert[abbreviation]
  end
  
end
