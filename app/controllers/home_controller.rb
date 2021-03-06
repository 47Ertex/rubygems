class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index, :privacy_policy] 
  def index
    @latest_goot_reviews=Enrollment.reviewed.latest_goot_reviews
    @latest = Course.latest.published.approved
    @top_rated=Course.top_rated.published.approved
    @popular=Course.popular.published.approved
    if current_user
      @purchased_courses=Course.joins(:enrollments).where(enrollments: {user: current_user}).order(created_at: :desc).limit(3)
      @created_courses = current_user.courses
    end
    @popular_tags=Tag.all.where.not(course_tags_count:0).order(course_tags_count: :desc).limit(10)
  end
  def activity
    if current_user.has_role?(:admin)
      @pagy, @activities = pagy(PublicActivity::Activity.all.order(created_at: :desc))
    else
      redirect_to root_path, alert: "Вы не авторизированы ждля доступа к этой станице" 
    end   
  end

  
  def analytics
    if current_user.has_role?(:admin)
      #@users=User.all
      #@enrollments=Enrollment.all
      #@courses=Course.all
    else
      redirect_to root_path, alert: "Вы не авторизированы ждля доступа к этой станице" 
    end  
  end  

  def privacy_policy
    
  end

end
