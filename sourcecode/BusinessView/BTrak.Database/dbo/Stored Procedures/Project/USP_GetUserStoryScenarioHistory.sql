-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-09-24 00:00:00.000'
-- Purpose      To Get the userstories scenarios history 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoryScenarioHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoryScenarioHistory]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @TestCaseId UNIQUEIDENTIFIER = NULL,
  @TestRunId UNIQUEIDENTIFIER = NULL,
  @ReportId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
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
           
           IF(@UserStoryId = '00000000-0000-0000-0000-000000000000') SET  @UserStoryId = NULL
          
		   SELECT TCH.Id AS UserStoryHistoryId,
                  US.UserStoryName,
                  TCH.OldValue,
                  TCH.NewValue,
                  TCH.FieldName,
                  TCH.TestCaseId,
				  TCH.UserStoryId,
				  TCH.ConfigurationId,
                  TC.Title TestCaseTitle,
                  TCS.Step StepText,
                  TCH.StepId,
				  TCS.Step,
				  TCS.StepOrder,
				  USS.UserStoryId,
				  TCS.ExpectedResult,
				  TR.[Name] TestRunName,
                  TCH.[Description],
                  TCH.CreatedByUserId,
                  TCH.CreatedDateTime,
                  U.FirstName +' '+ISNULL(U.SurName,'') as TestedByName,
                  U.ProfileImage TestedByProfileImage,
                  TotalCount = COUNT(1) OVER()
           FROM  [dbo].[TestCaseHistory] TCH WITH (NOLOCK)
                 INNER JOIN [dbo].[User] U ON U.Id = TCH.CreatedByUserId  AND U.InactiveDateTime IS NULL
                 LEFT JOIN [dbo].[UserStory] US ON US.Id = TCH.UserStoryId  AND US.InactiveDateTime IS NULL
                 LEFT JOIN TestCase TC ON TC.Id = TCH.TestCaseId  AND TC.InactiveDateTime IS NULL 
				 LEFT JOIN TestRun TR ON TR.Id = TCH.TestRunId and  tr.InactiveDateTime IS NULL
                 LEFT JOIN [UserStoryScenario] USS ON USS.TestCaseId = TCH.TestCaseId AND USS.UserStoryId = TCH.UserStoryId
                 LEFT JOIN [UserStoryScenarioStep] USSS ON USSS.StepId = TCH.StepId AND TCH.UserStoryId = @UserStoryId AND USSS.InActiveDateTime IS NULL
                 LEFT JOIN TestCaseStep TCS ON TCS.Id = TCH.StepId 
           WHERE U.CompanyId = @CompanyId 
                 AND (@UserStoryId IS NULL OR TCH.UserStoryId = @UserStoryId)
				 AND (@TestCaseId IS NULL OR TC.Id = @TestCaseId)
				 AND (@TestRunId IS NULL OR TR.Id = @TestRunId)
				 AND (@ReportId IS NULL OR (TCH.CreatedDateTime <= (SELECT CreatedDateTime FROM TestRailReport WHERE Id = @ReportId)))
				 AND (@TestRunId IS NULL 
                      OR TCH.CreatedDateTime >= (SELECT CreatedDateTime FROM TestRunSelectedCase 
                                                 WHERE TestRunId = @TestRunId AND TestCaseId = @TestCaseId AND InActiveDateTime IS NULL))
           ORDER BY TCH.CreatedDateTime DESC
        
        END
        ELSE
           RAISERROR (@HavePermission,11, 1)

     END TRY  
     BEGIN CATCH 
        
          THROW

    END CATCH
END
GO