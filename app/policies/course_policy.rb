class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def edit?
    #return true if @user.has_role?(:admin) || @user == @record.user
    @user.has_role?(:admin) || @record.user==@user
  end
  
  def update?
    #return true if @user.has_role?(:admin) || @user == @record.user
    @user.has_role?(:admin) || @record.user==@user
  end
  
  def new?
    @user.has_role?(:teacher)
  end
  
  def create?
    @user.has_role?(:teacher)
  end
  
  def destroy?
    @user.has_role?(:admin) || @record.user==@user
  end
end
