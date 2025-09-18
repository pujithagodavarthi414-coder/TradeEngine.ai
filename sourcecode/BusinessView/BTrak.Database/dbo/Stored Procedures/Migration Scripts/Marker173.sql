CREATE PROCEDURE [dbo].[Marker173]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	MERGE INTO [dbo].[ActivityTrackerApplicationUrl] AS Target 
	USING ( VALUES 
	(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Visual Studio Code', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/projects/0b2921a9-e930-4013-9047-670b5352f308/download_(2)-76d9f8b7-e984-427b-9f02-1234498b3860.jpg'),
	(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Microsoft Visual Studio', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/projects/0b2921a9-e930-4013-9047-670b5352f308/images-8d79bcd2-d420-4763-a206-459f36747542.jpg'),
	(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'SourceTree', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/projects/0b2921a9-e930-4013-9047-670b5352f308/download_(3)-fa158923-b169-43b8-9eba-2190348b1486.jpg'),
	(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Microsoft SQL Server Management Studio', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/sqlserver-c64a1619-93b3-47db-8262-7feba3f3e077.png'),
	(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Snovasys Office Messenger', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/sno-8a5d84e5-4dbf-43c4-90db-20b5b605ecc2.png'),
	(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Microsoft Word', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/word-5642a506-6ceb-4da2-a79a-928f2078db91.png'),
	(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Microsoft PowerPoint', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/powerpoint-20c0c8d3-af79-4e96-9499-613931d31d45.png'),
	(NEWID(), N'D1376714-5DB6-4D14-8E11-B5AAC2C7C662', N'Microsoft Excel', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/excel-990965bd-1c35-4721-a407-e00f18450b4f.png'),
	(NEWID(), N'468E34EC-53D6-444A-9434-7BC185C4CB6D', N'Linkedin', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/linkedin-862733e2-4391-4daf-8f66-d50fad5ca07f.png'),
	(NEWID(), N'468E34EC-53D6-444A-9434-7BC185C4CB6D', N'stackoverflow', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 1,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/stackoverflow-84e057bb-6081-4639-8e2a-0f0f8cd557fd.png'),
	(NEWID(), N'468E34EC-53D6-444A-9434-7BC185C4CB6D', N'youtube', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 0,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/youtube-19c6f7f9-1ac1-43e8-aa3f-84a53bc79251.png'),
	(NEWID(), N'468E34EC-53D6-444A-9434-7BC185C4CB6D', N'netflix', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 0,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/netflix-7cff2635-d5fa-402c-ab0f-c231a9c7ac73.png'),
	(NEWID(), N'468E34EC-53D6-444A-9434-7BC185C4CB6D', N'primevideo', @UserId, CAST(N'2018-08-24T15:18:26.297' AS DateTime), @CompanyId, 0,'https://bviewstorage.blob.core.windows.net/e5e5fc16-97ff-4736-8568-d6aab8c7f08d/projects/b7170d13-3a54-478e-9e19-6ff01a654dc4/primevideo-712f322b-4dda-4ece-b4b2-21916fdc6651.jpg')
	)
	AS Source ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]) 
	ON Target.Id = Source.Id 
	WHEN MATCHED THEN 
	UPDATE SET [Id] = Source.[Id],
			   [ActivityTrackerAppUrlTypeId] = Source.[ActivityTrackerAppUrlTypeId],		   
			   [AppUrlName] = Source.[AppUrlName],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CompanyId] = Source.[CompanyId],
			   [IsProductive] = Source.[IsProductive],
			   [AppUrlImage] = Source.[AppUrlImage]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]) VALUES
		   ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]);  

	INSERT INTO ActivityTrackerApplicationUrlRole(Id,ActivityTrackerApplicationUrlId,RoleId,CompanyId,IsProductive,CreatedByUserId,CreatedByDateTime)
	SELECT NEWID(),A.Id AS ActivityTrackerApplicationUrlId,R.Id AS RoleId,@CompanyId AS CompanyId,
				CASE WHEN A.AppUrlName IN (N'Visual Studio Code',N'Microsoft SQL Server Management Studio',N'Microsoft Visual Studio',N'SourceTree',N'Microsoft PowerPoint',N'Snovasys Office Messenger',
							N'Microsoft Word',N'Microsoft Excel',N'Linkedin',N'stackoverflow') THEN 1 
							ELSE 0 END
				,@UserId AS CreatedByUserId,GETDATE() AS CreatedByDateTime
					FROM ActivityTrackerApplicationUrl AS A ,Role AS R 
				WHERE A.CompanyId = @CompanyId AND R.CompanyId =  @CompanyId AND (R.IsHidden <> 1 OR R.IsHidden IS NULL OR R.IsHidden= 0)

END
GO
