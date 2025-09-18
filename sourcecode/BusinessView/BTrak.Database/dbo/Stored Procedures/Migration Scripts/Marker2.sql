CREATE PROCEDURE [dbo].[Marker2]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),N'This app displays the table  representation of employee leave details like leave type,applied on,date from,date to,No.Of days,from session,to session,leave status,leave reason,delete leave and approved leave. User can filter data by using filters like employee name,leave type,branch,Leave status,date from,date to and date. Also user can sort the data with the help of columns employee name,leave type,applied on,Date from,date to,No.of days,from session,to session,leave status and leave reason', N'Leaves dashboard', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL))
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.Id = Source.Id 
    WHEN MATCHED THEN 
    UPDATE SET [WidgetName] = Source.[WidgetName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] =  Source.[CompanyId],
               [Description] =  Source.[Description],
               [UpdatedDateTime] =  Source.[UpdatedDateTime],
               [UpdatedByUserId] =  Source.[UpdatedByUserId],
               [InActiveDateTime] =  Source.[InActiveDateTime]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;

UPDATE LeaveApplicationStatusSetHistory SET [Description] = 'Reapplied' WHERE [Description] = 'ReApplied'
END
GO