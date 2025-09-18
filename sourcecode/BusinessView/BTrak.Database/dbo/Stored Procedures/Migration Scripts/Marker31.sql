CREATE PROCEDURE [dbo].[Marker31]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[WeekDays] AS Target 
USING ( VALUES 
		(NEWID(),1, 'Monday', 0, 0, 1, @CompanyId, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(),2, 'Tuesday', 0, 0, 2, @CompanyId, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(),3, 'Wednesday', 0, 0, 3, @CompanyId, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(),4, 'Thursday', 0, 0, 4, @CompanyId, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(),5, 'Friday', 0, 0, 5, @CompanyId, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(),6, 'Saturday', 1, 0, 6, @CompanyId, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(),0, 'Sunday', 1, 0, 7, @CompanyId, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId)
)        
AS Source ([Id],[WeekDay],[WeekDayName],[IsWeekend],[IsHalfDay],[SortOrder],[CompanyId],[CreatedDateTime],[CreatedByUserId]) 
ON Target.Id = Source.Id
WHEN MATCHED THEN 
UPDATE SET [WeekDay] = Source.[WeekDay],
		   CompanyId = Source.CompanyId,
	       [IsWeekend] = Source.[IsWeekend],
		   [IsHalfDay] = Source.[IsHalfDay],
		   [SortOrder] = Source.[SortOrder],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[WeekDay],[WeekDayName],[IsWeekend],[IsHalfDay],[SortOrder],[CompanyId],[CreatedDateTime],[CreatedByUserId]) 
VALUES ([Id],[WeekDay],[WeekDayName],[IsWeekend],[IsHalfDay],[SortOrder],[CompanyId],[CreatedDateTime],[CreatedByUserId]);



MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'E50D0E15-8A69-488B-9391-27659FA2AB4A', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
  (NEWID(),N'By using this app user can manage the tds settings. User can add details like branch and is tds required. User can also edit these details.',N'Tds settings', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
		   (NEWID(), @RoleId, N'83B1EF70-F371-42AF-A8C5-A1632033D4B7', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
  (NEWID(),N'By using this app user can manage the hourly tds settings. User can add details like branch and hourly tds required. User can also edit these details.',N'Hourly tds configuration', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
		   (NEWID(), @RoleId, N'7CD55073-755E-4126-A4B7-E880BA223AC3', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
  (NEWID(),N'By using this app user can manage the days of week configuration.',N'Days of week configuration', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
 ,(NEWID(),N'By using this app user can manage the allowance time.',N'Allowance time', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
	(NEWID(), @RoleId, N'2DDDBEBA-63F7-423D-B522-1181B5782DDE', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
  (NEWID(),N'By using this app user can manage the contract pay settings. User can add details like branch, contract pay type, is to be paid, active from and active to. User can also edit these details.',N'Contract pay settings', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'7E12ED2E-0A76-450F-95DF-16EB35A3EA23', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		   (NEWID(), @RoleId, N'7E12ED2E-0A76-450F-95DF-16EB35A3EA23', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		   (NEWID(), @RoleId, N'D9FDF976-5055-42CA-87F6-644EA5BF1F2E', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		   (NEWID(), @RoleId, N'D9FDF976-5055-42CA-87F6-644EA5BF1F2E', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
  (NEWID(),N'By using this app user can manage employee loans. User can add details like employee,loan amount,loan type,perios type etc details. User can also edit these details.',N'Employee loans', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
  (NEWID(),N'By using this app user can get his/her loan installment details.',N'Employee loan installment', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
  (NEWID(),N'To view the payroll monthly details like number of employees,gross pay,working days,deductions,netpay and hold employees.','Monthly payroll details', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'D0AE20C9-BF9C-4389-8904-E9557D7B498F', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		   (NEWID(), @RoleId, N'7A11C52B-30C2-4923-977C-3C4D0F87A4CC', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
	  )
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);


MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
			 (NEWID(), @CompanyId, N'AdminMails', N'saiteja.pinnamaneni@snovasys.co.uk',N'Admin emails', GETDATE(), @UserId)
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
INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);

MERGE INTO [dbo].[PayRollComponent] AS Target 
USING (VALUES 
	(NEWID(),@CompanyId,'Tax',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId,NULL,NULL,NULL)
) 
AS Source ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [CompanyId] = Source.[CompanyId],
		   [ComponentName] = Source.[ComponentName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [UpdatedDateTime] = Source.[UpdatedDateTime],
           [UpdatedByUserId] = Source.[UpdatedByUserId],
           [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) VALUES ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

MERGE INTO [dbo].RateSheetFor AS Target 
USING ( VALUES 
		(NEWID(), @CompanyId, N'Regular Day - Paid Break',0,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Regular Day - Overtime',0,1,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Regular Day - Morning Shift',1,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Regular Day - Afternoon Shift',1,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Regular Day - Evening Shift',1,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Regular Day - Night Shift',1,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Regular Day - Training Rate',0,0,1,CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Regular Day - Early',0,1,0,CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Bank Holiday - Paid Break',0,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Bank Holiday - Overtime',0,1,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Bank Holiday - Morning Shift',1,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Bank Holiday - Afternoon Shift',1,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Bank Holiday - Evening Shift',1,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Bank Holiday - Night Shift',1,0,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Bank Holiday - Training Rate',0,0,1, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Bank Holiday - Early',0,1,0, CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId)
)
AS Source ([Id],[CompanyId],[RateSheetForName],IsShift,IsAllowance,IsTraining,[CreatedDateTime],[CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET CompanyId = Source.CompanyId,
	       [RateSheetForName] = Source.[RateSheetForName],
	       [IsShift] = Source.[IsShift],
		   [IsAllowance] = Source.[IsAllowance],
		   [IsTraining] = Source.[IsTraining],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[CompanyId],[RateSheetForName],IsShift,IsAllowance,IsTraining,[CreatedDateTime],[CreatedByUserId])  VALUES ([Id],[CompanyId],[RateSheetForName],IsShift,IsAllowance,IsTraining,[CreatedDateTime],[CreatedByUserId]);

MERGE INTO [dbo].[PayRollComponent] AS Target 
USING (VALUES 
	(NEWID(),@CompanyId,'Office Loan EMI',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId,NULL,NULL,NULL)
) 
AS Source ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [CompanyId] = Source.[CompanyId],
		   [ComponentName] = Source.[ComponentName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [UpdatedDateTime] = Source.[UpdatedDateTime],
           [UpdatedByUserId] = Source.[UpdatedByUserId],
           [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) VALUES ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

update payrollcomponent
set IsVisible = 1
where ComponentName not in( 
'Bonus',
'Other Allowance',
'Leave Encashment',
'Tax',
'TDS',
'Office Loan EMI'
)
AND CompanyId = @CompanyId

update payrollcomponent
set IsVisible = 0
where ComponentName in( 
'Bonus',
'Other Allowance',
'Leave Encashment',
'Tax',
'TDS',
'Office Loan EMI'
)
AND CompanyId = @CompanyId

update payrollcomponent
set Isdeduction = 1
where ComponentName in( 
'Tax',
'TDS',
'Office Loan EMI'
)
AND CompanyId = @CompanyId

MERGE INTO [dbo].[PayRollComponent] AS Target 
USING (VALUES 
	(NEWID(),@CompanyId,'Salary',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId,NULL,NULL,NULL)
) 
AS Source ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [CompanyId] = Source.[CompanyId],
		   [ComponentName] = Source.[ComponentName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [UpdatedDateTime] = Source.[UpdatedDateTime],
           [UpdatedByUserId] = Source.[UpdatedByUserId],
           [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) VALUES ([Id],[CompanyId],[ComponentName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

END
GO