require "carrierwave/storage/abstract"
require "carrierwave/storage/file"
require "carrierwave/storage/fog"

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    config.fog_provider = "fog/aws"
    config.fog_credentials = {
      :provider => "AWS",
      :aws_access_key_id => ENV["S3_KEY"],
      :aws_secret_access_key => ENV["S3_SECRET"],
      :region => ENV["S3_REGION"]
    }
    config.cache_dir = "#{Rails.root}/tmp/uploads" # To let CarrierWave work on heroku
    config.fog_directory    = ENV["S3_BUCKET_NAME"]
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end
