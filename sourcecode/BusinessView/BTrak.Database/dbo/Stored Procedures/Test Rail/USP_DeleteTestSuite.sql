-------------------------------------------------------------------------------
-- Author      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Delete TestSuiteSection
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_DeleteTestSuite] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d',@TestSuiteId = '4A4DED0A-581E-4295-BC57-F578E277BB29'

CREATE PROCEDURE [dbo].[USP_DeleteTestSuite]
(
    @TestSuiteId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 	
		
		  
		  DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestSuite WHERE Id = @TestSuiteId)
			
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
        
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF (@HavePermission = '1')
        BEGIN

		  DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
                                               FROM [TestSuite] WHERE Id = @TestSuiteId) = @TimeStamp
                                         THEN 1 ELSE 0 END)

           IF(@IsLatest = 1)
           BEGIN
		    
				DECLARE @CurrentDate DATETIME = GETDATE()

				DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestSuiteCreatedOrUpdated' AND CompanyId = @CompanyId )

				EXEC [USP_InsertTestRailAuditHistory] @TestSuiteId = @TestSuiteId,
													  @TestSuiteIsArchived = 1,
													  @ConfigurationId = @ConfigurationId,
									                  @OperationsPerformedBy = @OperationsPerformedBy

				UPDATE TestSuite SET InActiveDateTime = @CurrentDate,
									 UpdatedByUserId  = @OperationsPerformedBy,
									 UpdatedDateTime  = @CurrentDate
									 WHERE Id = @TestSuiteId

				IF(EXISTS(SELECT Id FROM Folder WHERE Id = @TestSuiteId  AND InActiveDateTime IS NULL))
				BEGIN

				DECLARE @FolderTimeStamp TIMESTAMP = (SELECT [TimeStamp] FROM [Folder] WHERE Id = @TestSuiteId AND InActiveDateTime IS NULL)
				
				EXEC [USP_DeleteFolder] @FolderId = @TestSuiteId,@TimeStamp = @FolderTimeStamp,@OperationsPerformedBy = @OperationsPerformedBy,@IsToReturn = 1
			   
			    END

				SELECT Id FROM TestSuite WHERE Id = @TestSuiteId

           END
           ELSE

				RAISERROR (50015,11, 1)
			
		END
        ELSE
        BEGIN
        
               RAISERROR (@HavePermission,11, 1)
               
        END	  
	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH
END
GO

