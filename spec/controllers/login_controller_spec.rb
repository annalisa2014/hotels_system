require 'rails_helper'

describe LoginController do
  before(:all) do
    @user = User.new({:first_name => "Mario", :last_name => "Rossi", :email => "m.rossi@gmail.com", :password => "password", :language => "it"})
    @user.save
  end

  describe 'POST #login' do
    it "returns 401 if wrong credentials are given" do
      post :login, { email: "m.rossi@gmail.com", password: "password123"}, format: :json
      expect(response.status).to eq(401)
    end

    it "returns 200 is correct credentials are given" do
      post :login, { email: "m.rossi@gmail.com", password: "password"}, format: :json
      expect(response.status).to eq(200)
    end
  end

  after(:all) do
    @user.destroy
  end
end