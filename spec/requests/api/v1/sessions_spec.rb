require 'swagger_helper'

RSpec.describe 'api/v1/sessions', type: :request do
  let(:user) { create(:user) }
  let(:disabe_user) { create(:disabe_user) }

  # before do
  #   puts "Created user: #{user.username}, password: #{user.password}"
  # end

  path '/api/v1/signin' do

    post('Create session') do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :signin, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          password: { type: :string }
        },
        required: [ 'username', 'password' ]
      }

      response '200', 'signed in' do
        let(:signin) { { username: user.username, password: user.password } }
        run_test!
      end

      response '200', 'User does not exist' do
        let(:signin) { { username: Faker::Name.name, password: user.password } }
        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['success']).to eq(false)
          expect(data['message']).to eq(I18n.t("api.user_does_not_exist"))
          expect(data['error_code']).to eq(1)
        end
      end

      response '200', 'Invalid password' do
        let(:signin) { { username: user.username, password: 'invalidpassword' } }
        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['success']).to eq(false)
          expect(data['message']).to eq(I18n.t("api.invalid_username_or_password"))
          expect(data['error_code']).to eq(2)
        end
      end

      response '200', 'Username is disabled' do
        let(:signin) { { username: disabe_user.username, password: disabe_user.password } }
        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['success']).to eq(false)
          expect(data['message']).to eq(I18n.t("api.username_is_disable"))
          expect(data['error_code']).to eq(3)
        end
      end
    end

  end
end