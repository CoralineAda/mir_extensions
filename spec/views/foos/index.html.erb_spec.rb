require 'spec_helper'

describe "foos/index.html.erb" do
  before(:each) do
    assign(:foos, [
      stub_model(Foo,
        :name => "Name",
        :active => false,
        :style => "Style"
      ),
      stub_model(Foo,
        :name => "Name",
        :active => false,
        :style => "Style"
      )
    ])
  end

  it "renders a list of foos" do
    render
    rendered.should have_selector("tr>td", :content => "Name".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => false.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Style".to_s, :count => 2)
  end
end
