class Identity < OmniAuth::Identity::Models::ActiveRecord
  attr_accessible :email, :password, :password_confirmation, :user_id
end
