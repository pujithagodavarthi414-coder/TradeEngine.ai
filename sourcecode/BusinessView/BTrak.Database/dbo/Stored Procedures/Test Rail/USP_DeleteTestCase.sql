-------------------------------------------------------------------------------
-- Author      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Delete TestCase
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_DeleteTestCase] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d',@TestCaseId = '29F53952-98AD-4DF5-A8BC-0A31545B706F'


CREATE PROCEDURE [dbo].[USP_DeleteTestCase]
(
    @TestCaseId NVARCHAR(MAX) = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY
			
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 	
	              
	IF (@TestCaseId = '') SET @TestCaseId = NULL
	    
	CREATE TABLE #TestCases 
	(
		TestCaseId UNIQUEIDENTIFIER
	)
		
	IF(@TestCaseId IS NOT NULL)
	BEGIN
		INSERT INTO #TestCases(TestCaseId)
		SELECT [Value] FROM [dbo].[Ufn_StringSplit](@TestCaseId,',')
	END

	DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestCase TC INNER JOIN TestSuiteSection TSS ON TC.SectionId = TSS.Id
	                                                                 INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId
																	 WHERE TC.Id = (SELECT TOP 1 TestCaseId FROM #TestCases))

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

	  IF (@HavePermission = '1')
       BEGIN
           DECLARE @IsLatest BIT = 1
										 --(CASE WHEN (SELECT [TimeStamp]
           --                                    FROM [TestCase] WHERE Id = @TestCaseId ) = @TimeStamp
           --                              THEN 1 ELSE 0 END)
           IF(@IsLatest = 1)
           BEGIN
               
               DECLARE @CurrentDate DATETIME = SYSDATETIMEOFFSET()
               
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                
				DECLARE @ConfigurationId UNIQUEIDENTIfier = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId)						           

		    EXEC [USP_InsertTestCaseHistory] @TestCaseId = @TestCaseId, @OldValue = 'No', @NewValue = 'Yes', @FieldName = 'TestCaseDeleted',
		                                     @Description = 'TestCaseDeleted', @OperationsPerformedBy = @OperationsPerformedBy, @ConfigurationId = @ConfigurationId

				UPDATE TestCase SET InActiveDateTime =  @CurrentDate,
				                     UpdatedByUserId =  @OperationsPerformedBy,
									 UpdatedDateTime =  @CurrentDate
									 WHERE Id IN (SELECT TestCaseId FROM #TestCases)

			DECLARE @TestCaseIds UNIQUEIDENTIFIER,@FolderTimeStamp TIMESTAMP 
			
			DECLARE Cursor_Script CURSOR
			FOR SELECT TC.TestCaseId AS TestCaseId,F.[TimeStamp] AS FolderTimeStamp
			    FROM Folder F
				INNER JOIN #TestCases TC ON TC.TestCaseId = F.Id 
				AND F.InActiveDateTime IS NULL
			 
			OPEN Cursor_Script
			         
			            FETCH NEXT FROM Cursor_Script INTO 
			                @TestCaseIds,@FolderTimeStamp
			             
			            WHILE @@FETCH_STATUS = 0
			            BEGIN
			
			               EXEC [USP_DeleteFolder] @FolderId = @TestCaseIds,@TimeStamp = @FolderTimeStamp
			                 ,@OperationsPerformedBy = @OperationsPerformedBy,@IsToReturn = 1
			
						    FETCH NEXT FROM Cursor_Script INTO 
			                @TestCaseIds,@FolderTimeStamp
			
						END
			
			CLOSE Cursor_Script
			
			DEALLOCATE Cursor_Script


				--IF(EXISTS(SELECT Id FROM Folder WHERE Id = @TestCaseId  AND InActiveDateTime IS NULL))
				--BEGIN

				--DECLARE @FolderTimeStamp TIMESTAMP = (SELECT [TimeStamp] FROM [Folder] 
    --                                                  WHERE Id = @TestCaseId AND InActiveDateTime IS NULL)
				
				--EXEC [USP_DeleteFolder] @FolderId = @TestCaseId,@TimeStamp = @FolderTimeStamp
    --             ,@OperationsPerformedBy = @OperationsPerformedBy,@IsToReturn = 1

				--END
				
		  SELECT @TestCaseId			   

           END
           ELSE
               RAISERROR (50015,11, 1)
      
	  END
       ELSE
           RAISERROR (@HavePermission,11, 1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
