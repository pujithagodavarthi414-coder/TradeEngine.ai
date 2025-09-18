
CREATE PROCEDURE [dbo].[USP_UpsertFormWorkflow]  
(  
   @FormTypeId UNIQUEIDENTIFIER = NULL,  
   @WorkflowName NVARCHAR(500),  
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL  
)  
As  
Begin  
 DECLARE @Currentdate DATETIME = GETDATE()  
INSERT INTO [dbo].[FormWorkflows](    
       [Id],    
       [FormTypeId],    
       [WorkflowName],    
       [CreatedDateTime],    
       [CreatedByUserId]   
           
        )    
          SELECT  NEWID(),  
    @FormTypeId,    
          @WorkflowName,  
    @Currentdate,    
          @OperationsPerformedBy  
  
    SELECT Id FROM GenericForm WHERE Id = @FormTypeId   
        End