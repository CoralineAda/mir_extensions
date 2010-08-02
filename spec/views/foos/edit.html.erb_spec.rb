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
      form.should have_selector("input#foo_name", :name => "foo[name]")
      form.should have_selector("input#foo_active", :name => "foo[active]")
      form.should have_selector("select#foo_style", :name => "foo[style]")
      form.should have_xpath("//select[@id='foo_style']/option", :value => 'Select...')
    end
  end

  it 'renders a text field with a default label' do
    render
    rendered.should have_selector("form", :action => foo_path(@foo), :method => "post") do |form|
      form.should have_xpath("//label[@for='foo_name']", :content => 'Name')
      form.should have_selector("input#foo_name", :name => "foo[name]")
    end
  end

  it 'renders a field with a custom label' do
    render
    rendered.should have_selector("form", :action => foo_path(@foo), :method => "post") do |form|
      form.should have_xpath("//label[@for='foo_active']", :content => 'Status')
    end
  end
  
  it 'renders an inline label for a checkbox' do
    render
    rendered.should have_selector("form", :action => foo_path(@foo), :method => "post") do |form|
      form.should have_xpath("//label[@for='foo_active']", :content => 'Active', :class => 'inline')
    end
  end

  it 'renders a select control with a default option' do
    render
    rendered.should have_selector("form", :action => foo_path(@foo), :method => "post") do |form|
      form.should have_xpath("//select[@id='foo_style']/option", :value => 'Select...')
    end
  end
  
  it 'renders a date select' do
    render
    rendered.should have_selector("form", :action => foo_path(@foo), :method => "post") do |form|
      form.should have_xpath("//select/option", :content => 'January')
      form.should have_xpath("//select/option", :content => '1')
      form.should have_xpath("//select/option", :content => '2010')
    end
  end
end
