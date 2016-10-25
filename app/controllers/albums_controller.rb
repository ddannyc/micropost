class AlbumsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,    only: [:edit, :update, :destroy]

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
    @photos = @album.photos.paginate(page: params[:page])
  end

  def update
    my_params = params.require(:album).permit(:title, :public)
    if @album.update_attributes(my_params)
      flash[:success] = '相册编辑成功'
      redirect_back(fallback_location: @album)
    else
      @photos = []
      render 'edit'
    end
  end

  def destroy
    @album.destroy
    helpers.qiniu_delete(@album.cover)
    @album.photos.each do |photo|
      helpers.qiniu_delete(photo.name)
    end
    flash[:success] = '相册删除成功'
    redirect_to albums_path
  end

  private

    def album_params
      params.permit(:title, :public, :cover)
    end

    def correct_user
      @album = current_user.albums.find_by(id: params[:id])
      redirect_to root_url if @album.nil?
    end

end
