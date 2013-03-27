object @venue
attributes :name, :address, :postalCode, :city, :state, :verified, :created_at

node :location do |v|
	{ :lat => v.lat, :lng => v.lng }
end
