------------------------------------------------------------------------------
-- Author       Harika Pabbisetty
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or update the TestCase
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modified      Geetha Ch
-- Created      '2019-04-01 00:00:00.000'
-- Purpose      To Save or update the TestCase
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_TestCaseStatusUpdate]
--@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
--,@TestCaseId = '064E76EC-CE9C-4624-8421-0F30DFD511AC'
--,@TestRunId='5B36D871-D923-4990-B794-F7A81325C326'
--,@StatusId = '63d3d282-76db-4e95-96d6-0c368681e3db'
--,@Version = 'Version 2'
--,@Elapsed = '02:00:00'
--,@AssignToId = '127133F1-4427-4149-9DD6-B02E0E036971'
----,@TimeStamp = 0x0000000000001E64
--  ,@StepStatusXml=N'<?xml version="1.0" encoding="utf-16"?>
--   <ArrayOfTestCaseStepMiniModel xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--   <TestCaseStepMiniModel>
--       <TestRunId>5B36D871-D923-4990-B794-F7A81325C326</TestRunId>
--       <StepId>35792FF4-3AE6-48CA-9B19-DCCC962323E0</StepId>
--       <StepActualResult>Step Result 1</StepActualResult>
--       <StepStatusId>451b7f11-818c-421e-a770-57cbcabe6273</StepStatusId>
--   </TestCaseStepMiniModel>
--   <TestCaseStepMiniModel>
--       <TestRunId>5B36D871-D923-4990-B794-F7A81325C326</TestRunId>
--       <StepId>4E28862D-EB6C-4426-9416-EE4C982F871D</StepId>
--       <StepActualResult>Step Result 1</StepActualResult>
--       <StepStatusId>451b7f11-818c-421e-a770-57cbcabe6273</StepStatusId>
--   </TestCaseStepMiniModel>
--   </ArrayOfTestCaseStepMiniModel>'

