class Verse < Hash
	attr_accessor :lines

	def initialize(hash={})
    	@lines = hash
  	end

  	def [](key)
    	@my_hash[key]
  	end

  	def []=(key,val)
    	@my_hash[key]=val
  	end

end