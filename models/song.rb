class Song < ActiveRecord::Base
  validates_presence_of :created_at
  has_many :stanzas

  attr_accessor :number_of_stanzas, :user, :shares

  

end