CREATE PROCEDURE [dbo].[USP_TestCaseStatusUpdate]
(
    @TestRunSelectedCaseId UNIQUEIDENTIFIER = NULL,
    @TestCaseId UNIQUEIDENTIFIER = NULL,
    @TestRunId UNIQUEIDENTIFIER = NULL,
    @StatusId UNIQUEIDENTIFIER = NULL,
    @StatusComment NVARCHAR(max) = NULL,
    @AssignToId UNIQUEIDENTIFIER = NULL,
    @AssignToComment NVARCHAR(max) = NULL,
    @Version NVARCHAR(50) = NULL,
    @Elapsed DATETIME = NULL,
    @IsArchived BIT  = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @TimeStamp TIMESTAMP = NULL,
    @StepStatusXml XML = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
        DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestRun WHERE Id = @TestRunId AND InActiveDateTime IS NULL)
       
       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
            IF(@HavePermission = '1')
            BEGIN
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
            --DECLARE @TestCaseIdCount INT = (SELECT COUNT(1) FROM TestRunSelectedCase WHERE TestCaseId = @TestCaseId AND TestRunId = @TestRunId)
                
                SET @TestRunSelectedCaseId = (SELECT Id FROM TestRunSelectedCase WHERE TestCaseId = @TestCaseId AND TestRunId = @TestRunId AND InActiveDateTime IS NULL)
                  
                    DECLARE @IsLatest BIT = (CASE WHEN @TestRunSelectedCaseId IS NULL 
                                                  THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                         FROM [TestRunSelectedCase] WHERE Id = @TestRunSelectedCaseId) = @TimeStamp
                                                                   THEN 1 ELSE 0 END END)
        
                    IF(@IsLatest = 1)
                    BEGIN
                      
                        DECLARE @Currentdate DATETIME = GETDATE()
                        
                        DECLARE @NewTestRunSelectedCaseId UNIQUEIDENTIFIER = NEWID()
                        
                        DECLARE @VersionNumber INT
                        DECLARE @Status NVARCHAR(250)
                        DECLARE @OldStatusComment NVARCHAR(max)
						DECLARE @OldAssignToComment NVARCHAR(max)
                        DECLARE @Assignee NVARCHAR(250)
                        DECLARE @OldStatus NVARCHAR(100),@OldStatusId UNIQUEIDENTIFIER
                        DECLARE @OldAsignee NVARCHAR(250),@OldAssignToId UNIQUEIDENTIFIER
                        
                        SELECT @OldStatusId = StatusId,@OldStatusComment = ltrim(rtrim(StatusComment)),
                               @OldAssignToComment = AssignToComment, @OldAssignToId = AssignToId  FROM TestRunSelectedCase WHERE Id = @TestRunSelectedCaseId 
                     
				 IF(@TestRunSelectedCaseId IS NULL)
				 BEGIN

					SET @TestRunSelectedCaseId = NEWID()

                   INSERT INTO [dbo].[TestRunSelectedCase]
                                     (
                                     [Id],
                                     [TestRunId],
                                     [TestCaseId],
                                     [StatusId],
                                     [StatusComment],
                                     [AssignToComment],
                                     [AssignToId],
                                     [Version],
                                     [Elapsed],
                                     [InActiveDateTime],
                                     [CreatedDateTime],
                                     [CreatedByUserId]
                                     )
                              SELECT @TestRunSelectedCaseId,
                                     @TestRunId,
                                     @TestCaseId,
                                     @StatusId,
                                     @StatusComment,
                                     @AssignToComment,
                                     @AssignToId,
                                     @Version,
                                     @Elapsed,
                                     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                     @Currentdate,
                                     @OperationsPerformedBy
                  END
				  ELSE
				  BEGIN

				              UPDATE [dbo].[TestRunSelectedCase]
                              SET    [TestRunId] = @TestRunId,
                                     [TestCaseId] = @TestCaseId,
                                     [StatusId] = @StatusId,
                                     [StatusComment] = @StatusComment,
                                     [AssignToComment] = @AssignToComment,
                                     [AssignToId] = @AssignToId,
                                     [Version] = @Version,
                                     [Elapsed] = @Elapsed,
                                     [InActiveDateTime] =CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                     [UpdatedDateTime] = @Currentdate,
                                     [UpdatedByUserId] = @OperationsPerformedBy
									 WHERE Id = @TestRunSelectedCaseId

				  END
               
                              DECLARE @TestCaseDependency TABLE
                                    (
                                        Id UNIQUEIDENTIFIER,
                                        TestRunId UNIQUEIDENTIFIER,
                                        StepId UNIQUEIDENTIFIER,
                                        StatusId UNIQUEIDENTIFIER,
                                        ActualResult NVARCHAR(max),
                                        IsArchived BIT,
                                        VersionNumber INT,
                                        OriginalId UNIQUEIDENTIFIER,
                                        OldStatusId UNIQUEIDENTIFIER,
                                        OldActualResult NVARCHAR(max)
                                    )
                                    INSERT INTO @TestCaseDependency(Id,TestRunId,StepId,ActualResult,StatusId)
                                    SELECT  NEWID(), 
                                             @TestRunId,
                                             [Table].[Column].value('StepId[1]', 'varchar(2000)'),
                                             [Table].[Column].value('StepActualResult[1]', 'varchar(max)'),
                                             [Table].[Column].value('StepStatusId[1]', 'Nvarchar(50)') 
                                    FROM @StepStatusXml.nodes('/ArrayOfTestCaseStepMiniModel/TestCaseStepMiniModel') AS [Table]([Column])
          
                                    UPDATE @TestCaseDependency  SET OldStatusId  =  TRSS.StatusId  FROM @TestCaseDependency T INNER JOIN TestRunSelectedStep TRSS ON T.StepId = TRSS.StepId AND T.TestRunId = TRSS.TestRunId 
                                                                                                 AND TRSS.InActiveDateTime IS NULL 
                                                                                        WHERE   T.StepId = TRSS.StepId 
                                                              
                               UPDATE @TestCaseDependency  SET OldActualResult  =  TRSS.ActualResult  FROM @TestCaseDependency T INNER JOIN TestRunSelectedStep TRSS ON T.StepId = TRSS.StepId AND T.TestRunId = TRSS.TestRunId 
                                                                                                 AND TRSS.InActiveDateTime IS NULL 
                                                                                        WHERE  T.StepId = TRSS.StepId 
                                     
                                         UPDATE [TestRunSelectedStep]
                                          SET   [TestRunId] = @TestRunId,
                                                [StepId] = T.StepId,
                                                [StatusId] = T.StatusId,
                                                [ActualResult] = T.ActualResult,
                                                UpdatedDateTime = @Currentdate,
                                                UpdatedByUserId = @OperationsPerformedBy
												FROM @TestCaseDependency T 
												WHERE T.StepId = TestRunSelectedStep.StepId AND TestRunSelectedStep.TestRunId = @TestRunId
									
									INSERT INTO TestRunSelectedStep(
                                                [Id],
                                                [TestRunId],
                                                [StepId],
                                                [StatusId],
                                                [ActualResult],
                                                InActiveDateTime,
                                                CreatedDateTime,
                                                CreatedByUserId
												)
                                         SELECT T.Id,
                                                @TestRunId, 
                                                T.StepId,
                                                T.StatusId,
                                                T.ActualResult,
                                                CASE WHEN IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                                @Currentdate,
                                                @OperationsPerformedBy
                                            FROM @TestCaseDependency T LEFT JOIN TestRunSelectedStep TRSS ON TRSS.TestRunId = T.TestRunId AND T.StepId = TRSS.StepId AND TRSS.InActiveDateTime IS NULL
											WHERE TRSS.StepId  IS NULL
                                                                       
                       
                             IF(@OldStatusId <> @StatusId)
                             BEGIN
                              
							  SELECT @OldStatus =[Status] FROM [TestCaseStatus] WHERE Id = @OldStatusId
                              SELECT @Status =[Status] FROM [TestCaseStatus] WHERE Id = @StatusId
							  DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId)
                             
							 EXEC USP_InsertTestCaseHistory @TestCaseId = @TestCaseId,@TestRunId = @TestRunId,@OldValue = @OldStatus,@NewValue = @Status,@FieldName='CaseStatus',@Description ='TestCaseStatusChanged',@IsFromUpload = NULL,@OperationsPerformedBy = @OperationsPerformedBy,@ConfigurationId = @ConfigurationId
                            
							 END
                             
							 IF(ISNULL(@StatusComment,'') != ISNULL(@OldStatusComment,''))
                             BEGIN
                             
                             EXEC USP_InsertTestCaseHistory @TestCaseId = @TestCaseId,@TestRunId = @TestRunId,@OldValue = @OldStatusComment,@NewValue = @StatusComment,@FieldName='StatusComment',@Description ='TestCaseStatusCommentChanged',@IsFromUpload = NULL,@OperationsPerformedBy = @OperationsPerformedBy
                             
							 END
                            
							 IF(@AssignToId <> ISNULL(@OldAssignToId,'00000000-0000-0000-0000-000000000000'))
                             BEGIN
                             
                             SELECT @Assignee = U.FirstName + ' ' + U.SurName FROM [User] U WHERE Id = @AssignToId 
                             SELECT @OldAsignee = U.FirstName + ' ' + U.SurName FROM [User] U WHERE Id = @OldAssignToId
                             
							 EXEC USP_InsertTestCaseHistory @TestCaseId = @TestCaseId,@TestRunId = @TestRunId,@OldValue = @OldAsignee,@NewValue = @Assignee,@FieldName='Assignee',@Description ='TestCaseAssigneeChanged',@IsFromUpload = NULL,@OperationsPerformedBy = @OperationsPerformedBy
                            
							 END

							 IF(ISNULL(@OldAssignToComment,'') <> ISNULL(@AssignToComment,''))
                             BEGIN
                             
							 EXEC USP_InsertTestCaseHistory @TestCaseId = @TestCaseId,@TestRunId = @TestRunId,@OldValue = @OldAssignToComment,@NewValue = @AssignToComment,@FieldName='AssignToComment',@Description ='TestcaseAssigneeCommentChanged',@IsFromUpload = NULL,@OperationsPerformedBy = @OperationsPerformedBy
                            
							 END

							 INSERT INTO [dbo].[TestCaseHistory](
                                                                [Id],
                                                                [TestCaseId],
																[ConfigurationId],
                                                                [TestRunId],
                                                                [StepId],
                                                                [OldValue],
                                                                [NewValue],
                                                                [FieldName],
                                                                [Description],
                                                                CreatedDateTime,
                                                                CreatedByUserId)
                                                     SELECT     NEWID(),
                                                                @TestCaseId,
																(SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId),
                                                                T.TestRunId,
                                                                T.StepId,
                                                                TCS1.[Status],
                                                                TCS.[Status],
                                                                'StepStatus',
                                                                NULL,
                                                                SYSDATETIMEOFFSET(),
                                                                @OperationsPerformedBy
                                                                FROM @TestCaseDependency T INNER JOIN TestCaseStatus TCS ON TCS.Id = T.StatusId 
                                                                                           INNER JOIN TestCaseStatus TCS1 ON TCS1.Id  = T.OldStatusId
                                                                WHERE T.StatusId != T.OldStatusId
                                                 
												 INSERT INTO [dbo].[TestCaseHistory](
                                                                [Id],
                                                                [TestCaseId],
                                                                [TestRunId],
                                                                [StepId],
                                                                [OldValue],
                                                                [NewValue],
                                                                [FieldName],
                                                                [Description],
                                                                CreatedDateTime,
                                                                CreatedByUserId)
                                                     SELECT     NEWID(),
                                                                @TestCaseId,
                                                                T.TestRunId,
                                                                T.StepId,
                                                                T.OldActualResult,
                                                                T.ActualResult,
                                                                'ActualResult',
                                                                NULL,
                                                                SYSDATETIMEOFFSET(),
                                                                @OperationsPerformedBy
                                                                FROM @TestCaseDependency T WHERE ISNULL((LTRIM(RTRIM(T.ActualResult))),'') != ISNULL((LTRIM(RTRIM(T.OldActualResult))),'')
                    
					SELECT Id FROM [dbo].[TestRunSelectedCase] WHERE Id = @TestRunSelectedCaseId
               
               END
                ELSE
                  RAISERROR (50008,11, 1)
       
       END
       ELSE
       BEGIN
            RAISERROR (@HavePermission,10, 1)
                      
       END
  END TRY
    BEGIN CATCH
        
        EXEC USP_GetErrorInformation
        
    END CATCH
END


