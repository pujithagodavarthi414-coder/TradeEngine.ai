-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the selected testcases only when select specific cases scenario
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestRunSelectedCases]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',

CREATE PROCEDURE [dbo].[USP_GetTestRunSelectedCases]
(
  @TestRunId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
  SET NOCOUNT ON
  BEGIN TRY
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
  
      DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
      IF (@HavePermission = '1')
      BEGIN

      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
      
            SELECT 
                  TRSC.TestCaseId,
                  TC.SectionId
             FROM [TestRunSelectedCase]TRSC INNER JOIN [TestCaseStatus]TCS ON TCS.Id = TRSC.StatusId  AND TRSC.InActiveDateTime IS NULL
                                            INNER JOIN [TestCase] TC ON TC.Id = TRSC.TestCaseId AND TC.InActiveDateTime IS NULL
             WHERE TRSC.TestRunId = @TestRunId 
                  AND (TCS.CompanyId = @CompanyId)
                  AND TCS.InActiveDateTime IS NULL

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