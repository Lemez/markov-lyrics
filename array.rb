class Array
	def longest
		self.sort_by(&:length).last
	end

	def shortest
		self.sort_by(&:length).first
	end
end

def get_random_word(array)
	randomarray = array[Random.rand(array.length)][0].split(" ")
	return randomarray
end

def get_long_word(array)
	get_random_word(array).longest.alpha_strip
end

def get_short_word(array)
	get_random_word(array).shortest.alpha_strip
end