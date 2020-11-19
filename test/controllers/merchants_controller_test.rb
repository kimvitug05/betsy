require "test_helper"

describe MerchantsController do
  describe "index" do
    it "must get index" do
      get merchants_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "must get show" do
      get merchant_path(merchants(:merchant1))
      must_respond_with :success
    end
  end

  describe "dashboard" do
    it "must get the dashboard page" do
      skip
    end
  end

  describe "create" do

  end

  describe "logout" do

  end
end
