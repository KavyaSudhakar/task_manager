module Authentication
    extend ActiveSupport::Concern
  
    included do
      before_action :authorize_request, except: [:index, :show] 
    end
  
    private
  
    def authorize_request
      header = request.headers['Authorization']
      if header.present? && header.start_with?('Bearer ')
        token = header.split(' ').last
        begin
          decoded = JsonWebToken.decode(token)
          @current_user = User.find(decoded[:user_id]) 
        rescue JWT::DecodeError => e
          render json: { error: 'Invalid token' }, status: :unauthorized
        end
      else
        render json: { error: 'Missing or invalid token' }, status: :unauthorized
      end
    end
  end
  