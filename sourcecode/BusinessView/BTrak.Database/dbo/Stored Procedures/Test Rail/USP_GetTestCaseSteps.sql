-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-30 00:00:00.000'
-- Purpose      To Get TestCaseSteps with different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestCaseSteps] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = 'a31b0c81-28c4-4920-9f7e-0fd5b52f058f'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetTestCaseSteps]
(
	@TestCaseStepId UNIQUEIDENTIFIER = NULL,
	@TestCaseId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
	@FeatureId UNIQUEIDENTIFIER = NULL,
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
			
			IF(@TestCaseStepId = '00000000-0000-0000-0000-000000000000') SET @TestCaseStepId = NULL
			
			IF(@TestCaseId = '00000000-0000-0000-0000-000000000000') SET @TestCaseId = NULL
				
			SELECT TCS.Id,
				   TCS.[TestCaseId],
				   TC.Title,
				   TCS.[Step],
				   TCS.[ExpectedResult],
				   (CASE WHEN TCS.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived,
				   TCS.[CreatedDateTime],
				   TCS.[CreatedByUserId],
				   TotalCount = COUNT(1) OVER()
			FROM [TestCaseStep] TCS WITH (NOLOCK) 
				 INNER JOIN TestCase TC WITH (NOLOCK) ON TCS.TestCaseId = TC.Id 
				 INNER JOIN TestSuite TS WITH (NOLOCK)  ON TC.TestSuiteId  = TS.Id 
				 INNER JOIN Project P WITH (NOLOCK) ON TS.ProjectId = P.Id 
			WHERE P.CompanyId = @CompanyId
				  AND (@TestCaseStepId IS NULL OR TCS.Id = @TestCaseStepId)
				  AND (@TestCaseId IS NULL OR TCS.TestCaseId = @TestCaseId)
				  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND TCS.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND TCS.InActiveDateTime IS NULL)) 
		
		END
		ELSE
			RAISERROR (@HavePermission,11, 1)

	END TRY
	BEGIN CATCH
		
		EXEC USP_GetErrorInformation
	
	END CATCH
END
GO
