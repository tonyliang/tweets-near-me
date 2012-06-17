class Tweet
  include Mongoid::Document
  validates :name, :location, :pic, :text, presence: true
  field :location, type: Array
  field :pic, type: String
  field :name, type: String
  field :text, type: String
  index({location:'2d'},{sparse:true})
  store_in collection: 'tweets',database:'app5314009'
end
