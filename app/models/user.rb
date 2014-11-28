class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
	validates :name, presence: true

  has_many(:submitted_urls, class_name: 'ShortenedUrl',
           foreign_key: :submitter_id, primary_key: :id, dependent: :destroy)

  has_many(:visits, class_name: "Visit", foreign_key: :visitor_id,
            primary_key: :id)
  has_many :visited_urls, -> { distinct }, through: :visits, source: :shortened_url

  def recent_submissions
    submitted_urls.where(created_at: 1.minute.ago..Time.now)
  end
end