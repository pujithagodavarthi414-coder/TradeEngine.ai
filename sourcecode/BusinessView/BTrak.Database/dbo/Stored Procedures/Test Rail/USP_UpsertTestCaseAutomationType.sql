-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To Save or update test case automation types
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------------------------------------------
--EXEC USP_UpsertTestCaseAutomationType @AutomationTypeName = 'Test',@IsArchived = 1,@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTestCaseAutomationType]
(
 @TestCaseAutomationTypeId UNIQUEIDENTIFIER = NULL,
 @AutomationTypeName  NVARCHAR(250) = NULL,
 @IsArchived BIT = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @TimeZone NVARCHAR(250) = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
 @IsDefault BIT = NULL
)
AS
BEGIN
   
      SET NOCOUNT ON
      BEGIN TRY 
      SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
​
        IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
        
        IF(@AutomationTypeName  = '') SET @AutomationTypeName  = NULL
        
        IF(@TestCaseAutomationTypeId = '00000000-0000-0000-0000-000000000000') SET @TestCaseAutomationTypeId = NULL    
​
         IF(@IsArchived = 1 AND @TestCaseAutomationTypeId IS NOT NULL)
         BEGIN
                
                      DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
                      
                      IF(EXISTS(SELECT Id FROM [TestCase] WHERE AutomationTypeId = @TestCaseAutomationTypeId  AND InActiveDateTime IS NULL))
                      BEGIN
                      
                      SET @IsEligibleToArchive = 'ThisTestCaseAutomationTypeUsedInTestCaseDeleteTheDependenciesAndTryAgain'
                      
                      END
                      
                      IF(@IsEligibleToArchive <> '1')
                      BEGIN
                      
                          RAISERROR (@isEligibleToArchive,11, 1)
                      
                      END
        END
​
        IF (@AutomationTypeName  IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'AutomationTypeName')
​
        END
        ELSE
        BEGIN
​
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
       
        IF (@HavePermission = '1')
        BEGIN
​
​
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	       SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			

           DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)
​
           DECLARE @Default BIT = (SELECT IsDefault FROM TestCaseAutomationType WHERE Id = @TestCaseAutomationTypeId  AND InActiveDateTime IS NULL)
​
           DECLARE @TestCaseAutomationTypeIdCount INT = (SELECT COUNT(1) FROM TestCaseAutomationType WHERE Id = @TestCaseAutomationTypeId  AND CompanyId = @CompanyId) 
​
           DECLARE @AutomationTypeNameCount INT = (SELECT COUNT(1) FROM  TestCaseAutomationType WHERE AutomationType = @AutomationTypeName AND (@TestCaseAutomationTypeId IS NULL OR Id <> @TestCaseAutomationTypeId ) AND CompanyId = @CompanyId) 
​
           IF(@TestCaseAutomationTypeIdCount = 0 AND @TestCaseAutomationTypeId IS NOT NULL)
           BEGIN
            
              RAISERROR(50002,16,1,'TestCaseAutomationType')
​
           END
           ELSE IF(@AutomationTypeNameCount > 0)
           BEGIN
​
              RAISERROR(50001,16,1,'TestCaseAutomationType')
​
           END
           ELSE IF (@Default = 1 AND @IsArchived = 1)
           BEGIN
​
              RAISERROR('SetDefaultToAnotherTestCaseBeforeDeletingThis',16,1)
​
           END
           ELSE IF (@Default = 1 AND @IsDefault = 0)
           BEGIN
​
              RAISERROR('SetDefaultToAnotherTestCaseBeforeEditingThis',16,1)
​
           END
           ELSE
           BEGIN
​
             DECLARE @IsLatest BIT = (CASE WHEN @TestCaseAutomationTypeId IS NULL THEN 1 ELSE 
                                      CASE WHEN (SELECT [TimeStamp] FROM TestCaseAutomationType WHERE Id = @TestCaseAutomationTypeId) = @TimeStamp THEN 1 ELSE 0 END END )
​
         
         IF (@IsLatest = 1)
           BEGIN
             
             --DECLARE @Currentdate DATETIME = GETDATE()
             
                UPDATE [TestCaseAutomationType]
                  SET  IsDefault = 0 ,
                       UpdatedDateTime = @Currentdate,
                       UpdatedByUserId = @OperationsPerformedBy
                       WHERE  CompanyId = @CompanyId  AND @IsDefault = 1 AND IsDefault = 1
             
             
             
              IF(@TestCaseAutomationTypeId IS NULL)
              BEGIN

              SET @TestCaseAutomationTypeId = NEWID()
​
              INSERT INTO TestCaseAutomationType( 
                                                 Id,
                                                 CompanyId,
                                                 AutomationType,
                                                 CreatedDateTime,
                                                 CreatedByUserId,
												 CreatedDateTimeZoneId,
                                                 InActiveDateTime,
                                                 IsDefault
                                               )
                                          SELECT @TestCaseAutomationTypeId,
                                                 @CompanyId,
                                                 @AutomationTypeName ,
                                                 @CurrentDate,
                                                 @OperationsPerformedBy,
												 @TimeZoneId,
                                                 CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
                                                 @IsDefault
               END
               ELSE
               BEGIN
                  UPDATE [TestCaseAutomationType]
                    SET  CompanyId = @CompanyId,
                         AutomationType = @AutomationTypeName,
                         UpdatedDateTime = @Currentdate,
                         UpdatedByUserId = @OperationsPerformedBy,
						 UpdatedDateTimeZoneId =  @TimeZoneId,
                         InActiveDateTime =  CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
                         InActiveDateTimeZoneId =  CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END,
                         IsDefault = @IsDefault
                         WHERE Id = @TestCaseAutomationTypeId
               END
                                        
                SELECT Id FROM TestCaseAutomationType WHERE Id = @TestCaseAutomationTypeId
​
            END
            ELSE
               RAISERROR(50008,16,1)
​
           END
            
           END
           ELSE
             RAISERROR(@HavePermission,11,1)
​
           END
​
      END TRY
​
    BEGIN CATCH
​
       THROW
​
    END CATCH
END
GO