# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#  Create 50 articles

50.times do |_n|
  title = Faker::Hipster.sentence(word_count: 2, random_words_to_add: 0, open_compounds_allowed: false)
  body = Faker::Hipster.paragraph_by_chars(characters: 100)
  Article.create!(title: title, body: body)
end
