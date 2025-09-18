CREATE PROCEDURE [dbo].[Marker46]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[PayRollComponent] AS Target 
USING (VALUES 
     (NEWID(), N'ESI', @CompanyId, 1, 0, CAST(0.7500 AS Decimal(18, 4)), CAST(3.2500 AS Decimal(18, 4)), 1, 1, CAST(N'2020-06-08 11:28:28.483' AS DateTime), @UserId)
	,(NEWID(), N'HRA', @CompanyId, 0, 0, NULL, NULL, 1, NULL, CAST(N'2020-06-08 11:28:07.243' AS DateTime), @UserId)
	,(NEWID(), N'PF', @CompanyId, 1, 0, CAST(12.0000 AS Decimal(18, 4)), CAST(12.0000 AS Decimal(18, 4)), 1, 1, CAST(N'2020-06-08 11:28:17.870' AS DateTime), @UserId)
	,(NEWID(), N'Basic', @CompanyId, 0, 0, NULL, NULL, 1, NULL, CAST(N'2020-06-08 11:28:02.910' AS DateTime), @UserId)
	,(NEWID(), N'Medical Allowance', @CompanyId, 0, 0, NULL, NULL, 1, NULL, CAST(N'2020-06-08 12:12:31.150' AS DateTime), @UserId)
	,(NEWID(), N'Prof Tax', @CompanyId, 1, 0, NULL, NULL, 1, NULL, CAST(N'2020-06-08 11:28:38.590' AS DateTime), @UserId)
	
) 
AS Source ([Id], [ComponentName], [CompanyId], [IsDeduction], [IsVariablePay], [EmployeeContributionPercentage], [EmployerContributionPercentage], [IsVisible], [RelatedToContributionPercentage], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [ComponentName] = Source.[ComponentName],
           [CompanyId] = Source.[CompanyId],
		   [IsDeduction] = Source.[IsDeduction],
		   [IsVariablePay] = Source.[IsVariablePay],
		   [EmployeeContributionPercentage] = Source.[EmployeeContributionPercentage],
		   [EmployerContributionPercentage] = Source.[EmployerContributionPercentage],
		   [IsVisible] = Source.[IsVisible],
		   [RelatedToContributionPercentage] =  Source.[RelatedToContributionPercentage],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [ComponentName], [CompanyId], [IsDeduction], [IsVariablePay], [EmployeeContributionPercentage], [EmployerContributionPercentage], [IsVisible], [RelatedToContributionPercentage], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [ComponentName], [CompanyId], [IsDeduction], [IsVariablePay], [EmployeeContributionPercentage], [EmployerContributionPercentage], [IsVisible], [RelatedToContributionPercentage], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[PayrollTemplate] AS Target 
USING (VALUES 
	  (NEWID(), N'Template For India', N'Template For India', @CompanyId, 0, 0, NULL,
	  (select Id from SYS_Currency where CurrencyName = 'Indian Rupee'), NULL, CAST(N'2020-06-08 12:09:23.817' AS DateTime), @UserId)
) 
AS Source ([Id], [PayrollName], [PayrollShortName], [CompanyId], [IsRepeatInfinitly], [IslastWorkingDay], [FrequencyId], [CurrencyId], [InfinitlyRunDate], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [PayrollName] = Source.[PayrollName],
           [PayrollShortName] = Source.[PayrollShortName],
		   [CompanyId] = Source.[CompanyId],
		   [IsRepeatInfinitly] = Source.[IsRepeatInfinitly],
		   [IslastWorkingDay] = Source.[IslastWorkingDay],
		   [FrequencyId] = Source.[FrequencyId],
		   [CurrencyId] = Source.[CurrencyId],
		   [InfinitlyRunDate] =  Source.[InfinitlyRunDate],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [PayrollName], [PayrollShortName], [CompanyId], [IsRepeatInfinitly], [IslastWorkingDay], [FrequencyId], [CurrencyId], [InfinitlyRunDate], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [PayrollName], [PayrollShortName], [CompanyId], [IsRepeatInfinitly], [IslastWorkingDay], [FrequencyId], [CurrencyId], [InfinitlyRunDate], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[PayrollTemplateConfiguration] AS Target 
USING (VALUES 
	 (NEWID(), (select Id from payrollcomponent where CompanyId = @CompanyId AND ComponentName = 'Prof Tax'), (select Id from payrolltemplate where CompanyId = @CompanyId AND PayRollName = 'Template For India'), 0, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2020-06-08 12:11:17.423' AS DateTime), @UserId, 5)
	,(NEWID(), (select Id from payrollcomponent where CompanyId = @CompanyId AND ComponentName = 'Medical Allowance'), (select Id from payrolltemplate where CompanyId = @CompanyId AND PayRollName = 'Template For India'), NULL, 1250, NULL, 1, NULL, 0, NULL, CAST(N'2020-06-08 12:11:17.423' AS DateTime), @UserId, 4)
	,(NEWID(), (select Id from payrollcomponent where CompanyId = @CompanyId AND ComponentName = 'PF'), (select Id from payrolltemplate where CompanyId = @CompanyId AND PayRollName = 'Template For India'), 1, NULL, CAST(24.0000 AS Decimal(18, 4)), 0, (select Id from payrollcomponent where CompanyId = @CompanyId AND ComponentName = 'Basic'), 0, NULL, CAST(N'2020-06-08 12:11:17.423' AS DateTime),@UserId,3)
	,(NEWID(), (select Id from payrollcomponent where CompanyId = @CompanyId AND ComponentName = 'HRA'), (select Id from payrolltemplate where CompanyId = @CompanyId AND PayRollName = 'Template For India'), 1, NULL, CAST(16.0000 AS Decimal(18, 4)), 1, NULL, 0, NULL, CAST(N'2020-06-08 12:11:17.423' AS DateTime), @UserId,2)
	,(NEWID(), (select Id from payrollcomponent where CompanyId = @CompanyId AND ComponentName = 'Basic'), (select Id from payrolltemplate where CompanyId = @CompanyId AND PayRollName = 'Template For India'), 1, NULL, CAST(30.0000 AS Decimal(18, 4)), 1, NULL, 0, NULL, CAST(N'2020-06-08 12:11:17.423' AS DateTime),@UserId,1)
) 
AS Source ([Id], [PayrollComponentId], [PayrollTemplateId], [Ispercentage], [Amount], [Percentagevalue], [IsCtcDependent], [DependentPayrollComponentId], [IsRelatedToPT], [ComponentId], [CreatedDateTime], [CreatedByUserId], [Order])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [PayrollComponentId] = Source.[PayrollComponentId],
		   [PayrollTemplateId] = Source.[PayrollTemplateId],
		   [Ispercentage] = Source.[Ispercentage],
		   [Amount] = Source.[Amount],
		   [Percentagevalue] = Source.[Percentagevalue],
		   [IsCtcDependent] = Source.[IsCtcDependent],
		   [DependentPayrollComponentId] =  Source.[DependentPayrollComponentId],
		   [IsRelatedToPT] = Source.[IsRelatedToPT],
		   [ComponentId] = Source.[ComponentId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [Order] = Source.[Order]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [PayrollComponentId], [PayrollTemplateId], [Ispercentage], [Amount], [Percentagevalue], [IsCtcDependent], [DependentPayrollComponentId], [IsRelatedToPT], [ComponentId], [CreatedDateTime], [CreatedByUserId], [Order]) 
VALUES ([Id], [PayrollComponentId], [PayrollTemplateId], [Ispercentage], [Amount], [Percentagevalue], [IsCtcDependent], [DependentPayrollComponentId], [IsRelatedToPT], [ComponentId], [CreatedDateTime], [CreatedByUserId], [Order]);

MERGE INTO [dbo].[ProfessionalTaxRange] AS Target 
USING (VALUES 
	   (NEWID(), CAST(0.0000 AS Decimal(18, 4)), CAST(15000.0000 AS Decimal(18, 4)), CAST(0.0000 AS Decimal(18, 4)), 0, GetDate(), NULL, (SELECT TOP(1) Id FROM Branch where CompanyId = @CompanyId))
	  ,(NEWID(), CAST(20001.0000 AS Decimal(18, 4)), NULL, CAST(200.0000 AS Decimal(18, 4)), 0, GetDate(), NULL, (SELECT TOP(1) Id FROM Branch where CompanyId = @CompanyId))
	  ,(NEWID(), CAST(15001.0000 AS Decimal(18, 4)), CAST(20000.0000 AS Decimal(18, 4)), CAST(150.0000 AS Decimal(18, 4)), 0, GetDate(), NULL, (SELECT TOP(1) Id FROM Branch where CompanyId = @CompanyId))
) 
AS Source ([Id], [FromRange], [ToRange], [TaxAmount], [IsArchived], [ActiveFrom], [ActiveTo], [BranchId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [FromRange] = Source.[FromRange],
           [ToRange] = Source.[ToRange],
		   [TaxAmount] = Source.[TaxAmount],
		   [IsArchived] = Source.[IsArchived],
		   [ActiveFrom] = Source.[ActiveFrom],
		   [ActiveTo] = Source.[ActiveTo],
		   [BranchId] = Source.[BranchId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [FromRange], [ToRange], [TaxAmount], [IsArchived], [ActiveFrom], [ActiveTo], [BranchId]) 
VALUES ([Id], [FromRange], [ToRange], [TaxAmount], [IsArchived], [ActiveFrom], [ActiveTo], [BranchId]);

MERGE INTO [dbo].ShiftTiming AS Target 
USING (VALUES 
	   (NEWId(),@CompanyId,'Regular day',(SELECT TOP(1) Id FROM Branch where CompanyId = @CompanyId AND InActiveDateTime IS NULL),GETDATE(),@UserId)
) 
AS Source (Id,CompanyId,ShiftName,BranchId,CreatedDateTime,CreatedByUserId)
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           CompanyId = Source.CompanyId,
           ShiftName = Source.ShiftName,
		   BranchId = Source.BranchId,
		   CreatedDateTime = Source.CreatedDateTime,
		   CreatedByUserId = Source.CreatedByUserId
WHEN NOT MATCHED BY TARGET THEN 
INSERT (Id,CompanyId,ShiftName,BranchId,CreatedDateTime,CreatedByUserId) 
VALUES (Id,CompanyId,ShiftName,BranchId,CreatedDateTime,CreatedByUserId);

MERGE INTO [dbo].ShiftWeek AS Target 
USING (VALUES 
	   (NEWId(),(SELECT TOP 1 Id FROM ShiftTiming WHERE ShiftName = 'Regular day' AND InActiveDateTime IS NULL AND BranchId = (SELECT TOP(1) Id FROM Branch where CompanyId = @CompanyId AND InActiveDateTime IS NULL)),'Monday','03:30:00','12:30:00','03:45:00',0,GETDATE(),@UserId)
	  ,(NEWId(),(SELECT TOP 1 Id FROM ShiftTiming WHERE ShiftName = 'Regular day' AND InActiveDateTime IS NULL AND BranchId = (SELECT TOP(1) Id FROM Branch where CompanyId = @CompanyId AND InActiveDateTime IS NULL)),'Tuesday','03:30:00','12:30:00','03:45:00',0,GETDATE(),@UserId)
	  ,(NEWId(),(SELECT TOP 1 Id FROM ShiftTiming WHERE ShiftName = 'Regular day' AND InActiveDateTime IS NULL AND BranchId = (SELECT TOP(1) Id FROM Branch where CompanyId = @CompanyId AND InActiveDateTime IS NULL)),'Wednesday','03:30:00','12:30:00','03:45:00',0,GETDATE(),@UserId)
	  ,(NEWId(),(SELECT TOP 1 Id FROM ShiftTiming WHERE ShiftName = 'Regular day' AND InActiveDateTime IS NULL AND BranchId = (SELECT TOP(1) Id FROM Branch where CompanyId = @CompanyId AND InActiveDateTime IS NULL)),'Thursday','03:30:00','12:30:00','03:45:00',0,GETDATE(),@UserId)
	  ,(NEWId(),(SELECT TOP 1 Id FROM ShiftTiming WHERE ShiftName = 'Regular day' AND InActiveDateTime IS NULL AND BranchId = (SELECT TOP(1) Id FROM Branch where CompanyId = @CompanyId AND InActiveDateTime IS NULL)),'Friday','03:30:00','12:30:00','03:45:00',0,GETDATE(),@UserId)
) 
AS Source (Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId)
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           ShiftTimingId = Source.ShiftTimingId,
           [DayOfWeek] = Source.[DayOfWeek],
		   StartTime = Source.StartTime,
		   EndTime = Source.EndTime,
		   DeadLine = Source.DeadLine,
		   IsPaidBreak = Source.IsPaidBreak,
		   CreatedDateTime = Source.CreatedDateTime,
		   CreatedByUserId = Source.CreatedByUserId
WHEN NOT MATCHED BY TARGET THEN 
INSERT (Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId) 
VALUES (Id,ShiftTimingId,[DayOfWeek],StartTime,EndTime,DeadLine,IsPaidBreak,CreatedDateTime,CreatedByUserId);

END