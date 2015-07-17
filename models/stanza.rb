class Stanza < ActiveRecord::Base
  validates_presence_of :type

  belongs_to :song
  has_many :lines

  store :settings, accessors: [:type, :number_lines, :pattern, :position_in_song], coder: JSON


  
end