class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user
  
  validates :user, :course, presence: true
  
  validates_uniqueness_of :user_id, scope: :course_id #user cant be subscribed to the same course twice
  validates_uniqueness_of :course_id, scope: :user_id #user cant be subscribed to the same course twice
  
  validate :cant_subscibe_to_own_course #user cant create subscription if course.user==current_user to the same course twice
  
    
  def to_s
    user
  end  
  
  protected
  def cant_subscibe_to_own_course
    if self.new_record?
      if self.user_id.presence?
        if user_id==course.user_id
          errors.add(:base, "You can not subscribe to your own course")
        end
      end  
    end  
  end
end