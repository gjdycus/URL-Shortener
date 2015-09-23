class User < ActiveRecord::Base

  validates :email, uniqueness: true, presence: true

  has_many :submitted_urls,
    class_name: "ShortenedUrl",
    foreign_key: :submitter_id,
    primary_key: :id

  has_many :visits,
    class_name: "Visit",
    foreign_key: :user_id,
    primary_key: :id

  has_many :shortened_urls, through: :visits

  alias visited_urls shortened_urls

  has_many :distinct_visited_urls,
    -> { distinct },
    through: :visits,
    source: :shortened_url

  has_many :votes,
    class_name: "Vote",
    foreign_key: :user_id,
    primary_key: :id

  def upvote(link)
    Vote.where(user_id: id, upvote: false, shortened_url_id: link.id).destroy_all
    Vote.create(user_id: id, shortened_url_id: link.id, upvote: true)
  end

  def downvote(link)
    Vote.where(user_id: id, upvote: true, shortened_url_id: link.id).destroy_all
    Vote.create(user_id: id, shortened_url_id: link.id, upvote: false)
  end


end
