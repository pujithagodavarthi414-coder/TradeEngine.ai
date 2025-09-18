CREATE PROCEDURE [dbo].[Marker190]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
	
DECLARE @CompanyName NVARCHAR(MAX) = (SELECT LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 20) FROM Company WHERE Id = @CompanyId)

--LEAVE MANAGEMENT TEST DATA START--

MERGE INTO [dbo].[LeaveType] AS Target 
USING ( VALUES 
        (NEWID(), @CompanyId, N'Sick Leave', GETDATE(),	@UserId,GETDATE(), @UserId, NULL, (SELECT Id FROM MasterLeaveType WHERE MasterLeaveTypeName = 'Sick leave'),'Sick Leave',3),
        (NEWID(), @CompanyId, N'General Leave', GETDATE(),	@UserId,GETDATE(), @UserId, NULL, (SELECT Id FROM MasterLeaveType WHERE MasterLeaveTypeName = 'Casual leave'),'General Leave',2)
		
)
AS Source ([Id], [CompanyId], [LeaveTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[InActiveDateTime],[MasterLeaveTypeId],[LeaveShortName],[IsIncludeHolidays]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId] = Source.[CompanyId],
	       [LeaveTypeName] = Source.[LeaveTypeName],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [UpdatedDateTime] = Source.[UpdatedDateTime],
		   [UpdatedByUserId] = Source.[UpdatedByUserId],
		   [InActiveDateTime] = Source.[InActiveDateTime],
		   [MasterLeaveTypeId] = Source.[MasterLeaveTypeId],
		   [LeaveShortName] = Source.[LeaveShortName],
		   [IsIncludeHolidays] = Source.[IsIncludeHolidays]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [CompanyId], [LeaveTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[InActiveDateTime],[MasterLeaveTypeId],[LeaveShortName],[IsIncludeHolidays]) VALUES ([Id], [CompanyId], [LeaveTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[InActiveDateTime],[MasterLeaveTypeId],[LeaveShortName],[IsIncludeHolidays]);

MERGE INTO [dbo].[LeaveApplicability] AS Target 
USING ( VALUES
       (NEWID(), 0, NULL,NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),NULL,NULL),
	   (NEWID(), 0, NULL,NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'General Leave' AND CompanyId = @CompanyId),NULL,NULL)
)
AS Source ([Id], [MinExperienceInMonths], [MaxExperienceInMonths], [MaxLaves], [LeaveTypeId], [InActiveDateTime],[EmployeeTypeId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [MinExperienceInMonths] = Source.[MinExperienceInMonths],
	       [MaxExperienceInMonths] = Source.[MaxExperienceInMonths],
	       [MaxLaves] = Source.[MaxLaves],
	       [LeaveTypeId] = Source.[LeaveTypeId],
	       [InActiveDateTime] = Source.[InActiveDateTime],
	       [EmployeeTypeId] = Source.[EmployeeTypeId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [MinExperienceInMonths], [MaxExperienceInMonths], [MaxLaves], [LeaveTypeId], [InActiveDateTime],[EmployeeTypeId]) VALUES ([Id], [MinExperienceInMonths], [MaxExperienceInMonths], [MaxLaves], [LeaveTypeId], [InActiveDateTime],[EmployeeTypeId]);

IF EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71')
BEGIN
MERGE INTO [dbo].[RoleLeaveType] AS Target 
USING ( VALUES

       (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL),
	   (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'General Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL)
)
AS Source ([Id], [RoleId], [LeaveTypeId], [CompanyId], [IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
	       [LeaveTypeId] = Source.[LeaveTypeId],
	       [CompanyId] = Source.[CompanyId],
		   [IsAccessAll]=  Source.[IsAccessAll],
	       [CreatedByUserId] = Source.[CreatedByUserId],
	       [UpdatedByUserId] = Source.[UpdatedByUserId],
	       [UpdatedDateTime] = Source.[UpdatedDateTime],
	       [CreatedDateTime] = Source.[CreatedDateTime],
	       [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [LeaveTypeId], [CompanyId], [IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime])
VALUES ([Id], [RoleId], [LeaveTypeId], [CompanyId], [IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]);
END

ELSE
IF EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='3AA49D13-76C9-4842-840E-4AC759B65DF8')
BEGIN
MERGE INTO [dbo].[RoleLeaveType] AS Target 
USING ( VALUES
   (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'General Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL)
)
AS Source ([Id], [RoleId], [LeaveTypeId], [CompanyId],[IsAccessAll],[CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
	       [LeaveTypeId] = Source.[LeaveTypeId],
	       [CompanyId] = Source.[CompanyId],
		   [IsAccessAll] = Source.[IsAccessAll],
	       [CreatedByUserId] = Source.[CreatedByUserId],
	       [UpdatedByUserId] = Source.[UpdatedByUserId],
	       [UpdatedDateTime] = Source.[UpdatedDateTime],
	       [CreatedDateTime] = Source.[CreatedDateTime],
	       [InActiveDateTime] = Source.[InActiveDateTime]
		
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime])
VALUES ([Id], [RoleId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]);
END
ELSE
IF NOT EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='BBBB8092-EBCC-43FF-A039-5E3BD2FACE51')
BEGIN
BEGIN
	MERGE INTO [dbo].[RoleLeaveType] AS Target 
USING ( VALUES
		(NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL),
	    (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'General Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL)
)
AS Source ([Id], [RoleId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
	       [LeaveTypeId] = Source.[LeaveTypeId],
	       [CompanyId] = Source.[CompanyId],
		   [IsAccessAll] = Source.[IsAccessAll], 
	       [CreatedByUserId] = Source.[CreatedByUserId],
	       [UpdatedByUserId] = Source.[UpdatedByUserId],
	       [UpdatedDateTime] = Source.[UpdatedDateTime],
	       [CreatedDateTime] = Source.[CreatedDateTime],
	       [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime])
VALUES ([Id], [RoleId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]);
END
END

MERGE INTO [dbo].[GenderLeaveType] AS Target 
USING ( VALUES

       (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL),
	   (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'General Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL)
)
AS Source ([Id], [GenderId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [GenderId] = Source.[GenderId],
	       [LeaveTypeId] = Source.[LeaveTypeId],
	       [CompanyId] = Source.[CompanyId],
	       [CreatedByUserId] = Source.[CreatedByUserId],
	       [UpdatedByUserId] = Source.[UpdatedByUserId],
	       [UpdatedDateTime] = Source.[UpdatedDateTime],
	       [CreatedDateTime] = Source.[CreatedDateTime],
	       [InActiveDateTime] = Source.[InActiveDateTime],
		   [IsAccessAll] = Source.[IsAccessAll]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [GenderId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]) VALUES ([Id], [GenderId], [LeaveTypeId], [CompanyId], [IsAccessAll],[CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]);

MERGE INTO [dbo].[BranchLeaveType] AS Target 
USING ( VALUES

       (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL),
	   (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'General Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL)
)
AS Source ([Id], [BranchId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [BranchId] = Source.[BranchId],
	       [LeaveTypeId] = Source.[LeaveTypeId],
	       [CompanyId] = Source.[CompanyId],
	       [CreatedByUserId] = Source.[CreatedByUserId],
	       [UpdatedByUserId] = Source.[UpdatedByUserId],
	       [UpdatedDateTime] = Source.[UpdatedDateTime],
	       [CreatedDateTime] = Source.[CreatedDateTime],
	       [InActiveDateTime] = Source.[InActiveDateTime],
		   [IsAccessAll] = Source.[IsAccessAll]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [BranchId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]) VALUES ([Id], [BranchId], [LeaveTypeId], [CompanyId], [IsAccessAll],[CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]);

MERGE INTO [dbo].[MariatalStatusLeaveType] AS Target 
USING ( VALUES

       (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL),
	   (NEWID(),NULL,(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'General Leave' AND CompanyId = @CompanyId),@CompanyId,1,@UserId,@UserId,GETDATE(),GETDATE(),NULL)
)
AS Source ([Id], [MariatalStatusId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [MariatalStatusId] = Source.[MariatalStatusId],
	       [LeaveTypeId] = Source.[LeaveTypeId],
	       [CompanyId] = Source.[CompanyId],
	       [CreatedByUserId] = Source.[CreatedByUserId],
	       [UpdatedByUserId] = Source.[UpdatedByUserId],
	       [UpdatedDateTime] = Source.[UpdatedDateTime],
	       [CreatedDateTime] = Source.[CreatedDateTime],
	       [InActiveDateTime] = Source.[InActiveDateTime],
		   [IsAccessAll] = Source.[IsAccessAll]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [MariatalStatusId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]) VALUES ([Id], [MariatalStatusId], [LeaveTypeId], [CompanyId],[IsAccessAll], [CreatedByUserId], [UpdatedByUserId],[UpdatedDateTime],[CreatedDateTime],[InActiveDateTime]);

MERGE INTO [dbo].[RestrictionType] AS Target 
USING ( VALUES
       (NEWID(), 'Monthly Restriction', 31,	0, 1, 0, 0, 0,@CompanyId,NULL,GETDATE(),@UserId,NULL,NULL)
)
AS Source ([Id], [Restriction], [LeavesCount], [IsWeekly], [IsMonthly], [IsQuarterly], [IsHalfYearly],[IsYearly],[CompanyId],[InActiveDateTime],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Restriction] = Source.[Restriction],
	       [LeavesCount] = Source.[LeavesCount],
	       [IsWeekly] = Source.[IsWeekly],
	       [IsMonthly] = Source.[IsMonthly],
	       [IsQuarterly] = Source.[IsQuarterly],
	       [IsHalfYearly] = Source.[IsHalfYearly],
	       [IsYearly] = Source.[IsYearly],
	       [CompanyId] = Source.[CompanyId],
		   [InActiveDateTime] = Source.[InActiveDateTime],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [UpdatedDateTime] = Source.[UpdatedDateTime],
		   [UpdatedByUserId] = Source.[UpdatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Restriction], [LeavesCount], [IsWeekly], [IsMonthly], [IsQuarterly], [IsHalfYearly],[IsYearly],[CompanyId],[InActiveDateTime],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId]) VALUES ([Id], [Restriction], [LeavesCount], [IsWeekly], [IsMonthly], [IsQuarterly], [IsHalfYearly],[IsYearly],[CompanyId],[InActiveDateTime],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId]);

MERGE INTO [dbo].[Leavefrequency] AS Target 
USING ( VALUES
        (NEWID(),(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId), NULL, NULL, -31, NULL, NULL, CAST(DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) AS DATETIME),CAST(DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1) AS DATETIME),10,GETDATE(),@UserId,GETDATE(),@UserId,NULL,@CompanyId, NULL, NULL, NULL, NULL,(SELECT Id FROM RestrictionType WHERE CompanyId = @CompanyId), 0,(SELECT Id FROM EmploymentStatus WHERE EmploymentStatusName = 'Full-Time Employee' AND CompanyId = @CompanyId)), 
        (NEWID(),(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'General Leave' AND CompanyId = @CompanyId), NULL, NULL, -31, NULL, NULL, CAST(DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) AS DATETIME),CAST(DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1) AS DATETIME),10,GETDATE(),@UserId,GETDATE(),@UserId,NULL,@CompanyId, NULL, NULL, NULL, NULL,(SELECT Id FROM RestrictionType WHERE CompanyId = @CompanyId), 0,(SELECT Id FROM EmploymentStatus WHERE EmploymentStatusName = 'Full-Time Employee' AND CompanyId = @CompanyId))
)
AS Source ([Id], [LeaveTypeId], [EncashmentTypeId], [LeaveFormulaId], [NumberOfDaysToBeIntimated], [CarryForwardLeavesCount], [PayableLeavesCount],[DateFrom],[DateTo],[NoOfLeaves],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime],[CompanyId],[IsToRepeatTheInterval],[PaymentTypeId],[IsToCarryForward],[IsEncashable],[RestrictionTypeId],[IsPaid],[EmploymentTypeId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [LeaveTypeId] = Source.[LeaveTypeId],
	       [EncashmentTypeId] = Source.[EncashmentTypeId],
	       [LeaveFormulaId] = Source.[LeaveFormulaId],
	       [NumberOfDaysToBeIntimated] = Source.[NumberOfDaysToBeIntimated],
	       [CarryForwardLeavesCount] = Source.[CarryForwardLeavesCount],
	       [PayableLeavesCount] = Source.[PayableLeavesCount],
	       [DateFrom] = Source.[DateFrom],
	       [DateTo] = Source.[DateTo],
	       [NoOfLeaves] = Source.[NoOfLeaves],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [UpdatedDateTime] = Source.[UpdatedDateTime],
		   [UpdatedByUserId] = Source.[UpdatedByUserId],
		   [InActiveDateTime] = Source.[InActiveDateTime],
		   [CompanyId] = Source.[CompanyId],
		   [IsToRepeatTheInterval] = Source.[IsToRepeatTheInterval],
		   [PaymentTypeId] = Source.[PaymentTypeId],
		   [IsToCarryForward] = Source.[IsToCarryForward],
		   [IsEncashable] = Source.[IsEncashable],
		   [RestrictionTypeId] = Source.[RestrictionTypeId],
		   [IsPaid] = Source.[IsPaid],
		   [EmploymentTypeId] = Source.[EmploymentTypeId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [LeaveTypeId], [EncashmentTypeId], [LeaveFormulaId], [NumberOfDaysToBeIntimated], [CarryForwardLeavesCount], [PayableLeavesCount],[DateFrom],[DateTo],[NoOfLeaves],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime],[CompanyId],[IsToRepeatTheInterval],[PaymentTypeId],[IsToCarryForward],[IsEncashable],[RestrictionTypeId],[IsPaid],[EmploymentTypeId]) VALUES ([Id], [LeaveTypeId], [EncashmentTypeId], [LeaveFormulaId], [NumberOfDaysToBeIntimated], [CarryForwardLeavesCount], [PayableLeavesCount],[DateFrom],[DateTo],[NoOfLeaves],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime],[CompanyId],[IsToRepeatTheInterval],[PaymentTypeId],[IsToCarryForward],[IsEncashable],[RestrictionTypeId],[IsPaid],[EmploymentTypeId]);

MERGE INTO [dbo].[LeaveFormula] AS Target 
USING ( VALUES
       (NEWID(), '3*5', NULL,5, 3,@CompanyId,GETDATE(),@UserId,NULL,NULL,NULL,NULL)
)
AS Source ([Id], [Formula], [SalaryTypeId], [NoOfDays], [NoOfleaves], [CompanyId],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime],[PayroleId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Formula] = Source.[Formula],
	       [SalaryTypeId] = Source.[SalaryTypeId],
	       [NoOfDays] = Source.[NoOfDays],
	       [NoOfleaves] = Source.[NoOfleaves],
	       [CompanyId] = Source.[CompanyId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [UpdatedDateTime] = Source.[UpdatedDateTime],
		   [UpdatedByUserId] = Source.[UpdatedByUserId],
		   [InActiveDateTime] = Source.[InActiveDateTime],
		   [PayroleId] = Source.[PayroleId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Formula], [SalaryTypeId], [NoOfDays], [NoOfleaves], [CompanyId],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime],[PayroleId]) VALUES ([Id], [Formula], [SalaryTypeId], [NoOfDays], [NoOfleaves], [CompanyId],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime],[PayroleId]);

--LEAVE MANAGEMENT TEST DATA END--

			 
END
GO

