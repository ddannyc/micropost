class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.content.blank? && @micropost.pictures.empty?
      render json: { msg: '请输入文字或者上传照片' }
    else
      if @micropost.save
        flash[:success] = "发表成功"
        redirect_to root_url
      else
        render json: { msg: @micropost.errors.full_messages } 
      end
    end
  end

  def destroy
    @micropost.destroy
    @micropost.pictures.each do |picture|
      helpers.qiniu_delete(picture)
    end
    flash[:success] = "Micropost deleted"
    #redirect_to request.referrer || root_url
    redirect_back(fallback_location: root_url)
  end

  private

  def micropost_params
    params.permit(:content, pictures: [])
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
