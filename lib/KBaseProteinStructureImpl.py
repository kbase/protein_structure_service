#BEGIN_HEADER
#END_HEADER


class KBaseProteinStructure:
    '''
    Module Name:
    KBaseProteinStructure

    Module Description:
    KBaseProteinStructure.spec:  typedef compiler specification for protein structure
service

Sean, please refer... 
https://trac.kbase.us/projects/kbase/wiki/StandardDocuments

Notes:  25 jun 2014 - removing resolution from the picture for now.
    '''

    ######## WARNING FOR GEVENT USERS #######
    # Since asynchronous IO can lead to methods - even the same method -
    # interrupting each other, you must be *very* careful when using global
    # state. A method could easily clobber the state set by another while
    # the latter method is running.
    #########################################
    #BEGIN_CLASS_HEADER
    #END_CLASS_HEADER

    # config contains contents of config file in a hash or None if it couldn't
    # be found
    def __init__(self, config):
        #BEGIN_CONSTRUCTOR
        #END_CONSTRUCTOR
        pass

    def lookup_pdb_by_md5(self, input_ids):
        # self.ctx is set by the wsgi application class
        # return variables are: results
        #BEGIN lookup_pdb_by_md5
        #END lookup_pdb_by_md5

        #At some point might do deeper type checking...
        if not isinstance(results, dict):
            raise ValueError('Method lookup_pdb_by_md5 return value ' +
                             'results is not type dict as required.')
        # return the results
        return [results]

    def lookup_pdb_by_fid(self, feature_ids):
        # self.ctx is set by the wsgi application class
        # return variables are: results
        #BEGIN lookup_pdb_by_fid
        #END lookup_pdb_by_fid

        #At some point might do deeper type checking...
        if not isinstance(results, dict):
            raise ValueError('Method lookup_pdb_by_fid return value ' +
                             'results is not type dict as required.')
        # return the results
        return [results]
