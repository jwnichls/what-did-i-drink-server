set :output, "/home/jwnichls/web/whatdididrink/rails/current/log/crontab.log"

every :day, :at => '3:00am' do
  runner "Venue.delete_all_unverified!"
end

every 1.hours do 
  runner "User.check_out_old_locations!"
end
