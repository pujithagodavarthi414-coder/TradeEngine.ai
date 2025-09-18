-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-08-01 00:00:00.000'
-- Purpose      To Get the selected testsuite sections only when select specific cases scenario
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestRunSelectedSections] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetTestRunSelectedSections]
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
       
      
                                    SELECT T.SectionId FROM 
                                                       (SELECT TC.SectionId,
													           COUNT(TRC.TestCaseId) TestCaseCount 
															   FROM TestRunSelectedCase TRC 
                                                       JOIN TestCase TC ON TC.Id = TRC.TestCaseId
												       JOIN TestCaseStatus TCS ON TCS.Id = TRC.StatusId 
													   AND TCS.InActiveDateTime IS NULL
                                                       AND TRC.InActiveDateTime IS NULL
                                                       AND TC.InActiveDateTime IS NULL
                                                       WHERE TestRunId = @TestRunId AND TCS.CompanyId = @CompanyId
                                                       GROUP BY TC.SectionId) T 
                                                       JOIN 
                                                       (SELECT TC.SectionId,COUNT(TC.Id) TestCaseCount FROM TestSuiteSection TS
                                                       JOIN TestCase TC ON TC.SectionId = TS.Id
                                                       AND TS.InActiveDateTime IS NULL
                                                       AND TC.InActiveDateTime IS NULL
                                                       GROUP BY TC.SectionId) J ON T.SectionId = J.SectionId AND T.TestCaseCount = J.TestCaseCount
  
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