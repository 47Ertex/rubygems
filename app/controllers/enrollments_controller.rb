class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy ]
  before_action :set_course, only: [:new, :create]

  # GET /enrollments or /enrollments.json
  def index
    @ransack_path=enrollments_path
    @q = Enrollment.ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    
    #@enrollments = Enrollment.all
    #@pagy, @enrollments = pagy(Enrollment.all)
    authorize @enrollments
  end

  def my_students
    @ransack_path=my_students_enrollments_path
    @q = Enrollment.joins(:course).where(courses: {user: current_user}).ransack(params[:q])
    @pagy,@enrollments = pagy(@q.result.includes(:user))
    render 'index'
  end  
  # GET /enrollments/1 or /enrollments/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{@enrollment.course.title}, #{@enrollment.user.email}",
        page_size: 'A4',
        template: "enrollments/show.pdf.haml",
        layout: "pdf.html.haml",
        orientation: "Landscape",
        lowquality: true,
        zoom: 1,
        dpi: 75
      end
    end
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
    authorize @enrollment
  end

  # POST /enrollments or /enrollments.json
  def create
    @enrollment=current_user.buy_course(@course)
    redirect_to course_path(@course), notice: "Вы стали падаваном"
    #EnrollmentMailer.student_enrollment(@enrollment).deliver_later
    #EnrollmentMailer.teacher_enrollment(@enrollment).deliver_later
    #if @course.price > 0
    #  flash[:alert] = "You can not access paid courses yet."
    #  redirect_to new_course_enrollment_path(@course)
    #else
    #  @enrollment=current_user.buy_course(@course)
    #  redirect_to course_path(@course), notice: "You are enrolled!!!!"
    #end  
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    authorize @enrollment
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    authorize @enrollment
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_course
      @course=Course.friendly.find(params[:course_id])  
    end
    
    def set_enrollment
      @enrollment = Enrollment.friendly.find(params[:id])
    end

    def enrollment_params
      params.require(:enrollment).permit(:rating, :review)
    end
end
