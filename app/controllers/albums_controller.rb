class AlbumsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,    only: [:edit, :update, :destroy]

  def index
    if params[:uid]
      @user = User.find(params[:uid])
      @albums = 
        @user.albums.where('public = ?', true).paginate(page: params[:page],
                                                       per_page: 8)
    else
      @albums = current_user.albums.paginate(page: params[:page], per_page: 8)
    end
    @js_validates = ['title'];
  end

  def show
    if params[:uid]
      @user = User.find(params[:uid])
      @album = @user.albums.find(params[:id])
    else
      @album = current_user.albums.find(params[:id])
    end
    @photos = @album.photos.paginate(page: params[:page])
  end

  def create
    album_params = params.permit(:title, :public, :cover)
    album_params[:cover] = Photo.first.id
    @album = current_user.albums.build(album_params)
    if @album.save
      photo = @album.photos.build(user_id: current_user.id, name: params[:cover])
      if photo.save
        @album.update_attribute(:cover, photo.reload.id)
        flash[:success] = '相册创建成功!';
        redirect_to albums_path
      else
        flash[:success] = photo.errors.full_messages
        redirect_to albums_path
      end
    else
      helpers.qiniu_delete(params[:cover])
      render json: {msg: @album.errors.full_messages}
    end
  end

  def edit
    @photos = @album.photos.paginate(page: params[:page])
  end

  def update
    my_params = params.require(:album).permit(:title, :public, :cover)
    if @album.update_attributes(my_params)
      flash[:success] = '相册编辑成功'
      redirect_back(fallback_location: @album)
    else
      @photos = []
      render 'edit'
    end
  end

  def destroy
    helpers.qiniu_delete(@album.cover_photo.name) if @album.cover_photo
    @album.destroy
    @album.photos.each do |photo|
      helpers.qiniu_delete(photo.name)
    end
    flash[:success] = '相册删除成功'
    redirect_to albums_path
  end

  private

    def correct_user
      @album = current_user.albums.find_by(id: params[:id])
      redirect_to root_url if @album.nil?
    end

end
