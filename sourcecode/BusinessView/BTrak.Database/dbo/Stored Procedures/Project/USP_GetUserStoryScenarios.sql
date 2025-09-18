-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      2019-09-18
-- Purpose      To Get TestCases scenarios in project module testrailtab by applying different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUserStoryScenarios] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId='52bc14f8-078a-4a6a-9771-9d477be42e7d'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUserStoryScenarios]
(
    @TestCaseId UNIQUEIDENTIFIER = NULL,
    @TestCaseIdsXml XML = NULL,
    @UserStoryId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               IF(@TestCaseId = '00000000-0000-0000-0000-000000000000') SET @TestCaseId = NULL
               IF(@UserStoryId = '00000000-0000-0000-0000-000000000000') SET @UserStoryId = NULL
                              CREATE TABLE #TestCaseIds
                              (
                              TestCaseId UNIQUEIDENTIFIER
                              )
                              IF(@TestCaseIdsXml IS NOT NULL)
                              BEGIN
                                INSERT INTO #TestCaseIds
                                SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)') FROM  @TestCaseIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                              END
                                     SELECT TC.Id AS TestCaseId
                                           ,TC.Title
                                           ,USS.UserStoryId
                                           ,TC.[SectionId]
                                           ,TSS.SectionName
                                           ,TC.[TemplateId]
                                           ,TT.TemplateType AS TemplateName
                                           ,TC.[TypeId]
										   ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
																WHERE UF.ReferenceId = TC.Id AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'FFDFBE28-D3D9-49F9-9018-50E02D9C8F5B' 
															FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseFilePath
				                           ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                                                 WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '77F086EA-E23F-414D-AD14-D4725CEF36C2'
															FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseMissionFilePath
				                           ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                                                  WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'CFB83453-60DD-4EB5-9818-95CDB3478AC5'
															FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseGoalFilePath
				                           ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                                               WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'ED61D300-9A7C-450F-8942-2444DACEAD0F'
															FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS PreConditionFilePath
				                           ,Stuff((SELECT ',' + FilePath FROM UploadFile UF
				                                               WHERE UF.ReferenceId = TC.Id  AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '4232A177-164E-456C-B427-7BDEED92DA1D'
															FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseStepDescriptionFilePath
				                           ,Stuff((SELECT ',' + FilePath FROM UploadFile UF
				                                              WHERE UF.ReferenceId = TC.Id AND UF.ReferenceTypeId = '6520F42D-DA2E-40E2-BAFA-D5EE4D37F4A3'
															FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS ExpectedResultFilePath
                                           ,TCT.TypeName
                                           ,TC.[Estimate]
                                           ,TC.[References]
                                           ,TC.PreCondition
                                           ,TC.[ExpectedResult]
                                           ,TC.[CreatedDateTime]
                                           ,TC.[CreatedByUserId]
                                           ,TC.[Mission]
                                           ,TC.[Goals]
                                           ,TC.[PriorityId]
                                           ,TP.PriorityType
                                           ,TC.[AutomationTypeId]
                                           ,TCAT.AutomationType
                                           ,TC.[TestCaseId] AS TestCaseIdentity
                                           ,TC.[TestSuiteId]
                                           ,TC.Steps
										   ,(SELECT COUNT(1) FROM [UserStory] US
												 LEFT JOIN [Goal]G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
												 LEFT JOIN [Sprints]S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
												 INNER JOIN [UserStoryType]UST ON UST.Id = US.UserStoryTypeId 
												 INNER JOIN [UserStoryStatus]USSS ON USSS.Id = US.UserStoryStatusId AND USSS.InactiveDateTime IS NULL
												 INNER JOIN [TaskStatus] TS ON TS.Id = USSS.TaskStatusId AND TS.[Order] NOT IN (4,6)
												 WHERE US.TestCaseId = TC.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
												        AND US.ArchivedDateTime IS NULL AND UST.IsBug = 1 AND UST.CompanyId =@CompanyId)BugsCount
                                           ,USS.StatusId
                                           ,TCS2.[Status] StatusName
                                           ,TCS2.StatusHexValue StatusColor
                                           ,TC.CreatedDateTime
                                           ,(SELECT TCS.Id AS StepId
                                                   ,TCS.Step  AS StepText
												   ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
																						JOIN TestCaseStep TCS1 ON TCS1.Id = UF.ReferenceId 
						                                                                 AND TCS1.Id = TCS.Id
						                                                                WHERE   UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '225BEB5C-1A53-40BB-A29B-B03BE3FA2779'
                                                                                        FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS StepTextFilePath
                                                   ,TCS.StepOrder As StepOrder
                                                   ,USSS.UserStoryId
                                                   ,TCS.ExpectedResult   AS StepExpectedResult
												   ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
																				 JOIN TestCaseStep TCS1 ON TCS1.Id = UF.ReferenceId 
						                                                          AND TCS1.Id = TCS.Id
						                                                         WHERE   UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '3A3E185B-BD74-4DB6-86BC-677EB9AB1609'
                                                           FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS StepExpectedResultFilePath
                                                   ,TCS1.[Status] StepStatusName
                                                   ,TCS1.StatusHexValue StepStatusColor
                                                   ,TCS1.Id StepStatusId
                                             FROM TestCaseStep TCS INNER JOIN [UserStoryScenarioStep] USSS ON TCS.Id  = USSS.StepId AND TCS.InActiveDateTime IS NULL AND USSS.InActiveDateTime IS NULL
                                                                   INNER JOIN [TestCaseStatus] TCS1 ON USSS.StatusId = TCS1.Id AND TCS1.InActiveDateTime IS NULL
                                             WHERE TCS.TestCaseId = TC.Id AND TCS.InActiveDateTime IS NULL
                                             ORDER BY TCS.StepOrder
                                             FOR XML PATH('TestCaseStepMiniModel'), ROOT('TestCaseStepMiniModel'), TYPE) AS TestCaseStepsXml
                                           ,TC.[TimeStamp]
										   ,USS.[TimeStamp] UserStoryScenarioTimeStamp
                                           ,TotalCount = COUNT(1) OVER()
                                      FROM TestCase TC WITH (NOLOCK)
                                                 INNER JOIN [UserStoryScenario] USS WITH (NOLOCK) ON TC.Id = USS.TestCaseId AND USS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
												 INNER JOIN TestSuiteSection TSS WITH(NOLOCK) ON TSS.Id =TC.SectionId AND TSS.InActiveDateTime IS NULL
                                                 INNER JOIN TestCaseTemplate TT WITH (NOLOCK)ON TT.Id = TC.TemplateId
                                                 INNER JOIN TestCaseType TCT WITH(NOLOCK) ON TCT.Id=TC.TypeId
                                                 INNER JOIN TestCaseAutomationType TCAT WITH(NOLOCK) ON TCAT.Id = TC.AutomationTypeId
                                                 INNER JOIN TestCasePriority TP WITH(NOLOCK) ON TP.Id = TC.PriorityId 
                                                 INNER JOIN TestCaseStatus TCS2 WITH(NOLOCK) ON TCS2.Id = USS.StatusId AND TCS2.InActiveDateTime IS NULL
												 LEFT JOIN #TestCaseIds T ON T.TestCaseId = TC.Id
                                      WHERE TT.CompanyId = @CompanyId AND TCT.CompanyId = @CompanyId AND TCAT.CompanyId = @CompanyId AND TP.CompanyId = @CompanyId
                                             AND TC.InActiveDateTime IS NULL
                                             AND (@TestCaseId IS NULL OR TC.Id = @TestCaseId)
                                             AND (@UserStoryId IS NULL OR USS.UserStoryId = @UserStoryId)
                                             AND (@TestCaseIdsXml IS  NULL OR T.TestCaseId IS NOT NULL)
                                    ORDER BY CONVERT(INT,REPLACE(TC.TestCaseId,'C',0))
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO