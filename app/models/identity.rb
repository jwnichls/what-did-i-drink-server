class Identity < OmniAuth::Identity::Models::ActiveRecord
  # attr_accessible :email, :password, :password_confirmation, :user_id
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\Z/i
end
