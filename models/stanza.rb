class Stanza < ActiveRecord::Base
  validates_presence_of :type

  belongs_to :song
  has_many :lines

  
end