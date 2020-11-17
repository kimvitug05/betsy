require "test_helper"

describe ProductController do
  it "must get index" do
    get product_index_url
    must_respond_with :success
  end

  it "must get show" do
    get product_show_url
    must_respond_with :success
  end

  it "must get new" do
    get product_new_url
    must_respond_with :success
  end

  it "must get edit" do
    get product_edit_url
    must_respond_with :success
  end

  it "must get create" do
    get product_create_url
    must_respond_with :success
  end

  it "must get update" do
    get product_update_url
    must_respond_with :success
  end

  it "must get destroy" do
    get product_destroy_url
    must_respond_with :success
  end

end
