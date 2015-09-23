class User < ActiveRecord::Base

  has_many :enrollments,
    class_name: "Enrollment",
    foreign_key: :student_id,
    primary_key: :id

  has_many :courses, through: :enrollments

  alias enrolled_courses courses
end
