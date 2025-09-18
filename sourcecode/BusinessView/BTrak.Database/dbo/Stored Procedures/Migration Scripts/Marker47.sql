CREATE PROCEDURE [dbo].[Marker47]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app provides the information of monthly ESI of an employee',N'ESI monthly statement', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app provides the information of salary bill of an employee',N'Salary register', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app provides the information of professional tax of employees',N'Professional tax monthly statement', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app provides the information of salary bill register',N'Salary bill register', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app provides the information of employee grade. In this app we can add, edit, delete employee grade',N'Employee grade', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app provides the information of employee grade. In this app we can get history of employee grade',N'Employee grade configuration', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the information of income of an employee. This app also contains information of deductions, adhoc income, monthly income and other',N'Income salary statement', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app provides the information of professional tax of an employer',N'Professional tax returns', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
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