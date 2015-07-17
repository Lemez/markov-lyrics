class Line < ActiveRecord::Base
  belongs_to :stanza
  has_many :words
end