class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  layout 'admin'

  protected

  def check_admin
    unless current_user && current_user.admin?
      redirect_to root_path, alert:"У вас нет прав администратора, необходимых для выполнения этого действия."
    end
  end
end