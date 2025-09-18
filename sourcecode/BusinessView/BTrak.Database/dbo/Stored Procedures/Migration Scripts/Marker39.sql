CREATE PROCEDURE [dbo].[Marker39]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app provides the information of salary wages of an employee',N'Salary wages', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app provides the information of salary of IT',N'Salary for IT', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app provides the information of PF of employees',N'PF of employees', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app provides the information of ESI of employees',N'ESI of employees', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
)
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

END