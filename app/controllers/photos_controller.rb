class PhotosController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,    only: :destroy

  def create
    my_params = photo_params
    @album = current_user.albums.find(my_params[:album_id])
    if @album && 
      my_params[:name].respond_to?('each')

      my_params[:name].each do |name|
        @album.photos.create(name: name)
      end

      flash[:success] = '照片上传成功'
      redirect_to @album
    else
      render json: { msg: ['上传失败'] }
    end
  end

  def destroy
    @photo.destroy
    helpers.qiniu_delete(@photo.name)
    flash[:success] = '照片删除成功'
    redirect_back(fallback_location: albums_path)
  end

  private

  def photo_params
    params.permit(:title, :album_id, name: [])
  end

  def correct_user
    @photo = Photo.find_by(id: params[:id])
    redirect_to root_url if @photo.nil? || !current_user?(@photo.album.user)
  end

end
