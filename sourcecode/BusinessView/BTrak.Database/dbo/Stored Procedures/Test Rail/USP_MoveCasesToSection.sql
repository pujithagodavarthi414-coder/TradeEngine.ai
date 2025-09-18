 -------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-31 00:00:00.000'
-- Purpose      To Move the Test cases from one section to other
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_MoveCasesToSection] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@TestCaseIds= '<GenericListOfGuid><ListItems><guid>7C7D0AFB-C5B0-458D-A468-0321F4619266</guid>
--<guid>B04FD967-924C-4A91-BD5F-032951FFB697</guid><guid>413C4070-3193-46EF-80CC-03348A3772DE</guid>
--</ListItems></GenericListOfGuid>'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_MoveCasesToSection]
(
    @TestCaseIds XML,
    @SectionId UNIQUEIDENTIFIER = NULL,
	@IsCopy BIT = 0,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF(@HavePermission = '1')			 
        BEGIN

        IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF (@SectionId = '00000000-0000-0000-0000-000000000000') SET @SectionId = NULL

        IF(@SectionId IS NULL)
		BEGIN
		
			RAISERROR(50011,16,1,'SectionId')
		
		END
        ELSE
        BEGIN

            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

            DECLARE @Currentdate DATETIME = GETDATE()

            DECLARE @MaxOrderId INT = 0

			DECLARE @TestCaseConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId)

            SELECT @MaxOrderId = ISNULL(Max([Order]),0) FROM TestCase WHERE SectionId = @SectionId

			DECLARE @TestSuiteId UNIQUEIDENTIFIER

			SET @TestSuiteId = (SELECT TestSuiteId FROM TestSuiteSection WHERE Id = @SectionId AND InActiveDateTime IS NULL)

			DECLARE @StatusId UNIQUEIDENTIFIER = (SELECT Id FROM TestCaseStatus TCS WHERE TCS.IsUntested = 1 and CompanyId = @CompanyId AND InActiveDateTime IS NULL)

			DECLARE @TestCaseCreated UNIQUEIDENTIFIER

            CREATE TABLE #Temp
            (
            [Order] INT IDENTITY(1, 1),
            TestCaseId UNIQUEIDENTIFIER,
            TestSuiteId UNIQUEIDENTIFIER,
            OrderValue INT,
			NewTestCaseId NVARCHAR(250),
			NewCaseId UNIQUEIDENTIFIER
            )

            INSERT INTO #Temp
            (
            TestCaseId,
			NewCaseId
            )
            SELECT x.y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS TestCaseId,NEWID()
            FROM @TestCaseIds.nodes('GenericListOfGuid/ListItems/guid') AS x(y)


			CREATE TABLE #Temp1
            (
            OldStepId UNIQUEIDENTIFIER,
			NewStepId UNIQUEIDENTIFIER
            )

			INSERT INTO #Temp1 SELECT Id,NEWID() FROM TestCaseStep TCS 
			INNER JOIN #Temp T ON T.TestCaseId = TCS.TestCaseId AND TCS.InActiveDateTime IS NULL

            UPDATE #Temp SET OrderValue = @MaxOrderId + 0, @MaxOrderId = @MaxOrderId + 1
            UPDATE #Temp SET TestSuiteId = @TestSuiteId
			
			DECLARE @newId UNIQUEIDENTIFIER = NEWID()
			DECLARE @TestcasestepnewId UNIQUEIDENTIFIER = NEWID()
			DECLARE @TestCaseId INT = (SELECT ISNULL((SELECT MAX(CAST((SUBSTRING(TC.TestCaseId,2,LEN(TC.TestCaseId))) AS INT)) 
                                                               FROM TestCase TC 
                                                                    INNER JOIN TestSuite TS ON TS.Id = TC.TestSuiteId 
                                                                    INNER JOIN Project P ON P.Id = TS.ProjectId 
                                                               WHERE P.CompanyId = @CompanyId
                                                               GROUP BY P.CompanyId
                                                               ),0))

			UPDATE #Temp SET NewTestCaseId = (@TestCaseId + 0),@TestCaseId = @TestCaseId + 1

			IF(@IsCopy=0)
			BEGIN

					DELETE TCH FROM [dbo].[TestCaseHistory] TCH 
							INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId
							INNER JOIN #Temp T ON T.TestCaseId = TC.Id AND TC.SectionId <> @SectionId 

					INSERT INTO [dbo].[TestCaseHistory]([Id], [TestCaseId], [OldValue], [NewValue], [FieldName], [ConfigurationId], CreatedDateTime, CreatedByUserId)
						SELECT  NEWID(), T.TestCaseId, NULL, NULL, 'TestCaseMoved',
											  @TestCaseConfigurationId,
								              @Currentdate, @OperationsPerformedBy
												FROM TestCase TC INNER JOIN #Temp T ON T.TestCaseId = TC.Id AND TC.SectionId <> @SectionId
			
					UPDATE TestCase
							SET [SectionId] = @SectionId,
								[Order] = T.OrderValue,
								[UpdatedDateTime] = @Currentdate,
								[UpdatedByUserId] = @OperationsPerformedBy
							FROM TestCase TC INNER JOIN #Temp T ON T.TestCaseId = TC.Id AND TC.SectionId <> @SectionId			
							--select * FROM TestCase TC INNER JOIN #Temp T ON T.TestCaseId = TC.Id AND TC.SectionId <> @SectionId
			END

            IF(@IsCopy=1)
			BEGIN
			
			INSERT INTO TestCase (
									 Id, 
									 Title,
									 SectionId,
									 TemplateId,
									 TypeId,
									 Estimate,
									 [Order],
									 [References],
									 Steps,
									 ExpectedResult,
									 Mission,
									 Goals,
									 PreCondition,
									 CreatedDateTime,
									 CreatedByUserId,
									 PriorityId,
									 AutomationTypeId,
									 TestCaseId,
									 TestSuiteId
								)
						   SELECT
								  T.NewCaseId,
								  TC.Title,
								  @SectionId,
								  TC.TemplateId,
								  TC.TypeId,
								  TC.Estimate,
								  T.OrderValue,
								  TC.[References],
								  TC.Steps,
								  TC.ExpectedResult,
								  TC.Mission,
								  TC.Goals,
								  TC.PreCondition,
								  GETDATE(),
								  @OperationsPerformedBy,
								  TC.PriorityId,
								  TC.AutomationTypeId,
								  ('C' + CAST(T.NewTestCaseId AS NVARCHAR(100))),
								  TC.TestSuiteId
								FROM TestCase TC INNER JOIN #Temp T ON T.TestCaseId = TC.Id

			INSERT INTO TestCaseStep(
			                          Id,
									  TestCaseId,
									  Step,
									  StepOrder,
									  ExpectedResult,
									  CreatedDateTime,
									  CreatedByUserId
			                        )
							SELECT  
							          T.NewStepId,
									  TT.NewCaseId,
									  TCS.Step,
									  TCS.StepOrder,
									  TCS.ExpectedResult,
									  GETDATE(),
									  @OperationsPerformedBy
							        
							FROM TestCaseStep TCS
							INNER JOIN #Temp1 T ON T.OldStepId = TCS.Id
							INNER JOIN #Temp TT ON TT.TestCaseId = TCS.TestCaseId

			INSERT INTO [TestRunSelectedCase]
                                         (
                                         [Id],
                                         [TestCaseId],
                                         [StatusId],
                                         [TestRunId],
                                         CreatedDateTime,
                                         CreatedByUserId
                                         )
                               SELECT    NEWID(),
                                         TCT.NewCaseId,
                                         @StatusId,
                                         TR.Id,
                                         @Currentdate,
                                         @OperationsPerformedBy
                                  FROM TestRun TR INNER JOIN #Temp TCT ON TCT.TestSuiteId  = TR.TestSuiteId 
                                  WHERE TR.IsIncludeAllCases = 1
                                        AND TR.TestSuiteId = @TestSuiteId 
                                        AND TR.InActiveDateTime IS NULL

			INSERT INTO [TestRunSelectedStep]
                                         (
                                         [Id],
                                         [StepId],
                                         [StatusId],
                                         [TestRunId],
                                         CreatedDateTime,
                                         CreatedByUserId
                                         )
                                  SELECT NEWID(),
								         TCS.Id,
										 @StatusId,
										 TR.Id,
										 @Currentdate,
										 @OperationsPerformedBy
								   FROM TestCaseStep TCS INNER JOIN #Temp T ON T.NewCaseId = TCS.TestCaseId AND TCS.InActiveDateTime IS NULL
										                 INNER JOIN TestRun TR ON TR.TestSuiteId = T.TestSuiteId AND TR.InActiveDateTime IS NULL
								  WHERE TR.IsIncludeAllCases = 1

            INSERT INTO [dbo].[TestCaseHistory]([Id], [TestCaseId], [OldValue], [NewValue], [FieldName], [ConfigurationId], CreatedDateTime, CreatedByUserId)
						SELECT  NEWID(), T.NewCaseId, NULL, NULL, 'TestCaseCreated',
											  @TestCaseConfigurationId,
								              @Currentdate, @OperationsPerformedBy
												FROM TestCase TC INNER JOIN #Temp T ON T.TestCaseId = TC.Id
													
			--INSERT INTO [dbo].[TestCaseHistory]([Id], [TestCaseId], [TestRunId], [OldValue], [NewValue], [FieldName], [Description], [ConfigurationId], CreatedDateTime, CreatedByUserId)
			--			SELECT  NEWID(), TCT.NewCaseId, TR.Id, NULL, NULL, 'TestCase', 'AddedToTestRun',
			--								  (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseCreatedOrUpdated' AND CompanyId = @CompanyId),
			--					              @Currentdate, @OperationsPerformedBy
			--									FROM TestRun TR INNER JOIN #Temp TCT ON TCT.TestSuiteId  = TR.TestSuiteId 
			--									WHERE TR.IsIncludeAllCases = 1
			--										AND TR.TestSuiteId = @TestSuiteId 
			--										AND TR.InActiveDateTime IS NULL

							
			DECLARE @TeseCaseStepCount INT=(SELECT COUNT(1) FROM UploadFile UF JOIN TestCaseStep TCS ON TCS.Id = UF.ReferenceId JOIN #Temp T ON T.TestCaseId = TCS.TestCaseId)

			IF(@TeseCaseStepCount>0)
			BEGIN
					INSERT INTO [dbo].[UploadFile]
											(
											Id,
											[FileName],
											FilePath,
											FileExtension,
											FileSize,
											ReferenceId,
											ReferenceTypeId,
											FolderId,
											StoreId,
											CompanyId,
											CreatedByUserId,
											CreatedDateTime
											)
									SELECT NEWID(),
										UF.[FileName],
										UF.FilePath,
										UF.FileExtension,
										UF.FileSize,
										T1.NewStepId,
										UF.ReferenceTypeId,
										UF.FolderId,
										UF.StoreId,
										UF.CompanyId,
										@OperationsPerformedBy,
										GETDATE()
												 
									FROM UploadFile UF 
									JOIN TestCaseStep TCS ON TCS.Id = UF.ReferenceId 
									JOIN #Temp T ON T.TestCaseId = TCS.TestCaseId
									INNER JOIN #Temp1 T1 ON T1.OldStepId = TCS.Id

			END

			DECLARE @TestcaseCount INT = (SELECT COUNT(1) FROM TestCase TC JOIN #Temp T ON T.TestCaseId = TC.Id)
							
			IF(@TestcaseCount>0)
							BEGIN
									INSERT INTO [dbo].[UploadFile]
									                      (
															Id,
															[FileName],
															FilePath,
															FileExtension,
															FileSize,
															ReferenceId,
															ReferenceTypeId,
															FolderId,
															StoreId,
															CompanyId,
															CreatedByUserId,
															CreatedDateTime
							                               )
												SELECT 
													   NEWID(),
													   [FileName],
													   FilePath,
													   FileExtension,
													   FileSize,
													   T.NewCaseId,
													   ReferenceTypeId,
													   FolderId,
													   StoreId,
													   CompanyId,
													   @OperationsPerformedBy,
													   GETDATE()
						    
												FROM UploadFile UF
												INNER JOIN #Temp T ON T.TestCaseId = UF.ReferenceId
							END
			END


			SELECT Id FROM TestSuiteSection WHERE Id = @SectionId

            END
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