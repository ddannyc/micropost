class PostsController < ApplicationController
    before_action :logged_in_user, only: [:new, :edit, :create, :destroy]
    before_action :correct_user, only: [:update, :destroy]

    def index
        if current_user
          @categories = current_user.categories
          @posts = current_user.posts
          @posts = @posts.where(category_id: params[:c]) if params[:c]
          @posts = @posts.paginate(page: params[:page], per_page: 10)
        else
          @categories = []
          @posts = Post.paginate(page: params[:page], per_page: 10)
        end
    end

    def show
        @categories = []
        @categories = current_user.categories if current_user 
        @post = Post.find(params[:id])
    end

    def new
        @post = Post.new
        @categories = current_user.categories 
    end

    def edit
        @post = Post.find(params[:id])
        @categories = current_user.categories 
    end

    def create
        @categories = current_user.categories 
        @post = current_user.posts.build(params_post)
        if @post.save
            flash[:success] = 'Post created success.'
            Category.increment_counter(:post_nums, params_post[:category_id])
            redirect_to @post 
        else
            flash.now[:errors] = @post.errors.full_messages
            render 'new' 
        end
    end

    def update
        @categories = current_user.categories
        old_category_id = @post.category_id
        if @post.update_attributes(params_post)
            if @post.category_id != old_category_id 
                Category.decrement_counter(:post_nums, old_category_id)
                Category.increment_counter(:post_nums, @post.category_id)
            end
            flash[:success] = 'Post edited success.'
            redirect_to @post 
        else
            flash.now[:errors] = @post.errors.full_messages
            render 'edit' 
        end

    end

    private
    
    def params_post
        params.require(:post).permit(:title, :content, :category_id)
    end

    def correct_user
        @post = current_user.posts.find(params[:id])
        redirect_to root_url if @post.nil?
    end
end
