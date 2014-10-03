'''
Written By: Eleisha Jackson
Date: 10/2/2014
Description: This is a helper file that is used to map the sequences of the models to the template 
structure sequence.


'''

def get_sequences(file):
	"""
	This function takes a file with a bunch of sequences in fasta format and returns a list of the sequences. 
	
	Args: 
		file: The name of the fasta file of the given sequences
		
	Returns:
		Returns TWO lists
		It returns: all_sequences, headers
		all_sequences is a list of every sequence in the fasta file
		headers is a list of every header for each sequence in the fasta file
		The headers and the sequences are in corresponding elements in the two lists 
		(so the first element in the header list is the header for the first sequence in the sequence list.)				
	"""
		
	all_sequences = []  
	natural_sequences = []
	designed_sequences = []
	headers = []

	file_data = open(file, "r")
	seq_data = file_data.readlines()
	file_data.close()
	#print seq_data
	#This block of code basically just removes all of the headers from the array of sequence information.
	#It creates all_sequences, which is a list of all the sequences from the natural alignment file.
	string  = ''
	finished_sequence = ''
	for sequence in seq_data:
		if sequence[0] == '>': #If it is a header append the last sequence that was processed
			headers.append(sequence.rstrip())
			if(string != ''):
				finished_sequence = string #Just in case the sequence was translated from Stockholm format
				all_sequences.append(finished_sequence) #Appends the sequence into the array full of aligned sequences
				string = '' #Empty the string that represents the sequence (you don't want to append the old with the new)
		else:       
			string = string + sequence.rstrip("\n") #Strip the new line that is at the end of each sequence in alignment
	all_sequences.append(string)
	num_sequences = len(all_sequences)
	return all_sequences, headers   

def create_pdb_alignment_map(seqs, pdb_res_nums, map_filename):
	'''
	Creates a file that maps a pdb seqeunce onto a given alignments. 
	Args: 
		seqs: A list of aligned sequences 
		pdb_res_nums: A list of residue numbers from the pdb file
		map_filename: The file name to write the map to
	
	Returns:
		Does not return anything but creates a file with a map
	'''

	
	alignment_length = len(seqs[0]) 
	aligned_pdb_seq = seqs[0]
	#Make map list
	map_outfile = open(map_filename, "w")
	map_outfile.write("align_pos\tpdb_pos\tpdb_aa\n")
	res_counter = 0
	for j in xrange(0, alignment_length):
		map_outfile.write(str(j+1) + "\t")
		if(aligned_pdb_seq[j]!= "-"):
			map_outfile.write(str(pdb_res_nums[res_counter]) + "\t" + aligned_pdb_seq[j])
			res_counter = res_counter + 1
		else:
			map_outfile.write("NA" + "\t" + "-")
		map_outfile.write("\n")

def write_seq_to_file(seqs, headers, out_fasta):
	"""
	Writes a group of sequences to a file
	
	Args:
		seqs: A list of sequences
		headers: A list of descriptors (often fasta headers > included)
		out_fasta: The name of the file that the sequences will be written to
		
	Returns:
		out_fasta: A string that is the filename that was given to the function
	
	"""
	file = open(out_fasta, "w")
	j = 0
	for seq in seqs:
		file.write(headers[j]+ "\n")
		file.write(seq + "\n")
		j = j+1
	file.close()
	return out_fasta
