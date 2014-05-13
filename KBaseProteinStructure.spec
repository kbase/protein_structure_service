/* Service for all ......R 

Sean, please refer... 
https://trac.kbase.us/projects/kbase/wiki/StandardDocuments
*/
module KBaseProteinStructure { 


    /* Inputs to service: */

    typedef string md5_id_t;             /* KBase Protein MD5 id  */

    typedef list<md5_id_t> md5_ids_t;    /* list of the same */


    /* Outputs from service */
	
    typedef string  pdb_id_t;            /* PDB id */

    typedef string  chains_t;            /* subchains of a match, i.e. "(A,C,D)" */

    typedef int     exact_t;             /* 1 (true) if exact match to pdb sequence */
    
    typedef float   resolution_t;        /* structural resolution (angstroms) */

    typedef float   percent_id_t;        /* % identity from BLASTP matches */
 
    typedef int     align_length_t;      /* alignment length  */

    typedef structure {
                       pdb_id_t        pdb_id;
                       chains_t        chains;
                       resolution_t    resolution;
                       exact_t         exact;
                       percent_id_t    percent_id;
                       align_length_t  align_length;
                      } PDBMatch;

    typedef list<PDBMatch> PDBMatches;    /* list of the same */

    typedef mapping<md5_id_t,PDBMatches> md5_to_pdb_matches;
    

    /*FUNCTIONS*/
    
    /* primary function - accepts a list of protein MD5s.  returns a hash (mapping?)  */
    /* of each to a list of PDBMatch records */

    funcdef lookup_pdb_by_md5( md5_ids_t input_ids ) returns (md5_to_pdb_matches results);
}; 
