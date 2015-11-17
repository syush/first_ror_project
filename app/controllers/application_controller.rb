class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_categories
  helper_method :have_rights_for?, :under_admin?


  def abort_if_non_authorized(object)
    unless have_rights_for?(object)
      redirect_to :root, alert: "У вас нет прав для выполнения этого действия"
    end
  end

  def under_admin?
    current_user && current_user.admin?
  end

  def have_rights_for?(object)
    object && current_user && (current_user.author_of?(object) || current_user.admin?)
  end

  private

  def set_categories
    @categories = Category.all
  end


end
