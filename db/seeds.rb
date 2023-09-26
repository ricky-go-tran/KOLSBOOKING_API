# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
    # jobs = Job.all

    # jobs.each do |job|
    #   job.image.attach(io: URI.open(Faker::LoremFlickr.image(size: "1200x900")), filename: 'default.jpg')
    # end
  # user = User.find(5)
  # user.profile.avatar.attach(io: URI.open(Faker::LoremFlickr.image(size: "1200x900")), filename: 'default.jpg')
  #

Industry.create(name: 'Travel and Hospitality', description: 'The travel and hospitality industry includes businesses related to travel, tourism, and accommodations, such as hotels, airlines, travel agencies, and resorts.')
Industry.create(name: 'Health and Fitness', description: 'The health and fitness industry focuses on promoting physical well-being and includes fitness centers, gyms, wellness programs, and healthcare-related services.')
Industry.create(name: 'Technology and Electronics', description: 'The technology and electronics industry involves the development, manufacturing, and distribution of electronic devices, software, and technological solutions.')
Industry.create(name: 'Finance and Investment', description: 'The finance and investment industry deals with financial services, banking, investment management, and the allocation of capital for businesses and individuals.')
Industry.create(name: 'Digital Content and Entertainment', description: 'The digital content and entertainment industry creates and distributes digital media, including movies, music, video games, streaming services, and online content.')
