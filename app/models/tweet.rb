class Tweet
  include Mongoid::Document
  field :location, type: Array
  field :pic, type: String
  field :name, type: String
  index({location:'2d'},{sparse:true})
  store_in collection: 'tweets',database:'Banjo'
end
