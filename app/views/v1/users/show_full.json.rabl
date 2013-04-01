extends "v1/users/show"

object @user
attribute :email, :created_at, :admin, :venue_updated_at

child :venue, :if => lambda { |u| u.venue } do
	extends "v1/venues/show"
end

