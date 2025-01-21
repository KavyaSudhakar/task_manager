class UsersController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  before_action :authorize_request, except: :register
  before_action :find_user, except: %i[register index]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/1 
  def show
    render json: @user, status: :ok
  end

  # POST /users 
  def register
    @user = User.new(user_params)
    if @user.save!
      render json: @user, serializer: UserSerializer, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/1 
  def destroy
    @user.destroy!
  end

  private
  
    def find_user
      @user = User.find_by_username!(params[:_username])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :phone, :status, :password, :password_confirmation)
    end

    def render_unprocessable_entity(exception)
      render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
  
    def render_not_found
      render json: { errors: 'Resource not found' }, status: :not_found
    end
end
