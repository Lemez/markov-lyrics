require "espeak"
include ESpeak

def speak_chorus
	@@chorus.each_pair{|k,v| speak_line(v)}
end

def speak_line(line)

	Speech.new(line, voice: "en", pitch: @pitch, speed: @speed).speak

end