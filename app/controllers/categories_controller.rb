class CategoriesController < ApplicationController
    before_action :logged_in_user, only: [:new, :edit, :create, :destroy]

    def create
        params_category = params.permit(:content)
        category = Category.new(user_id: current_user.id, content: params_category[:content])
        if category.save
            result = {status: 0, id: category.id, content: category.content}
        else
            result = {status: -1}
        end
        render json: result 
        return
    end
end
