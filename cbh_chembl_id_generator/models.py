# -*- coding: utf-8 -*-
from django.db import models

class CBHCompoundIdManager(models.Manager):
    def make_compound_public(self, data):
        raise NotImplementedError

    def upsert(self, id_key, original_installation_keyv, structure_keyv=''):
        cursor = connection.cursor()
        sql = "select make_new_id(%s,%s,%s);" % (structure_keyv, id_key, original_installation_keyv)
        mytuple = cursor.fetchall()
        data = [d[0] for d in mytuple]
        return data

    def new_public_compound_or_update(self, data):
        '''Here we know that we have an  inchi key so the 
        structure key is the inchi key '''
        return self.upsert(data["id_key"],data["original_installation_keyv"], data["inchi_key"])



    def new_batch(data):
        '''Here we know that we have no inchi key so the 
        structure key is the existing compound id '''
        return self.upsert(data["id_key"],data["original_installation_keyv"], data["assigned_id"])


    def new_private_compound(data):
        '''Here we have nothing so we just get a new ID'''
        return self.upsert(data["id_key"],data["original_installation_keyv"])
        


class CBHCompoundId(models.Model):
    '''Private structures will be stored in the private version of this table
    Public structures will be stored in the public version as well as the local version of this table
    This gives a data format looking like this:


        For public molecules                    
        ===============================================================================================================================                                            
                                                structure key               project key             install key             assigned id
        --------------------------------------------------------------------------------------------------------------------------------
        Public Node                     column contains inchi key               Yes                    Yes                    Yes
        Private node 1                           deleted                        deleted               deleted                deleted                              
                                                                        
                                                                        
        For private  molecules             
        ==============================================================================================================================                                                               
                                               structure key               project key             install key             assigned id
        -------------------------------------------------------------------------------------------------------------------------------
        Public Node                     assigned id for uniqueness              Yes                    Yes                    Yes
        Private node 1              column contains inchi key                   Yes                    Yes                    Yes
                                                                        

        For blinded  molecules                                          
        ==============================================================================================================================                       
                                              structure key               project key             install key             assigned id
        ------------------------------------------------------------------------------------------------------------------------------
        Public Node                     assigned id for uniqueness              Yes                    Yes                    Yes
        Private node 1              assigned id for uniqueness                  Yes                    Yes                    Yes
                                                                        

        API requests to the public instance
        ===============================================================================================================================
        All API requests will contain the INCHI key but this will not be saved in the case of private molecules.
        There will be an option to ask for a new ID



    This was the algorithm can look for the molecule in the local project or install first and assign an ID if it is there, otherwise it requests
    from the public node to get a new ID or a public ID                                                  

    A separate process will later link newly publicised molecules with their private counterparts

    '''
    structure_key = models.CharField(max_length=50, unique=True)
    assigned_id = models.CharField(max_length=12, unique=True)
    original_installation_key = models.CharField(max_length=10)
    current_batch_id = models.IntegerField(default=0)
    objects = CBHCompoundIdManager()







