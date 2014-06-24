# TODO: maybe this would be possible to invoke from Makefile?
#
#       wget 'ftp://ftp.wwpdb.org/pub/pdb/derived_data/pdb_seqres.txt.gz'

all:  pdb.uniq.md5.fasta pdb.md5.tab pdb_md5_prot.phr
# extract uniq sequences, label by md5 hash
pdb.uniq.md5.fasta:  pdb_seqres.txt.gz
	gunzip -c pdb_seqres.txt.gz | ./extract_unique_sequences_md5 >pdb.uniq.md5.fasta 

# Next make table that maps md5 ids to PDB ids and chaines

pdb.md5.tab: pdb_seqres.txt.gz
	gunzip -c pdb_seqres.txt.gz | ./create_md5_pdb_id_mapping >pdb.md5.tab

#
# make blast database
# 
pdb_md5_prot.phr pdb_md5_prot.pin pdb_md5_prot.psq: pdb.uniq.md5.fasta
	makeblastdb -dbtype prot -in pdb.uniq.md5.fasta -title "PDB protein sequences MD5" -out pdb_md5_prot

