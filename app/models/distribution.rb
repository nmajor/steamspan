class Distribution < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  mount_uploader :image, ImageUploader

  def self.get_within_limits min
    where('distributions.minutes < ?', min).order("RANDOM()").first
  end

  def description_with_num min
    description.gsub('[num]', number_with_delimiter((min / minutes).to_s))
  end
end
