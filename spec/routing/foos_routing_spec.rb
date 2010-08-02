require "spec_helper"

describe FoosController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/foos" }.should route_to(:controller => "foos", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/foos/new" }.should route_to(:controller => "foos", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/foos/1" }.should route_to(:controller => "foos", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/foos/1/edit" }.should route_to(:controller => "foos", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/foos" }.should route_to(:controller => "foos", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/foos/1" }.should route_to(:controller => "foos", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/foos/1" }.should route_to(:controller => "foos", :action => "destroy", :id => "1")
    end

  end
end
