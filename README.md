
Expression Services
================================================

Overview
--------
This service has methods for finding Protein Structure Databank (PDB)
entries with sequences similar to a KBase protein sequence, specified
by either a MD5 id or a feature or coding sequence id.  There are two
functions, one for searching by MD5, and the other searching by
feature ID (FID).  More details can be found in 
docs/KBaseProteinStructure.html

The princpal client for which this service is intended is the
landing page widget defined in kbaseGeneStructureMatches.js 
ui-common/functional-site/src/widgets/genomes in the ui-common repo.


Author
------
Sean McCorkle BNL (mccorkle@bnl.gov, sean.r.mccorkle@gmail.com)

Log
---
0.01 - Initial Release candidate 
0.02 - Broader Match Criteria - now only 30% identity over 80% length required

Special deployment instructions
-------------------------------

1) This service currently relies on a CDMI connection to Central Store to
   convert MD5s to protein sequences and counts on a blastp binary to
   find similar sequences.  The build (deploy) process starts with a
   fasta-format file of sequences directly from the PDB, condenses that
   to a set of unique sequences indexed by MD5 ids, and builds a blastp
   index db from that, which resides in
   /kb/deployment/services/protein_structure_service/pdb/ along with other
   auxilliary files (mapping PDB ids to sequence MD5s) Currently this
   amounts to ~64 Mb of space


2) The  makefile test order was rearranged to invoke test-service before
   test-client before test-scripts.  The author's preference is to 
   "make deploy" and then "make test-service" before starting the service,
   then start the service and then "make test-client". 
   ("test-service" checks make sure that the deployed pdb file environment 
   is in place and a CMDI link to central store can be established.)
   Otherwise standard KBase deployment and test should work.   


Starting/Stopping the service, and other notes
----------------------------------------------
* to start and stop the service, use the 'start_service' and 'stop_service'
  scripts in (the default location) /kb/deployment/services/protein_structure_service
* check /kb/deployment/services/protein_structure_service/log/error.log to see if there 
  were any errors  (one information message "LOADED MD5 PDB TABLE  two" has been 
  left in)
* on test machines, KBaseProteinStructure services listen on port 7088, 
  so this port must be open
* after starting the service, the process id of the service is stored in the 
  'service.pid' file in /kb/deployment/services/protein_structure_service
* log files are currently dumped in the /kb/deployment/services/protein_structure_service/log
  directory
* 'reboot_service' speeds the process of stopping, redeploying and restarting a service
  for the purposes of debugging and testing.
