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
 
 
end
