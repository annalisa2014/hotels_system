require 'rails_helper'

describe UsersController do
  before(:all) do
    @user = User.new("first_name":"Mario", "last_name":"Rossi", "email":"m.rossi@gmail.com", "password":"password", "language":"it")
    @user.save
  end

  describe 'POST #create' do
    it "returns an authentication token" do
      post :create, { first_name: "User", last_name: "User", email: "user@example.com", password: "password", language: "it"}, format: :json
      expect(response.body).to be_an_instance_of(String)
      expect(response.body.length).to be(32)
    end

    it "returns an error if user is created with wrong parameters" do
      post :create, { first_name: "User", password: "password", language: "it"}, format: :json
      expect(response.body).to eql("[\"Last name can't be blank\",\"Email can't be blank\"]")
    end

    it 'returns 400 if attempting to create user with already taken email' do
      post :create, { first_name: "User", password: "password", language: "it", email: "m.rossi@gmail.com"}, format: :json
      expect(response.status).to eql(403)
    end
  end

  describe 'GET #index' do
    it "returns 200 if authentication token is passed" do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)
      get :index, format: :json
      expect(response.status).to eq(200)
    end

    it "returns 401 if user is not authenticaed" do
      get :index, format: :json
      expect(response.status).to eq(401)
    end
  end

  describe 'GET #show' do
    it "returns 200 if authentication token is passed" do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)
      get :show, {id: @user.id}, format: :json
      expect(response.status).to eq(200)
    end

    it "returns 401 if user is not authenticated" do
      get :show, {id: @user.id}, format: :json
      expect(response.status).to eq(401)
    end
  end

  describe 'PUT #update' do
    it "returns 200 with an authentication token" do
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)
      put :update, { id: @user.id, first_name: "Maria"}, format: :json
      expect(response.status).to eq(200)
    end

    it "returns 401 if no authentication token" do
      put :update, { id: @user.id, first_name: "Maria"}, format: :json
      expect(response.status).to eq(401)
    end
  end

  describe 'DELETE #destroy' do
    it "returns 401 if no token is passed" do
      delete :destroy, { id: @user.id}, format: :json
      expect(response.status).to eq(401)
    end

    it "returns 200 and deletes user" do
      controller.request.env['Accept-Language'] = 'it'
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)

      delete :destroy, { id: @user.id}, format: :json
      expect(response.status).to eq(200)
    end
  end

  after(:all) do
    @user.destroy
  end
end