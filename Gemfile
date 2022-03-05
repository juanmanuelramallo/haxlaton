source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

gem "aws-sdk-s3", require: false
gem "bootsnap", require: false
gem "chusaku"
gem "dotenv-rails"
gem "jbuilder"
gem "jsbundling-rails"
gem "pagy"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rack-cors"
gem "rails", "~> 7.0.2", ">= 7.0.2.2"
gem "redis", "~> 4.0"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
end

group :development do
  gem "web-console"
  gem "annotate"
end
