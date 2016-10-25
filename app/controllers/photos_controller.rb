class PhotosController < ApplicationController

  def create
    my_params = photo_params
    @album = current_user.albums.find(my_params[:album_id])
    if @album && 
      my_params[:name].respond_to?('each')

      my_params[:name].each do |name|
        @album.photos.create!(name: name)
      end

      flash[:success] = '照片上传成功'
      redirect_to @album
    else
      render json: { msg: ['上传失败'] }
    end
  end

  def destroy
    @photo = Photo.find(params[:id]);
    user = @photo.album.user
    if current_user?(user)
      helpers.qiniu_delete(@photo.name)
      @photo.destroy
      flash[:success] = '照片删除成功'
      redirect_back(fallback_location: albums_path)
    end
  end

  private

  def photo_params
    params.permit(:title, :album_id, name: [])
  end

end
