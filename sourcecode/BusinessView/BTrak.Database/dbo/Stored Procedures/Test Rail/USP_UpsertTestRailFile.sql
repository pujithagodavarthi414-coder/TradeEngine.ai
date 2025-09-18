-------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the TestRailFile
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the TestRailFile
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertTestRailFile]
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@FileName ='Sprint12'
--,@TestRailId='D8352F75-1152-4BCB-A896-7DFBD66FA803'
--,@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d'
--,@FilePathXml = '<ArrayOfString>
--                          <string>https://bviewstorage.blob.core.windows.net/localsiteuploads/letterH-88739f71-a980-40ea-b1d9-d0502284</string>
--                          <string>https://bviewstorage.blob.core.windows.net/localsiteuploads/letterH-88739f71-a980-40ea-b1d9-d0502284</string>
--                          <string>https://bviewstorage.blob.core.windows.net/localsiteuploads/letterH-88739f71-a980-40ea-b1d9-d0502284</string>
--                          <string>https://bviewstorage.blob.core.windows.net/localsiteuploads/letterH-88739f71-a980-40ea-b1d9-d0502284</string>
--                          <string>https://bviewstorage.blob.core.windows.net/localsiteuploads/letterH-88739f71-a980-40ea-b1d9-d0502284</string>
--                     </ArrayOfString>'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTestRailFile]
(
  @FileName  NVARCHAR(500) = NULL,
  @FilePathXml  XML = NULL,
  @TestRailId UNIQUEIDENTIFIER = NULL,
  @IsTestCasePreCondition BIT = NULL,
  @IsTestCaseStatus BIT = NULL,
  @IsTestCaseStep BIT = NULL,
  @IsTestRun BIT = NULL,
  @TestRunId UNIQUEIDENTIFIER = NULL,
  @IsTestPlan BIT = NULL,
  @IsMilestone BIT = NULL,
  @IsTestCase BIT = NULL,
  @IsExpectedResult BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
       SET NOCOUNT ON

	   BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
				DECLARE @TestRailFile TABLE
				(
					TestRailFileId UNIQUEIDENTIFIER,
					[FileName] NVARCHAR(500),
					[FilePath] NVARCHAR(800),
					VersionNumber INT,
					[IsArchived] BIT,
					OriginalId UNIQUEIDENTIFIER
				)

				--INSERT INTO @TestRailFile([FileName],[FilePath])
				--SELECT [FileName],[FilePath]
				--FROM [TestRailFile] TF 
				--WHERE (@TestRailId IS NULL OR TF.TestRailId = @TestRailId)
				--       AND (@IsTestCasePreCondition IS NULL OR IsTestCasePreCondition = @IsTestCasePreCondition)
				--       AND (@IsTestCaseStatus IS NULL OR IsTestCaseStatus = @IsTestCaseStatus)
				--       AND (@IsTestCaseStep IS NULL OR IsTestCaseStep = @IsTestCaseStep)
				--       AND (@IsTestRun IS NULL OR IsTestRun = @IsTestRun)
				--       AND (@IsTestPlan IS NULL OR IsTestPlan = @IsTestPlan)
				--       AND (@IsMilestone IS NULL OR IsMilestone = @IsMilestone)
				--       AND (@IsTestCase IS NULL OR IsTestCase = @IsTestCase)
				--       AND (@TestRunId IS NULL OR TestRunId = @TestRunId)
				--	   AND (@IsExpectedResult IS NULL OR IsExpectedResult = @IsExpectedResult)
				--       AND TF.CompanyId = @CompanyId
				
				DECLARE @Currentdate DATETIME = GETDATE()
        
				INSERT INTO @TestRailFile(TestRailFileId,[FilePath])
				SELECT NEWID(),[Table].[Column].value('(text())[1]', 'nvarchar(500)')
				FROM @FilepathXml.nodes('/ArrayOfString/string') AS [Table]([Column])
				
				UPDATE [TestRailFile] SET InActiveDateTime = @Currentdate WHERE TestRailId = @TestRailId
				                           AND (@IsTestCasePreCondition IS NULL OR IsTestCasePreCondition = @IsTestCasePreCondition)
				                           AND (@IsTestCaseStatus IS NULL OR IsTestCaseStatus = @IsTestCaseStatus)
				                           AND (@IsTestCaseStep IS NULL OR IsTestCaseStep = @IsTestCaseStep)
				                           AND (@IsTestRun IS NULL OR IsTestRun = @IsTestRun)
				                           AND (@IsTestPlan IS NULL OR IsTestPlan = @IsTestPlan)
				                           AND (@IsMilestone IS NULL OR IsMilestone = @IsMilestone)
				                           AND (@IsTestCase IS NULL OR IsTestCase = @IsTestCase)
				                           AND (@TestRunId IS NULL OR TestRunId = @TestRunId)
					                       AND (@IsExpectedResult IS NULL OR IsExpectedResult = @IsExpectedResult)
				                           AND  CompanyId = @CompanyId

				INSERT INTO [dbo].[TestRailFile](
				            [Id],
					        [FileName],
					        [FilePath],
					        [TestRailId],
							[TestRunId],
					        [IsTestCasePreCondition],
					        [IsTestCaseStatus],
					        [IsTestCaseStep],
					        [IsTestRun],
					        [IsTestPlan],
					        [IsMilestone],
					        [IsTestCase],
							[IsExpectedResult],
					        [CompanyId],
							[InActiveDateTime],
					        [CreatedDateTime],
					        [CreatedByUserId])
			         SELECT TestRailFileId,
			         		ISNULL([FileName],@FileName),
			         		[FilePath],
			         		@TestRailId,
							@TestRunId,
			         		@IsTestCasePreCondition,
			         		@IsTestCaseStatus,
			         		@IsTestCaseStep,
			         		@IsTestRun,
			         		@IsTestPlan,
			         		@IsMilestone,
			         		@IsTestCase,
							@IsExpectedResult,
			         		@CompanyId,
							CASE WHEN IsArchived = 1 THEN @Currentdate ELSE NULL END,
			         		@Currentdate,
			         		@OperationsPerformedBy
			           FROM @TestRailFile

				 SELECT Id FROM [dbo].[TestRailFile] where [TimeStamp] = (SELECT MAX(TimeStamp) FROM [TestRailFile])

		END TRY  
	    BEGIN CATCH 
		
		   THROW

	   END CATCH

END
GO