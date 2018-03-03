require "rails_helper"

describe "User" do
  describe 'password is properly encrypted and stored' do
    it 'crypts a password with a random salt' do
      expect(User.new.crypt_password("test123")).not_to eql("test123")
    end

    before(:example) do
      @user = User.new
      @user.crypt_password("test123")
    end

    it 'check if password is properly stored' do
      expect(@user.password_correct?("test123")).to be_truthy
    end
  end
end