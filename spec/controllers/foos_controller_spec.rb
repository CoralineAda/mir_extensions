require 'spec_helper'

describe FoosController do

  def mock_foo(stubs={})
    @mock_foo ||= mock_model(Foo, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all foos as @foos" do
      Foo.stub(:all) { [mock_foo] }
      get :index
      assigns(:foos).should eq([mock_foo])
    end
  end

  describe "GET show" do
    it "assigns the requested foo as @foo" do
      Foo.stub(:find).with("37") { mock_foo }
      get :show, :id => "37"
      assigns(:foo).should be(mock_foo)
    end
  end

  describe "GET new" do
    it "assigns a new foo as @foo" do
      Foo.stub(:new) { mock_foo }
      get :new
      assigns(:foo).should be(mock_foo)
    end
  end

  describe "GET edit" do
    it "assigns the requested foo as @foo" do
      Foo.stub(:find).with("37") { mock_foo }
      get :edit, :id => "37"
      assigns(:foo).should be(mock_foo)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created foo as @foo" do
        Foo.stub(:new).with({'these' => 'params'}) { mock_foo(:save => true) }
        post :create, :foo => {'these' => 'params'}
        assigns(:foo).should be(mock_foo)
      end

      it "redirects to the created foo" do
        Foo.stub(:new) { mock_foo(:save => true) }
        post :create, :foo => {}
        response.should redirect_to(foo_url(mock_foo))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved foo as @foo" do
        Foo.stub(:new).with({'these' => 'params'}) { mock_foo(:save => false) }
        post :create, :foo => {'these' => 'params'}
        assigns(:foo).should be(mock_foo)
      end

      it "re-renders the 'new' template" do
        Foo.stub(:new) { mock_foo(:save => false) }
        post :create, :foo => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested foo" do
        Foo.should_receive(:find).with("37") { mock_foo }
        mock_foo.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :foo => {'these' => 'params'}
      end

      it "assigns the requested foo as @foo" do
        Foo.stub(:find) { mock_foo(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:foo).should be(mock_foo)
      end

      it "redirects to the foo" do
        Foo.stub(:find) { mock_foo(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(foo_url(mock_foo))
      end
    end

    describe "with invalid params" do
      it "assigns the foo as @foo" do
        Foo.stub(:find) { mock_foo(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:foo).should be(mock_foo)
      end

      it "re-renders the 'edit' template" do
        Foo.stub(:find) { mock_foo(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested foo" do
      Foo.should_receive(:find).with("37") { mock_foo }
      mock_foo.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the foos list" do
      Foo.stub(:find) { mock_foo }
      delete :destroy, :id => "1"
      response.should redirect_to(foos_url)
    end
  end

end
