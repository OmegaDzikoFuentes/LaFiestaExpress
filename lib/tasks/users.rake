# lib/tasks/users.rake
namespace :users do
    task generate_api_tokens: :environment do
      User.find_each do |user|
        user.update!(api_token: SecureRandom.urlsafe_base64(32)) unless user.api_token
      end
    end
  end
