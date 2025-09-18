------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-09-18 00:00:00.000'
-- Purpose      To change the status of userstory scenarios
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertUserStoryScenario]
--@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
--,@TestCaseId = '064E76EC-CE9C-4624-8421-0F30DFD511AC'
--,@UserStoryId='5B36D871-D923-4990-B794-F7A81325C326'
--,@StatusId = '63d3d282-76db-4e95-96d6-0c368681e3db'
CREATE PROCEDURE [dbo].[USP_UpsertUserStoryScenario]
(
    @UserStoryScenarioId UNIQUEIDENTIFIER = NULL,
    @UserStoryId UNIQUEIDENTIFIER = NULL,
    @TestCaseId UNIQUEIDENTIFIER = NULL,
    @StatusId UNIQUEIDENTIFIER = NULL,
    @IsArchived BIT  = NULL,
	@TimeZone NVARCHAR(250) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @TimeStamp TIMESTAMP = NULL,
    @StepStatusXml XML = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
         DECLARE @ProjectId UNIQUEIDENTIFIER =  (SELECT [dbo].[Ufn_GetProjectIdByUserStoryId](@UserStoryId))
       
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
            
            IF(@HavePermission = '1')
            BEGIN
                     
                    DECLARE @VersionNumber INT
​
                    DECLARE @OldStatusId UNIQUEIDENTIFIER
            			 

                    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				    DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
	                SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone

                    DECLARE @Currentdate DATETIMEOFFSET =  dbo.Ufn_GetCurrentTime(@Offset)
            
                    SELECT @UserStoryScenarioId = Id,@OldStatusId = StatusId FROM UserStoryScenario WHERE TestCaseId = @TestCaseId AND UserStoryId = @UserStoryId  AND InActiveDateTime IS NULL
                  
                    DECLARE @IsLatest BIT = (CASE WHEN @UserStoryScenarioId  IS NULL
                                                            THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                     FROM [UserStoryScenario] WHERE Id = @UserStoryScenarioId) = @TimeStamp
                                                                              THEN 1 ELSE 0 END END)
                  
                    IF(@IsLatest = 1)
                    BEGIN
                      
                        --DECLARE @Currentdate DATETIME = GETDATE()
                        
​
                        DECLARE @Status NVARCHAR(250)
                        DECLARE @OldStatus NVARCHAR(100)
                        
                             UPDATE [UserStoryScenario]
                                SET StatusId = @StatusId,
									InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                    UpdatedDateTime = @Currentdate,
									UpdatedDateTimeZoneId = @TimeZoneId,
                                    UpdatedByUserId = @OperationsPerformedBy
                                WHERE Id = @UserStoryScenarioId
                             
                                  IF(@OldStatusId != @StatusId)
                                  BEGIN
                              
                                   SELECT @OldStatus =[Status] FROM [TestCaseStatus] WHERE Id = @OldStatusId 
                                   SELECT @Status =[Status] FROM [TestCaseStatus] WHERE Id = @StatusId
                                    
                                   DECLARE @ConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId)
​
                                   EXEC USP_InsertTestCaseHistory @TestCaseId = @TestCaseId,@TestRunId = NULL,@UserStoryId = @UserStoryId, @OldValue = @OldStatus,@NewValue = @Status,@FieldName='TestCaseStatus',@Description ='UserStoryScenarioStatusChanged',@IsFromUpload = NULL,@OperationsPerformedBy = @OperationsPerformedBy,@ConfigurationId = @ConfigurationId
                            
                                  END
                                               
                                               CREATE TABLE #UserStoryScenarioStep
                                               (
                                               Id UNIQUEIDENTIFIER,
                                               StepId UNIQUEIDENTIFIER,
                                               StatusId UNIQUEIDENTIFIER,
											   IsArchived BIT
                                               )
                                               INSERT INTO #UserStoryScenarioStep(Id,StepId,StatusId)
                                                SELECT  NEWID() , 
                                                        [Table].[Column].value('StepId[1]', 'varchar(250)'),
                                                        [Table].[Column].value('StepStatusId[1]', 'Nvarchar(50)')
                                                  FROM @StepStatusXml.nodes('/ArrayOfTestCaseStepMiniModel/TestCaseStepMiniModel') AS [Table]([Column])
                                              
                                               INSERT INTO #UserStoryScenarioStep(
                                                            Id,
                                                            StepId,
                                                            StatusId,
                                                            IsArchived
                                                            )
                                                   SELECT   NEWID(),
                                                            StepId,
                                                            StatusId,
                                                            1
                                                       FROM UserStoryScenarioStep USS INNER JOIN TestCaseStep TCS ON TCS.Id = USS.StepId 
                                                                                         AND TCS.InActiveDateTime IS NULL 
                                                                                         AND USS.InActiveDateTime IS NULL 
                                                       WHERE TCS.TestCaseId = @TestCaseId AND @IsArchived = 1 
                                                       
                                        INSERT INTO [dbo].[TestCaseHistory](
                                                          [Id],
                                                          [UserStoryId],
                                                          [StepId],
                                                          [OldValue],
                                                          [NewValue],
                                                          [Description],
                                                          [FieldName],
                                                          CreatedDateTime,
														  CreatedDateTimeZoneId,
                                                          CreatedByUserId)
                                                   SELECT NEWID(),
                                                          @UserStoryId,
                                                          USS.StepId,
                                                          TCS1.[Status],
                                                          TCS.[Status],
                                                          'UserStoryScenarioStepStatusChanged',
                                                          'ScenarioStepStatus',
                                                          @Currentdate,
														  @TimeZoneId,
                                                          @OperationsPerformedBy
                                                          FROM #UserStoryScenarioStep US INNER JOIN UserStoryScenarioStep USS ON US.StepId = USS.StepId AND USS.UserStoryId = @UserStoryId AND USS.InactiveDateTime IS NULL
                                                                                         INNER JOIN TestCaseStatus TCS ON TCS.Id = US.StatusId 
                                                                                         INNER JOIN TestCaseStatus TCS1 ON TCS1.Id = USS.StatusId
                                                        WHERE USS.UserStoryId = @UserStoryId AND US.StatusId <> USS.StatusId
                                UPDATE [UserStoryScenarioStep]
                                  SET  StatusId = T.StatusId,
									   InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                       UpdatedDateTime = @Currentdate,
									   UpdatedDateTimeZoneId = @TimeZoneId,
                                       UpdatedByUserId =  @OperationsPerformedBy
                                  FROM  UserStoryScenarioStep  USS INNER JOIN  #UserStoryScenarioStep T ON T.StepId = USS.StepId  AND USS.InactiveDateTime IS NULL
                                 WHERE USS.UserStoryId = @UserStoryId
                    
                    
                        SELECT TestCaseId FROM [dbo].[UserStoryScenario] WHERE Id = @UserStoryScenarioId
               
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
        
        THROW
        
    END CATCH
END
GO