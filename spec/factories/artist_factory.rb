# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  url        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :artist, class: Artist do
    id 2
    # if we mock and stub these, the id must be removed
    name Faker::Name.name
    url Faker::Internet.url
  end
  factory :artist2, class: Artist do
    id 3
    name Faker::Name.name
    url Faker::Internet.url
  end
  factory :invalid_artist, class: Artist do
    id 3
    name nil
    url nil
  end
end
