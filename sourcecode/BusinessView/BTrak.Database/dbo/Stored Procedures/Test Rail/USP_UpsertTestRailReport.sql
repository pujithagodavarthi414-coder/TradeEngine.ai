-------------------------------------------------------------------------------
-- Author       Mahesh Musku
-- Created      '2019-04-30 00:00:00.000'
-- Purpose      To Save or Update TestRail Reports
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertTestRailReport] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ReportName='Mobile Application',@ProjectId='068EEAEA-B54F-47E3-9064-5D2AE28BADFF',@MilestoneId='987FB2BC-D536-4126-A65F-3AC82BBF3C86'

CREATE PROCEDURE [dbo].[USP_UpsertTestRailReport]
(
    @TestRailReportId UNIQUEIDENTIFIER = NULL, 
    @ProjectId  UNIQUEIDENTIFIER = NULL, 
    @MilestoneId UNIQUEIDENTIFIER = NULL, 
    @TestRunId UNIQUEIDENTIFIER = NULL, 
    @Description NVARCHAR(1000) = NULL,
    @TestPlanId UNIQUEIDENTIFIER = NULL, 
    @TestRailOptionId UNIQUEIDENTIFIER = NULL, 
    @ReportName NVARCHAR(500) = NULL,
    @PdfUrl NVARCHAR(500) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER, 
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
        
       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
       IF(@HavePermission = '1')
       BEGIN
       
	   DECLARE @TestRailReportIdCount INT = (SELECT COUNT(1) FROM TestRailReport WHERE Id = @TestRailReportId  AND InActiveDateTime IS NULL)
        
        DECLARE @TestRailReportNamesCount INT = (SELECT COUNT(1) FROM [dbo].[TestRailReport] WHERE [Name] = @ReportName AND ProjectId = @ProjectId  AND InactiveDateTime IS NULL AND (@TestRailReportId IS NULL OR Id <> @TestRailReportId))
       
        IF(@TestRailReportIdCount = 0 AND @TestRailReportId IS NOT NULL)
        BEGIN
       
	      RAISERROR(50002,16, 1,'TestRailReport')
       
	    END
        ELSE IF(@TestRailReportNamesCount >0)
        BEGIN
      
	       RAISERROR(50001,16,1,'TestRailReport')
        
		END 
        ELSE
        BEGIN
            
                DECLARE @IsLatest BIT = (CASE WHEN @TestRailReportId IS NULL 
                                              THEN 1
											  WHEN @IsArchived = 1 
                                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                       FROM [TestRailReport] WHERE Id = @TestRailReportId ) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
            
                IF(@IsLatest = 1)
                BEGIN
                       
                    DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()
                   
					DECLARE @FieldName NVARCHAR(100)
					
					DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					DECLARE @ConfigurationId UNIQUEIDENTIFIER

					 SET @ConfigurationId  = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestRepoReportCreatedOrUpdated' AND CompanyId = @CompanyId )

                   IF(@TestRailReportId IS NULL)
				   BEGIN

				   SET @TestRailReportId = NEWID()

				   INSERT INTO [dbo].[TestRailReport](
                                 [Id],
                                 [Name],
                                 [MilestoneId],
                                 [ProjectId],
                                 [TestRunId],
                                 [TestPlanId],
                                 [TestRailReportOptionId] ,
                                 [Description],
								 [PdfUrl],
                                 [IsOpen],
                                 [IsCompleted],
                                 [InActiveDateTime],
                                 [CreatedDateTime],
                                 [CreatedByUserId]
                                 )
                          SELECT @TestRailReportId,
                                 @ReportName,
                                 @MilestoneId,
                                 @ProjectId,
                                 @TestRunId,
                                 @TestPlanId,
                                 @TestRailOptionId,
                                 @Description,
								 @PdfUrl,
                                 1,
                                 0, 
                                 (CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END),
                                 @Currentdate,
                                 @OperationsPerformedBy
								 
								   INSERT INTO [dbo].[TestCasesReport](
                                                             [Id],
                                                             [ReportId],
                                                             [TestRunId],
                                                             [TestCaseId],
                                                             [TestCaseTitle],
                                                             [AssignToId],
                                                             [TestedByUserId] ,
                                                             [StatusId],
                                                             [CreatedDateTime],
                                                             [CreatedByUserId]
                                                             )
                                                      SELECT NEWID()
                                                             ,@TestRailReportId
                                                             ,TSC.TestRunId
                                                             ,TSC.TestCaseId
                                                             ,TC.[Title]
                                                             ,TSC.AssignToId
                                                             ,TSC.UpdatedByUserId
                                                             ,TSC.StatusId
                                                             ,@Currentdate
                                                             ,@OperationsPerformedBy
                                                             FROM  TestCase TC WITH(NOLOCK) 
                                                                INNER JOIN TestRunSelectedCase TSC WITH (NOLOCK) ON TC.Id = TSC.TestCaseId  AND TC.InActiveDateTime IS NULL  AND TSC.InActiveDateTime IS NULL
                                                                INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InactiveDateTime IS NULL
																INNER JOIN TestSuite TS WITH(NOLOCK) ON TS.Id = TSS.TestSuiteId   AND TS.InactiveDateTime IS NULL
																INNER JOIN TestCaseStatus TCS  WITH (NOLOCK) ON TSC.StatusId = TCS.Id   AND TCS.InActiveDateTime IS NULL
                                                                INNER JOIN [TestRun] TR WITH(NOLOCK) ON TR.Id = TSC.TestRunId  AND TR.InActiveDateTime IS NULL
                                                                INNER JOIN [User]CU  WITH (NOLOCK) ON CU.Id = TC.CreatedByUserId 
                                                                LEFT JOIN [User]U  WITH (NOLOCK) ON U.Id = TSC.AssignToId 
                                                                WHERE (TR.MilestoneId = @MilestoneId OR TR.Id = @TestRunId)   
																 ORDER BY TSC.CreatedDateTime,TSC.[TimeStamp]

                        SET @FieldName = 'ReportCreated'
                         
                          EXEC [dbo].[USP_InsertTestCaseHistory] @OperationsPerformedBy=@OperationsPerformedBy,@FieldName= @FieldName,@NewValue = @ReportName,@ConfigurationId=@ConfigurationId,@ReferenceId = @TestRailReportId,@Description = 'TestRailReportAdded'


                    END
					ELSE
					BEGIN
					  
						EXEC [dbo].[USP_InsertTestRailAuditHistory] @TestRailReportId = @TestRailReportId, 
																	@TestRailReportProjectId = @ProjectId, 
																	@TestRailReportMilestoneId = @MilestoneId, 
																	@TestRailReportTestRunId = @TestRunId, 
																	@TestRailReportDescription = @Description,
																	@TestRailReportTestPlanId = @TestPlanId, 
																	@TestRailReportTestRailOptionId = @TestRailOptionId, 
																	@TestRailReportName = @ReportName,
																	@TestRailReportPdfUrl = @PdfUrl,
																	@TestRailReportIsArchived = @IsArchived,
																	@ConfigurationId = @ConfigurationId, 
																	@OperationsPerformedBy = @OperationsPerformedBy

					    UPDATE  [dbo].[TestRailReport]
                             SET [Name] = @ReportName,
                                 [MilestoneId] = @MilestoneId,
                                 [ProjectId] = @ProjectId,
                                 [TestRunId] = @TestRunId,
                                 [TestPlanId] =  @TestPlanId,
                                 [TestRailReportOptionId] = @TestRailOptionId ,
                                 [Description] =  @Description,
								 [PdfUrl] =  @PdfUrl,
                                 [IsOpen] =  1,
                                 [IsCompleted] = 0,
                                 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                 [UpdatedDateTime] =  @Currentdate,
                                 [UpdatedByUserId] = @OperationsPerformedBy
								 WHERE Id = @TestRailReportId
                                 
					  END
               
			   SELECT Id FROM [dbo].[TestRailReport] WHERE Id = @TestRailReportId 
                
                END
                ELSE
                    RAISERROR (50008,11, 1)

            END
    END
    ELSE
    BEGIN
                      
         RAISERROR (@HavePermission,10, 1)
                   
    END     
    END TRY
    BEGIN CATCH
        
          THROW

    END CATCH
END