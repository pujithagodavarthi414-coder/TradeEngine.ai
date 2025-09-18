Create Procedure USP_GetFormFields   
(  
 @FormId UNIQUEIDENTIFIER = NULL,  
 @OperationsPerformedBy UNIQUEIDENTIFIER  
)  
As    
Begin     
    
SELECT GF.[Id] AS Id,      
                  GF.[GenericFormId],      
                  GF.[Label],      
                   GF.[Key],
				  GF.[Datatype]
      from GenericFormKey  GF where GenericFormId = @FormId  
and InActiveDateTime is NULL     
end