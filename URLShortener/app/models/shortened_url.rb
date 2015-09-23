class ShortenedUrl < ActiveRecord::Base

  include SecureRandom

  validates :short_url, uniqueness: true, presence: true
  validates :long_url, uniqueness: true, presence: true, length: { maximum: 255 }
  validate :no_more_than_five_submissions_in_the_last_minute
  validate :non_premium_users_can_submit_max_5_urls

  belongs_to :user,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id

  has_many :visitors,
    through: :visits,
    source: :user

  has_many :uniq_visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user

  def self.random_code(long_url)
    loop do
      code = SecureRandom.urlsafe_base64
      return long_url[0..3] + code[0..6] unless self.exists?(short_url: code)
    end
  end

  def self.prune(n)
    self.where("created_at < ?", n.minutes.ago).destroy_all
  end

  def self.create_for_user_and_long_url!(user, long_url)
    self.create!(submitter_id: user.id, short_url: self.random_code(long_url), long_url: long_url)
  end

  def self.create_for_user_and_long_url(user, long_url)
    self.create(submitter_id: user.id, short_url: self.random_code(long_url), long_url: long_url)
  end


  def num_uniques
    uniq_visitors.count
  end

  def num_clicks
    visitors.count
  end

  def vote_count
    Vote.where(:shortened_url_id => id).map(&:value).inject(0,:+)
  end

  def num_recent_uniques
    Visit.select(:user_id).where("created_at > ?", 10.minutes.ago).where(shortened_url_id: self.id).uniq.count
  end

  private

  def no_more_than_five_submissions_in_the_last_minute
    if ShortenedUrl.where("created_at > ?", 1.minute.ago).where(submitter_id: submitter_id).count >= 5
      errors[:submission] << "Can't create more than 5 URLs in one minute"
    end
  end

  def non_premium_users_can_submit_max_5_urls
    if ShortenedUrl.where(submitter_id: submitter_id).count >= 5 && User.find(submitter_id).premium == false
      errors[:submission] << "Cannot add more urls without premium!"
    end
  end

end
