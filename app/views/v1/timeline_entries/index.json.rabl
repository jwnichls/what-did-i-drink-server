collection @entries
attributes :type, :created_at

child :user do
	attributes :id, :full_name
end

child :drink do
	attributes :id, :name, :created_by
end
