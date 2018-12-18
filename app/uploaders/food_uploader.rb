class FoodUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    '/images/fallback/' + [version_name, 'default.png'].compact.join('_')
  end
end
