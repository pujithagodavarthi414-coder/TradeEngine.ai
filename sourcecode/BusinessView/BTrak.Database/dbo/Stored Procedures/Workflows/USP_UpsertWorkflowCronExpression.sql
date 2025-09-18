CREATE PROCEDURE [dbo].[USP_UpsertWorkflowCronExpression]        
(        
   @CronExpression NVARCHAR(800) = NULL,        
   @WorkflowId  UNIQUEIDENTIFIER = NULL,        
   @IsArchived BIT = NULL,        
   @OperationsPerformedBy UNIQUEIDENTIFIER,         
   @ResponsibleUserId UNIQUEIDENTIFIER = NULL        
)        
AS        
BEGIN        
      
  IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL        
        
  IF(@CronExpression = '') SET @CronExpression = NULL        
        
  ELSE IF(@CronExpression IS NULL)        
  BEGIN        
             
      RAISERROR(50011,16, 2, 'CronExpression')        
        
  END        
  ELSE        
  BEGIN        
        
     DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))        
        
   IF (@HavePermission = '1')        
   BEGIN   
     
    DECLARE @OldWorkflowId UNIQUEIDENTIFIER = (SELECT ID FROM   [dbo].[WorkflowCronExpression] WHERE WorkflowId = @WorkflowId )  
        
 IF(@OldWorkflowId IS NULL)  
 BEGIN  
    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))        
    DECLARE @Id UNIQUEIDENTIFIER = NEWID()      
    DECLARE @Currentdate DATETIME = GETDATE()       
   INSERT INTO [dbo].[WorkflowCronExpression](        
                  [Id],      
      [CronExpression],      
      [WorkflowId],        
                  [InActiveDateTime],        
                  [CreatedDateTime],        
                  [CreatedByUserId],        
                  CompanyId,        
                  [ResponsibleUserId])        
               Select  @Id,        
            @CronExpression,      
                   @WorkflowId,        
        CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,        
                  @Currentdate,        
                  @OperationsPerformedBy,        
         @CompanyId,        
       @ResponsibleUserId        
      SELECT @Id AS JobId   
   END  
   ELSE  
   BEGIN  
   UPDATE [dbo].[WorkflowCronExpression] SET  
   [CronExpression] = @CronExpression  
   WHERE WorkflowId = @WorkflowId  
   SELECT @OldWorkflowId As JobId    
    END  
   END   
     
      
   END      
   END