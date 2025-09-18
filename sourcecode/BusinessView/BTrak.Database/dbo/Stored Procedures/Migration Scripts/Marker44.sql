CREATE PROCEDURE [dbo].[Marker44]
(
	@CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
UPDATE  [CustomWidgets] SET CustomWidgetName='Purchases this month' WHERE CustomWidgetName LIKE '%Purchases this moth%'  AND CompanyId = @CompanyId
UPDATE  [CustomAppDetails] SET VisualizationName='Purchases this month' WHERE VisualizationName LIKE '%Purchases this moth%'  AND InActiveDateTime IS NULL
UPDATE  [WorkspaceDashboards] SET [Name] ='Purchases this month' WHERE [Name] LIKE '%Purchases this moth%'  AND CompanyId = @CompanyId

DECLARE @Value VARCHAR(10)=N'1'
DECLARE @IsVisible BIT =1
IF NOT EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71')
	BEGIN
	SET @Value=N'0'
	SET @IsVisible = 0
	END

MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
       (NEWID(), @CompanyId, N'IsAddOrEditCustomApps ',@Value, N'Is add or edit custom apps', CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId,@IsVisible)
	   )
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET CompanyId = Source.CompanyId,
			   [Key] = source.[Key],
			   [Value] = Source.[Value],
			   [Description] = source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsVisible] = Source.[IsVisible]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]);

UPDATE CustomWidgets SET CustomWidgetName = 'Employee blocked work items/dependency analysis' 
WHERE CustomWidgetName = 'Employee blocked work items/dependency analasys' AND CompanyId = @CompanyId

UPDATE WorkspaceDashboards SET [Name] ='Employee blocked work items/dependency analysis'
            WHERE [Name] = 'Employee blocked work items/dependency analasys' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET CustomWidgetName = 'Employee lunch out Vs break < 30 mins' 
WHERE CustomWidgetName = 'Employee lunch out Vs break < 30 mints' AND CompanyId = @CompanyId

UPDATE WorkspaceDashboards SET [Name] = 'Employee lunch out Vs break < 30 mins' 
WHERE [Name] = 'Employee lunch out Vs break < 30 mints' 

UPDATE CustomWidgets SET CustomWidgetName = 'Office spent Vs productive time' 
WHERE CustomWidgetName = 'Office spent Vs prodictive time' AND CompanyId = @CompanyId

UPDATE WorkspaceDashboards SET [Name] = 'Office spent Vs productive time' 
WHERE [Name] = 'Office spent Vs prodictive time' AND CompanyId = @CompanyId 

UPDATE CustomWidgets SET CustomWidgetName = 'Planned work VS unplanned work employee wise' 
WHERE CustomWidgetName = 'Planned VS unplanned employee wise' AND CompanyId = @CompanyId

UPDATE WorkspaceDashboards SET [Name] = 'Planned work VS unplanned work employee wise' 
WHERE [Name] = 'Planned VS unplanned employee wise' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET CustomWidgetName = 'Today''s leaves count' 
WHERE CustomWidgetName = 'Today leaves count' AND CompanyId = @CompanyId

UPDATE WorkspaceDashboards SET [Name] = 'Today''s leaves count' 
WHERE [Name] = 'Today leaves count' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET CustomWidgetName = 'Today''s morning late people count' 
WHERE CustomWidgetName = 'Today morning late people count' AND CompanyId = @CompanyId

UPDATE WorkspaceDashboards SET [Name] = 'Today''s morning late people count' 
WHERE [Name] = 'Today morning late people count' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET CustomWidgetName = 'Today''s target' 
WHERE CustomWidgetName = 'Today target' AND CompanyId = @CompanyId

UPDATE Widget SET WidgetName = 'Work item status' 
WHERE WidgetName = 'Work item status with admin' AND CompanyId = @CompanyId

UPDATE WorkspaceDashboards SET [Name] = 'Today''s target'
 WHERE [Name] = 'Today target' AND CompanyId = @CompanyId
	
UPDATE CustomWidgets SET WidgetQuery = '
SELECT COUNT(1)[Night late people count] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	         WHERE CAST(TS.[Date] AS date)  = CAST(DATEADD(DAY,-1,GETDATE()) AS date)AND  cast(OutTime as time) >= ''16:30:00.00''
			 AND CompanyId =(SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy''  AND InActiveDateTime IS NULL)
' WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Night late people count'

			UPDATE CustomWidgets SET WidgetQuery = '
SELECT ISNULL(SUM(Total.Cnt),0) AS [Leaves waiting approval] FROM 
		   (SELECT LAP.UserId,LAP.OverallLeaveStatusId,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                ELSE 1 END END AS Cnt FROM
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM master..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = ''P'' AND LA.InActiveDateTime IS NULL
										    ) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id AND LAP.InActiveDateTime IS NULL
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsWaitingForApproval = 1
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND H.WeekOffDays IS NULL
			)Total' WHERE CompanyId = @CompanyId  AND CustomWidgetName = 'Leaves waiting approval'

				UPDATE CustomWidgets SET WidgetQuery= '
SELECT ISNULL(Jinner.[Yesterday team spent time],''0h'')[Yesterday team spent time]  FROM(
SELECT CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time] FROM
					     (SELECT ISNULL([Spent time],0) [Spent time] FROM
						 (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - 
	                         ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
							          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				                                   LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = UB.[Date] AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,
												   TS.LunchBreakStartTime,TS.UserId)T WHERE T.[Spent time] > 0)
												   Z)Jinner		' 
												   WHERE CustomWidgetName ='Yesterday team spent time' AND CompanyId = @CompanyId

												   	UPDATE CustomWidgets SET WidgetQuery= 'SELECT COUNT(1)[Imminent deadline work items count] FROM
(SELECT US.Id
 FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
 AND US.OwnerUserId =  ''@OperationsPerformedBy''
                                                   AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
                   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
			          AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			       INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'')
			       LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	               LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND (GS.IsActive = 1 )
				   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND  S.SprintStartDate IS NOT NULL
				   WHERE ((US.GoalId IS NoT NULL AND GS.Id IS Not NULL AND  (CAST(US.DeadLineDate AS date) > CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	
				 AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))))
				  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND CAST(S.SprintEndDate AS date) >= CAST(GETDATE() AS date)))
				  GROUP BY US.Id)T' 
												   WHERE CustomWidgetName ='Imminent deadline work items count' AND CompanyId = @CompanyId

UPDATE WorkspaceDashboards SET [Name] = 'Leaves waiting for approval'  WHERE [Name] = 'Leaves waiting approval' 
    AND CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Leaves waiting approval'  AND CompanyId = @CompanyId )

UPDATE CustomWidgets SET CustomWidgetName = 'Leaves waiting for approval' WHERE CustomWidgetName ='Leaves waiting approval'  AND CompanyId = @CompanyId  


UPDATE EntityFeature
SET InActiveDateTime = GETDATE() WHERE Id = '0C32D02D-F453-48ED-9D1F-F701D1164BF7'

 --DECLARE @ModuleId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[Module] WHERE ModuleName = 'Authorisation')
 --  DECLARE @CompanyModuleId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[CompanyModule] WHERE CompanyId = @CompanyId AND ModuleId = @ModuleId AND IsActive = 1 )

 --  IF (@CompanyModuleId IS NULL AND @ModuleId IS NOT NULL)
 --  BEGIN
 --  MERGE INTO [dbo].[CompanyModule] AS Target 
 --   USING ( VALUES 
 --  (NEWID(), @CompanyId, @ModuleId,0, CAST(N'2020-01-17T09:38:36.913' AS DateTime), @UserId)
 --   )
 --   AS Source ([Id], [CompanyId], [ModuleId],[IsActive], [CreatedDateTime], [CreatedByUserId])
 --   ON Target.Id = Source.Id
 --   WHEN MATCHED THEN
 --   UPDATE SET 
 --              [ModuleId] = Source.[ModuleId],
	--		   [IsActive] = Source.[IsActive],
 --              [CompanyId] = Source.[CompanyId],    
 --              [CreatedDateTime] = Source.[CreatedDateTime],
 --              [CreatedByUserId] = Source.[CreatedByUserId]
 --   WHEN NOT MATCHED BY TARGET THEN 
 --   INSERT ([Id], [CompanyId], [ModuleId],[IsActive],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId],[ModuleId],[IsActive], [CreatedDateTime], [CreatedByUserId]);
	--END

