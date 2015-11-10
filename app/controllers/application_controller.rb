class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_categories

  def abort_if_non_authorized(object)
    unless object.user == current_user
      redirect_to :root, alert: "У вас нет прав для выполнения этого действия"
    end
  end


  private

  def set_categories
    @categories = Category.all
  end
end
