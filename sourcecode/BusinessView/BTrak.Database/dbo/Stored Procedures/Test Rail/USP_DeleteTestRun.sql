-------------------------------------------------------------------------------
-- Author      Mahesh Musuku
-- Created      '2019-05-31 00:00:00.000'
-- Purpose      To Delete TestRun
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_DeleteTestRun] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TestRunId='078185B0-A7AF-41B2-AB9F-712135993A5D'

CREATE PROCEDURE [dbo].[USP_DeleteTestRun]
(
    @TestRunId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	    
		DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestRun WHERE Id = @TestRunId)

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
        
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        IF (@HavePermission = '1')
        BEGIN
           DECLARE @IsLatest BIT = (CASE WHEN @TestRunId IS NULL 
                                               THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                         FROM [TestRun] WHERE Id = @TestRunId AND InActiveDateTime IS NULL) = @TimeStamp
                                                                 THEN 1 ELSE 0 END END)
              
			IF(@IsLatest = 1)
			BEGIN      
		
				DECLARE @Currentdate DATETIME = GETDATE()
				 
				DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestRunCreatedOrUpdated' AND CompanyId = @CompanyId )

				EXEC [USP_InsertTestRailAuditHistory] @TestRunId = @TestRunId,
													  @TestRunIsArchived = 1,
													  @ConfigurationId = @ConfigurationId,
									                  @OperationsPerformedBy = @OperationsPerformedBy
				     
				UPDATE TestRun SET UpdatedDateTime = @Currentdate,
								  UpdatedByUserId = @OperationsPerformedBy,
								  InActiveDateTime = @Currentdate
								  WHERE Id = @TestRunId
				
				IF(EXISTS(SELECT Id FROM Folder WHERE Id = @TestRunId  AND InActiveDateTime IS NULL))
				BEGIN

				DECLARE @FolderTimeStamp TIMESTAMP = (SELECT [TimeStamp] FROM [Folder] WHERE Id = @TestRunId AND InActiveDateTime IS NULL)
				
				EXEC [USP_DeleteFolder] @FolderId = @TestRunId,@TimeStamp = @FolderTimeStamp,@OperationsPerformedBy = @OperationsPerformedBy,@IsToReturn = 1
				
				END

				SELECT Id FROM [dbo].[TestRun] where Id = @TestRunId
			
			END
			ELSE
        
				RAISERROR (50008,11, 1)   
		
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
GO