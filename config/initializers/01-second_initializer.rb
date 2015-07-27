require 'trollop'

opts = Trollop::options do
  opt :words, "Use word mode"                    # flag --monkey, default false
  opt :sentences, "Use sentences mode"                    # flag --monkey, default false
  opt :minsyll, "minimum syllables", :type => :integer, :default => 4         # string --name <s>, default nil
  opt :maxsyll, "maximum syllables", :type => :integer, :default => 12  # integer --num-limbs <i>, default to 4
  opt :number, "number of items", :type => :integer, :default => 100         # string --name <s>, default nil
end


MIN = opts[:minsyll]
MAX = opts[:maxsyll]
WORDS = opts[:words]
SENTENCES = opts[:sentences]
NUMBER = opts[:number]

