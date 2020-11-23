require "test_helper"

describe MerchantsController do
  describe "auth_callback" do
    it "logs in an existing merchant and redirects to the root path" do
      start_count = Merchant.count
      merchant = merchants(:merchant1)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))

      get auth_callback_path(:github)

      must_redirect_to root_path

      expect(session[:user_id]).must_equal merchant.id
      expect(Merchant.count).must_equal start_count
    end

    it "creates a new user and redirects to the root path" do
      start_count = Merchant.count
      new_merchant = Merchant.new(provider: "github", uid: 99999, username: "test_user", email: "test@user.com")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_merchant))
      get auth_callback_path(:github)

      must_redirect_to root_path

      expect(Merchant.count).must_equal start_count + 1
      expect(session[:user_id]).must_equal Merchant.last.id
    end

    it "redirects to the root path if given invalid user data" do
      start_count = Merchant.count
      new_merchant = Merchant.new(provider: "github", uid: nil, username: "test_user", email: "test@user.com")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(new_merchant))
      get auth_callback_path(:github)

      must_redirect_to root_path

      new_merchant = Merchant.find_by(uid: new_merchant.uid, provider: new_merchant.provider)
      expect(new_merchant).must_be_nil
      expect(Merchant.count).must_equal start_count
      expect(session[:user_id]).must_be_nil
    end
  end

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

    it "must redirect if merchant does not exist" do
      get merchant_path(-1)
      must_respond_with :redirect
      must_redirect_to merchants_path
    end
  end

  describe "dashboard" do
    it "cannot get the dashboard page if not logged in" do
      get dashboard_path
      must_respond_with :redirect
    end

    it "can get the dashboard page if logged in" do
      perform_login

      get dashboard_path
      must_respond_with :success
    end
  end

  # TODO
  describe "create" do
    skip
  end

  describe "logout" do
    it "must redirect to root path and clear session user_id" do
      perform_login

      post logout_path
      must_respond_with :redirect
      must_redirect_to root_path

      expect(session[:user_id]).must_be_nil
    end
  end
end
