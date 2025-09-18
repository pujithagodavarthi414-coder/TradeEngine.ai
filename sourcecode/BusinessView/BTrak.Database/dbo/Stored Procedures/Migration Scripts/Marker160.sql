CREATE PROCEDURE [dbo].[Marker160]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

UPDATE FinancialYearConfigurations SET CountryId = B.CountryId
FROM FinancialYearConfigurations FYC 
INNER JOIN Branch B ON B.Id = FYC.BranchId
WHERE B.CompanyId = @CompanyId

UPDATE TaxSlabs SET CountryId = B.CountryId
FROM TaxSlabs TS INNER JOIN Branch B ON B.Id = TS.BranchId
WHERE B.CompanyId = @CompanyId

UPDATE TaxAllowances SET CountryId = B.CountryId
FROM TaxAllowances TA 
INNER JOIN Branch B ON B.Id = TA.BranchId
WHERE B.CompanyId = @CompanyId

IF EXISTS(SELECT * FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual')
BEGIN

DELETE TA FROM [TaxAllowances] TA
JOIN TaxAllowanceType TAY ON TAY.Id = TaxAllowanceTypeId
WHERE CompanyId = @CompanyId AND TA.CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)

MERGE INTO [dbo].[TaxAllowances] AS Target 
USING (VALUES 
         (NEWID(), N'24', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, CAST(200000.0000 AS Decimal(10, 4)), NULL, NULL, NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:47:39.577' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'80C', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, CAST(150000.0000 AS Decimal(10, 4)), NULL, NULL, NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:38:12.013' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'80CCD(1B)', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, CAST(50000.0000 AS Decimal(10, 4)), NULL, NULL, NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:50:47.180' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'80D', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, CAST(25000.0000 AS Decimal(10, 4)), NULL, NULL, NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, CAST(50000.0000 AS Decimal(10, 4)), NULL, 0, CAST(N'2020-10-09 08:02:56.390' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'80TTA', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, CAST(10000.0000 AS Decimal(10, 4)), NULL, NULL, NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:51:58.680' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'80TTB', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, CAST(50000.0000 AS Decimal(10, 4)), NULL, NULL, NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:53:34.990' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'HRA', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, NULL, NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 1, CAST(N'2020-10-09 08:04:54.430' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
		 )

AS Source ([Id], [Name], [TaxAllowanceTypeId], [IsPercentage], [MaxAmount], [PercentageValue], [ParentId], [PayRollComponentId], [ComponentId], [FromDate], [ToDate], [OnlyEmployeeMaxAmount], [MetroMaxPercentage], [LowestAmountOfParentSet], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [InactiveDateTime], [BranchId], [CountryId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [Name] = Source.[Name],
           [TaxAllowanceTypeId] = Source.[TaxAllowanceTypeId],
		   [IsPercentage] = Source.[IsPercentage],
		   [MaxAmount] = Source.[MaxAmount],
		   [PercentageValue] = Source.[PercentageValue],
		   [ParentId] = Source.[ParentId],
		   [PayRollComponentId] = Source.[PayRollComponentId],
		   [ComponentId] = Source.[ComponentId],
		   [FromDate] = Source.[FromDate],
		   [ToDate] = Source.[ToDate],
		   [OnlyEmployeeMaxAmount] = Source.[OnlyEmployeeMaxAmount],
		   [MetroMaxPercentage] = Source.[MetroMaxPercentage],
		   [LowestAmountOfParentSet] = Source.[LowestAmountOfParentSet],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [UpdatedDateTime] = Source.[UpdatedDateTime],
		   [UpdatedByUserId] = Source.[UpdatedByUserId],
		   [InactiveDateTime] = Source.[InactiveDateTime],
		   [BranchId] = Source.[BranchId],
		   [CountryId] = Source.[CountryId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Name], [TaxAllowanceTypeId], [IsPercentage], [MaxAmount], [PercentageValue], [ParentId], [PayRollComponentId], [ComponentId], [FromDate], [ToDate], [OnlyEmployeeMaxAmount], [MetroMaxPercentage], [LowestAmountOfParentSet], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [InactiveDateTime], [BranchId], [CountryId]) 
VALUES ([Id], [Name], [TaxAllowanceTypeId], [IsPercentage], [MaxAmount], [PercentageValue], [ParentId], [PayRollComponentId], [ComponentId], [FromDate], [ToDate], [OnlyEmployeeMaxAmount], [MetroMaxPercentage], [LowestAmountOfParentSet], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [InactiveDateTime], [BranchId], [CountryId]);

MERGE INTO [dbo].[TaxAllowances] AS Target 
USING (VALUES 
         (NEWID(), N'HOME LOAN INTEREST', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='24' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:48:23.453' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'ELSS', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:45:58.607' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'KVP', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:42:22.123' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'SSY', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:42:56.660' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'NSC', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:44:11.497' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'LIC', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:39:30.010' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'HOME LOAN PRINCIPAL', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:44:53.470' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'STAMP DUTY', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:47:03.740' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'EPF', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Automatic'), 0, NULL, CAST(24.0000 AS Decimal(10, 4)), (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), (SELECT TOP(1) Id FROM PayRollComponent WHERE ComponentName ='Basic' AND CompanyId = @CompanyId), NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:38:59.043' AS DateTime), @UserId, CAST(N'2020-10-09 07:40:44.347' AS DateTime), @UserId, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'SCHOOL FEES', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:45:26.907' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'PPF', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80C' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:41:21.303' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'NPS', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80CCD(1B)' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:51:09.617' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'MEDICLAIM', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, CAST(50000.0000 AS Decimal(10, 4)), NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80D' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, CAST(25000.0000 AS Decimal(10, 4)), NULL, 0, CAST(N'2020-10-09 08:04:09.333' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'INTEREST ON SAVINGS ACCOUNT (OTHER THAN SENIOR CITIZEN)', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80TTA' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:53:07.290' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'INTEREST ON SAVINGS ACCOUNT (SENEIOR CITIZEN)', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80TTB' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:58:21.177' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'INTEREST ON DEPOSITS WITH POST OFFICE, BANKS, CO-OPERATIVE BANK (SENEIOR CITIZEN)', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='80TTB' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 07:59:46.057' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'RENTAL RECEIPTS', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Manual'), 0, NULL, NULL, (SELECT Id FROM TaxAllowances WHERE Name ='HRA' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 10:34:54.360' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'RENTAL-10%BASIC', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Automatic'), 0, NULL, CAST(10.0000 AS Decimal(10, 4)), (SELECT Id FROM TaxAllowances WHERE Name ='HRA' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), NULL, (SELECT Id FROM Component WHERE ComponentName ='#Basic#-#RentalReceiptValue#'), CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, NULL, 0, CAST(N'2020-10-09 10:36:15.307' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
        ,(NEWID(), N'40% BASIC', (SELECT TOP(1) Id FROM TaxAllowanceType WHERE CompanyId = @CompanyId AND TaxAllowanceTypeName = 'Automatic'), 0, NULL, CAST(40.0000 AS Decimal(10, 4)), (SELECT Id FROM TaxAllowances WHERE Name ='HRA' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)), (SELECT TOP(1) Id FROM PayRollComponent WHERE ComponentName ='Basic' AND CompanyId = @CompanyId), NULL, CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL, NULL, CAST(50.0000 AS Decimal(10, 4)), 0, CAST(N'2020-10-09 10:35:25.427' AS DateTime), @UserId, NULL, NULL, NULL, NULL, (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId))
)

AS Source ([Id], [Name], [TaxAllowanceTypeId], [IsPercentage], [MaxAmount], [PercentageValue], [ParentId], [PayRollComponentId], [ComponentId], [FromDate], [ToDate], [OnlyEmployeeMaxAmount], [MetroMaxPercentage], [LowestAmountOfParentSet], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [InactiveDateTime], [BranchId], [CountryId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [Name] = Source.[Name],
           [TaxAllowanceTypeId] = Source.[TaxAllowanceTypeId],
		   [IsPercentage] = Source.[IsPercentage],
		   [MaxAmount] = Source.[MaxAmount],
		   [PercentageValue] = Source.[PercentageValue],
		   [ParentId] = Source.[ParentId],
		   [PayRollComponentId] = Source.[PayRollComponentId],
		   [ComponentId] = Source.[ComponentId],
		   [FromDate] = Source.[FromDate],
		   [ToDate] = Source.[ToDate],
		   [OnlyEmployeeMaxAmount] = Source.[OnlyEmployeeMaxAmount],
		   [MetroMaxPercentage] = Source.[MetroMaxPercentage],
		   [LowestAmountOfParentSet] = Source.[LowestAmountOfParentSet],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [UpdatedDateTime] = Source.[UpdatedDateTime],
		   [UpdatedByUserId] = Source.[UpdatedByUserId],
		   [InactiveDateTime] = Source.[InactiveDateTime],
		   [BranchId] = Source.[BranchId],
		   [CountryId] = Source.[CountryId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Name], [TaxAllowanceTypeId], [IsPercentage], [MaxAmount], [PercentageValue], [ParentId], [PayRollComponentId], [ComponentId], [FromDate], [ToDate], [OnlyEmployeeMaxAmount], [MetroMaxPercentage], [LowestAmountOfParentSet], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [InactiveDateTime], [BranchId], [CountryId]) 
VALUES ([Id], [Name], [TaxAllowanceTypeId], [IsPercentage], [MaxAmount], [PercentageValue], [ParentId], [PayRollComponentId], [ComponentId], [FromDate], [ToDate], [OnlyEmployeeMaxAmount], [MetroMaxPercentage], [LowestAmountOfParentSet], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [InactiveDateTime], [BranchId], [CountryId]);

END


MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
(NEWID(),'Today''s leaves count','','SELECT ISNULL(SUM(Total.Cnt),0) AS [Today leaves count] FROM 
		   (SELECT LAP.UserId,LAP.OverallLeaveStatusId,CASE WHEN (H.[Date] = CAST(GETDATE() AS DATE)  OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                ELSE CASE WHEN (CAST(GETDATE() AS DATE)  = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (CAST(GETDATE() AS DATE)  = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                ELSE 1 END END AS Cnt FROM
			       LeaveApplication LAP
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND (LS.isapproved = 1 OR LS.IsWaitingForApproval = 1)
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((CAST(GETDATE() AS DATE)  BETWEEN ES.ActiveFrom AND ES.ActiveTo) 
					                                                         OR (CAST(GETDATE() AS DATE)  >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) 
																	  AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,CAST(GETDATE() AS DATE) ) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = CAST(GETDATE() AS DATE)  AND H.InActiveDateTime IS NULL AND H.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND H.WeekOffDays IS NULL
			WHERE CAST(LAP.LeaveDateFrom  AS DATE) <= CAST(GETDATE() AS DATE) 
			      AND LAP.InActiveDateTime IS NULL
			      AND CAST(LAP.LeaveDateTo  AS DATE) >= CAST(GETDATE() AS DATE)
			      AND ((''@IsReportingOnly'' = 1 AND LAP.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
	 								    OR (''@IsMyself''= 1 AND  LAP.UserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
										)Total',@CompanyId,@UserId,GETDATE())
										)
AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Today''s leaves count'),'Today leaves count', 'int'
        ,'SELECT LAP.Id 
				FROM
			       LeaveApplication LAP
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND (LS.isapproved = 1 OR LS.IsWaitingForApproval = 1)
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((CAST(GETDATE() AS DATE)  BETWEEN ES.ActiveFrom AND ES.ActiveTo) 
					                                                         OR (CAST(GETDATE() AS DATE)  >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) 
																	  AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,CAST(GETDATE() AS DATE) ) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = CAST(GETDATE() AS DATE)  AND H.InActiveDateTime IS NULL AND H.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND H.WeekOffDays IS NULL
			WHERE CAST(LAP.LeaveDateFrom  AS DATE) <= CAST(GETDATE() AS DATE) 
			      AND LAP.InActiveDateTime IS NULL
			      AND CAST(LAP.LeaveDateTo  AS DATE) >= CAST(GETDATE() AS DATE)
			      AND ((''@IsReportingOnly'' = 1 AND LAP.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
	 								    OR (''@IsMyself''= 1 AND  LAP.UserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))		

			GROUP BY LAP.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Leaves' ),@CompanyId,@UserId,GETDATE(),NULL)

			)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.CompanyId = Source.CompanyId 
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId];

  UPDATE CustomAppDetails SET YCoOrdinate = 'Today leaves count' 
  WHERE VisualizationName = 'Today''s leaves count_gauge' 
        AND CustomApplicationId  IN (SELECT Id FROM CustomWidgets 
		                             WHERE CustomWidgetName = 'Today''s leaves count'
                                           AND CompanyId = @CompanyId)

END
GO
