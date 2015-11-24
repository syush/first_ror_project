class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_categories
  helper_method :have_rights_for?, :under_admin?

  protected

  def abort_if_not_authorized(object)
    abort unless have_rights_for?(object)
  end

  def under_admin?
    current_user && current_user.admin?
  end

  def have_rights_for?(object)
    object && current_user && (current_user.author_of?(object) || current_user.admin?)
  end

  def safe_save(object, notice)
    if object.save
      yield if block_given?
      redirect_to :back, notice: notice
    else
      redirect_to :back, alert: 'Из-за неизвестной ошибки операция не была завершена'
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  private

  def set_categories
    @categories = Category.all
  end


  def abort
    redirect_to :root, alert: "У вас нет прав для выполнения этого действия"
  end

end
