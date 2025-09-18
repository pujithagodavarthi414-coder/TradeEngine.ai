-- exec [USP_CompanyTestDataInsertScript] @CompanyId = '17B0B359-FD58-4088-A0AA-A88CCF0D5C80',@UserId = '0B77544C-668A-4992-B10E-D8B1848E3821'
CREATE PROCEDURE  [dbo].[USP_CompanyTestDataInsertScript]
(
 @CompanyId UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

DECLARE @CompanyName NVARCHAR(MAX) = (SELECT LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 20) FROM Company WHERE Id = @CompanyId)

DECLARE @RoleId UNIQUEIDENTIFIER = (SELECT TOP(1) RoleId FROM UserRole WHERE UserId = @UserId AND InactiveDateTime IS NULL)

MERGE INTO [dbo].[User] AS Target
USING ( VALUES
       (NEWID(), @CompanyId, N'Garcia', N'Maria', N'Maria@'+@CompanyName+'.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, CAST(N'2019-03-01T19:41:04.277' AS DateTime), NULL, (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),GetDate(), @UserId),
	   (NEWID(), @CompanyId, N'Johnson', N'James', N'James@'+@CompanyName+'.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, CAST(N'2019-03-01T19:40:12.007' AS DateTime), NULL, (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),GetDate(), @UserId),
	   --(NEWID(), @CompanyId, N'Simson', N'James', N'Simson@'+@CompanyName+'.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, CAST(N'2019-03-01T19:40:12.007' AS DateTime), NULL, (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),GetDate(), @UserId),
	   --(NEWID(), @CompanyId, N'Gokul', N'James', N'Gokul@'+@CompanyName+'.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, CAST(N'2019-03-01T19:40:12.007' AS DateTime), NULL, (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),GetDate(), @UserId),
	   (NEWID(), @CompanyId, N'Smith', N'David', N'David@'+@CompanyName+'.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi',  NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, CAST(N'2019-03-01T19:39:52.750' AS DateTime), NULL, (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),GetDate(), @UserId),
	   (NEWID(), @CompanyId, N'Martinez', N'Maria', N'Martinez@'+@CompanyName+'.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, CAST(N'2019-03-01T19:41:52.540' AS DateTime), NULL, (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),GetDate(), @UserId)
)

AS Source ([Id], [CompanyId], [SurName], [FirstName], [UserName], [Password], [IsPasswordForceReset], [IsActive], [TimeZoneId], [MobileNo], [IsAdmin], [IsActiveOnMobile], [RegisteredDateTime], [LastConnection], [CurrencyId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [SurName] = source.[SurName],
		   [FirstName] = source.[FirstName],
		   [UserName] = Source.[UserName],
		   [Password] = source.[Password],
		   [IsPasswordForceReset] = Source.[IsPasswordForceReset],
		   [IsActive] = source.[IsActive],
		   [MobileNo] = source.[MobileNo],
		   [IsAdmin] = source.[IsAdmin],
		   [IsActiveOnMobile] = source.[IsActiveOnMobile],
		   [RegisteredDateTime] = source.[RegisteredDateTime],
		   [LastConnection] = source.[LastConnection],
		   [CurrencyId] = Source.[CurrencyId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]

WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [SurName], [FirstName], [UserName], [Password],  [IsPasswordForceReset], [IsActive], [TimeZoneId], [MobileNo], [IsAdmin], [IsActiveOnMobile], [RegisteredDateTime], [LastConnection], [CurrencyId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [SurName], [FirstName], [UserName], [Password], [IsPasswordForceReset], [IsActive], [TimeZoneId], [MobileNo], [IsAdmin], [IsActiveOnMobile], [RegisteredDateTime], [LastConnection], [CurrencyId], [CreatedDateTime], [CreatedByUserId]);

UPDATE [User] SET CurrencyId =(SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId) WHERE Id=@UserId

IF NOT EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71')
	BEGIN
    IF EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='3AA49D13-76C9-4842-840E-4AC759B65DF8')
	BEGIN
		MERGE INTO [dbo].[UserRole] AS Target 
		USING ( VALUES 
		 (NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'Maria@'+@CompanyName+'.com' AND CompanyId = @CompanyId), ISNULL((SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId),@RoleId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com' AND CompanyId = @CompanyId), ISNULL((SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId),@RoleId) ,NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'David@'+@CompanyName+'.com' AND CompanyId = @CompanyId),ISNULL((SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId),@RoleId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'Martinez@'+@CompanyName+'.com' AND CompanyId = @CompanyId),ISNULL((SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId),@RoleId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		) 
		AS Source ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [UserId] = Source.[UserId],
				   [RoleId] = Source.[RoleId],
				   [InActiveDateTime] = Source.[InActiveDateTime],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
		VALUES ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId]);
	END
	ELSE IF EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='BBBB8092-EBCC-43FF-A039-5E3BD2FACE51')
	BEGIN
		MERGE INTO [dbo].[UserRole] AS Target 
		USING ( VALUES 
		(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com' AND CompanyId = @CompanyId), (SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId) ,NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'David@'+@CompanyName+'.com' AND CompanyId = @CompanyId),(SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'Martinez@'+@CompanyName+'.com' AND CompanyId = @CompanyId),(SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		) 
		AS Source ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [UserId] = Source.[UserId],
				   [RoleId] = Source.[RoleId],
				   [InActiveDateTime] = Source.[InActiveDateTime],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
		VALUES ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId]);
	END
	ELSE
	BEGIN
		MERGE INTO [dbo].[UserRole] AS Target 
		USING ( VALUES 
		 (NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'Maria@'+@CompanyName+'.com' AND CompanyId = @CompanyId), (SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com' AND CompanyId = @CompanyId), (SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId) ,NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'David@'+@CompanyName+'.com' AND CompanyId = @CompanyId),(SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'Martinez@'+@CompanyName+'.com' AND CompanyId = @CompanyId),(SELECT Id FROM [Role] WHERE RoleName = 'Super Admin' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		) 
		AS Source ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [UserId] = Source.[UserId],
				   [RoleId] = Source.[RoleId],
				   [InActiveDateTime] = Source.[InActiveDateTime],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
		VALUES ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId]);
	END
	END
ELSE
	BEGIN 
		MERGE INTO [dbo].[UserRole] AS Target 
		USING ( VALUES 
		 (NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'Maria@'+@CompanyName+'.com' AND CompanyId = @CompanyId), (SELECT Id FROM [Role] WHERE RoleName = 'Lead Developer' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com' AND CompanyId = @CompanyId), (SELECT Id FROM [Role] WHERE RoleName = 'Software Engineer' AND CompanyId = @CompanyId) ,NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'David@'+@CompanyName+'.com' AND CompanyId = @CompanyId),(SELECT Id FROM [Role] WHERE RoleName = 'Software Engineer' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		,(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'Martinez@'+@CompanyName+'.com' AND CompanyId = @CompanyId),(SELECT Id FROM [Role] WHERE RoleName = 'Software Engineer' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime),@UserId)
		) 
		AS Source ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [UserId] = Source.[UserId],
				   [RoleId] = Source.[RoleId],
				   [InActiveDateTime] = Source.[InActiveDateTime],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
		VALUES ([Id], [UserId], [RoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId]);
	END



MERGE INTO [dbo].[Employee] AS Target
USING ( VALUES
	(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),'MG 1234',(SELECT Id FROM Gender WHERE CompanyId = @CompanyId AND Gender = 'Female'),(SELECT Id FROM MaritalStatus WHERE CompanyId = @CompanyId AND MaritalStatus = 'Single'),(SELECT Id FROM Nationality WHERE NationalityName LIKE '%British%' AND CompanyId = @CompanyId),'1990-09-10',NULL,getdate(),@UserId),
	(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),'JS 1234',(SELECT Id FROM Gender WHERE CompanyId = @CompanyId AND Gender = 'Male'),(SELECT Id FROM MaritalStatus WHERE CompanyId = @CompanyId AND MaritalStatus = 'Married'),(SELECT Id FROM Nationality WHERE NationalityName LIKE '%American%' AND CompanyId = @CompanyId),'1990-09-21','2018-06-03',getdate(),@UserId),
	(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),'DS 1234',(SELECT Id FROM Gender WHERE CompanyId = @CompanyId AND Gender = 'Male'),(SELECT Id FROM MaritalStatus WHERE CompanyId = @CompanyId AND MaritalStatus = 'Single'),(SELECT Id FROM Nationality WHERE NationalityName LIKE '%British%' AND CompanyId = @CompanyId),'1997-08-20',NULL,getdate(),@UserId),
	(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),'MM 1234',(SELECT Id FROM Gender WHERE CompanyId = @CompanyId AND Gender = 'FeMale'),(SELECT Id FROM MaritalStatus WHERE CompanyId = @CompanyId AND MaritalStatus = 'Married'),(SELECT Id FROM Nationality WHERE NationalityName LIKE '%British%' AND CompanyId = @CompanyId),'1989-04-11',DATEADD(YEAR, -15, GETDATE()),getdate(),@UserId)
)

AS Source ([Id], [UserId],EmployeeNumber,GenderId,MaritalStatusId,NationalityId,DateOfBirth,[MarriageDate], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserId] = Source.[UserId],
		   EmployeeNumber = Source.EmployeeNumber,
		   GenderId = Source.GenderId,
		   MaritalStatusId = Source.MaritalStatusId,
		   NationalityId = Source.NationalityId,
		   DateOfBirth = Source.DateOfBirth,
		   [MarriageDate] = Source.[MarriageDate],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [UserId],EmployeeNumber,GenderId,MaritalStatusId,NationalityId,DateOfBirth,[MarriageDate], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [UserId],EmployeeNumber,GenderId,MaritalStatusId,NationalityId,DateOfBirth,[MarriageDate], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeReportTo] AS Target
USING ( VALUES
		 (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
				   (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE U.Id = @UserId AND CompanyId = @CompanyId), CAST(N'2019-03-20T16:22:15.210' AS DateTime), NULL, GetDate(), @UserId,(SELECT Id FROM ReportingMethod WHERE [ReportingMethodType] LIKE '%Direct%' AND CompanyId = @CompanyId))
        ,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
				   (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(N'2019-03-20T16:22:15.213' AS DateTime), NULL, GetDate(), @UserId,(SELECT Id FROM ReportingMethod WHERE [ReportingMethodType] LIKE '%Direct%' AND CompanyId = @CompanyId))
        ,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
				   (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(N'2019-03-20T10:21:16.740' AS DateTime), NULL, GetDate(), @UserId,(SELECT Id FROM ReportingMethod WHERE [ReportingMethodType] LIKE '%Direct%' AND CompanyId = @CompanyId))
        ,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
				   (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(N'2019-03-19T17:28:51.410' AS DateTime), NULL, GetDate(), @UserId,(SELECT Id FROM ReportingMethod WHERE [ReportingMethodType] LIKE '%Direct%' AND CompanyId = @CompanyId))
)
AS Source ([Id], [EmployeeId], [ReportToEmployeeId], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId],[ReportingMethodId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [EmployeeId] = Source.[EmployeeId],
		   [ReportToEmployeeId] = source.[ReportToEmployeeId],
		   [ActiveFrom] = source.[ActiveFrom],
		   [ActiveTo] = source.[ActiveTo],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [ReportingMethodId] = Source.[ReportingMethodId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [EmployeeId], [ReportToEmployeeId], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId],[ReportingMethodId]) VALUES ([Id], [EmployeeId], [ReportToEmployeeId], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId],[ReportingMethodId]);

MERGE INTO [dbo].[State] AS Target 
USING ( VALUES 
 (NEWID(), @CompanyId, N'Andhra Pradesh', CAST(N'2019-05-07T09:50:17.440' AS DateTime),@UserId)
,(NEWID(), @CompanyId, N'Telengana', CAST(N'2019-05-07T10:31:35.093' AS DateTime),@UserId)
,(NEWID(), @CompanyId, N'Bihar', CAST(N'2019-05-06T12:50:59.933' AS DateTime),@UserId)
,(NEWID(), @CompanyId, N'Karnataka', CAST(N'2019-05-06T12:57:47.477' AS DateTime),@UserId)
,(NEWID(), @CompanyId, N'Tamilnadu', CAST(N'2019-05-06T12:56:45.820' AS DateTime),@UserId)
		
	)
AS Source([Id], [CompanyId], [StateName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [StateName] = Source.[StateName]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [CompanyId], [StateName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [StateName], [CreatedDateTime], [CreatedByUserId]);	  

MERGE INTO [dbo].[Region] AS Target 
USING ( VALUES 
	  (NEWID(), @CompanyId, N'London', (SELECT Id FROM Country WHERE CountryName LIKE '%England%' AND CompanyId = @CompanyId),  GetDate(), @UserId)
) 
AS Source ([Id], [CompanyId], [RegionName], [CountryId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId],
           [RegionName] = Source.[RegionName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CountryId] = Source.[CountryId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [CompanyId], [RegionName], [CountryId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [RegionName], [CountryId], [CreatedDateTime], [CreatedByUserId]);   

--MERGE INTO [dbo].[Branch] AS Target
--USING ( VALUES
--         (NEWID(),@CompanyId, N'Birmingham', (SELECT R.Id FROM Region R JOIN Country C ON C.Id = R.CountryId WHERE C.CompanyId = @CompanyId AND CountryName LIKE '%England%'), GetDate(), @UserId),
--		 (NEWID(),@CompanyId, N'Nottingham', (SELECT R.Id FROM Region R JOIN Country C ON C.Id = R.CountryId WHERE C.CompanyId = @CompanyId AND CountryName LIKE '%England%'), GetDate(), @UserId),
--		 (NEWID(),@CompanyId, N'Manchester', (SELECT R.Id FROM Region R JOIN Country C ON C.Id = R.CountryId WHERE C.CompanyId = @CompanyId AND CountryName LIKE '%England%'), GetDate(), @UserId)
--)
--AS Source ([Id], [CompanyId], [BranchName],[RegionId], [CreatedDateTime], [CreatedByUserId])
--ON Target.Id = Source.Id
--WHEN MATCHED THEN
--UPDATE SET [CompanyId] = Source.[CompanyId],
--           [BranchName] = Source.[BranchName],
--           [RegionId] = Source.[RegionId],
--           [CreatedDateTime] = Source.[CreatedDateTime],
--           [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN
--INSERT ([Id], [CompanyId], [BranchName],[RegionId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [BranchName],[RegionId], [CreatedDateTime], [CreatedByUserId]);

DECLARE @NewEntityId UNIQUEIDENTIFIER = NEWID()

INSERT INTO [Entity]([Id],[CompanyId],[EntityName],[IsGroup],[IsEntity],[IsCountry],[IsBranch],[CreatedDateTime],[CreatedByUserId])
SELECT @NewEntityId,@CompanyId,(SELECT CompanyName FROM Company WHERE Id = @CompanyId) + '_Group',1,0,0,0,GETDATE(),@UserId

DECLARE @EntityId UNIQUEIDENTIFIER = (SELECT Id FROM Entity WHERE CompanyId = @CompanyId AND IsBranch = 1 AND EntityName = (SELECT CompanyName FROM Company WHERE Id = @CompanyId))

UPDATE Entity SET ParentEntityId = @NewEntityId WHERE Id = @EntityId

INSERT INTO EntityBranch([Id],BranchId,EntityId,CreatedDateTime,CreatedByUserId)
SELECT NEWID(),@EntityId,@NewEntityId,GETDATE(),@UserId

DECLARE @Entity TABLE
(
    EntityId UNIQUEIDENTIFIER
)

DECLARE @InnerCountryId UNIQUEIDENTIFIER = (SELECT Id FROM Country 
                                            WHERE CompanyId = @CompanyId
                                                  AND CountryName = (SELECT CountryName FROM SYS_Country WHERE Id = (SELECT [CountryId] FROM Company WHERE Id = @CompanyId))
                                                  AND InActiveDateTime IS NULL)
          
IF(@InnerCountryId IS NULL)
BEGIN
    
   SET @InnerCountryId = (SELECT TOP (1) Id FROM Country WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)

END

 INSERT INTO @Entity(EntityId)
 EXEC [dbo].[USP_UpsertEntity] @EntityName = 'Birmingham',@TimeZoneId='c527b633-9fb6-4d9f-be87-5172dbe87d18',@IsBranch = 1,@OperationsPerformedBy = @UserId,@ParentEntityId = @NewEntityId,@CountryId = @InnerCountryId
 
 INSERT INTO @Entity(EntityId)
 EXEC [dbo].[USP_UpsertEntity] @EntityName = 'Nottingham',@TimeZoneId='c527b633-9fb6-4d9f-be87-5172dbe87d18',@IsBranch = 1,@OperationsPerformedBy = @UserId,@ParentEntityId = @NewEntityId,@CountryId = @InnerCountryId

 INSERT INTO @Entity(EntityId)
 EXEC [dbo].[USP_UpsertEntity] @EntityName = 'Manchester',@TimeZoneId='c527b633-9fb6-4d9f-be87-5172dbe87d18',@IsBranch = 1,@OperationsPerformedBy = @UserId,@ParentEntityId = @NewEntityId,@CountryId = @InnerCountryId

--INSERT INTO [dbo].[Entity](Id,EntityName,CreatedDateTime,CreatedByUserId,CompanyId,ParentEntityId)
--SELECT B.Id,B.BranchName,GETDATE(),@UserId,@CompanyId,@NewEntityId
--FROM Branch B
--WHERE B.CompanyId = @CompanyId AND CreatedByUserId = @UserId
--      AND Id NOT IN (SELECT Id FROM Entity WHERE companyId = @CompanyId)

--INSERT INTO [dbo].[EntityBranch]([Id],[EntityId],[BranchId],[CreatedByUserId],[CreatedDateTime])
--SELECT NEWID(),E.Id,E.Id,@UserId,GETDATE()
--FROM Entity E
--WHERE E.CompanyId = @CompanyId AND CreatedByUserId = @UserId

--INSERT INTO [dbo].[EntityBranch]([Id],[EntityId],[BranchId],[CreatedByUserId],[CreatedDateTime])
--SELECT NEWID(),@NewEntityId,B.Id,@UserId,GETDATE()
--FROM Branch B
--WHERE B.CompanyId = @CompanyId AND B.CreatedByUserId = @UserId

MERGE INTO [dbo].[EmployeeBranch] AS Target
USING ( VALUES
		 (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),
					(SELECT Id FROM [Branch] WHERE [BranchName] = 'Manchester' AND CompanyId = @CompanyId),
					 CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL,GetDate(), @UserId)
        ,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
					 (SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),
					 CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL,GetDate(), @UserId)
        ,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id  WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
					(SELECT Id FROM [Branch] WHERE [BranchName] = 'Nottingham' AND CompanyId = @CompanyId),
					CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL,GetDate(), @UserId)
        ,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id  WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
					(SELECT Id FROM [Branch] WHERE [BranchName] = 'Manchester' AND CompanyId = @CompanyId),
					CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL,GetDate(), @UserId)
		)
AS Source ([Id], [EmployeeId], [BranchId], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [EmployeeId] = Source.[EmployeeId],
		   [BranchId] = source.[BranchId],
		   [ActiveFrom] = source.[ActiveFrom],
		   [ActiveTo] = source.[ActiveTo],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [EmployeeId], [BranchId], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [EmployeeId], [BranchId], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]);

INSERT INTO [dbo].[EmployeeEntity]([Id],EmployeeId,EntityId,[CreatedByUserId],[CreatedDateTime])
SELECT NEWID(),(SELECT Id FROM Employee WHERE UserId = @UserId),@NewEntityId,@UserId,GETDATE()

INSERT INTO [dbo].[EmployeeEntity]([Id],EmployeeId,EntityId,[CreatedByUserId],[CreatedDateTime])
SELECT NEWID(),T.EmployeeId,T.BranchId,@UserId,GETDATE()
FROM (SELECT EB.EmployeeId,EB.BranchId
      FROM EmployeeBranch AS EB 
	  WHERE EmployeeId IN (SELECT Id FROM Employee 
	                       WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId))
	 ) T
LEFT JOIN [EmployeeEntity] EE ON EE.EmployeeId = T.EmployeeId AND EE.EntityId = T.BranchId
WHERE EE.EmployeeId IS NULL AND EE.EntityId IS NULL

INSERT INTO EmployeeEntityBranch(Id,EmployeeId,BranchId,CreatedByUserId,CreatedDateTime)
SELECT NEWID(),T.EmployeeId,T.BranchId,@UserId,GETDATE()
FROM  (SELECT EB.BranchId,EN.EmployeeId
       FROM EmployeeEntity EN INNER JOIN EntityBranch EB ON EN.EntityId = EB.EntityId
       WHERE EN.EmployeeId IN (SELECT Id FROM Employee 
	                           WHERE UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId)) 
			AND EN.InactiveDateTime IS NULL
       GROUP BY EB.BranchId,EN.EmployeeId
      ) T

MERGE INTO [dbo].[ShiftTiming] AS Target
USING ( VALUES
		 (NEWID(), @CompanyId, N'Shift timings 1', (SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId), CAST(N'2019-03-21T11:37:09.943' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,(NEWID(), @CompanyId, N'Shift timings 2', (SELECT B.Id FROM Branch B WHERE BranchName = 'Nottingham' AND B.CompanyId = @CompanyId), CAST(N'2019-03-21T03:52:17.723' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,(NEWID(), @CompanyId, N'Shift timings 3', (SELECT B.Id FROM Branch B WHERE BranchName = 'Manchester' AND B.CompanyId = @CompanyId), CAST(N'2019-03-21T03:52:17.723' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
)

AS Source ([Id], CompanyId, [ShiftName], BranchId, [CreatedDateTime] ,[CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET CompanyId = Source.CompanyId,
		   BranchId = source.BranchId,
		   [ShiftName] = Source.[ShiftName],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], CompanyId, [ShiftName] ,BranchId ,[CreatedDateTime] ,[CreatedByUserId]) 
VALUES ([Id], CompanyId, [ShiftName] ,BranchId ,[CreatedDateTime] ,[CreatedByUserId]);

MERGE INTO [dbo].[ShiftWeek] AS Target
USING ( VALUES
		 (NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 1%'),  N'Monday',   CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId,NULL, NULL, CAST(N'05:00:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 1%'),  N'Tuesday',  CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'03:45:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 1%'),  N'Wednesday',CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'03:45:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 1%'),  N'Thursday', CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'03:45:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 1%'),  N'Friday',   CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'03:45:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 1%'),  N'Saturday', CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'03:45:00' AS Time))
		-- 2nd branch																																																			   
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 2%'),  N'Monday',   CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId,NULL, NULL, CAST(N'04:30:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 2%'),  N'Tuesday',  CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'04:00:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 2%'),  N'Wednesday',CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'04:00:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 2%'),  N'Thursday', CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'04:00:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 2%'),  N'Friday',   CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'04:00:00' AS Time))
		-- 3rd branch																																																			   
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 3%'),  N'Monday',   CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId,NULL, NULL, CAST(N'04:30:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 3%'),  N'Tuesday',  CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'04:00:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 3%'),  N'Wednesday',CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'04:00:00' AS Time))
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 3%'),  N'Thursday', CAST(N'03:30:00' AS Time), CAST(N'12:30:00' AS Time) , CAST(N'2019-03-21T03:52:17.723' AS DateTime), @UserId,NULL, NULL, CAST(N'04:00:00' AS Time))
)

AS Source ([Id], ShiftTimingId ,[DayOfWeek] , [StartTime], [EndTime], [CreatedDateTime] ,[CreatedByUserId] , [UpdatedDateTime], [UpdatedByUserId], [DeadLine])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET ShiftTimingId = Source.ShiftTimingId,
		   [DayOfWeek] = Source.[DayOfWeek],
		   [StartTime] = Source.[StartTime],
		   [EndTime] = Source.[EndTime],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [UpdatedDateTime] = Source.[UpdatedDateTime],
           [UpdatedByUserId] = Source.[UpdatedByUserId],
           [DeadLine] = Source.[DeadLine]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], ShiftTimingId ,[DayOfWeek] , [StartTime], [EndTime], [CreatedDateTime] ,[CreatedByUserId] , [UpdatedDateTime], [UpdatedByUserId], [DeadLine]) 
VALUES ([Id], ShiftTimingId ,[DayOfWeek] , [StartTime], [EndTime], [CreatedDateTime] ,[CreatedByUserId] , [UpdatedDateTime], [UpdatedByUserId], [DeadLine]);

MERGE INTO [dbo].[EmployeeShift] AS Target
USING ( VALUES
		 (NEWID(),(SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 1%')
					,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),
					CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,GetDate(),@UserId)
		
		,(NEWID(), (SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 2%')
					,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
					CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,GetDate(),@UserId)
		
		,(NEWID(),(SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 3%')
					,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id  WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
					CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,GetDate(),@UserId)
		
		,(NEWID(),(SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 1%')
					,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id  WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 
					CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,GetDate(),@UserId)
		,(NEWID(),(SELECT Id FROM [ShiftTiming] WHERE CompanyId = @CompanyId AND [ShiftName] LIKE '%Shift timings 1%')
					,(SELECT E.Id FROM EMPLOYEE E WHERE E.UserId = @UserId), 
					CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,GetDate(),@UserId)
)

AS Source ([Id] ,[ShiftTimingId] ,[EmployeeId] ,[ActiveFrom] ,[ActiveTo] ,[CreatedDateTime] ,[CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [ShiftTimingId] = Source.[ShiftTimingId],
		   [EmployeeId] = source.[EmployeeId],
		   [ActiveFrom] = Source.[ActiveFrom],
		   [ActiveTo] = source.[ActiveTo],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id] ,[ShiftTimingId] ,[EmployeeId] ,[ActiveFrom] ,[ActiveTo] ,[CreatedDateTime] ,[CreatedByUserId]) VALUES ([Id] ,[ShiftTimingId] ,[EmployeeId] ,[ActiveFrom] ,[ActiveTo] ,[CreatedDateTime] ,[CreatedByUserId]);

IF NOT EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='FEC07283-AA98-41E1-B3D3-28CD6C6C5D97')
BEGIN
MERGE INTO [dbo].[Project] AS Target
USING ( VALUES
        (NEWID(), @CompanyId, N'IOT', @UserId, 0, NULL, GetDate(), @UserId),
		(NEWID(), @CompanyId, N'Rasberry PI', @UserId, 0, NULL, GetDate(), @UserId),
		(NEWID(), @CompanyId, N'Big Data', @UserId, 0, NULL, GetDate(), @UserId)
)
AS Source ([Id], [CompanyId], [ProjectName], [ProjectResponsiblePersonId], [IsArchived], [ArchivedDateTime], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [ProjectName] = Source.[ProjectName],
		   [ProjectResponsiblePersonId] = Source.[ProjectResponsiblePersonId],
		   --[IsArchived] = Source.[IsArchived],
		   --[ArchivedDateTime] = Source.[ArchivedDateTime],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [ProjectName], [ProjectResponsiblePersonId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [ProjectName], [ProjectResponsiblePersonId], [CreatedDateTime], [CreatedByUserId]);      

MERGE INTO [dbo].[UserProject] AS Target
USING ( VALUES
       (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project qa%' AND CompanyId = @CompanyId), GetDate(), @UserId),
	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project qa%' AND CompanyId = @CompanyId), GetDate(), @UserId),
	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project qa%' AND CompanyId = @CompanyId), GetDate(), @UserId),
	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project lead%' AND CompanyId = @CompanyId), GetDate(), @UserId),        
	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project lead%' AND CompanyId = @CompanyId), GetDate(), @UserId),        
	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data General%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project lead%' AND CompanyId = @CompanyId), GetDate(), @UserId),
	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project developer%' AND CompanyId = @CompanyId), GetDate(), @UserId),        
	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project developer%' AND CompanyId = @CompanyId), GetDate(), @UserId),        
	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI Sql%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project developer%' AND CompanyId = @CompanyId), GetDate(), @UserId),        

	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI Sql%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project developer %' AND CompanyId = @CompanyId), GetDate(), @UserId),
	   (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project developer %' AND CompanyId = @CompanyId), GetDate(), @UserId),
	   (NEWID(), @UserId, (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data General%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project manager%' AND CompanyId = @CompanyId), GetDate(), @UserId),        
	   (NEWID(), @UserId, (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project manager%' AND CompanyId = @CompanyId), GetDate(), @UserId),        
	   (NEWID(), @UserId, (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId), (SELECT Id FROM [EntityRole] WHERE EntityRoleName LIKE '%Project manager%' AND CompanyId = @CompanyId), GetDate(), @UserId)

)
AS Source ([Id], [UserId], [ProjectId], [GoalId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserId] = Source.[UserId],
           [ProjectId] = Source.[ProjectId],
           [GoalId] = Source.[GoalId],
           [EntityRoleId] = Source.[EntityRoleId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [UserId], [ProjectId], [GoalId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [UserId], [ProjectId], [GoalId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]);      

--MERGE INTO [dbo].[GoalStatus] AS Target 
--USING ( VALUES 
--			(NEWID() , N'Not needed',@CompanyId, GETDATE(),@UserId,NULL,1,NULL,NULL,NULL,NULL,NULL),
--			(NEWID() , N'Gave up',@CompanyId,   GETDATE(), @UserId,NULL,NULL,1,NULL,NULL,NULL,NULL),
--			(NEWID() , N'Completed',@CompanyId, GETDATE(), @UserId,NULL,NULL,NULL,1,NULL,NULL,NULL),
--			(NEWID() , N'Backlog',@CompanyId,   GETDATE(), @UserId,NULL,NULL,NULL,NULL,1,NULL,NULL),
--			(NEWID() , N'Active',@CompanyId,    GETDATE(), @UserId,NULL,NULL,NULL,NULL,NULL,1,NULL),
--			(NEWID() , N'Replan',@CompanyId,    GETDATE(), @UserId,NULL,NULL,NULL,NULL,NULL,NULL,1),
--			(NEWID() , N'Parked',@CompanyId,    GETDATE(), @UserId,1,NULL,NULL,NULL,NULL,NULL,NULL)
--) 
--AS Source ([Id], [GoalStatusName],[CompanyId], [CreatedDateTime], [CreatedByUserId],[IsParked],[IsNotNeeded],[IsGaveUp],[IsCompleted],[IsBackLog],[IsActive],[IsReplan]) 
--ON Target.Id = Source.Id  
--WHEN MATCHED THEN 
--UPDATE SET [GoalStatusName] = Source.[GoalStatusName],
--	       [CompanyId] = Source.[CompanyId],
--	       [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId],
--		   [IsParked] = Source.[IsParked],
--		   [IsNotNeeded]= Source.[IsNotNeeded],
--		   [IsGaveUp]= Source.[IsGaveUp],
--		   [IsCompleted]= Source.[IsCompleted],
--		   [IsBackLog]= Source.[IsBackLog],
--		   [IsActive]= Source.[IsActive],
--		   [IsReplan] = Source.[IsReplan]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [GoalStatusName],[CompanyId], [CreatedDateTime], [CreatedByUserId],[IsParked],[IsNotNeeded],[IsGaveUp],[IsCompleted],[IsBackLog],[IsActive],[IsReplan]) VALUES ([Id], [GoalStatusName],[CompanyId], [CreatedDateTime], [CreatedByUserId], [IsParked],[IsNotNeeded],[IsGaveUp],[IsCompleted],[IsBackLog],[IsActive],[IsReplan]);  

MERGE INTO [dbo].[Goal] AS Target
USING ( VALUES
        (NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'IOT General', N'IOT General',NULL, DATEADD(DAY,-3,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-1'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'Kanban'), N'IOT Sql', N'IOT Sql', NULL,  DATEADD(DAY,-4,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId, '7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-2'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'Kanban Bugs'), N'IOT Bugs', N'IOT Bugs',NULL,  DATEADD(DAY,2,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId, '7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-3'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'Backlog',N'Backlog', NULL,  NULL, NULL,   NULL, GetDate(), @UserId, 'F6F118EA-7023-45F1-BCF6-CE6DB1CEE5C3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'G-4'),

		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'Rasberry PI General',N'Rasberry PI General', NULL, DATEADD(DAY,-3,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-5'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'Kanban'), N'Rasberry PI Sql',  N'Rasberry PI Sql', NULL,  DATEADD(DAY,-4,GetDate()), NULL, (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId, '7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-6'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'Kanban Bugs'), N'Rasberry PI Bugs',N'Rasberry PI Bugs', NULL,  DATEADD(DAY,3,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(),@UserId, '7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-7'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'Kanban Bugs'), N'Scenarios TestData Bugs List',N'Scenarios TestData Bugs List', NULL,  DATEADD(DAY,3,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(),@UserId, '7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-7'),
	    (NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'Backlog', N'Backlog', NULL,  NULL, NULL,  NULL, GetDate(), @UserId, 'F6F118EA-7023-45F1-BCF6-CE6DB1CEE5C3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'G-4'),

		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'Big Data General', N'Big Data General',NULL,  DATEADD(DAY,-2,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-8'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'Kanban'), N'Big Data Sql',N'Big Data Sql',  NULL,  DATEADD(DAY,-4,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-9'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'Kanban'), N'Unplanned work', N'Unplanned work', NULL,  DATEADD(DAY,-4,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-9'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'Test Scenarios', 'Test Scenarios',NULL,  DATEADD(DAY,-4,GetDate()), NULL,   (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-9'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'UI changes', 'Test Scenarios', NULL,  DATEADD(DAY,-4,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-9'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'Reports Issues','Test Scenarios', NULL,  DATEADD(DAY,-4,GetDate()), NULL, (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-9'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'Widgets modifications','Test Scenarios',  NULL,  DATEADD(DAY,-4,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-9'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'Making web requests','Test Scenarios', NULL,  DATEADD(DAY,-4,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId,'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-10'),		
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'Kanban Bugs'), N'Big Data Bugs',N'Big Data Bugs',  NULL,  DATEADD(DAY,1,GetDate()), NULL,  (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId, '7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL,'G-11'),
		(NEWID(), (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM BoardType WHERE CompanyId = @CompanyId AND BoardTypeName = 'SuperAgile'), N'Backlog', N'Backlog', NULL,  NULL, NULL, NULL, GetDate(), @UserId, 'F6F118EA-7023-45F1-BCF6-CE6DB1CEE5C3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,'G-4')

)

AS Source ([Id], [ProjectId], [BoardTypeId], [GoalName],[GoalShortName], [GoalBudget], [OnboardProcessDate], [IsLocked],  [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[GoalStatusId], [ConfigurationId], 
[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsParked], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
 [Version], [ParkedDateTime],[GoalUniqueName]) 
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [ProjectId] = Source.[ProjectId],
		   [BoardTypeId] = Source.[BoardTypeId],
		   [GoalName] = Source.[GoalName],
		   [GoalShortName] = Source.[GoalShortName],
		   [GoalBudget] = Source.[GoalBudget],
		   [OnboardProcessDate] = Source.[OnboardProcessDate],
		   [IsLocked] = Source.[IsLocked],
		   [GoalResponsibleUserId] = Source.[GoalResponsibleUserId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [GoalStatusId] = Source.[GoalStatusId],
		   [ConfigurationId] = source.[ConfigurationId],
		   [ConsiderEstimatedHoursId] = Source.[ConsiderEstimatedHoursId],
		   [GoalStatusColor] = Source.[GoalStatusColor],
		   [IsProductiveBoard] = Source.[IsProductiveBoard],
		   [IsApproved] = Source.[IsApproved],
		   [ConsiderEstimatedHours] = Source.[ConsiderEstimatedHours],
		   [IsToBeTracked] = Source.[IsToBeTracked],
		   [BoardTypeApiId] = Source.[BoardTypeApiId],
		   GoalUniqueName = Source.GoalUniqueName,
		   [Version] = Source.[Version],
		   [ParkedDateTime] = Source.[ParkedDateTime]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [ProjectId], [BoardTypeId], [GoalName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalShortName], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[GoalStatusId], [ConfigurationId], 
[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
 [Version], [ParkedDateTime],[GoalUniqueName]) VALUES ([Id], [ProjectId], [BoardTypeId], [GoalName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalShortName], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId], [GoalStatusId], [ConfigurationId], 
[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
 [Version], [ParkedDateTime],[GoalUniqueName]);     
 
MERGE INTO [dbo].[GoalWorkFlow] AS Target
USING ( VALUES
        (NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'IOT General' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'SuperAgile'),GETDATE(),@UserId),
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'IOT Sql' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban'),GETDATE(),@UserId),		 
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'IOT Bugs' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban Bugs'),GETDATE(),@UserId),
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Rasberry PI General' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'SuperAgile'),GETDATE(),@UserId) ,
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE  'Test Scenarios' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'SuperAgile'),GETDATE(),@UserId) ,
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Rasberry PI Sql' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban'),GETDATE(),@UserId),      
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Unplanned work' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban'),GETDATE(),@UserId),      
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Rasberry PI Bugs' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban Bugs'),GETDATE(),@UserId), 
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Scenarios TestData Bugs List' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban Bugs'),GETDATE(),@UserId), 
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Big Data General' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'SuperAgile'),GETDATE(),@UserId),   
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'UI changes' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'SuperAgile'),GETDATE(),@UserId),   
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Reports Issues' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'SuperAgile'),GETDATE(),@UserId),   
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Widgets modifications' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'SuperAgile'),GETDATE(),@UserId),   
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Making web requests' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'SuperAgile'),GETDATE(),@UserId),   
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Big Data Sql' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban'),GETDATE(),@UserId),			 
		(NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName LIKE N'Big Data Bugs' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban Bugs'),GETDATE(),@UserId)	 
)
AS Source ([Id], [GoalId],[WorkFlowId],[CreatedDateTime],[CreatedByUserId]) 
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [GoalId] = source.[GoalId],
		   [WorkFlowId] = source.[WorkFlowId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [GoalId],[WorkFlowId],[CreatedDateTime],[CreatedByUserId]) VALUES ([Id], [GoalId],[WorkFlowId],[CreatedDateTime],[CreatedByUserId]);     
 
MERGE INTO [dbo].[GoalHistory] AS Target
USING ( VALUES
        (NEWID(), NULL, N'IOT General',N'GoalAdded',N'GoalAdded',(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId),@UserId, DATEADD(DAY,-1,GetDate())),
        (NEWID(), NULL, N'IOT Sql',N'GoalAdded',N'GoalAdded',(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id  WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId),@UserId, DATEADD(DAY,-1,GetDate())),
        (NEWID(), NULL, N'IOT Bugs',N'GoalAdded',N'GoalAdded',(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Bugs%' AND CompanyId = @CompanyId),@UserId, DATEADD(DAY,-2,GetDate())),
        (NEWID(), NULL, N'Rasberry PI General',N'GoalAdded',N'GoalAdded',(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id  WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId),@UserId, DATEADD(DAY,-2,GetDate())),
        (NEWID(), NULL, N'Rasberry PI Sql',N'GoalAdded',N'GoalAdded',(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id  WHERE GoalName LIKE '%Rasberry PI Sql%' AND CompanyId = @CompanyId),@UserId, DATEADD(DAY,-1,GetDate())),
        (NEWID(), NULL, N'Rasberry PI Bugs',N'GoalAdded',N'GoalAdded',(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI Bugs%' AND CompanyId = @CompanyId),@UserId, DATEADD(DAY,-1,GetDate())),
        (NEWID(), NULL, N'Big Data General',N'GoalAdded',N'GoalAdded',(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data General%' AND CompanyId = @CompanyId),@UserId, DATEADD(DAY,-2,GetDate())),
        (NEWID(), NULL, N'Big Data Sql',N'GoalAdded',N'GoalAdded',(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId),@UserId, DATEADD(DAY,-1,GetDate())),
        (NEWID(), NULL, N'Big Data Bugs',N'GoalAdded',N'GoalAdded',(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data Bugs%' AND CompanyId = @CompanyId),@UserId, DATEADD(DAY,-1,GetDate()))
)
AS Source ([Id],[OldValue], [NewValue],[FieldName],[Description],[GoalId], [CreatedByUserId],[CreatedDateTime]) 
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [OldValue] = Source.[OldValue],
           [NewValue] = Source.[NewValue],
           [FieldName] = Source.[FieldName],
           [Description] = Source.[Description],
           [GoalId] = Source.[GoalId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id],[OldValue], [NewValue],[FieldName],[Description],[GoalId],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id],[OldValue], [NewValue],[FieldName],[Description],[GoalId],[CreatedDateTime], [CreatedByUserId]);  

MERGE INTO [dbo].[GoalReplan] AS Target
USING ( VALUES
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,1),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,2),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,1),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,2),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,3),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,1),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,2),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,3),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,4),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,5),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,1),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,2),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,3),
        (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), (select top 1 Id from GoalReplanType WHERE IsUnplannedLeaves = 1 AND CompanyId = @CompanyId),'',GETDATE(),@UserId,4)
       )
AS Source ([Id], [GoalId],[GoalReplanTypeId],[Reason],[CreatedDateTime],[CreatedByUserId],GoalReplanCount)
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [GoalId] = source.[GoalId],
		   [GoalReplanTypeId] = source.[GoalReplanTypeId],
		   [Reason] = source.[Reason],
		   [GoalReplanCount] = source.[GoalReplanCount],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [GoalId],[GoalReplanTypeId],[Reason],[CreatedDateTime],[CreatedByUserId],GoalReplanCount) VALUES([Id], [GoalId],[GoalReplanTypeId],[Reason],[CreatedDateTime],[CreatedByUserId],GoalReplanCount);     

MERGE INTO [dbo].[UserStory] AS Target
USING ( VALUES
		 (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId), N'Functions for Iot Project', CAST(2.00 AS Decimal(18, 2)), GetDate(), @UserId, NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-1',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId)),
		 (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId), N'Stored Procedures for Iot Project', CAST(6.00 AS Decimal(18, 2)), DateAdd(day,-1, GetDate()), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Completed'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-4',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId)),
		
		 (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), N'Create Sample App for finding room temp using IOT',  CAST(6.00 AS Decimal(18, 2)), DateAdd(day,-1, GetDate()),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Dev Inprogress'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-2',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId)),
		 (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), N'Create Sample Iot Project', CAST(1.00 AS Decimal(18, 2)), DateAdd(day,1, GetDate()), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Dev Completed'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-3',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId)),
		
		 (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data General%' AND CompanyId = @CompanyId), N'Create Sample Big Data project', CAST(1.00 AS Decimal(18, 2)), DateAdd(day,-1, GetDate()), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Analysis Completed'), GetDate(), @UserId, DATEADD(DAY,0,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-5',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Big Data General%' AND CompanyId = @CompanyId)),
		 
		 (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId), N'Stored procs for Big Data', CAST(1.00 AS Decimal(18, 2)), GetDate(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'), GetDate(), @UserId, DATEADD(DAY,-3,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-6',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId)),
		 (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId), N'Functions for Big Data', CAST(1.00 AS Decimal(18, 2)),  DateAdd(day,3, GetDate()), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), NULL, 27,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Not Started'), GetDate(), @UserId, DATEADD(DAY,0,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-8',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId)),		 
		 
		 (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId), N'Create Sample Rassberry Pi Project', CAST(4.00 AS Decimal(18, 2)), DateAdd(day,1, GetDate()), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Deployed'), GetDate(), @UserId, DATEADD(DAY,-4,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-9',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId)),
		 (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI Sql%' AND CompanyId = @CompanyId), N'Stored Procedures for Rassberry Pi', CAST(1.00 AS Decimal(18, 2)),DateAdd(day,2, GetDate()), @UserId, NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'), GetDate(), @UserId, DATEADD(DAY,2,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-10',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI Sql%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Rasberry PI Sql%' AND CompanyId = @CompanyId))		 
		
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'we recommend creating database roles, adding the database users to the roles,',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-40',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'A user that has access to a database c',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-37',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'When people gain access to a database they are identified as a database user.',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-32',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'Within each schema there are database objects such as tables, views, and stored procedures.',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-25',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'and then grant access permission to the roles. Granting permissions to roles',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-41',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'. Files can be grouped into filegroups.',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-29',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'A computer can have one or more',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-21',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'an be given permission to access the objects in the database.',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-38',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'than one instance of SQL Server installed.',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-22',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'Some objects such as certificates and asymmetric keys are contained within the database,',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-26',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'When people gain access to an instance of SQL Server they are identified as a login.',5,GETDATE(),@UserId,Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-31',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'instead of users makes it easier to keep permissions consistent and',5,GETDATE(),@UserId,Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-42',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'Each instance of SQL Server can contain one or many databases.',5,GETDATE(),@UserId,Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-23',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'see CREATE USER (Transact-SQL).',5,GETDATE(),@UserId,Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-36',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'Though permissions can be granted to individual users,',5,GETDATE(),@UserId,Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-39',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'a database user can be created that is not based on a login.',5,GETDATE(),@UserId,Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-34',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'SQL Server databases are stored in the file system in files',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-28',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'For more information about files and filegroups, see Database Files and Filegroups.',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-30',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'but are not contained within a schema. For more information about creating tables, see Tables.',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-27',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'A database user can be based on a login. If contained databases are enabled,',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-33',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'Test 1',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'BUG-1',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'For more information about users,',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-35',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'Within a database, there are one or many object ownership groups called schemas.',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-24',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'Change operating modes for SQL Server Database Mirroring',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-44',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),'Steps to Apply a Service Pack or Patch to Mirrored SQL Server Databases',5,GETDATE(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),Null,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),GETDATE(),@UserId,GETDATE(),null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-58',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Test Scenarios' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Test Scenarios%' AND CompanyId = @CompanyId))
		
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Change SQL Server Database Mirroring from Manual to Automatic Failover',NULL,DATEADD(DAY,1,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-45',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'How to add a database file to a mirrored SQL Server database',NULL,DATEADD(DAY,1,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'New'),GETDATE(),@UserId,NULL,null,(SELECT Id FROM BugPriority where ishigh = 1 AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-55',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'SQL Server Database Mirroring Performance Monitoring',NULL,DATEADD(DAY,1,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'New'),GETDATE(),@UserId,NULL,null,(SELECT Id FROM BugPriority where iscritical = 1 AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-52',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Move Database Files for a SQL Server Mirrored Database Without Impacting Database Mirroring',5,DATEADD(DAY,1,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'New'),GETDATE(),@UserId,NULL,null,(SELECT Id FROM BugPriority where ishigh = 1 AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-57',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'How to Remove SQL Server witness server from an existing Database Mirroring Configuration',5,DATEADD(DAY,1,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)	,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'New'),GETDATE(),@UserId,NULL,null,(SELECT Id FROM BugPriority where IsMedium = 1 AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-47',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Setup SQL Server 2008 R2 Database Mirroring with Automatic Failover Across the Internet',5,DATEADD(DAY,1,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,(SELECT Id FROM BugPriority where islow = 1 AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-48',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Configure SQL Server Database Mirroring Using SSMS',5,DATEADD(DAY,1,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-46',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'SQL Server Database Mirroring Inventory and Monitoring Scripts',3,DATEADD(DAY,-2,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-51',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Monitoring SQL Server Database Mirroring with Email Alerts',5,DATEADD(DAY,-2,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-50',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Adjusting the automatic failover time for SQL Server Database Mirroring',5,DATEADD(DAY,-2,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-43',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'How to move database files of a Mirrored SQL Server Database',1,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)	,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-56',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Connection Strings',0.5,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-49',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'SQL Server Database Mirroring Report',4,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-53',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Planning',5,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-54',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'see CREATE USER (Transact-SQL).',3,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-14',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
		
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'Within each schema there are database objects such as tables, views, and stored procedures.',3,DATEADD(DAY,-7,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-4',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'. Files can be grouped into filegroups.',5,DATEADD(DAY,-6,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-8',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'Some objects such as certificates and asymmetric keys are contained within the database,',5,DATEADD(DAY,-7,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-5',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'and then grant access permission to the roles. Granting permissions to roles',5,DATEADD(DAY,-8,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-19',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'Each instance of SQL Server can contain one or many databases.',5,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-2',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'For more information about files and filegroups, see Database Files and Filegroups.',5,DATEADD(DAY,-5,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Not Started'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-9',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'When people gain access to an instance of SQL Server they are identified as a login.',5,DATEADD(DAY,-1,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Not Started'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-10',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'instead of users makes it easier to keep permissions consistent and',5,DATEADD(DAY,-1,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-20',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'but are not contained within a schema. For more information about creating tables, see Tables.',5,DATEADD(DAY,-6,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)	,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-6',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'When people gain access to a database they are identified as a database user.',5,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)	,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-11',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'A computer can have one or more than one instance of SQL Server installed.',5,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)	,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Not Started'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-1',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'a database user can be created that is not based on a login. For more information about users,',5,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)	,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Not Started'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-13',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'Though permissions can be granted to individual users,',6,DATEADD(DAY,-2,GETDATE()),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)	,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-17',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'A database user can be based on a login. If contained databases are enabled,',1,DATEADD(DAY,-5,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-12',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'A user that has access to a database c',2,DATEADD(DAY,-1,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-15',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'Within a database, there are one or many object ownership groups called schemas.',4,DATEADD(DAY,-4,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-3',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'SQL Server databases are stored in the file system in files',6,DATEADD(DAY,-3,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-7',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),'an be given permission to access the objects in the database.',8,DATEADD(DAY,-2,GETDATE()),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),Null,NULL,'WI-16',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE 'Unplanned work' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Unplanned work%' AND CompanyId = @CompanyId))
		
		 ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId), N'Need to change Monthly productivity to Employee Index', CAST(4.00 AS Decimal(18, 2)), DateAdd(day,1, GetDate()),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Deployed'), GetDate(), @UserId, DATEADD(DAY,-4,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-9',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId))
		 ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId), N'More Bugs Goals list-- Need to add test data', CAST(4.00 AS Decimal(18, 2)), DateAdd(day,1, GetDate()),@UserId, NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Deployed'), GetDate(), @UserId, DATEADD(DAY,-4,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-9',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId))
		 ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId), N'Need to add test data for  daily userstoires', CAST(4.00 AS Decimal(18, 2)), DateAdd(day,1, GetDate()),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Deployed'), GetDate(), @UserId, DATEADD(DAY,-4,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-9',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId))
		 ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId), N'Need add test data for Complience', CAST(4.00 AS Decimal(18, 2)), DateAdd(day,1, GetDate()),@UserId, NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Deployed'), GetDate(), @UserId, DATEADD(DAY,-4,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-9',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId))
		 ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId), N'deployed vs bounced back userstoires', CAST(4.00 AS Decimal(18, 2)), DateAdd(day,1, GetDate()),@UserId, NULL, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Deployed'), GetDate(), @UserId, DATEADD(DAY,-4,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-9',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId))
        
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Setup SQL Server 2008 R2 Database with project monitoring',5,GETDATE(),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-48',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Setup SQL Server 2008 R2 And testdata',5,GETDATE(),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-48',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Setup SQL Server 2008 R2 Database with project and perfomance issues',5,GETDATE(),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-48',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),'Setup SQL Server 2008 R2 Database with project monitoring and create indexes for all tables',5,GETDATE(),@UserId,NULL,null,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress'),GETDATE(),@UserId,NULL,null,null,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId),Null,NULL,'WI-48',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Scenarios TestData Bugs List%' AND CompanyId = @CompanyId))


		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'Add a new field to the model.',6,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-1',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'Responding to change over following a plan.',6,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-9',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'Working software over comprehensive documentation.',11,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-7',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'Customer collaboration over contract negotiation.',12,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-8',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'Verifies the database is in sync with the model classes it was generated from',13,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-5',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'When EF Code First is used to automatically create a database',7,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-3',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'Migrate the new field to the database.',10,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-2',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'Agility in Agile Software Development focuses on the culture',14,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-10',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'Individuals and interactions over processes and tools.',5,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-6',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),'Adds a table to the database to track the schema of the database.',6,DATEADD(MONTH,-1,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-4',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Making web requests%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Making web requests%' AND CompanyId = @CompanyId))
		 
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'It fosters shared responsibility and accountability',7,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-12',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'Create a data source that generates a sequence of data elements asynchronously.',9,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-20',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'Collaboration facilitates combining different perspectives',8,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-17',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'that in in turn enable the team align to the requirements',7,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-16',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'timely in implementation defect fixes and accommodating changes',4,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-18',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'Facilitates effective communication and continuous collaboration',6,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-13',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'Progress is constant, sustainable, and predictable emphasizing transparency',11,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-19',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'Frequent and continuous deliveries ensure quick feedback',6,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-15',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'whole team with multi-discipline cross-functional teams that are empowered and selforganizing',5,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-11',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),'The whole-team approach avoids delays and wait times',3,DATEADD(MONTH,-2,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-14',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%UI changes%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%UI changes%' AND CompanyId = @CompanyId))


		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),'dotnet run automatically performs dotnet restore if your environment is missing dependencies.',7,DATEADD(MONTH,-4,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-35',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Widgets modifications%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),'It also performs dotnet build if your application needs to be rebuilt. After your initial setup',9,DATEADD(MONTH,-4,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-36',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Widgets modifications%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),'install a development certificate and run the NuGet package manager to restore missing dependencies.',5,DATEADD(MONTH,-4,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-33',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Widgets modifications%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),'This creates the starter files for a basic "Hello World" application.',8,DATEADD(MONTH,-4,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-30',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Widgets modifications%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),'As this is a new project, none of the dependencies are in place',7,DATEADD(MONTH,-4,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-31',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Widgets modifications%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),'so the first run will download the .NET Core framework',6,DATEADD(MONTH,-4,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-32',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Widgets modifications%' AND CompanyId = @CompanyId))
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),'you will only need to run dotnet restore or dotnet build when it makes sense for your project.',5,DATEADD(MONTH,-4,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-37',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Widgets modifications%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),'type dotnet run (see note) at the command prompt to run your application.',4,DATEADD(MONTH,-4,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-34',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Widgets modifications%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Widgets modifications%' AND CompanyId = @CompanyId))
      
		 ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),'Use pattern matching expressions to implement behavior based on types and property values.',16,DATEADD(MONTH,-3,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-24',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Reports Issues%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),'Open a command prompt and create a new directory for your application.',9,DATEADD(MONTH,-3,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-27',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Reports Issues%' AND CompanyId = @CompanyId) )
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),'Recognize when the new interface and data source are preferred to earlier synchronous data sequences.',5,DATEADD(MONTH,-3,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-22',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Reports Issues%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),'Recognize situations where pattern matching should be used.',4,DATEADD(MONTH,-3,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-23',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Reports Issues%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),'Consume that data source asynchronously.',10,DATEADD(MONTH,-3,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-21',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Reports Issues%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),'The first step is to create a new application.',16,DATEADD(MONTH,-3,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-26',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Reports Issues%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),'Type the command dotnet new console at the command prompt.',5,DATEADD(MONTH,-3,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-29',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Reports Issues%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),'Make that the current directory.',9,DATEADD(MONTH,-3,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-28',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Reports Issues%' AND CompanyId = @CompanyId))
         ,(NEWID(),(SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),'Combine pattern matching with other techniques to create complete algorithms.',7,DATEADD(MONTH,-3,GETDATE()),@UserId,NULL,NULL,(SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'QA Approved'),  GETDATE(),@UserId,NULL,NULL,NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,'WI-25',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Reports Issues%'   AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%Reports Issues%' AND CompanyId = @CompanyId))
         
        
		 ----------------------
		,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), N'SQL abstraction leaks like a sieve filled with superfluid helium. ',  CAST(6.00 AS Decimal(18, 2)), DateAdd(day,-1, GetDate()),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Blocked'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-95',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId)),
         (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), N'This is because the thing they are trying to abstract is way too complex to do it efficiently.',  CAST(6.00 AS Decimal(18, 2)), DateAdd(day,-1, GetDate()),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Blocked'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-90',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId)),
         (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), N'The possible operations on sets and the ',  CAST(6.00 AS Decimal(18, 2)), DateAdd(day,-1, GetDate()),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Blocked'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-91',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId)),
         (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), N'intermediate results of these operations are so numerious  ',  CAST(6.00 AS Decimal(18, 2)), DateAdd(day,-1, GetDate()),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Blocked'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-92',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId)),
         (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), N'intermediate results of these operations are so numerious  ',  CAST(6.00 AS Decimal(18, 2)), DateAdd(day,-1, GetDate()),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Blocked'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-92',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId)),
         (NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), N'multifarious that with current level of technology ',  CAST(6.00 AS Decimal(18, 2)), DateAdd(day,-1, GetDate()),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 27, (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Dev Inprogress'), GetDate(), @UserId, DATEADD(DAY,-1,GETDATE()), NULL, NULL,(SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Work item%' AND CompanyId = @CompanyId),NULL,NULL,N'WI-93',(SELECT G.ProjectId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId),(SELECT GF.WorkflowId FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id JOIN GoalWorkFlow GF ON GF.GoalId = G.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId))

)
AS Source ([Id], [GoalId], [UserStoryName], [EstimatedTime], [DeadLineDate], [OwnerUserId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime],[UserStoryUniqueName],[ProjectId],[WorkFlowId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [GoalId] = Source.[GoalId],
		   [UserStoryName] = Source.[UserStoryName],
		   [EstimatedTime] = Source.[EstimatedTime],
		   [OwnerUserId] = Source.[OwnerUserId],
		   [DependencyUserId] = Source.[DependencyUserId],
		   [Order] = Source.[Order],
		   [UserStoryStatusId] = Source.[UserStoryStatusId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [ActualDeadLineDate] = source.[ActualDeadLineDate],
		   [ArchivedDateTime] = Source.[ArchivedDateTime],
           [BugPriorityId] = Source.[BugPriorityId],
           [UserStoryTypeId] = Source.[UserStoryTypeId],
           [ParkedDateTime] = Source.[ParkedDateTime],
		   [UserStoryUniqueName] = Source.[UserStoryUniqueName],
		   [ProjectId] = Source.[ProjectId],
		   [WorkFlowId] = Source.[WorkFlowId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [GoalId], [UserStoryName], [EstimatedTime], [DeadLineDate], [OwnerUserId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime],[UserStoryUniqueName],[ProjectId],[WorkFlowId]) VALUES ([Id], [GoalId], [UserStoryName], [EstimatedTime], [DeadLineDate], [OwnerUserId], [DependencyUserId], [Order], [UserStoryStatusId], 
[CreatedDateTime], [CreatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime],[UserStoryUniqueName],[ProjectId],[WorkFlowId]);         

INSERT INTO UserStoryWorkflowStatusTransition(Id,UserStoryId,CompanyId,WorkflowEligibleStatusTransitionId,TransitionDateTime,CreatedDateTime,CreatedByUserId)
SELECT NEWID(),US.Id,P.CompanyId,Z.WorkflowEligibleStatusTransitionId,GETDATE(),GETDATE(),US.OwnerUserId FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND GoalName ='Test Scenarios'
                             INNER JOIN Project P ON P.Id = G.ProjectId AND CompanyId =@CompanyId
                            INNER JOIN GoalWorkFlow GW ON GW.GoalId = G.Id
                            CROSS JOIN (SELECT Id WorkflowEligibleStatusTransitionId FROM WorkflowEligibleStatusTransition 
							      WHERE WorkflowId = (SELECT GW.WorkflowId FROM Goal G INNER JOIN GoalWorkFlow GW ON GW.GoalId = G.Id INNER JOIN Project P ON P.Id = G.ProjectId AND GoalName = 'Test Scenarios' AND CompanyId = @CompanyId
							 WHERE GoalName ='Test Scenarios')
							   AND ToWorkflowUserStoryStatusId  IN 
							 (SELECT Id FROM UserStoryStatus WHERE [Status]  IN ('QA Approved') AND CompanyId = @CompanyId)
							 AND FromWorkflowUserStoryStatusId  IN 
							 (SELECT Id FROM UserStoryStatus WHERE [Status]  IN ('Deployed') AND CompanyId = @CompanyId))Z  

INSERT INTO UserStoryWorkflowStatusTransition(Id,UserStoryId,CompanyId,WorkflowEligibleStatusTransitionId,TransitionDateTime,CreatedDateTime,CreatedByUserId)
SELECT NEWID(),US.Id,P.CompanyId,Z.WorkflowEligibleStatusTransitionId,US.DeadLineDate,US.DeadLineDate,US.OwnerUserId FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND GoalName IN ('UI changes','Reports Issues','Widgets modifications','Making web requests')
                             INNER JOIN Project P ON P.Id = G.ProjectId AND CompanyId =@CompanyId
                            INNER JOIN GoalWorkFlow GW ON GW.GoalId = G.Id
                            CROSS JOIN (SELECT Id WorkflowEligibleStatusTransitionId FROM WorkflowEligibleStatusTransition 
							      WHERE WorkflowId IN (SELECT GW.WorkflowId FROM Goal G INNER JOIN GoalWorkFlow GW ON GW.GoalId = G.Id INNER JOIN Project P ON P.Id = G.ProjectId  AND CompanyId = @CompanyId
							 WHERE GoalName IN ('UI changes','Reports Issues','Widgets modifications','Making web requests')
							   AND ToWorkflowUserStoryStatusId  IN 
							 (SELECT Id FROM UserStoryStatus WHERE [Status]  IN ('QA Approved') AND CompanyId = @CompanyId)
							 AND FromWorkflowUserStoryStatusId  IN 
							 (SELECT Id FROM UserStoryStatus WHERE [Status]  IN ('Deployed') AND CompanyId = @CompanyId)))Z    

INSERT INTO [dbo].[UserStoryHistory] ([Id],[OldValue], [NewValue],[FieldName],[Description],[UserStoryId],[CreatedDateTime], [CreatedByUserId])
SELECT NEWID(),NULL,NULL,N'UserStory',N'UserStoryAdded',US.Id,DATEADD(MINUTE,-6,GetDate()),@UserId FROM [UserStory] US JOIN [Goal] G ON G.Id = US.GoalId JOIN [Project] P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId

UPDATE UserStory SET ParentUserStoryId = (SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = N'Create Sample Iot Project' AND GoalName LIKE '%IOT General%' AND P.CompanyId = @CompanyId) WHERE UserStoryTypeId = (SELECT Id FROM UserStoryType WHERE UserStoryTypeName LIKE '%Bug%' AND CompanyId = @CompanyId) AND UserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Inprogress' )

MERGE INTO [dbo].[UserStoryHistory] AS Target
USING ( VALUES
        (NEWID(), N'Not Started', N'Analysis Completed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Create Sample App for finding room temp using IOT%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-5,GetDate())),
        (NEWID(), N'Analysis Completed', N'Dev Inprogress',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id  WHERE UserStoryName LIKE '%Create Sample App for finding room temp using IOT%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-3,GetDate())),
        (NEWID(), N'Not Started', N'Analysis Completed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Create Sample Iot Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-5,GetDate())),
        (NEWID(), N'Analysis Completed', N'Dev Inprogress',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id  WHERE UserStoryName LIKE '%Create Sample Iot Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-3,GetDate())),
        (NEWID(), N'Dev Inprogress', N'Dev Completed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Create Sample Iot Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-1,GetDate())),
        
        (NEWID(), N'Not Started', N'Inprogress',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id  WHERE UserStoryName LIKE '%Functions for Iot Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-5,GetDate())),
        (NEWID(), N'Not Started', N'Inprogress',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id  WHERE UserStoryName LIKE '%Stored Procedures for Iot Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-5,GetDate())),
        (NEWID(), N'Inprogress', N'Completed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id  WHERE UserStoryName LIKE '%Stored Procedures for Iot Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-3,GetDate())),
        (NEWID(), N'Not Started', N'Inprogress',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id  WHERE UserStoryName LIKE '%Stored procs for Big Data%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-5,GetDate())),
        (NEWID(), N'Not Started', N'Analysis Completed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id  WHERE UserStoryName LIKE '%Create Sample Big Data project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-3,GetDate())),
        
        --(NEWID(), N'Not Started', N'Analysis Completed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Sample file for finding numbers using Big Data%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-10,GetDate())),
        --(NEWID(), N'Analysis Completed', N'Dev Inprogress',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Sample file for finding numbers using Big Data%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-8,GetDate())),
        --(NEWID(), N'Dev Inprogress', N'Dev Completed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Sample file for finding numbers using Big Data%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-6,GetDate())),
        --(NEWID(), N'Dev Completed', N'Deployed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Sample file for finding numbers using Big Data%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-4,GetDate())),
        --(NEWID(), N'Deployed', N'Qaapproved',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Sample file for finding numbers using Big Data%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-2,GetDate())),
        
        (NEWID(), N'Not Started', N'Analysis Completed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Create Sample Rassberry Pi Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-10,GetDate())),
        (NEWID(), N'Analysis Completed', N'Dev Inprogress',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Create Sample Rassberry Pi Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-7,GetDate())),
        (NEWID(), N'Dev Inprogress', N'Dev Completed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Create Sample Rassberry Pi Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-6,GetDate())),
        (NEWID(), N'Dev Completed', N'Deployed',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Create Sample Rassberry Pi Project%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-4,GetDate())),
        (NEWID(), N'Not Started', N'Inprogress',N'UserStoryStatus',N'UserStoryStatusChanged',(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Stored Procedures for Rassberry Pi%' AND P.CompanyId = @CompanyId),@UserId, DATEADD(MINUTE,-5,GetDate()))
)
AS Source ([Id],[OldValue], [NewValue],[FieldName],[Description],[UserStoryId],[CreatedByUserId],[CreatedDateTime]) 
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [OldValue] = Source.[OldValue],
           [NewValue] = Source.[NewValue],
           [FieldName] = Source.[FieldName],
           [Description] = Source.[Description],
           [UserStoryId] = Source.[UserStoryId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id],[OldValue], [NewValue],[FieldName],[Description],[UserStoryId],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id],[OldValue], [NewValue],[FieldName],[Description],[UserStoryId],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[UserStorySpentTime] AS Target
USING ( VALUES
		 (NEWID(),N'Worked on this userstory',N'197359ed-c9fe-4699-a394-c33ca66446ef',DATEADD(DAY,-1,GETDATE()),DATEADD(DAY,-1,GETDATE()),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Functions for Iot Project%' AND P.CompanyId = @CompanyId), 60, 60,@UserId,DATEADD(DAY,-1,GETDATE()), @UserId),
		 (NEWID(),N'Worked on this userstory',N'197359ed-c9fe-4699-a394-c33ca66446ef',DATEADD(DAY,-1,GETDATE()),DATEADD(DAY,-1,GETDATE()),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Create Sample App for finding room temp using IOT%' AND P.CompanyId = @CompanyId), 240,  120,(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-1,GETDATE()), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),
		 (NEWID(),N'Worked on this userstory',N'197359ed-c9fe-4699-a394-c33ca66446ef',DATEADD(DAY,-1,GETDATE()),DATEADD(DAY,-1,GETDATE()),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Functions for Big Data%' AND P.CompanyId = @CompanyId), 60, 60,(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-1,GETDATE()), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),
		 (NEWID(),N'Worked on this userstory',N'197359ed-c9fe-4699-a394-c33ca66446ef',DATEADD(DAY,-1,GETDATE()),DATEADD(DAY,-1,GETDATE()),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN PROJECT P ON G.ProjectId = P.Id WHERE UserStoryName LIKE '%Stored Procedures for Rassberry Pi%' AND P.CompanyId = @CompanyId), 60, 60,@UserId,GetDate(), @UserId)
)
AS Source ([Id], [Comment],[LogTimeOptionId],[DateFrom], [DateTo],[UserStoryId], [SpentTimeInMin], [RemainingTimeInMin],[UserId],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserStoryId] = Source.[UserStoryId],
		   [SpentTimeInMin] = Source.[SpentTimeInMin],
		   [RemainingTimeInMin] = Source.[RemainingTimeInMin],
		   [Comment] = Source.[Comment],
		   [UserId] = Source.[UserId],
		   [LogTimeOptionId] = Source.[LogTimeOptionId],
		   [DateFrom] = Source.[DateFrom],
		   [DateTo] = Source.[DateTo],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [Comment],[LogTimeOptionId],[DateFrom], [DateTo],[UserStoryId], [SpentTimeInMin], [RemainingTimeInMin],[UserId],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [Comment],[LogTimeOptionId],[DateFrom], [DateTo],[UserStoryId], [SpentTimeInMin], [RemainingTimeInMin],[UserId],[CreatedDateTime], [CreatedByUserId]);

END

MERGE INTO [dbo].[ProjectFeature] AS Target
USING ( VALUES
        (NEWID(), N'Database', (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), NULL, @UserId, GetDate()),
		(NEWID(), N'General', (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), NULL, @UserId, GetDate()),
		(NEWID(), N'Database', (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), NULL, @UserId, GetDate()),
		(NEWID(), N'General', (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), NULL, @UserId, GetDate()),
		(NEWID(), N'General', (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), NULL, @UserId, GetDate()),
		(NEWID(), N'Database', (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), NULL, @UserId, GetDate())
)

AS Source ([Id], [ProjectFeatureName], [ProjectId], [IsDelete], [CreatedByUserId], [CreatedDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [ProjectFeatureName] = Source.[ProjectFeatureName],
		   [ProjectId] = source.[ProjectId],
		   [IsDelete] = source.[IsDelete],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [ProjectFeatureName], [ProjectId], [IsDelete], [CreatedByUserId], [CreatedDateTime]) VALUES ([Id], [ProjectFeatureName], [ProjectId], [IsDelete], [CreatedByUserId], [CreatedDateTime]);

MERGE INTO [dbo].[TimeSheet] AS TARGET 
USING (VALUES 
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 03:34:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), @UserId, CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 03:34:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -1, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -1, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -1, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -2, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -2, GETDATE())))) + ' 03:34:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -2, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -2, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -2, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -2, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -2, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -2, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -2, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -2, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -2, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -2, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -2, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -2, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -2, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -2, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -2, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -3, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -3, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -3, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -3, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -3, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -3, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -3, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -3, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -3, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -3, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -3, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -3, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -3, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -3, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -3, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -3, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -3, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -4, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -4, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -4, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -4, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -4, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -4, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -4, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -4, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -4, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -4, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -4, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -4, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -4, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -4, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -4, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -4, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -4, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -5, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -5, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -5, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -5, GETDATE())))) + ' 10:45:00.000',(CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -5, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -5, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -5, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -5, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -5, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -5, GETDATE())))) + ' 10:45:00.000',(CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -5, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -5, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -5, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -5, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -5, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -5, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -5, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -6, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -6, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -6, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -6, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -6, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -6, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -6, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -6, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -6, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -6, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -6, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -6, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -6, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -6, GETDATE()) AS DATETIME),CAST(DATEADD(MONTH, -6, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -6, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -6, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -7, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -7, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -7, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -7, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -7, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -7, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -7, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -7, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -7, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -7, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -7, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -7, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -7, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -7, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -7, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -7, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -7, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),  CAST(DATEADD(MONTH, -8, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -8, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -8, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -8, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -8, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -8, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),  CAST(DATEADD(MONTH, -8, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -8, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -8, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -8, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -8, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -8, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -8, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -8, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -8, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -8, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -9, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -9, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -9, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -9, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -9, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -9, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -9, GETDATE()) AS DATETIME),(CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -9, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -9, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -9, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -9, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -9, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -9, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -9, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -9, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -9, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -10, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -10, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -10, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -10, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -10, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -10, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -10, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -10, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -10, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -10, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -10, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -10, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -10, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -10, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -10, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -10, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -10, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -11, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -11, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -11, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -11, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -11, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -11, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -11, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -11, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -11, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -11, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(MONTH, -11, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(MONTH, -11, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(MONTH, -11, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(MONTH, -11, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -11, GETDATE()) AS DATETIME), NULL, NULL, CAST(DATEADD(MONTH, -11, GETDATE()) AS DATETIME), CAST(DATEADD(MONTH, -11, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),

	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -13, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -8, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -8, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -8, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -8, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(DAY, -8, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -13, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -8, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -8, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -8, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -8, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -8, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(DAY, -8, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -14, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -9, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -9, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -9, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -9, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(DAY, -9, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -14, GETDATE()) AS DATETIME), (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -9, GETDATE())))) + ' 04:15:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -9, GETDATE())))) + ' 09:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -9, GETDATE())))) + ' 10:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,DATEADD(DAY, -9, GETDATE()))) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,DATEADD(DAY, -9, GETDATE())))) + ' 17:00:00.000', CAST(DATEADD(DAY, -9, GETDATE()) AS DATETIME), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),

       (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(GETDATE() AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,0,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,GETDATE()))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),''),DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '10:15'), (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 11:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 11:31:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 17:00:00.000', GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
       (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(GETDATE() AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,0,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,GETDATE()))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),''),DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '10:15'), (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 11:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 11:31:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 17:00:00.000', GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
       (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(GETDATE() AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,GETDATE()))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),''),DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '10:15'), (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 11:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 11:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 17:00:00.000', GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
       (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(GETDATE() AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,GETDATE()))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),''),DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), 0) + '10:15'), (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 11:30:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 11:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 17:00:00.000', GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
       (NEWID(), @UserId, CAST(GETDATE() AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,GETDATE()))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 2, GETDATE()), 0) + '10:15'), ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,GETDATE()))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 2, GETDATE()), 0) + '10:30'), (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 11:45:00.000', (CONVERT(VARCHAR,DATEPART(YEAR,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(MONTH,GETDATE())) +  '-' + CONVERT(VARCHAR,DATEPART(DAY,GETDATE()))) + ' 17:00:00.000', GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'), 

	  (NEWID(), (SELECT Id FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -1, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -1, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -1, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 1, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -1, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-1,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 1, GETDATE()), 0) + '17:30'), DATEADD(DAY, DATEDIFF(DAY, 1, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -2, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -2, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -2, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 2, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -2, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-2,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 2, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 2, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -2, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -2, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -2, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 2, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -2, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-2,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 2, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 2, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -3, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -3, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -3, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -3, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-3,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0) + '17:30'), DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -3, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -3, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -3, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -3, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-3,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -3, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -3, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -3, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -3, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-3,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 3, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -4, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -4, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -4, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -4, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-4,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -4, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -4, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -4, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -4, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-4,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) + '17:20'), DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -4, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -4, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -4, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -4, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-4,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -4, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -4, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -4, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -4, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-4,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 4, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -5, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -5, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -5, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -5, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-5,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -5, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -5, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -5, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -5, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-5,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -5, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -5, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -5, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -5, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-5,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0) + '17:30'), DATEADD(DAY, DATEDIFF(DAY, 5, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -6, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -6, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -6, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -6, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-6,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -6, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -6, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -6, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -6, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-6,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -6, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -6, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -6, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -6, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-6,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 6, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -7, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -7, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -7, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -7, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-7,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -7, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -7, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -7, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -7, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-7,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0) + '17:10'), DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -7, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -7, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -7, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -7, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-7,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -7, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -7, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -7, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -7, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-7,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 7, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -8, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -8, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -8, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 8, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -8, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-8,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 8, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 8, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -8, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -8, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -8, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 8, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -8, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-8,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 8, GETDATE()), 0) + '17:00'), DATEADD(DAY, DATEDIFF(DAY, 8, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -8, GETDATE()) AS DATE), ISNULL(NULLIF((SELECT DATEADD(MINUTE,15,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -8, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId JOIN [Employee] E ON E.Id = ES.EmployeeId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek]=(DATENAME(WEEKDAY,DATEADD(DAY, -8, GETDATE()))) AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 8, GETDATE()), 0) + '10:15'), NULL, NULL, ISNULL(NULLIF((SELECT DATEADD(MINUTE,30,DATEADD(DAY,DATEDIFF(DAY,CONVERT(DATETIME,SW.DeadLine),CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY, -8, GETDATE())))),CONVERT(DATETIME,SW.DeadLine)))FROM ShiftTiming ST JOIN EmployeeShift ES ON ST.Id = ES.ShiftTimingId  JOIN ShiftWeek SW ON SW.ShiftTimingId=ST.Id AND SW.[DAYOfWeek] = DATENAME(WEEKDAY,DATEADD(DAY,-8,GETDATE())) JOIN [Employee] E ON E.Id = ES.EmployeeId AND E.UserId = @UserId),''),DATEADD(DAY, DATEDIFF(DAY, 8, GETDATE()), 0) + '17:15'), DATEADD(DAY, DATEDIFF(DAY, 8, GETDATE()), 0), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -2, GETDATE()) AS DATE), CAST(DATEADD(DAY, -2, GETDATE()) AS DATETIME), CAST(DATEADD(DAY, -2, GETDATE()) AS DATETIME), CAST(DATEADD(DAY, -2, GETDATE()) AS DATETIME), CAST(DATEADD(DAY, -2, GETDATE()) AS DATETIME), GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1'),
	  (NEWID(), (SELECT Id FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId), CAST(DATEADD(DAY, -3, GETDATE()) AS DATE), CAST(DATEADD(DAY, -3, GETDATE()) AS DATETIME), CAST(DATEADD(DAY, -3, GETDATE()) AS DATETIME), CAST(DATEADD(DAY, -3, GETDATE()) AS DATETIME), CAST(DATEADD(DAY, -3, GETDATE()) AS DATETIME), GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1')
)
	
AS SOURCE ([Id], [UserId], [DATE], [InTime], [LunchBreakStartTime], [LunchBreakEndTime], [OutTime], [CreatedDATETIME], [CreatedByUserId], [InTimeTimeZone], [LunchBreakStartTimeZone],[LunchBreakEndTimeZone], [OutTimeTimeZone]) 
ON TARGET.Id = SOURCE.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = SOURCE.[Id],
	       [UserId] = SOURCE.[UserId],
		   [DATE] = SOURCE.[DATE],
		   [InTime] = SOURCE.[InTime],
		   [InTimeTimeZone] = SOURCE.[InTimeTimeZone],
		   [LunchBreakStartTime] = SOURCE.[LunchBreakStartTime],
		   [LunchBreakStartTimeZone] = SOURCE.[LunchBreakStartTimeZone],
		   [LunchBreakEndTime] = SOURCE.[LunchBreakEndTime],
		   [LunchBreakEndTimeZone] = SOURCE.[LunchBreakEndTimeZone],
		   [OutTime] = SOURCE.[OutTime],
		   [OutTimeTimeZone] = SOURCE.[OutTimeTimeZone],
		   [CreatedDATETIME] = SOURCE.[CreatedDATETIME],
		   [CreatedByUserId] = SOURCE.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [UserId], [DATE], [InTime],[InTimeTimeZone], [LunchBreakStartTime], [LunchBreakStartTimeZone], [LunchBreakEndTime], [LunchBreakEndTimeZone], [OutTime], [OutTimeTimeZone], [CreatedDATETIME], [CreatedByUserId]) VALUES ([Id], [UserId], [DATE], [InTime], [InTimeTimeZone], [LunchBreakStartTime], [LunchBreakStartTimeZone], [LunchBreakEndTime], [LunchBreakEndTimeZone], [OutTime], [OutTimeTimeZone], [CreatedDATETIME], [CreatedByUserId]); 

MERGE INTO [dbo].[TimeSheetHistory] AS TARGET 
USING (VALUES 
	  (NEWID(), (SELECT Id FROM [TimeSheet] WHERE UserId = @UserId AND [Date] = CAST(GETDATE() AS Date)), GETDATE(), 'Started', GETDATE(), @UserId),
	  (NEWID(), (SELECT Id FROM [TimeSheet] WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId) AND [Date] = CAST(GETDATE() AS Date)), GETDATE(), 'Started', GETDATE(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),
	  (NEWID(), (SELECT Id FROM [TimeSheet] WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId) AND [Date] = CAST(GETDATE() AS Date)), GETDATE(), 'Started', GETDATE(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),
	  (NEWID(), (SELECT Id FROM [TimeSheet] WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId) AND [Date] = CAST(GETDATE() AS Date)), GETDATE(), 'Started', GETDATE(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),
	  (NEWID(), (SELECT Id FROM [TimeSheet] WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId) AND [Date] = CAST(GETDATE() AS Date)), GETDATE(), 'Started', GETDATE(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId))
)
AS SOURCE ([Id], [TimeSheetId],[NewValue],[FieldName],[CreatedDateTime], [CreatedByUserId]) 
ON TARGET.Id = SOURCE.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = SOURCE.[Id],
	       [TimeSheetId] = SOURCE.[TimeSheetId],
		   [NewValue] = SOURCE.[NewValue],
		   [FieldName] = SOURCE.[FieldName],
		   [CreatedDateTime] = SOURCE.[CreatedDateTime],
		   [CreatedByUserId] = SOURCE.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TimeSheetId],[NewValue],[FieldName],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [TimeSheetId],[NewValue],[FieldName],[CreatedDateTime], [CreatedByUserId]); 

--Assets
MERGE INTO [dbo].[SeatingArrangement] AS Target
USING ( VALUES    
		 (NEWID(), (SELECT E.UserId FROM Employee E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),(SELECT EB.BranchId FROM Employee E JOIN [User] U ON E.UserId = U.Id JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id  WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'T45',NULL,NULL,GetDate(), @UserId)
		,(NEWID(), (SELECT E.UserId FROM Employee E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),(SELECT EB.BranchId FROM Employee E JOIN [User] U ON E.UserId = U.Id JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id  WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'T35',NULL,NULL,GetDate(), @UserId)
		,(NEWID(), (SELECT E.UserId FROM Employee E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),(SELECT EB.BranchId FROM Employee E JOIN [User] U ON E.UserId = U.Id JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id  WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'T46',NULL,NULL,GetDate(), @UserId)
		,(NEWID(), (SELECT E.UserId FROM Employee E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),(SELECT EB.BranchId FROM Employee E JOIN [User] U ON E.UserId = U.Id JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id  WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'T56',NULL,NULL,GetDate(), @UserId)
		,(NEWID(), (SELECT E.UserId FROM Employee E JOIN [User] U ON E.UserId = U.Id WHERE E.UserId = @UserId AND CompanyId = @CompanyId),(SELECT EB.BranchId FROM Employee E JOIN [User] U ON E.UserId = U.Id JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id  WHERE E.UserId = @UserId AND CompanyId = @CompanyId), N'T90',NULL,NULL,GetDate(), @UserId)
)
AS Source ([Id],[EmployeeId], [BranchId], [SeatCode], [Description], [Comment], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [EmployeeId] = Source.[EmployeeId],
		   [BranchId] = source.[BranchId],
		   [SeatCode] = Source.[SeatCode],
           [Description] = Source.[Description],
           [Comment] = Source.[Comment],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [CreatedDateTime] = Source.[CreatedDateTime]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id],[EmployeeId], [BranchId], [SeatCode], [Description], [Comment], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id],[EmployeeId], [BranchId], [SeatCode], [Description], [Comment], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Supplier] AS Target
USING ( VALUES    
		 (NEWID(), @CompanyId, N'Best Enterprises', N'HP', N'JB', N'Sales', N'1230456789', N'1234578960', N'James', CAST(N'2019-03-07T00:00:00.000' AS DateTime), GetDate(), @UserId, NULL)
		,(NEWID(), @CompanyId, N'E Technologies', N'Dell', N'Suresh', N'Sales', N'1234567890', N'1234567890', N'Ramesh', CAST(N'2019-03-07T00:00:00.000' AS DateTime), GetDate(), @UserId, NULL)
		,(NEWID(), @CompanyId, N'Technozin', N'Lenovo', N'Michel', N'Sales', N'1234567890', N'0231456789', N'Smith', CAST(N'2019-03-07T00:00:00.000' AS DateTime), GetDate(), @UserId, NULL)
		,(NEWID(), @CompanyId, N'Best Furnitures', N'Usha', N'David', N'Sales', N'1230456789', N'1459886932', N'Madhavan', CAST(N'2019-03-11T00:00:00.000' AS DateTime),GetDate(), @UserId, NULL)
		,(NEWID(), @CompanyId, N'Apple Technosoft', N'Apple', N'Chan', N'Manager', N'1230456789', N'1230456789', N'Jivan', CAST(N'2019-03-04T00:00:00.000' AS DateTime),GetDate(), @UserId, NULL)
)

AS Source ([Id], [CompanyId], [SupplierName], [CompanyName], [ContactPerson], [ContactPosition], [CompanyPhoneNumber], [ContactPhoneNumber], [VendorIntroducedBy], [StartedWorkingFrom], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [SupplierName] = source.[SupplierName],
		   [CompanyName] = Source.[CompanyName],
           [ContactPerson] = Source.[ContactPerson],
           [ContactPosition] = Source.[ContactPosition],
           [CompanyPhoneNumber] = Source.[CompanyPhoneNumber],
		   [ContactPhoneNumber] = Source.[ContactPhoneNumber],
           [VendorIntroducedBy] = Source.[VendorIntroducedBy],
           [StartedWorkingFrom] = Source.[StartedWorkingFrom],
           [InActiveDateTime] = Source.[InActiveDateTime]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [SupplierName], [CompanyName], [ContactPerson], [ContactPosition], [CompanyPhoneNumber], [ContactPhoneNumber], [VendorIntroducedBy], [StartedWorkingFrom], [CreatedDateTime], [CreatedByUserId],[InActiveDateTime]) VALUES ([Id], [CompanyId], [SupplierName], [CompanyName], [ContactPerson], [ContactPosition], [CompanyPhoneNumber], [ContactPhoneNumber], [VendorIntroducedBy], [StartedWorkingFrom], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]);

MERGE INTO [dbo].[Product] AS Target
USING ( VALUES
     (NEWID(), @CompanyId, N'Apple', GetDate(), @UserId)
	,(NEWID(), @CompanyId, N'Lenovo', GetDate(), @UserId)
	,(NEWID(), @CompanyId, N'HP', GetDate(), @UserId)
	,(NEWID(), @CompanyId, N'Dell', GetDate(), @UserId)
	,(NEWID(), @CompanyId, N'Usha', GetDate(), @UserId)
)

AS Source ([Id], [CompanyId], [ProductName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [ProductName] = source.[ProductName],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [ProductName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [ProductName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ProductDetails] AS Target
USING (VALUES
     (NEWID(), (SELECT Id FROM Product WHERE ProductName LIKE '%Apple%'  AND CompanyId = @CompanyId), N'456',   (SELECT Id FROM Supplier WHERE SupplierName LIKE '%Best Enterprises%' AND CompanyId = @CompanyId), N'789', GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM Product WHERE ProductName LIKE '%Lenovo%' AND CompanyId = @CompanyId), N'78652', (SELECT Id FROM Supplier WHERE SupplierName LIKE '%Technozin%' AND CompanyId = @CompanyId), N'5552', GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'   AND CompanyId = @CompanyId), N'523',   (SELECT Id FROM Supplier WHERE SupplierName LIKE '%Apple Technosoft%' AND CompanyId = @CompanyId), N'489',GetDate(), @UserId)

)

AS Source ([Id], [ProductId], [ProductCode], [SupplierId], [ManufacturerCode], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [ProductId] = Source.[ProductId],
		   [ProductCode] = source.[ProductCode],
		   [SupplierId] = source.[SupplierId],
		   [ManufacturerCode] = source.[ManufacturerCode],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [ProductId], [ProductCode], [SupplierId], [ManufacturerCode], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [ProductId], [ProductCode], [SupplierId], [ManufacturerCode], [CreatedDateTime], [CreatedByUserId]);
 
MERGE INTO [dbo].[Asset] AS Target
USING ( VALUES
    (NEWID(), N'Ch 345',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '523'), CAST(N'2019-03-03T00:00:00.000' AS DateTime), (SELECT Id FROM Product WHERE ProductName LIKE '%Apple%'  AND CompanyId = @CompanyId), N'Chair', CAST(700 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 1, DATEADD(day,-2,GETDATE()), 'Asset damaged', (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 1, 0, GetDate(), @UserId, (SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'1',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '523'), DATEADD(day,-5,GETDATE()),      (SELECT Id FROM Product WHERE ProductName LIKE '%Lenovo%'  AND CompanyId = @CompanyId), N'Mouse', CAST(100 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 1, 1, GetDate(), @UserId, (SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'5',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '78652'), CAST(N'2019-03-05T00:00:00.000' AS DateTime),      (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), N'CPU', CAST(500 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'3',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '456'), CAST(N'2019-03-07T00:00:00.000' AS DateTime),      (SELECT Id FROM Product WHERE ProductName LIKE '%HP%'  AND CompanyId = @CompanyId), N'Monitor', CAST(500 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 1, DATEADD(day,-5,GETDATE()), 'Asset damaged', (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'20',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '523'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Apple%'  AND CompanyId = @CompanyId), N'KeyBoard', CAST(100 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'10',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '78652'), CAST(N'2019-02-07T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), N'MacBook', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'Mp34',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '456'), CAST(N'2019-03-05T00:00:00.000' AS DateTime),   (SELECT Id FROM Product WHERE ProductName LIKE '%Usha%'  AND CompanyId = @CompanyId), N'MousePad', CAST(800 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 1, 0, GetDate(), @UserId, (SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'11',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '456'), DATEADD(day,-5,GETDATE()),     (SELECT Id FROM Product WHERE ProductName LIKE '%Apple%'  AND CompanyId = @CompanyId), N'MacBook', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'13',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '78652'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), N'KeyBoard', CAST(1000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'4',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '456'), CAST(N'2019-03-04T00:00:00.000' AS DateTime),      (SELECT Id FROM Product WHERE ProductName LIKE '%Apple%'  AND CompanyId = @CompanyId), N'MacBook', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'2',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '78652'), CAST(N'2019-03-07T00:00:00.000' AS DateTime),      (SELECT Id FROM Product WHERE ProductName LIKE '%HP%'  AND CompanyId = @CompanyId), N'KeyBoard', CAST(200 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 1, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'21',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '523'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Lenovo%'  AND CompanyId = @CompanyId), N'KeyBoard', CAST(800 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 1, DATEADD(day,-4,GETDATE()), 'Asset damaged', (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'27',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '523'), DATEADD(day,-5,GETDATE()),     (SELECT Id FROM Product WHERE ProductName LIKE '%Usha%'  AND CompanyId = @CompanyId), N'MacBook', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'7',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '78652'), CAST(N'2019-03-01T00:00:00.000' AS DateTime),      (SELECT Id FROM Product WHERE ProductName LIKE '%Apple%'  AND CompanyId = @CompanyId), N'Monitor', CAST(700 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 1, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'17',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '456'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), N'KeyBoard', CAST(100 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'14',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '523'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%HP%'  AND CompanyId = @CompanyId), N'MousePad', CAST(100 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'24',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '456'), DATEADD(day,-5,GETDATE()),     (SELECT Id FROM Product WHERE ProductName LIKE '%Lenovo%'  AND CompanyId = @CompanyId), N'KeyBoard', CAST(100 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'28',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '78652'), CAST(N'2019-02-03T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Apple%'  AND CompanyId = @CompanyId), N'MacBook', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'8',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '456'), CAST(N'2019-02-01T00:00:00.000' AS DateTime),      (SELECT Id FROM Product WHERE ProductName LIKE '%HP%'  AND CompanyId = @CompanyId), N'Monitor', CAST(700 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, NULL, NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'12',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '78652'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), N'MacBook', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 1, DATEADD(day,-2,GETDATE()), 'Asset damaged', (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	
	(NEWID(), N'132',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '78652'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), N'MacBook', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, DATEADD(day,-2,GETDATE()), NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'16',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '456'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), N'Monitor', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, DATEADD(day,-2,GETDATE()), NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL),
	(NEWID(), N'29',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '523'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), N'KeyBoard', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 0, DATEADD(day,-2,GETDATE()), NULL, NULL, 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),(SELECT Id FROM SeatingArrangement WHERE SeatCode LIKE '%T35%' AND BranchId IN (SELECT Id FROM Branch WHERE CompanyId = @CompanyId))),
	(NEWID(), N'M56',(SELECT PD.Id FROM [ProductDetails] PD JOIN Product P ON P.Id = PD.ProductId WHERE CompanyId = @CompanyId AND ProductCode = '78652'), CAST(N'2019-02-06T00:00:00.000' AS DateTime),     (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), N'CPU', CAST(8000 AS Decimal(18, 0)), (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), 1, DATEADD(day,-2,GETDATE()), 'Asset damaged', (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 0, 0, GetDate(), @UserId,(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId),NULL)
	--(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId)
)

AS Source ([Id], [AssetNumber],[ProductDetailsId], [PurchasedDate], [ProductId], [AssetName], [Cost], [CurrencyId], [IsWriteOff], [DamagedDate], [DamagedReason], [DamagedByUserId], [IsEmpty], [IsVendor], [CreatedDateTime], [CreatedByUserId],[BranchId],[SeatingId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [AssetNumber] = Source.[AssetNumber],
		   [PurchasedDate] = source.[PurchasedDate],
		   [ProductId] = source.[ProductId],
		   [AssetName] = source.[AssetName],
		   [Cost] = source.[Cost],
		   [CurrencyId] = source.[CurrencyId],
		   [IsWriteOff] = source.[IsWriteOff],
		   [DamagedDate] = source.[DamagedDate],
		   [DamagedReason] =  source.[DamagedReason],
		   [DamagedByUserId] =  source.[DamagedByUserId],
		   [IsEmpty] = source.[IsEmpty],
		   [IsVendor] = source.[IsVendor],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [BranchId] = Source.[Branchid],
		   [SeatingId] = Source.[SeatingId],
		   [ProductDetailsId] = Source.[ProductDetailsId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [AssetNumber],[ProductDetailsId], [PurchasedDate], [ProductId], [AssetName], [Cost], [CurrencyId], [IsWriteOff], [DamagedDate], [DamagedReason], [DamagedByUserId], [IsEmpty], [IsVendor], [CreatedDateTime], [CreatedByUserId],[BranchId],[SeatingId]) VALUES ([Id], [AssetNumber],[ProductDetailsId], [PurchasedDate], [ProductId], [AssetName], [Cost], [CurrencyId], [IsWriteOff], [DamagedDate], [DamagedReason], [DamagedByUserId], [IsEmpty], [IsVendor], [CreatedDateTime], [CreatedByUserId],[BranchId],[SeatingId]);

MERGE INTO [dbo].[AssetAssignedToEmployee] AS Target
USING ( VALUES
     (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'Ch 345' AND CompanyId = @CompanyId), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'1' AND CompanyId = @CompanyId),      (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'2' AND CompanyId = @CompanyId),      (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'3' AND CompanyId = @CompanyId),      (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'4' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'5' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'Mp34' AND CompanyId = @CompanyId),   (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'7' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'8' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'11' AND CompanyId = @CompanyId),      (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'12' AND CompanyId = @CompanyId),      (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'13' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'17' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'21' AND CompanyId = @CompanyId),		 (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'24' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'28' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'10' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'14' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'132' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'16' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'29' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'M56' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'20' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'27' AND CompanyId = @CompanyId),     (SELECT Id FROM [User] WHERE Id = @UserId AND CompanyId = @CompanyId), GetDate(), NULL, @UserId, GetDate(), @UserId)
	   
)

AS Source ([Id], [AssetId], [AssignedToEmployeeId], [AssignedDateFrom], [AssignedDateTo], [ApprovedByUserId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [AssetId] = Source.[AssetId],
		   [AssignedToEmployeeId] = source.[AssignedToEmployeeId],
		   [AssignedDateTo] = source.[AssignedDateTo],
		   [ApprovedByUserId] = source.[ApprovedByUserId],
		   [AssignedDateFrom] = source.[AssignedDateFrom],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [AssetId], [AssignedToEmployeeId], [AssignedDateFrom], [AssignedDateTo], [ApprovedByUserId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [AssetId], [AssignedToEmployeeId], [AssignedDateFrom], [AssignedDateTo], [ApprovedByUserId], [CreatedDateTime], [CreatedByUserId]);

INSERT INTO [dbo].[AssetHistory]([Id], [AssetId],[AssetHistoryJson],[CreatedDateTime], [CreatedByUserId])
SELECT NEWID(),A.Id AS AssetId
        ,(SELECT 'Asset' AS FieldName
        ,A.AssetName AS OldValue
		,U.FirstName + ' ' + ISNULL(U.SurName,'') AS NewValue
		,'AssetIsNewlyAssignedTo' AS 'Description'  
        ,A.AssetName AS OldValueText
		,U.FirstName + ' ' + ISNULL(U.SurName,'') AS NewValueText
		FOR JSON PATH, ROOT('AssetsFieldsChangedList'))
		,GETDATE()
		,@UserId
FROM 
Asset A
INNER JOIN AssetAssignedToEmployee AAE ON AAE.AssetId = A.Id
INNER JOIN [User] U ON U.Id = AAE.AssignedToEmployeeId
WHERE U.CompanyId = @CompanyId

INSERT INTO [dbo].[AssetHistory]([Id], [AssetId],[AssetHistoryJson],[CreatedDateTime], [CreatedByUserId])
SELECT NEWID(),A.Id AS AssetId
        ,(SELECT 'IsWriteOff' AS FieldName
        ,A.AssetName AS OldValue
		,U.Id AS NewValue
		,'AssetIsWriteOffChange' AS 'Description'  
        ,A.AssetName AS OldValueText
		,U.FirstName + ' ' + ISNULL(U.SurName,'') AS NewValueText
		FOR JSON PATH, ROOT('AssetsFieldsChangedList'))
		,GETDATE()
		,@UserId
FROM 
Asset A
INNER JOIN AssetAssignedToEmployee AAE ON AAE.AssetId = A.Id AND A.IsWriteOff = 1
INNER JOIN [User] U ON U.Id = AAE.AssignedToEmployeeId
WHERE U.CompanyId = @CompanyId

MERGE INTO [dbo].[VendorDetails] AS Target
USING ( VALUES
     (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'Ch 345' AND CompanyId = @CompanyId), (SELECT Id FROM Product WHERE ProductName LIKE '%Apple%'  AND CompanyId = @CompanyId), CAST(700.00 AS Decimal(18, 2))),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'1' AND CompanyId = @CompanyId),      (SELECT Id FROM Product WHERE ProductName LIKE '%Dell%'  AND CompanyId = @CompanyId), CAST(100.00 AS Decimal(18, 2))),
	 (NEWID(), (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'5' AND CompanyId = @CompanyId),      (SELECT Id FROM Product WHERE ProductName LIKE '%HP%'  AND CompanyId = @CompanyId), CAST(200.00 AS Decimal(18, 2)))
)
AS Source ([Id], [AssetId], [ProductId], [Cost])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [AssetId] = Source.[AssetId],
		   [ProductId] = source.[ProductId],
		   [Cost] = source.[Cost]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [AssetId], [ProductId], [Cost]) VALUES ([Id], [AssetId], [ProductId], [Cost]);
--Assets
MERGE INTO [dbo].[FormType] AS Target
USING ( VALUES
       (NEWID(), N'Code review check', @CompanyId, GetDate(), @UserId)
	  ,(NEWID(), N'Meeting notes', @CompanyId, GetDate(), @UserId)
	  ,(NEWID(), N'Status', @CompanyId, GetDate(), @UserId)
)
AS Source ([Id], [FormTypeName], [CompanyId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [FormTypeName] = Source.[FormTypeName],
		   [CompanyId] = source.[CompanyId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [FormTypeName], [CompanyId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [FormTypeName], [CompanyId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[GenericForm] AS Target
USING ( VALUES
       (NEWID(), (SELECT Id FROM FormType WHERE FormTypeName LIKE '%Code review check%' AND CompanyId = @CompanyId), N'Code Review', N'{"components":[{"label":"Code Review Description","showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"textField","defaultValue":"","conditional":{"show":false,"when":"","json":""},"$$hashKey":"object:249","spellcheck":true,"validate":{"customMessage":"","json":""},"widget":{"type":""},"reorder":false,"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[]},{"label":"Description","isUploadEnabled":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textarea","input":true,"key":"description","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"wysiwyg":"","uploadUrl":"","uploadOptions":"","uploadDir":"","reorder":false,"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[]},{"label":"Is Checked","labelPosition":"top","shortcut":"","mask":false,"tableView":true,"alwaysEnabled":false,"type":"checkbox","input":true,"key":"isChecked","defaultValue":false,"validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"reorder":false,"encrypted":false,"properties":{},"customConditional":"","logic":[]}]}', NULL, NULL, GetDate(), @UserId)
	  ,(NEWID(), (SELECT Id FROM FormType WHERE FormTypeName LIKE '%Meeting notes%' AND CompanyId = @CompanyId), N'Meeting', N'{"components":[{"label":"Description","showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"textField","defaultValue":"","conditional":{"show":false,"when":"","json":""},"$$hashKey":"object:249","spellcheck":true,"validate":{"customMessage":"","json":""},"widget":{"type":""},"reorder":false,"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[]},{"label":"Meeting Notes","isUploadEnabled":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textarea","input":true,"key":"textArea2","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"wysiwyg":"","uploadUrl":"","uploadOptions":"","uploadDir":"","reorder":false}]}', NULL, NULL, GetDate(), @UserId)
	  ,(NEWID(), (SELECT Id FROM FormType WHERE FormTypeName LIKE '%Status%' AND CompanyId = @CompanyId), N'Status', N'{"components":[{"label":"Description","showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"textField","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":false,"when":"","json":""},"$$hashKey":"object:249","spellcheck":true,"widget":{"type":""},"reorder":false,"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[]}]}', NULL, NULL, GetDate(), @UserId)
)

AS Source ([Id], [FormTypeId], [FormName], [FormJson], [ArchivedDateTime], [ArchivedByUserId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [FormTypeId] = Source.[FormTypeId],
		   [FormName] = source.[FormName],
		   [FormJson] = source.[FormJson],
		   --[ArchivedDateTime] = source.[ArchivedDateTime],
		   --[ArchivedByUserId] = source.[ArchivedByUserId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [FormTypeId], [FormName], [FormJson], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [FormTypeId], [FormName], [FormJson], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[StatusReportingConfiguration_New] AS Target
USING ( VALUES
       (NEWID(), N'Meeting', (SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Meeting notes%' AND CompanyId = @CompanyId), @UserId, GetDate(),GetDate(), @UserId)
	  ,(NEWID(), N'Status', (SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Status%' AND CompanyId = @CompanyId), @UserId, GetDate(), GetDate(), @UserId)
	  ,(NEWID(), N'Code Review Check', (SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Code Review%' AND CompanyId = @CompanyId), @UserId, GetDate(), GetDate(), @UserId)
)

AS Source  ([Id], [ConfigurationName], [GenericFormId], [AssignedByUserId], [AssignedDateTime], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [ConfigurationName] = Source.[ConfigurationName],
		   [GenericFormId] = source.[GenericFormId],
		   [AssignedByUserId] = source.[AssignedByUserId],
		   [AssignedDateTime] = source.[AssignedDateTime],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT  ([Id], [ConfigurationName], [GenericFormId], [AssignedByUserId], [AssignedDateTime], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [ConfigurationName], [GenericFormId], [AssignedByUserId], [AssignedDateTime], [CreatedDateTime], [CreatedByUserId]);


MERGE INTO [dbo].[FormSubmissions] AS Target 
USING ( VALUES 
  (NEWID(), (SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Status%' AND CompanyId = @CompanyId), N'{"data":{"textField":"test description"}}', 'New', (SELECT Id FROM [User] WHERE UserName =  N'Maria@'+@CompanyName+'.com' AND CompanyId = @CompanyId), @UserId ,CAST(N'2019-05-07T09:50:17.440' AS DateTime),(SELECT Id FROM [User] WHERE UserName =  N'Maria@'+@CompanyName+'.com' AND CompanyId = @CompanyId))
 ,(NEWID(), (SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Meeting notes%' AND CompanyId = @CompanyId), N'{"data":{"textField":"sample","textArea2":"points discussed"}}', 'New', @UserId, (SELECT Id FROM [User] WHERE UserName =  N'Maria@'+@CompanyName+'.com' AND CompanyId = @CompanyId) ,CAST(N'2019-05-07T09:50:17.440' AS DateTime),@UserId)
 ,(NEWID(), (SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Status%' AND CompanyId = @CompanyId), N'{"data":{"textField":"test description 1"}}', 'New', (SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com' AND CompanyId = @CompanyId), @UserId ,CAST(N'2019-05-07T09:50:17.440' AS DateTime),(SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com' AND CompanyId = @CompanyId))
 ,(NEWID(), (SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Meeting notes%' AND CompanyId = @CompanyId), N'{"data":{"textField":"sample details","textArea2":"points to be discussed"}}', 'New', @UserId, (SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com' AND CompanyId = @CompanyId) ,CAST(N'2019-05-07T09:50:17.440' AS DateTime),@UserId)
	)
AS Source([Id], [GenericFormId], [FormData], [Status], [AssignedByUserId], [AssignedToUserId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET 
           [GenericFormId] = Source.[GenericFormId],
		   [FormData] = Source.[FormData],
		   [Status] = Source.[Status],
		   [AssignedByUserId] = Source.[AssignedByUserId],
		   [AssignedToUserId] = Source.[AssignedToUserId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [GenericFormId], [FormData], [Status], [AssignedByUserId], [AssignedToUserId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [GenericFormId], [FormData], [Status], [AssignedByUserId], [AssignedToUserId], [CreatedDateTime], [CreatedByUserId]);	

MERGE INTO [dbo].[StatusReportingConfigurationOption] AS Target
USING ( VALUES
      (NEWID(), (SELECT S.Id FROM [StatusReportingConfiguration_New] S JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Meeting notes%' AND CompanyId = @CompanyId), (SELECT Id FROM StatusReportingOption_New WHERE OptionName LIKE '%Friday%' AND CompanyId = @CompanyId),GetDate(), @UserId)
	 ,(NEWID(), (SELECT S.Id FROM [StatusReportingConfiguration_New] S JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Code review check%' AND CompanyId = @CompanyId), (SELECT Id FROM StatusReportingOption_New WHERE OptionName LIKE '%Wednesday%' AND CompanyId = @CompanyId),GetDate(), @UserId)
	 ,(NEWID(), (SELECT S.Id FROM [StatusReportingConfiguration_New] S JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Status%' AND CompanyId = @CompanyId), (SELECT Id FROM StatusReportingOption_New WHERE OptionName LIKE '%Everyworkingday%' AND CompanyId = @CompanyId),GetDate(), @UserId)
)

AS Source ([Id], [StatusReportingConfigurationId], [StatusReportingOptionId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [StatusReportingConfigurationId] = Source.[StatusReportingConfigurationId],
		   [StatusReportingOptionId] = source.[StatusReportingOptionId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [StatusReportingConfigurationId], [StatusReportingOptionId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [StatusReportingConfigurationId], [StatusReportingOptionId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[StatusReportingConfigurationUser] AS Target
USING ( VALUES
      (NEWID(), (SELECT S.Id FROM [StatusReportingConfiguration_New] S JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Meeting notes%' AND CompanyId = @CompanyId), @UserId, GetDate(), @UserId)
	 ,(NEWID(), (SELECT S.Id FROM [StatusReportingConfiguration_New] S JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Code review check%' AND CompanyId = @CompanyId), @UserId, GetDate(), @UserId)
	 ,(NEWID(), (SELECT S.Id FROM [StatusReportingConfiguration_New] S JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Status%' AND CompanyId = @CompanyId), @UserId, GetDate(), @UserId)
)

AS Source ([Id], [StatusReportingConfigurationId], [UserId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [StatusReportingConfigurationId] = Source.[StatusReportingConfigurationId],
		   [UserId] = source.[UserId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [StatusReportingConfigurationId], [UserId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [StatusReportingConfigurationId], [UserId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[StatusReporting_New] AS Target
USING ( VALUES
     (NEWID(), (SELECT G.FormJson FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Meeting notes%' AND CompanyId = @CompanyId), (SELECT SO.Id FROM StatusReportingConfigurationOption SO JOIN [StatusReportingConfiguration_New] S ON S.Id = SO.StatusReportingConfigurationId JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Meeting notes%' AND CompanyId = @CompanyId), N'', N'', N'{"textField":"Status report Status report"}', N'Status report', GetDate(), GetDate(),@UserId)
	,(NEWID(), (SELECT G.FormJson FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Code review check%' AND CompanyId = @CompanyId), (SELECT SO.Id FROM StatusReportingConfigurationOption SO JOIN [StatusReportingConfiguration_New] S ON S.Id = SO.StatusReportingConfigurationId JOIN [GenericForm] G ON S.GenericFormId = G.Id JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Code review check%' AND CompanyId = @CompanyId), N'', N'', N'{"textField":"code review report","description":"code review report code review report","isChecked":true}', N'code review report', GetDate(), GetDate(),@UserId)
)

AS Source ([Id],[FormJson],[StatusReportingConfigurationOptionId], [FilePath], [FileName],[FormDataJson], [Description], [SubmittedDateTime], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [StatusReportingConfigurationOptionId] = Source.[StatusReportingConfigurationOptionId],
		   [FilePath] = source.[FilePath],
		   [FileName] = source.[FileName],
		   [FormJson] = Source.[FormJson],
		   [FormDataJson] = Source.[FormDataJson],
		   [Description] = source.[Description],
		   [SubmittedDateTime] = source.[SubmittedDateTime],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [FormJson], [StatusReportingConfigurationOptionId], [FilePath], [FileName], [FormDataJson], [Description], [SubmittedDateTime], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [FormJson], [StatusReportingConfigurationOptionId], [FilePath], [FileName], [FormDataJson], [Description], [SubmittedDateTime], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[CustomApplication] AS Target
USING ( VALUES
     (NEWID(),N'Test-1',N'Form submitted successfully', GetDate(),@UserId)
     ,(NEWID(),N'Test-2', N'Form submitted successfully',GetDate(),@UserId)
)

AS Source ([Id], [CustomApplicationName], [PublicMessage], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CustomApplicationName] = Source.[CustomApplicationName],
		   [PublicMessage] = source.[PublicMessage],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CustomApplicationName], [PublicMessage], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [CustomApplicationName], [PublicMessage], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].CustomApplicationForms AS Target
USING ( VALUES
     (NEWID(),(SELECT Id FROM [CustomApplication] WHERE [CustomApplicationName] = N'Test-1' AND [CreatedByUserId] = @UserId),(SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Meeting notes%' AND CompanyId = @CompanyId), GetDate(),@UserId)
     ,(NEWID(),(SELECT Id FROM [CustomApplication] WHERE [CustomApplicationName] = N'Test-2' AND [CreatedByUserId] = @UserId),(SELECT G.Id FROM [GenericForm] G JOIN FormType F ON F.Id = G.FormTypeId WHERE FormTypeName LIKE '%Status%' AND CompanyId = @CompanyId), GetDate(),@UserId)
)

AS Source ([Id], [CustomApplicationId], [GenericFormId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
		   [GenericFormId] = source.[GenericFormId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CustomApplicationId], [GenericFormId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [CustomApplicationId], [GenericFormId], [CreatedDateTime], [CreatedByUserId]);

UPDATE CustomApplicationForms
                  SET [PublicUrl] = 'application/application-form/' + 'Test' + '/' + GF.FormName From CustomApplicationForms CAF
                  INNER JOIN GenericForm GF ON GF.Id = CAF.GenericFormId
                  INNER JOIN FormType FT ON FT.Id = GF.FormTypeId
                  WHERE FT.CompanyId = @CompanyId

INSERT INTO CustomApplicationKey ([Id], GenericFormKeyId, [GenericFormId], CustomApplicationId,[CreatedDateTime], [CreatedByUserId])
SELECT NEWID()
       ,GFK.Id
	   ,GFK.GenericFormId
	   ,CA.Id
	   ,GETDATE()
	   ,@UserId
FROM CustomApplication CA 
     INNER JOIN CustomApplicationForms CAF ON CAF.CustomApplicationId = CA.Id
	 INNER JOIN GenericForm GF ON GF.Id = CAF.GenericFormId
	 INNER JOIN GenericFormKey GFK ON GFK.GenericFormId = GF.Id
	 INNER JOIN FormType FT ON FT.Id = GF.FormTypeId
WHERE FT.CompanyId = @CompanyId

INSERT INTO CustomApplicationRoleConfiguration ([Id], RoleId, CustomApplicationId,[CreatedDateTime], [CreatedByUserId])
SELECT NEWID()
       ,R.Id
	   ,CA.Id
	   ,GETDATE()
	   ,@UserId
FROM [Role] R INNER JOIN CustomApplication CA ON 1 = 1
WHERE CA.CreatedByUserId = @UserId AND R.CompanyId = @CompanyId

MERGE INTO [dbo].[CanteenFoodItem] AS Target
USING ( VALUES
     (NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId), N'choco Pie', 10.0000, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Manchester' AND B.CompanyId = @CompanyId), N'Hide & Sick', 30.0000, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Nottingham' AND B.CompanyId = @CompanyId), N'Good Day Biscuts', 20.0000, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Manchester' AND B.CompanyId = @CompanyId), N'Bingo yumitos', 10.0000, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId), N'Five star', 10.0000, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId), N'50 - 50 Biscuts', 10.0000, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Nottingham' AND B.CompanyId = @CompanyId), N'Lays (Red)', 10.0000, GetDate(), NULL,GetDate(), @UserId)
	,(NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId), N'Coffee Bytes', 10.0000, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Nottingham' AND B.CompanyId = @CompanyId), N'Dairy Milk', 10.0000, GetDate(), NULL, GetDate(), @UserId )
	,(NEWID(), @CompanyId,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT B.Id FROM Branch B WHERE BranchName = 'Manchester' AND B.CompanyId = @CompanyId), N'Lays (Green)', 10.0000, GetDate(), NULL, GetDate(), @UserId)
)

AS Source ([Id], [CompanyId],CurrencyId,BranchId, [FoodItemName], [Price], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [FoodItemName] = source.[FoodItemName],
		   CurrencyId = Source.CurrencyId,
		   BranchId = Source.BranchId,
		   [Price] = source.[Price],
		   [ActiveFrom] = Source.[ActiveFrom],
		   [ActiveTo] = source.[ActiveTo],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId],CurrencyId,BranchId, [FoodItemName], [Price], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId],CurrencyId,BranchId, [FoodItemName], [Price], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[UserCanteenCredit] AS Target
USING ( VALUES
     (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 250.0000, GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 250.0000, GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 250.0000, GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), @UserId, 250.0000, GetDate(), @UserId)
)

AS Source ([Id], [CreditedToUserId], [CreditedByUserId], [Amount], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CreditedToUserId] = Source.[CreditedToUserId],
		   [CreditedByUserId] = source.[CreditedByUserId],
		   [Amount] = source.[Amount],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CreditedToUserId], [CreditedByUserId], [Amount], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CreditedToUserId], [CreditedByUserId], [Amount], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[UserPurchasedCanteenFoodItem] AS Target
USING ( VALUES
     (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM CanteenFoodItem WHERE FoodItemName LIKE '%choco Pie%' AND CompanyId = @CompanyId),(SELECT Price FROM CanteenFoodItem WHERE FoodItemName LIKE '%choco Pie%' AND CompanyId = @CompanyId), 1, GetDate())
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM CanteenFoodItem WHERE FoodItemName LIKE '%Hide & Sick%' AND CompanyId = @CompanyId),(SELECT Price FROM CanteenFoodItem WHERE FoodItemName LIKE '%Hide & Sick%' AND CompanyId = @CompanyId), 1, GetDate())
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM CanteenFoodItem WHERE FoodItemName LIKE '%Good Day Biscuts%' AND CompanyId = @CompanyId),(SELECT Price FROM CanteenFoodItem WHERE FoodItemName LIKE '%Good Day Biscuts%' AND CompanyId = @CompanyId), 1, GetDate())
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM CanteenFoodItem WHERE FoodItemName LIKE '%Five star%' AND CompanyId = @CompanyId),(SELECT Price FROM CanteenFoodItem WHERE FoodItemName LIKE '%Five star%' AND CompanyId = @CompanyId), 1, GetDate())
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM CanteenFoodItem WHERE FoodItemName LIKE '%50 - 50 Biscuts%' AND CompanyId = @CompanyId),(SELECT Price FROM CanteenFoodItem WHERE FoodItemName LIKE '%50 - 50 Biscuts%' AND CompanyId = @CompanyId), 1, GetDate())
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM CanteenFoodItem WHERE FoodItemName LIKE '%Coffee Bytes%' AND CompanyId = @CompanyId),(SELECT Price FROM CanteenFoodItem WHERE FoodItemName LIKE '%Coffee Bytes%' AND CompanyId = @CompanyId), 1, GetDate())
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM CanteenFoodItem WHERE FoodItemName LIKE '%Dairy Milk%' AND CompanyId = @CompanyId),(SELECT Price FROM CanteenFoodItem WHERE FoodItemName LIKE '%Dairy Milk%' AND CompanyId = @CompanyId), 1, GetDate())
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM CanteenFoodItem WHERE FoodItemName LIKE '%Lays (Red)%' AND CompanyId = @CompanyId),(SELECT Price FROM CanteenFoodItem WHERE FoodItemName LIKE '%Lays (Red)%' AND CompanyId = @CompanyId), 1, GetDate())
)

AS Source ([Id], [UserId], [FoodItemId],[FoodItemPrice], [Quantity], [PurchasedDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserId] = Source.[UserId],
		   [FoodItemId] = source.[FoodItemId],
		   [Quantity] = source.[Quantity],
		   [PurchasedDateTime] = source.[PurchasedDateTime],
		   [FoodItemPrice] = Source.[FoodItemPrice]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [UserId], [FoodItemId],[FoodItemPrice], [Quantity], [PurchasedDateTime]) VALUES ([Id], [UserId], [FoodItemId],[FoodItemPrice], [Quantity], [PurchasedDateTime]);

MERGE INTO [dbo].[FoodOrder] AS Target
USING ( VALUES
     (NEWID(), @CompanyId, @UserId, 'Maria ordered the food', 'Food order details not seems to be fair', (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Chapathi,Roti,panir', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), GetDate(),GetDate(), GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Maria martinez ordered this food order',NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,CurdRice', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), GetDate(),GetDate(), GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  GetDate(),GetDate(),GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Amount overdue',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'pulka,caju curruy,paneer,Egg Biryani', 800.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),  GetDate(),GetDate(), GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Dum biryani,chapathi,roti,kaju', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  GetDate(),GetDate(), GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'france Biryani,Veg Biryani', 500.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), GetDate(),GetDate(), GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,Lolipop Biryani', 650.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  GetDate(),GetDate(), GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  GetDate(),GetDate(), GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Curd Rice,bi,veg Biryani,Egg Biryani', 700.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  GetDate(),GetDate(), GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  GetDate(),GetDate(),GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), GetDate(),GetDate(), GetDate(), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Butter Non,paneer,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  GetDate(),GetDate(), GetDate(), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Maria ordered the food', 'Food order details not seems to be fair', (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Chapathi,Roti,panir', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()),DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, -1, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -1, GETDATE()),DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, -1, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Dum biryani,chapathi,roti,kaju', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()),DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, -1, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'france Biryani,Veg Biryani', 500.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()),DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, -1, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,Lolipop Biryani', 650.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()),DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, -1, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()),DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, -1, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()),DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, -1, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),DATEADD(MONTH, -1, GETDATE()),DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, -1, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Butter Non,paneer,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()),DATEADD(MONTH, -1, GETDATE()), DATEADD(MONTH, -1, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Maria martinez ordered this food order',NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,CurdRice', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -2, GETDATE()),DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -2, GETDATE()),DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Amount overdue',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'pulka,caju curruy,paneer,Egg Biryani', 800.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -2, GETDATE()),DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Dum biryani,chapathi,roti,kaju', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -2, GETDATE()),DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,Lolipop Biryani', 650.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -2, GETDATE()),DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -2, GETDATE()),DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -2, GETDATE()),DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -2, GETDATE()),DATEADD(MONTH, -2, GETDATE()), DATEADD(MONTH, -2, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Maria ordered the food', 'Food order details not seems to be fair', (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Chapathi,Roti,panir', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()),DATEADD(MONTH, -3, GETDATE()), DATEADD(MONTH, -3, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Maria martinez ordered this food order',NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,CurdRice', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -3, GETDATE()),DATEADD(MONTH, -3, GETDATE()), DATEADD(MONTH, -3, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()),DATEADD(MONTH, -3, GETDATE()), DATEADD(MONTH, -3, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Dum biryani,chapathi,roti,kaju', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()),DATEADD(MONTH, -3, GETDATE()), DATEADD(MONTH, -3, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'france Biryani,Veg Biryani', 500.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -3, GETDATE()),DATEADD(MONTH, -3, GETDATE()), DATEADD(MONTH, -3, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -3, GETDATE()),DATEADD(MONTH, -3, GETDATE()), DATEADD(MONTH, -3, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Curd Rice,bi,veg Biryani,Egg Biryani', 700.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()),DATEADD(MONTH, -3, GETDATE()), DATEADD(MONTH, -3, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()),DATEADD(MONTH, -3, GETDATE()), DATEADD(MONTH, -3, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),DATEADD(MONTH, -3, GETDATE()),DATEADD(MONTH, -3, GETDATE()), DATEADD(MONTH, -3, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Maria ordered the food', 'Food order details not seems to be fair', (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Chapathi,Roti,panir', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()),DATEADD(MONTH, -4, GETDATE()), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,Lolipop Biryani', 650.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -4, GETDATE()),DATEADD(MONTH, -4, GETDATE()), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -4, GETDATE()),DATEADD(MONTH, -4, GETDATE()), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Curd Rice,bi,veg Biryani,Egg Biryani', 700.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -4, GETDATE()),DATEADD(MONTH, -4, GETDATE()), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -4, GETDATE()),DATEADD(MONTH, -4, GETDATE()), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()),DATEADD(MONTH, -4, GETDATE()), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Butter Non,paneer,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()),DATEADD(MONTH, -4, GETDATE()), DATEADD(MONTH, -4, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Amount overdue',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'pulka,caju curruy,paneer,Egg Biryani', 800.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Dum biryani,chapathi,roti,kaju', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'france Biryani,Veg Biryani', 500.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,Lolipop Biryani', 650.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Curd Rice,bi,veg Biryani,Egg Biryani', 700.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Butter Non,paneer,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()),DATEADD(MONTH, -5, GETDATE()), DATEADD(MONTH, -5, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Maria ordered the food', 'Food order details not seems to be fair', (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Chapathi,Roti,panir', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()),DATEADD(MONTH, -6, GETDATE()), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Maria martinez ordered this food order',NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,CurdRice', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()),DATEADD(MONTH, -6, GETDATE()), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -6, GETDATE()),DATEADD(MONTH, -6, GETDATE()), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Amount overdue',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'pulka,caju curruy,paneer,Egg Biryani', 800.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -6, GETDATE()),DATEADD(MONTH, -6, GETDATE()), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -6, GETDATE()),DATEADD(MONTH, -6, GETDATE()), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Curd Rice,bi,veg Biryani,Egg Biryani', 700.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -6, GETDATE()),DATEADD(MONTH, -6, GETDATE()), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -6, GETDATE()),DATEADD(MONTH, -6, GETDATE()), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -6, GETDATE()),DATEADD(MONTH, -6, GETDATE()), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Butter Non,paneer,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -6, GETDATE()),DATEADD(MONTH, -6, GETDATE()), DATEADD(MONTH, -6, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Maria ordered the food', 'Food order details not seems to be fair', (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Chapathi,Roti,panir', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -7, GETDATE()),DATEADD(MONTH, -7, GETDATE()), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Maria martinez ordered this food order',NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,CurdRice', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -7, GETDATE()),DATEADD(MONTH, -7, GETDATE()), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -7, GETDATE()),DATEADD(MONTH, -7, GETDATE()), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Amount overdue',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'pulka,caju curruy,paneer,Egg Biryani', 800.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -7, GETDATE()),DATEADD(MONTH, -7, GETDATE()), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Dum biryani,chapathi,roti,kaju', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -7, GETDATE()),DATEADD(MONTH, -7, GETDATE()), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'france Biryani,Veg Biryani', 500.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -7, GETDATE()),DATEADD(MONTH, -7, GETDATE()), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,Lolipop Biryani', 650.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -7, GETDATE()),DATEADD(MONTH, -7, GETDATE()), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -7, GETDATE()),DATEADD(MONTH, -7, GETDATE()), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Curd Rice,bi,veg Biryani,Egg Biryani', 700.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -7, GETDATE()),DATEADD(MONTH, -7, GETDATE()), DATEADD(MONTH, -7, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Maria ordered the food', 'Food order details not seems to be fair', (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Chapathi,Roti,panir', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()),DATEADD(MONTH, -8, GETDATE()), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Maria martinez ordered this food order',NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,CurdRice', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -8, GETDATE()),DATEADD(MONTH, -8, GETDATE()), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()),DATEADD(MONTH, -8, GETDATE()), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Dum biryani,chapathi,roti,kaju', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()),DATEADD(MONTH, -8, GETDATE()), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'france Biryani,Veg Biryani', 500.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -8, GETDATE()),DATEADD(MONTH, -8, GETDATE()), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,Lolipop Biryani', 650.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()),DATEADD(MONTH, -8, GETDATE()), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()),DATEADD(MONTH, -8, GETDATE()), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()),DATEADD(MONTH, -8, GETDATE()), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()),DATEADD(MONTH, -8, GETDATE()), DATEADD(MONTH, -8, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -9, GETDATE()),DATEADD(MONTH, -9, GETDATE()), DATEADD(MONTH, -9, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Curd Rice,bi,veg Biryani,Egg Biryani', 700.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -9, GETDATE()),DATEADD(MONTH, -9, GETDATE()), DATEADD(MONTH, -9, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -9, GETDATE()),DATEADD(MONTH, -9, GETDATE()), DATEADD(MONTH, -9, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),DATEADD(MONTH, -9, GETDATE()),DATEADD(MONTH, -9, GETDATE()), DATEADD(MONTH, -9, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Butter Non,paneer,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -9, GETDATE()),DATEADD(MONTH, -9, GETDATE()), DATEADD(MONTH, -9, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Maria ordered the food', 'Food order details not seems to be fair', (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Chapathi,Roti,panir', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),DATEADD(MONTH, -10, GETDATE()),DATEADD(MONTH, -10, GETDATE()), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Maria martinez ordered this food order',NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,CurdRice', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -10, GETDATE()),DATEADD(MONTH, -10, GETDATE()), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -10, GETDATE()),DATEADD(MONTH, -10, GETDATE()), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Amount overdue',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'pulka,caju curruy,paneer,Egg Biryani', 800.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -10, GETDATE()),DATEADD(MONTH, -10, GETDATE()), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Dum biryani,chapathi,roti,kaju', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId), DATEADD(MONTH, -10, GETDATE()),DATEADD(MONTH, -10, GETDATE()), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'france Biryani,Veg Biryani', 500.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),DATEADD(MONTH, -10, GETDATE()),DATEADD(MONTH, -10, GETDATE()), DATEADD(MONTH, -10, GETDATE()), @UserId)

	,(NEWID(), @CompanyId, @UserId, 'Maria ordered the food', 'Food order details not seems to be fair', (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Chapathi,Roti,panir', 300.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'curdrice,bi', 200.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Amount overdue',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'pulka,caju curruy,paneer,Egg Biryani', 800.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Dum biryani,chapathi,roti,kaju', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'france Biryani,Veg Biryani', 500.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Veg Biryani,Lolipop Biryani', 650.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, 'Food order applied',NULL, (SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,paneer', 250.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Curd Rice,bi,veg Biryani,Egg Biryani', 700.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Roti,Pulka,paneer,kaju', 750.0000, @UserId,(SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, 'Employee limit crossed',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'chapathi,kaju,veg Biryani,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Rejected%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), @CompanyId, @UserId, NULL, NULL,(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId), N'Butter Non,paneer,Roti', 500.0000, @UserId, (SELECT Id FROM [FoodOrderStatus] WHERE [Status] LIKE '%Approved%' AND CompanyId = @CompanyId),  DATEADD(MONTH, -11, GETDATE()),DATEADD(MONTH, -11, GETDATE()), DATEADD(MONTH, -11, GETDATE()), @UserId)

)

AS Source ([Id], [CompanyId],[StatusSetByUserId],[Comment],[Reason],[CurrencyId], [FoodItemName], [Amount], [ClaimedByUserId], [FoodOrderStatusId], [OrderedDateTime], [StatusSetDateTime], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [FoodItemName] = source.[FoodItemName],
		   [Amount] = source.[Amount],
		   [StatusSetByUserId] = source.[StatusSetByUserId],
		   [Comment] = source.[Comment],
		   [Reason] = source.[Reason],
		   [CurrencyId] = Source.[CurrencyId],
		   [ClaimedByUserId] = Source.[ClaimedByUserId],
		   [FoodOrderStatusId] = source.[FoodOrderStatusId],
		   [OrderedDateTime] = source.[OrderedDateTime],
		   [StatusSetDateTime] = source.[StatusSetDateTime],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId],[StatusSetByUserId],[Comment],[Reason],[CurrencyId], [FoodItemName], [Amount], [ClaimedByUserId], [FoodOrderStatusId], [OrderedDateTime], [StatusSetDateTime], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId],[StatusSetByUserId],[Comment],[Reason],[CurrencyId], [FoodItemName], [Amount], [ClaimedByUserId], [FoodOrderStatusId], [OrderedDateTime], [StatusSetDateTime], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[FoodOrderUser] AS Target
USING ( VALUES
     (NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Chapathi,Roti,panir%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Butter Non,paneer,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,Lolipop Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%france Biryani,Veg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%pulka,caju curruy,paneer,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Curd Rice,bi,veg Biryani,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,CurdRice%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Dum biryani,chapathi,roti,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE, GETDATE())), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), @UserId)

	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Chapathi,Roti,panir%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -1, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Butter Non,paneer,Roti%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -1, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(MONTH, -1, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -1, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -1, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -1, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,Lolipop Biryani%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -1, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%france Biryani,Veg Biryani%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -1, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -1, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -1, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Dum biryani,chapathi,roti,kaju%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -1, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(MONTH, -1, GETDATE()), @UserId)

	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -2, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -2, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -2, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,Lolipop Biryani%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -2, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%pulka,caju curruy,paneer,Egg Biryani%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -2, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -2, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,CurdRice%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -2, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -2, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Dum biryani,chapathi,roti,kaju%' AND CompanyId = @CompanyId  AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -2, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -2, GETDATE()), @UserId)

	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Chapathi,Roti,panir%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -3, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -3, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -3, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -3, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%france Biryani,Veg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -3, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -3, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Curd Rice,bi,veg Biryani,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -3, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,CurdRice%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -3, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()), @UserId)
	 ,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Dum biryani,chapathi,roti,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -3, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -3, GETDATE()), @UserId)

	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Chapathi,Roti,panir%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -4, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Butter Non,paneer,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -4, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -4, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -4, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -4, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,Lolipop Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -4, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Curd Rice,bi,veg Biryani,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -4, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -4, GETDATE()), @UserId)

	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Butter Non,paneer,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,Lolipop Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%france Biryani,Veg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%pulka,caju curruy,paneer,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Curd Rice,bi,veg Biryani,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Dum biryani,chapathi,roti,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -5, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -5, GETDATE()), @UserId)

	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Chapathi,Roti,panir%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -6, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Butter Non,paneer,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -6, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -6, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -6, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -6, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%pulka,caju curruy,paneer,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -6, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -6, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Curd Rice,bi,veg Biryani,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -6, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,CurdRice%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -6, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -6, GETDATE()), @UserId)

	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Chapathi,Roti,panir%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -7, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -7, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,Lolipop Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -7, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%france Biryani,Veg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -7, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%pulka,caju curruy,paneer,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -7, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -7, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Curd Rice,bi,veg Biryani,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -7, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,CurdRice%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -7, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -7, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Dum biryani,chapathi,roti,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -7, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -7, GETDATE()), @UserId)

	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Chapathi,Roti,panir%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -8, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -8, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -8, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -8, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,Lolipop Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -8, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%france Biryani,Veg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -8, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -8, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,CurdRice%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -8, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -8, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Dum biryani,chapathi,roti,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -8, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(MONTH, -8, GETDATE()), @UserId)

	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Butter Non,paneer,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -9, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -9, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -9, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -9, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -9, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -9, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -9, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -9, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Curd Rice,bi,veg Biryani,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -9, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -9, GETDATE()), @UserId)

	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Chapathi,Roti,panir%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -10, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%france Biryani,Veg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -10, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%pulka,caju curruy,paneer,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -10, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -10, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,CurdRice%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -10, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -10, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Dum biryani,chapathi,roti,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -10, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -10, GETDATE()), @UserId)

	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Chapathi,Roti,panir%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Butter Non,paneer,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%chapathi,kaju,veg Biryani,Roti%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,Pulka,paneer,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Roti,paneer%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Veg Biryani,Lolipop Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%france Biryani,Veg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%pulka,caju curruy,paneer,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%curdrice,bi%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Curd Rice,bi,veg Biryani,Egg Biryani%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)
	,(NEWID(), (SELECT top 1 Id FROM FoodOrder WHERE FoodItemName LIKE '%Dum biryani,chapathi,roti,kaju%' AND CompanyId = @CompanyId AND CONVERT(DATE,OrderedDateTime) = CONVERT(DATE,DATEADD(MONTH, -11, GETDATE()))), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(MONTH, -11, GETDATE()), @UserId)

)

AS Source ([Id], [OrderId], [UserId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [OrderId] = Source.[OrderId],
		   [UserId] = source.[UserId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [OrderId], [UserId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [OrderId], [UserId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ReviewTemplate] AS Target
USING ( VALUES    
	    (NEWID(),  N'{"TemplateJson": ["Is any Loops or Cursors used ?", "Is any functions Used..?", "Weather follewed DB Guidelines ?"]}',(SELECT Id FROM UserStorySubType WHERE UserStorySubTypeName = 'API' AND CompanyId = @CompanyId), @CompanyId, GetDate(),@UserId),
		(NEWID(),  N'{"TemplateJson": ["Is Followed API Defination Contraints ?", "Is Alignment is Good..?", "Is It understandable for Developers ?"]}', (SELECT Id FROM UserStorySubType WHERE UserStorySubTypeName = 'UI' AND CompanyId = @CompanyId), @CompanyId, GetDate(), @UserId),
		(NEWID(),  N'{"TemplateJson": ["Is Followed UI  Defination Contraints ?", "Is Alignment is Good..?", "Is It understandable for  Developers ?"]}', (SELECT Id FROM UserStorySubType WHERE UserStorySubTypeName = 'DB' AND CompanyId = @CompanyId), @CompanyId, GetDate(),@UserId),
		(NEWID(),  N'{"TemplateJson": ["Is validations correct or Not.. ?", "Is Provided any security..?", "Weather  Flexibility Or Not ?"]}', (SELECT Id FROM UserStorySubType WHERE UserStorySubTypeName = 'UI definition' AND CompanyId = @CompanyId), @CompanyId, GetDate(),@UserId)
		)
AS Source ([Id], [TemplateJson], [UserStorySubTypeId], [CompanyId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [TemplateJson] = source.[TemplateJson],
		   [UserStorySubTypeId] = Source.[UserStorySubTypeId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]   	   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [TemplateJson], [UserStorySubTypeId], [CompanyId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [TemplateJson], [UserStorySubTypeId], [CompanyId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Merchant] AS Target
USING ( VALUES    
	    (NEWID(),@CompanyId, N'Maira',GetDate(), @UserId),
		(NEWID(),@CompanyId, N'James',GetDate(), @UserId),
		(NEWID(),@CompanyId, N'David',GetDate(), @UserId),
		(NEWID(),@CompanyId, N'Ani',GetDate(), @UserId),
		(NEWID(),@CompanyId, N'William',GetDate(), @UserId),
		(NEWID(),@CompanyId, N'Robert',GetDate(), @UserId),
		(NEWID(),@CompanyId, N'Gracia',GetDate(), @UserId)
)
AS Source ([Id],CompanyId, [MerchantName] ,[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
		   [MerchantName] = source.[MerchantName],
		   CompanyId = source.CompanyId,	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]   	   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id],CompanyId,[MerchantName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id],CompanyId,[MerchantName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseReport] AS Target
USING ( VALUES    
	    (NEWID(),  N'Test',N'Software ',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),(SELECT Id FROM ExpenseReportStatus WHERE [Name] LIKE '%Achived%' AND CompanyId = @CompanyId),10000,5000, 0,0,GetDate(), @UserId),
		(NEWID(),  N'test1',N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),(SELECT Id FROM ExpenseReportStatus WHERE [Name] LIKE '%Submitted%' AND CompanyId = @CompanyId),10000,10000,0,0,GetDate(), @UserId),
		(NEWID(),  N'Test3', N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),(SELECT Id FROM ExpenseReportStatus WHERE [Name] LIKE '%Approved%' AND CompanyId = @CompanyId),10000,20000,0,0,GetDate(), @UserId),
		(NEWID(),  N'Test2',N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),(SELECT Id FROM ExpenseReportStatus WHERE [Name] LIKE '%Rejected%' AND CompanyId = @CompanyId),10000,50000,0,0,GetDate(), @UserId),
		(NEWID(),  N'test5',N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),(SELECT Id FROM ExpenseReportStatus WHERE [Name] LIKE '%Reimbursed%' AND CompanyId = @CompanyId),10000,0,    0,0,GetDate(), @UserId)
		)
AS Source ([Id], [ReportTitle], [BusinessPurpose],[DurationFrom],[DurationTo],[ReportStatusId],[AdvancePayment],[AmountToBeReimbursed],[IsReimbursed],[UndoReimbursement],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [ReportTitle] = Source.[ReportTitle],
		   [BusinessPurpose] = source.[BusinessPurpose],	   
		   [DurationFrom] = source.[DurationFrom],
		   [DurationTo] = source.[DurationTo],
		   [ReportStatusId] = source.[ReportStatusId],
		   [AdvancePayment] = source.[AdvancePayment],
		   [AmountToBeReimbursed] = source.[AmountToBeReimbursed],
		   [IsReimbursed] = source.[IsReimbursed],
		   [UndoReimbursement] = source.[UndoReimbursement],	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]   	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [ReportTitle], [BusinessPurpose],[DurationFrom],[DurationTo],[ReportStatusId],[AdvancePayment],[AmountToBeReimbursed],[IsReimbursed],[UndoReimbursement],[CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [ReportTitle], [BusinessPurpose],[DurationFrom],[DurationTo],[ReportStatusId],[AdvancePayment],[AmountToBeReimbursed],[IsReimbursed],[UndoReimbursement],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Mode] AS Target
USING ( VALUES    
  (NEWID(),@Companyid, N'COD', GetDate(), @UserId)
 ,(NEWID(),@Companyid, N'Payment',GetDate(), @UserId)
  )
AS Source  ([Id], [CompanyId], [ModeName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
		   [CompanyId] = source.[CompanyId],
		   [ModeName] = source.[ModeName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]     	   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [ModeName], [CreatedDateTime], [CreatedByUserId]) VALUES   ([Id], [CompanyId], [ModeName], [CreatedDateTime], [CreatedByUserId]);

--Expenses & Invoices
MERGE INTO [dbo].[Expense] AS Target
USING ( VALUES    
	    (NEWID(),(SELECT Id FROM Branch WHERE BranchName LIKE '%Birmingham%' AND CompanyId = @CompanyId), N'Office Expenses',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT Id FROM PaymentStatus WHERE PaymentStatus LIKE '%Success%' AND CompanyId = @CompanyId),@UserId,NULL,(SELECT Id FROM ExpenseStatus WHERE [Name] LIKE '%Approved%'),NULL,0,GetDate(),GetDate(),GetDate(), @UserId,@CompanyId,1),
		(NEWID(),(SELECT Id FROM Branch WHERE BranchName LIKE '%Birmingham%' AND CompanyId = @CompanyId), N'Canteen purchases',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT Id FROM PaymentStatus WHERE PaymentStatus LIKE '%Fail%' AND CompanyId = @CompanyId),@UserId,NULL,(SELECT Id FROM ExpenseStatus WHERE [Name] LIKE '%Pending%'),NULL,0,GetDate(),GetDate(),GetDate(), @UserId,@CompanyId,2),
		(NEWID(),(SELECT Id FROM Branch WHERE BranchName LIKE '%Birmingham%' AND CompanyId = @CompanyId), N'Furniture',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT Id FROM PaymentStatus WHERE PaymentStatus LIKE '%Pending%' AND CompanyId = @CompanyId),@UserId,NULL,(SELECT Id FROM ExpenseStatus WHERE [Name] LIKE '%Rejected%'),NULL,1,GetDate(),GetDate(),GetDate(), @UserId,@CompanyId,3),
		(NEWID(),(SELECT Id FROM Branch WHERE BranchName LIKE '%Birmingham%' AND CompanyId = @CompanyId), N'Off campus drive',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT Id FROM PaymentStatus WHERE PaymentStatus LIKE '%Success%' AND CompanyId = @CompanyId),@UserId,NULL,(SELECT Id FROM ExpenseStatus WHERE [Name] LIKE '%Approved%'),NULL,0,GetDate(),GetDate(),GetDate(), @UserId,@CompanyId,4),
		(NEWID(),(SELECT Id FROM Branch WHERE BranchName LIKE '%Birmingham%' AND CompanyId = @CompanyId), N'Travel expenses',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT Id FROM PaymentStatus WHERE PaymentStatus LIKE '%Pending%' AND CompanyId = @CompanyId),@UserId,NULL,(SELECT Id FROM ExpenseStatus WHERE [Name] LIKE '%Rejected%'),NULL,1,GetDate(),GetDate(),GetDate(), @UserId,@CompanyId,5),
		(NEWID(),(SELECT Id FROM Branch WHERE BranchName LIKE '%Birmingham%' AND CompanyId = @CompanyId), N'Software purchase',(SELECT Id FROM Currency WHERE CurrencyName LIKE '%Euro%' AND CompanyId = @CompanyId),(SELECT Id FROM PaymentStatus WHERE PaymentStatus LIKE '%Fail%' AND CompanyId = @CompanyId),@UserId,NULL,(SELECT Id FROM ExpenseStatus WHERE [Name] LIKE '%Approved%'),NULL,0,GetDate(),GetDate(),GetDate(), @UserId,@CompanyId,6)
		)
AS Source ([Id],[BranchId],[ExpenseName],[CurrencyId],[PaymentStatusId],[ClaimedByUserId],[CashPaidThroughId],[ExpenseStatusId],[BillReceiptId],[ClaimReimbursement],[ReceiptDate],[ExpenseDate],[CreatedDateTime], [CreatedByUserId],[CompanyId],[ExpenseNumber])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
            [ExpenseName] = Source.[ExpenseName],
		    [CurrencyId] = Source.[CurrencyId],
		    [PaymentStatusId] = source.[PaymentStatusId],
			[ClaimedByUserId] = source.[ClaimedByUserId],
			[CashPaidThroughId] = source.[CashPaidThroughId],
			[ExpenseStatusId] = source.[ExpenseStatusId],
			--[MerchantId] = source.[MerchantId],
			[BillReceiptId] = source.[BillReceiptId],
			[ClaimReimbursement] = Source.[ClaimReimbursement],
			[ReceiptDate] = Source.[ReceiptDate],
			[CompanyId] = Source.[CompanyId],
            [CreatedDateTime] = Source.[CreatedDateTime],
            [CreatedByUserId] = Source.[CreatedByUserId],
			[BranchId] = Source.[BranchId],
			[ExpenseNumber] = Source.[ExpenseNumber]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id],[BranchId], [ExpenseName],[CurrencyId],[PaymentStatusId],[ClaimedByUserId],[CashPaidThroughId],[ExpenseStatusId],[BillReceiptId],[ClaimReimbursement],[ReceiptDate],[ExpenseDate],[CreatedDateTime], [CreatedByUserId],[CompanyId],[ExpenseNumber]) 
VALUES([Id],[BranchId], [ExpenseName],[CurrencyId],[PaymentStatusId],[ClaimedByUserId],[CashPaidThroughId],[ExpenseStatusId],[BillReceiptId],[ClaimReimbursement],[ReceiptDate],[ExpenseDate],[CreatedDateTime], [CreatedByUserId],[CompanyId],[ExpenseNumber]);

MERGE INTO [dbo].[ExpenseCategoryConfiguration] AS Target
USING ( VALUES    
	    (NEWID(), N'Office Expenses',(SELECT Id FROM Merchant WHERE MerchantName LIKE '%Maira%' AND CompanyId = @CompanyId),(SELECT Id FROM Expense WHERE ExpenseName LIKE '%Office Expenses%' AND CompanyId = @CompanyId),(SELECT Id FROM ExpenseCategory WHERE CategoryName LIKE '%Office Supplies%' AND CompanyId = @CompanyId),N'Office Expenses',10000,GetDate(), @UserId),
		(NEWID(), N'Canteen purchases',(SELECT Id FROM Merchant WHERE MerchantName LIKE '%James%' AND CompanyId = @CompanyId),(SELECT Id FROM Expense WHERE ExpenseName LIKE '%Canteen purchases%' AND CompanyId = @CompanyId),(SELECT Id FROM ExpenseCategory WHERE CategoryName LIKE '%Other Expenses%' AND CompanyId = @CompanyId),N'Canteen purchases',5000,GetDate(), @UserId),
		(NEWID(), N'Furniture',(SELECT Id FROM Merchant WHERE MerchantName LIKE '%David%' AND CompanyId = @CompanyId),(SELECT Id FROM Expense WHERE ExpenseName LIKE '%Furniture%' AND CompanyId = @CompanyId),(SELECT Id FROM ExpenseCategory WHERE CategoryName LIKE '%Office Supplies%' AND CompanyId = @CompanyId),N'Furniture',15000,GetDate(), @UserId),
		(NEWID(), N'Off campus drive',(SELECT Id FROM Merchant WHERE MerchantName LIKE '%William%' AND CompanyId = @CompanyId),(SELECT Id FROM Expense WHERE ExpenseName LIKE '%Off campus drive%' AND CompanyId = @CompanyId),(SELECT Id FROM ExpenseCategory WHERE CategoryName LIKE '%Other Expenses%' AND CompanyId = @CompanyId),N'Off campus drive',500000,GetDate(), @UserId),
		(NEWID(), N'Travel expenses',(SELECT Id FROM Merchant WHERE MerchantName LIKE '%Robert%' AND CompanyId = @CompanyId),(SELECT Id FROM Expense WHERE ExpenseName LIKE '%Travel expenses%' AND CompanyId = @CompanyId),(SELECT Id FROM ExpenseCategory WHERE CategoryName LIKE '%Other Expenses%' AND CompanyId = @CompanyId),N'Travel expenses',10000,GetDate(), @UserId),
		(NEWID(), N'Software purchase',(SELECT Id FROM Merchant WHERE MerchantName LIKE '%Gracia%' AND CompanyId = @CompanyId),(SELECT Id FROM Expense WHERE ExpenseName LIKE '%Software purchase%' AND CompanyId = @CompanyId),(SELECT Id FROM ExpenseCategory WHERE CategoryName LIKE '%IT and Internet Expenses%' AND CompanyId = @CompanyId),N'Software purchase',20000,GetDate(), @UserId)
		)
AS Source ([Id],[ExpenseCategoryName],[MerchantId],[ExpenseId],[ExpenseCategoryId],[Description],[Amount],[CreatedDateTime],[CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
            [ExpenseId] = Source.[ExpenseId],
		    [ExpenseCategoryId] = Source.[ExpenseCategoryId],
			[ExpensecategoryName] = Source.ExpenseCategoryName,
			MerchantId = Source.MerchantId,
		    [Description] = source.[Description],
			[Amount] = source.[Amount],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]  	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id],[ExpenseCategoryName],[MerchantId],[ExpenseId],[ExpenseCategoryId],[Description],[Amount],[CreatedDateTime], [CreatedByUserId]) 
VALUES([Id],[ExpenseCategoryName],[MerchantId],[ExpenseId],[ExpenseCategoryId],[Description],[Amount],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseHistory] AS Target
USING ( VALUES    
	    (NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Office Expenses%' AND CompanyId = @CompanyId),  NULL,N'ExpenseAdded',N'ExpenseAdded',N'Office Expenses',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Canteen purchases%' AND CompanyId = @CompanyId),NULL,N'ExpenseAdded',N'ExpenseAdded',N'Canteen purchases',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Furniture%' AND CompanyId = @CompanyId),        NULL,N'ExpenseAdded',N'ExpenseAdded',N'Furniture',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Off campus drive%' AND CompanyId = @CompanyId), NULL,N'ExpenseAdded',N'ExpenseAdded',N'Off campus drive',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Travel expenses%' AND CompanyId = @CompanyId),  NULL,N'ExpenseAdded',N'ExpenseAdded',N'Travel expenses',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Software purchase%' AND CompanyId = @CompanyId),NULL,N'ExpenseAdded',N'ExpenseAdded',N'Software purchase',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Furniture%' AND CompanyId = @CompanyId),N'Pending',N'ExpenseStatus',N'ExpenseStatusChanged',N'Rejected',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Off campus drive%' AND CompanyId = @CompanyId),N'Pending',N'ExpenseStatus',N'ExpenseStatusChanged',N'Approved',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Office Expenses%' AND CompanyId = @CompanyId),N'Pending',N'ExpenseStatus',N'ExpenseStatusChanged',N'Approved',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Travel expenses%' AND CompanyId = @CompanyId),N'Pending',N'ExpenseStatus',N'ExpenseStatusChanged',N'Rejected',GetDate(), @UserId),
		(NEWID(), (SELECT Id FROM Expense WHERE ExpenseName LIKE '%Software purchase%' AND CompanyId = @CompanyId),N'Pending',N'ExpenseStatus',N'ExpenseStatusChanged',N'Approved',GetDate(), @UserId)
		)
AS Source ([Id],[ExpenseId],[OldValue],[FieldName],[Description],[NewValue],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
            [ExpenseId] = Source.[ExpenseId],
		    [OldValue] = Source.[OldValue],
		    [NewValue] = Source.[NewValue],
		    [FieldName] = Source.[FieldName],
		    [Description] = source.[Description],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]  	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id],[ExpenseId],[OldValue],[NewValue],[FieldName],[Description],[CreatedDateTime], [CreatedByUserId]) 
VALUES([Id],[ExpenseId],[OldValue],[NewValue],[FieldName],[Description],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Customer] AS Target
USING ( VALUES    
	    (NEWID(),@CompanyId,  N'Danielle', N'd@'+@CompanyName+'.com ',N'Ongole',NULL,N'AP',(SELECT Id FROM [dbo].[State] WHERE [StateName] = N'Andhra Pradesh' AND [CompanyId] = @CompanyId),(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId),515001,123456,NULL,GetDate(), @UserId),
		(NEWID(),@CompanyId,  N'Selena',N'g@'+@CompanyName+'.com', N'Ongole',NULL,N'AP',(SELECT Id FROM [dbo].[State] WHERE [StateName] = N'Andhra Pradesh' AND [CompanyId] = @CompanyId),(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId),515001,123456,NULL,GetDate(), @UserId),
		(NEWID(),@CompanyId,  N'Kate',N's@'+@CompanyName+'.com' ,N'Ongole',NULL,N'AP',(SELECT Id FROM [dbo].[State] WHERE [StateName] = N'Andhra Pradesh' AND [CompanyId] = @CompanyId),(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId),515001,123456,NULL,GetDate(), @UserId),
		(NEWID(),@CompanyId,  N'Harry',N'h@'+@CompanyName+'.com', N'Ongole',NULL,N'AP',(SELECT Id FROM [dbo].[State] WHERE [StateName] = N'Andhra Pradesh' AND [CompanyId] = @CompanyId),(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId),515001,123456,NULL,GetDate(), @UserId),
		(NEWID(),@CompanyId,  N'Charles',N'T@'+@CompanyName+'.com ',N'Ongole',NULL,N'AP',(SELECT Id FROM [dbo].[State] WHERE [StateName] = N'Andhra Pradesh' AND [CompanyId] = @CompanyId),(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId),515001,123456,NULL,GetDate(), @UserId)
)
AS Source ([Id], [CompanyId], [CustomerName],[ContactEmail],[AddressLine1],[AddressLine2],[City],[StateId],[CountryId],[PostalCode],[MobileNumber],[Notes],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [CustomerName] = source.[CustomerName],	   
		    [ContactEmail] = source.[ContactEmail],
			[AddressLine1] = source.[AddressLine1],
			[AddressLine2] = source.[AddressLine2],
			[City] = source.[City],
			[StateId] = source.[StateId],
			[CountryId] = source.[CountryId],
			[PostalCode] = source.[PostalCode],
			[MobileNumber] = source.[MobileNumber],
			[Notes] = source.[Notes],	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		       	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [CustomerName],[ContactEmail],[AddressLine1],[AddressLine2],[City],[StateId],[CountryId],[PostalCode],[MobileNumber],[Notes],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [CustomerName],[ContactEmail],[AddressLine1],[AddressLine2],[City],[StateId],[CountryId],[PostalCode],[MobileNumber],[Notes],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceType] AS Target
USING ( VALUES    
 (NEWID(), @CompanyId, N'Credit memo', GetDate(), @UserId)
,(NEWID(), @CompanyId, N'ast due invoice', GetDate(), @UserId)
,(NEWID(), @CompanyId, N'Interim invoice', GetDate(), @UserId)
,(NEWID(), @CompanyId, N'Recurring invoice', GetDate(), @UserId)
,(NEWID(), @CompanyId, N'Final invoice', GetDate(), @UserId)
,(NEWID(), @CompanyId, N'Pro forma invoice', GetDate(), @UserId)
)
AS Source ([Id], [CompanyId], [InvoiceTypeName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [CompanyId]      = source.[CompanyId],	   
		   [InvoiceTypeName] = Source.[InvoiceTypeName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]  	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [InvoiceTypeName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [InvoiceTypeName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Invoice] AS Target
USING ( VALUES    
	  (NEWID(), @CompanyId, N'Pictures', (SELECT Id FROM Customer WHERE CustomerName LIKE '%Danielle%' AND CompanyId = @CompanyId), (SELECT Id FROM Project WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceType WHERE InvoiceTypeName LIKE '%Credit memo%' AND CompanyId = @CompanyId), N'123', GetDate(), GetDate(), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, GetDate(), @UserId)
	, (NEWID(), @CompanyId, N'Pictures', (SELECT Id FROM Customer WHERE CustomerName LIKE '%Kate%' AND CompanyId = @CompanyId),     (SELECT Id FROM Project WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceType WHERE InvoiceTypeName LIKE '%ast due invoice%' AND CompanyId = @CompanyId), N'123', GetDate(), GetDate(), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, GetDate(), @UserId)
	, (NEWID(), @CompanyId, N'Pictures', (SELECT Id FROM Customer WHERE CustomerName LIKE '%Harry%' AND CompanyId = @CompanyId),    (SELECT Id FROM Project WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceType WHERE InvoiceTypeName LIKE '%Interim invoice%' AND CompanyId = @CompanyId), N'123', GetDate(), GetDate(), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, GetDate(), @UserId)
	, (NEWID(), @CompanyId, N'Pictures', (SELECT Id FROM Customer WHERE CustomerName LIKE '%Selena%' AND CompanyId = @CompanyId),   (SELECT Id FROM Project WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceType WHERE InvoiceTypeName LIKE '%Recurring invoice%' AND CompanyId = @CompanyId), N'123', GetDate(), GetDate(), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, GetDate(), @UserId)
	, (NEWID(), @CompanyId, N'Pictures', (SELECT Id FROM Customer WHERE CustomerName LIKE '%Charles%' AND CompanyId = @CompanyId),  (SELECT Id FROM Project WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceType WHERE InvoiceTypeName LIKE '%Final invoice%' AND CompanyId = @CompanyId), N'123', GetDate(), GetDate(), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, GetDate(), @UserId)
	, (NEWID(), @CompanyId, N'Pictures', (SELECT Id FROM Customer WHERE CustomerName LIKE '%Danielle%' AND CompanyId = @CompanyId), (SELECT Id FROM Project WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceType WHERE InvoiceTypeName LIKE '%Pro forma invoice%' AND CompanyId = @CompanyId), N'123', GetDate(), GetDate(), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, GetDate(), @UserId)	
)
AS Source ([Id], [CompanyId], [CompnayLogo], [BillToCustomerId], [ProjectId], [InvoiceTypeId], [InvoiceNumber], [Date], [DueDate], [Discount], [Notes], [Terms], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [CompnayLogo] = source.[CompnayLogo],	   
		    [BillToCustomerId] = source.[BillToCustomerId],
			[ProjectId] = source.[ProjectId],
			[InvoiceTypeId] = source.[InvoiceTypeId],
			[InvoiceNumber]= source.[InvoiceNumber],
			[Date] = source.[Date],
			[DueDate] = source.[DueDate],
			[Discount] = source.[Discount],
			[Notes] = source.[Notes],
			[Terms] = source.[Terms],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		      	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [CompnayLogo], [BillToCustomerId], [ProjectId], [InvoiceTypeId], [InvoiceNumber], [Date], [DueDate], [Discount], [Notes], [Terms], [CreatedDateTime], [CreatedByUserId])VALUES ([Id], [CompanyId], [CompnayLogo], [BillToCustomerId], [ProjectId], [InvoiceTypeId], [InvoiceNumber], [Date], [DueDate], [Discount], [Notes], [Terms], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceCategory] AS Target
USING ( VALUES    
	 (NEWID(), @CompanyId, N'Progress Invoice', GetDate(), @UserId)
	,(NEWID(), @CompanyId, N'Standard Invoice', GetDate(), @UserId)
	,(NEWID(), @CompanyId, N'Commercial Invoice', GetDate(), @UserId)
	,(NEWID(), @CompanyId, N'Recurring Invoice', GetDate(), @UserId)
	,(NEWID(), @CompanyId, N'Pending Invoice', GetDate(), @UserId)
	,(NEWID(), @CompanyId, N'Timesheet', GetDate(), @UserId)
)
AS Source ([Id], [CompanyId], [InvoiceCategoryName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = source.[CompanyId],	   
		   [InvoiceCategoryName] = Source.[InvoiceCategoryName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]  	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [InvoiceCategoryName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [InvoiceCategoryName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceItem] AS Target
USING ( VALUES    
	  (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Credit memo%' AND IT.CompanyId = @CompanyId),       N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%COD%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Progress Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%ast due invoice%' AND IT.CompanyId = @CompanyId),   N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%Payment%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Standard Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Interim invoice%' AND IT.CompanyId = @CompanyId),   N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%COD%' AND CompanyId = @CompanyId),(SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Commercial Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Recurring invoice%' AND IT.CompanyId = @CompanyId), N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%Payment%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Recurring Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Credit memo%' AND IT.CompanyId = @CompanyId),       N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%COD%' AND CompanyId = @CompanyId),(SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Timesheet%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Pro forma invoice%' AND IT.CompanyId = @CompanyId), N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%Payment%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Progress Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%ast due invoice%' AND IT.CompanyId = @CompanyId),   N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%Payment%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Commercial Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Credit memo%' AND IT.CompanyId = @CompanyId),       N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%COD%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Recurring Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Final invoice%' AND IT.CompanyId = @CompanyId),     N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%COD%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Pending Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Pro forma invoice%' AND IT.CompanyId = @CompanyId), N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%Payment%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Recurring Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Credit memo%' AND IT.CompanyId = @CompanyId),       N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%COD%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Timesheet%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Interim invoice%' AND IT.CompanyId = @CompanyId),   N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%COD%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Commercial Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Final invoice%' AND IT.CompanyId = @CompanyId),     N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%Payment%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Pending Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Recurring invoice%' AND IT.CompanyId = @CompanyId), N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%Payment%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Standard Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%ast due invoice%' AND IT.CompanyId = @CompanyId),   N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', (SELECT Id FROM Mode WHERE ModeName LIKE '%COD%' AND CompanyId = @CompanyId), (SELECT Id FROM InvoiceCategory WHERE InvoiceCategoryName LIKE '%Progress Invoice%' AND CompanyId = @CompanyId), N'Specifies', GetDate(), @UserId)
)
AS Source ([Id], [InvoiceId], [DisplayName], [Description], [Price], [SKU], [Group], [ModeId], [InvoiceCategoryId], [Notes], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [InvoiceId] = source.[InvoiceId],
		   [DisplayName] = source.[DisplayName],	
		   [Description] = source.[Description],	
		   [Price] = source.[Price],	
		   [SKU] = source.[SKU],	
		   [Group] = source.[Group],	
		   [ModeId] = source.[ModeId],	
		   [InvoiceCategoryId] = source.[InvoiceCategoryId],		   
		   [Notes] = Source.[Notes],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]  
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [InvoiceId], [DisplayName], [Description], [Price], [SKU], [Group], [ModeId], [InvoiceCategoryId], [Notes], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [InvoiceId], [DisplayName], [Description], [Price], [SKU], [Group], [ModeId], [InvoiceCategoryId], [Notes], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[PaymentType] AS Target
USING ( VALUES    
 (NEWID(), @CompanyId, N'PayTm', GetDate(), @UserId)
,(NEWID(), @CompanyId, N'OnlineBanking', GetDate(), @UserId)
,(NEWID(), @CompanyId, N'ATM', GetDate(), @UserId)
)
AS Source ([Id], [CompanyId], [PaymentTypeName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = source.[CompanyId],
		   [PaymentTypeName] = source.[PaymentTypeName],	
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId] 	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [PaymentTypeName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [PaymentTypeName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Payment] AS Target
USING ( VALUES    
	  (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Credit memo%' AND IT.CompanyId = @CompanyId),      (SELECT Id FROM PaymentType WHERE PaymentTypeName LIKE '%PayTm%' AND CompanyId = @CompanyId), GetDate(), CAST(10000.00000 AS Numeric(10, 5)), N'Test', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%ast due invoice%' AND IT.CompanyId = @CompanyId),  (SELECT Id FROM PaymentType WHERE PaymentTypeName LIKE '%OnlineBanking%' AND CompanyId = @CompanyId), GetDate(), CAST(10000.00000 AS Numeric(10, 5)), N'Test', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Interim invoice%' AND IT.CompanyId = @CompanyId),  (SELECT Id FROM PaymentType WHERE PaymentTypeName LIKE '%ATM%' AND CompanyId = @CompanyId), GetDate(), CAST(10000.00000 AS Numeric(10, 5)), N'Test', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Recurring invoice%' AND IT.CompanyId = @CompanyId),(SELECT Id FROM PaymentType WHERE PaymentTypeName LIKE '%PayTm%' AND CompanyId = @CompanyId), GetDate(), CAST(10000.00000 AS Numeric(10, 5)), N'Test', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Pro forma invoice%' AND IT.CompanyId = @CompanyId),(SELECT Id FROM PaymentType WHERE PaymentTypeName LIKE '%ATM%' AND CompanyId = @CompanyId), GetDate(), CAST(10000.00000 AS Numeric(10, 5)), N'Test', GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Final invoice%' AND IT.CompanyId = @CompanyId),    (SELECT Id FROM PaymentType WHERE PaymentTypeName LIKE '%ATM%' AND CompanyId = @CompanyId), GetDate(), CAST(10000.00000 AS Numeric(10, 5)), N'Test', GetDate(), @UserId)
)
AS Source  ([Id], [InvoiceId], [PaymentTypeId], [Date], [Amount], [Notes], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [InvoiceId] = source.[InvoiceId],
		   [PaymentTypeId] = source.[PaymentTypeId],
		   [Date] = source.[Date],
		   [Amount] = source.[Amount],
		   [Notes] = source.[Notes],	
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]  	   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [InvoiceId], [PaymentTypeId], [Date], [Amount], [Notes], [CreatedDateTime], [CreatedByUserId]) VALUES   ([Id], [InvoiceId], [PaymentTypeId], [Date], [Amount], [Notes], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceTask] AS Target
USING ( VALUES   
	  (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Credit memo%' AND IT.CompanyId = @CompanyId),      N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%ast due invoice%' AND IT.CompanyId = @CompanyId),  N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Interim invoice%' AND IT.CompanyId = @CompanyId),  N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Recurring invoice%' AND IT.CompanyId = @CompanyId),N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Credit memo%' AND IT.CompanyId = @CompanyId),      N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Pro forma invoice%' AND IT.CompanyId = @CompanyId),N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%ast due invoice%' AND IT.CompanyId = @CompanyId),  N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Credit memo%' AND IT.CompanyId = @CompanyId),      N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Final invoice%' AND IT.CompanyId = @CompanyId),    N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Pro forma invoice%' AND IT.CompanyId = @CompanyId),N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Credit memo%' AND IT.CompanyId = @CompanyId),      N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Interim invoice%' AND IT.CompanyId = @CompanyId),  N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
	, (NEWID(), (SELECT I.Id FROM Invoice I JOIN InvoiceType IT ON IT.Id = I.InvoiceTypeId WHERE InvoiceTypeName LIKE '%Final invoice%' AND IT.CompanyId = @CompanyId),    N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, GetDate(), @UserId)
)
AS Source  ([Id], [InvoiceId], [Task], [Rate], [Hours], [Item], [Price], [Quantity], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [InvoiceId] = source.[InvoiceId],
		   [Task] = source.[Task],
		   [Rate] = source.[Rate],
		   [Hours] = source.[Hours],
		   [Item] = source.[Item],
		   [Price] = source.[Price],
		   [Quantity] = source.[Quantity],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [InvoiceId], [Task], [Rate], [Hours], [Item], [Price], [Quantity], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [InvoiceId], [Task], [Rate], [Hours], [Item], [Price], [Quantity], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Client] AS Target 
USING ( VALUES
		(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'Maria@'+@CompanyName+'.com' AND CompanyId = @CompanyId), @CompanyId, @CompanyName, GETDATE(), @UserId),
		(NEWID(), (SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com' AND CompanyId = @CompanyId), @CompanyId, @CompanyName, GETDATE(), @UserId)
) 
AS Source ([Id], [UserId], [CompanyId], [CompanyName], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [UserId] = Source.[UserId],
		   [CompanyId] = Source.[CompanyId],
           [CompanyName] = Source.[CompanyName],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CreatedDateTime] = Source.[CreatedDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [UserId], [CompanyId], [CompanyName], [CreatedDateTime], [CreatedByUserId])
VALUES ([Id], [UserId], [CompanyId], [CompanyName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Invoice_New] AS Target 
USING ( VALUES
		(NEWID(), (SELECT C.Id FROM [User] U JOIN [Client] C ON C.UserId = U.Id WHERE U.UserName =  N'Maria@'+@CompanyName+'.com' AND U.CompanyId = @CompanyId), (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'United States Dollar' AND CompanyId = @CompanyId), '1111', (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Draft' AND CompanyId = @CompanyId), GETDATE(), 0, 0, 0, 0, @CompanyId, GETDATE(), @UserId),
		(NEWID(), (SELECT C.Id FROM [User] U JOIN [Client] C ON C.UserId = U.Id WHERE U.UserName =  N'James@'+@CompanyName+'.com' AND U.CompanyId = @CompanyId), (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Pound sterling' AND CompanyId = @CompanyId), '1112', (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Draft' AND CompanyId = @CompanyId), GETDATE(), 0, 0, 0, 0, @CompanyId, GETDATE(), @UserId),
		(NEWID(), (SELECT C.Id FROM [User] U JOIN [Client] C ON C.UserId = U.Id WHERE U.UserName =  N'Maria@'+@CompanyName+'.com' AND U.CompanyId = @CompanyId), (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId), '1113', (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Draft' AND CompanyId = @CompanyId), GETDATE(), 0, 0, 0, 0, @CompanyId, GETDATE(), @UserId)
) 
AS Source ([Id], [ClientId], [CurrencyId], [InvoiceNumber], [InvoiceStatusId], [IssueDate], [TotalAmount], [SubTotalAmount], [Discount], [DiscountAmount], [CompanyId], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [ClientId] = Source.[ClientId],
		   [CurrencyId] = Source.[CurrencyId],
           [InvoiceNumber] = Source.[InvoiceNumber],
           [InvoiceStatusId] = Source.[InvoiceStatusId],
           [IssueDate] = Source.[IssueDate],
           [TotalAmount] = Source.[TotalAmount],
           [SubTotalAmount] = Source.[SubTotalAmount],
           [Discount] = Source.[Discount],
           [DiscountAmount] = Source.[DiscountAmount],
           [CompanyId] = Source.[CompanyId],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CreatedDateTime] = Source.[CreatedDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [ClientId], [CurrencyId], [InvoiceNumber], [InvoiceStatusId], [IssueDate], [TotalAmount], [SubTotalAmount], [Discount], [DiscountAmount], [CompanyId], [CreatedDateTime], [CreatedByUserId])
VALUES ([Id], [ClientId], [CurrencyId], [InvoiceNumber], [InvoiceStatusId], [IssueDate], [TotalAmount], [SubTotalAmount], [Discount], [DiscountAmount], [CompanyId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceHistory] AS Target 
USING ( VALUES
		(NEWID(), (SELECT Id FROM [Invoice_New] WHERE InvoiceNumber = '1111' AND CompanyId = @CompanyId), NULL, '1111', 'InvoiceAdded', GETDATE(), @UserId),
		(NEWID(), (SELECT Id FROM [Invoice_New] WHERE InvoiceNumber = '1112' AND CompanyId = @CompanyId), NULL, '1112', 'InvoiceAdded', GETDATE(), @UserId),
		(NEWID(), (SELECT Id FROM [Invoice_New] WHERE InvoiceNumber = '1113' AND CompanyId = @CompanyId), NULL, '1113', 'InvoiceAdded', GETDATE(), @UserId)
) 
AS Source ([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [InvoiceId] = Source.[InvoiceId],
		   [OldValue] = Source.[OldValue],
           [NewValue] = Source.[NewValue],
           [Description] = Source.[Description],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CreatedDateTime] = Source.[CreatedDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
VALUES ([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Estimate] AS Target 
USING ( VALUES
		(NEWID(), (SELECT C.Id FROM [User] U JOIN [Client] C ON C.UserId = U.Id WHERE U.UserName =  N'Maria@'+@CompanyName+'.com' AND U.CompanyId = @CompanyId), (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'United States Dollar' AND CompanyId = @CompanyId), '2222', (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Draft' AND CompanyId = @CompanyId), GETDATE(), 0, 0, 0, 0, @CompanyId, GETDATE(), @UserId),
		(NEWID(), (SELECT C.Id FROM [User] U JOIN [Client] C ON C.UserId = U.Id WHERE U.UserName =  N'James@'+@CompanyName+'.com' AND U.CompanyId = @CompanyId), (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Pound sterling' AND CompanyId = @CompanyId), '2223', (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Draft' AND CompanyId = @CompanyId), GETDATE(), 0, 0, 0, 0, @CompanyId, GETDATE(), @UserId),
		(NEWID(), (SELECT C.Id FROM [User] U JOIN [Client] C ON C.UserId = U.Id WHERE U.UserName =  N'Maria@'+@CompanyName+'.com' AND U.CompanyId = @CompanyId), (SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId), '2224', (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Draft' AND CompanyId = @CompanyId), GETDATE(), 0, 0, 0, 0, @CompanyId, GETDATE(), @UserId)
) 
AS Source ([Id], [ClientId], [CurrencyId], [EstimateNumber], [EstimateStatusId], [IssueDate], [TotalAmount], [SubTotalAmount], [Discount], [DiscountAmount], [CompanyId], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [ClientId] = Source.[ClientId],
		   [CurrencyId] = Source.[CurrencyId],
           [EstimateNumber] = Source.[EstimateNumber],
           [EstimateStatusId] = Source.[EstimateStatusId],
           [IssueDate] = Source.[IssueDate],
           [TotalAmount] = Source.[TotalAmount],
           [SubTotalAmount] = Source.[SubTotalAmount],
           [Discount] = Source.[Discount],
           [DiscountAmount] = Source.[DiscountAmount],
           [CompanyId] = Source.[CompanyId],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CreatedDateTime] = Source.[CreatedDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [ClientId], [CurrencyId], [EstimateNumber], [EstimateStatusId], [IssueDate], [TotalAmount], [SubTotalAmount], [Discount], [DiscountAmount], [CompanyId], [CreatedDateTime], [CreatedByUserId])
VALUES ([Id], [ClientId], [CurrencyId], [EstimateNumber], [EstimateStatusId], [IssueDate], [TotalAmount], [SubTotalAmount], [Discount], [DiscountAmount], [CompanyId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EstimateHistory] AS Target 
USING ( VALUES
		(NEWID(), (SELECT Id FROM [Estimate] WHERE EstimateNumber = '2222' AND CompanyId = @CompanyId), NULL, '2222', 'EstimateAdded', GETDATE(), @UserId),
		(NEWID(), (SELECT Id FROM [Estimate] WHERE EstimateNumber = '2223' AND CompanyId = @CompanyId), NULL, '2223', 'EstimateAdded', GETDATE(), @UserId),
		(NEWID(), (SELECT Id FROM [Estimate] WHERE EstimateNumber = '2224' AND CompanyId = @CompanyId), NULL, '2224', 'EstimateAdded', GETDATE(), @UserId)
) 
AS Source ([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [EstimateId] = Source.[EstimateId],
		   [OldValue] = Source.[OldValue],
           [NewValue] = Source.[NewValue],
           [Description] = Source.[Description],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CreatedDateTime] = Source.[CreatedDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
VALUES ([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId]);
--Expenses & Invoices

--MERGE INTO [dbo].[EmployeeWorkConfiguration] AS Target 
--USING ( VALUES 
--	 (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--	,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--	,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--	,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--	,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--	,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--	,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--	,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--	,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--	,(NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), GetDate(), NULL, GetDate(), @UserId)
--)
--AS Source ([Id],[EmployeeId],[MinAllocatedHours],[MaxAllocatedHours],[ActiveFrom],[ActiveTo],[CreatedDateTime],[CreatedByUserId])
--ON Target.Id = Source.Id 
--WHEN MATCHED THEN 
--UPDATE SET [EmployeeId]  = Source.[EmployeeId], 
--           [MinAllocatedHours] = Source.[MinAllocatedHours],
--		   [MaxAllocatedHours] = source.[MaxAllocatedHours],
--		   [ActiveFrom] = source.[ActiveFrom],
--		   [ActiveTo] = source.[ActiveTo],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--	       [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id],[EmployeeId],[MinAllocatedHours],[MaxAllocatedHours],[ActiveFrom],[ActiveTo],[CreatedDateTime],[CreatedByUserId]) VALUES ([Id],[EmployeeId],[MinAllocatedHours],[MaxAllocatedHours],[ActiveFrom],[ActiveTo],[CreatedDateTime],[CreatedByUserId]);

MERGE INTO [dbo].[UserActiveDetails] AS Target 
USING ( VALUES 
	 (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(N'2018-01-08T00:00:00.000' AS DateTime), NULL, GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(N'2018-01-02T00:00:00.000' AS DateTime), NULL, GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(N'2018-05-10T00:00:00.000' AS DateTime), NULL, GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), CAST(N'2017-12-04T00:00:00.000' AS DateTime), NULL, GetDate(), @UserId)
)
AS Source ([Id], [UserId], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [UserId] = Source.[UserId],
	       [ActiveFrom] = Source.[ActiveFrom],
	       [ActiveTo] = Source.[ActiveTo],	       
		   [CreatedDateTime] = Source.[CreatedDateTime],
	       [CreatedByUserId] = Source.[CreatedByUserId]

WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [UserId], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [UserId], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]);

--MERGE INTO [dbo].[PayGrade] AS Target 
--USING ( VALUES 
--	 (NEWID(), @CompanyId, N'PayGrade 1', GetDate(), @UserId)
--	,(NEWID(), @CompanyId, N'PayGrade 2', GetDate(), @UserId)
--	,(NEWID(), @CompanyId, N'PayGrade 3', GetDate(), @UserId)
--	,(NEWID(), @CompanyId, N'PayGrade 4', GetDate(), @UserId)
--) 
--AS Source ([Id], [CompanyId], [PayGradeName],  [CreatedDateTime], [CreatedByUserId])
--ON Target.Id = Source.Id  
--WHEN MATCHED THEN 
--UPDATE SET [CompanyId]  = Source.[CompanyId],
--           [PayGradeName] = Source.[PayGradeName],
--	       [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT([Id], [CompanyId], [PayGradeName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [PayGradeName], [CreatedDateTime], [CreatedByUserId]);	   

--MERGE INTO [dbo].[ContractType] AS Target 
--USING ( VALUES 
--	 (NEWID(), @CompanyId, N'Full-Time', GetDate(), @UserId)
--	,(NEWID(), @CompanyId, N'Part-Time', GetDate(), @UserId)
--) 
--AS Source ([Id], [CompanyId], [ContractTypeName], [CreatedDateTime], [CreatedByUserId])
--ON Target.Id = Source.Id  
--WHEN MATCHED THEN 
--UPDATE SET [CompanyId]  = Source.[CompanyId],
--           [ContractTypeName] = Source.[ContractTypeName],
--	       [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT([Id], [CompanyId], [ContractTypeName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [ContractTypeName], [CreatedDateTime], [CreatedByUserId]);	   

MERGE INTO [dbo].[RateType] AS Target 
USING ( VALUES 
	 (NEWID(), N'RateType 1', N'50.00',@CompanyId, GETDATE(), @UserId)
	,(NEWID(), N'RateType 2', N'75.50',@CompanyId, GETDATE(), @UserId)
	,(NEWID(), N'RateType 3', N'20.50',@CompanyId, GETDATE(), @UserId)
	,(NEWID(), N'RateType 4', N'40.00',@CompanyId, GETDATE(), @UserId)
	,(NEWID(), N'RateType 5', N'35.2', @CompanyId, GETDATE(), @UserId)
) 
AS Source ([Id], [Type], [Rate],[CompanyId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Type]  = Source.[Type],
           [Rate] = Source.[Rate],
		   [CompanyId] = Source.[CompanyId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [Type], [Rate],[CompanyId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [Type], [Rate],[CompanyId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[BreakType] AS Target 
USING ( VALUES 
	  (NEWID(), @CompanyId, N'PaidBreaks', 1,  GetDate(), @UserId)
	, (NEWID(), @CompanyId, N'Causual Break', 0,  GetDate(), @UserId)
	, (NEWID(), @CompanyId, N'Office Break', 0,  GetDate(), @UserId)
) 
AS Source ([Id], [CompanyId], [BreakName], [IsPaid], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId],
           [BreakName] = Source.[BreakName],
		   [IsPaid] = Source.[IsPaid],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [CompanyId], [BreakName], [IsPaid], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [BreakName], [IsPaid], [CreatedDateTime], [CreatedByUserId]);   

MERGE INTO [dbo].[UserBreak] AS Target 
USING ( VALUES 
         (NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GETDATE(),0,GETDATE(),DATEADD(MINUTE,20,GETDATE()),NULL,NULL,GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1')
        ,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GETDATE(),0,GETDATE(),DATEADD(MINUTE,16,GETDATE()),NULL,NULL,GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1')
        ,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GETDATE(),0,GETDATE(),DATEADD(MINUTE,19,GETDATE()),NULL,NULL,GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1')
        ,(NEWID(), (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GETDATE(),0,GETDATE(),DATEADD(MINUTE,23,GETDATE()),NULL,NULL,GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1')
        ,(NEWID(), @UserId,GETDATE(),0,GETDATE(),DATEADD(MINUTE,21,GETDATE()),NULL,NULL,GETDATE(), @UserId, '557c436a-5d19-4eeb-a677-93ea2609eaf1', '557c436a-5d19-4eeb-a677-93ea2609eaf1')
)  
AS Source ([Id], [UserId], [Date],[IsOfficeBreak],[BreakIn],[BreakOut],[InActiveDateTime],[BreakTypeId], [CreatedDateTime], [CreatedByUserId], [BreakInTimeZone], [BreakOutTimeZone]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [UserId] = Source.[UserId],
	       [Date] = Source.[Date],
	       [IsOfficeBreak] = Source.[IsOfficeBreak],
		   [BreakIn] = Source.[BreakIn],
		   [BreakOut] = Source.[BreakOut],
		   [InActiveDateTime] = Source.[InActiveDateTime],
		   [BreakTypeId] = Source.[BreakTypeId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [BreakInTimeZone] = Source.[BreakInTimeZone],
		   [BreakOutTimeZone] = Source.[BreakOutTimeZone]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [UserId], [Date],[IsOfficeBreak],[BreakIn],[BreakOut],[InActiveDateTime],[BreakTypeId], [CreatedDateTime], [CreatedByUserId], [BreakInTimeZone], [BreakOutTimeZone]) VALUES ([Id], [UserId], [Date],[IsOfficeBreak],[BreakIn],[BreakOut],[InActiveDateTime],[BreakTypeId], [CreatedDateTime], [CreatedByUserId], [BreakInTimeZone], [BreakOutTimeZone]);	 

MERGE INTO [dbo].[EmployeeEmergencyContact] AS Target 
USING ( VALUES 
	  (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Mother%'), N'Amar', N'arvei', NULL, NULL, N'2782726789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Child%'), N'Amar', N'Pullela', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Mother%'), N'jai', N'kappala', NULL, NULL, N'2868774156789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Child%'), N'Amar', N'Pullela', NULL, NULL, N'288888888456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Child%'), N'chares', N'haric', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Mother%'), N'Amar', N'Pullela', NULL, NULL, N'278678668', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Child%'), N'harish', N'abhi', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Mother%'), N'Amar', N'Pullela', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Child%'), N'Amar', N'Pullela', NULL, NULL, N'8667856789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Mother%'), N'syamal', N'Pullela', NULL, NULL, N'287786789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Child%'), N'Amar', N'Pullela', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Mother%'), N'jayachandra', N'Pullela', NULL, NULL, N'2877256789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT Id FROM EMPLOYEE WHERE UserId = @UserId ), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Child%'), N'Andrew', N'Smith', NULL, NULL, N'2877252719', N'987466223', 1, 1, N'Manchester', N'Manchester', NULL, NULL, (SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT Id FROM EMPLOYEE WHERE UserId = @UserId ), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Mother%'), N'Bran', N'Swann', NULL, NULL, N'2877252719', N'987466223', 1, 1, N'Manchester', N'Manchester', NULL, NULL, (SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
	, (NEWID(), (SELECT Id FROM EMPLOYEE WHERE UserId = @UserId ), (SELECT Id FROM RelationShip WHERE CompanyId = @CompanyId AND [RelationShipName] like '%Mother%'), N'Peter', N'Parker', NULL, NULL, N'2877252719', N'987466223', 1, 1, N'Manchester', N'Manchester', NULL, NULL,(SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId), GetDate(), @UserId)
) 
AS Source ([Id], [EmployeeId], [RelationshipId], [FirstName], [LastName], [OtherRelation], [HomeTelephone], [MobileNo], [WorkTelephone], [IsEmergencyContact], [IsDependentContact], [AddressStreetOne], [AddressStreetTwo], [StateOrProvinceId], [ZipOrPostalCode], [CountryId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET 
           [EmployeeId] = Source.[EmployeeId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [RelationshipId] = Source.[RelationshipId],
		   [FirstName] = Source.[FirstName],
		   [LastName] = Source.[LastName],
		   [OtherRelation] = Source.[OtherRelation],
		   [HomeTelephone] = Source.[HomeTelephone],
		   [MobileNo] = Source.[MobileNo],
		   [WorkTelephone] = Source.[WorkTelephone],
		   [IsEmergencyContact] = Source.[IsEmergencyContact],
		   [IsDependentContact] = Source.[IsDependentContact],
		   [AddressStreetOne] = Source.[AddressStreetOne],
		   [AddressStreetTwo] = Source.[AddressStreetTwo],
		   [StateOrProvinceId] = Source.[StateOrProvinceId],
		   [ZipOrPostalCode] = Source.[ZipOrPostalCode],
		   [CountryId] = Source.[CountryId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [EmployeeId], [RelationshipId], [FirstName], [LastName], [OtherRelation], [HomeTelephone], [MobileNo], [WorkTelephone], [IsEmergencyContact], [IsDependentContact], [AddressStreetOne], [AddressStreetTwo], [StateOrProvinceId], [ZipOrPostalCode], [CountryId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [EmployeeId], [RelationshipId], [FirstName], [LastName], [OtherRelation], [HomeTelephone], [MobileNo], [WorkTelephone], [IsEmergencyContact], [IsDependentContact], [AddressStreetOne], [AddressStreetTwo], [StateOrProvinceId], [ZipOrPostalCode], [CountryId], [CreatedDateTime], [CreatedByUserId]);	   

MERGE INTO [dbo].[SoftLabel] AS Target 
USING ( VALUES 
	  (NEWID(), @CompanyId, N'T005s',56, (SELECT B.Id FROM Branch B WHERE BranchName = 'Birmingham' AND B.CompanyId = @CompanyId), GetDate(), @UserId)
	, (NEWID(), @CompanyId, N'TO59Q',456, (SELECT B.Id FROM Branch B WHERE BranchName = 'Nottingham' AND B.CompanyId = @CompanyId),GetDate(), @UserId)
	, (NEWID(), @CompanyId, N'TTJX', 185, (SELECT B.Id FROM Branch B WHERE BranchName = 'Manchester' AND B.CompanyId = @CompanyId),GetDate(), @UserId)
) 
AS Source ([Id], [CompanyId], [SoftLabelName],[SoftLabelValue] ,[BranchId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId],
           [SoftLabelName] = Source.[SoftLabelName],
		   [SoftLabelValue] = Source.[SoftLabelValue],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [BranchId] = Source.[BranchId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [CompanyId], [SoftLabelName],[SoftLabelValue], [BranchId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [SoftLabelName],[SoftLabelValue], [BranchId], [CreatedDateTime], [CreatedByUserId]);	   

MERGE INTO [dbo].[EmployeeLicence] AS Target 
USING ( VALUES 
	  (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),(SELECT Id FROM LicenceType WHERE CompanyId = @CompanyId AND LicenceTypeName LIKE '%Permanent%'), N'123456', GetDate(), CAST(N'2021-04-01T00:00:00.000' AS DateTime), GetDate(),@UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),(SELECT Id FROM LicenceType WHERE CompanyId = @CompanyId AND LicenceTypeName LIKE '%3 Months%'), N'5249', GetDate(), CAST(N'2021-04-01T00:00:00.000' AS DateTime), GetDate(),@UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),(SELECT Id FROM LicenceType WHERE CompanyId = @CompanyId AND LicenceTypeName LIKE '%1 Year%'), N'32692', GetDate(), CAST(N'2021-04-01T00:00:00.000' AS DateTime), GetDate(),@UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM LicenceType WHERE CompanyId = @CompanyId AND LicenceTypeName LIKE '%5 years%'), N'53988', GetDate(), CAST(N'2021-04-01T00:00:00.000' AS DateTime), GetDate(),@UserId)
	, (NEWID(), (SELECT Id FROM EMPLOYEE WHERE UserId = @UserId), (SELECT Id FROM LicenceType WHERE CompanyId = @CompanyId AND LicenceTypeName LIKE '%5 years%'), N'53888', GetDate(), CAST(N'2021-04-01T00:00:00.000' AS DateTime), GetDate(),@UserId)
) 
AS Source ([Id], [EmployeeId], [LicenceTypeId], [LicenceNumber], [IssuedDate], [ExpiryDate], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [EmployeeId]  = Source.[EmployeeId],
           [LicenceTypeId] = Source.[LicenceTypeId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [LicenceNumber] = Source.[LicenceNumber]	     

WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [EmployeeId], [LicenceTypeId], [LicenceNumber], [IssuedDate], [ExpiryDate], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [EmployeeId], [LicenceTypeId], [LicenceNumber], [IssuedDate], [ExpiryDate], [CreatedDateTime], [CreatedByUserId]);	   

MERGE INTO [dbo].[EmployeeImmigration] AS Target 
USING ( VALUES 
	  (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'Visa', N'FG001', GetDate(), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, (SELECT Id FROM Country WHERE CountryName LIKE '%England%' AND CompanyId = @CompanyId), NULL, NULL, GetDate(), NULL, GetDate(),@UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'Visa', N'CD3001', GetDate(), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, (SELECT Id FROM Country WHERE CountryName LIKE '%India%' AND CompanyId = @CompanyId), NULL, NULL, GetDate(), NULL, GetDate(),@UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'Visa', N'GDFG001', GetDate(), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, (SELECT Id FROM Country WHERE CountryName LIKE '%England%' AND CompanyId = @CompanyId), NULL, NULL, GetDate(), NULL, GetDate(),@UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'Passport', N'24G851', GetDate(), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, (SELECT Id FROM Country WHERE CountryName LIKE '%India%' AND CompanyId = @CompanyId), NULL, NULL, GetDate(), NULL, GetDate(),@UserId)	
	, (NEWID(), (SELECT Id FROM EMPLOYEE WHERE UserId = @UserId ),  N'Passport', N'24G851', GetDate(), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, (SELECT Id FROM Country WHERE CountryName LIKE '%England%' AND CompanyId = @CompanyId), NULL, NULL, GetDate(), NULL, GetDate(),@UserId)	
) 
AS Source ([Id], [EmployeeId], [Document], [DocumentNumber], [IssuedDate], [ExpiryDate], [EligibleStatus], [CountryId], [EligibleReviewDate], [Comments], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [EmployeeId]  = Source.[EmployeeId],
           [Document] = Source.[Document],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [DocumentNumber] = Source.[DocumentNumber],
		   [IssuedDate] = Source.[IssuedDate],
		   [ExpiryDate] = Source.[ExpiryDate],
		   [EligibleStatus] = Source.[EligibleStatus],
		   [CountryId] = Source.[CountryId],
		   [EligibleReviewDate] = Source.[EligibleReviewDate],
		   [Comments] = Source.[Comments],
		   [ActiveFrom] = Source.[ActiveFrom],
		   [ActiveTo] = Source.[ActiveTo]

WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [EmployeeId], [Document], [DocumentNumber], [IssuedDate], [ExpiryDate], [EligibleStatus], [CountryId], [EligibleReviewDate], [Comments], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [EmployeeId], [Document], [DocumentNumber], [IssuedDate], [ExpiryDate], [EligibleStatus], [CountryId], [EligibleReviewDate], [Comments], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]);	   

MERGE INTO [dbo].[EmployeeContactDetails] AS Target 
USING ( VALUES 
	  (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'UK', N'SF Road', N'500001',(SELECT Id FROM Country WHERE CountryName LIKE '%England%' AND CompanyId = @CompanyId), NULL, N'123456789', NULL, N'Dani@gamil.com', N'a@'+@CompanyName+'.com', N'Dani', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), NULL, GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'UK', N'SF Road', N'500001', (SELECT Id FROM Country WHERE CountryName LIKE '%India%' AND CompanyId = @CompanyId), NULL, N'123456789', NULL, N'Dina@gamil.com', N'a@'+@CompanyName+'.com', N'Dina', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), NULL,GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'UK', N'SF Road', N'500001', (SELECT Id FROM Country WHERE CountryName LIKE '%England%' AND CompanyId = @CompanyId), NULL, N'123456789', NULL, N'Kevin@gamil.com', N'a@'+@CompanyName+'.com',  N'Kevin', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), NULL, GetDate(), @UserId)
	, (NEWID(), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'UK', N'SF Road', N'500001', (SELECT Id FROM Country WHERE CountryName LIKE '%India%' AND CompanyId = @CompanyId), NULL, N'123456789', NULL, N'Nick@gamil.com', N'a@'+@CompanyName+'.com',  N'Nick', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), NULL, GetDate(), @UserId)
) 
AS Source ([Id], [EmployeeId], [Address1], [Address2], [PostalCode], [CountryId], [HomeTelephoneno], [Mobile], [WorkTelephoneno], [WorkEmail], [OtherEmail], [ContactPersonName], [Relationship], [DateOfBirth], [EmployeeContactTypeId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [EmployeeId] = Source.[EmployeeId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [Address1] = Source.[Address1],
		   [Address2] = Source.[Address2],
		   [PostalCode] = Source.[PostalCode],
		   [CountryId] = Source.[CountryId],
		   [HomeTelephoneno] = Source.[HomeTelephoneno],
		   [Mobile] = Source.[Mobile],
		   [WorkTelephoneno] = Source.[WorkTelephoneno],
		   [WorkEmail] = Source.[WorkEmail],
		   [OtherEmail] = Source.[OtherEmail],
		   [ContactPersonName] = Source.[ContactPersonName],
		   [Relationship] = Source.[Relationship],
		   [EmployeeContactTypeId] = Source.[EmployeeContactTypeId],
		   [DateOfBirth] = Source.[DateOfBirth]

WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [EmployeeId], [Address1], [Address2], [PostalCode], [CountryId], [HomeTelephoneno], [Mobile], [WorkTelephoneno], [WorkEmail], [OtherEmail], [ContactPersonName], [Relationship], [DateOfBirth], [EmployeeContactTypeId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [EmployeeId], [Address1], [Address2], [PostalCode], [CountryId], [HomeTelephoneno], [Mobile], [WorkTelephoneno], [WorkEmail], [OtherEmail], [ContactPersonName], [Relationship], [DateOfBirth], [EmployeeContactTypeId],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeDesignation] AS Target 
USING ( VALUES 
	 (NEWID(), (SELECT Id FROM Designation WHERE DesignationName = 'Lead Developer' AND CompanyId = @CompanyId), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),       (SELECT Id FROM EmploymentStatus WHERE CompanyId = @CompanyId AND EmploymentStatusName LIKE '%Full-Time Employee%'), (SELECT Id FROM JobCategory WHERE CompanyId = @CompanyId AND JobCategoryType LIKE '%Professionals%'), (SELECT Id FROM Department WHERE CompanyId = @CompanyId AND DepartmentName LIKE '%IT%'), NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM Designation WHERE DesignationName = 'Software Engineer' AND CompanyId = @CompanyId), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),    (SELECT Id FROM EmploymentStatus WHERE CompanyId = @CompanyId AND EmploymentStatusName LIKE '%Full-Time Employee%'), (SELECT Id FROM JobCategory WHERE CompanyId = @CompanyId AND JobCategoryType LIKE '%Professionals%'), (SELECT Id FROM Department WHERE CompanyId = @CompanyId AND DepartmentName LIKE '%IT%'), NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM Designation WHERE DesignationName = 'Software Engineer' AND CompanyId = @CompanyId), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),    (SELECT Id FROM EmploymentStatus WHERE CompanyId = @CompanyId AND EmploymentStatusName LIKE '%Part-Time Employee%'), (SELECT Id FROM JobCategory WHERE CompanyId = @CompanyId AND JobCategoryType LIKE '%Operatives%'),    (SELECT Id FROM Department WHERE CompanyId = @CompanyId AND DepartmentName LIKE '%Finance%'), NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, GetDate(), NULL, GetDate(), @UserId)
	,(NEWID(), (SELECT Id FROM Designation WHERE DesignationName = 'Software Engineer' AND CompanyId = @CompanyId), (SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), (SELECT Id FROM EmploymentStatus WHERE CompanyId = @CompanyId AND EmploymentStatusName LIKE '%Consultant%'), (SELECT Id FROM JobCategory WHERE CompanyId = @CompanyId AND JobCategoryType LIKE '%Sales Workers%'), (SELECT Id FROM Department WHERE CompanyId = @CompanyId AND DepartmentName LIKE '%Sales%'), NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, GetDate(), NULL, GetDate(), @UserId)
) 
AS Source ([Id], [DesignationId], [EmployeeId], [EmploymentStatusId], [JobCategoryId], [DepartmentId], [ContrcatStartDate], [ContrcatEndDate], [ContractDetails], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [DesignationId]  = Source.[DesignationId],
           [EmployeeId] = Source.[EmployeeId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [EmploymentStatusId] = Source.[EmploymentStatusId],
		   [JobCategoryId] = Source.[JobCategoryId],
		   [DepartmentId] = Source.[DepartmentId],
		   [ContrcatStartDate] = Source.[ContrcatStartDate],
		   [ContrcatEndDate] = Source.[ContrcatEndDate],
		   [ContractDetails] = Source.[ContractDetails],
		   [ActiveFrom] = Source.[ActiveFrom],
		   [ActiveTo] = Source.[ActiveTo]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [DesignationId], [EmployeeId], [EmploymentStatusId], [JobCategoryId], [DepartmentId], [ContrcatStartDate], [ContrcatEndDate], [ContractDetails], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [DesignationId], [EmployeeId], [EmploymentStatusId], [JobCategoryId], [DepartmentId], [ContrcatStartDate], [ContrcatEndDate], [ContractDetails], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeSalary] AS Target 
USING ( VALUES 
	 
	 (NEWID(), (SELECT Id FROM PayGrade WHERE [PayGradeName] = 'Chief Executive Officer (C.E.O)' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 'Salary component 1', (SELECT Id FROM PayFrequency WHERE CompanyId = @CompanyId AND PayFrequencyName LIKE '%Monthly on First Pay of Month%'),(SELECT Id FROM PaymentMethod WHERE CompanyId = @CompanyId AND PaymentMethodName LIKE '%NEFT%'), (SELECT Id FROM Currency WHERE CompanyId = @CompanyId AND CurrencyName LIKE '%Euro%'), 1000, GetDate(), @UserId),
	 (NEWID(), (SELECT Id FROM PayGrade WHERE [PayGradeName] = 'Executive' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%'AND CompanyId = @CompanyId), 'Salary component 2', (SELECT Id FROM PayFrequency WHERE CompanyId = @CompanyId AND PayFrequencyName LIKE '%Semi Monthly%'),(SELECT Id FROM PaymentMethod WHERE CompanyId = @CompanyId AND PaymentMethodName LIKE '%ATM%'), (SELECT Id FROM Currency WHERE CompanyId = @CompanyId AND CurrencyName LIKE '%Canadian Dollar%'), 4000, GetDate(), @UserId),
	 (NEWID(), (SELECT Id FROM PayGrade WHERE [PayGradeName] = 'Chief Executive Officer (C.E.O)' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 'Salary component 1', (SELECT Id FROM PayFrequency WHERE CompanyId = @CompanyId AND PayFrequencyName LIKE '%Bi Weekly%'),(SELECT Id FROM PaymentMethod WHERE CompanyId = @CompanyId AND PaymentMethodName LIKE '%NEFT%'), (SELECT Id FROM Currency WHERE CompanyId = @CompanyId AND CurrencyName LIKE '%Euro%'), 1500, GetDate(), @UserId),
	 (NEWID(), (SELECT Id FROM PayGrade WHERE [PayGradeName] = 'Executive' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 'Salary component 2', (SELECT Id FROM PayFrequency WHERE CompanyId = @CompanyId AND PayFrequencyName LIKE '%Hourly%'),(SELECT Id FROM PaymentMethod WHERE CompanyId = @CompanyId AND PaymentMethodName LIKE '%ATM%'), (SELECT Id FROM Currency WHERE CompanyId = @CompanyId AND CurrencyName LIKE '%Canadian Dollar%'), 100, GetDate(), @UserId),
	 (NEWID(), (SELECT Id FROM PayGrade WHERE [PayGradeName] = 'Chief Executive Officer (C.E.O)' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId), 'Salary component 1', (SELECT Id FROM PayFrequency WHERE CompanyId = @CompanyId AND PayFrequencyName = 'Monthly'),(SELECT Id FROM PaymentMethod WHERE CompanyId = @CompanyId AND PaymentMethodName LIKE '%NEFT%'), (SELECT Id FROM Currency WHERE CompanyId = @CompanyId AND CurrencyName LIKE '%Euro%'), 2000, GetDate(), @UserId)
) 
AS Source ([Id], [SalaryPayGradeId], [EmployeeId], [SalaryComponent], [SalaryPayFrequencyId], [PaymentMethodId], [CurrencyId], [Amount], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [SalaryPayGradeId]  = Source.[SalaryPayGradeId],
           [EmployeeId] = Source.[EmployeeId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [SalaryComponent] = Source.[SalaryComponent],
		   [SalaryPayFrequencyId] = Source.[SalaryPayFrequencyId],
		   [PaymentMethodId] = Source.[PaymentMethodId],
		   [CurrencyId] = Source.[CurrencyId],
		   [Amount] = Source.[Amount]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [SalaryPayGradeId], [EmployeeId], [SalaryComponent], [SalaryPayFrequencyId], [PaymentMethodId], [CurrencyId], [Amount], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [SalaryPayGradeId], [EmployeeId], [SalaryComponent], [SalaryPayFrequencyId], [PaymentMethodId], [CurrencyId], [Amount], [CreatedDateTime], [CreatedByUserId]);

DECLARE @CountryId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[Country] WHERE [CountryName] = N'India' AND [CompanyId] = @CompanyId)

MERGE INTO [dbo].[Bank] AS Target 
USING ( VALUES 
          (NEWID(),@CountryId, N'Test Bank', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 
)  
AS Source ([Id], [CountryId], [BankName], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CountryId] = Source.[CountryId],
	       [BankName] = Source.[BankName],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [CountryId], [BankName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CountryId], [BankName], [CreatedDateTime], [CreatedByUserId]);

 MERGE INTO [dbo].[BankDetail] AS Target 
USING ( VALUES 
	 (NEWID(), '6016 1331 9268 19',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 'Maria account', 45,(SELECT id FROM Bank WHERE BankName='Test Bank' AND CountryId = @CountryId), 'Birmingham', GetDate(),GetDate(),GetDate(), @UserId),
	 (NEWID(), '6016 1331 9268 20',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%'AND CompanyId = @CompanyId), 'James account', 90, (SELECT id FROM Bank WHERE BankName='Test Bank' AND CountryId = @CountryId), 'Birmingham' , GetDate(),GetDate(),GetDate(), @UserId),
	 (NEWID(), '6016 1331 9268 21',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 'David account', 30, (SELECT id FROM Bank WHERE BankName='Test Bank' AND CountryId = @CountryId) , 'Birmingham', GetDate(), GetDate(),GetDate(),@UserId),
	 (NEWID(), '6016 1331 9268 22',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), 'Martinez account', 15, (SELECT id FROM Bank WHERE BankName='Test Bank' AND CountryId = @CountryId) , 'Birmingham', GetDate(),GetDate(),GetDate(), @UserId),
	 (NEWID(), '6016 1331 9268 23',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId), 'Test account', 60, (SELECT id FROM Bank WHERE BankName='Test Bank' AND CountryId = @CountryId), 'Birmingham', GetDate(),GetDate(),GetDate(), @UserId)
) 
AS Source ([Id], [AccountNumber], [EmployeeId], [AccountName], [BuildingSocietyRollNumber], [BankId], [BranchName], [DateFrom],[EffectiveFrom], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [AccountNumber]  = Source.[AccountNumber],
           [EmployeeId] = Source.[EmployeeId],
		   [AccountName] = Source.[AccountName],
		   [BuildingSocietyRollNumber] = Source.[BuildingSocietyRollNumber],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [BankId] = Source.[BankId],
		   [BranchName] = Source.[BranchName],
		   [DateFrom] = Source.[DateFrom],
		   [EffectiveFrom] = Source.[EffectiveFrom]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [AccountNumber], [EmployeeId], [AccountName], [BuildingSocietyRollNumber], [BankId], [BranchName], [DateFrom], [EffectiveFrom], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [AccountNumber], [EmployeeId], [AccountName], [BuildingSocietyRollNumber], [BankId], [BranchName], [DateFrom], [EffectiveFrom], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeLanguage] AS Target 
USING ( VALUES 
	 
	 (NEWID(), (SELECT Id FROM [Language] WHERE [LanguageName] = 'English' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Fluency] WHERE [FluencyName] = 'Speaking' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Competency] WHERE [CompetencyName] = 'Good' AND CompanyId = @CompanyId) ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),'Can speak English fluently.', GetDate(), @UserId),
	 (NEWID(), (SELECT Id FROM [Language] WHERE [LanguageName] = 'English' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Fluency] WHERE [FluencyName] = 'Speaking' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Competency] WHERE [CompetencyName] = 'Good' AND CompanyId = @CompanyId) ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%'AND CompanyId = @CompanyId), 'Can speak English fluently.',GetDate(), @UserId),
	 (NEWID(), (SELECT Id FROM [Language] WHERE [LanguageName] = 'English' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Fluency] WHERE [FluencyName] = 'Speaking' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Competency] WHERE [CompetencyName] = 'Good' AND CompanyId = @CompanyId) ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),'Can speak English fluently.',GetDate(),@UserId),
	 (NEWID(), (SELECT Id FROM [Language] WHERE [LanguageName] = 'English' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Fluency] WHERE [FluencyName] = 'Speaking' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Competency] WHERE [CompetencyName] = 'Good' AND CompanyId = @CompanyId) ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),'Can speak English fluently.',GetDate(), @UserId),
	 (NEWID(), (SELECT Id FROM [Language] WHERE [LanguageName] = 'English' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Fluency] WHERE [FluencyName] = 'Speaking' AND CompanyId = @CompanyId) ,(SELECT Id FROM [Competency] WHERE [CompetencyName] = 'Good' AND CompanyId = @CompanyId) ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId),'Can speak English fluently.',GetDate(), @UserId)
) 
AS Source ([Id], [LanguageId], [FluencyId], [CompetencyId],[EmployeeId], [Comments], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [LanguageId]  = Source.[LanguageId],
           [EmployeeId] = Source.[EmployeeId],
		   [FluencyId] = Source.[FluencyId],
		   [CompetencyId] = Source.[CompetencyId],
	       [Comments] = Source.[Comments],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [LanguageId], [EmployeeId], [FluencyId], [CompetencyId], [Comments], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [LanguageId], [EmployeeId], [FluencyId], [CompetencyId], [Comments], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeSkill] AS Target 
USING ( VALUES 
	 
	 (NEWID(),(SELECT Id FROM [Skill] WHERE [SkillName] = 'AngularJS' AND CompanyId = @CompanyId), 1,'Working on this technology since 2 years.' ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), GetDate(), GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [Skill] WHERE [SkillName] = 'AngularJS' AND CompanyId = @CompanyId), 2,'Working on this technology since 2 years.' ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%'AND CompanyId = @CompanyId), GetDate() ,GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [Skill] WHERE [SkillName] = 'AngularJS' AND CompanyId = @CompanyId), 3,'Working on this technology since 2 years.' ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GetDate() ,GetDate(),@UserId),
	 (NEWID(),(SELECT Id FROM [Skill] WHERE [SkillName] = 'AngularJS' AND CompanyId = @CompanyId), 3.3,'Working on this technology since 2 years.' ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GetDate() ,GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [Skill] WHERE [SkillName] = 'AngularJS' AND CompanyId = @CompanyId), 2,'Working on this technology since 2 years.' ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId),GetDate() ,GetDate(), @UserId)
) 
AS Source ([Id], [SkillId], [YearsOfExperience], [Comments],[EmployeeId],[DateFrom],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [SkillId]  = Source.[SkillId],
           [EmployeeId] = Source.[EmployeeId],
		   [YearsOfExperience] = Source.[YearsOfExperience],
	       [Comments] = Source.[Comments],
		   [DateFrom] = Source.[DateFrom],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [SkillId], [YearsOfExperience], [Comments],[EmployeeId],[DateFrom],[CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [SkillId], [YearsOfExperience], [Comments],[EmployeeId],[DateFrom],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeEducation] AS Target 
USING ( VALUES 
	 
	 (NEWID(),(SELECT Id FROM [EducationLevel] WHERE [EducationLevel] = 'MBA' AND CompanyId = @CompanyId), 'University of Oxford','Human Resources Manager',9.8 ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(year, -1, GetDate()), GetDate(),GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [EducationLevel] WHERE [EducationLevel] = 'MBA' AND CompanyId = @CompanyId), 'University of Oxford','Human Resources Manager',9.8 ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%'AND CompanyId = @CompanyId), DATEADD(year, -1, GetDate()),GetDate() ,GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [EducationLevel] WHERE [EducationLevel] = 'MBA' AND CompanyId = @CompanyId), 'University of Oxford','Human Resources Manager',9.8 ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -1, GetDate()),GetDate() ,GetDate(),@UserId),
	 (NEWID(),(SELECT Id FROM [EducationLevel] WHERE [EducationLevel] = 'MBA' AND CompanyId = @CompanyId), 'University of Oxford','Human Resources Manager',9.8 ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -1, GetDate()),GetDate() ,GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [EducationLevel] WHERE [EducationLevel] = 'MBA' AND CompanyId = @CompanyId), 'University of Oxford','Human Resources Manager',9.8 ,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId),DATEADD(year, -1, GetDate()),GetDate() ,GetDate(), @UserId)
) 
AS Source ([Id], [EducationLevelId], [Institute], [MajorSpecialization],[GPA_Score],[EmployeeId],[StartDate],[EndDate],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [EducationLevelId]  = Source.[EducationLevelId],
           [EmployeeId] = Source.[EmployeeId],
		   [Institute] = Source.[Institute],
	       [MajorSpecialization] = Source.[MajorSpecialization],
		   [GPA_Score] = Source.[GPA_Score],
		   [StartDate] = Source.[StartDate],
		   [EndDate] = Source.[EndDate],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [EducationLevelId], [Institute], [MajorSpecialization],[GPA_Score],[EmployeeId],[StartDate],[EndDate],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [EducationLevelId], [Institute], [MajorSpecialization],[GPA_Score],[EmployeeId],[StartDate],[EndDate],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeWorkExperience] AS Target 
USING ( VALUES 
	 
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId), 'Test company','Worked as a software engineer',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()),DATEADD(month, -1, GetDate()), GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId), 'Test company','Worked as a software engineer',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%'AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()),DATEADD(month, -1, GetDate()),GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId), 'Test company','Worked as a software engineer',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),DATEADD(month, -1, GetDate()) ,GetDate(),@UserId),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId), 'Test company','Worked as a software engineer',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),DATEADD(month, -1, GetDate()),GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId), 'Test company','Worked as a software engineer',(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId),DATEADD(year, -2, GetDate()),DATEADD(month, -1, GetDate()),GetDate(), @UserId)
) 
AS Source ([Id], [DesignationId], [Company], [Comments],[EmployeeId],[FromDate],[ToDate],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [DesignationId]  = Source.[DesignationId],
           [EmployeeId] = Source.[EmployeeId],
		   [Company] = Source.[Company],
	       [Comments] = Source.[Comments],
		   [FromDate] = Source.[FromDate],
		   [ToDate] = Source.[ToDate],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [DesignationId], [Company], [Comments],[EmployeeId],[FromDate],[ToDate],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [DesignationId], [Company], [Comments],[EmployeeId],[FromDate],[ToDate],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeMembership] AS Target 
USING ( VALUES 
	 
	 (NEWID(),'Designing and Implementing an Azure AI Solution','Microsoft',(SELECT Id FROM [MemberShip] WHERE [MemberShipType] = 'Yearly' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()), GetDate(), @UserId),
	 (NEWID(),'Designing and Implementing an Azure AI Solution','Microsoft',(SELECT Id FROM [MemberShip] WHERE [MemberShipType] = 'Yearly' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%'AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()),GetDate(), @UserId),
	 (NEWID(),'Designing and Implementing an Azure AI Solution','Microsoft',(SELECT Id FROM [MemberShip] WHERE [MemberShipType] = 'Yearly' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(),@UserId),
	 (NEWID(),'Designing and Implementing an Azure AI Solution','Microsoft',(SELECT Id FROM [MemberShip] WHERE [MemberShipType] = 'Yearly' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), @UserId),
	 (NEWID(),'Designing and Implementing an Azure AI Solution','Microsoft',(SELECT Id FROM [MemberShip] WHERE [MemberShipType] = 'Yearly' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId),DATEADD(year, -2, GetDate()),GetDate(), @UserId)
) 
AS Source ([Id], [NameOfTheCertificate], [IssueCertifyingAuthority], [MembershipId],[EmployeeId],[CommenceDate],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [NameOfTheCertificate]  = Source.NameOfTheCertificate,
           [EmployeeId] = Source.[EmployeeId],
		   [IssueCertifyingAuthority] = Source.IssueCertifyingAuthority,
		   [MembershipId] = Source.MembershipId,
	       [CommenceDate] = Source.CommenceDate,
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [NameOfTheCertificate], [IssueCertifyingAuthority], [MembershipId],[EmployeeId],[CommenceDate],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [NameOfTheCertificate], [IssueCertifyingAuthority], [MembershipId],[EmployeeId],[CommenceDate],[CreatedDateTime], [CreatedByUserId]);
DECLARE @SuperAdminBranch UNIQUEIDENTIFIER = (SELECT TOP 1 EB.BranchId FROM EmployeeBranch EB INNER JOIN Employee E ON E.ID = EB.EmployeeId WHERE E.UserId = @UserId)
MERGE INTO [dbo].[Job] AS Target 
USING ( VALUES 
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'IT' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Manchester' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()), GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'IT' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%'AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()),GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'IT' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Nottingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(),@UserId),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'IT' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Manchester' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'IT' AND CompanyId = @CompanyId),@SuperAdminBranch,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId),DATEADD(year, -2, GetDate()),GetDate(), @UserId)
) 
AS Source ([Id], [DesignationId], [EmploymentStatusId], [JobCategoryId],[DepartmentId],[BranchId],[EmployeeId],[JoinedDate],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [DesignationId]  = Source.[DesignationId],
           [EmployeeId] = Source.[EmployeeId],
		   [EmploymentStatusId] = Source.[EmploymentStatusId],
		   [JobCategoryId] = Source.[JobCategoryId],
	       [DepartmentId] = Source.[DepartmentId],
		   [BranchId] = Source.[BranchId],
		   [JoinedDate] = Source.[JoinedDate],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [DesignationId], [EmploymentStatusId], [JobCategoryId],[DepartmentId],[BranchId],[EmployeeId],[JoinedDate],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [DesignationId], [EmploymentStatusId], [JobCategoryId],[DepartmentId],[BranchId],[EmployeeId],[JoinedDate],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Contract] AS Target 
USING ( VALUES 
	 (NEWID(),(SELECT Id FROM [ContractType] WHERE [ContractTypeName] = 'Full-Time' AND CompanyId = @CompanyId),(SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),50,100,NULL,NULL,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()), GetDate(),GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [ContractType] WHERE [ContractTypeName] = 'Full-Time' AND CompanyId = @CompanyId),(SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),50,100,NULL,NULL,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@'+@CompanyName+'.com%'AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()),GetDate(),GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [ContractType] WHERE [ContractTypeName] = 'Full-Time' AND CompanyId = @CompanyId),(SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),50,100,NULL,NULL,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(),GetDate(),@UserId),
	 (NEWID(),(SELECT Id FROM [ContractType] WHERE [ContractTypeName] = 'Full-Time' AND CompanyId = @CompanyId),(SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),50,100,NULL,NULL,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(),GetDate(), @UserId),
	 (NEWID(),(SELECT Id FROM [ContractType] WHERE [ContractTypeName] = 'Full-Time' AND CompanyId = @CompanyId),(SELECT Id FROM [Currency] WHERE [CurrencyName] = 'Indian Rupee' AND CompanyId = @CompanyId),50,100,NULL,NULL,(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id AND CompanyId = @CompanyId AND U.Id = @UserId),DATEADD(year, -2, GetDate()),GetDate(),GetDate(), @UserId)
) 
AS Source ([Id], [ContractTypeId], [CurrencyId],[ContractedHours], [HourlyRate],[HolidayOrThisYear],[HolidayOrFullEntitlement],[EmployeeId],[StartDate],[EndDate],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [ContractTypeId]  = Source.[ContractTypeId],
           [EmployeeId] = Source.[EmployeeId],
		   [CurrencyId] = Source.[CurrencyId],
		   [ContractedHours] = Source.[ContractedHours],
	       [HourlyRate] = Source.[HourlyRate],
		   [HolidayOrThisYear] = Source.[HolidayOrThisYear],
		   [HolidayOrFullEntitlement] = Source.[HolidayOrFullEntitlement],
		   [StartDate] = Source.[StartDate],
		   [EndDate] = Source.[EndDate],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [ContractTypeId], [CurrencyId],[ContractedHours], [HourlyRate],[HolidayOrThisYear],[HolidayOrFullEntitlement],[EmployeeId],[StartDate],[EndDate],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [ContractTypeId], [CurrencyId],[ContractedHours], [HourlyRate],[HolidayOrThisYear],[HolidayOrFullEntitlement],[EmployeeId],[StartDate],[EndDate],[CreatedDateTime], [CreatedByUserId]);
 
MERGE INTO [dbo].[Permission] AS Target 
USING ( VALUES 
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-1,GETDATE()),0,0,NULL,(SELECT Id FROM PermissionReason WHERE CompanyId = @CompanyId AND ReasonName LIKE '%Due to traffic%'),'01:00:01',60,1,GetDate(),@UserId),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-15,GETDATE()),0,0,NULL,(SELECT Id FROM PermissionReason WHERE CompanyId = @CompanyId AND ReasonName LIKE '%Coming to office%'),'01:00:01',60,1,GetDate(),@UserId),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-6,GETDATE()),0,0,NULL,(SELECT Id FROM PermissionReason WHERE CompanyId = @CompanyId AND ReasonName LIKE '%Personal Work%'),'01:00:01',60,1,GetDate(),@UserId),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-12,GETDATE()),0,0,NULL,(SELECT Id FROM PermissionReason WHERE CompanyId = @CompanyId AND ReasonName LIKE '%Health Problem%'),'01:00:01',60,1,GetDate(),@UserId),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-19,GETDATE()),0,0,NULL,(SELECT Id FROM PermissionReason WHERE CompanyId = @CompanyId AND ReasonName LIKE '%Last night late%'),'01:00:01',60,1,GetDate(),@UserId),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-2,GETDATE()),0,0,NULL,(SELECT Id FROM PermissionReason WHERE CompanyId = @CompanyId AND ReasonName LIKE '%Due to traffic%'),'01:00:01',60,1,GetDate(),@UserId),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-25,GETDATE()),0,0,NULL,(SELECT Id FROM PermissionReason WHERE CompanyId = @CompanyId AND ReasonName LIKE '%Bus Late%'),'01:00:01',60,1,GetDate(),@UserId),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),DATEADD(DAY,-4,GETDATE()),0,0,NULL,(SELECT Id FROM PermissionReason WHERE CompanyId = @CompanyId AND ReasonName LIKE '%Due to traffic%'),'01:00:01',60,1,GetDate(),@UserId)
	  )
AS Source ([Id], [UserId], [Date],[IsMorning],[IsDeleted],[Reason], [PermissionReasonId],[Duration], [DurationInMinutes], [Hours],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [UserId] = Source.[UserId],
           [Date] = Source.[Date],
		   [IsMorning] = Source.[IsMorning],
		   [IsDeleted] = Source.[IsDeleted],
		   [Reason] = Source.[Reason],
		   [PermissionReasonId] = Source.[PermissionReasonId],
		   [Duration] = Source.[Duration],
		   [DurationInMinutes] = Source.[DurationInMinutes],
		   [Hours] = Source.[Hours],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [UserId], [Date],[IsMorning],[IsDeleted],[Reason], [PermissionReasonId],[Duration], [DurationInMinutes], [Hours],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [UserId], [Date],[IsMorning],[IsDeleted],[Reason], [PermissionReasonId],[Duration], [DurationInMinutes], [Hours],[CreatedDateTime], [CreatedByUserId]);


MERGE INTO [dbo].[ProcessDashboard] AS TARGET
USING (VALUES
			(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT Sql%' AND CompanyId = @CompanyId), 1, GetDate(), @UserId,(SELECT MAX(DeadLineDate) FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId AND US.GoalId = (SELECT G.Id FROM Goal G JOIN Project P ON P.Id = G.ProjectId AND P.Companyid = @CompanyId AND GoalName LIKE '%IOT Sql%')))
		   ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%IOT General%' AND CompanyId = @CompanyId), 1, GetDate(), @UserId,(SELECT MAX(DeadLineDate) FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId AND US.GoalId = (SELECT G.Id FROM Goal G JOIN Project P ON P.Id = G.ProjectId AND P.Companyid = @CompanyId AND GoalName LIKE '%IOT General%')))
		   ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI General%' AND CompanyId = @CompanyId), 1, GetDate(), @UserId,(SELECT MAX(DeadLineDate) FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId AND US.GoalId = (SELECT G.Id FROM Goal G JOIN Project P ON P.Id = G.ProjectId AND P.Companyid = @CompanyId AND GoalName LIKE  '%Rasberry PI General%')))
		   ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Rasberry PI Sql%' AND CompanyId = @CompanyId), 1, GetDate(), @UserId,(SELECT MAX(DeadLineDate) FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId AND US.GoalId = (SELECT G.Id FROM Goal G JOIN Project P ON P.Id = G.ProjectId AND P.Companyid = @CompanyId AND GoalName LIKE  '%Rasberry PI Sql%')))
		   ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data General%' AND CompanyId = @CompanyId), 1, GetDate(), @UserId,(SELECT MAX(DeadLineDate) FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId AND US.GoalId = (SELECT G.Id FROM Goal G JOIN Project P ON P.Id = G.ProjectId AND P.Companyid = @CompanyId AND GoalName LIKE  '%Big Data General%')))
		   ,(NEWID(), (SELECT G.Id FROM Goal G JOIN PROJECT P ON G.ProjectId = P.Id WHERE GoalName LIKE '%Big Data Sql%' AND CompanyId = @CompanyId), 1, GetDate(), @UserId,(SELECT MAX(DeadLineDate) FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND P.CompanyId = @CompanyId AND US.GoalId = (SELECT G.Id FROM Goal G JOIN Project P ON P.Id = G.ProjectId AND P.Companyid = @CompanyId AND GoalName LIKE  '%Big Data Sql%')))
)
AS Source ([Id], [GoalId], [DashboardId], [GeneratedDateTime], [CreatedByUserId],[Milestone])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [GoalId] = Source.[GoalId],
		   [DashboardId] = Source.[DashboardId],
		   [GeneratedDateTime] = Source.[GeneratedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [Milestone] = Source.[Milestone]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [GoalId], [DashboardId], [GeneratedDateTime], [CreatedByUserId],[Milestone]) VALUES ([Id], [GoalId], [DashboardId], [GeneratedDateTime], [CreatedByUserId],[Milestone]);

MERGE INTO [dbo].[LeaveAllowance] AS Target
USING ( VALUES
	  (NEWID(), @CompanyId, 2015, 12, GetDate(), @UserId)
	, (NEWID(), @CompanyId, 2016, 13, GetDate(), @UserId)
	, (NEWID(), @CompanyId, 2018, 14, GetDate(), @UserId)
	, (NEWID(), @CompanyId, 2017, 11, GetDate(), @UserId)
	, (NEWID(), @CompanyId, 2019, 11, GetDate(), @UserId)
	, (NEWID(), @CompanyId, 2020, 12, GetDate(), @UserId)
)

AS Source ([Id], [CompanyId], [Year], [NoOfLeaves], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [Year] = source.[Year],
		   [NoOfLeaves] = source.[NoOfLeaves],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [Year], [NoOfLeaves], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [Year], [NoOfLeaves], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[UserStoryWorkflowStatusTransition] AS TARGET
USING ( VALUES
   --    (NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-180,GETDATE()),DATEADD(MINUTE,-180,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
   --   ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
   --   ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
	  --,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-180,GETDATE()),DATEADD(MINUTE,-180,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
   --   ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
   --   ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
   --   ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-180,GETDATE()),DATEADD(MINUTE,-180,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
   --   ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
	  --,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-60,GETDATE()),DATEADD(MINUTE,-60,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
   --   ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-10,GETDATE()),DATEADD(MINUTE,-10,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Sample file for finding numbers using Big Data' AND P.CompanyId = @CompanyId))
       (NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Stored Procedures for Iot Project' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Inprogress' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'Kanban' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-10,GETDATE()),DATEADD(MINUTE,-10,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Stored Procedures for Iot Project' AND P.CompanyId = @CompanyId))
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Create Sample Rassberry Pi Project' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-10,GETDATE()),DATEADD(MINUTE,-10,GETDATE()),(SELECT US.OwnerUserId FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Create Sample Rassberry Pi Project' AND P.CompanyId = @CompanyId))
	  ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'A user that has access to a database c' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'A user that has access to a database c' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'A user that has access to a database c' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Though permissions can be granted to individual users,' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Though permissions can be granted to individual users,' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Though permissions can be granted to individual users,' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Though permissions can be granted to individual users,' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Though permissions can be granted to individual users,' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Adjusting the automatic failover time for SQL Server Database Mirroring' AND GoalName LIKE 'Scenarios TestData Bugs List' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Adjusting the automatic failover time for SQL Server Database Mirroring' AND GoalName LIKE 'Scenarios TestData Bugs List' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Adjusting the automatic failover time for SQL Server Database Mirroring' AND GoalName LIKE 'Scenarios TestData Bugs List' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'Adjusting the automatic failover time for SQL Server Database Mirroring' AND GoalName LIKE 'Scenarios TestData Bugs List' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'see CREATE USER (Transact-SQL).' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'see CREATE USER (Transact-SQL).' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
      ,(NEWID(),(SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId AND US.UserStoryName = 'see CREATE USER (Transact-SQL).' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId),@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WEST WHERE FromWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId) AND ToWorkflowUserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId) AND WorkflowId = (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId)),DATEADD(MINUTE,-150,GETDATE()),DATEADD(MINUTE,-150,GETDATE()),@UserId)
)
AS SOURCE (Id,UserStoryId,CompanyId,WorkflowEligibleStatusTransitionId,TransitionDateTime,CreatedDateTime,CreatedByUserId)
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET UserStoryId = Source.UserStoryId,
           CompanyId = Source.CompanyId,
		   WorkflowEligibleStatusTransitionId = Source.WorkflowEligibleStatusTransitionId,
		   TransitionDateTime = Source.TransitionDateTime,
		   CreatedDateTime = Source.CreatedDateTime,
		   CreatedByUserId = Source.CreatedByUserId
WHEN NOT MATCHED BY TARGET THEN 
INSERT (Id,UserStoryId,CompanyId,WorkflowEligibleStatusTransitionId,TransitionDateTime,CreatedDateTime,CreatedByUserId) VALUES (Id,UserStoryId,CompanyId,WorkflowEligibleStatusTransitionId,TransitionDateTime,CreatedDateTime,CreatedByUserId);

--LEAVE MANAGEMENT TEST DATA START--

MERGE INTO [dbo].[LeaveApplication] AS Target 
USING ( VALUES

        (NEWID(),@UserId,GETDATE(),'Test Leave1',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, 3, GETDATE()) AS DATE),	CAST(DATEADD(DAY, 3, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),@UserId,GETDATE(),'Test Leave2',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, 4, GETDATE()) AS DATE),	CAST(DATEADD(DAY, 4, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Rejected' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),@UserId,GETDATE(),'Test Leave3',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, 5, GETDATE()) AS DATE),	CAST(DATEADD(DAY, 5, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),

		(NEWID(),@UserId,GETDATE(),'Test Leave4',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -9, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -9, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),@UserId,GETDATE(),'Test Leave5',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -10, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -10, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Rejected' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),@UserId,GETDATE(),'Test Leave6',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -11, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -11, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),

		 (NEWID(),@UserId,GETDATE(),'Test Leave7',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -12, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -12, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),@UserId,GETDATE(),'Test Leave8',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -13, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -13, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Rejected' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),@UserId,GETDATE(),'Test Leave9',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -14, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -14, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),

		(NEWID(),@UserId,GETDATE(),'Test Leave10',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -5, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -5, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),@UserId,GETDATE(),'Test Leave11',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -6, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -6, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Rejected' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),@UserId,GETDATE(),'Test Leave12',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -7, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -7, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),

		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),'Test Leave13',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, 5, GETDATE()) AS DATE),	CAST(DATEADD(DAY, 5, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),'Test Leave14',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -10, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -10, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),'Test Leave15',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -13, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -13, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),

		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),'Test Leave16',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, 5, GETDATE()) AS DATE),	CAST(DATEADD(DAY, 5, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),'Test Leave17',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -10, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -10, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),'Test Leave18',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -13, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -13, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),

		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),'Test Leave19',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, 6, GETDATE()) AS DATE),	CAST(DATEADD(DAY, 6, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),'Test Leave20',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -8, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -8, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL),
		(NEWID(),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),'Test Leave21',(SELECT Id FROM LeaveType WHERE LeaveTypeName = 'Sick Leave' AND CompanyId = @CompanyId),CAST(DATEADD(DAY, -17, GETDATE()) AS DATE),	CAST(DATEADD(DAY, -17, GETDATE()) AS DATE),GETDATE(),@UserId,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId =@CompanyId)
		,(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),(SELECT Id FROM LeaveSession WHERE LeaveSessionName = 'Full Day' AND CompanyId = @CompanyId),NULL,NULL,NULL)
)
AS Source ([Id], [UserId], [LeaveAppliedDate], [LeaveReason], [LeaveTypeId], [LeaveDateFrom],[LeaveDateTo],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[OverallLeaveStatusId],[FromLeaveSessionId],[ToLeaveSessionId],[InActiveDateTime],[IsDeleted],[BackUpUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [UserId] = Source.[UserId],
	       [LeaveAppliedDate] = Source.[LeaveAppliedDate],
	       [LeaveReason] = Source.[LeaveReason],
	       [LeaveTypeId] = Source.[LeaveTypeId],
	       [LeaveDateFrom] = Source.[LeaveDateFrom],
	       [LeaveDateTo] = Source.[LeaveDateTo],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [UpdatedDateTime] = Source.[UpdatedDateTime],
		   [UpdatedByUserId] = Source.[UpdatedByUserId],
		   [OverallLeaveStatusId] = Source.[OverallLeaveStatusId],
		   [FromLeaveSessionId] = Source.[FromLeaveSessionId],
		   [ToLeaveSessionId] = Source.[ToLeaveSessionId],
		   [InActiveDateTime] = Source.[InActiveDateTime],
		   [IsDeleted] = Source.[IsDeleted],
		   [BackUpUserId] = Source.[BackUpUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [UserId], [LeaveAppliedDate], [LeaveReason], [LeaveTypeId], [LeaveDateFrom],[LeaveDateTo],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[OverallLeaveStatusId],[FromLeaveSessionId],[ToLeaveSessionId],[InActiveDateTime],[IsDeleted],[BackUpUserId]) VALUES ([Id], [UserId], [LeaveAppliedDate], [LeaveReason], [LeaveTypeId], [LeaveDateFrom],[LeaveDateTo],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[OverallLeaveStatusId],[FromLeaveSessionId],[ToLeaveSessionId],[InActiveDateTime],[IsDeleted],[BackUpUserId]);

MERGE INTO [dbo].[LeaveApplicationStatusSetHistory] AS Target 
USING ( VALUES

        (NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave1' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave1', 'Approved',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave2' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Rejected' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave2', 'Rejected',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave3' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave3', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave4' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave4', 'Approved',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave5' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Rejected' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave5', 'Rejected',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave6' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave6', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave7' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave7', 'Approved',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave8' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Rejected' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave8', 'Rejected',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave9' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave9', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave10' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave10', 'Approved',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave11' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Rejected' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave11', 'Rejected',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave12' AND UserId = @UserId),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave12', 'Applied',NULL,NULL),

		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave13' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),@UserId,	NULL,'Test Leave13', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave14' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),@UserId,	NULL,'Test Leave14', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave15' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),@UserId,	NULL,'Test Leave15', 'Applied',NULL,NULL),

		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave16' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),@UserId,	NULL,'Test Leave16', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave17' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),@UserId,	NULL,'Test Leave17', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave18' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Waiting for approval' AND CompanyId = @CompanyId),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),@UserId,	NULL,'Test Leave18', 'Applied',NULL,NULL),

		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave19' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),@UserId,	NULL,'Test Leave19', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave19' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave19', 'Approved',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave20' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),@UserId,	NULL,'Test Leave20', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave20' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave20', 'Approved',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave21' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),GETDATE(),@UserId,	NULL,'Test Leave21', 'Applied',NULL,NULL),
		(NEWID(),(SELECT Id FROM LeaveApplication WHERE LeaveReason = 'Test Leave21' AND UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM LeaveStatus WHERE LeaveStatusName = 'Approved' AND CompanyId = @CompanyId),@UserId,GETDATE(),@UserId,	NULL,'Test Leave21', 'Approved',NULL,NULL)

)
AS Source ([Id], [LeaveApplicationId], [LeaveStatusId],[LeaveStuatusSetByUserId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime],[Reason],[Description],[OldValue],[NewValue]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [LeaveApplicationId] = Source.[LeaveApplicationId],
	       [LeaveStatusId] = Source.[LeaveStatusId],
	       [LeaveStuatusSetByUserId] = Source.[LeaveStuatusSetByUserId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [InActiveDateTime] = Source.[InActiveDateTime],
		   [Reason] = Source.[Reason],
		   [Description] = Source.[Description],
		   [OldValue] = Source.[OldValue],
		   [NewValue] = Source.[NewValue]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [LeaveApplicationId], [LeaveStatusId], [LeaveStuatusSetByUserId],[CreatedDateTime], [CreatedByUserId], [InActiveDateTime],[Reason],[Description],[OldValue],[NewValue]) VALUES ([Id], [LeaveApplicationId], [LeaveStatusId],[LeaveStuatusSetByUserId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime],[Reason],[Description],[OldValue],[NewValue]);

UPDATE Employee SET GenderId = (SELECT Id FROM Gender WHERE Gender = 'Male' AND CompanyId = @CompanyId) WHERE UserId = @UserId
UPDATE Employee SET DateofBirth = DATEADD(YEAR, -20, GETDATE()) WHERE UserId = @UserId
UPDATE Employee SET MaritalStatusId = (SELECT Id FROM MaritalStatus WHERE MaritalStatus = 'Married' AND CompanyId = @CompanyId) WHERE UserId = @UserId
UPDATE Employee SET NationalityId = (SELECT Id FROM Nationality WHERE NationalityName = 'Angolian' AND CompanyId = @CompanyId) WHERE UserId = @UserId

UPDATE Employee SET GenderId = (SELECT Id FROM Gender WHERE Gender = 'Male' AND CompanyId = @CompanyId) WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)
UPDATE Employee SET DateofBirth = DATEADD(YEAR, -20, GETDATE()) WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)
UPDATE Employee SET MaritalStatusId = (SELECT Id FROM MaritalStatus WHERE MaritalStatus = 'Married' AND CompanyId = @CompanyId) WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)
UPDATE Employee SET NationalityId = (SELECT Id FROM Nationality WHERE NationalityName = 'Angolian' AND CompanyId = @CompanyId) WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)

UPDATE Employee SET GenderId = (SELECT Id FROM Gender WHERE Gender = 'Male' AND CompanyId = @CompanyId) WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)
UPDATE Employee SET DateofBirth = DATEADD(YEAR, -40, GETDATE()) WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)
UPDATE Employee SET MaritalStatusId = (SELECT Id FROM MaritalStatus WHERE MaritalStatus = 'Married' AND CompanyId = @CompanyId) WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)
UPDATE Employee SET NationalityId = (SELECT Id FROM Nationality WHERE NationalityName = 'Angolian' AND CompanyId = @CompanyId) WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)

--LEAVE MANAGEMENT TEST DATA END--

--Activity Tracker Start --

MERGE INTO [dbo].[ActivityTrackerConfigurationState] AS Target
USING ( VALUES
	(NEWID(), 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, @CompanyId)
)
AS Source (Id, IsTracking, IsScreenshot, IsDelete, DeleteRoles, IsRecord, RecordRoles, IsIdealTime, IdealTimeRoles, IsManualTime, ManualTimeRole, CompanyId)
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId] = Source.[CompanyId],
		    [Id] = Source.[Id],
			[IsTracking] = Source.[IsTracking],		   
			[IsScreenshot] = Source.[IsScreenshot],
			[IsDelete] = Source.[IsDelete],
			[DeleteRoles] = Source.[DeleteRoles],
			[IsRecord] = Source.[IsRecord],
			[RecordRoles] = Source.[RecordRoles],
			[IsIdealTime] =  Source.[IsIdealTime],
			[IdealTimeRoles] =  Source.[IdealTimeRoles],
			[IsManualTime] =  Source.[IsManualTime],
			[ManualTimeRole] =  Source.[ManualTimeRole]
WHEN NOT MATCHED BY TARGET THEN 
INSERT (Id, IsTracking, IsScreenshot, IsDelete, DeleteRoles, IsRecord, RecordRoles, IsIdealTime, IdealTimeRoles, IsManualTime, ManualTimeRole, CompanyId) VALUES
	    (Id, IsTracking, IsScreenshot, IsDelete, DeleteRoles, IsRecord, RecordRoles, IsIdealTime, IdealTimeRoles, IsManualTime, ManualTimeRole, CompanyId);

--MERGE INTO [dbo].[ActivityTrackerApplicationUrl] AS Target 
--USING ( VALUES 
--(NEWID(), N'468E34EC-53D6-444A-9434-7BC185C4CB6D', N'Google', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,NULL),
--(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Visual Studio Code', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,NULL),
--(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Microsoft Visual Studio', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 0,NULL),
--(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'SourceTree', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 0,NULL),
--(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Microsoft SQL Server Management Studio', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,NULL)
--)
--AS Source ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]) 
--ON Target.Id = Source.Id 
--WHEN MATCHED THEN 
--UPDATE SET [Id] = Source.[Id],
--		   [ActivityTrackerAppUrlTypeId] = Source.[ActivityTrackerAppUrlTypeId],		   
--		   [AppUrlName] = Source.[AppUrlName],
--		   [CreatedByUserId] = Source.[CreatedByUserId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CompanyId] = Source.[CompanyId],
--		   [IsProductive] = Source.[IsProductive],
--		   [AppUrlImage] = Source.[AppUrlImage]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]) VALUES
--       ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]);  

IF (SELECT COUNT(*) FROM Company WHERE Id=@CompanyId AND IndustryId NOT IN ('7499F5E3-0EF2-4044-B840-2411B68302F9', 'FEC07283-AA98-41E1-B3D3-28CD6C6C5D97','BBBB8092-EBCC-43FF-A039-5E3BD2FACE51','3AA49D13-76C9-4842-840E-4AC759B65DF8')) > 0
BEGIN
	MERGE INTO [dbo].[ActivityTrackerRolePermission] AS Target 
			USING ( VALUES 
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Consultant')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'HR Executive')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'HR Manager')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Software Trainee')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Analyst Developer')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'CEO')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Goal Responsible Person')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Digital Sales Executive')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Director')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Lead Generation Manager')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Recruiter')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Hr Consultant')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Senior Software Engineer')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Temp Grp')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Lead Developer')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Manager')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'QA')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Freelancer')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Software Engineer')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'COO')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Business Analyst')),
	  --      (NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Client')),
			(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Super Admin'))
			)  
			AS Source ([Id], [CompanyId],  [CreatedDateTime], [CreatedByUserId],  [IsDeleteScreenShots],[IsRecordActivity],[IsIdleTime],[IdleScreenShotCaptureTime],[IdleAlertTime],[IsManualEntryTime],[MinimumIdelTime],[IsOfflineTracking],[RoleId]) 
			ON Target.Id = Source.Id  
			WHEN MATCHED THEN 
			UPDATE SET [CompanyId] = Source.[CompanyId],
						[CreatedDateTime] = Source.[CreatedDateTime],
						[CreatedByUserId] = Source.[CreatedByUserId],		   
						[IsDeleteScreenShots] = Source.[IsDeleteScreenShots],
						[IsRecordActivity] = Source.[IsRecordActivity],
						[IsIdleTime] = Source.[IsIdleTime],
						[IdleScreenShotCaptureTime] = Source.[IdleScreenShotCaptureTime],
						[IdleAlertTime] = Source.[IdleAlertTime],
						[IsManualEntryTime] =  Source.[IsManualEntryTime],
						[MinimumIdelTime] = Source.[MinimumIdelTime],
						[IsOfflineTracking]= Source.[IsOfflineTracking],
						[RoleId] =  Source.[RoleId]
			WHEN NOT MATCHED BY TARGET THEN 
			INSERT ([Id], [CompanyId],  [CreatedDateTime], [CreatedByUserId], [IsDeleteScreenShots],[IsRecordActivity],[IsIdleTime],[IdleScreenShotCaptureTime],[IdleAlertTime],[IsManualEntryTime],[IsOfflineTracking],[RoleId]) VALUES
					([Id], [CompanyId],  [CreatedDateTime], [CreatedByUserId], [IsDeleteScreenShots],[IsRecordActivity],[IsIdleTime],[IdleScreenShotCaptureTime],[IdleAlertTime],[IsManualEntryTime],[IsOfflineTracking],[RoleId]);

	MERGE INTO [dbo].[ActivityTrackerScreenShotFrequency] AS Target 
	USING ( VALUES 
	(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  'Super Admin'))
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName = 'Super Admin')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  'Super Admin')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  'Super Admin')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName = 'Super Admin')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'CEO')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Goal Responsible Person')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Digital Sales Executive')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Director')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Lead Generation Manager')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Recruiter')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Hr Consultant')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Senior Software Engineer')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Temp Grp')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Lead Developer')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Manager')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'QA')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Freelancer')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Software Engineer')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'COO')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Business Analyst')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Client')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Super Admin'))
	)
	AS Source ([Id], [ScreenShotFrequency], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [Multiplier], [RoleId]) 
	ON Target.Id = Source.Id 
	WHEN MATCHED THEN 
	UPDATE SET [Id] = Source.[Id],
				[RoleId] = Source.[RoleId],
				[ScreenShotFrequency] = Source.[ScreenShotFrequency],		   
				[FrequencyIndex] = Source.[FrequencyIndex],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[CreatedDateTime] = Source.[CreatedDateTime],
				[ComapnyId] = Source.[ComapnyId],
				[Multiplier] = Source.[Multiplier]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [ScreenShotFrequency], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [Multiplier], [RoleId]) VALUES
			([Id], [ScreenShotFrequency], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [Multiplier], [RoleId]);	      
	  
	MERGE INTO [dbo].[ActivityTrackerRoleConfiguration] AS Target 
		USING ( VALUES 
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Consultant')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'HR Executive')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'HR Manager')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Software Trainee')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Analyst Developer')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'CEO')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Goal Responsible Person')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Digital Sales Executive')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Director')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Lead Generation Manager')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Recruiter')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Hr Consultant')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Senior Software Engineer')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Temp Grp')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Lead Developer')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Manager')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'QA')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Freelancer')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Software Engineer')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'COO')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Business Analyst')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Client')),
		(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Super Admin'))
		)
		AS Source ([Id], [ActivityTrackerAppUrlTypeId], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [RoleId]) 
		ON Target.Id = Source.Id 
		WHEN MATCHED THEN 
		UPDATE SET [Id] = Source.[Id],
					[RoleId] = Source.[RoleId],
					[ActivityTrackerAppUrlTypeId] = Source.[ActivityTrackerAppUrlTypeId],		   
					[FrequencyIndex] = Source.[FrequencyIndex],
					[CreatedByUserId] = Source.[CreatedByUserId],
					[CreatedDateTime] = Source.[CreatedDateTime],
					[ComapnyId] = Source.[ComapnyId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [ActivityTrackerAppUrlTypeId], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [RoleId]) VALUES
				([Id], [ActivityTrackerAppUrlTypeId], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [RoleId]);  
END

IF EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId IN ('7499F5E3-0EF2-4044-B840-2411B68302F9'))
BEGIN
	MERGE INTO [dbo].[ActivityTrackerRolePermission] AS Target 
			USING ( VALUES 
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'User')),
			--(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Manager')),
			(NEWID(),@CompanyId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, 1,1,1,0,0,1,10, 1, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Super Admin'))
			)  
			AS Source ([Id], [CompanyId],  [CreatedDateTime], [CreatedByUserId],  [IsDeleteScreenShots],[IsRecordActivity],[IsIdleTime],[IdleScreenShotCaptureTime],[IdleAlertTime],[IsManualEntryTime],[MinimumIdelTime],[IsOfflineTracking],[RoleId]) 
			ON Target.Id = Source.Id  
			WHEN MATCHED THEN 
			UPDATE SET [CompanyId] = Source.[CompanyId],
						[CreatedDateTime] = Source.[CreatedDateTime],
						[CreatedByUserId] = Source.[CreatedByUserId],		   
						[IsDeleteScreenShots] = Source.[IsDeleteScreenShots],
						[IsRecordActivity] = Source.[IsRecordActivity],
						[IsIdleTime] = Source.[IsIdleTime],
						[IdleScreenShotCaptureTime] = Source.[IdleScreenShotCaptureTime],
						[IdleAlertTime] = Source.[IdleAlertTime],
						[IsManualEntryTime] =  Source.[IsManualEntryTime],
						[MinimumIdelTime] = Source.[MinimumIdelTime],
						[IsOfflineTracking]= Source.[IsOfflineTracking],
						[RoleId] =  Source.[RoleId]
			WHEN NOT MATCHED BY TARGET THEN 
			INSERT ([Id], [CompanyId],  [CreatedDateTime], [CreatedByUserId], [IsDeleteScreenShots],[IsRecordActivity],[IsIdleTime],[IdleScreenShotCaptureTime],[IdleAlertTime],[IsManualEntryTime],[IsOfflineTracking],[RoleId]) VALUES
					([Id], [CompanyId],  [CreatedDateTime], [CreatedByUserId], [IsDeleteScreenShots],[IsRecordActivity],[IsIdleTime],[IdleScreenShotCaptureTime],[IdleAlertTime],[IsManualEntryTime],[IsOfflineTracking],[RoleId]);

	MERGE INTO [dbo].[ActivityTrackerScreenShotFrequency] AS Target 
	USING ( VALUES 
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'User')),
	--(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Manager')),
	(NEWID(), 0, -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, 0, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Super Admin'))
	)
	AS Source ([Id], [ScreenShotFrequency], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [Multiplier], [RoleId]) 
	ON Target.Id = Source.Id 
	WHEN MATCHED THEN 
	UPDATE SET [Id] = Source.[Id],
				[RoleId] = Source.[RoleId],
				[ScreenShotFrequency] = Source.[ScreenShotFrequency],		   
				[FrequencyIndex] = Source.[FrequencyIndex],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[CreatedDateTime] = Source.[CreatedDateTime],
				[ComapnyId] = Source.[ComapnyId],
				[Multiplier] = Source.[Multiplier]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [ScreenShotFrequency], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [Multiplier], [RoleId]) VALUES
			([Id], [ScreenShotFrequency], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [Multiplier], [RoleId]);	      
	  
	MERGE INTO [dbo].[ActivityTrackerRoleConfiguration] AS Target 
		USING ( VALUES 
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'User')),
		--(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Manager')),
		(NEWID(), N'83824C7A-EEC0-4F64-A1EE-D9967AA59536', -1, @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime),@CompanyId, (SELECT Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Super Admin'))
		)
		AS Source ([Id], [ActivityTrackerAppUrlTypeId], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [RoleId]) 
		ON Target.Id = Source.Id 
		WHEN MATCHED THEN 
		UPDATE SET [Id] = Source.[Id],
					[RoleId] = Source.[RoleId],
					[ActivityTrackerAppUrlTypeId] = Source.[ActivityTrackerAppUrlTypeId],		   
					[FrequencyIndex] = Source.[FrequencyIndex],
					[CreatedByUserId] = Source.[CreatedByUserId],
					[CreatedDateTime] = Source.[CreatedDateTime],
					[ComapnyId] = Source.[ComapnyId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [ActivityTrackerAppUrlTypeId], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [RoleId]) VALUES
				([Id], [ActivityTrackerAppUrlTypeId], [FrequencyIndex], [CreatedByUserId], [CreatedDateTime], [ComapnyId], [RoleId]);  
END

--MERGE INTO [dbo].[ActivityTrackerApplicationUrlRole] AS Target
--USING ( VALUES
--(NEWID(),@CompanyId,@UserId,GETDATE(),(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'Google' AND CompanyId = @CompanyId),(SELECT Id FROM Role WHERE CompanyId=@CompanyId AND RoleName =  N'Lead Developer')),
--(NEWID(),@CompanyId,@UserId,GETDATE(),(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'Visual Studio Code' AND CompanyId = @CompanyId),(SELECT Id FROM Role WHERE CompanyId=@CompanyId AND RoleName =  N'Software Engineer')),
--(NEWID(),@CompanyId,@UserId,GETDATE(),(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'Microsoft Visual Studio' AND CompanyId = @CompanyId),(SELECT Id FROM Role WHERE CompanyId=@CompanyId AND RoleName =  N'Software Engineer')),
--(NEWID(),@CompanyId,@UserId,GETDATE(),(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'Microsoft Visual Studio' AND CompanyId = @CompanyId),(SELECT Id FROM Role WHERE CompanyId=@CompanyId AND RoleName =  N'Lead Developer')),
--(NEWID(),@CompanyId,@UserId,GETDATE(),(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'Microsoft SQL Server Management Studio' AND CompanyId = @CompanyId),(SELECT Id FROM Role WHERE CompanyId=@CompanyId AND RoleName =  N'Software Engineer')),
--(NEWID(),@CompanyId,@UserId,GETDATE(),(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'SourceTree' AND CompanyId = @CompanyId),(SELECT Id FROM Role WHERE CompanyId=@CompanyId AND RoleName =  N'Lead Developer')),
--(NEWID(),@CompanyId,@UserId,GETDATE(),(SELECT Id FROM ActivityTrackerApplicationUrl WHERE AppUrlName = N'SourceTree' AND CompanyId = @CompanyId),(SELECT Id FROM Role WHERE CompanyId=@CompanyId AND RoleName =  N'Software Engineer'))
--)
--AS Source ([Id], [CompanyId], [CreatedByUserId], [CreatedByDateTime], [ActivityTrackerApplicationUrlId], [RoleId])
--ON Target.Id = Source.Id
--WHEN MATCHED THEN 
--UPDATE SET [Id] = Source.[Id],
--		   [CompanyId] = Source.[CompanyId],
--		   [CreatedByUserId] = Source.[CreatedByUserId],
--		   [CreatedByDateTime] = Source.[CreatedByDateTime],
--		   [ActivityTrackerApplicationUrlId] = Source.[ActivityTrackerApplicationUrlId],
--		   [RoleId] = Source.[RoleId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [CompanyId], [CreatedByUserId], [CreatedByDateTime], [ActivityTrackerApplicationUrlId],[RoleId]) VALUES
--       ([Id], [CompanyId], [CreatedByUserId], [CreatedByDateTime], [ActivityTrackerApplicationUrlId],[RoleId]);  

IF NOT EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='7499F5E3-0EF2-4044-B840-2411B68302F9')
BEGIN
	MERGE INTO [dbo].[UserMAC] AS Target
	USING ( VALUES
	(NEWID(), N'8CEC4BC10234', (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),(SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'5' AND CompanyId = @CompanyId),@CompanyId,@UserId,GETDATE()),
	(NEWID(), N'8CEC4BC10235', (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,@CompanyId,@UserId,GETDATE()),
	(NEWID(), N'8CEC4BC10236', (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,@CompanyId,@UserId,GETDATE()),
	(NEWID(), N'8CEC4BC10237', (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId),NULL,@CompanyId,@UserId,GETDATE()),
	(NEWID(), N'8CEC11223344', @UserId, (SELECT A.Id FROM ASSET A JOIN Product P ON P.Id = A.ProductId WHERE AssetNumber = N'M56' AND CompanyId = @CompanyId), @CompanyId, @UserId,GETDATE())
	)
	AS Source ([Id], [MACAddress], [UserId], [AssetId], [CompanyId], [CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [Id] = Source.[Id],
				[MACAddress] = Source.[MACAddress],
				[UserId] = Source.[UserId],
				[AssetId] = Source.[AssetId],
				[CompanyId] = Source.[CompanyId],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[CreatedDateTime] = Source.[CreatedDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [MACAddress], [UserId], [AssetId], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
			([Id], [MACAddress], [UserId], [AssetId], [CompanyId], [CreatedByUserId], [CreatedDateTime]); 
END
ELSE
BEGIN
	MERGE INTO [dbo].[Employee] AS Target
	USING ( VALUES
		((SELECT Id FROM Employee WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM [User] WHERE UserName LIKE '%Maria@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'8CEC4BC10234'),
		((SELECT Id FROM Employee WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM [User] WHERE UserName LIKE '%James@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'8CEC4BC10235'),
		((SELECT Id FROM Employee WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM [User] WHERE UserName LIKE '%David@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'8CEC4BC10236'),
		((SELECT Id FROM Employee WHERE UserId = (SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId)),(SELECT Id FROM [User] WHERE UserName LIKE '%Martinez@'+@CompanyName+'.com%' AND CompanyId = @CompanyId), N'8CEC4BC10237'),
		((SELECT Id FROM Employee WHERE UserId = @UserId),@UserId, N'8CEC4BC10238')
	)

	AS Source ([Id], [UserId], [MACAddress])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [UserId] = Source.[UserId],
			   MACAddress = Source.MACAddress
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [UserId], MACAddress) 
	VALUES ([Id], [UserId], MACAddress);
END

EXEC  [dbo].[USP_TestDataActivityTrackerInsertScript] @CompanyId = @CompanyId,@UserId = @UserId

-- Activity Tracker End --


--UPDATE UserStory SET ParentUserStoryId = (SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId 
--AND US.UserStoryName = 'For more information about users,' AND GoalName LIKE 'Test Scenarios' AND P.CompanyId = @CompanyId) FROM BugPriority BP WHERE BugPriorityId = BP.Id AND (BP.IsCritical = 1 OR BP.IsMedium = 1 )

--UPDATE UserStory SET ParentUserStoryId = (SELECT US.Id FROM UserStory US JOIN Goal G ON G.Id = US.GoalId JOIN Project P ON P.Id = G.ProjectId 
--AND US.UserStoryName = N'Create Sample App for finding room temp using IOT' AND GoalName LIKE 'IOT General' AND P.CompanyId = @CompanyId) FROM BugPriority BP WHERE BugPriorityId = BP.Id AND( BP.IsHigh = 1 OR BugPriorityId IS NULL)

UPDATE Goal SET [GoalStatusColor] = (SELECT [dbo].[Ufn_GoalColour](Id)) WHERE CreatedByUserId = @UserId
 
 DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%IOT%' AND CompanyId = @CompanyId)
 DECLARE @ProjectId2 UNIQUEIDENTIFIER = (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Rasberry PI%' AND CompanyId = @CompanyId)
 DECLARE @ProjectId3 UNIQUEIDENTIFIER = (SELECT P.Id FROM Project P WHERE ProjectName LIKE '%Big Data%' AND CompanyId = @CompanyId)

DECLARE @IOTGoalId UNIQUEIDENTIFIER = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
DECLARE @BigDataGoalId UNIQUEIDENTIFIER = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
DECLARE @RasberryGoalId UNIQUEIDENTIFIER = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)

DECLARE @IOTProjectId UNIQUEIDENTIFIER = (SELECT G.ProjectId FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
DECLARE @BigDataProjectId UNIQUEIDENTIFIER = (SELECT G.ProjectId FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
DECLARE @RasberryProjectId UNIQUEIDENTIFIER = (SELECT G.ProjectId FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)

DECLARE @IOTWorkflowId UNIQUEIDENTIFIER = (SELECT GF.WorkflowId FROM GoalWorkFlow GF 
INNER JOIN Goal G ON GF.GoalId = G.Id
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
DECLARE @BigDataWorkflowId UNIQUEIDENTIFIER = (SELECT GF.WorkflowId FROM GoalWorkFlow GF 
INNER JOIN Goal G ON GF.GoalId = G.Id
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
DECLARE @RasberryWorkflowId UNIQUEIDENTIFIER = (SELECT GF.WorkflowId FROM GoalWorkFlow GF 
INNER JOIN Goal G ON GF.GoalId = G.Id
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)



DECLARE @BugPriorityP0Id UNIQUEIDENTIFIER = (SELECT Id FROM BugPriority WHERE CompanyId = @CompanyId AND PriorityName LIKE '%P0%')
DECLARE @BugPriorityP1Id UNIQUEIDENTIFIER = (SELECT Id FROM BugPriority WHERE CompanyId = @CompanyId AND PriorityName LIKE '%P1%')
DECLARE @BugPriorityP2Id UNIQUEIDENTIFIER = (SELECT Id FROM BugPriority WHERE CompanyId = @CompanyId AND PriorityName LIKE '%P2%')
DECLARE @BugPriorityP3Id UNIQUEIDENTIFIER = (SELECT Id FROM BugPriority WHERE CompanyId = @CompanyId AND PriorityName LIKE '%P3%')

DECLARE @UserStoryTypeId UNIQUEIDENTIFIER = (SELECT Id FROM UserStoryType WHERE CompanyId = @CompanyId AND UserStoryTypeName LIKE '%Bug%')

DECLARE @NewStatusId UNIQUEIDENTIFIER = (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'New')
DECLARE @InProgressStatusId UNIQUEIDENTIFIER = (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'InProgress')
DECLARE @ResolvedStatusId UNIQUEIDENTIFIER = (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Resolved')
DECLARE @VerifiedStatusId UNIQUEIDENTIFIER = (SELECT Id FROM UserStoryStatus WHERE CompanyId = @CompanyId AND [Status] = 'Verified')
DECLARE @CurrentDate DATETIME = GetDate()


-- UserStory script

INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId],[Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 14', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-14', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 24', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-24', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 13', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-13', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 22', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-22', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 18', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-18', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 8', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-8', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 15', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL,@BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-15', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 3', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-3', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 2', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-2', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 6', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-6', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 10', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-10', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 23', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-23', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 17', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-17', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 16', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-16', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 7', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-7', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 21', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-21', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 20', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL,  @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-20', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 19', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL,  @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-19', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 5', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId,@CurrentDate, @UserId, NULL, NULL,  @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-4', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 1', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL,  @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-1', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @IOTGoalId, N'test user story 12', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL,  @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-12', NULL, NULL, @IOTWorkflowId,@IOTProjectId, NULL, 0)


INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 7', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-7', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 16', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-16', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 23', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-23', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 21', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-21', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 10', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-10', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 11', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-11', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 18', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-18', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 14', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-14', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 6', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-6', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 5', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-4', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 9', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-9', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 8', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-8', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 17', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-17', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 15', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-15', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 24', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-24', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 13', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-13', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 12', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-12', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 2', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-2', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 22', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-22', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @BigDataGoalId, N'test user story 3', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-3', NULL, NULL, @BigDataWorkflowId,@BigDataProjectId, NULL, 0)



INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 5', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-4', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 7', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-7', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 15', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-15', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 11', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-11', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 20', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-20', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 2', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP0Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-2', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 18', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-18', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 17', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-17', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 1', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-1', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 24', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-24', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 3', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP1Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-3', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId],[Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 22', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId,@CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-22', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 12', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-12', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 16', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-16', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 13', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId,@CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-13', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 10', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-10', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 21', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP2Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-21', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 23', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @VerifiedStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-23', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 4', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, NULL, NULL, NULL, NULL, NULL,@VerifiedStatusId, @CurrentDate, @UserId,@CurrentDate, @UserId, NULL, NULL,@BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-5', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 6', NULL, CAST(0.00 AS Decimal(18, 2)), NULL, @UserId, NULL, NULL, NULL, NULL, @InProgressStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-6', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 14', NULL, NULL, NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-14', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)
INSERT [dbo].[UserStory] ([Id], [GoalId], [UserStoryName], [Description], [EstimatedTime], [DeadLineDate], [OwnerUserId], [TestSuiteSectionId], [TestCaseId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ActualDeadLineDate], [ArchivedDateTime], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime], [InActiveDateTime], [VersionName], [EpicName], [UserStoryPriorityId], [UserStoryUniqueName], [ReviewerUserId], [ParentUserStoryId], [WorkFlowId],[ProjectId], [Tag], [IsForQa]) VALUES (NEWID(), @RasberryGoalId, N'test user story 8', NULL, NULL, NULL, @UserId, NULL, NULL, NULL, NULL, @NewStatusId, @CurrentDate, @UserId, @CurrentDate, @UserId, NULL, NULL, @BugPriorityP3Id, @UserStoryTypeId, NULL, NULL, NULL, N'', NULL, NULL, N'BUG-8', NULL, NULL, @RasberryWorkflowId,@RasberryProjectId, NULL, 0)


DECLARE @BDBUSId2 UNIQUEIDENTIFIER  = (SELECT Id FROM [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 2')


DECLARE @BDBUSId3 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 3')

DECLARE @BDBUSId5 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 5')

DECLARE @BDBUSId6 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 6')


DECLARE @BDBUSId7 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 7')

DECLARE @BDBUSId8 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 8')

DECLARE @BDBUSId9 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 9')

DECLARE @BDBUSId10 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 10')

DECLARE @BDBUSId11 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 11')

DECLARE @BDBUSId12 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 12')

DECLARE @BDBUSId13 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 13')

DECLARE @BDBUSId14 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 14')

DECLARE @BDBUSId15 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 15')

DECLARE @BDBUSId16 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 16')

DECLARE @BDBUSId17 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 17')

DECLARE @BDBUSId18 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 18')

DECLARE @BDBUSId21 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 21')

DECLARE @BDBUSId22 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 22')

DECLARE @BDBUSId23 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 23')

DECLARE @BDBUSId24 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Big Data Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 24')

INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId2, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId3, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId5, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId6, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId7, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId8, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId9, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId10, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId11, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId12, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId13, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId14, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId15, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId16, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId17, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId18, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId21, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId22, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId23, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId24, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)


INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId2, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId5, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId6, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId8, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId9, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId10, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId11, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId12, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId13, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId21, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId23, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId22, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(),@BDBUSId24, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)


INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId2, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId8, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId9, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId10, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId11, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId12, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId22, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)

INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId2, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId8, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId9, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId10, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId11, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId12, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @BDBUSId22, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)



DECLARE @RPBUSId1 UNIQUEIDENTIFIER  = (SELECT Id FROM [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 1')


DECLARE @RPBUSId2 UNIQUEIDENTIFIER  = (SELECT Id FROM [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 2')


DECLARE @RPBUSId3 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 3')

DECLARE @RPBUSId4 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 4')


DECLARE @RPBUSId5 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 5')

DECLARE @RPBUSId6 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 6')


DECLARE @RPBUSId7 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 7')

DECLARE @RPBUSId8 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 8')

DECLARE @RPBUSId10 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 10')

DECLARE @RPBUSId11 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 11')

DECLARE @RPBUSId12 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 12')

DECLARE @RPBUSId13 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 13')

DECLARE @RPBUSId14 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 14')

DECLARE @RPBUSId15 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 15')

DECLARE @RPBUSId16 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 16')

DECLARE @RPBUSId17 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 17')

DECLARE @RPBUSId18 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 18')

DECLARE @RPBUSId20 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 20')

DECLARE @RPBUSId21 UNIQUEIDENTIFIER = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 21')

DECLARE @RPBUSId22 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 22')

DECLARE @RPBUSId23 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 23')

DECLARE @RPBUSId24 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%Rasberry PI Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 24')


INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId1, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId2, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId3, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId4, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId5, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId6, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId7, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId8, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId10, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId11, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId12, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId13, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId14, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId15, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId16, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId17, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId18, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId20, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId21, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId22, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId23, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId24, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)


INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId1, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId2, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId3, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId4, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId6, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId10, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId11, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId15, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId20, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId21, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId23, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId22, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId24, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)


INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId2, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId3, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId4, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId20 , N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId22, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId23, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)

INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId2, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId3, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId4, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId20, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId22, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @RPBUSId23, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)


DECLARE @IOTBUSId1 UNIQUEIDENTIFIER  = (SELECT Id FROM [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 1')

DECLARE @IOTBUSId2 UNIQUEIDENTIFIER  = (SELECT Id FROM [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 2')


DECLARE @IOTBUSId3 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 3')

DECLARE @IOTBUSId5 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 5')

DECLARE @IOTBUSId6 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 6')


DECLARE @IOTBUSId7 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 7')

DECLARE @IOTBUSId8 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 8')

DECLARE @IOTBUSId9 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 9')


DECLARE @IOTBUSId10 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 10')

DECLARE @IOTBUSId12 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 12')

DECLARE @IOTBUSId13 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 13')

DECLARE @IOTBUSId14 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 14')

DECLARE @IOTBUSId15 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 15')

DECLARE @IOTBUSId16 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 16')

DECLARE @IOTBUSId17 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 17')

DECLARE @IOTBUSId18 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 18')

DECLARE @IOTBUSId19 UNIQUEIDENTIFIER  =  (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 19')

DECLARE @IOTBUSId20 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 20')

DECLARE @IOTBUSId21 UNIQUEIDENTIFIER = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 21')

DECLARE @IOTBUSId22 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 22')

DECLARE @IOTBUSId23 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 23')

DECLARE @IOTBUSId24 UNIQUEIDENTIFIER  = (SELECT Id from [UserStory] US WHERE
GoalId = (SELECT G.Id FROM Goal G
INNER JOIN Project P ON P.Id = G.ProjectId
WHERE GoalShortName LIKE '%IOT Bugs%' AND P.CompanyId = @CompanyId)
AND US.UserStoryName LIKE '%test user story 24')

INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId1, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId2, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId3, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId5, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId6, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId7, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId8, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId10, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId12, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId13, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId14, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId15, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId16, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId17, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId18, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId19, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId20, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId21, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId22, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId23, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId24, NULL, NULL, N'UserStory', N'UserStoryAdded',  GetDate(), @UserId, NULL, NULL)


INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId1, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId2, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId3, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId5, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId6, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId7, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId12, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId13, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId15, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId16, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId17, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId21, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId22, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId24, N'New', N'Inprogress', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)

INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId1, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId2, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId6, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId7, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId12, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId21, N'Inprogress', N'Resolved', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)

INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId1, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId2, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId6, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId7, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId12, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)
INSERT [dbo].[UserStoryHistory] ([Id], [UserStoryId], [OldValue], [NewValue], [FieldName], [Description], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES (NEWID(), @IOTBUSId21, N'Resolved', N'Verified', N'UserStoryStatus', N'UserStoryStatusChanged',  GetDate(), @UserId, NULL, NULL)

 EXEC [dbo].[USP_TestRailTestData] @CompanyId = @CompanyId,@UserId=@UserId,@ProjectId= @ProjectId

DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT top 1 Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

--MERGE INTO [dbo].[Folder] AS Target 
--USING ( VALUES
--		((SELECT Id FROM [User] WHERE UserName =  N'Maria@'+@CompanyName+'.com'    AND CompanyId = @CompanyId), (SELECT EmployeeNumber FROM Employee WHERE UserId = (SELECT Id FROM [User] WHERE UserName =  N'Maria@'+@CompanyName+'.com'    AND CompanyId = @CompanyId)), NULL, GETDATE(), @UserId, @StoreId, NULL),
--		((SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com'    AND CompanyId = @CompanyId), (SELECT EmployeeNumber FROM Employee WHERE UserId = (SELECT Id FROM [User] WHERE UserName =  N'James@'+@CompanyName+'.com'    AND CompanyId = @CompanyId)), NULL, GETDATE(), @UserId, @StoreId, NULL),
--		((SELECT Id FROM [User] WHERE UserName =  N'David@'+@CompanyName+'.com'    AND CompanyId = @CompanyId), (SELECT EmployeeNumber FROM Employee WHERE UserId = (SELECT Id FROM [User] WHERE UserName =  N'David@'+@CompanyName+'.com'    AND CompanyId = @CompanyId)), NULL, GETDATE(), @UserId, @StoreId, NULL),
--		((SELECT Id FROM [User] WHERE UserName =  N'Martinez@'+@CompanyName+'.com' AND CompanyId = @CompanyId), (SELECT EmployeeNumber FROM Employee WHERE UserId = (SELECT Id FROM [User] WHERE UserName =  N'Martinez@'+@CompanyName+'.com' AND CompanyId = @CompanyId)), NULL, GETDATE(), @UserId, @StoreId, NULL)
--) 
--AS Source ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) 
--ON Target.Id = Source.Id  
--WHEN MATCHED THEN 
--UPDATE SET [Id] = Source.[Id],
--           [FolderName] = Source.[FolderName],
--		   [ParentFolderId] = Source.[ParentFolderId],
--           [CreatedByUserId] = Source.[CreatedByUserId],
--           [CreatedDateTime] = Source.[CreatedDateTime],
--           [StoreId] = Source.[StoreId],
--		   [InActiveDateTime] = Source.[InActiveDateTime]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) VALUES ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]);

  DECLARE @UserstoryCount INT  = 1
  UPDATE UserStory SET UserStoryUniqueName = (@UserstoryCount + 0),@UserstoryCount = @UserstoryCount + 1
  FROM UserStoryType UST WHERE UST.Id = UserStory.UserStoryTypeId AND CompanyId = @CompanyId
  AND UST.IsUserStory = 1

  UPDATE UserStory SET UserStoryUniqueName =   ShortName + '-' +  CAST(ISNULL(UserStoryUniqueName,0) + 1 AS NVARCHAR(250))
  FROM UserStoryType UST WHERE UST.Id = UserStory.UserStoryTypeId AND CompanyId = @CompanyId
  AND UST.IsUserStory = 1
  
  DECLARE @BugsCount INT  = 1
 UPDATE UserStory SET UserStoryUniqueName = (@BugsCount + 0),@BugsCount = @BugsCount + 1
  FROM UserStoryType UST WHERE UST.Id = UserStory.UserStoryTypeId AND CompanyId = @CompanyId
  AND UST.IsBug = 1

  UPDATE UserStory SET UserStoryUniqueName =   ShortName + '-' +  CAST(ISNULL(UserStoryUniqueName,0) + 1 AS NVARCHAR(250))
  FROM UserStoryType UST WHERE UST.Id = UserStory.UserStoryTypeId AND CompanyId = @CompanyId
  AND UST.IsBug = 1

MERGE INTO [dbo].[RateSheet] AS Target
USING ( VALUES
	(newid(), @CompanyId, 'Regular Day - Early', (select top 1 Id From RateSheetFor where CompanyId = @CompanyId and RateSheetForName = 'Regular Day - Early'), (ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99),DATEADD(year, -2, GetDate()), @UserId),
	(newid(), @CompanyId, 'Bank Holiday - Early', (select top 1 Id From RateSheetFor where CompanyId = @CompanyId and RateSheetForName = 'Bank Holiday - Early'), (ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99), (ABS(CHECKSUM(NewId())) % 99),DATEADD(year, -2, GetDate()), @UserId)
	)
AS Source ([Id], CompanyId, RateSheetName, RateSheetForId, RatePerHour, RatePerHourMon, RatePerHourTue, RatePerHourWed, RatePerHourThu, RatePerHourFri, RatePerHourSat, RatePerHourSun,[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [Id] = Source.[Id],
		   CompanyId = source.CompanyId,
		   RateSheetName = source.RateSheetName,
		   RateSheetForId = Source.RateSheetForId,
		   RatePerHour = source.RatePerHour,
		   RatePerHourMon = source.RatePerHourMon,
		   RatePerHourTue = source.RatePerHourTue,
		   RatePerHourWed = source.RatePerHourWed,
		   RatePerHourThu = source.RatePerHourThu,
		   RatePerHourFri = source.RatePerHourFri,
		   RatePerHourSat = source.RatePerHourSat,
		   RatePerHourSun = source.RatePerHourSun,
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], CompanyId, RateSheetName, RateSheetForId, RatePerHour, RatePerHourMon, RatePerHourTue, RatePerHourWed, RatePerHourThu, RatePerHourFri, RatePerHourSat, RatePerHourSun,[CreatedDateTime], [CreatedByUserId])
VALUES ([Id], CompanyId, RateSheetName, RateSheetForId, RatePerHour, RatePerHourMon, RatePerHourTue, RatePerHourWed, RatePerHourThu, RatePerHourFri, RatePerHourSat, RatePerHourSun,[CreatedDateTime], [CreatedByUserId]);

DECLARE @CURRENCYCODE VARCHAR(20)
select @CURRENCYCODE = CY.CurrencyCode From Company CM
INNER JOIN SYS_Currency SC ON SC.Id = CM.CurrencyId
INNER JOIN Currency CY ON CM.Id = CY.CompanyId AND SC.CurrencyCode = CY.CurrencyCode
WHERE  CM.Id= @companyId

INSERT INTO EmployeeRateSheet(Id, RateSheetEmployeeId, RateSheetId, CompanyId, RateSheetName, RateSheetForId, RateSheetStartDate,RateSheetEndDate,RatePerHour,RatePerHourMon, RatePerHourTue,RatePerHourWed,
RatePerHourThu,RatePerHourFri,RatePerHourSat,RatePerHourSun,CreatedDateTime,CreatedByUserId,UpdatedDateTime,UpdatedByUserId,InActiveDateTime, RateSheetCurrencyId)
SELECT newid(), e.Id , r.Id, r.CompanyId, r.RateSheetName, r.RateSheetForId, GETDATE(),DATEADD(month, 3, getdate()),(ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99), 
(ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99),(ABS(CHECKSUM(NewId())) % 99),
r.CreatedDateTime,r.CreatedByUserId,r.UpdatedDateTime,r.UpdatedByUserId,r.InActiveDateTime,
( CASE WHEN @CURRENCYCODE IS NULL THEN (select Id from Currency where CompanyId=@companyId and CurrencyCode = 'GBP') ELSE (select Id from Currency where CompanyId=@companyId and CurrencyCode = @CURRENCYCODE) END) from 
RateSheet r
LEFT JOIN Employee e on 1= 1
LEFT JOIN EmployeeRateSheet er on r.id = er.RateSheetId and e.Id = er.RateSheetEmployeeId
WHERE er.Id is null and r.CompanyId = @CompanyId

INSERT INTO UserStoryWorkflowStatusTransition(Id,UserStoryId,CompanyId,WorkflowEligibleStatusTransitionId,TransitionDateTime,CreatedDateTime,CreatedByUserId)
SELECT NEWID(),US.Id,@CompanyId,(SELECT Id FROM WorkflowEligibleStatusTransition WHERE ToWorkflowUserStoryStatusId  IN 
							 (SELECT Id FROM UserStoryStatus WHERE [Status]  IN ('Deployed') AND CompanyId = @CompanyId)
							 AND FromWorkflowUserStoryStatusId  IN 
							 (SELECT Id FROM UserStoryStatus WHERE [Status]  IN ('Dev Completed') AND CompanyId = @CompanyId)),GETDATE(),GETDATE(),US.OwnerUserId 
FROM UserStory US WHERE UserStoryStatusId 
IN (SELECT Id FROM UserStoryStatus WHERE [Status]  IN ('Deployed') AND CompanyId = @CompanyId)

UPDATE Goal SET OnboardProcessDate = DATEADD(day,-1,GETDATE()) WHERE Id IN (SELECT G.Id FROM Goal G INNER JOIN Project P ON P.Id =G.ProjectId  
WHERE P.CompanyId = @CompanyId) AND OnboardProcessDate IS NOT NULL

UPDATE Goal SET GoalStatusColor= t.GoalStatusColor FROM 
(SELECT G.Id, dbo.[Ufn_GoalColour](G.Id)GoalStatusColor FROM Goal G INNER JOIN Project P ON P.Id = G.ProjectId  
WHERE P.CompanyId = @CompanyId AND OnboardProcessDate IS NOT NULL)t where t.Id =Goal.Id
 
    DECLARE @TestCaseId INT = 0
    UPDATE UserStory SET UserStoryUniqueName = (@TestCaseId + 0),@TestCaseId = @TestCaseId + 1  FROM UserStoryType UST
	WHERE UST.Id = UserStory.UserStoryTypeId AND UST.CompanyId = @CompanyId
	AND UserStory.UserStoryUniqueName IS NULL

   UPDATE UserStory SET UserStoryUniqueName = (SELECT SHORTNAME + '-' +  CAST(ISNULL(UserStoryUniqueName,0) + 1 AS NVARCHAR(250)))
   FROM UserStoryType UST WHERE UST.Id = UserStory.UserStoryTypeId AND UST.CompanyId =  @CompanyId
   AND UserStory.UserStoryUniqueName IS NULL

END
GO