class Array
	def longest
		self.sort_by(&:length).last
	end

	def shortest
		self.sort_by(&:length).first
	end
end