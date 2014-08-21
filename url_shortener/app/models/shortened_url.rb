require 'securerandom'
class ShortenedUrl < ActiveRecord::Base
  include SecureRandom
  validates :short_url, presence: true, uniqueness: true
  
  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :short_url_id,
    primary_key: :id
  )

  has_many :visitors, Proc.new { distinct }, :through => :visits, :source => :visitor
  
  
  def self.random_code
    code = ""
    loop do 
      code = SecureRandom.urlsafe_base64
      break unless self.exists?(code)
    end
    code
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    self.create!(long_url: long_url, short_url: self.random_code, submitter_id: user.id)
  end
  
  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end
  
  def num_recent_uniques
    visits.select(:visitor_id).where(10.minutes.ago).distinct.count  
  end
end