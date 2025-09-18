-------------------------------------------------------------------------------
-- Modified      Mahesh Musuku
-- Created      '2019-09-04 00:00:00.000'
-- Purpose      To Get the testcases for each section in reports tab dropdown
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetHierarchicalCases]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ReportId='BD7211F6-F6C8-42B0-B306-16567764BC6A'

CREATE PROCEDURE [dbo].[USP_GetHierarchicalCases]
(
 
   @ProjectId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @MilestoneId  UNIQUEIDENTIFIER = NULL,
   @ReportId  UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
  SET NOCOUNT ON
  BEGIN TRY

  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
  
     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
         
	  CREATE TABLE #Temp
		 (
		 TestCaseId UNIQUEIDENTIFIER,
		 TestRunId UNIQUEIDENTIFIER,
		 AssignToId UNIQUEIDENTIFIER,
		 TestCaseTitle NVARCHAR(MAX),
		 TestedByUserId UNIQUEIDENTIFIER,
		 StatusId UNIQUEIDENTIFIER,
		 ReportId UNIQUEIDENTIFIER,
		 SectionId UNIQUEIDENTIFIER
		 )
		 INSERT INTO #Temp(TestCaseId,TestRunId,AssignToId,TestCaseTitle,TestedByUserId,StatusId,ReportId,SectionId)
		 SELECT TCR.TestCaseId,
		        TestRunId,
				AssignToId,
				TestCaseTitle,
				TestedByUserId,
				StatusId ,
				ReportId,
				TC.SectionId
				FROM TestCasesReport TCR INNER JOIN TestCase TC ON TC.Id = TCR.TestCaseId AND TC.InActiveDateTime IS NULL
				                         INNER JOIN TestSuiteSection TSS  ON TC.SectionId = TSS.Id  AND TSS.InActiveDateTime IS NULL
				WHERE ReportId = @ReportId AND TCR.InActiveDateTime IS NULL 
				ORDER BY TSS.CreatedDateTime OFFSET 0 ROW FETCH NEXT 100 ROW ONLY
                
				
				    SELECT T.SectionId,
			               TSS.SectionName,
					       TSS.ParentSectionId ,
						   (SELECT COUNT(1) FROM #Temp WHERE SectionId = TSS.Id)CasesCount,
		                   (SELECT 
                              TCR.TestCaseId
                             ,TCR.TestCaseTitle AS Title
                             ,TCR.TestRunId
							 ,TR1.[Name] TestRunName
                             ,TC.TestCaseId TestCaseIdentity
                             ,TCR.AssignToId
                             ,TCS.[Status] AS StatusName
                             ,TCS.StatusHexValue AS StatusColor 
                             ,U.FirstName + ' ' + U.SurName AssignToName
                             ,TU.FirstName + ' ' + TU.SurName TestedByUserName
                             ,U.ProfileImage AssignToProfileImage  
                             --,TotalCount = COUNT(1) OVER()
                             ,CASE WHEN (SELECT COUNT(1) FROM TestRunSelectedCase TRSC 
                                                                          INNER JOIN TestCase TC1 ON TC1.Id = TRSC.TestCaseId  AND TC1.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL 
                                                                          INNER JOIN TestSuiteSection TSS ON TSS.Id = TC1.SectionId  AND TSS.InActiveDateTime IS NULL
                                                                          INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId  AND TS.InActiveDateTime IS NULL AND TR1.InActiveDateTime IS NULL
                                                                          INNER JOIN TestRun TR1 ON TR1.Id = TRSC.TestRunId AND TRSC.InActiveDateTime IS NULL AND TR1.InActiveDateTime IS NULL
                                                                         WHERE TRSC.TestCaseId = TCR.TestCaseId  AND TRSC.TestRunId = TCR.TestRunId)>0 THEN 0 ELSE 1 END AS IsDeleted
                             ,TC.CreatedByUserId
                               FROM  #Temp TCR INNER JOIN   TestCase TC WITH(NOLOCK) ON TCR.TestCaseId = TC.Id AND TC.InActiveDateTime IS NULL --AND TCR.AsAtInActiveDateTime IS NULL AND TCR.InActiveDateTime IS NULL
                               INNER JOIN TestCaseStatus TCS  WITH (NOLOCK) ON TCR.StatusId = TCS.Id AND TCS.InactiveDateTime IS NULL  
                               LEFT JOIN [User]TU  WITH (NOLOCK) ON TU.Id = TCR.TestedByUserId
                               INNER JOIN TestRun TR1 ON TR1.Id = TCR.TestRunId  AND TR1.InActiveDateTime IS NULL
							   LEFT JOIN [User]U  WITH (NOLOCK) ON U.Id = TCR.AssignToId 
                               WHERE TCR.ReportId = @ReportId AND TC.SectionId = T.SectionId
                               ORDER BY TCS.CreatedDateTime,TCS.[TimeStamp]
                               FOR XML PATH('TestRailReportsMiniModel'), ROOT('TestCaseModel'), TYPE) AS TestCasesXml
		                    FROM
                            (SELECT PS.SectionId
                                     FROM #Temp TCR CROSS APPLY Ufn_GetMultiSectionLevel(TCR.SectionId)PS
                                     WHERE TCR.ReportId = @ReportId 
                                     GROUP BY PS.SectionId)T INNER JOIN TestSuiteSection TSS ON TSS.Id = T.SectionId AND TSS.InActiveDateTime IS NULL ORDER BY TSS.CreatedDateTime
		                    		                        
					              
    
  END TRY
  BEGIN CATCH

      THROW

  END CATCH
END

