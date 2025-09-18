
CREATE PROCEDURE [dbo].[Marker22]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


DECLARE @WidgetId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[Widget] WHERE WidgetName = 'Sprint bug report' AND COmpanyId = @CompanyId)
IF(@WidgetId IS NULL)
BEGIN
MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
    (NEWID(), N'This app provides the bug report of work items for a sprint',N'Sprint bug report',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
)
AS Source ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
ON Target.Id = Source.Id 
WHEN MATCHED THEN 
UPDATE SET [WidgetName] = Source.[WidgetName],
           [Description] = Source.[Description],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] =  Source.[CompanyId],
           [UpdatedDateTime] =  Source.[UpdatedDateTime],
           [UpdatedByUserId] =  Source.[UpdatedByUserId],
           [InActiveDateTime] =  Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
VALUES ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

END
END


DECLARE @Temp TABLE
(
RowNO INT  Identity(1,1),
ProjectId UNIQUEIDENTIFIER
)
INSERT INTO @Temp
SELECT P.Id FROM PROJECT  P LEFT JOIN GOAL G ON G.ProjectId = P.Id 
                       WHERE G.GoalName <> 'Backlog' AND G.GoalShortName <> 'Backlog'
                       AND P.CompanyId = @CompanyId AND P.InActiveDateTime IS NULL
                       GROUP BY P.Id 
declare @Count INT = (SELECT MAX(RowNO) FROM @Temp)
                        
                        WHILE(@Count > 0)
                       BEGIN
                     
                      DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM @Temp WHERE RowNO = @Count)
                      DECLARE @BoardTypeId UNIQUEIDENTIFIER = (SELECT BT.Id FROM BoardType BT INNER JOIN BoardTypeUi BTU ON BT.BoardTypeUIId = BTU.Id WHERE BoardTypeName = 'SuperAgile' and BT.InActiveDateTime IS NULL AND BT.CompanyId = @CompanyId AND BT.IsBugBoard IS NULL)
                      DECLARE @GoalId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[Goal] G WHERE G.GoalName = 'Backlog' AND G.GoalShortName = 'Backlog' AND G.ProjectId = @ProjectId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL)
                      DECLARE @BoardTypeWorkflowIdCount INT = (SELECT Count(1)
                                                       FROM [dbo].[BoardTypeWorkFlow]BTW
                                                     
                                                       where BTW.BoardTypeId = @BoardTypeId )
                      IF(@GoalId IS NULL AND @BoardTypeId IS NOT NULL AND @BoardTypeWorkflowIdCount = 1)
                      BEGIN
                       
                       EXEC [dbo].[USP_UpsertGoal]@GoalName = 'Backlog',@GoalShortName = 'Backlog',
                                                      @ProjectId = @ProjectId,@BoardTypeId = @BoardTypeId,
                                                      @OperationsPerformedBy = @UserId
                      END 
                       SET @Count = @Count - 1
                     
                       END
IF(NOT EXISTS(SELECT Id FROM [dbo].[CompanySettings] WHERE [Key] = 'IsWorkItemStartFunctionalityRequired' AND CompanyId = @CompanyId))
BEGIN
  MERGE INTO [dbo].[CompanySettings] AS Target
    USING ( VALUES
       (NEWID(), @CompanyId, N'IsWorkItemStartFunctionalityRequired ', N'0', N'Is work item auto start functionality required ', CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId)
    )
    AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
    ON Target.Id = Source.Id
    WHEN MATCHED THEN
    UPDATE SET CompanyId = Source.CompanyId,
               [Key] = source.[Key],
               [Value] = Source.[Value],
               [Description] = source.[Description],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) 
    VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);

END
GO