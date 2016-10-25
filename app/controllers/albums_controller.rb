class AlbumsController < ApplicationController
  before_action :logged_in_user

  def index
    @albums = current_user.albums.paginate(page: params[:page], per_page: 8)
    @js_validates = ['title'];
  end

  def show
    @album = current_user.albums.find(params[:id])
    @photos = @album.photos.paginate(page: params[:page])
  end

  def create
    @album = current_user.albums.build(album_params)
    if @album.save
      flash[:success] = '相册创建成功!';
      redirect_to albums_path
    else
      helpers.qiniu_delete(params[:cover])
      render json: {msg: @album.errors.full_messages}
    end
  end

  def edit
    @album = current_user.albums.find(params[:id])
    @photos = @album.photos.paginate(page: params[:page])
  end

  def update
    @album = current_user.albums.find(params[:id])
    my_params = params.require(:album).permit(:title, :public)
    if @album.update_attributes(my_params)
      flash[:success] = '相册编辑成功'
      redirect_to @album
    else
      @photos = []
      render 'edit'
    end
  end

  def destroy
    @album = current_user.albums.find(params[:id])
    helpers.qiniu_delete(@album.cover)
    @album.photos.each do |photo|
      helpers.qiniu_delete(photo.name)
    end
    @album.destroy
    flash[:success] = '相册删除成功'
    redirect_to albums_path
  end

  private

    def album_params
      params.permit(:title, :public, :cover)
    end

end
