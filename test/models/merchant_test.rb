require "test_helper"

describe Merchant do
  before do
    @merchant = Merchant.create(email: "mkkr@123.com", username: "MKKRs")
  end

  it "is valid when all fields are filled" do

    #Act/Assert
    result = @merchant.valid?
    expect(result).must_equal true
  end

  it "is invalid without a username" do

    #Act/Assert
    @merchant.username = nil
    expect(@merchant.valid?).must_equal false
    expect(@merchant.errors.messages.include?(:username)).must_equal true
    expect(@merchant.errors.messages[:username].include?("can't be blank")).must_equal true

  end

  it "is invalid without an e-mail" do

    #Act/Assert
    @merchant.email = nil
    expect(@merchant.valid?).must_equal false
    expect(@merchant.errors.messages.include?(:email)).must_equal true
    expect(@merchant.errors.messages[:email].include?("can't be blank")).must_equal true

  end

  it "is invalid if email is improperly formatted" do

    #Act/Assert
    @merchant.email = "iamanemail.com"
    expect(@merchant.valid?).must_equal false
    expect(@merchant.errors.messages.include?(:email)).must_equal true
    expect(@merchant.errors.messages[:email].include?("is invalid")).must_equal true

  end
  it "fails validation when the username already exists" do

        #Act
        new_merchant = Merchant.create(username: @merchant.username, email: "im_good@email.com")

        #Assert
        expect(new_merchant.valid?).must_equal false
        expect(new_merchant.errors.messages.include?(:username)).must_equal true
        expect(new_merchant.errors.messages[:username].include?("has already been taken")).must_equal true
      end

  it "fails validation when the email already another_merchant" do
    #Act
    another_merchant = Merchant.create(username: "neopet_2020", email: @merchant.email)

    #Assert
    expect(another_merchant.valid?).must_equal false
    expect(another_merchant.errors.messages.include?(:email)).must_equal true
    expect(another_merchant.errors.messages[:email].include?("has already been taken")).must_equal true
  end
  
  #TODO - edge case for uid
#   it "requires a unique uid" do
#     dup = Merchant.new(username: "bob_belcher", provider: "github", uid: 12345, email: "bob@bob.com")
#     expect(dup.valid?).must_equal false
#     expect(dup.errors.messages).must_include :uid
#   end

#   describe "relations" do
#     it "has a list of products" do
#       expect(@merchant1).must_respond_to :products

#       #TODO - uncomment when products are created

#       # @merchant1.products.each do |product|
#       #   expect(product).must_be_kind_of Product
#       # end
#     end
end
