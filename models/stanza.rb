class Stanza < ActiveRecord::Base

  belongs_to :song
  has_many :lines
  
end