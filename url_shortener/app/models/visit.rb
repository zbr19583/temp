class Visit < ActiveRecord::Base
  validates :short_url_id, :visitor_id, presence: true

  belongs_to(
    :shortened_url,
    class_name: "ShortenedUrl",
    foreign_key: :short_url_id,
    primary_key: :id
  )
  
  belongs_to(
    :visitor,
    class_name: "User",
    foreign_key: :visitor_id,
    primary_key: :id
  )
  
  def self.record_visit!(user, shortened_url)
    self.create!(short_url_id: shortened_url.id, visitor_id: user.id)
  end

end