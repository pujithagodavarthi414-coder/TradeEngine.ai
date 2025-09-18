CREATE Procedure USP_GetForms      
(  
 @OperationsPerformedBy UNIQUEIDENTIFIER   
)  
As      
Begin       
  
DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))    
      
SELECT GF.[Id] AS Id,        
                  GF.[FormTypeId],        
                  GF.[FormName] as FormTypeName,        
                  GF.[FormName],       
      GF.[WorkflowTrigger],        
      GF.FormJson,        
          
      GF.[CreatedDateTime],         
      GF.[CreatedByUserId],        
      GF.[UpdatedDateTime],        
      GF.[UpdatedByUserId],        
      GF.InActiveDateTime AS ArchivedDateTime,        
          
      GF.[TimeStamp],        
      CASE WHEN GF.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,        
      TotalCount = COUNT(1) OVER()        
           FROM [dbo].[GenericForm] GF WITH (NOLOCK)        
          INNER JOIN FormType FT ON (FT.Id = GF.FormTypeId)   
    where FT.CompanyId = @CompanyId  
    End    

  