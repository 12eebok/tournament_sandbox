require "spec_helper"

describe Competitive::RegistrationsController do
  describe "routing" do

    it "routes to #index" do
      get("competitive/registrations").should route_to("competitive/registrations#index")
    end

    it "routes to #new" do
      get("competitive/registrations/new").should route_to("competitive/registrations#new")
    end

    it "routes to #show" do
      get("competitive/registrations/1").should route_to("competitive/registrations#show", :id => "1")
    end

    it "routes to #edit" do
      get("competitive/registrations/1/edit").should route_to("competitive/registrations#edit", :id => "1")
    end

    it "routes to #create" do
      post("competitive/registrations").should route_to("competitive/registrations#create")
    end

    it "routes to #update" do
      put("competitive/registrations/1").should route_to("competitive/registrations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("competitive/registrations/1").should route_to("competitive/registrations#destroy", :id => "1")
    end

  end
end
