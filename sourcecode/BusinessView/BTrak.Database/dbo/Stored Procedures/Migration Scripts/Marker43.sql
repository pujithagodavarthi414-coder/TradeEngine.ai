CREATE PROCEDURE [dbo].[Marker43]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

	MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
		(NEWID(), 'This app allows to view the tax allownace details of the employees and provide the details regarding each employee.', N'Employee tax allowance details',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
		(NEWID(), 'This app allows to view the payroll details of the employees and provide the details regarding each employee.', N'Employee payroll details',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
		(NEWID(), 'This app allows to view the resignation details of the employees and provide the details regarding each employee.', N'Employee resignation details',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
GO