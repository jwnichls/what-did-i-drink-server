collection @entries
attributes :type, :created_at

child :user do
	attributes :id, :full_name
end

child :drink do
	attributes :id, :name, :created_by
	child :images do
		node :small do |i|
		  i.image_url(:small)
		end
		node :thumb do |i|
		  i.image_url(:thumb)
		end
		node :image do |i|
		  i.image_url
		end
	end
end
