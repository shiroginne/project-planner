require 'faker'

puts "Seeding..."

100.times do
  project = Project.create!(name: Faker::Company.name)
  rand(25..35).times do
    Task.create!(
      project: project,
      name: Faker::Lorem.sentence(word_count: 3),
      expires_at: Faker::Time.forward(days: 180)
    )
  end
end

puts "Done!"
