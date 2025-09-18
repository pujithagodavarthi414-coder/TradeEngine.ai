-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-07-31 00:00:00.000'
-- Purpose      To  update Assignee or status for Multiple TestCases
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpdateAssignForMultipleTestCases]
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--,@AssignToId = '127133F1-4427-4149-9DD6-B02E0E036971'
--,@StatusId ='451B7F11-818C-421E-A770-57CBCABE6273'
--,@TestCaseIdsXml = '<ArrayOfGuid>
--                          <guid>69A2FD48-7C9F-4401-81A3-87AB419205A2</guid>
--                          <guid>D480ED17-5505-45D3-B42F-0D362CC2BB0F</guid>
--                          <guid>0EEE6682-5E07-41CE-8329-09D593A42774</guid>
--                          <guid>E72CE873-6C3F-4617-981C-3D7A33E44DCE</guid>
--                     </ArrayOfGuid>'
--,@TestRunId='D3883FBD-BD9B-47E0-A1FF-E565D791E109'

CREATE PROCEDURE [dbo].[USP_UpdateAssignForMultipleTestCases]
(
    @TestCaseIdsXml XML= NULL,
    @AssignToId UNIQUEIDENTIFIER = NULL,
    @StatusId UNIQUEIDENTIFIER = NULL,
    @TestRunId UNIQUEIDENTIFIER = NULL,
    @StatusComment NVARCHAR(MAX) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
          DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM TestRun WHERE Id = @TestRunId AND InActiveDateTime IS NULL)
       
          DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            IF(@HavePermission = '1')
            BEGIN
            
                  CREATE TABLE #Temp
                  (
                       TestRunSelectedCaseId UNIQUEIDENTIFIER,
                       OldStatusId UNIQUEIDENTIFIER,
                       OldAssignToId UNIQUEIDENTIFIER,
                       OldStatusComment NVARCHAR(MAX),
                       TestCaseId UNIQUEIDENTIFIER
                  )
                    INSERT INTO #Temp(TestRunSelectedCaseId,OldStatusId,OldAssignToId,OldStatusComment,TestCaseId)
                     SELECT Id,StatusId,AssignToId,StatusComment,TestCaseId FROM TestRunSelectedCase WHERE TestCaseId IN (SELECT [Table].[Column].value('(text())[1]', 'varchar(100)')
                                           FROM @TestCaseIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])) 
										   AND TestRunId = @TestRunId AND InActiveDateTime IS NULL
                 
				 CREATE NONCLUSTERED INDEX IX_#Temp_TestRunSelectedCaseId_OldStatusId_OldAssignToId
				 ON #Temp ([TestRunSelectedCaseId],[OldStatusId],[OldAssignToId])
                 
				 DECLARE @Currentdate DATETIME = GETDATE()
                        
					 UPDATE TestRunSelectedCase 
						SET StatusId = CASE WHEN @StatusId IS NULL THEN TRSC.StatusId ELSE @StatusId END, 
						    StatusComment = CASE WHEN @StatusComment IS NULL THEN TRSC.StatusComment ELSE @StatusComment END,
							AssignToId = CASE WHEN @AssignToId IS NULL THEN TRSC.AssignToId ELSE @AssignToId END,
							UpdatedDateTime = @Currentdate,
							UpdatedByUserId = @OperationsPerformedBy
						FROM TestRunSelectedCase TRSC INNER JOIN #Temp T ON T.TestRunSelectedCaseId= TRSC.Id 
                  
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
                                                                T.TestCaseId,
                                                                @TestRunId,
                                                                NULL,
                                                                U.FirstName + ' ' + U.SurName,
                                                                U1.FirstName + ' ' + U1.SurName,
                                                                'Assignee',
                                                                'TestCaseAssigneeChanged',
                                                                SYSDATETIMEOFFSET(),
                                                                @OperationsPerformedBy
                                                                FROM #Temp T LEFT JOIN [User]U ON U.Id  = T.OldAssignToId 
                                                                             LEFT JOIN [User]U1 ON U1.Id = @AssignToId   
                                                                WHERE ISNULL(T.OldAssignToId,'00000000-0000-0000-0000-000000000000') <> ISNULL(@AssignToId,'00000000-0000-0000-0000-000000000000') 
																AND @AssignToId IS NOT NULL
                                                         
						 DECLARE @StatusConfigurationId UNIQUEIDENTIFIER = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName = 'TestCaseStatusChanged' AND CompanyId = @CompanyId)
             							 
                                              INSERT INTO [dbo].[TestCaseHistory](
                                                                [Id],
                                                                [TestCaseId],
                                                                [TestRunId],
                                                                [StepId],
                                                                [OldValue],
                                                                [NewValue],
                                                                [ConfigurationId],
                                                                [FieldName],
                                                                [Description],
                                                                CreatedDateTime,
                                                                CreatedByUserId)
                                                     SELECT     NEWID(),
                                                                T.TestCaseId,
                                                                @TestRunId,
                                                                 NULL,
                                                                 TCS.[Status],
                                                                 TCS1.[Status],
                                                                 @StatusConfigurationId,
                                                                'CaseStatus',
                                                                'TestCaseStatusChanged',
                                                                SYSDATETIMEOFFSET(),
                                                                @OperationsPerformedBy
                                                                FROM #Temp T LEFT JOIN TestCaseStatus TCS ON TCS.Id = T.OldStatusId
                                                                             LEFT JOIN TestCaseStatus TCS1 ON TCS1.Id = @StatusId
                                                                WHERE  ISNULL(T.OldStatusId,'00000000-0000-0000-0000-000000000000') <> ISNULL(@StatusId,'00000000-0000-0000-0000-000000000000') AND @StatusId IS NOT NULL
                                            
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
                                                                T.TestCaseId,
                                                                @StatusConfigurationId,
                                                                @TestRunId,
                                                                NULL,
                                                                T.OldStatusComment,
                                                                @StatusComment,
                                                                'StatusComment',
                                                                'TestCaseStatusCommentChanged',
                                                                SYSDATETIMEOFFSET(),
                                                                @OperationsPerformedBy
                                                                FROM #Temp T 
                                                                WHERE ISNULL(T.OldStatusComment,'') <> ISNULL(@StatusComment,'') AND @StatusComment IS NOT NULL
                   
                   SELECT TestCaseId FROM [dbo].[TestRunSelectedCase] WHERE Id IN (SELECT TestRunSelectedCaseId FROM #Temp)
			
             
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