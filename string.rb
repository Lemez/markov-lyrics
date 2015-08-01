require 'set'
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

	def alpha_strip
		self.gsub(/[^A-Za-z ]/,"")
	end

	def prepare_for_parsing
		self.gsub(/[^A-Za-z'-]/,"")
		condition = ["\'","-"] & [self[0],self[-1]]
		self.remove_first_last_punctuation unless condition.empty?
	end

	def remove_first_last_punctuation
		self.gsub(/[^A-Za-z]/,"") 
	end
end

def is_word_alpha?(word)
	return word =~ /[A-Za-z]/
end
