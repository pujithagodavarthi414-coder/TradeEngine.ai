-------------------------------------------------------------------------------  
-- Author       Aruna
-- Created      '2021-05-27 00:00:00.000'  
-- Purpose      To Save or Update the ExitConfiguration  
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved  
-------------------------------------------------------------------------------  
  
CREATE PROCEDURE [dbo].[USP_UpsertExitConfiguration]  
(  
  @ExitId UNIQUEIDENTIFIER = NULL,  
  @ExitName  NVARCHAR(500) = NULL,  
  @IsShow BIT = NULL,  
  @IsArchived BIT = NULL,  
  @OperationsPerformedBy UNIQUEIDENTIFIER  
)  
AS  
BEGIN  
       SET NOCOUNT ON  
  
    BEGIN TRY  
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
  
     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))  
              
        IF (@HavePermission = '1')  
        BEGIN  
  
  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))  
  
  DECLARE @ExitIdCount INT = (SELECT COUNT(1) FROM ExitConfiguration WHERE Id = @ExitId AND CompanyId = @CompanyId)  
  
  DECLARE @ExitNameCount INT = (SELECT COUNT(1) FROM ExitConfiguration WHERE ExitName = @ExitName AND InActiveDateTime IS NULL AND CompanyId = @CompanyId AND (@ExitId IS NULL OR Id <> @ExitId))  
  
  IF(@ExitIdCount = 0 AND @ExitId IS NOT NULL)  
  BEGIN  
  
   RAISERROR(50002,16, 1,'ExitConfiguration')  
  
  END  
  ELSE IF(@ExitNameCount > 0)  
  BEGIN  
  
   RAISERROR(50001,16,1,'ExitConfiguration')  
  
  END  
  ELSE  
  BEGIN  
       
  DECLARE @CurrentDate DATETIME = GETDATE()  
  
  If(@ExitId IS NULL)  
  BEGIN  
     SET @ExitId = NEWID()  
       
     INSERT INTO [dbo].[ExitConfiguration](  
                                    [Id],  
                              [ExitName],  
             [IsShow],  
             InActiveDateTime,  
                              [CompanyId],  
                              [CreatedDateTime],  
                              [CreatedByUserId]  
                           )  
                           SELECT @ExitId,  
                                 @ExitName,  
             @IsShow,  
                                 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,  
                                 @CompanyId,  
                                 @Currentdate,  
                                 @OperationsPerformedBy  
                         
             END  
    ELSE  
    BEGIN  
  
           UPDATE [ExitConfiguration]   
              SET ExitName = @ExitName,  
         IsShow = @IsShow,  
            InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,  
         CompanyId =  @CompanyId,  
         UpdatedDateTime = @CurrentDate,  
         UpdatedByUserId = @OperationsPerformedBy  
         WHERE Id = @ExitId  
  
    END  
     
   SELECT Id FROM [dbo].[ExitConfiguration] WHERE Id = @ExitId  
  
   END  
   END  
      ELSE  
         BEGIN  
                   
     RAISERROR (@HavePermission,11, 1)  
                      
         END    
  END TRY    
     BEGIN CATCH   
    
     THROW  
  
    END CATCH  
  
END