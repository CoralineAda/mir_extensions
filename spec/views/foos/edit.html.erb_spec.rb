require 'spec_helper'

describe "foos/edit.html.erb" do
  before(:each) do
    @foo = assign(:foo, stub_model(Foo,
      :new_record? => false,
      :name => "MyString",
      :active => false,
      :style => "MyString"
    ))
  end

  it "renders the edit foo form" do
    render

    rendered.should have_selector("form", :action => foo_path(@foo), :method => "post") do |form|
      form.should have_xpath("//label[@for='foo_name']", :content => 'Name')
      form.should have_selector("input#foo_name", :name => "foo[name]")
      form.should have_xpath("//label[@for='foo_active']", :content => 'Status')
      form.should have_xpath("//label[@for='foo_active']", :content => 'Active', :class => 'inline')
      form.should have_selector("input#foo_active", :name => "foo[active]")
      form.should have_selector("select#foo_style", :name => "foo[style]")
      form.should have_xpath("//select[@id='foo_style']/options", :content => 'Select...')
    end
  end

end
