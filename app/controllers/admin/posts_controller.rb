class Admin::PostsController < Admin::BaseController

  before_action :set_post

  def approve
    @post.publish
    safe_save(@post, 'Теперь публикация стала доступна пользователям.') { @post.approve_notify }
  end

  def discard
    @post.set_draft
    safe_save(@post, 'Публикация отклонена.') { @post.discard_notify }
  end

end