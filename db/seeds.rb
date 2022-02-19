# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'date'
require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'rake'

def get_sentiment(comment)
  url = URI("https://japerk-text-processing.p.rapidapi.com/sentiment/")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)
  request["content-type"] = 'application/x-www-form-urlencoded'
  request["x-rapidapi-host"] = 'japerk-text-processing.p.rapidapi.com'
  request["x-rapidapi-key"] = ENV['RAPIDAPI_KEY']
  request.body = "text=#{comment}&language=english"

  case JSON.parse(http.request(request).read_body)['label']
  when 'pos'
    return 'Positive'
  when 'neg'
    return 'Negative'
  else
    return 'Neutral'
  end
end

puts 'Clearing database...'
system('rails db:schema:load')

puts 'Generating users...'
artists = []
1.times do
  user = User.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, password: '123123123')
  artists << user
end

arisa = User.new(first_name: "Arisa", last_name: "Nemoto", email: "ardolce23@gmail.com", password: "a23123123")

arisa.save!
artists << arisa

tom = User.new(first_name: "Tom", last_name: "Tsui", email: "tomtsui@xxx.com", password: "1234567")
tom.save!
artists << tom

ref = User.new(first_name: "Ref", last_name: "Mags", email: "refmags@xxx.com", password: "1234567")
ref.save!
artists << ref

nico = User.new(first_name: "Nico", last_name: "Lentgen", email: "nicolaslentgen@xxx.com", password: "1234567")
nico.save!
artists << nico

puts 'Generating venue...'
venue = Venue.create!(
  name: "Tokyo Dome",
  address: Faker::Address.city
)

artists.each do |artist|
  puts 'Generating events...'
  1.times do
    event = Event.new(
      name: ["#{artist.first_name} #{artist.last_name}:National Tour", "LIVE!!: #{artist.first_name} #{artist.last_name}"].sample,
      start_at: Faker::Time.between_dates(from: Date.today - 1, to: Date.today, period: :all),
      end_at: Faker::Time.between_dates(from: Date.today + 1, to: Date.today + 2, period: :all),
      description: Faker::Lorem.paragraphs,
      user: User.all.sample,
      venue: venue
    )
    event.user = artist
    event.save!
    event.images.attach(io: URI.open("https://unsplash.com/s/photos/concert"), filename: "concerts.jpeg")
  end
end

puts 'Event done'

puts 'Generating event reviews for user Arisa'
comment = 'Best performance I have ever seen!'
arisa.events.first.event_reviews.create!(rating: 5, comment: comment, sentiment: get_sentiment(comment))

comment = "It's ok I guess."
arisa.events.first.event_reviews.create!(rating: 3, comment: comment, sentiment: get_sentiment(comment))

comment = 'Overall pretty nice :)'
arisa.events.first.event_reviews.create!(rating: 4, comment: comment, sentiment: get_sentiment(comment))

comment = 'Boring as hell.'
arisa.events.first.event_reviews.create!(rating: 1, comment: comment, sentiment: get_sentiment(comment))

comment = "The show is alright but the veune sucks."
arisa.events.first.event_reviews.create!(rating: 3, comment: comment, sentiment: get_sentiment(comment))

puts 'Generating song for user Arisa'
arisa_song = arisa.events.first.songs.new(
  name: 'The Symphony No. 5 in C minor',
  composer_name: 'Ludwig van Beethoven',
  start_at: DateTime.parse('Sat, 19 Feb 2022 07:10:00.000000000 UTC +00:00'),
  length_in_minute: 20,
  description: Faker::Lorem.paragraphs
)
arisa_song.save!
arisa_song.images.attach(io: URI.open("https://images-na.ssl-images-amazon.com/images/I/61HYd5O7onL.jpg"), filename: "symphony_no_5.jpg")

# arisa_song.song_reviews.create!(rating: 5, comment: 'Best performance I have ever seen!')
