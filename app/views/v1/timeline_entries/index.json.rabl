collection @entries
attributes :type, :created_at

child :user, :if => lambda { |e| e.user } do
	extends "v1/users/show"
end

child :drink, :if => lambda { |e| e.drink } do
	extends "v1/drinks/show_small"
end
