class Vote < ActiveRecord::Base

  validates :upvote, inclusion: { in: [true,false] }

  validates :user_id, uniqueness: true

  def value
    upvote ? 1 : -1
  end

  belongs_to :user,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id


end
