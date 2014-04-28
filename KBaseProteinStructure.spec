/* Service for all ......R 

Sean, please refer... 
https://trac.kbase.us/projects/kbase/wiki/StandardDocuments
*/
module KBaseProteinStructure { 

    /* 
        KBase Protein MD5 id 
    */
    typedef string md5_id;



    typedef list<md5_id> md5_ids;

    /*
	PDB id
    */
    typedef string pdb_id;

    typedef list<pdb_id> pdb_ids;

    typedef mapping<md5_id,pdb_ids> md5_to_pdb_ids;
    

    /*FUNCTIONS*/
    
    /* core function used by many others.  Given a list of KBase SampleIds returns mapping of SampleId to expressionSampleDataStructure (essentially the core Expression Sample Object) : 
    {sample_id -> expressionSampleDataStructure}*/
    funcdef lookup_pdb_by_md5( md5_ids input_ids ) returns (md5_to_pdb_ids results);
}; 
