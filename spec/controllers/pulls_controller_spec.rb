require 'spec_helper'

describe PullsController do
  describe "#index" do
    get :index
    assigns(@pulls.should_not be_nil)
  end
end
