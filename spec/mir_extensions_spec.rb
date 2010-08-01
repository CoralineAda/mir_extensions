require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MirExtensions" do

  describe 'class methods' do
  
    describe 'state codes' do
    
      it 'returns the state code for a given state' do
        MirExtensions.state_code_for('Virginia').should == 'VA'
      end
      
      it 'returns the state for a given state code' do
        MirExtensions.state_name_for('VA').should == 'Virginia'
      end
      
      it 'handles failures gracefully' do
        MirExtensions.state_name_for('XX').should be_nil
      end
      
    end
    
    it 'returns the month name for a month number' do
      MirExtensions.month_name_for(0).should == 'JAN'
    end
    
    it 'returns a canonical URL' do
      MirExtensions.canonical_url('cnn.com').should == 'cnn.com/'
    end
  
    it 'normalizes slugs' do
      MirExtensions.normalize_slug('!@#$%^&*()').should == ''
      MirExtensions.normalize_slug('abcdefghijklmnopqrstuvwxyz').should == 'abcdefghijklmnopqrstuvwxyz'
      MirExtensions.normalize_slug('ABCDEFGHIJKLMNOPQRSTUVWXYZ').should == 'abcdefghijklmnopqrstuvwxyz'
      MirExtensions.normalize_slug('0123456789').should == '0123456789'
      MirExtensions.normalize_slug('mir-utility').should == 'mir-utility'
      MirExtensions.normalize_slug('mir--utility').should == 'mir-utility'
      MirExtensions.normalize_slug('mir-utility').should == 'mir-utility'
      MirExtensions.normalize_slug('mir-utility/index//').should == 'mir-utility-index'
    end

  end
  
  describe 'string extensions' do

    it 'formats phone numbers' do
      '3125555252'.to_phone.should == '312-555-5252'
    end
  
    it 'formats phone numbers, accepting options' do
      '3125555252'.to_phone(:area_code => true).should == '(312) 555-5252'
    end
  
  end
 
  it 'formats phone numbers' do
    ''.number_to_phone('5168675309').should == '516-867-5309'
  end

  it 'formats phone numbers with separate area codes' do
    '5168675309'.formatted_phone.should == '(516) 867-5309'
  end

  it 'handles invalid phone numbers gracefully' do
    'Alphabet Soup'.formatted_phone.should == 'Alphabet Soup'
    'Transylvania 6-5000'.formatted_phone.should == 'Transylvania 6-5000'
    '123-45-6789'.formatted_phone.should == '123-45-6789'
  end

  it 'formats zip codes' do
    '205000003'.formatted_zip.should == '20500-0003'
  end

  it 'calculates arithmetic means' do
    _a = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
    _a.mean.should == (_a.sum.to_f/_a.size.to_f).to_f
  end

  it 'aliases count to size' do
    _a = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
    _a.count.should == _a.size
  end

  it 'converts seconds to hours:minutes:seconds' do
    86400.to_hrs_mins_secs.should == '24:00:00'
  end

  it 'rounds to the nearest tenth' do
    Math::PI.to_nearest_tenth.should == 3.1
  end

  it 'converts active records to an array of name-value pairs suitable for select tags' do
    Primary.stubs(:all).returns([Primary.new(:name => 'Admin'), Primary.new(:name => 'User')])
    Primary.to_option_values.should == [ ['Admin', nil], ['User', nil] ]
  end

  it 'strips the values of specified attributes' do
    p = Primary.new(:name => ' foo bar  ')
    p.strip(:name)
    p.name.should == 'foo bar'
  end

  it 'converts arrays to a histogram hash' do
    [:r, :r, :o, :y, :g, :b, :i, :v, :v, :o].to_histogram.should == {:o=>2, :g=>1, :v=>2, :r=>2, :i=>1, :y=>1, :b=>1}
  end

  it 'converts a hash to HTTP parameters' do
    _return = {
      :string => 1,
      :array => [2, 3],
      :hash => {
        :a => 4,
        :b => {
          :c => 5
        }
      }
    }.to_params

    _return.include?('string=1').should be_true
    _return.include?('array[0]=2&array[1]=3').should be_true
    _return.include?('hash[a]=4').should be_true
    _return.include?('hash[b][c]=5').should be_true
  end

  it 'converts a hash to SQL conditions' do
    _hash = {
      :first_name => 'Quentin',
      :last_name => 'Tarantino'
    }
    _hash.to_sql.should =~ /first_name = 'Quentin'/
    _hash.to_sql.should =~ /last_name = 'Tarantino'/
    _hash.to_sql.should =~ / AND /
  end

  it 'initializes SOAP headers' do
    _control = {
      :tag => '',
      :value => ''
    }
    _header = Header.new( _control[:tag], _control[:value] )
    _header.on_simple_outbound.should == _control[:value]
  end

  it 'capitalizes words without omitting characters like titleize' do
    'vice-president of the united states of america'.capitalize_words.should == 'Vice-President Of The United States Of America'
  end

  it 'expands address abbreviations' do
    _control = {
      '1600 Pennsylvania Av' => '1600 Pennsylvania Avenue',
      '1600 Pennsylvania Av.' => '1600 Pennsylvania Avenue',
      '1600 Pennsylvania Ave' => '1600 Pennsylvania Avenue',
      '1600 Pennsylvania Ave.' => '1600 Pennsylvania Avenue',
      '77 Sunset Bl' => '77 Sunset Boulevard',
      '77 Sunset Bl.' => '77 Sunset Boulevard',
      '77 Sunset Bld' => '77 Sunset Boulevard',
      '77 Sunset Bld.' => '77 Sunset Boulevard',
      '77 Sunset Blv' => '77 Sunset Boulevard',
      '77 Sunset Blv.' => '77 Sunset Boulevard',
      '77 Sunset Blvd' => '77 Sunset Boulevard',
      '77 Sunset Blvd.' => '77 Sunset Boulevard',
      '10 Columbus Cr' => '10 Columbus Circle',
      '10 Columbus Cr.' => '10 Columbus Circle',
      '10 Lincoln Ctr Plz' => '10 Lincoln Center Plaza',
      '10 Lincoln Ctr. Plz.' => '10 Lincoln Center Plaza',
      '157 King Arthur Ct' => '157 King Arthur Court',
      '157 King Arthur Ct.' => '157 King Arthur Court',
      '157 King Arthur Crt' => '157 King Arthur Court',
      '157 King Arthur Crt.' => '157 King Arthur Court',
      '680 N Lake Shore Dr' => '680 North Lake Shore Drive',
      '680 N. Lake Shore Dr.' => '680 North Lake Shore Drive',
      '8900 Van Wyck Expy' => '8900 Van Wyck Expressway',
      '8900 Van Wyck Expy.' => '8900 Van Wyck Expressway',
      '8900 Van Wyck Expw' => '8900 Van Wyck Expressway',
      '8900 Van Wyck Expw.' => '8900 Van Wyck Expressway',
      '8900 Van Wyck Expressw' => '8900 Van Wyck Expressway',
      '8900 Van Wyck Expressw.' => '8900 Van Wyck Expressway',
      '837 E Magical Frwy' => '837 East Magical Freeway',
      '837 E. Magical Frwy.' => '837 East Magical Freeway',
      '750 W Sunrise Hwy' => '750 West Sunrise Highway',
      '750 W. Sunrise Hwy.' => '750 West Sunrise Highway',
      '9264 Penny Ln' => '9264 Penny Lane',
      '9264 Penny Ln.' => '9264 Penny Lane',
      '10099 Ridge Gate Pky Ste 200' => '10099 Ridge Gate Parkway Suite 200',
      '10099 Ridge Gate Pky. Ste. 200' => '10099 Ridge Gate Parkway Suite 200',
      '10099 Ridge Gate Pkw Suite 200' => '10099 Ridge Gate Parkway Suite 200',
      '10099 Ridge Gate Pkw. Suite 200' => '10099 Ridge Gate Parkway Suite 200',
      '10099 Ridge Gate Pkwy Suite 200' => '10099 Ridge Gate Parkway Suite 200',
      '10099 Ridge Gate Pkwy. Suite 200' => '10099 Ridge Gate Parkway Suite 200',
      '10099 Ridge Gate Prkwy Suite 200' => '10099 Ridge Gate Parkway Suite 200',
      '10099 Ridge Gate Prkwy. Suite 200' => '10099 Ridge Gate Parkway Suite 200',
      "5137 Zebulon's Pk" => "5137 Zebulon's Pike",
      "5137 Zebulon's Pk." => "5137 Zebulon's Pike",
      "King's Plz" => "King's Plaza",
      "King's Plz." => "King's Plaza",
      '4616 Melrose Pl' => '4616 Melrose Place',
      '4616 Melrose Pl.' => '4616 Melrose Place',
      '93812 S Hightower Rd' => '93812 South Hightower Road',
      '93812 S. Hightower Rd.' => '93812 South Hightower Road',
      '249 NE Rural Rt' => '249 Northeast Rural Route',
      '249 N.E. Rural Rt.' => '249 Northeast Rural Route',
      '249 NE Rural Rte' => '249 Northeast Rural Route',
      '249 N.E. Rural Rte.' => '249 Northeast Rural Route',
      '1 SW Main St' => '1 Southwest Main Street',
      '1 S.W. Main St.' => '1 Southwest Main Street',
      '1935 SE Trpk' => '1935 Southeast Turnpike',
      '1935 S.E. Trpk.' => '1935 Southeast Turnpike',
      '369 NW Army Tr' => '369 Northwest Army Trail',
      '369 N.W. Army Tr.' => '369 Northwest Army Trail'
    }
    _control.keys.each do |_key|
      _key.expand_address_abbreviations.should == _control[_key]
    end
  end

  it 'converts 24-hour time' do
    '18:20'.to_12_hour_time == '6:20 PM'
  end

  it 'adds the HTTP-protocol prefix' do
    'www.seologic.com'.add_http_prefix.should == 'http://www.seologic.com'
    'ftp.seologic.com'.add_http_prefix.should == 'http://ftp.seologic.com'
    'ftp://ftp.seologic.com'.add_http_prefix.should == 'ftp://ftp.seologic.com'
    'http://'.add_http_prefix.should == 'http://'
  end

  it 'detects HTTP URLs' do
    'http://www.seologic.com/'.valid_http_url?.should be_true
    'https://www.seologic.com/'.valid_http_url?.should be_true
    'www.seologic.com'.valid_http_url?.should be_false
  end

  it 'detects trailing slashes' do
    'www.seologic.com'.has_http?.should be_false
    'www.seologic.com/'.has_trailing_slash?.should be_true
    'www.seologic.com/index'.has_trailing_slash?.should be_false
    'www.seologic.com/users/'.has_trailing_slash?.should be_true
  end

  it 'detects page URLs' do
    'www.seologic.com'.is_page?.should be_false
    'www.seologic.com/index'.is_page?.should be_false
    'www.seologic.com/index.cgi'.is_page?.should be_false
    'www.seologic.com/index.htm'.is_page?.should be_true
    'www.seologic.com/index.html'.is_page?.should be_true
  end

  it 'returns the host of a valid URI string' do
    'www.seologic.com'.to_host.should be_nil
    'www.seologic.com/webmaster-tools/link-popularity-check.php'.to_host.should be_nil
    'http://www.seologic.com'.to_host.should == 'www.seologic.com'
    'http://www.seologic.com/webmaster-tools/link-popularity-check.php'.to_host.should == 'www.seologic.com'
  end

  it 'converts a URI string to a URI object' do
    'www.seologic.com'.to_uri.is_a?(URI).should be_true
    'http://www.seologic.com'.to_uri.is_a?(URI::HTTP).should be_true
    'SEO Logic'.to_uri.should be_nil
  end

  it 'detects a valid HTTP URL' do
    'www.seologic.com'.valid_http_url?.should be_false
    'http://'.valid_http_url?.should be_false
    'http://www.seologic.com'.valid_http_url?.should be_true
    'http://http://www.seologic.com'.valid_http_url?.should be_false
    'SEO Logic'.valid_http_url?.should be_false
  end

end
