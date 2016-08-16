namespace :rentals do
  desc "TODO"
  task slug: :environment do
    Property.find_each(&:save)
  end

end
