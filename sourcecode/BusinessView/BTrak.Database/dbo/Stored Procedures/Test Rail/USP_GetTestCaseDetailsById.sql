-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      2019-09-10
-- Purpose      To Get TestCases Details By applying testcaseid filter
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestCaseDetailsById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetTestCaseDetailsById]
(
    @TestCaseId UNIQUEIDENTIFIER = NULL,
    @SectionId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)       
AS
BEGIN
    
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
               IF(@TestCaseId = '00000000-0000-0000-0000-000000000000') SET @TestCaseId = NULL
               
               IF(@SectionId = '00000000-0000-0000-0000-000000000000') SET @SectionId = NULL
               
		       DECLARE @TestCaseIdCount INT  = (SELECT  COUNT(1) FROM TestCase WHERE Id = @TestCaseId AND InActiveDateTime IS NULL)

		       IF(@TestCaseIdCount = 0 AND @TestCaseId IS NOT NULL)
               BEGIN
                  
			      RAISERROR(50002,16, 1,'TestCase')
               
			   END
               
              
		 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	     IF(@HavePermission = '1')
	     BEGIN

									 SELECT TC.Id AS TestCaseId 
                                           ,TC.Title 
                                           ,TC.[SectionId]
                                           ,TSS.SectionName      
                                           ,TC.[TemplateId]  
                                           ,TT.TemplateType AS TemplateName    
                                           ,TC.[TypeId] 
										   ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
						                                WHERE UF.CompanyId = @CompanyId  AND  UF.ReferenceId = TC.Id AND (@TestCaseId IS NULL OR UF.ReferenceId = @TestCaseId) AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'FFDFBE28-D3D9-49F9-9018-50E02D9C8F5B' 
                                                       FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseFilePath
				                           ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                                                 WHERE UF.CompanyId = @CompanyId AND  UF.ReferenceId = TC.Id AND (@TestCaseId IS NULL OR UF.ReferenceId = @TestCaseId) AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '77F086EA-E23F-414D-AD14-D4725CEF36C2'
                                           FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseMissionFilePath,
				                           Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                                                  WHERE UF.CompanyId = @CompanyId AND  UF.ReferenceId = TC.Id  AND (@TestCaseId IS NULL OR UF.ReferenceId = @TestCaseId) AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'CFB83453-60DD-4EB5-9818-95CDB3478AC5'
                                                          FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseGoalFilePath,
				                           Stuff((SELECT ',' + FilePath FROM UploadFile UF 
				                                               WHERE UF.CompanyId = @CompanyId AND  UF.ReferenceId = TC.Id AND (@TestCaseId IS NULL OR UF.ReferenceId = @TestCaseId) AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = 'ED61D300-9A7C-450F-8942-2444DACEAD0F'
                                                          FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS PreConditionFilePath,
				                           Stuff((SELECT ',' + FilePath FROM UploadFile UF
				                                               WHERE UF.CompanyId = @CompanyId AND UF.ReferenceId = TC.Id AND (@TestCaseId IS NULL OR UF.ReferenceId = @TestCaseId) AND UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '4232A177-164E-456C-B427-7BDEED92DA1D'
                                                          FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS TestCaseStepDescriptionFilePath,
				                           Stuff((SELECT ',' + FilePath FROM UploadFile UF
				                                              WHERE UF.CompanyId = @CompanyId AND (@TestCaseId IS NULL OR UF.ReferenceId = @TestCaseId) AND  UF.ReferenceId = TC.Id AND UF.ReferenceTypeId = '6520F42D-DA2E-40E2-BAFA-D5EE4D37F4A3'
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
                                           ,TC.CreatedDateTime
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
							                 FROM TestCaseHistory TCH INNER JOIN [User]U ON U.Id = TCH.CreatedByUserId
							                                          LEFT JOIN TestCaseStep TCS ON TCS.Id = TCH.StepId
																	  LEFT JOIN [TestRun]TR ON TR.Id = TCH.TestRunId
							               WHERE TCH.TestCaseId = TC.Id AND TCH.ConfigurationId <> '94113D41-8034-4320-94C0-7752B3E663C6'
							               ORDER BY TCH.CreatedDateTime DESC,TCH.[TimeStamp]
							                FOR JSON PATH)) TestCaseHistoryXml
                                           ,(SELECT TCS.Id AS StepId
                                                   ,TCS.Step  AS StepText
                                                   ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
																						JOIN TestCaseStep TCS1 ON TCS1.Id = UF.ReferenceId AND  UF.CompanyId = @CompanyId  
						                                                                 AND TCS1.Id = TCS.Id
						                                                                WHERE   UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '225BEB5C-1A53-40BB-A29B-B03BE3FA2779'
                                                                                        FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS StepTextFilePath
                                                   ,TCS.StepOrder As StepOrder
                                                   ,TCS.ExpectedResult   AS StepExpectedResult
                                                   ,Stuff((SELECT ',' + FilePath FROM UploadFile UF 
																				 JOIN TestCaseStep TCS1 ON TCS1.Id = UF.ReferenceId AND UF.CompanyId = @CompanyId  
						                                                          AND TCS1.Id = TCS.Id
						                                                         WHERE   UF.InActiveDateTime IS NULL AND UF.ReferenceTypeId = '3A3E185B-BD74-4DB6-86BC-677EB9AB1609'
                                                           FOR XML PATH(''),TYPE).value('text()[1]','nvarchar(4000)'),1,1,N'') AS StepExpectedResultFilePath
                                             FROM TestCaseStep TCS
                                             WHERE TCS.TestCaseId = TC.Id
                                                                                  AND TCS.InActiveDateTime IS NULL 
											 GROUP BY TCS.Id ,TCS.Step,TCS.StepOrder,TCS.ExpectedResult
                                             ORDER BY TCS.StepOrder
                                             FOR XML PATH('TestCaseStepMiniModel'), ROOT('TestCaseStepMiniModel'), TYPE) AS TestCaseStepsXml
                                           ,TC.[TimeStamp]
                                           ,TotalCount = COUNT(1) OVER()
                                      FROM TestCase TC WITH (NOLOCK)
                                                 INNER JOIN TestSuiteSection TSS WITH (NOLOCK) ON TSS.Id = TC.SectionId
                                                 INNER JOIN TestCaseTemplate TT WITH (NOLOCK)ON TT.Id = TC.TemplateId
                                                 INNER JOIN TestCaseType TCT WITH(NOLOCK) ON TCT.Id=TC.TypeId
                                                 INNER JOIN TestCaseAutomationType TCAT WITH(NOLOCK) ON TCAT.Id=TC.AutomationTypeId
                                                 INNER JOIN TestCasePriority TP WITH(NOLOCK) ON TP.Id = TC.PriorityId
                                      WHERE TT.CompanyId = @CompanyId AND TCT.CompanyId = @CompanyId AND TCAT.CompanyId = @CompanyId
                                             AND TC.InActiveDateTime IS NULL
                                             AND (@TestCaseId IS NULL OR TC.Id = @TestCaseId)
                                             AND (@SectionId IS NULL OR TC.SectionId = @SectionId)
                                     GROUP BY TC.Id,TC.Title ,TC.[SectionId],TSS.SectionName,TC.[TemplateId],
									 TT.TemplateType,TC.[TypeId] ,TCT.TypeName,TC.[Estimate] ,TC.[References] ,TC.PreCondition
									 ,TC.[ExpectedResult],TC.[CreatedDateTime],TC.[CreatedByUserId] ,TC.[Mission],TC.[Goals],TC.[PriorityId] 
                                     ,TP.PriorityType,TC.[AutomationTypeId],TCAT.AutomationType,TC.[TestCaseId],TC.[TestSuiteId],TC.Steps
									 ,TC.[TimeStamp]

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
GO