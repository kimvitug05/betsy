require "test_helper"


describe MerchantsController do
  describe "login" do
    it "can log in an existing user" do
      user = perform_login(merchants(:neopetsy))

      must_respond_with :redirect
    end
  end

  it "must get index" do
    get merchants_index_url
    must_respond_with :success
  end

  it "must get show" do
    get merchants_show_url
    must_respond_with :success
  end

  describe "current" do
    it "returns 200 OK for a logged-in user" do
      #Arrange
      perform_login

      #Act
      get current_user_path

      #Assert
      must_respond_with :success
    end
  end
end
