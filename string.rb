class String
	def clean_up
		words = self.split(" ")
		words.reject!{|w| w.downcase.include?("chorus") or w.downcase.include?("verse") \
										or w.downcase.include?("[") or w.downcase.include?("\\") \
										or w.downcase.include?("}") or w.downcase.include?("{") \
										or w.downcase.include?("]")
										}
		words.join(" ")
	end

	def separate_out
		separated = self.split(" ").map! {|s| s[0]==s[0].upcase && s!="I" ? s="\n#{s}" : s }.join(" ") 
		cleaner = separated.split("\n").map(&:strip).reject {|a| !a.include?(" ")}
		cleaner
	end
end