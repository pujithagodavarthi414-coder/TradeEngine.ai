-------------------------------------------------------------------------------
-- Modified      Mahesh Musuku
-- Created      '2019-05-01 00:00:00.000'
-- Purpose      To Search the testcases in selected testrun
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

-- EXEC [dbo].[USP_GetTestRunCaseDetailsById]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@TestCaseId='0DD56653-41AB-44CF-B7AB-17C0F463D78B',

CREATE PROCEDURE [dbo].[USP_GetTestRunCaseDetailsById]
(
  @TestRunId UNIQUEIDENTIFIER = NULL,
  @TestCaseId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @SectionId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
  SET NOCOUNT ON
  BEGIN TRY
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
  
     DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF(@HavePermission = '1')
	BEGIN

     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       
             IF(@TestRunId = '00000000-0000-0000-0000-000000000000') SET @TestRunId = NULL
        
             IF(@TestCaseId = '00000000-0000-0000-0000-000000000000') SET @TestCaseId = NULL

			 DECLARE @BugCount INT = (SELECT COUNT(1)Counts FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND  US.TestCaseId = @TestCaseId AND
								                US.InactiveDateTime IS NULL AND G.InactiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
												INNER JOIN UserStoryType UST  WITH(NOLOCK) ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL  AND UST.IsBug = 1 
												INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US.UserStoryStatusId AND USSS.InactiveDateTime IS NULL 
												AND USSS.TaskStatusId NOT IN ('884947DF-579A-447A-B28B-528A29A3621D','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'))
         			  			  	 
         SELECT TSC.[Id] AS TestRunSelectedCaseId
                ,TSC.TestRunId
                ,TSC.TestCaseId
                ,TC.[Title]
                ,TC.SectionId
                ,TC.TemplateId
                ,TCT.TemplateType TemplateName 
                ,TC.TestCaseId TestCaseIdentity
                ,TC.TestSuiteId
                ,TC.TypeId
				 ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
						              WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'FFDFBE28-D3D9-49F9-9018-50E02D9C8F5B' 
                                     FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseFilePath
				,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                      WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '77F086EA-E23F-414D-AD14-D4725CEF36C2'
                FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseMissionFilePath,
				Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                       WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'CFB83453-60DD-4EB5-9818-95CDB3478AC5'
                               FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseGoalFilePath,
				Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                    WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'ED61D300-9A7C-450F-8942-2444DACEAD0F'
                               FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS PreConditionFilePath,
				Stuff((SELECT ',' + FilePath FROM UploadFile UF
				                    WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '4232A177-164E-456C-B427-7BDEED92DA1D'
                               FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseStepDescriptionFilePath,
				Stuff((SELECT ',' + FilePath FROM UploadFile UF
				                   WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '6520F42D-DA2E-40E2-BAFA-D5EE4D37F4A3'
                FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS ExpectedResultFilePath
               ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
						        WHERE UF.ReferenceId = TSC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'E6A6B453-3D12-4F24-894F-E923FFB1C154'
                            FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS AssigneeCommentFilePath
				,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                      WHERE UF.ReferenceId = TSC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '37EF5578-77AA-4A44-AB1E-BE76B585B2CE'
                FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS StatusCommentFilePath
			   ,TT.TypeName
                ,TC.Estimate
                ,TC.[References]
                ,TC.[ExpectedResult]
                ,TC.Steps
                ,TC.Mission
                ,TC.Goals
                ,TC.PriorityId
                ,TP.PriorityType
                ,TC.AutomationTypeId
                ,TCAT.AutomationType
                ,TC.PreCondition
                ,TSC.AssignToId
                ,TSC.AssignToComment
                ,TSC.[Version]
				,@BugCount BugsCount
                ,TSC.Elapsed
                ,TSC.StatusId
                ,TCS.[Status] AS StatusName
                ,TCS.StatusHexValue AS StatusColor 
				,TSC.StatusComment
              --  ,StatusCommentFilePath
                ,U.FirstName + ' ' + U.SurName AssignToName
                ,U.ProfileImage AssignToProfileImage  
                ,CU.FirstName + ' ' + CU.SurName TestedBy
                ,TSC.[CreatedDateTime]
                ,TSC.[CreatedByUserId]
                ,(SELECT(SELECT TCS.Id AS StepId
                            ,TCS.Step  AS StepText
							,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
									JOIN TestCaseStep TCS1 ON TCS1.Id = UF.ReferenceId 
						            AND TCS1.Id = TCS.Id
						           WHERE  UF.InActiveDateTime IS NULL AND  UF.ReferenceTypeId = '225BEB5C-1A53-40BB-A29B-B03BE3FA2779'
                                   FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS StepTextFilePath
                            ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
							 							 JOIN TestCaseStep TCS1 ON TCS1.Id = UF.ReferenceId 
						                                   AND TCS1.Id = TCS.Id
						                                  WHERE   UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '3A3E185B-BD74-4DB6-86BC-677EB9AB1609'
                                    FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS StepExpectedResultFilePath
							,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
												 JOIN TestCaseStep TCS1 ON TCS1.Id = UF.ReferenceId 
						                           AND TCS1.Id = TCS.Id
						                          WHERE   UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'F86D67E1-D351-4A76-9FDD-06D1A9D84181'
                            FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS StepActualResultFilePath
							
                            ,TCS.ExpectedResult   AS StepExpectedResult
                            --,TRF1.StepExpectedResultFilePath
							,TRSS.ActualResult AS StepActualResult
                            --,TRF1.StepActualResultFilePath
							,TRSS.Id TestRunSelectedStepId
                            ,TRSS.StatusId AS StepStatusId
                            ,TCRSS.StatusHexValue StepStatusColor
                            ,TCRSS.[Status] StepStatusName 
                      FROM TestCaseStep TCS  
                           INNER JOIN TestRunSelectedStep TRSS WITH (NOLOCK) ON TRSS.StepId = TCS.Id AND TCS.TestCaseId = TC.Id AND TCS.TestCaseId = TC.Id AND TCS.InActiveDateTime IS NULL 
														   AND TRSS.TestRunId = @TestRunId AND TRSS.InActiveDateTime IS NULL AND TCS.InActiveDateTime IS NULL
                           INNER JOIN TestCaseStatus TCRSS WITH (NOLOCK) ON TCRSS.Id = TRSS.StatusId AND TCRSS.InActiveDateTime IS NULL
                      GROUP BY TCS.Id,TCS.Step,TRSS.ActualResult,TCS.ExpectedResult,
					  TRSS.Id,TRSS.StatusId,TCRSS.StatusHexValue,TCRSS.[Status],TCS.StepOrder--,TRF1.StepTextFilePath,TRF1.StepActualResultFilePath,TRF1.StepExpectedResultFilePath
					  ORDER BY TCS.StepOrder
					  FOR JSON PATH)) TestCaseStepsXml
                    ,(SELECT(SELECT TCH.Id,
					          TCH.TestCaseId,
							  TCH.FieldName,
							  TCH.OldValue,
							  TCH.NewValue+' '+ISNULL(TCH.FilePath,'') NewValue,
							  TCS.Step,
							  TCS.ExpectedResult,
							  TCH.CreatedDateTime,
							  U.FirstName + ' ' + U.SurName TestedByName,
							  U.ProfileImage  TestedByProfileImage,  
							  TCH.CreatedByUserId
							FROM TestCaseHistory TCH INNER JOIN [User]U ON U.Id = TCH.CreatedByUserId  AND TSC.CreatedDateTime <= TCH.CreatedDateTime AND TCH.TestCaseId = TSC.TestCaseId AND TCH.TestRunId = TSC.TestRunId
							                         LEFT JOIN TestCaseStep TCS ON TCS.Id = TCH.StepId
							ORDER BY TCH.CreatedDateTime DESC,TCH.[TimeStamp]
							FOR JSON PATH)) TestCaseHistoryXml
                ,TSC.[TimeStamp]
                ,TotalCount = COUNT(1) OVER()
               FROM TestRunSelectedCase TSC WITH (NOLOCK)
                  INNER JOIN TestCase TC WITH (NOLOCK) ON TC.Id = TSC.TestCaseId AND TC.INActiveDateTime IS NULL AND TSC.TestRunId = @TestRunId
				  AND (@TestCaseId IS NULL OR TSC.TestCaseId = @TestCaseId) AND TSC.InActiveDateTime IS NULL
                  INNER JOIN TestCaseStatus TCS WITH (NOLOCK) ON TSC.StatusId = TCS.Id 
                  INNER JOIN TestCaseTemplate TCT WITH (NOLOCK) ON TCT.Id = TC.TemplateId
                  INNER JOIN TestCaseType TT WITH (NOLOCK) ON  TT.Id = TC.TypeId
                  INNER JOIN TestCasePriority TP  WITH (NOLOCK) ON TP.Id = TC.PriorityId
                  INNER JOIN TestCaseAutomationType TCAT  WITH (NOLOCK) ON TCAT.Id = TC.AutomationTypeId
                  LEFT JOIN  [User]U  WITH (NOLOCK) ON U.Id = TSC.AssignToId
                  INNER JOIN [User]CU  WITH (NOLOCK) ON CU.Id = TC.CreatedByUserId
		WHERE (TCT.CompanyId = @CompanyId)
                 AND (@TestRunId IS NULL OR TSC.TestRunId = @TestRunId)
                 AND (@SectionId IS NULL OR TC.SectionId =@SectionId)
                 AND (@TestCaseId IS NULL OR TSC.TestCaseId = @TestCaseId)
                 AND TSC.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
			 GROUP BY  TSC.[Id],TSC.TestRunId,TSC.TestCaseId,TC.[Title],TC.SectionId,TC.TemplateId,TCT.TemplateType,TC.TestCaseId,TC.TestSuiteId,TC.TypeId
			           ,TT.TypeName,TC.Estimate,TC.[References],TC.[ExpectedResult] ,TC.Steps,TC.Mission,TC.Goals,TC.PriorityId,TP.PriorityType
                ,TC.AutomationTypeId,TCAT.AutomationType,TC.PreCondition  ,TSC.AssignToId,TSC.AssignToComment,TSC.[Version],TSC.Elapsed,TSC.StatusId
                ,TCS.[Status] ,TCS.StatusHexValue ,TSC.StatusComment,U.FirstName,U.SurName,U.ProfileImage,CU.FirstName ,CU.SurName,TSC.[CreatedDateTime]
                ,TSC.[TimeStamp],TSC.CreatedByUserId,TC.Id,TSC.CreatedDateTime
    
	END
	ELSE
	BEGIN
	
	     RAISERROR (@HavePermission,16, 1)
	
	END
  END TRY
  BEGIN CATCH

      THROW

  END CATCH
END
GO