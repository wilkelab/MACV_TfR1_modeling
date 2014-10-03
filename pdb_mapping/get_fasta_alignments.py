import sys, os, subprocess
import map_helper as mp
from Bio import AlignIO

'''
	Description: 
	Written By: Eleisha Jackson
	Date: 10/2/2014
	This is a script that creates fasta files from the .ali Modeller alignments
	
'''

def main(argv = sys.argv):
	process = subprocess.call("mkdir -p modeller_fasta_alignments" , shell = True)
	#arg 1 = virus, arg 2 = virus four letter code
	variants = ["ccal", "human", "human_L212V", "mouse_5aa", "mouse", "rat", "rat_5aa", "rat_9aa"]
	for variant in variants:
		outname =  "modeller_fasta_alignments/" + variant + "_" + argv[2] +  "_GP1_modeller_alignment.fasta"
		alignment = "../sawyer_modeling/" + argv[1] + "/make_alignments/" + variant + "_" + argv[2] + "_GP1.ali"
		align = AlignIO.read(alignment, "pir")
		seqs = []
		headers = []
		for record in align:
			seqs.append(str(record.seq))
			headers.append(">"  + record.id)		
		mp.write_seq_to_file(seqs, headers, outname)

		
if __name__ == "__main__":
	main(sys.argv)
	