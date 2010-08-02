require 'spec_helper'

describe "foos/show.html.erb" do
  before(:each) do
    @foo = assign(:foo, stub_model(Foo,
      :name => "Name",
      :active => false,
      :style => "Style"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Name".to_s)
    rendered.should contain(false.to_s)
    rendered.should contain("Style".to_s)
  end
end
