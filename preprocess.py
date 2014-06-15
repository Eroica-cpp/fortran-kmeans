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
	id2code_dict = cPickle.load(open("./data/id2code_dict.pickle"))

	f = open("./data/id_codeList.txt", "w")
	len_list = []
	for (iden, code) in id2code_dict.items():
		key_word_list = key_word_dict[iden]
		key_word_list = key_word_dict[iden]
		word_code_list = []
		for key in key_word_list:
			word_code_list.append(word2code[key])
		word_code_list.sort()
		f.write(str(code) + "\t" + "\t".join([str(i) for i in word_code_list]) + "\n")
		len_list.append(str(len(word_code_list)))
		print "code:", code, "done!"
	f2 = open("./data/len.txt", "w")
	f2.write("\t".join(len_list))
	f2.close()
	f.close()



def id2code():
	"""
	map page id to compact code array
	"""
	key_word_dict = cPickle.load(open("./data/key_word_dict.pickle"))
	
	counter = 1
	id2code = {}
	for iden in key_word_dict.keys():
		id2code[iden] = counter
		counter += 1
		print "counter =", counter

	## save object
	cPickle.dump(id2code, open("./data/id2code_dict.pickle", "w"))

if __name__ == "__main__":
	get_id_codeList()
	## id2code()