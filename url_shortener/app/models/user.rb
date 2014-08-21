# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  
  has_many(
    :submitted_urls, 
    class_name: "ShortenedUrl", 
    foreign_key: :submitter_id,
    primary_key: :id
  )
  
  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :visitor_id,
    primary_key: :id
  )

  has_many :visited_urls, Proc.new { distinct }, :through => :visits, :source => :shortened_url
end
