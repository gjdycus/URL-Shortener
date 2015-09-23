class Course < ActiveRecord::Base

  has_many :enrollments,
    class_name: "Enrollment",
    foreign_key: :course_id,
    primary_key: :id

  has_one :prerequisite,
    class_name: "Course",
    foreign_key: :id,
    primary_key: :prereq_id

  has_many :users, through: :enrollments

  has_one :instructor,
    class_name: "User",
    foreign_key: :id,
    primary_key: :instructor_id

  alias enrolled_students users
end
