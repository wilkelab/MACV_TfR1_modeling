import map_helper as mp
import numpy as np
import Bio.PDB
import subprocess, os, sys

'''
	Description: 
	Written By: Eleisha Jackson
	Date: 10/2/2014
	This is a script that maps the sequences of the models to the unrenumbered template sequence
	
'''

def make_map(chain, temp_seq, template_pdb, model_seq, model_pdb, align_file, map_filename):
	out = open(map_filename, "a")
	#Start the parser 
	pdb_parser = Bio.PDB.PDBParser(QUIET = True)
	
	#Get the structures
	model_structure = pdb_parser.get_structure("model", model_pdb)
	temp_structure = pdb_parser.get_structure("model", template_pdb)

	mod_model = model_structure[0]
	temp_model= temp_structure[0]

	mod_chain = mod_model[chain]
	temp_chain = temp_model[chain]

	#Get models
	mod_atoms = []
	temp_atoms = []
	
	temp_residues = []
	mod_residues = []
	temp_res_nums = []
	mod_res_nums = []

	#For each residue in the template and model chains, get the residue name and residue number
	for res in temp_chain:
		temp_residues.append( res )
		temp_res_nums.append( res.id[1])
		
	for res in mod_chain:
		mod_residues.append( res )
		mod_res_nums.append( res.id[1])
	
	mod_i = 0
	temp_i = 0
	#Use the alignment to print out the sequence including gaps
	for (mod_aa, temp_aa) in zip(model_seq, temp_seq):
		if mod_aa != '-' and temp_aa!= '-':
			#print temp_res_nums[temp_i], temp_aa, mod_res_nums[mod_i], mod_aa
			out.write(chain + "\t" + str(temp_res_nums[temp_i]) + "\t" + temp_aa + "\t" + str(mod_res_nums[mod_i]) + "\t" + mod_aa + "\n" )
			temp_i += 1
			mod_i += 1
		if mod_aa != "-" and temp_aa == "-":
			#print "NA", "-", mod_res_nums[mod_i], mod_aa
			out.write(chain + "\t" + "NA\t" + "-" + "\t" + str(mod_res_nums[mod_i]) + "\t" + mod_aa + "\n")
			mod_i += 1
		if temp_aa!= "-" and mod_aa == "-":
			#print temp_res_nums[temp_i], temp_aa, "NA", "-"
			out.write(chain + "\t" + str(temp_res_nums[temp_i]) + "\t" + temp_aa +  "\tNA\t" + "-" + "\n")
			temp_i += 1

	out.close()
	
def main(argv = sys.argv):
	#Perform the mapping for each virus and each TfR1 variant
	viruses = ["JUNV"]
	variants = ["ccal", "human", "human_L212V", "mouse_5aa", "mouse", "rat", "rat_5aa", "rat_9aa"]
	if (os.path.isdir("./model_maps")):
		subprocess.call("rm -r model_maps", shell = True)
	for virus in viruses: 
		print virus
		for variant in variants:
			print variant
			process = subprocess.call("mkdir -p model_maps/", shell = True)
			model_pdb = "../sawyer_docking/models/" + variant + "_" + virus + "_GP1_1.pdb"
			template_pdb = "../3KAS_unrenumbered.pdb" #UNRENUMBERED Template structure
			align_file = "modeller_fasta_alignments/" + variant+ "_" + virus + "_GP1_modeller_alignment.fasta"
			map_filename = "model_maps/" + variant + "_" + virus + "_GP1_map.txt"
			
			out = open(map_filename, "a") #Output file
			out.write("chain\ttemplate_resnum\ttemplate_resname\tmodel_resnum\tmodel_resname\n")
			out.close()
			
			sequences, headers = mp.get_sequences(align_file) #Get the two sequences from the alignment
			full_temp_seq = sequences[0]
			full_model_seq = sequences[1]
			
			#Break the chain up by chain A and chain B then make the map for each chain separately
			chain_break_1 = full_temp_seq.index("/")
			temp_seq = full_temp_seq[:chain_break_1]
			chain_break_2 = full_model_seq.index("/")
			model_seq = full_model_seq[:chain_break_2]

			make_map("A", temp_seq, template_pdb, model_seq, model_pdb, align_file, map_filename)
			temp_seq = full_temp_seq[chain_break_1+1:]
			model_seq = full_model_seq[chain_break_2+1:]
			make_map("B", temp_seq, template_pdb, model_seq, model_pdb, align_file, map_filename)

if __name__ == "__main__":
	main()