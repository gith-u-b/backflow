require 'swagger_helper'

RSpec.describe 'api/v1/registrations', type: :request do
  let(:user) { create(:user) }

  path '/api/v1/signup' do

    post('create registration') do
      tags 'Registrations'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :signup, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          password: { type: :string },
          confirmation_password: { type: :string }
        },
        required: [ 'username', 'password' ]
      }
  
      response '200', 'Invalid password' do
        let(:signup) { { username: Faker::Name.name, password: '-', confirmation_password: '-' } }
        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['success']).to eq(false)
          expect(data['message']).to eq(I18n.t("api.invalid_password"))
        end
      end

      response '200', 'Password not match' do
        let(:signup) { { username: Faker::Name.name, password: '123', confirmation_password: '1234' } }
        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['success']).to eq(false)
          expect(data['message']).to eq(I18n.t("api.password_is_not_match"))
        end
      end

      response '200', 'Username already exist' do
        let(:signup) { { username: user.username, password: '123', confirmation_password: '123' } }
        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['success']).to eq(false)
          expect(data['message']).to eq(I18n.t("api.username_already_exist"))
        end
      end
    end
  end
end
