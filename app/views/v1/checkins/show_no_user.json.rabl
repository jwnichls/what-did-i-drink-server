object @checkin
attributes :notes, :created_at

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

t.integer  "user_id"
t.integer  "drink_id"
t.integer  "venue_id"