
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
kbaseGeneStructureMatches.js landing page widget in
ui-common/functional-site/src/widgets/genomes in the ui-common repo.


Author
------
Sean McCorkle BNL (mccorkle@bnl.gov, sean.r.mccorkle@gmail.com)

Log
---
0.01 - Initial Release candidate 

Special deployment instructions
-------------------------------

1) This service currently relies on a CDMI connection to Central Store to
   convert MD5s to protein sequences and counts on a blastp binary to
   find similar sequences.  The build (deploy) process starts with a
   fasta-format file of sequences directly from the PDB, condenses that
   to e set of unique sequences indexed by MD5 ids, and builds a blastp
   index db from that, which resides in
   /kb/deployment/services/kbaseproteinstructure/pdb/ along with other
   auxilliary files (mapping PDB ids to sequence MD5s) Currently this
   amounts to ~64 Mb of space

2) Since this service is not yet in production, I've left the client test 
   URL as the testing/developement URL.  When in production, in the file
   t/lib/prot_struct_test_utils.pm
   will need to have this line 
   our $service_url = "http://140.221.85.122:7088";
   changed to the assigned production url

3) Makefile test order was rearranged to invoke test-service before
   test-client before test-scripts.  Otherwise standard KBase deployment
   and test should work.   "test-service" checks make sure that the 
   deployed pdb file environment is in place and a CMDI link to central 
   store can be established.



Starting/Stopping the service, and other notes
----------------------------------------------
* to start and stop the service, use the 'start_service' and 'stop_service'
  scripts in (the default location) /kb/deployment/services/KBaseProteinStructure
* check /kb/deployment/services/KBaseProteinStructure/log/error.log to see if there 
  were any errors
* on test machines, KBaseProteinStructure services listen on port 7088, 
  so this port must be open
* after starting the service, the process id of the service is stored in the 
  'service.pid' file in /kb/deployment/services/KBaseProteinStructure
* log files are currently dumped in the /kb/deployment/services/KBaseProteinStructure/log
  directory
* 'reboot_service' speeds the process of stopping, redeploying and restarting a service
  for the purposes of debugging and testing.
