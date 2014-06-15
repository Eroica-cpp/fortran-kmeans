"""
preprocess and clean data
"""
import cPickle
import sys

def get_id_codeList():
	"""
	replace every key word in key_word_dict as a code
	"""
	word2code = cPickle.load(open("./data/word_to_code.pickle"))
	key_word_dict = cPickle.load(open("./data/key_word_dict.pickle"))

	f = open("./data/id_codeList.txt", "w")
	for (iden, key_word_list) in key_word_dict.items():
		code_list = []
		for key in key_word_list:
			code_list.append(word2code[key])
		code_list.sort()
		f.write(str(iden) + "\t" + "\t".join([str(i) for i in code_list]) + "\n")
		print "iden:", iden, "done!"

	f.close()

if __name__ == "__main__":
	get_id_codeList()