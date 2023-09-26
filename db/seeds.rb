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
  user = User.find(5)
  user.profile.avatar.attach(io: URI.open(Faker::LoremFlickr.image(size: "1200x900")), filename: 'default.jpg')
