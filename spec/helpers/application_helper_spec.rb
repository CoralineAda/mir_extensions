require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  
  it 'detects its action' do
    _controller = Object.new
    _controller.stubs(:action_name).returns('index')
    controller.stubs(:controller).returns(_controller)
    controller.action?('index').should be_true
    controller.action?('destroy').should be_false
    controller.action?(/index|show/).should be_true
  end

  it 'formats arrays as HTML lines' do
    controller.array_to_lines([:a, :b, :c]).should == 'a<br />b<br />c'
  end

  it 'returns a check-mark div' do
    controller.checkmark.should == '<div class="checkmark"></div>'
  end

  it 'detects its action' do
    _controller = Object.new
    _controller.stubs(:controller_name).returns('home')
    controller.stubs(:controller).returns(_controller)
    controller.controller?('home').should be_true
    controller.controller?('primary').should be_false
    controller.controller?(/home|primary/).should be_true
 end

  it 'returns an options string with the default select prompt' do
    controller.options_for_array([['1', 'Option 1'], ['2', 'Option 2'], ['3', 'Option 3']]).should == "#{controller.select_prompt_option}<option value=\"1\" >Option 1</option><option value=\"2\" >Option 2</option><option value=\"3\" >Option 3</option>"
  end

  it 'returns an options string with the default select prompt and a default value' do
    controller.options_for_array([['1', 'Option 1'], ['2', 'Option 2'], ['3', 'Option 3']], '2').should == "#{controller.select_prompt_option}<option value=\"1\" >Option 1</option><option value=\"2\" selected=\"1\">Option 2</option><option value=\"3\" >Option 3</option>"
  end

    
end
