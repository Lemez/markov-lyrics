StanfordCoreNLP.jar_path = '/Users/JW/Dropbox/Dev/Websites/FrontEnd/_JS plugins/stanford-core-nlp-minimal/'
StanfordCoreNLP.model_path = '/Users/JW/Dropbox/Dev/Websites/FrontEnd/_JS plugins/stanford-core-nlp-minimal/'
NLP =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)