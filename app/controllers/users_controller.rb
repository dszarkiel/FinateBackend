class UsersController < ApplicationController

    def index 
        users = User.all
        render json: users, except: [:created_at, :updated_at]
    end

    def show
        user = User.find_by_id(params[:id])
        render json: user.to_json(include: [:accounts, :transactions, :budgets])
    end

    def create
        user = User.new(user_params)
        if user.save
            NewUserEmailMailer.notify_user(user).deliver_later
            render json: user, except: [:created_at, :updated_at]
        else
            render json: {error: user.errors.full_messages}
        end
    end

    def update
        user = User.find_by_id(params[:id])
        if user.update(user_params)
            render json: user
        else
            render json: {error: "Oops, something went wrong."}
        end
    end

    def destroy
        user = User.find_by_id(params[:id])
        if user.destroy
            render json: user
        else
            render json: {error: "Oops, something went wrong."}
        end
    end

    private 

    def user_params
        params.permit(:first_name, :last_name, :date_of_birth, :email, :password, :address, :address_two, :city, :state, :zipcode, :avg_monthly_income)
    end

end