IF NOT EXISTS(SELECT * FROM CompanySettings WHERE [Key]='ConsiderMACAddressInEmployeeScreen' AND CompanyId=@CompanyId)
BEGIN

DECLARE @Val CHAR(1) = IIF((SELECT IndustryId FROM Company WHERE Id = @CompanyId) = (SELECT Id FROM Industry WHERE IndustryName LIKE '%Remote Working%') , 1, 0)

MERGE INTO [dbo].[CompanySettings] AS Target
USING ( VALUES
			(NEWID(), @CompanyId, N'ConsiderMACAddressInEmployeeScreen', @Val,N'Considering MAC address from employee ', GETDATE(), @UserId)
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

END

-- Project role default permissions

DECLARE @ProjectDevRoleId UNIQUEIDENTIFIER
DECLARE @ProjectLeadRoleId UNIQUEIDENTIFIER
DECLARE @ProjectQaRoleId UNIQUEIDENTIFIER

SELECT @ProjectDevRoleId = Id FROM [EntityRole] WHERE CompanyId=@CompanyId AND EntityRoleName = 'Project developer'
SELECT @ProjectLeadRoleId = Id FROM [EntityRole] WHERE CompanyId=@CompanyId AND EntityRoleName = 'Project lead'
SELECT @ProjectQaRoleId = Id FROM [EntityRole] WHERE CompanyId=@CompanyId AND EntityRoleName = 'Project qa'

IF(@ProjectDevRoleId IS NOT NULL)
BEGIN

	MERGE INTO [dbo].[EntityRoleFeature] AS Target 
		USING ( VALUES 
	(NEWID(), N'E769DD87-69C4-49B7-85B4-56F2170D4799',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	--(NEWID(), N'CA3B6E21-8C62-4D91-8338-92A956F83BCA',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'F35FB3F9-8B59-4A8B-8781-E795CA0BE55E',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'DDC5DD27-D443-4E66-8168-8AA057B3DC23',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'BACB1281-D0E9-485B-B6E4-407AC560BEF6',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'F3195B7A-C116-4BB0-9722-CEFFCB5E126D',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'FBC59404-079C-4C1D-866A-7129FFB06450',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'456ABE97-C833-402C-9172-3BBAE3BEBB9D',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'15430FCA-1BEA-40E0-AD04-EF49CB049FA5',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'DA6793DA-586B-410A-B406-D019AE9D68A6',@ProjectDevRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId)
	) 
		AS Source ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]) 
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [EntityFeatureId] = Source.[EntityFeatureId],
				   [EntityRoleId] = Source.[EntityRoleId],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]) 
		VALUES ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]);

END

IF(@ProjectLeadRoleId IS NOT NULL)
BEGIN

	MERGE INTO [dbo].[EntityRoleFeature] AS Target 
		USING ( VALUES 
	
	(NEWID(), N'15430FCA-1BEA-40E0-AD04-EF49CB049FA5',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	--(NEWID(), N'CA3B6E21-8C62-4D91-8338-92A956F83BCA',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'BE7781C6-713D-4B8A-AFF7-4EA7D0415730',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'456ABE97-C833-402C-9172-3BBAE3BEBB9D',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'8286A0BD-2640-475E-B275-F6DFEFFD26D5',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'E769DD87-69C4-49B7-85B4-56F2170D4799',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'CB732217-C68E-45E7-8D47-9C809A974D64',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'BF4BA389-0000-4BC5-8158-7B94CEF2D9B1',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'DA6793DA-586B-410A-B406-D019AE9D68A6',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'9C1AF8F6-464D-438C-A9C7-3D15174FE12E',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'611DB8EA-A237-478A-ACEC-F295D996A869',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'BACB1281-D0E9-485B-B6E4-407AC560BEF6',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'DDC5DD27-D443-4E66-8168-8AA057B3DC23',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'B40DF5A4-3BF9-4206-8757-6371C6F72F0D',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'B2375297-CB8F-4A06-B364-F732A5037A77',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'F35FB3F9-8B59-4A8B-8781-E795CA0BE55E',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'FBC59404-079C-4C1D-866A-7129FFB06450',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'220A1FCE-87F4-4FB2-A171-EC242E1CA035',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'B49A96AC-3F90-4D63-8EC0-5E8F542E6E13',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'F3195B7A-C116-4BB0-9722-CEFFCB5E126D',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'0B9A3D23-EDFF-456A-9D69-D8F2E9D7784F',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'F683B9DD-C302-45B4-90B8-F0737644806D',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'D8FAA4BB-C900-40BD-883E-653D3B98B27D',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'5C509269-983E-4E31-994A-B6C0558029DA',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'AF25210A-ABC3-4BC7-87E6-A02AA3B81A50',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'12365639-1CC0-4A9C-B787-F1AA8C5C5293',@ProjectLeadRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId)
	) 
		AS Source ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]) 
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [EntityFeatureId] = Source.[EntityFeatureId],
				   [EntityRoleId] = Source.[EntityRoleId],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]) 
		VALUES ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]);

END

IF(@ProjectDevRoleId IS NOT NULL)
BEGIN

	MERGE INTO [dbo].[EntityRoleFeature] AS Target 
		USING ( VALUES 
	
	(NEWID(), N'C0828385-B5D2-4176-8653-C65A6A586EF0',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'BE7781C6-713D-4B8A-AFF7-4EA7D0415730',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'71F29ABA-13FD-42A0-BA92-6474694FFECE',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'B76F1702-5F5C-466B-97D7-DF369C2A8A32',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'EB37496A-D573-499A-8804-8C44504DA450',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'B49A96AC-3F90-4D63-8EC0-5E8F542E6E13',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'D8FAA4BB-C900-40BD-883E-653D3B98B27D',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	--(NEWID(), N'CA3B6E21-8C62-4D91-8338-92A956F83BCA',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'AB90D413-5021-4232-ACAB-11E11E9A59E6',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'876C0F6B-846D-4CBD-AD1B-7B49F3D3B978',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'B2375297-CB8F-4A06-B364-F732A5037A77',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'7ADB5FC3-4C21-48FE-A8BB-7E81217F2E91',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'BF4BA389-0000-4BC5-8158-7B94CEF2D9B1',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'CB732217-C68E-45E7-8D47-9C809A974D64',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'8286A0BD-2640-475E-B275-F6DFEFFD26D5',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'BACB1281-D0E9-485B-B6E4-407AC560BEF6',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'3D2853EE-527C-4AA3-BF83-A939F7834CC3',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'CA9DBDDE-0B61-4916-B494-3EA374A9065C',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'1E618A6C-E653-44DB-BFBB-82A7F0412041',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'9C1AF8F6-464D-438C-A9C7-3D15174FE12E',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'E74DEA02-4ED0-4276-B4A9-1DFD433BB00F',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'C801C0D4-C35B-48D2-9EA5-15048BA71904',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'CFD6FA63-25BC-4953-9B75-973114563793',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'F3195B7A-C116-4BB0-9722-CEFFCB5E126D',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'B90731AE-6B56-4D3B-8E99-0D625A999DD2',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'AF25210A-ABC3-4BC7-87E6-A02AA3B81A50',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'456ABE97-C833-402C-9172-3BBAE3BEBB9D',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'DA6793DA-586B-410A-B406-D019AE9D68A6',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'5C509269-983E-4E31-994A-B6C0558029DA',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'611DB8EA-A237-478A-ACEC-F295D996A869',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'CB4F95E1-08E8-46CD-A25A-352EAED56505',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'881989C4-9B1B-4900-B1B5-B48C835237F2',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'E769DD87-69C4-49B7-85B4-56F2170D4799',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'15430FCA-1BEA-40E0-AD04-EF49CB049FA5',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'FF8A0BE1-2A5D-4E53-B71C-E21CBEE9DF61',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'BA495879-FC48-4231-BCCB-5DA604490456',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'8F3B039E-B17A-454A-BD3E-76BE6FD35484',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'F35FB3F9-8B59-4A8B-8781-E795CA0BE55E',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'FBC59404-079C-4C1D-866A-7129FFB06450',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'A7758D2F-D23B-458A-B0EC-230ED046B51B',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'DDC5DD27-D443-4E66-8168-8AA057B3DC23',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId),
	(NEWID(), N'F683B9DD-C302-45B4-90B8-F0737644806D',@ProjectQaRoleId, CAST(N'2020-06-02 06:17:58.240' AS DateTime), @UserId)
	) 
		AS Source ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]) 
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [EntityFeatureId] = Source.[EntityFeatureId],
				   [EntityRoleId] = Source.[EntityRoleId],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]) 
		VALUES ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]);

END

	DECLARE @SettingValue VARCHAR(10)=N'1'
    DECLARE @SettingIsVisible BIT =1

	DECLARE  @IsSoftWare BIT = (SELECT IsSoftWare FROM [dbo].[Company] WHERE Id = @CompanyId)
	
	IF(@IsSoftWare = 0)
	BEGIN
	 SET @SettingValue = N'0'
	END

MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
	   (NEWID(), @CompanyId, N'EnableSprints ',@SettingValue, N'Enable Sprints', CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId,@SettingIsVisible),
	   (NEWID(), @CompanyId, N'EnableTestcaseManagement ',@SettingValue, N'Enable test case management', CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId,@SettingIsVisible),
	   (NEWID(), @CompanyId, N'EnableBugBoard ',@SettingValue, N'Enable bug board', CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId,@SettingIsVisible)

	)
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET CompanyId = Source.CompanyId,
			   [Key] = source.[Key],
			   [Value] = Source.[Value],
			   [Description] = source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsVisible] = Source.[IsVisible]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]);
	  
	  DECLARE @Currentdate DATETIME = GETDATE()

MERGE INTO [dbo].[Tags] AS Target
USING ( VALUES
 (NEWID(),1,'Projects',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),2,'HR',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),3,'Documents',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),4,'Leaves',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),5,'Payroll',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),6,'Audits',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),7,'Roster',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),8,'Assets',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),9,'Activity Tracker',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),10,'Invoices',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),11,'Expenses',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),12,'Forms',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),13,'Canteen',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),14,'Food Order',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),15,'Productivity',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),16,'Feature App',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),41,'System',NULL,@CompanyId,@UserId,@Currentdate)
,(NEWID(),NULL,'Other',NULL,@CompanyId,@UserId,@Currentdate)
)
AS Source ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [TagName] = Source.[TagName],
		   [CompanyId] = Source.[CompanyId],	
		   [ParentTagId] = Source.[ParentTagId],	
		   [Order] = Source.[Order],	
		   [CreatedDateTime] = Source.[CreatedDateTime],	
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT  ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]) VALUES
([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]);	

MERGE INTO [dbo].[Tags] AS Target
USING ( VALUES
(NEWID(),17,'Project Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Projects' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),18,'Goals',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Projects' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),19,'Sprints',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Projects' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),20,'Test Case Management',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Projects' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),21,'HR Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'HR' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),22,'Time Sheet Management',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'HR' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),23,'Users',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'HR' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),24,'Leave Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Leaves' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),25,'Roster Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Roster' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),26,'Asset Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Assets' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),27,'Expense Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Expenses' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),28,'Canteen Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Canteen' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),29,'Food Order Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Food Order' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),30,'Project Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Projects' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),31,'HR Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'HR' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),32,'Leave Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Leaves' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),33,'Payroll Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Payroll' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),34,'Audit Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Audits' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),35,'Asset Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Assets' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),36,'Activity Tracker Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Activity Tracker' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),37,'Invoice Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Invoices' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),38,'Expense Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Expenses' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),39,'Form Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Forms' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),40,'Canteen Configuration',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Canteen' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),41,'Payroll Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Payroll' ),@CompanyId,@UserId,@Currentdate)
,(NEWID(),NULL,'Activity',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Projects'),@CompanyId,@UserId,@Currentdate)
)
AS Source ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [TagName] = Source.[TagName],
		   [CompanyId] = Source.[CompanyId],	
		   [ParentTagId] = Source.[ParentTagId],	
		   [Order] = Source.[Order],	
		   [CreatedDateTime] = Source.[CreatedDateTime],	
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT  ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]) VALUES
([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]);	

END