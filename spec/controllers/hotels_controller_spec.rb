require 'rails_helper'

describe HotelsController do
  before(:all) do
    @hotel = Hotel.new("name":"Miramare","country_code":"IT","average_price":500)
    @hotel.save
    @user = User.new("first_name":"Mario", "last_name":"Rossi", "email":"m.rossi@gmail.com", "password":"password", "language":"it")
    @user.save
  end

  describe 'GET #index' do
    it "returns 401 if no authentication token" do
      @user.add_managed_hotel @hotel
      get :index, format: :json
      expect(response.status).to eq(401)
    end

    context "returning hotel data" do
      it "returns 200 and hotels list with authentication token" do
        @user.add_managed_hotel @hotel
        get :index, format: :json
        expect(response.status).to eq(401)
      end
    end

  end

  describe 'GET #show' do
    context "returns hotel data" do
      it "shows hotel data and increments views_count" do
        @user.add_managed_hotel @hotel
        controller.request.env['Accept-Language'] = 'it'
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)

        get :show, {id: @hotel.id}
        expect(response.status).to eq(200)
        expect(response.body).to include("\"views_count\":1")
      end
    end

    context "returns 403 when token is passed but user is not manager" do
      it "returns 403 if user is not manager of that hotel" do
        controller.request.env['Accept-Language'] = 'it'
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)

        get :show, {id: @hotel.id}
        expect(response.status).to eq(403)
      end
    end

    context "returns 401 if no token is passed" do
      it "returns 401" do
        @user.add_managed_hotel @hotel
        get :show, {id: @hotel.id}
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST #create' do
    it "returns 200 and creates new hotel" do
      controller.request.env['Accept-Language'] = 'it'
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)

      post :create, { name: "Esplanade", country_code: "IT", average_price: 200.0}, format: :json
      expect(response.status).to eq(200)
    end

    it "user gets manager of new hotel" do
      controller.request.env['Accept-Language'] = 'it'
      controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)

      post :create, { name: "Esplanade", country_code: "IT", average_price: 200.0}, format: :json
      response_json = JSON.parse(response.body)
      expect(@user.is_hotel_manager?(response_json['id'])).to be_truthy
    end

    it "returns 401 if no token is passed" do
      post :create, { name: "Esplanade", country_code: "IT", average_price: 200.0}, format: :json
      expect(response.status).to eq(401)
    end
  end

  describe 'PUT #update' do
    context "Cannot update hotel" do
      it "returns 403 if token is passed  but user is not manager of that hotel" do
        controller.request.env['Accept-Language'] = 'it'
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)

        put :update, {id: @hotel.id, name: "Miramare 2"}
        expect(response.status).to eq(403)
      end

      it "returns 401 if no token is passed" do
        put :update, { id: @hotel.id, name: "Miramare 2"}, format: :json
        expect(response.status).to eq(401)
      end
    end

    context "Properly updates hotel" do
      it "returns 200 and updates hotel" do
        @user.add_managed_hotel @hotel
        controller.request.env['Accept-Language'] = 'it'
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)

        put :update, { id: @hotel.id, name: "Miramare 2"}, format: :json
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'DELETE #destroy' do
    context "Cannot delete hotel" do
      it "returns 403 if token is passed  but user is not manager of that hotel" do
        controller.request.env['Accept-Language'] = 'it'
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)

        delete :destroy, {id: @hotel.id}
        expect(response.status).to eq(403)
      end

      it "returns 401 if no token is passed" do
        delete :destroy, { id: @hotel.id}, format: :json
        expect(response.status).to eq(401)
      end
    end

    context "Properly destroys hotel" do
      it "returns 200 and deletes hotel" do
        @user.add_managed_hotel @hotel
        controller.request.env['Accept-Language'] = 'it'
        controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(@user.token)

        delete :destroy, { id: @hotel.id}, format: :json
        expect(response.status).to eq(200)
      end
    end
  end

  after(:all) do
    @hotel.destroy
    @user.destroy
  end
end