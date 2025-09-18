-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the TestRailFiles By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_SearchTestRailFiles] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = 'a31b0c81-28c4-4920-9f7e-0fd5b52f058f'

CREATE PROCEDURE [dbo].[USP_SearchTestRailFiles]
(
	@TestRailFileId UNIQUEIDENTIFIER = NULL,
	@TestRailId UNIQUEIDENTIFIER = NULL,
	@FileId UNIQUEIDENTIFIER = NULL,
	@IsTestCasePreCondition BIT = NULL,
	@IsTestCaseStatus BIT = NULL,
	@IsTestCaseStep BIT = NULL,
	@IsTestRun BIT = NULL,
	@IsTestPlan BIT = NULL,
	@IsMilestone BIT = NULL,
	@IsTestCase BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

 SET NOCOUNT ON

	 BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF (@TestRailFileId = '00000000-0000-0000-0000-000000000000') SET @TestRailFileId = NULL
			
			IF (@TestRailId = '00000000-0000-0000-0000-000000000000') SET @TestRailId = NULL

			IF (@FileId = '00000000-0000-0000-0000-000000000000') SET @FileId = NULL

			SELECT TF.Id AS TestRailFileId,
				   TF.[FileName],
				   TF.FilePath,
				   TF.TestRailId,
				   TF.IsTestCasePreCondition,
				   TF.IsTestCaseStatus,
				   TF.IsTestCaseStep,
				   TF.IsTestRun,
				   TF.IsTestPlan,
				   TF.IsMilestone,
				   TF.IsTestCase,
				   TF.CompanyId,
				   TF.CreatedByUserId,
				   TotalCount = COUNT(1) OVER() 
			  FROM [TestRailFile] TF WITH (NOLOCK)
			  WHERE (@TestRailFileId IS NULL OR TF.Id = @TestRailFileId)
					AND (@TestRailId IS NULL OR TF.TestRailId = @TestRailId)
					AND (@FileId IS NULL OR TF.Id = @FileId)
					AND (@IsTestCasePreCondition IS NULL OR IsTestCasePreCondition = @IsTestCasePreCondition)
					AND (@IsTestCaseStatus IS NULL OR IsTestCaseStatus = @IsTestCaseStatus)
					AND (@IsTestCaseStep IS NULL OR IsTestCaseStep = @IsTestCaseStep)
					AND (@IsTestRun IS NULL OR IsTestRun = @IsTestRun)
					AND (@IsTestPlan IS NULL OR IsTestPlan = @IsTestPlan)
					AND (@IsMilestone IS NULL OR IsMilestone = @IsMilestone)
					AND (@IsTestCase IS NULL OR IsTestCase = @IsTestCase)
					AND TF.CompanyId = @CompanyId
		  ORDER BY TF.CreatedDateTime,TF.[TimeStamp]  

			 
	END TRY  
	BEGIN CATCH 
		
		 EXEC USP_GetErrorInformation

	END CATCH

END
GO
