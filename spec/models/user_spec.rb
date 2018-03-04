require "rails_helper"

describe "User" do
  before(:all) do
    @hotel = Hotel.new("name":"Miramare","country_code":"IT","average_price":500)
    @hotel.save
    @user = User.new({"first_name":"Mario", "last_name":"Rossi", "email":"m.rossi@gmail.com", "password":"test123", "language":"it"})
    @user.save
  end

  describe 'password is properly encrypted and stored' do
    it 'crypts a password with a random salt' do
      expect(@user.password).not_to eql("test123")
    end

    it 'check if password is properly stored' do
      expect(@user.password_correct?("test123")).to be_truthy
    end
  end

  describe 'users are managers as well' do
    it "#is_manager" do
      @user.hotels << @hotel
      expect(@user.is_manager?).to be_truthy
    end

    it "with no hotels, user is not a manager" do
      expect(@user.is_manager?).to be_falsy
    end

    it "#is_hotel_manager?" do
      @user.hotels << @hotel
      expect(@user.is_hotel_manager? @hotel.id).to be_truthy
    end
  end

  after(:all) do
    @hotel.destroy
    @user.destroy
  end
end