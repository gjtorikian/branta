namespace :search do
  desc "Creates the search index"
  task create_index: :environment do
    Branta::IndexManager.create_index
  end

  desc "Force creates the search index"
  task force_create_index: :environment do
    Branta::IndexManager.create_index(true)
  end
end
