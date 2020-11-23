require "test_helper"

describe CategorizationsController do
  describe "index" do
    it "can get the index path" do
      get categorizations_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "can get the show path" do
      get categorization_path(categorizations(:kitchen))
      must_respond_with :success
    end
  end

  describe "new" do
    it "cannot get the new path as a guest user" do
      get new_categorization_path
      must_respond_with :redirect
    end

    it "can get the new path as a logged in user" do
      perform_login

      get new_categorization_path
      must_respond_with :success
    end
  end

  describe "create" do

    it "cannot create a new categorization as a guest user" do
      categorization_hash = {
        categorization: {
          name: "new task"
        },
      }

      expect {
        post categorizations_path, params: categorization_hash
      }.must_differ "Categorization.count", 0

      must_respond_with :redirect
      must_redirect_to root_path
    end

    it "can create a new categorization as a logged in user" do
      perform_login

      categorization_hash = {
          categorization: {
              name: "new task"
          },
      }

      expect {
        post categorizations_path, params: categorization_hash
      }.must_differ "Categorization.count", 1

      new_category = Categorization.find_by(name: categorization_hash[:categorization][:name])

      must_respond_with :redirect
      must_redirect_to categorization_path(new_category.id)
    end
  end
end
