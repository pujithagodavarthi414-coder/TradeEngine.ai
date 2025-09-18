-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the TestSuite
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'  
-- Purpose      To Save or update the TestSuite
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertTestSuite]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @ProjectId='53C96173-0651-48BD-88A9-7FC79E836CCE',@TestSuiteName='Sprint 7',@Description='Test Cases'
 -------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTestSuite]
(
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
    @ProjectId UNIQUEIDENTIFIER = NULL,
    @TestSuiteName NVARCHAR(250) = NULL,
    @Description NVARCHAR(999), 
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
       IF(@HavePermission = '1')
       BEGIN
		IF(@TestSuiteName = '') SET @TestSuiteName = NULL

		IF(@ProjectId IS NULL)
		BEGIN
		    
			RAISERROR(50011,16, 2, 'Project')

		END
		ELSE IF(@TestSuiteName IS NULL)
		BEGIN
			
		    RAISERROR(50011,16, 2, 'TestSuiteName')

		END
		ELSE
		BEGIN

			DECLARE @TestSuiteIdCount INT = 0
			DECLARE @OldSuiteName NVARCHAR(250) 
			
			 SELECT  @TestSuiteIdCount= COUNT(1),@OldSuiteName = TestSuiteName FROM TestSuite WHERE Id = @TestSuiteId GROUP BY TestSuiteName

		    DECLARE @TestSuiteNamesCount INT = (SELECT COUNT(1) FROM [dbo].[TestSuite] WHERE [TestSuiteName] = @TestSuiteName AND ProjectId = @ProjectId AND (Id <> @TestSuiteId OR @TestSuiteId IS NULL)  AND InactiveDateTime IS NULL)
				  
			IF(@TestSuiteIdCount = 0 AND @TestSuiteId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16, 1,'TestSuite')

			END
			ELSE IF(@TestSuiteNamesCount > 0)
			BEGIN

				RAISERROR(50001,16,1,'TestSuite')

			END	
			ELSE
			BEGIN
					
					DECLARE @IsLatest BIT = (CASE WHEN @TestSuiteId IS NULL 
					                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
				                                                           FROM [TestSuite] WHERE Id = @TestSuiteId) = @TimeStamp
																	THEN 1 ELSE 0 END END)
			  
			  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
				    IF(@IsLatest = 1)
					BEGIN

				       DECLARE @Currentdate DATETIME = GETDATE()
				       
				       DECLARE @FieldName NVARCHAR(100)
					   
					--   DECLARE @OldSuiteName NVARCHAR(50) = (SELECT TestSuiteName FROM TestSuite WHERE Id = @TestSuiteId AND InActiveDateTime IS NULL)

					   --IF(@TestSuiteId IS NULL)
        --               SET @FieldName = 'TestSuiteCreated'
        --               ELSE
        --               SET @FieldName = 'TestSuiteUpdated'
					   
					   DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteCreatedOrUpdated' AND CompanyId = @CompanyId )

				       IF(@TestSuiteId IS NULL)
					   BEGIN

					   SET @TestSuiteId =  NEWID()

					   INSERT INTO [dbo].[TestSuite](
				                    [Id],
				                    [TestSuiteName],
				                    [ProjectId],
				                    [Description],
				                    [InActiveDateTime],
				                    [CreatedDateTime],
				                    [CreatedByUserId]
									)
				             SELECT @TestSuiteId,
				                    @TestSuiteName,
				                    @ProjectId,
				                    @Description,
				                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
				                    @Currentdate,
				                    @OperationsPerformedBy

						SET @FieldName = 'TestSuiteCreated'

						EXEC [dbo].[USP_InsertTestCaseHistory] @OperationsPerformedBy = @OperationsPerformedBy,@FieldName= @FieldName,@NewValue=@TestSuiteName,@ConfigurationId = @ConfigurationId,@ReferenceId = @TestSuiteId,@Description = 'TestSuiteAdded'

						END
						ELSE
						BEGIN
						
						EXEC [USP_InsertTestRailAuditHistory] @TestSuiteId = @TestSuiteId,
															  @TestSuiteProjectId = @ProjectId,
															  @TestSuiteName = @TestSuiteName,
															  @TestSuiteDescription = @Description, 
															  @TestSuiteIsArchived = @IsArchived,
															  @ConfigurationId = @ConfigurationId,
									                          @OperationsPerformedBy = @OperationsPerformedBy

						UPDATE  [dbo].[TestSuite]
						        SET [Id]               = @TestSuiteId,
				                    [TestSuiteName]    = @TestSuiteName,
				                    [ProjectId]        = @ProjectId,
				                    [Description]      = @Description, 
				                   -- [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END, 
				                    [UpdatedDateTime]  = @Currentdate, 
				                    [UpdatedByUserId]  = @OperationsPerformedBy
									WHERE Id = @TestSuiteId
						
						 IF(@TestSuiteName <> @OldSuiteName)
						 BEGIN

						 UPDATE Folder SET FolderName = @TestSuiteName,
						                   UpdatedDateTime = @Currentdate,
										   UpdatedByUserId = @OperationsPerformedBy
										   WHERE Id = @TestSuiteId AND InActiveDateTime IS NULL

						 END

						END
​
				    SELECT Id FROM [dbo].[TestSuite] WHERE Id = @TestSuiteId
				               
				  END
					
					ELSE

				  	RAISERROR (50008,11, 1)

			END

		END
	END
    ELSE
    BEGIN
                      
         RAISERROR (@HavePermission,10, 1)
                   
    END     
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO