require 'spec_helper'

describe "foos/new.html.erb" do
  before(:each) do
    assign(:foo, stub_model(Foo,
      :new_record? => true,
      :name => "MyString",
      :active => false,
      :style => "MyString"
    ))
  end

  it "renders new foo form" do
    render

    rendered.should have_selector("form", :action => foos_path, :method => "post") do |form|
      form.should have_selector("input#foo_name", :name => "foo[name]")
      form.should have_selector("input#foo_active", :name => "foo[active]")
      form.should have_selector("select#foo_style", :name => "foo[style]")
    end
  end
end
