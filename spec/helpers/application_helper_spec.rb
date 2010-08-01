require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do

  it 'loads' do
    ApplicationHelper::SELECT_PROMPT.should == 'Select...'    
  end
  
  it 'has methods' do
    ApplicationHelper.array_to_lines([:a, :b, :c]).should == 'a<br />b<br />c'
  end
  
#   it 'detects its action' do
#     _controller = Object.new
#     _controller.stubs(:action_name).returns('index')
#     self.stubs(:controller).returns(_controller)
#     self.action?('index').should be_true
#     self.action?('destroy').should be_false
#     self.action?(/index|show/).should be_true
#   end
# 
#   it 'formats arrays as HTML lines' do
#     self.array_to_lines([:a, :b, :c]).should == 'a<br />b<br />c'
#   end
# 
#   it 'returns a check-mark div' do
#     self.checkmark.should == '<div class="checkmark"></div>'
#   end
# 
#   it 'detects its action' do
#     _controller = Object.new
#     _controller.stubs(:controller_name).returns('home')
#     self.stubs(:controller).returns(_controller)
#     self.controller?('home').should be_true
#     self.controller?('primary').should be_false
#     self.controller?(/home|primary/).should be_true
#  end
    
end
