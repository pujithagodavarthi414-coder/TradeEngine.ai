CREATE PROCEDURE  [dbo].[USP_TestDataInsertScript]  
AS 
BEGIN 

-----------------------Update Company SET CompanyName = 'GK Solutions' where id = '4afeb444-e826-4f95-ac41-2175e36a0c16'

DECLARE @CompanyName Varchar(50) = 'Snovasys Software Solutions'
DECLARE @CompanyId Uniqueidentifier
SELECT @CompanyId = Id FROM Company where CompanyName = @CompanyName


MERGE INTO [dbo].[User] AS Target
USING ( VALUES
       (N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', @CompanyId, N'Garcia', N'Maria', N'Maria@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T19:41:04.277' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	   (N'5e22e01a-bf81-46c5-8a64-600600e0313d', @CompanyId, N'Johnson', N'James', N'James@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T19:40:12.007' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	   (N'db9458b5-d28b-4dd5-a059-69eea129df6e', @CompanyId, N'Smith', N'David', N'David@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T19:39:52.750' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	   (N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', @CompanyId, N'Martinez', N'Maria', N'Martinez@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T19:41:52.540' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	   (N'e38b057f-aa4e-4e63-b10a-74aa252aa004', @CompanyId, N'Rodriguez', N'Maria', N'Rodriguez@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T19:42:04.603' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	   (N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', @CompanyId, N'Smith', N'James', N'JamesSmith@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 1, 1, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T19:41:16.977' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	   (N'0019af86-8618-4f46-9dfa-a41d9e98275f', @CompanyId, N'Hernandez', N'Maria', N'Hernandez@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T19:41:41.400' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	   (N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', @CompanyId, N'Smith', N'Mary', N'Mary@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T19:42:15.717' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	   (N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', @CompanyId, N'Smith', N'Michael', N'Michael@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', NULL, 1, N'C527B633-9FB6-4D9F-BE87-5172DBE87D18', N'+919999999999', 0, 0, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T19:42:28.400' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	   (N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', @CompanyId, N'Smith', N'Robert', N'Robert@gmail.com', N'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi', 1, 1, N'557C436A-5D19-4EEB-A677-93EA2609EAF1', N'+919999999999', 0, 1, N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Capture-3c866fb0-416d-44b8-b761-033712f4a8c3.PNG', CAST(N'2019-03-01T06:21:58.010' AS DateTime), NULL, CAST(N'2019-03-01T06:21:58.010' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
)

AS Source ([Id], [CompanyId], [SurName], [FirstName], [UserName], [Password], [IsPasswordForceReset], [IsActive], [TimeZoneId], [MobileNo], [IsAdmin], [IsActiveOnMobile], [ProfileImage], [RegisteredDateTime], [LastConnection], [CreatedDateTime], [CreatedByUserId])
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
		   [ProfileImage] = source.[ProfileImage],
		   [RegisteredDateTime] = source.[RegisteredDateTime],
		   [LastConnection] = source.[LastConnection],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]

WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [SurName], [FirstName], [UserName], [Password], [IsPasswordForceReset], [IsActive], [TimeZoneId], [MobileNo], [IsAdmin], [IsActiveOnMobile], [ProfileImage], [RegisteredDateTime], [LastConnection], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [CompanyId], [SurName], [FirstName], [UserName], [Password], [IsPasswordForceReset], [IsActive], [TimeZoneId], [MobileNo], [IsAdmin], [IsActiveOnMobile], [ProfileImage], [RegisteredDateTime], [LastConnection], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Employee] AS Target
USING ( VALUES
	('906DE613-43BA-4563-AE6B-1F31512D0665','1C90BBEB-D85D-4BFB-97F5-48626F6CEB27',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
	('A841612D-894A-4539-ADAB-25F183B57315','5E22E01A-BF81-46C5-8A64-600600E0313D',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
	('30F6A3DD-D686-4F55-A3FC-473E5ED76976','DB9458B5-D28B-4DD5-A059-69EEA129DF6E',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
	('A3D2EA8F-046F-43D3-9F96-4773EB3FB225','E7499FA4-EBF5-4F82-BED1-6E23E42AC13F',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
	('F2E604DB-6317-4B08-805A-598C7881E821','E38B057F-AA4E-4E63-B10A-74AA252AA004',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
	('83E2DEEE-4943-4435-9CC9-5BE3204775F4','F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
	('331F0C6E-C573-4B69-B6D2-A1E548794967','0019AF86-8618-4F46-9DFA-A41D9E98275F',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
	('7A5CEE67-75AC-40F7-BC1F-AA5608AF9F2F','B3A4E6FA-9F71-441D-BBB6-AD1155243D64',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
	('B0D579BE-FD46-40F7-B3C6-C52393F2B1E9','52789CF1-DAE3-4FC8-88AD-E874FE1D6B34',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
	('F7A58F30-EA2F-452D-96A6-DB023885B2B7','000D7682-E46D-48C6-B7D8-B6509FABB3C0',null,null,null,null,null,null,null,null,getdate(),'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
)

AS Source ([Id], [UserId], [EmployeeNumber], [GenderId], [MaritalStatusId], [NationalityId], [DateofBirth], [Smoker], [MilitaryService], [NickName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserId] = Source.[UserId],
		   [EmployeeNumber] = source.[EmployeeNumber],
		   [GenderId] = source.[GenderId],
		   [MaritalStatusId] = Source.[MaritalStatusId],
		   [NationalityId] = source.[NationalityId],
		   [DateofBirth] = source.[DateofBirth],
		   [Smoker] = Source.[Smoker],
		   [MilitaryService] = source.[MilitaryService],
		   [NickName] = source.[NickName],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [UserId], [EmployeeNumber], [GenderId], [MaritalStatusId], [NationalityId], [DateofBirth], [Smoker], [MilitaryService], [NickName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [UserId], [EmployeeNumber], [GenderId], [MaritalStatusId], [NationalityId], [DateofBirth], [Smoker], [MilitaryService], [NickName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeReportTo] AS Target
USING ( VALUES
		 (N'0e66c6c1-ed62-4d9f-be2f-06f143f0e488', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'f437b2dc-5783-49a8-ba37-0a2a05efee98', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.213' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.213' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'c2ef3b50-310d-4a1c-8125-0e0ce4fd0d32', N'906de613-43ba-4563-ae6b-1f31512d0665', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.740' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.740' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'521af088-6f91-4bd7-96ae-127c4f5e1a07', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.410' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.410' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'9181d2f9-7290-48b1-84aa-1e4c03a69141', N'83e2deee-4943-4435-9cc9-5be3204775f4', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'151c1517-8bc6-4fd9-b72c-20512f216eed', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.420' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.420' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'ffc0b4df-d08a-4aa8-8223-2314c751a7e6', N'331f0c6e-c573-4b69-b6d2-a1e548794967', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.410' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.410' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'b864b04e-1894-4f68-b1ac-25def2c1e23f', N'f2e604db-6317-4b08-805a-598c7881e821', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'11b98c90-d6dd-4bea-8ce3-2cef9b83bfa7', N'906de613-43ba-4563-ae6b-1f31512d0665', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.403' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.403' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'96ae74bf-ba2e-4854-a0ff-30482f037b2c', N'331f0c6e-c573-4b69-b6d2-a1e548794967', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'd8d7bb51-9a3e-4418-9163-335cc18efcec', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'50d1ec9f-cf5b-4958-ba1f-356dedb4754a', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.747' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.747' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'99d7ee71-49be-4f53-83b0-386c13f38f96', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.213' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.213' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'39edeeb8-a112-4093-815f-3a74b0452fa2', N'a841612d-894a-4539-adab-25f183b57315', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.410' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.410' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'e4534bbc-2305-499b-9274-44ca46fb44d1', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'b4376541-b2b1-4109-88e3-4e96b1a73c6b', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'61908f56-c0f5-458f-860f-50a43bf6b881', N'f2e604db-6317-4b08-805a-598c7881e821', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'3e504e93-d757-4a03-b5ea-59a59464396a', N'a841612d-894a-4539-adab-25f183b57315', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'bc586fd9-427e-4245-b5aa-5a97558b6881', N'906de613-43ba-4563-ae6b-1f31512d0665', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.403' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.403' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'13de112f-7838-4bc2-a1ae-68b3c25e2668', N'331f0c6e-c573-4b69-b6d2-a1e548794967', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'72b836ac-173d-4ba6-8538-7025d78857e5', N'83e2deee-4943-4435-9cc9-5be3204775f4', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'4b0386b8-7a40-4617-aff9-70dd54ae4c89', N'a841612d-894a-4539-adab-25f183b57315', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'60e486be-2ce7-46b7-a95e-718abc31bd25', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.410' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.410' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'465b378f-9878-43be-b706-7aa5fa93f647', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'4ba30f2a-b3e0-4c73-87ef-7cd888e4b753', N'906de613-43ba-4563-ae6b-1f31512d0665', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'bcf8fcf6-1b41-4286-a541-84e110c3adce', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'0f2488e4-b217-483e-b05a-877edc8a6179', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'83af9d56-57a5-4f4e-ada7-8fe853c832eb', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.423' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.423' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'dd31a733-a45c-4341-a602-911eee55539d', N'331f0c6e-c573-4b69-b6d2-a1e548794967', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.420' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.420' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'017670e4-407e-4039-920d-92b532c80c0f', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.413' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.413' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'82a7abd7-86a4-4680-b959-9582e9e6d4d1', N'f2e604db-6317-4b08-805a-598c7881e821', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'fba3a9be-2064-4542-a642-9fb949849335', N'83e2deee-4943-4435-9cc9-5be3204775f4', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.417' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.417' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'7d8fdadd-a065-4644-aa2c-a27fad98e5e7', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.410' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.410' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'1ca2362a-cded-4cf3-949e-a77b537259d6', N'f2e604db-6317-4b08-805a-598c7881e821', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.413' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.413' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'48480da4-e4b4-42cf-9cda-ab7826795b56', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:30:09.427' AS DateTime), NULL, CAST(N'2019-03-19T17:30:09.427' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'7d4ee17e-9f7e-4b56-9d46-abf8caa7dd77', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), NULL, CAST(N'2019-03-20T10:21:16.743' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'494859be-9e9e-447c-aec6-bca7f3b72680', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.213' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.213' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'0f628213-5a16-4fcf-a763-db0c857185b6', N'83e2deee-4943-4435-9cc9-5be3204775f4', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.407' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'9bd34068-a90f-4725-bb2d-dc65bdf15563', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-19T17:28:51.410' AS DateTime), NULL, CAST(N'2019-03-19T17:28:51.410' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'f7f191d5-0e0e-4510-9b2a-fb1de5ea6694', N'a841612d-894a-4539-adab-25f183b57315', NULL, N'f2e604db-6317-4b08-805a-598c7881e821', NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.210' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')

)
AS Source ([Id], [EmployeeId], [ReportingMethodId], [ReportToEmployeeId], [OtherText], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [EmployeeId] = Source.[EmployeeId],
		   [ReportingMethodId] = source.[ReportingMethodId],
		   [ReportToEmployeeId] = source.[ReportToEmployeeId],
		   [OtherText] = source.[OtherText],
		   [ActiveFrom] = source.[ActiveFrom],
		   [ActiveTo] = source.[ActiveTo],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [EmployeeId], [ReportingMethodId], [ReportToEmployeeId], [OtherText], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [EmployeeId], [ReportingMethodId], [ReportToEmployeeId], [OtherText], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]);


MERGE INTO [dbo].[EmployeeBranch] AS Target
USING ( VALUES
		 (N'aa4cd629-529a-44a3-adc6-13190fb9f025', N'906de613-43ba-4563-ae6b-1f31512d0665', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'fd563c64-dbd4-485a-b6da-20fb02333e65', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'5339df5b-7a4d-477f-920f-2f527b576902', N'83e2deee-4943-4435-9cc9-5be3204775f4', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'3d27bca0-4569-4c26-b646-3157cf8a3141', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'5fd68d4a-912e-43f7-90e2-55ced0aae368', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'ec32771e-4e19-4e12-901d-a628372e1f72', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'e370dba7-460d-49e3-bf19-acb099f0c446', N'331f0c6e-c573-4b69-b6d2-a1e548794967', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'f71fbf11-7bd6-4f40-8e7f-b5c889aa8750', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'10c29518-c06e-46ec-99f8-ced6fe8fa9b2', N'f2e604db-6317-4b08-805a-598c7881e821', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
        ,(N'1811c9d9-1e02-4396-b2fd-d1a0214efc69', N'a841612d-894a-4539-adab-25f183b57315', N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2017-03-22T16:21:13.007' AS DateTime), NULL, CAST(N'2019-03-20T16:22:15.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
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

MERGE INTO [dbo].[EmployeeShift] AS Target
USING ( VALUES
		 ('FA879F03-054F-4217-BC3E-B27773A1521F',N'140e994a-b455-4acd-bcb9-18a6ee72a674',N'906DE613-43BA-4563-AE6B-1F31512D0665',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,('D0F56FB2-380D-4220-A306-2DC67E37BAF9',N'19077c23-c740-4f33-b19a-246dbc5477c6',N'A841612D-894A-4539-ADAB-25F183B57315',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,('56C28EB9-44DA-4994-AF50-F4C8AC94A857',N'7047c4ed-db57-458c-9845-276ed8c3ae55',N'30F6A3DD-D686-4F55-A3FC-473E5ED76976',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,('15FB4718-DBA7-445B-84B2-4D0DF15B226D',N'87fe2aff-90c6-4989-98d3-2e4320f70405',N'A3D2EA8F-046F-43D3-9F96-4773EB3FB225',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,('D88AB8FA-5AFF-4F50-A622-5931620C2EA7',N'a80d3387-888e-4eff-a69e-31775a9b68b2',N'F2E604DB-6317-4B08-805A-598C7881E821',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,('2F23AB0A-7088-4C04-A163-C0E3F939400B',N'e157301a-4289-4a42-a642-ab6488b81e1d',N'83E2DEEE-4943-4435-9CC9-5BE3204775F4',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,('17AB560A-AC24-4DA1-B1FF-8FECA8B637E1',N'2361e0d1-86ba-4900-8e8a-b8de43083e8d',N'331F0C6E-C573-4B69-B6D2-A1E548794967',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,('4577F4EB-D04C-41F5-B18F-F41C20688BCB',N'64df5d66-b5ec-4ab9-9402-cc8f17a38994',N'7A5CEE67-75AC-40F7-BC1F-AA5608AF9F2F',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,('7E01FCBF-FB9D-4463-B805-7C4A69854EB8',N'140e994a-b455-4acd-bcb9-18a6ee72a674',N'B0D579BE-FD46-40F7-B3C6-C52393F2B1E9',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
		,('9AA57DD0-1C88-445A-8E58-B8EDD4C9DA09',N'19077c23-c740-4f33-b19a-246dbc5477c6',N'F7A58F30-EA2F-452D-96A6-DB023885B2B7',CAST(N'2019-03-21T11:37:09.943' AS DateTime),NULL,CAST(N'2019-03-21T11:37:09.943' AS DateTime),N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
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

MERGE INTO [dbo].[PermissionConfiguration] AS Target
USING ( VALUES
        (N'2a9519fb-e7a3-4bcd-aa97-8bfcd34e3e4f', N'Permissions based on goal status'),
		(N'0c7996e2-5f0e-4733-9de8-fff09291b370', N'Permissions based on user story status')
)

AS Source ([Id], [Permission])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [Permission] = Source.[Permission]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [Permission]) VALUES ([Id], [Permission]);      

MERGE INTO [dbo].[Project] AS Target
USING ( VALUES
        (N'068EEAEA-B54F-47E3-9064-5D2AE28BADFF', @CompanyId, N'IOT', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', NULL, NULL),
		(N'F69CF3E3-F077-4D31-B8C0-583C5FB0B4E2', @CompanyId, N'Rasberry PI', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', NULL, NULL),
		(N'69D86700-0DF4-46FD-ABD5-6C35ABBD8889', @CompanyId, N'Big Data', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', NULL, NULL),
		(N'636BBBB7-BD22-4B3B-A67B-41AF4ABEE2A9', @CompanyId, N'Cyber Security', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', NULL, NULL),
		(N'7D9C19E8-B67F-434F-B54A-F4A6C094F7E6', @CompanyId, N'Umbraco', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', NULL, NULL),
		(N'A55F00E8-840C-492F-A893-60F0E27EFCCA', @CompanyId, N'Artificial Intelligence', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', NULL, NULL),
		(N'FD1909A0-0BDE-4555-9D59-61027BFA3A32', @CompanyId, N'Image Processing', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',NULL, NULL),
		(N'A3EAD0C0-A236-4C81-9C9D-AC10F012A5BF', @CompanyId, N'Automatic Teller Machine', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',NULL, NULL),
		(N'A483A084-7232-4101-9579-4662243D184A', @CompanyId, N'Face Recognition', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', NULL, NULL),
		(N'730CB4F3-8B2F-4362-986D-E423B167B2D9', @CompanyId, N'Data Mining ', NULL, CAST(N'2019-02-28T13:27:46.553' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', NULL, NULL)
)

AS Source ([Id], [CompanyId], [ProjectName], [ProjectResponsiblePersonId], [CreatedDateTime], [CreatedByUserId], [ProjectStatusColor], [ProjectTypeId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [ProjectName] = Source.[ProjectName],
		   [ProjectResponsiblePersonId] = Source.[ProjectResponsiblePersonId],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [ProjectStatusColor] = Source.[ProjectStatusColor],
		   [ProjectTypeId] = Source.[ProjectTypeId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [ProjectName], [ProjectResponsiblePersonId], [CreatedDateTime], [CreatedByUserId], [ProjectStatusColor], [ProjectTypeId]) VALUES ([Id], [CompanyId], [ProjectName], [ProjectResponsiblePersonId], [CreatedDateTime], [CreatedByUserId], [ProjectStatusColor], [ProjectTypeId]);      

MERGE INTO [dbo].[Goal] AS Target
USING ( VALUES
        (N'01FBFB3F-16F7-46B1-9503-2597763CE685', N'068EEAEA-B54F-47E3-9064-5D2AE28BADFF', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'IOT General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'IOT General', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',N'7A79AB9F-D6F0-40A0-A191-CED6C06656DE', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'89D5370B-FB0E-4FE9-BBF2-92D7B07302C7', N'068EEAEA-B54F-47E3-9064-5D2AE28BADFF', N'b2683875-8ff4-4826-877d-3119b776441e', N'IOT Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'IOT Sql',  N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'9585FF58-1236-45A8-96D9-AA1EC701B79C', N'068EEAEA-B54F-47E3-9064-5D2AE28BADFF', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'IOT Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'IOT Bugs', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'264E74F4-040A-4532-83E2-DBDAC671A221', N'F69CF3E3-F077-4D31-B8C0-583C5FB0B4E2', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Rasberry PI General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Rasberry PI General', N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',  N'7A79AB9F-D6F0-40A0-A191-CED6C06656DE', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'234EBB9D-195E-4BCA-B6B8-B7589A80A48A', N'F69CF3E3-F077-4D31-B8C0-583C5FB0B4E2', N'b2683875-8ff4-4826-877d-3119b776441e', N'Rasberry PI Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Rasberry PI Sql', N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'523C99C0-4086-49F2-9B40-AFCB2E54E878', N'F69CF3E3-F077-4D31-B8C0-583C5FB0B4E2', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Rasberry PI Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Rasberry PI Bugs', N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'954299FC-DBBB-4C28-B25F-F87C67977A05', N'69D86700-0DF4-46FD-ABD5-6C35ABBD8889', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Big Data General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Big Data General', N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',N'7A79AB9F-D6F0-40A0-A191-CED6C06656DE', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'A8CABFF3-0B65-4760-BABB-989F390BAF70', N'69D86700-0DF4-46FD-ABD5-6C35ABBD8889', N'b2683875-8ff4-4826-877d-3119b776441e', N'Big Data Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Big Data Sql',  N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'B3105E68-7705-4D85-8567-572C8519D139', N'69D86700-0DF4-46FD-ABD5-6C35ABBD8889', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Big Data Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Big Data Bugs',  N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'3C7DE47A-167E-4D5D-A6A2-C9C45129AE9E', N'636BBBB7-BD22-4B3B-A67B-41AF4ABEE2A9', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Cyber Security General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Cyber Security General',  N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7A79AB9F-D6F0-40A0-A191-CED6C06656DE', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'99E8E01A-3695-49FE-98A5-F7B2855AD597', N'636BBBB7-BD22-4B3B-A67B-41AF4ABEE2A9', N'b2683875-8ff4-4826-877d-3119b776441e', N'Cyber Security Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Cyber Security Sql',  N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'4C52A26A-3F78-413C-9198-88A3D18484D8', N'636BBBB7-BD22-4B3B-A67B-41AF4ABEE2A9', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Cyber Security Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Cyber Security Bugs',  N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'BAFC9BF2-9C98-4354-8848-6CD3C863B033', N'7D9C19E8-B67F-434F-B54A-F4A6C094F7E6', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Umbraco general', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Umbraco general',  N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',  N'7A79AB9F-D6F0-40A0-A191-CED6C06656DE', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'B98833A8-8C9F-44DD-AD37-573B7C249C59', N'7D9C19E8-B67F-434F-B54A-F4A6C094F7E6', N'b2683875-8ff4-4826-877d-3119b776441e', N'Umbraco Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Umbraco Sql',  N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'B7287544-7E91-42DB-ACB5-6ACB64CF02CA', N'7D9C19E8-B67F-434F-B54A-F4A6C094F7E6', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Umbraco Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Umbraco Bugs',  N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'941069AA-D073-4604-866C-56471E0E868C', N'A55F00E8-840C-492F-A893-60F0E27EFCCA', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Artificial Intelligence General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Artificial Intelligence General',  N'E38B057F-AA4E-4E63-B10A-74AA252AA004', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'97CD4FAD-3A78-425B-AD29-8CC94C68F020', N'A55F00E8-840C-492F-A893-60F0E27EFCCA', N'b2683875-8ff4-4826-877d-3119b776441e', N'Artificial Intelligence Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Artificial Intelligence Sql',  N'E38B057F-AA4E-4E63-B10A-74AA252AA004', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'EB4AB72D-A0DD-4F05-B8C2-F568CEE06EF5', N'A55F00E8-840C-492F-A893-60F0E27EFCCA', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Artificial Intelligence Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Artificial Intelligence Bugs',  N'E38B057F-AA4E-4E63-B10A-74AA252AA004', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'7547E3AD-0141-4D13-8E92-FB3B2551A9FF', N'FD1909A0-0BDE-4555-9D59-61027BFA3A32', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Image Processing General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Image Processing General',  N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'E2ACBE61-DC24-42DF-81FA-634922343532', N'FD1909A0-0BDE-4555-9D59-61027BFA3A32', N'b2683875-8ff4-4826-877d-3119b776441e', N'Image Processing Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Image Processing Sql',  N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'2D4FCC04-F220-4545-AEE4-565FFC7792E2', N'FD1909A0-0BDE-4555-9D59-61027BFA3A32', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Image Processing Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Image Processing Bugs',  N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'B3D81FED-37D2-4362-8F82-EAB79DE521EB', N'A3EAD0C0-A236-4C81-9C9D-AC10F012A5BF', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'ATM General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'ATM General',  N'5E22E01A-BF81-46C5-8A64-600600E0313D', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),		
		(N'48CA9964-5BFB-47A2-B509-D6E371CBE129', N'A3EAD0C0-A236-4C81-9C9D-AC10F012A5BF', N'b2683875-8ff4-4826-877d-3119b776441e', N'ATM Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'ATM Sql',  N'5E22E01A-BF81-46C5-8A64-600600E0313D', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL,NULL, NULL),
		(N'9AA12E0F-F75C-4308-920C-9BCB8E4E9CF7', N'A3EAD0C0-A236-4C81-9C9D-AC10F012A5BF', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'ATM Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'ATM Bugs', N'5E22E01A-BF81-46C5-8A64-600600E0313D', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'ABAFC577-8261-4E3F-95CC-59E8807DF29A', N'A483A084-7232-4101-9579-4662243D184A', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'FR General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Operation System General',  N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'D31EFF15-B9D2-4A85-8F3D-83B2EA475C6A', N'A483A084-7232-4101-9579-4662243D184A', N'b2683875-8ff4-4826-877d-3119b776441e', N'FR Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'FR Sql', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL,  NULL, NULL),
		(N'DBC7DBD6-1C54-4648-BD44-B23BE01FDB96', N'A483A084-7232-4101-9579-4662243D184A', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'FR Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'FR Bugs', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'8D064DCA-752E-49E6-B471-D85843B68F03', N'730CB4F3-8B2F-4362-986D-E423B167B2D9', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Data Mining General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Data Mining General',  N'0019AF86-8618-4F46-9DFA-A41D9E98275F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL,NULL, NULL),
		(N'EEF8519D-A9FB-42B4-8240-B0A692C2E4DB', N'730CB4F3-8B2F-4362-986D-E423B167B2D9', N'b2683875-8ff4-4826-877d-3119b776441e', N'Data Mining Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Data Mining Sql',  N'0019AF86-8618-4F46-9DFA-A41D9E98275F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL,NULL, NULL),
		(N'C4B73DC1-D186-4F6A-9B43-40E20BE078E1', N'730CB4F3-8B2F-4362-986D-E423B167B2D9', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Data Mining Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Data Mining Bugs', N'0019AF86-8618-4F46-9DFA-A41D9E98275F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'4998026f-0ace-4eb3-ba78-e4f12149980a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'b2683875-8ff4-4826-877d-3119b776441e', N'IOT Scores', NULL, CAST(N'2019-03-01T00:00:00.000' AS DateTime), 0, N'IOT Scores',  N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-01T19:55:31.680' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'97f89037-8dbe-4452-b7fd-c01b2e2f5805', N'7d9c19e8-b67f-434f-b54a-f4a6c094f7e6', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Umbraco System', NULL, CAST(N'2019-03-02T00:00:00.000' AS DateTime), 0, N'Umbraco System',  N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-01T19:59:20.827' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'28f3d700-6b57-41c2-952c-61288fafde32', N'f69cf3e3-f077-4d31-b8c0-583c5fb0b4e2', N'b2683875-8ff4-4826-877d-3119b776441e', N'Rassberry PI scores', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Rassberry PI scores', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-01T19:57:38.967' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'037e41b7-aee6-4171-a8e7-4878ae0f82fd', N'69d86700-0df4-46fd-abd5-6c35abbd8889', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Big Data Scores', NULL, CAST(N'2019-03-02T00:00:00.000' AS DateTime), 0, N'Big Data Scores',  N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-01T19:46:49.513' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'4F6AD92E-38A2-46D0-B16B-46EC51E0666D', N'69d86700-0df4-46fd-abd5-6c35abbd8889', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Big Data Replan', NULL, CAST(N'2019-03-02T00:00:00.000' AS DateTime), 0, N'Big Data Replan',  N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-01T19:46:49.513' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'AD16FC34-9072-4129-B0C4-99312D3B0092', N'69d86700-0df4-46fd-abd5-6c35abbd8889', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Big Data Backlog', NULL, CAST(N'2019-03-02T00:00:00.000' AS DateTime), 0, N'Big Data Backlog', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-01T19:46:49.513' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'BCDB8250-B2B6-4629-B838-FE820B344B17', N'f69cf3e3-f077-4d31-b8c0-583c5fb0b4e2', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Rassberry PI Replan', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Rassberry PI Replan',  N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-01T19:57:38.967' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'E31EEED8-9048-4F4E-B8DA-2D57CA535778', N'f69cf3e3-f077-4d31-b8c0-583c5fb0b4e2', N'b2683875-8ff4-4826-877d-3119b776441e', N'Rassberry PI Backlog', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Rassberry PI Backlog', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-01T19:57:38.967' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'E3ADACA0-B8C9-41B4-B0D5-09EE60B12F20', N'7d9c19e8-b67f-434f-b54a-f4a6c094f7e6', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'Umbraco Replan', NULL, CAST(N'2019-03-02T00:00:00.000' AS DateTime), 0, N'Umbraco Replan',  N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-01T19:59:20.827' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'39DB508B-EA34-4483-88AD-6DE518E59D25', N'7d9c19e8-b67f-434f-b54a-f4a6c094f7e6', N'b2683875-8ff4-4826-877d-3119b776441e', N'Umbraco Backlog', NULL, CAST(N'2019-03-02T00:00:00.000' AS DateTime), 0, N'Umbraco Backlog',  N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-01T19:59:20.827' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'C4291D09-BA6F-45FF-BA84-7B8CA0E5D507', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'b2683875-8ff4-4826-877d-3119b776441e', N'IOT Replan', NULL, CAST(N'2019-03-01T00:00:00.000' AS DateTime), 0, N'IOT Replan', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-01T19:55:31.680' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'5142C4AA-B831-403D-AE98-07C9398DE111', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'IOT Backlog', NULL, CAST(N'2019-03-01T00:00:00.000' AS DateTime), 0, N'IOT Backlog', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-01T19:55:31.680' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, N'00000000-0000-0000-0000-000000000000', N'', NULL),
		(N'A2311594-5D75-4A72-AA26-377C0A587487', N'730CB4F3-8B2F-4362-986D-E423B167B2D9', N'b2683875-8ff4-4826-877d-3119b776441e', N'Data Mining Replan', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Data Mining Replan',  N'0019AF86-8618-4F46-9DFA-A41D9E98275F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'4FF2C500-B0F5-4644-935D-CBA8EE002C2B', N'730CB4F3-8B2F-4362-986D-E423B167B2D9', N'b2683875-8ff4-4826-877d-3119b776441e', N'Data Mining Backlog', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Data Mining Backlog',  N'0019AF86-8618-4F46-9DFA-A41D9E98275F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'64BEF4B2-B1ED-4824-81D9-9171DD4B5A64', N'A483A084-7232-4101-9579-4662243D184A', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'FR Replan', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'FR Replan',  N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'D3E2D424-A07B-497C-B5DF-F6982A543C68', N'A483A084-7232-4101-9579-4662243D184A', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'FR Backlog', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'FR Backlog',  N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'B69823F8-01BA-4671-A87D-EEDB755865F1', N'A3EAD0C0-A236-4C81-9C9D-AC10F012A5BF', N'b2683875-8ff4-4826-877d-3119b776441e', N'ATM Replan', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'ATM Replan', N'5E22E01A-BF81-46C5-8A64-600600E0313D', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'51D88383-916B-4590-85CC-4E97CC6F33CF', N'A3EAD0C0-A236-4C81-9C9D-AC10F012A5BF', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'ATM Backlog', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'ATM Backlog',  N'5E22E01A-BF81-46C5-8A64-600600E0313D', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',  N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'D59A1A0E-FCA7-4568-997D-EC6CFB846932', N'FD1909A0-0BDE-4555-9D59-61027BFA3A32', N'b2683875-8ff4-4826-877d-3119b776441e', N'Image Processing Replan', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Image Processing Replan', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'17FF025C-4742-4913-802F-D27CAED2F87B', N'FD1909A0-0BDE-4555-9D59-61027BFA3A32', N'b2683875-8ff4-4826-877d-3119b776441e', N'Image Processing Backlog', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Image Processing Backlog',  N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',  N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'3304DA13-AED9-4294-89DB-57B3D781495A', N'636BBBB7-BD22-4B3B-A67B-41AF4ABEE2A9', N'b2683875-8ff4-4826-877d-3119b776441e', N'Cyber Security Replan', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Cyber Security Replan',  N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'143E2F9C-2AE9-411E-9133-E55B01035D05', N'636BBBB7-BD22-4B3B-A67B-41AF4ABEE2A9', N'b2683875-8ff4-4826-877d-3119b776441e', N'Cyber Security Backlog', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Cyber Security Backlog',  N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',  N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'3EB98D40-122B-44A5-994C-7E27650CA48F', N'A55F00E8-840C-492F-A893-60F0E27EFCCA', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Artificial Intelligence Replan', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Artificial Intelligence Replan', N'E38B057F-AA4E-4E63-B10A-74AA252AA004', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'5af65423-afc4-4e9d-a011-f4df97ed5faf', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL),
		(N'4B34D328-9401-43B6-BE50-0B1916A3865C', N'A55F00E8-840C-492F-A893-60F0E27EFCCA', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'Artificial Intelligence Backlog', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'Artificial Intelligence Backlog',  N'E38B057F-AA4E-4E63-B10A-74AA252AA004', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'f6f118ea-7023-45f1-bcf6-ce6db1cee5c3', NULL, NULL, N'#b7b7b7', 1, NULL, NULL, 1, 1, NULL, NULL, NULL)
		,(N'16945B9B-618B-469F-83A4-8937B1086FA8', N'068EEAEA-B54F-47E3-9064-5D2AE28BADFF', N'28009e1d-eb84-41f0-9541-e10f054fe6c1', N'IOT General', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'IOT General',  N'127133F1-4427-4149-9DD6-B02E0E036971', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',  N'7A79AB9F-D6F0-40A0-A191-CED6C06656DE', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL)
		,(N'05BB6D88-AFD2-4C3F-AE30-075F561FFF2B', N'068EEAEA-B54F-47E3-9064-5D2AE28BADFF', N'b2683875-8ff4-4826-877d-3119b776441e', N'IOT Sql', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'IOT Sql',  N'127133F1-4427-4149-9DD6-B02E0E036971', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL)
		,(N'436B041E-EC20-4E0F-85FC-600B7C3E067A', N'068EEAEA-B54F-47E3-9064-5D2AE28BADFF', N'F28643CA-9F23-42E0-B51E-03F82A99A281', N'IOT Bugs', NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), 0, N'IOT Bugs', N'127133F1-4427-4149-9DD6-B02E0E036971', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',  N'7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, NULL, N'#04fe02', 1, NULL, NULL, 1, 1, NULL, NULL, NULL)
)

AS Source ([Id], [ProjectId], [BoardTypeId], [GoalName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalShortName], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[GoalStatusId], [ConfigurationId], 
[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsParked], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
 [Version], [ParkedDateTime]) 
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [ProjectId] = Source.[ProjectId],
		   [BoardTypeId] = Source.[BoardTypeId],
		   [GoalName] = Source.[GoalName],
		   [GoalBudget] = Source.[GoalBudget],
		   [OnboardProcessDate] = Source.[OnboardProcessDate],
		   [IsLocked] = Source.[IsLocked],
		   [GoalShortName] = Source.[GoalShortName],
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
		   [Version] = Source.[Version],
		   [ParkedDateTime] = Source.[ParkedDateTime]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [ProjectId], [BoardTypeId], [GoalName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalShortName], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[GoalStatusId], [ConfigurationId], 
[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
 [Version], [ParkedDateTime]) VALUES ([Id], [ProjectId], [BoardTypeId], [GoalName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalShortName], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId], [GoalStatusId], [ConfigurationId], 
[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
 [Version], [ParkedDateTime]);     
 
MERGE INTO [dbo].[UserStory] AS Target
USING ( VALUES
        (N'd06d0b85-ba72-47d7-ae0e-01ec75e11373', N'3c7de47a-167e-4d5d-a6a2-c9c45129ae9e', N'Create Sample application for salting password using Cyber Security', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D', NULL, NULL,N'US-1'),
		 (N'a69a1636-9ee6-4bc3-8f73-04cf0dc56c3d', N'abafc577-8261-4e3f-95cc-59e8807df29a', N'FR System', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D', NULL, NULL,N'US-2'),
		 (N'066e793b-fc9a-478a-8f2f-06fb158052d7', N'97cd4fad-3a78-425b-ad29-8cc94c68f020', N'Functions for AI', CAST(5.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D', NULL, NULL,N'US-3'),
		 (N'5de9e4f6-c7ca-4390-9d68-17db10155d71', N'941069aa-d073-4604-866c-56471e0e868c', N'Create Sample AI Project', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',  CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D', NULL, NULL,N'US-4'),
		 (N'83c07f12-610d-47d3-87ff-1d8b8e8f93de', N'8d064dca-752e-49e6-b471-d85843b68f03', N'Sample application for Data Mining', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime),  NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D', NULL, NULL,N'US-5'),
		 (N'035ef61d-60c2-4633-a66f-216c4040be49', N'b98833a8-8c9f-44dd-ad37-573b7c249c59', N'functions for umbraco', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'e38b057f-aa4e-4e63-b10a-74aa252aa004', NULL, 27, N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D', NULL, NULL,N'US-6'),
		 (N'4d850f7e-b3c9-4341-872c-2b6f09beadde', N'99e8e01a-3695-49fe-98a5-f7b2855ad597', N'stored procs for cyber security', CAST(7.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', NULL, 27, N'67260E91-CDEF-41D0-AEBC-C48FD4DE814D', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-7'),
		 (N'0d94bbcd-e88b-451d-903f-2de5346f2a41', N'4998026f-0ace-4eb3-ba78-e4f12149980a', N'Delete Scores', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-02T00:00:00.000' AS DateTime), N'e38b057f-aa4e-4e63-b10a-74aa252aa004', NULL, 2, N'7503dace-d75a-4df1-b687-64334263b908', CAST(N'2019-03-01T19:56:12.243' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-02T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-8'),
		 (N'c9b482a5-a0dc-40e8-84e4-347d67a8ec34', N'037e41b7-aee6-4171-a8e7-4878ae0f82fd', N'Update Scores', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-16T00:00:00.000' AS DateTime), N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', NULL, 4, N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', CAST(N'2019-03-01T19:47:33.510' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-16T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-9'),
		 (N'7c710f24-a663-417f-a206-3bf5cb21f769', N'4998026f-0ace-4eb3-ba78-e4f12149980a', N'Add scores', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', NULL, 1, N'7503dace-d75a-4df1-b687-64334263b908', CAST(N'2019-03-01T19:55:53.447' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-10'),
		 (N'256e63ca-398f-4cda-94ea-45c69a7c1fe4', N'89d5370b-fb0e-4fe9-bbf2-92d7b07302c7', N'Functions for Iot Project', CAST(2.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'db9458b5-d28b-4dd5-a059-69eea129df6e', NULL, 27, N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-12'),
		 (N'0f2ea47e-deb6-4f15-a59f-46f1dec10871', N'037e41b7-aee6-4171-a8e7-4878ae0f82fd', N'Edit Scores', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-11T00:00:00.000' AS DateTime), N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', NULL, 3, N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', CAST(N'2019-03-01T19:47:32.933' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-11T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-13'),
		 (N'f6658662-34e0-4254-8aa9-50a02aee91d9', N'037e41b7-aee6-4171-a8e7-4878ae0f82fd', N'Add  Scores', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-15T00:00:00.000' AS DateTime), N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', NULL, 1, N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', CAST(N'2019-03-01T19:47:31.007' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-15T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-14'),
		 (N'26343798-a7b4-44d5-8dfa-532e932e9642', N'037e41b7-aee6-4171-a8e7-4878ae0f82fd', N'Delete Scores', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-03T00:00:00.000' AS DateTime), N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', NULL, 2, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-01T19:47:32.347' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-03T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-15'),
		 (N'f5e1d216-e3c0-4d83-b56d-59302a85827c', N'99e8e01a-3695-49fe-98a5-f7b2855ad597', N'functions for cyber security', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', NULL, 27, N'E1418CE8-A51B-4DE5-AFF3-42F8A588E3AE', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-16'),
		 (N'e1f9c151-0dca-4d93-a68b-5974bb7e2eca', N'01fbfb3f-16f7-46b1-9503-2597763ce685', N'Create Sample App for finding room temp using IOT', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'e38b057f-aa4e-4e63-b10a-74aa252aa004', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-17'),
		 (N'c33599f6-81a4-4688-a27e-5b0fa510235f', N'97f89037-8dbe-4452-b7fd-c01b2e2f5805', N'Edit data', CAST(8.00 AS Decimal(18, 2)), CAST(N'2019-03-05T00:00:00.000' AS DateTime), N'e38b057f-aa4e-4e63-b10a-74aa252aa004', NULL, 2, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-01T19:59:33.230' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',  CAST(N'2019-03-05T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-18'),
		 (N'116e83bc-1f7c-4e48-b558-6cc87299b06e', N'954299fc-dbbb-4c28-b25f-f87c67977a05', N'Create Sample Big Data project', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'db9458b5-d28b-4dd5-a059-69eea129df6e', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',  CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-19'),
		 (N'0809a724-6a96-4581-a7df-7d3c7a80758a', N'97f89037-8dbe-4452-b7fd-c01b2e2f5805', N'Add data', CAST(6.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'db9458b5-d28b-4dd5-a059-69eea129df6e', NULL, 1, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-01T19:59:32.603' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-20'),
		 (N'f633c431-f38f-402b-bd8d-7f16b495bd76', N'941069aa-d073-4604-866c-56471e0e868c', N'Create AI Mini Project', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', NULL, 27, N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-22'),
		 (N'62b3c0f8-d0f8-493e-83b9-8e7c463099a4', N'28f3d700-6b57-41c2-952c-61288fafde32', N'To compress data to Zip file', CAST(10.00 AS Decimal(18, 2)), CAST(N'2019-03-07T00:00:00.000' AS DateTime), N'db9458b5-d28b-4dd5-a059-69eea129df6e', NULL, 3, N'7503dace-d75a-4df1-b687-64334263b908', CAST(N'2019-03-01T20:03:53.870' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-07T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-23'),
		 (N'1182056b-3c1a-412a-a86d-94dfb68efeab', N'e2acbe61-dc24-42df-81fa-634922343532', N'Stored procs for Image Processing', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'e38b057f-aa4e-4e63-b10a-74aa252aa004', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-24'),
		 (N'9c1dc578-65a7-4b2d-9084-95aa86070c7c', N'a8cabff3-0b65-4760-babb-989f390baf70', N'Stored procs for Big Data', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-25'),
		 (N'963c9fe7-f822-4b5a-a7de-9f7be098bb90', N'abafc577-8261-4e3f-95cc-59e8807df29a', N'Create Sample FR System', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', NULL, 27, N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-26'),
		 (N'2cffc146-58d0-4222-9591-a8deef40297e', N'264e74f4-040a-4532-83e2-dbdac671a221', N'Create App for face detection using Rassberry PI', CAST(6.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-27'),
		 (N'1a6fe6cc-46d4-47d6-9d67-ac53bb1b6fbc', N'954299fc-dbbb-4c28-b25f-f87c67977a05', N'Sample file for finding numbers using Big Data', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'db9458b5-d28b-4dd5-a059-69eea129df6e', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',  CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-28'),
		 (N'6c791803-33ad-462f-aef1-ae094df02d8c', N'28f3d700-6b57-41c2-952c-61288fafde32', N'Edit and Delete Data', CAST(10.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', NULL, 2, N'7503dace-d75a-4df1-b687-64334263b908', CAST(N'2019-03-01T20:03:28.403' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-29'),
		 (N'57546f6b-1004-4ceb-8953-aeaa928f9da6', N'8d064dca-752e-49e6-b471-d85843b68f03', N'Data Mining', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'5e22e01a-bf81-46c5-8a64-600600e0313d', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-30'),
		 (N'804fdd71-990d-441e-bf11-b4adebe43e4a', N'bafc9bf2-9c98-4354-8848-6cd3c863b033', N'Create Sample umbraco Project', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-31'),
		 (N'8f01fa40-bb99-4ba3-b667-b5b9a321d8e6', N'97cd4fad-3a78-425b-ad29-8cc94c68f020', N'stored procs for AI', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-32'),
		 (N'db49feb7-49a0-498c-91b2-b81ec0ec8d8a', N'48ca9964-5bfb-47a2-b509-d6e371cbe129', N'Functions for ATM', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'e38b057f-aa4e-4e63-b10a-74aa252aa004', NULL, 27, N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-33'),
		 (N'4ed3fa60-eef5-406c-88b8-c31019b7afe4', N'48ca9964-5bfb-47a2-b509-d6e371cbe129', N'Stored procs for ATM', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',  CAST(N'2019-03-04T00:00:00.000' AS DateTime),  NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-34'),
		 (N'6e513940-d5e2-4e32-9628-c760de8d3a81', N'7547e3ad-0141-4d13-8e92-fb3b2551a9ff', N'Sample Image recognisation using Image Processing ', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'db9458b5-d28b-4dd5-a059-69eea129df6e', NULL, 27, N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-35'),
		 (N'6995a750-d8c6-4e8c-b519-cb2d5c1f2cea', N'eef8519d-a9fb-42b4-8240-b0a692c2e4db', N'Functions for Data Mining', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', NULL, 27, N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-36'),
		 (N'3cdd7559-07b6-46ab-8176-d0f8dddb3daf', N'b3d81fed-37d2-4362-8f82-eab79de521eb', N'Create Sample ATM app', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-37'),
		 (N'9d3099ad-a275-4d3a-a23a-dc65c186c14a', N'b3d81fed-37d2-4362-8f82-eab79de521eb', N'ATM', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', NULL, 27, N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',  CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-38'),
		 (N'1f6c9053-575d-4d17-b68d-e1979181cc6d', N'a8cabff3-0b65-4760-babb-989f390baf70', N'Functions for Big Data', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', NULL, 27, N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-39'),
		 (N'06f47320-6e13-4c77-b067-e62b4f6b8b69', N'b98833a8-8c9f-44dd-ad37-573b7c249c59', N'stored procs for umbraco', CAST(6.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'e38b057f-aa4e-4e63-b10a-74aa252aa004', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-40'),
		 (N'8e81ba3e-5d0f-43d8-857a-e8055b1f3441', N'7547e3ad-0141-4d13-8e92-fb3b2551a9ff', N'Create Sample Image Processing', CAST(8.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'e38b057f-aa4e-4e63-b10a-74aa252aa004', NULL, 27, N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-41'),
		 (N'4b77337d-3c5d-4b90-ac99-e833dedd294a', N'28f3d700-6b57-41c2-952c-61288fafde32', N'Add data for system', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-03T00:00:00.000' AS DateTime), N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', NULL, 1, N'67260e91-cdef-41d0-aebc-c48fd4de814d', CAST(N'2019-03-01T19:57:58.870' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-03T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-42'),
		 (N'318063d2-16b0-4c50-af22-ec46ec8130ab', N'3c7de47a-167e-4d5d-a6a2-c9c45129ae9e', N'Create Sample Cyber Security App', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-43'),
		 (N'dcd68db6-494f-41ad-a932-ee9a673b4287', N'01fbfb3f-16f7-46b1-9503-2597763ce685', N'Create Sample Iot Project', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-44'),
		 (N'eeb5e917-f828-4edc-b9fb-f25cf21582aa', N'264e74f4-040a-4532-83e2-dbdac671a221', N'Create Sample Rassberry Pi Project', CAST(4.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', NULL, 27, N'b3b17186-6d07-4416-878d-f78a73a753fc', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-45'),
		 (N'1d324bba-9229-42fb-ab21-f3946eb08e43', N'234ebb9d-195e-4bca-b6b8-b7589a80a48a', N'Stored Procedures for Rassberry Pi', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-46'),
		 (N'73684c44-7120-4984-a995-f828fe4c0535', N'89d5370b-fb0e-4fe9-bbf2-92d7b07302c7', N'Stored Procedures for Iot Project', CAST(6.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'0019af86-8618-4f46-9dfa-a41d9e98275f', NULL, 27, N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-47'),
		 (N'd0c60f7c-5ff5-465e-9c57-fb8662731e1a', N'bafc9bf2-9c98-4354-8848-6cd3c863b033', N'Design a website using umbraco', CAST(1.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', NULL, 27, N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-48'),
		 (N'7a110ece-fbc2-43ab-b02f-fd3e42f2472d', N'eef8519d-a9fb-42b4-8240-b0a692c2e4db', N'Stored procs for Data Mining', CAST(5.00 AS Decimal(18, 2)), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', NULL, 27, N'47332259-7d32-479d-a704-569c00f2b0b3', CAST(N'2019-03-04T11:57:28.517' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',  CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL,N'6C32EE90-F5C4-4081-94B3-8143A4C4847D',NULL,NULL,N'US-49')
)
AS Source ([Id], [GoalId], [UserStoryName], [EstimatedTime], [DeadLineDate], [OwnerUserId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [ActualDeadLineDate], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime],[UserStoryUniqueName])
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
           [BugPriorityId] = Source.[BugPriorityId],
           [UserStoryTypeId] = Source.[UserStoryTypeId],
           [ParkedDateTime] = Source.[ParkedDateTime],
		   [UserStoryUniqueName] = Source.[UserStoryUniqueName]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [GoalId], [UserStoryName], [EstimatedTime], [DeadLineDate], [OwnerUserId], [DependencyUserId], [Order], [UserStoryStatusId], [CreatedDateTime], [CreatedByUserId], [ActualDeadLineDate], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime],[UserStoryUniqueName]) VALUES ([Id], [GoalId], [UserStoryName], [EstimatedTime], [DeadLineDate], [OwnerUserId], [DependencyUserId], [Order], [UserStoryStatusId], 
[CreatedDateTime], [CreatedByUserId], [ActualDeadLineDate], [BugPriorityId], [UserStoryTypeId], [ProjectFeatureId], [ParkedDateTime],[UserStoryUniqueName]);      

MERGE INTO [dbo].[ProjectFeature] AS Target
USING ( VALUES
        (N'4b9c840e-ae3f-4a61-afad-01410c6a650e', N'Database', N'068EEAEA-B54F-47E3-9064-5D2AE28BADFF', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'5e332160-b4ca-4659-80b2-01f1d9116bc7', N'General', N'068EEAEA-B54F-47E3-9064-5D2AE28BADFF', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'f2ee6245-a59c-4e61-9198-068b37e2645b', N'Database', N'F69CF3E3-F077-4D31-B8C0-583C5FB0B4E2', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'fc896ce6-f1c9-4bd8-a3cf-08ddadce359b', N'General', N'F69CF3E3-F077-4D31-B8C0-583C5FB0B4E2', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'0c8f93a3-208c-4e93-abef-0a13c8be8431', N'General', N'69D86700-0DF4-46FD-ABD5-6C35ABBD8889', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'c9aeb2a9-94f7-4468-823c-0afab2ebff54', N'Database', N'69D86700-0DF4-46FD-ABD5-6C35ABBD8889', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'69c5afe4-9e6f-4d9e-9a92-0d96e5f34e66', N'General', N'636BBBB7-BD22-4B3B-A67B-41AF4ABEE2A9', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'9d178239-bdc2-4d99-b739-10f7910cdd3b', N'Database', N'636BBBB7-BD22-4B3B-A67B-41AF4ABEE2A9', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'3dfb9bca-565a-4aaa-872f-15406b997646', N'General', N'7D9C19E8-B67F-434F-B54A-F4A6C094F7E6', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'57fcc32b-4bf6-4215-97ff-156986ee6e47', N'Database', N'7D9C19E8-B67F-434F-B54A-F4A6C094F7E6', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'ff53c0bf-71de-4c1a-b28e-1681854acfc9', N'General', N'A55F00E8-840C-492F-A893-60F0E27EFCCA', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'E7B96941-C699-4F4D-B370-82D43B0BE41D', N'Database', N'A55F00E8-840C-492F-A893-60F0E27EFCCA', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'F7845179-B1F8-4B3F-BB1C-1D9166E086D0', N'General', N'FD1909A0-0BDE-4555-9D59-61027BFA3A32', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'2AB94627-F19B-4717-9E73-9ACC2E3555A7', N'Database', N'FD1909A0-0BDE-4555-9D59-61027BFA3A32', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'9881A54B-30DD-4B26-B158-28E80FD0ED5F', N'General', N'A3EAD0C0-A236-4C81-9C9D-AC10F012A5BF', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'7C6A2C87-F0DB-481C-8648-3CF70468F4D9', N'Database', N'A3EAD0C0-A236-4C81-9C9D-AC10F012A5BF', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'94326A70-633B-4768-9A3A-B33A8B2BAF36', N'General', N'A483A084-7232-4101-9579-4662243D184A', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'8E91CA3C-24AE-4B58-BD3C-E2460F402162', N'Database', N'A483A084-7232-4101-9579-4662243D184A', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'22353049-C8A4-4622-BF26-BDBDB8C20B6E', N'General', N'730CB4F3-8B2F-4362-986D-E423B167B2D9', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime)),
		(N'DAA0473E-2868-46C7-8C69-21BD895BCE80', N'Database', N'730CB4F3-8B2F-4362-986D-E423B167B2D9', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2019-02-28T04:25:37.970' AS DateTime))
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

MERGE INTO [dbo].[UserStoryLogTime] AS Target
USING ( VALUES
        (N'47e2a6fb-f817-4965-b0cd-0013787a99b2', N'DCD68DB6-494F-41AD-A932-EE9A673B4287', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'22436869-18a5-4cfa-80b4-0020346393d8', N'E1F9C151-0DCA-4D93-A68B-5974BB7E2ECA', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-03-01T04:13:35.630' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'4ffb05a6-fa6f-49c7-857c-0023266d7fbe', N'73684C44-7120-4984-A995-F828FE4C0535', CAST(N'2019-03-01T04:13:00.270' AS DateTime), CAST(N'2019-03-01T04:13:35.630' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'e4e8a35c-2c2d-465d-b01e-0031a2734f53', N'256E63CA-398F-4CDA-94EA-45C69A7C1FE4', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'897106ee-4622-45c5-8cc8-00328546e585', N'EEB5E917-F828-4EDC-B9FB-F25CF21582AA', CAST(N'2019-03-02T04:13:00.270' AS DateTime), CAST(N'2019-03-02T04:13:35.630' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'191eeaae-3d0e-47c7-b746-00392700d455', N'2CFFC146-58D0-4222-9591-A8DEEF40297E', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'62808868-9604-4e87-9db7-003e5c0c312b', N'1D324BBA-9229-42FB-AB21-F3946EB08E43', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'1523c61e-457e-4459-a277-0042a17452a8', N'1A6FE6CC-46D4-47D6-9D67-AC53BB1B6FBC', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'462758b8-328b-400f-a68e-0046a3016d2c', N'1A6FE6CC-46D4-47D6-9D67-AC53BB1B6FBC', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'521ec9b6-d190-4147-9c50-004d621a0454', N'9C1DC578-65A7-4B2D-9084-95AA86070C7C', CAST(N'2019-03-01T04:13:00.270' AS DateTime), CAST(N'2019-03-02T04:13:35.630' AS DateTime), N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'3929e99c-dfc7-4ece-9580-005095c316e1', N'1F6C9053-575D-4D17-B68D-E1979181CC6D', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'755a13bf-1a72-4e09-a558-005f3042ec95', N'318063D2-16B0-4C50-AF22-EC46EC8130AB', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'cdfc59ea-6dc6-402b-8ba6-008506fa17c1', N'D06D0B85-BA72-47D7-AE0E-01EC75E11373', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'000D7682-E46D-48C6-B7D8-B6509FABB3C0',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'81d11d53-996f-4ae5-9084-008a3df4283f', N'4D850F7E-B3C9-4341-872C-2B6F09BEADDE', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'fe2cc84a-24e0-4866-bf77-009731d113f1', N'F5E1D216-E3C0-4D83-B56D-59302A85827C', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'000D7682-E46D-48C6-B7D8-B6509FABB3C0',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'e8913a89-0083-41a4-8f83-00a310a27c29', N'804FDD71-990D-441E-BF11-B4ADEBE43E4A', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'94599f8b-880c-4955-9d19-00a49cdd7666', N'D0C60F7C-5FF5-465E-9C57-FB8662731E1A', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'cfa52ebd-caf6-4fbc-acdc-00aecdac8a04', N'06F47320-6E13-4C77-B067-E62B4F6B8B69', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'E38B057F-AA4E-4E63-B10A-74AA252AA004',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'08c3e3ab-1dde-41fd-8e53-00b9f91095db', N'035EF61D-60C2-4633-A66F-216C4040BE49', CAST(N'2019-03-02T04:13:00.270' AS DateTime), CAST(N'2019-03-02T04:13:35.630' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'a2d946ef-cda8-4878-aa11-00c43871b11b', N'5DE9E4F6-C7CA-4390-9D68-17DB10155D71', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'31698f13-4dad-4493-ab69-00c9f543beb0', N'F633C431-F38F-402B-BD8D-7F16B495BD76', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'cff4a71e-e2e4-4c60-866e-00d4162ca800', N'8F01FA40-BB99-4BA3-B667-B5B9A321D8E6', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'bcce06bf-9370-4b50-9019-00d9271dfcfc', N'066E793B-FC9A-478A-8F2F-06FB158052D7', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'f650c344-c782-4436-9b6f-00da96b4fac5', N'8E81BA3E-5D0F-43D8-857A-E8055B1F3441', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'ba144541-e08c-4fb2-aca9-00e240983957', N'6E513940-D5E2-4E32-9628-C760DE8D3A81', CAST(N'2019-03-01T04:13:00.270' AS DateTime), CAST(N'2019-03-01T04:13:35.630' AS DateTime), N'E38B057F-AA4E-4E63-B10A-74AA252AA004',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'5d29a0d8-caec-453f-8ccf-00e994cbda4f', N'1182056B-3C1A-412A-A86D-94DFB68EFEAB', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'E38B057F-AA4E-4E63-B10A-74AA252AA004',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'e89c1e84-7eca-42e8-b69e-01186f5c9e59', N'3CDD7559-07B6-46AB-8176-D0F8DDDB3DAF', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'678cdf90-0d8d-4fe1-ab1f-011bcab0320d', N'3CDD7559-07B6-46AB-8176-D0F8DDDB3DAF', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'5daf71bf-c8ad-4ba3-8d61-011d6abc0333', N'9D3099AD-A275-4D3A-A23A-DC65C186C14A', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'af440369-8c93-487e-8199-0121eb2f34f1', N'4ED3FA60-EEF5-406C-88B8-C31019B7AFE4', CAST(N'2019-03-01T04:13:00.270' AS DateTime), CAST(N'2019-03-01T04:13:35.630' AS DateTime), N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'18f48c43-a9ce-4a5b-aeeb-012591127394', N'DB49FEB7-49A0-498C-91B2-B81EC0EC8D8A', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'000D7682-E46D-48C6-B7D8-B6509FABB3C0',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'77f95220-8e57-4829-8ce3-012bb41b424a', N'A69A1636-9EE6-4BC3-8F73-04CF0DC56C3D', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'5cf47ee9-34eb-458b-910c-0133df61f019', N'57546F6B-1004-4CEB-8953-AEAA928F9DA6', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'398eba9e-7349-45d0-9862-014a6eba5dad', N'57546F6B-1004-4CEB-8953-AEAA928F9DA6', CAST(N'2019-03-02T04:13:00.270' AS DateTime), CAST(N'2019-03-02T04:13:35.630' AS DateTime), N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'EBECE9E7-F4C7-4273-8A28-C8F8DA2D2444', N'DCD68DB6-494F-41AD-A932-EE9A673B4287', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'4915BD7C-6D72-42DE-8005-703EC11D10B8', N'E1F9C151-0DCA-4D93-A68B-5974BB7E2ECA', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-03-01T04:13:35.630' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'C4F6E519-EC3C-461A-BB34-04B87B119ACB', N'73684C44-7120-4984-A995-F828FE4C0535', CAST(N'2019-03-01T04:13:00.270' AS DateTime), CAST(N'2019-03-01T04:13:35.630' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'B2598CF5-99E2-47F2-AE80-ECB6E470DC41', N'256E63CA-398F-4CDA-94EA-45C69A7C1FE4', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'DBF85163-BE0A-40F5-A21A-38CA4C32F69A', N'EEB5E917-F828-4EDC-B9FB-F25CF21582AA', CAST(N'2019-03-02T04:13:00.270' AS DateTime), CAST(N'2019-03-02T04:13:35.630' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'3275B2CE-127F-4F12-9D05-72F17146B037', N'2CFFC146-58D0-4222-9591-A8DEEF40297E', CAST(N'2019-02-28T04:13:00.270' AS DateTime), CAST(N'2019-02-28T04:13:35.630' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',1, CAST(N'2019-02-28T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
)

AS Source ([Id], [UserStoryId], [StartDateTime], [EndDateTime], [UserId], [IsStarted], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserStoryId] = Source.[UserStoryId],
		   [StartDateTime] = source.[StartDateTime],
		   [EndDateTime] = source.[EndDateTime],
		   [UserId] = source.[UserId],
		   [IsStarted] = source.[IsStarted],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [UserStoryId], [StartDateTime], [EndDateTime], [UserId], [IsStarted], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [UserStoryId], [StartDateTime], [EndDateTime], [UserId], [IsStarted], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[UserStoryWorkflowStatusTransition] AS Target
USING ( VALUES
		(N'3cd3cca8-10f1-4d0b-aa0d-00008d4f478a', N'd06d0b85-ba72-47d7-ae0e-01ec75e11373', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'02d696fb-7d17-4a0c-b0da-0001326b308d', N'a69a1636-9ee6-4bc3-8f73-04cf0dc56c3d', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'174784c1-3e30-4021-ba94-000260f7049a', N'066e793b-fc9a-478a-8f2f-06fb158052d7', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'a81583a2-56c9-4b32-9899-0005fcfd97d8', N'8e81ba3e-5d0f-43d8-857a-e8055b1f3441', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'b8db4ebb-456a-425d-a5e3-00062993eabe', N'd0c60f7c-5ff5-465e-9c57-fb8662731e1a', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'32c663fe-3c00-4b2c-9334-0006b54b199e', N'e1f9c151-0dca-4d93-a68b-5974bb7e2eca', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'f0789e7d-4957-45c7-8733-00085a9f442c', N'1f6c9053-575d-4d17-b68d-e1979181cc6d', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'f3becb5b-7a86-41bc-9cf7-0008eca91938', N'116e83bc-1f7c-4e48-b558-6cc87299b06e', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'67f1942a-7186-4516-9239-000998176dda', N'9d3099ad-a275-4d3a-a23a-dc65c186c14a', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'906405fc-d5b3-4ae6-a67f-000dceffe7ce', N'2cffc146-58d0-4222-9591-a8deef40297e', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'99439b4d-ae4b-4375-87c3-000f5e452779', N'1a6fe6cc-46d4-47d6-9d67-ac53bb1b6fbc', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'67f0135a-857c-4395-8c0b-0010163c46db', N'f633c431-f38f-402b-bd8d-7f16b495bd76', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'f9c7d3d9-07ad-4126-a10b-00109ffb20ac', N'318063d2-16b0-4c50-af22-ec46ec8130ab', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'7ad368db-1cc1-4e23-8596-0010eb00d091', N'dcd68db6-494f-41ad-a932-ee9a673b4287', N'893f5e80-8983-4431-a651-5a338f5e3b0e', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'1a68a5f8-e1b2-4ad7-8901-0010f948e33a', N'256e63ca-398f-4cda-94ea-45c69a7c1fe4', N'3C252585-C15C-4812-A31C-AF2A1B306074', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'FDC5EEBF-69F6-401B-8392-65A104BE172E', N'd06d0b85-ba72-47d7-ae0e-01ec75e11373', N'3C252585-C15C-4812-A31C-AF2A1B306074', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'EB65A846-40E8-4344-A100-AC7B0ED62D52', N'a69a1636-9ee6-4bc3-8f73-04cf0dc56c3d', N'D552B2AF-FF59-42DB-9AE2-F0B17171C22F', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'D91B764A-9DF8-4C2C-BB58-FA952D1977E2', N'066e793b-fc9a-478a-8f2f-06fb158052d7', N'D552B2AF-FF59-42DB-9AE2-F0B17171C22F', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'4BAD4CBE-B4B7-43A7-8CD9-DA86061F59FE', N'8e81ba3e-5d0f-43d8-857a-e8055b1f3441', N'4033D021-5321-46A7-A518-38EE2FEEA62B', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'2B8417D6-1291-4E04-8A6C-4664DC552EB3', N'd0c60f7c-5ff5-465e-9c57-fb8662731e1a', N'984C73CB-308E-40C9-AEA3-4383DC2515DF', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
		(N'906F5663-2029-4F31-8BB4-D9ABBEE86F3B', N'e1f9c151-0dca-4d93-a68b-5974bb7e2eca', N'3DC093A0-D65C-4ED0-BEF5-41FF72B7D653', CAST(N'2019-03-04T04:55:34.710' AS DateTime), CAST(N'2019-03-04T04:55:34.710' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')	
)

AS Source ([Id], [UserStoryId], [WorkflowEligibleStatusTransitionId], [TransitionDateTime], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserStoryId] = Source.[UserStoryId],
		   [WorkflowEligibleStatusTransitionId] = source.[WorkflowEligibleStatusTransitionId],
		   [TransitionDateTime] = source.[TransitionDateTime],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [UserStoryId], [WorkflowEligibleStatusTransitionId], [TransitionDateTime], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [UserStoryId], [WorkflowEligibleStatusTransitionId], [TransitionDateTime], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[GoalReplan] AS Target
USING ( VALUES
        (N'4d580cf7-e9ad-450f-b13c-001a6c8da013', N'D31EFF15-B9D2-4A85-8F3D-83B2EA475C6A', N'e548cd87-6401-4eeb-8527-6f90f81247fb', NULL, CAST(N'2019-02-28T14:43:32.533' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'c4ccc957-e703-4293-8555-003ecfaa6cdb', N'DBC7DBD6-1C54-4648-BD44-B23BE01FDB96', N'e548cd87-6401-4eeb-8527-6f90f81247fb', NULL, CAST(N'2019-02-28T14:43:32.533' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'beb5272e-e833-4d8b-8224-0043cc349a3b', N'8D064DCA-752E-49E6-B471-D85843B68F03', N'e548cd87-6401-4eeb-8527-6f90f81247fb', NULL, CAST(N'2019-02-28T14:43:32.533' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'45d7bf1d-3d21-4ae3-a675-0089262d37e8', N'EEF8519D-A9FB-42B4-8240-B0A692C2E4DB', N'e548cd87-6401-4eeb-8527-6f90f81247fb', NULL, CAST(N'2019-02-28T14:43:32.533' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'),
		(N'1233be39-b72f-46c1-bf5e-00cdc6fdfb3e', N'C4B73DC1-D186-4F6A-9B43-40E20BE078E1', N'e548cd87-6401-4eeb-8527-6f90f81247fb', NULL, CAST(N'2019-02-28T14:43:32.533' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
)

AS Source ([Id], [GoalId], [GoalReplanTypeId], [Reason], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [GoalId] = Source.[GoalId],
		   [GoalReplanTypeId] = source.[GoalReplanTypeId],
		   [Reason] = source.[Reason],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [GoalId], [GoalReplanTypeId], [Reason], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [GoalId], [GoalReplanTypeId], [Reason], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[TimeSheet] AS TARGET 
USING (VALUES 
	  (N'4829cc3a-0dd3-4f99-9a7c-014ad4239bf5', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:30:00.000' AS DateTime), CAST(N'2019-03-04T08:55:00.000' AS DateTime), CAST(N'2019-03-04T09:58:00.000' AS DateTime), CAST(N'2019-03-04T13:53:00.000' AS DateTime), CAST(N'2019-03-04T12:02:39.107' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'2e996097-334d-439a-a3e4-06055bc76175', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:32:00.000' AS DateTime), CAST(N'2019-03-08T09:50:00.000' AS DateTime), CAST(N'2019-03-08T10:53:00.000' AS DateTime), CAST(N'2019-03-08T12:32:00.000' AS DateTime), CAST(N'2019-03-04T12:44:43.393' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'21f7b83c-80ca-4f0e-ac16-06ebf152205c', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-06' AS Date), CAST(N'2019-03-06T03:43:00.000' AS DateTime), CAST(N'2019-03-06T09:50:00.000' AS DateTime), CAST(N'2019-03-06T10:50:00.000' AS DateTime), CAST(N'2019-03-06T13:45:00.000' AS DateTime), CAST(N'2019-03-04T12:22:47.963' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'9d73fd2f-506d-414c-9662-081971e07851', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-06' AS Date), CAST(N'2019-03-06T03:35:00.000' AS DateTime), CAST(N'2019-03-06T06:45:00.000' AS DateTime), CAST(N'2019-03-06T09:45:00.000' AS DateTime), CAST(N'2019-03-06T13:53:00.000' AS DateTime), CAST(N'2019-03-04T12:21:35.817' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'f871a055-60bb-4813-8419-087b56765b0d', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T03:53:00.000' AS DateTime), CAST(N'2019-03-05T09:53:00.000' AS DateTime), CAST(N'2019-03-05T10:30:00.000' AS DateTime), CAST(N'2019-03-05T13:30:00.000' AS DateTime), CAST(N'2019-03-04T12:19:15.300' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'e26c3a5d-0a50-4996-b3c4-09cc3af026ac', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-06' AS Date), CAST(N'2019-03-06T03:31:00.000' AS DateTime), CAST(N'2019-03-06T08:31:00.000' AS DateTime), CAST(N'2019-03-06T09:31:00.000' AS DateTime), CAST(N'2019-03-06T12:35:00.000' AS DateTime), CAST(N'2019-03-04T12:19:35.793' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'51739426-d656-480b-b9aa-0bca39c2fa73', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:32:00.000' AS DateTime), CAST(N'2019-03-08T07:45:00.000' AS DateTime), CAST(N'2019-03-08T08:53:00.000' AS DateTime), CAST(N'2019-03-08T12:53:00.000' AS DateTime), CAST(N'2019-03-04T12:39:51.987' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'd24ef264-5be4-4d2a-ba76-0c28595533b7', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-01' AS Date), CAST(N'2019-03-01T03:36:00.000' AS DateTime), CAST(N'2019-03-01T08:23:00.000' AS DateTime), CAST(N'2019-03-01T09:23:00.000' AS DateTime), CAST(N'2019-03-01T13:20:00.000' AS DateTime), CAST(N'2019-03-04T11:54:08.660' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'0d1542ec-e93d-4d62-9332-1322c5dd99a6', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T03:33:00.000' AS DateTime), CAST(N'2019-03-05T08:42:00.000' AS DateTime), CAST(N'2019-03-05T09:33:00.000' AS DateTime), CAST(N'2019-03-05T13:45:00.000' AS DateTime), CAST(N'2019-03-04T12:15:07.907' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'1144748d-199b-4dbd-9661-1725c0289c97', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T03:31:00.000' AS DateTime), CAST(N'2019-03-05T09:31:00.000' AS DateTime), CAST(N'2019-03-05T10:32:00.000' AS DateTime), CAST(N'2019-03-05T14:26:00.000' AS DateTime), CAST(N'2019-03-04T12:15:37.217' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'2ffbb393-5350-4cde-b90c-1b1bd76d156f', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:50:00.000' AS DateTime), CAST(N'2019-03-07T07:53:00.000' AS DateTime), CAST(N'2019-03-07T08:53:00.000' AS DateTime), CAST(N'2019-03-07T09:50:00.000' AS DateTime), CAST(N'2019-03-04T12:29:33.560' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'509bd9f8-c6ed-4089-9410-230623c05706', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T03:35:00.000' AS DateTime), CAST(N'2019-03-05T07:00:00.000' AS DateTime), CAST(N'2019-03-05T08:30:00.000' AS DateTime), CAST(N'2019-03-05T12:32:00.000' AS DateTime), CAST(N'2019-03-04T12:13:17.467' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'5c44258b-c8aa-42c5-a391-291d09c963b4', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:32:00.000' AS DateTime), CAST(N'2019-03-04T08:28:00.000' AS DateTime), CAST(N'2019-03-04T08:53:00.000' AS DateTime), CAST(N'2019-03-04T13:26:00.000' AS DateTime), CAST(N'2019-03-04T12:08:30.977' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'd7f4afe1-c566-48eb-be62-3127183dcf2a', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:31:00.000' AS DateTime), CAST(N'2019-03-04T09:31:00.000' AS DateTime), CAST(N'2019-03-04T10:30:00.000' AS DateTime), CAST(N'2019-03-04T13:50:00.000' AS DateTime), CAST(N'2019-03-04T12:11:54.623' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'bb28eaf9-7934-463d-9b8b-406e0f66e023', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:35:00.000' AS DateTime), CAST(N'2019-03-04T07:55:00.000' AS DateTime), CAST(N'2019-03-04T08:32:00.000' AS DateTime), CAST(N'2019-03-04T12:35:00.000' AS DateTime), CAST(N'2019-03-04T12:04:15.270' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'9b457bc0-a040-4f14-8228-46db216e172e', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-06' AS Date), CAST(N'2019-03-06T02:50:00.000' AS DateTime), CAST(N'2019-03-06T08:43:00.000' AS DateTime), CAST(N'2019-03-06T09:55:00.000' AS DateTime), CAST(N'2019-03-06T14:23:00.000' AS DateTime), CAST(N'2019-03-04T12:23:44.770' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'1f3bd063-b36e-462e-a68c-4e3781ff2e30', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-06' AS Date), CAST(N'2019-03-06T03:53:00.000' AS DateTime), CAST(N'2019-03-06T07:50:00.000' AS DateTime), CAST(N'2019-03-06T10:30:00.000' AS DateTime), CAST(N'2019-03-06T13:55:00.000' AS DateTime), CAST(N'2019-03-04T12:21:03.990' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'ff3de312-1f02-4087-b08d-58a8d8a8b8af', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-06' AS Date), CAST(N'2019-03-06T03:35:00.000' AS DateTime), CAST(N'2019-03-06T06:35:00.000' AS DateTime), CAST(N'2019-03-06T08:30:00.000' AS DateTime), CAST(N'2019-03-06T12:53:00.000' AS DateTime), CAST(N'2019-03-04T12:20:02.800' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'7b89b4db-f90c-4162-9ee4-5caf95d19c68', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-01' AS Date), CAST(N'2019-03-01T03:30:00.000' AS DateTime), CAST(N'2019-03-01T07:30:00.000' AS DateTime), CAST(N'2019-03-01T08:30:00.000' AS DateTime), CAST(N'2019-03-01T12:30:00.000' AS DateTime), CAST(N'2019-03-04T11:56:45.947' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'75e7d77b-8ae2-4bfa-a086-5cb89d3a2018', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:23:00.000' AS DateTime), CAST(N'2019-03-04T06:33:00.000' AS DateTime), CAST(N'2019-03-04T08:33:00.000' AS DateTime), CAST(N'2019-03-04T12:31:00.000' AS DateTime), CAST(N'2019-03-04T12:03:20.720' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'204a7b1d-7349-46fc-a9a0-639101e556d3', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:45:00.000' AS DateTime), CAST(N'2019-03-08T07:45:00.000' AS DateTime), CAST(N'2019-03-08T08:53:00.000' AS DateTime), CAST(N'2019-03-08T13:35:00.000' AS DateTime), CAST(N'2019-03-04T12:40:42.973' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'e3dcdb37-bda3-4fdc-947f-67524cda1d83', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-01' AS Date), CAST(N'2019-03-01T03:30:00.000' AS DateTime), CAST(N'2019-03-01T09:30:00.000' AS DateTime), CAST(N'2019-03-01T10:40:00.000' AS DateTime), CAST(N'2019-03-01T14:00:00.000' AS DateTime), CAST(N'2019-03-04T12:01:28.267' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'3b6869eb-d6d4-414b-95aa-7d581c13ed41', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-01' AS Date), CAST(N'2019-03-01T03:50:00.000' AS DateTime), CAST(N'2019-03-01T07:00:00.000' AS DateTime), CAST(N'2019-03-01T08:30:00.000' AS DateTime), CAST(N'2019-03-01T13:00:00.000' AS DateTime), CAST(N'2019-03-04T12:01:00.977' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'c9fb60f8-fdf0-4789-b85c-7f6127c7d9bb', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:45:00.000' AS DateTime), CAST(N'2019-03-07T07:53:00.000' AS DateTime), CAST(N'2019-03-07T08:55:00.000' AS DateTime), CAST(N'2019-03-07T12:45:00.000' AS DateTime), CAST(N'2019-03-04T12:33:36.820' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'2960ddc8-9e2d-4c7a-8b67-809c0439f4bc', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T03:32:00.000' AS DateTime), CAST(N'2019-03-05T09:32:00.000' AS DateTime), CAST(N'2019-03-05T10:32:00.000' AS DateTime), CAST(N'2019-03-05T11:45:00.000' AS DateTime), CAST(N'2019-03-04T12:13:40.983' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'd98f7a58-07e7-4640-9fce-81f140d913d2', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:55:00.000' AS DateTime), CAST(N'2019-03-07T07:50:00.000' AS DateTime), CAST(N'2019-03-07T09:08:00.000' AS DateTime), CAST(N'2019-03-07T12:50:00.000' AS DateTime), CAST(N'2019-03-04T12:38:31.063' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'43cf768a-ce3f-4fba-abfa-823c3efd317a', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:32:00.000' AS DateTime), CAST(N'2019-03-07T08:50:00.000' AS DateTime), CAST(N'2019-03-07T09:53:00.000' AS DateTime), CAST(N'2019-03-07T12:50:00.000' AS DateTime), CAST(N'2019-03-04T12:34:45.590' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'0b747fe1-2066-4c6c-91e1-8a40ea85f193', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:31:00.000' AS DateTime), CAST(N'2019-03-04T06:41:00.000' AS DateTime), CAST(N'2019-03-04T07:41:00.000' AS DateTime), CAST(N'2019-03-04T12:50:00.000' AS DateTime), CAST(N'2019-03-04T12:11:24.587' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'27bbb74c-02e4-41c4-9925-8b115a506f37', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:40:00.000' AS DateTime), CAST(N'2019-03-08T07:55:00.000' AS DateTime), CAST(N'2019-03-08T08:50:00.000' AS DateTime), CAST(N'2019-03-08T12:53:00.000' AS DateTime), CAST(N'2019-03-04T12:45:29.357' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'7fddb3bc-b9fb-4d29-8257-8ed44c200098', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:33:00.000' AS DateTime), CAST(N'2019-03-08T07:53:00.000' AS DateTime), CAST(N'2019-03-08T08:45:00.000' AS DateTime), CAST(N'2019-03-08T12:39:00.000' AS DateTime), CAST(N'2019-03-04T12:47:41.837' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'f4a7fcc0-419f-462b-99ce-9e2ce007a0d9', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T03:50:00.000' AS DateTime), CAST(N'2019-03-05T08:50:00.000' AS DateTime), CAST(N'2019-03-05T09:50:00.000' AS DateTime), CAST(N'2019-03-05T13:45:00.000' AS DateTime), CAST(N'2019-03-04T12:16:29.270' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'4beab088-f861-4b6c-9129-9faf42bf745c', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', CAST(N'2019-03-01' AS Date), CAST(N'2019-03-01T03:40:00.000' AS DateTime), CAST(N'2019-03-01T07:00:00.000' AS DateTime), CAST(N'2019-03-01T08:30:00.000' AS DateTime), CAST(N'2019-03-01T13:20:00.000' AS DateTime), CAST(N'2019-03-04T11:57:23.150' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'9a88f54f-1c03-49a0-91ef-a298394c0d1e', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:32:00.000' AS DateTime), CAST(N'2019-03-07T08:32:00.000' AS DateTime), CAST(N'2019-03-07T09:33:00.000' AS DateTime), CAST(N'2019-03-07T12:59:00.000' AS DateTime), CAST(N'2019-03-04T12:29:04.553' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'66422163-5671-4634-acaf-a496533251f5', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-06' AS Date), CAST(N'2019-03-06T03:50:00.000' AS DateTime), CAST(N'2019-03-06T06:55:00.000' AS DateTime), CAST(N'2019-03-06T08:20:00.000' AS DateTime), CAST(N'2019-03-06T13:50:00.000' AS DateTime), CAST(N'2019-03-04T12:20:44.343' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'cce6c447-d7d3-4819-af19-a99e5dde5a53', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:45:00.000' AS DateTime), CAST(N'2019-03-07T07:34:00.000' AS DateTime), CAST(N'2019-03-07T08:50:00.000' AS DateTime), CAST(N'2019-03-07T12:56:00.000' AS DateTime), CAST(N'2019-03-04T12:26:10.107' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'3e229c53-fd4f-4837-b272-adedbeaf1521', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T03:54:00.000' AS DateTime), CAST(N'2019-03-05T09:53:00.000' AS DateTime), CAST(N'2019-03-05T10:46:00.000' AS DateTime), CAST(N'2019-03-05T15:49:00.000' AS DateTime), CAST(N'2019-03-04T12:16:02.770' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'5aed3e88-a439-46b7-84cb-bfdb351ee7fd', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:35:00.000' AS DateTime), CAST(N'2019-03-07T06:45:00.000' AS DateTime), CAST(N'2019-03-07T08:23:00.000' AS DateTime), CAST(N'2019-03-07T12:55:00.000' AS DateTime), CAST(N'2019-03-04T12:24:15.153' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'bb6e5cec-747e-4683-b810-c8983270f7ca', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:45:00.000' AS DateTime), CAST(N'2019-03-08T07:53:00.000' AS DateTime), CAST(N'2019-03-08T09:23:00.000' AS DateTime), CAST(N'2019-03-08T12:53:00.000' AS DateTime), CAST(N'2019-03-04T12:44:17.480' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'ed4a619d-05cc-43ab-8801-c98035c247f6', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:52:00.000' AS DateTime), CAST(N'2019-03-07T08:20:00.000' AS DateTime), CAST(N'2019-03-07T09:00:00.000' AS DateTime), CAST(N'2019-03-07T12:50:00.000' AS DateTime), CAST(N'2019-03-04T12:26:40.020' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'5f6ce76f-0dce-46f9-8697-cb41352febb0', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-01' AS Date), CAST(N'2019-03-01T03:50:00.000' AS DateTime), CAST(N'2019-03-01T06:00:00.000' AS DateTime), CAST(N'2019-02-28T19:30:00.000' AS DateTime), CAST(N'2019-03-01T12:30:00.000' AS DateTime), CAST(N'2019-03-04T11:55:18.903' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'6321aca5-b5f5-4f98-bcb9-ce951e4d6cd3', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:35:00.000' AS DateTime), CAST(N'2019-03-08T07:35:00.000' AS DateTime), CAST(N'2019-03-08T08:32:00.000' AS DateTime), CAST(N'2019-03-08T12:35:00.000' AS DateTime), CAST(N'2019-03-04T12:41:07.817' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'60754565-1d9b-424d-92d8-d3ce9cc915d4', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:53:00.000' AS DateTime), CAST(N'2019-03-07T09:50:00.000' AS DateTime), CAST(N'2019-03-07T08:53:00.000' AS DateTime), CAST(N'2019-03-07T12:56:00.000' AS DateTime), CAST(N'2019-03-04T12:27:35.433' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'07defd48-a71d-4571-a382-d696d8112f51', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:50:00.000' AS DateTime), CAST(N'2019-03-08T08:50:00.000' AS DateTime), CAST(N'2019-03-08T09:53:00.000' AS DateTime), CAST(N'2019-03-08T12:56:00.000' AS DateTime), CAST(N'2019-03-04T12:39:24.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'86655f63-47ab-4778-bd6e-d89f95c33bfb', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-07' AS Date), CAST(N'2019-03-07T03:43:00.000' AS DateTime), CAST(N'2019-03-07T06:53:00.000' AS DateTime), CAST(N'2019-03-07T08:20:00.000' AS DateTime), CAST(N'2019-03-07T12:55:00.000' AS DateTime), CAST(N'2019-03-04T12:35:17.197' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'f01265e7-effa-4ea0-adaa-dda047bc410b', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T03:32:00.000' AS DateTime), CAST(N'2019-03-05T07:31:00.000' AS DateTime), CAST(N'2019-03-05T08:32:00.000' AS DateTime), CAST(N'2019-03-05T12:32:00.000' AS DateTime), CAST(N'2019-03-04T12:12:36.980' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'f143809c-4475-4d64-9b96-df64841e48e8', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T02:55:00.000' AS DateTime), CAST(N'2019-03-05T06:55:00.000' AS DateTime), CAST(N'2019-03-05T08:00:00.000' AS DateTime), CAST(N'2019-03-05T13:50:00.000' AS DateTime), CAST(N'2019-03-04T12:16:56.860' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'60ec6620-ed08-4cb3-bb17-e4bd2a14e36a', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-05' AS Date), CAST(N'2019-03-05T03:35:00.000' AS DateTime), CAST(N'2019-03-05T07:32:00.000' AS DateTime), CAST(N'2019-03-05T08:32:00.000' AS DateTime), CAST(N'2019-03-05T13:53:00.000' AS DateTime), CAST(N'2019-03-04T12:14:13.657' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'98817534-f7bc-48ee-bcfe-e708c0ca31cb', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:31:00.000' AS DateTime), CAST(N'2019-03-08T08:53:00.000' AS DateTime), CAST(N'2019-03-08T09:50:00.000' AS DateTime), CAST(N'2019-03-08T12:45:00.000' AS DateTime), CAST(N'2019-03-04T12:45:52.363' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'cc217b1f-2f72-4bce-a082-e8454161f39d', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-08' AS Date), CAST(N'2019-03-08T03:33:00.000' AS DateTime), CAST(N'2019-03-08T07:35:00.000' AS DateTime), CAST(N'2019-03-08T08:35:00.000' AS DateTime), CAST(N'2019-03-08T12:50:00.000' AS DateTime), CAST(N'2019-03-04T12:46:24.587' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'11ba5e81-401b-4795-a7ac-ebdb7195965b', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-01' AS Date), CAST(N'2019-03-01T03:30:00.000' AS DateTime), CAST(N'2019-03-01T06:30:00.000' AS DateTime), CAST(N'2019-03-01T07:30:00.000' AS DateTime), CAST(N'2019-03-01T12:30:00.000' AS DateTime), CAST(N'2019-03-04T11:57:54.477' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'7b66d22d-faaa-4d36-9365-ec56b3ec8f5e', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-01' AS Date), CAST(N'2019-03-01T03:30:00.000' AS DateTime), CAST(N'2019-03-01T08:24:00.000' AS DateTime), CAST(N'2019-03-01T09:45:00.000' AS DateTime), CAST(N'2019-03-01T12:50:00.000' AS DateTime), CAST(N'2019-03-04T11:54:49.300' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'efa3dc70-d13a-464e-ab21-efaee3842493', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:43:00.000' AS DateTime), CAST(N'2019-03-04T07:45:00.000' AS DateTime), CAST(N'2019-03-04T08:50:00.000' AS DateTime), CAST(N'2019-03-04T13:20:00.000' AS DateTime), CAST(N'2019-03-04T12:07:00.023' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'fd9d1c80-0e2f-49b3-951e-f133bd3ae2ad', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:42:00.000' AS DateTime), CAST(N'2019-03-04T07:45:00.000' AS DateTime), CAST(N'2019-03-04T08:45:00.000' AS DateTime), CAST(N'2019-03-04T13:22:00.000' AS DateTime), CAST(N'2019-03-04T12:06:16.297' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'e9ee22f4-dd06-4d4f-ba48-fbd106fa6ee9', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:50:00.000' AS DateTime), CAST(N'2019-03-04T08:28:00.000' AS DateTime), CAST(N'2019-03-04T09:28:00.000' AS DateTime), CAST(N'2019-03-04T14:50:00.000' AS DateTime), CAST(N'2019-03-04T12:10:56.507' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL),
	  (N'15d10315-a0bb-4b14-b55a-fcb96ecca14a', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-04' AS Date), CAST(N'2019-03-04T03:45:00.000' AS DateTime), CAST(N'2019-03-04T07:31:00.000' AS DateTime), CAST(N'2019-03-04T08:36:00.000' AS DateTime), CAST(N'2019-03-04T13:22:00.000' AS DateTime), CAST(N'2019-03-04T12:03:47.910' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 1, NULL, NULL)
	) 
AS SOURCE ([Id], [UserId], [Date], [InTime], [LunchBreakStartTime], [LunchBreakEndTime], [OutTime], [CreatedDateTime], [CreatedByUserId], [IsFeed], [ButtonTypeId], [Time]) 
ON TARGET.Id = SOURCE.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = SOURCE.[Id],
	       [UserId] = SOURCE.[UserId],
		   [Date] = SOURCE.[Date],
		   [InTime] = SOURCE.[InTime],
		   [LunchBreakStartTime] = SOURCE.[LunchBreakStartTime],
		   [LunchBreakEndTime] = SOURCE.[LunchBreakEndTime],
		   [OutTime] = SOURCE.[OutTime],
		   [CreatedDateTime] = SOURCE.[CreatedDateTime],
		   [CreatedByUserId] = SOURCE.[CreatedByUserId],
		   [IsFeed] = SOURCE.[IsFeed],
		   [ButtonTypeId] = SOURCE.[ButtonTypeId],
		   [Time] = SOURCE.[Time]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [UserId], [Date], [InTime], [LunchBreakStartTime], [LunchBreakEndTime], [OutTime], [CreatedDateTime], [CreatedByUserId], [IsFeed], [ButtonTypeId], [Time]) VALUES ([Id], [UserId], [Date], [InTime], [LunchBreakStartTime], [LunchBreakEndTime], [OutTime], [CreatedDateTime], [CreatedByUserId], [IsFeed], [ButtonTypeId], [Time]); 

MERGE INTO [dbo].[Supplier] AS Target
USING ( VALUES    
		 (N'a590466f-da6f-464a-8f1b-22689c58ae39', @CompanyId, N'Best Enterprises', N'HP', N'JB', N'Sales', N'1230456789', N'1234578960', N'James', CAST(N'2019-03-07T00:00:00.000' AS DateTime), CAST(N'2019-03-08T10:08:34.260' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL)
		,(N'13a22eca-baf5-45d2-999c-40d6b28ea2a0', @CompanyId, N'E Technologies', N'Dell', N'Suresh', N'Sales', N'1234567890', N'1234567890', N'Ramesh', CAST(N'2019-03-07T00:00:00.000' AS DateTime), CAST(N'2019-03-08T09:59:27.693' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL)
		,(N'808fc254-ae9b-45f9-8c61-87fcd7dddf78', @CompanyId, N'Technozin', N'Lenovo', N'Michel', N'Sales', N'1234567890', N'0231456789', N'Smith', CAST(N'2019-03-07T00:00:00.000' AS DateTime), CAST(N'2019-03-08T10:03:43.413' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL)
		,(N'3ebfef91-2d32-457f-a6ae-9e57d1c82404', @CompanyId, N'Best Furnitures', N'Usha', N'David', N'Sales', N'1230456789', N'1459886932', N'Madhavan', CAST(N'2019-03-11T00:00:00.000' AS DateTime), CAST(N'2019-03-08T10:21:36.230' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL)
		,(N'51994092-3f81-4be3-bf06-b59518f219f8', @CompanyId, N'Apple Technosoft', N'Apple', N'Chan', N'Manager', N'1230456789', N'1230456789', N'Jivan', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-03-08T10:12:24.120' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL)
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
     (N'e85aab54-a326-4bd7-b8f4-43bea6e952b1', @CompanyId, N'Apple', CAST(N'2019-03-08T10:10:53.260' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'16ef64d7-da56-44f0-bd35-4edc52510ead', @CompanyId, N'Lenovo', CAST(N'2019-03-08T10:02:13.233' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'5387f753-38b6-46f8-a9b7-c21a36fad6bd', @CompanyId, N'HP', CAST(N'2019-03-08T10:06:32.560' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'dfbfcab0-43a6-4103-b78e-c983d8e0c67e', @CompanyId, N'Dell', CAST(N'2019-03-08T10:00:05.547' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'72402049-b698-402c-adfa-dbc99475c9e9', @CompanyId, N'Usha', CAST(N'2019-03-08T10:20:02.807' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')

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
USING ( VALUES
     (N'3e225e79-67ec-4b3d-ae19-2a9ea1dec83f', N'5387f753-38b6-46f8-a9b7-c21a36fad6bd', N'456', N'a590466f-da6f-464a-8f1b-22689c58ae39', N'789', CAST(N'2019-03-08T10:08:53.450' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'7d437998-0c4c-435f-a9e1-d8f04b32f865', N'72402049-b698-402c-adfa-dbc99475c9e9', N'78652', N'a590466f-da6f-464a-8f1b-22689c58ae39', N'5552', CAST(N'2019-03-08T10:21:42.747' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'4064967e-9b52-41f0-aea2-e281dcea6911', N'e85aab54-a326-4bd7-b8f4-43bea6e952b1', N'523', N'51994092-3f81-4be3-bf06-b59518f219f8', N'489', CAST(N'2019-03-08T10:12:30.633' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')

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
    (N'b7dd007a-5925-4032-8d05-0b6e2fe12e28', N'Ch 345', CAST(N'2019-03-03T00:00:00.000' AS DateTime), N'72402049-b698-402c-adfa-dbc99475c9e9', N'Chair', CAST(700 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 1, 0, CAST(N'2019-03-08T10:22:10.200' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'232c7520-e2ba-4133-aa7e-0c45ba6b367a', N'1', CAST(N'2019-03-07T00:00:00.000' AS DateTime), N'dfbfcab0-43a6-4103-b78e-c983d8e0c67e', N'Mouse', CAST(100 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 1, 1, CAST(N'2019-03-08T10:01:21.717' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'0c1be35e-a0a3-4224-a7e8-13a50d15f47b', N'5', CAST(N'2019-03-05T00:00:00.000' AS DateTime), N'dfbfcab0-43a6-4103-b78e-c983d8e0c67e', N'CPU', CAST(500 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T10:15:34.107' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'3fa2254b-a680-4eb3-8cbf-1f8bf4ac1136', N'3', CAST(N'2019-03-07T00:00:00.000' AS DateTime), N'5387f753-38b6-46f8-a9b7-c21a36fad6bd', N'Monitor', CAST(500 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T10:09:17.573' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'f5a66f40-d585-4253-afca-202576b7bc32', N'20', CAST(N'2019-02-06T00:00:00.000' AS DateTime), N'16ef64d7-da56-44f0-bd35-4edc52510ead', N'KeyBoard', CAST(100 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T11:17:16.913' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'59b766b9-0b50-4c3d-a860-2378a1d1ac2e', N'10', CAST(N'2019-02-07T00:00:00.000' AS DateTime), N'e85aab54-a326-4bd7-b8f4-43bea6e952b1', N'MacBook', CAST(8000 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T10:43:23.450' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'35841473-4db3-43e2-a1e1-329f6112836e', N'Mp 1234', CAST(N'2019-03-05T00:00:00.000' AS DateTime), N'dfbfcab0-43a6-4103-b78e-c983d8e0c67e', N'MousePad', CAST(800 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 1, 0, CAST(N'2019-03-08T10:18:09.810' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'c19faa0c-0cdb-4f21-abb7-39125495a118', N'11', CAST(N'2019-02-06T00:00:00.000' AS DateTime), N'e85aab54-a326-4bd7-b8f4-43bea6e952b1', N'MacBook', CAST(8000 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T10:44:27.000' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'e627536f-df51-42ff-bec2-3ba5d9038b5d', N'13', CAST(N'2019-02-06T00:00:00.000' AS DateTime), N'16ef64d7-da56-44f0-bd35-4edc52510ead', N'KeyBoard', CAST(1000 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T11:00:44.123' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'3cdf95be-016a-4f71-a3f5-41da3e41ed0a', N'4', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'e85aab54-a326-4bd7-b8f4-43bea6e952b1', N'MacBook', CAST(8000 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T10:13:01.407' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'63053486-89D4-47B6-AB2A-934A9F238812'),
	(N'809f97a6-806d-4338-bfeb-51385da55f73', N'2', CAST(N'2019-03-07T00:00:00.000' AS DateTime), N'16ef64d7-da56-44f0-bd35-4edc52510ead', N'KeyBoard', CAST(200 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 1, CAST(N'2019-03-08T10:04:45.007' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707'),
	(N'67aea764-40ee-4d99-9e53-67d651c3df83', N'21', CAST(N'2019-02-06T00:00:00.000' AS DateTime), N'16ef64d7-da56-44f0-bd35-4edc52510ead', N'KeyBoard', CAST(800 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T11:21:46.127' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707'),
	(N'8b4d70b7-b02e-4086-a99d-6821af6deb50', N'27', CAST(N'2019-02-03T00:00:00.000' AS DateTime), N'e85aab54-a326-4bd7-b8f4-43bea6e952b1', N'MacBook', CAST(8000 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T11:32:40.877' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707'),
	(N'724b4964-e4b9-4a11-bd31-6c8c9ad9eafe', N'7', CAST(N'2019-03-01T00:00:00.000' AS DateTime), N'dfbfcab0-43a6-4103-b78e-c983d8e0c67e', N'Monitor', CAST(700 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 1, CAST(N'2019-03-08T10:41:44.800' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707'),
	(N'4d8cb41c-9c85-4d4c-a4c3-7f4c0e2fa463', N'17', CAST(N'2019-02-06T00:00:00.000' AS DateTime), N'16ef64d7-da56-44f0-bd35-4edc52510ead', N'KeyBoard', CAST(100 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T11:03:31.247' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707'),
	(N'f12ef635-92f5-4d5a-9b76-975cd69345b6', N'13', CAST(N'2019-02-06T00:00:00.000' AS DateTime), N'72402049-b698-402c-adfa-dbc99475c9e9', N'MousePad', CAST(100 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T10:48:59.840' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707'),
	(N'c72f7702-6e98-42b0-9b37-c46753b04d7a', N'24', CAST(N'2019-02-06T00:00:00.000' AS DateTime), N'16ef64d7-da56-44f0-bd35-4edc52510ead', N'KeyBoard', CAST(100 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T11:27:53.933' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707'),
	(N'b6511476-8db3-4892-8f4f-c468ced0e1d4', N'28', CAST(N'2019-02-03T00:00:00.000' AS DateTime), N'e85aab54-a326-4bd7-b8f4-43bea6e952b1', N'MacBook', CAST(8000 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T11:36:45.727' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707'),
	(N'dc5db4e5-124e-40aa-8198-f5f246f4dedd', N'8', CAST(N'2019-02-01T00:00:00.000' AS DateTime), N'dfbfcab0-43a6-4103-b78e-c983d8e0c67e', N'Monitor', CAST(700 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T10:42:45.657' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707'),
	(N'8cb8321f-7474-4465-88b1-ff1c99e5388c', N'12', CAST(N'2019-02-06T00:00:00.000' AS DateTime), N'e85aab54-a326-4bd7-b8f4-43bea6e952b1', N'MacBook', CAST(8000 AS Decimal(18, 0)), N'e1df9c69-5724-4244-8691-7691d3b0f16f', 0, NULL, NULL, 0, 0, CAST(N'2019-03-08T10:45:18.910' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',N'1210DB37-93F7-4347-9240-E978A270B707')
)

AS Source ([Id], [AssetNumber], [PurchasedDate], [ProductId], [AssetName], [Cost], [CurrencyId], [IsWriteOff], [DamagedDate], [DamagedReason], [IsEmpty], [IsVendor], [CreatedDateTime], [CreatedByUserId],[BranchId])
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
		   [IsEmpty] = source.[IsEmpty],
		   [IsVendor] = source.[IsVendor],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [BranchId] = Source.[Branchid]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [AssetNumber], [PurchasedDate], [ProductId], [AssetName], [Cost], [CurrencyId], [IsWriteOff], [DamagedDate], [DamagedReason], [IsEmpty], [IsVendor], [CreatedDateTime], [CreatedByUserId], [BranchId]) VALUES ([Id], [AssetNumber], [PurchasedDate], [ProductId], [AssetName], [Cost], [CurrencyId], [IsWriteOff], [DamagedDate], [DamagedReason], [IsEmpty], [IsVendor], [CreatedDateTime], [CreatedByUserId],[BranchId]);

MERGE INTO [dbo].[AssetAssignedToEmployee] AS Target
USING ( VALUES
     (N'62241afc-31bb-4bf8-94ad-0a4aed661186', N'f5a66f40-d585-4253-afca-202576b7bc32', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-08T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T11:17:16.917' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'26535dfb-b508-4254-bdd0-0eda240d4648', N'0c1be35e-a0a3-4224-a7e8-13a50d15f47b', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-06T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:15:34.110' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'b92cd3b5-0499-4b98-b96f-132f0beed775', N'c19faa0c-0cdb-4f21-abb7-39125495a118', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-07T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:44:27.003' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'46e7cb79-ff95-4465-b9a3-1350feb12e68', N'4d8cb41c-9c85-4d4c-a4c3-7f4c0e2fa463', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-08T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T11:03:31.253' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'37f8e4f8-91e5-48cf-9ad0-1b67bd281d99', N'67aea764-40ee-4d99-9e53-67d651c3df83', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-08T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T11:21:46.130' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'c578e45c-1160-4821-a558-33889cbcd143', N'b7dd007a-5925-4032-8d05-0b6e2fe12e28', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', CAST(N'2019-03-07T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:22:10.203' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'90591434-88d9-4147-8647-38a9532a86b6', N'f12ef635-92f5-4d5a-9b76-975cd69345b6', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-07T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:48:59.847' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'ee62ebda-df9b-4cf8-b43b-38ec10095968', N'8b4d70b7-b02e-4086-a99d-6821af6deb50', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-06T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T11:32:40.880' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'ee46e9b7-2db9-4128-b6a7-422f3c4bff31', N'dc5db4e5-124e-40aa-8198-f5f246f4dedd', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:42:45.660' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'6536be51-5f6f-49f6-b118-4c66cbd822ea', N'c72f7702-6e98-42b0-9b37-c46753b04d7a', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-08T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T11:27:53.937' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'76b1b606-e236-412a-bdca-5ee6fe578962', N'e627536f-df51-42ff-bec2-3ba5d9038b5d', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-08T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T11:00:44.130' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'af59e6b7-4a6b-4d3b-8b40-654526d34a4a', N'59b766b9-0b50-4c3d-a860-2378a1d1ac2e', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-08T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:43:23.453' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'8d7801aa-cfc9-4922-81d2-80ea2f648341', N'35841473-4db3-43e2-a1e1-329f6112836e', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-08T10:18:09.817' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:18:09.817' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'1112a5aa-981e-40cc-8e71-8d5c69da3369', N'724b4964-e4b9-4a11-bd31-6c8c9ad9eafe', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-04T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:41:44.807' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'4ad1fd13-c73a-457c-91d5-99ed5cd8fa72', N'232c7520-e2ba-4133-aa7e-0c45ba6b367a', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-08T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:01:21.737' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'f23b71e4-182f-43f7-bd5e-a2ce371914e9', N'b6511476-8db3-4892-8f4f-c468ced0e1d4', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-07T00:00:00.000' AS DateTime), NULL, N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-08T11:36:45.733' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'1266d417-e6ec-4f22-ac86-ab25bc540ec0', N'809f97a6-806d-4338-bfeb-51385da55f73', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-08T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:04:45.013' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'73d045b4-bfde-49e6-87ef-d6018a90abd7', N'3fa2254b-a680-4eb3-8cbf-1f8bf4ac1136', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-08T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:09:17.610' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'e4769fe9-87cc-4723-8bf3-d7d48904a175', N'3cdf95be-016a-4f71-a3f5-41da3e41ed0a', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-06T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:13:01.410' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f'),
	 (N'51d6e174-9a75-411d-b960-fc5601ad032e', N'8cb8321f-7474-4465-88b1-ff1c99e5388c', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-07T00:00:00.000' AS DateTime), NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-08T10:45:18.913' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')

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

MERGE INTO [dbo].[VendorDetails] AS Target
USING ( VALUES
     (N'10bedef2-4e3e-4caa-8585-65ddb907f1ab', N'724b4964-e4b9-4a11-bd31-6c8c9ad9eafe', N'dfbfcab0-43a6-4103-b78e-c983d8e0c67e', CAST(700.00 AS Decimal(18, 2))),
	 (N'431ab4a3-8cff-4ac9-af48-c1b607b3713a', N'232c7520-e2ba-4133-aa7e-0c45ba6b367a', N'dfbfcab0-43a6-4103-b78e-c983d8e0c67e', CAST(100.00 AS Decimal(18, 2))),
	 (N'1d1bfa3f-fa98-4def-9c0a-fd490a6ecb43', N'809f97a6-806d-4338-bfeb-51385da55f73', N'16ef64d7-da56-44f0-bd35-4edc52510ead', CAST(200.00 AS Decimal(18, 2)))
)

AS Source ([Id], [AssetId], [ProductId], [Cost])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [AssetId] = Source.[AssetId],
		   [ProductId] = source.[ProductId],
		   [Cost] = source.[Cost]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [AssetId], [ProductId], [Cost]) VALUES ([Id], [AssetId], [ProductId], [Cost]);

MERGE INTO [dbo].[FormType] AS Target
USING ( VALUES
       (N'd3238916-4958-4c61-9f53-1c67f9b793aa', N'Code review check', @CompanyId, CAST(N'2019-02-28T10:30:46.073' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	  ,(N'76ac2396-89e5-4b69-a82c-338f76f281bf', N'Meeting notes', @CompanyId, CAST(N'2019-02-28T10:30:46.073' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	  ,(N'28ef4f03-ea47-4756-a672-ce35f3ce2964', N'Status', @CompanyId, CAST(N'2019-02-28T10:30:46.073' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')

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
       (N'4588a593-20d3-4af9-8851-3513be8cd2df', N'd3238916-4958-4c61-9f53-1c67f9b793aa', N'Code Review', N'{"components":[{"label":"Code Review Description","showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"textField","defaultValue":"","conditional":{"show":false,"when":"","json":""},"$$hashKey":"object:249","spellcheck":true,"validate":{"customMessage":"","json":""},"widget":{"type":""},"reorder":false,"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[]},{"label":"Description","isUploadEnabled":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textarea","input":true,"key":"description","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"wysiwyg":"","uploadUrl":"","uploadOptions":"","uploadDir":"","reorder":false,"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[]},{"label":"Is Checked","labelPosition":"top","shortcut":"","mask":false,"tableView":true,"alwaysEnabled":false,"type":"checkbox","input":true,"key":"isChecked","defaultValue":false,"validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"reorder":false,"encrypted":false,"properties":{},"customConditional":"","logic":[]}]}', CAST(N'2019-03-12T12:35:23.083' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	  ,(N'b3b25c62-2d46-4661-9070-b877087b3102', N'76ac2396-89e5-4b69-a82c-338f76f281bf', N'Meeting', N'{"components":[{"label":"Description","showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"textField","defaultValue":"","conditional":{"show":false,"when":"","json":""},"$$hashKey":"object:249","spellcheck":true,"validate":{"customMessage":"","json":""},"widget":{"type":""},"reorder":false,"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[]},{"label":"Meeting Notes","isUploadEnabled":false,"showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textarea","input":true,"key":"textArea2","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":"","when":"","json":""},"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[],"wysiwyg":"","uploadUrl":"","uploadOptions":"","uploadDir":"","reorder":false}]}', CAST(N'2019-03-12T12:02:07.397' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	  ,(N'da751316-da6b-4b06-be59-f6322cb4ffc7', N'28ef4f03-ea47-4756-a672-ce35f3ce2964', N'Status', N'{"components":[{"label":"Description","showWordCount":false,"showCharCount":false,"tableView":true,"alwaysEnabled":false,"type":"textfield","input":true,"key":"textField","defaultValue":"","validate":{"customMessage":"","json":""},"conditional":{"show":false,"when":"","json":""},"$$hashKey":"object:249","spellcheck":true,"widget":{"type":""},"reorder":false,"inputFormat":"plain","encrypted":false,"properties":{},"customConditional":"","logic":[]}]}', CAST(N'2019-03-12T12:58:58.167' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')

)

AS Source ([Id], [FormTypeId], [FormName], [FormJson], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [FormTypeId] = Source.[FormTypeId],
		   [FormName] = source.[FormName],
		   [FormJson] = source.[FormJson],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [FormTypeId], [FormName], [FormJson], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [FormTypeId], [FormName], [FormJson], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[StatusReportingConfiguration_New] AS Target
USING ( VALUES
       (N'6b12b5b3-9ad3-4100-bdad-3ae5d0b912a9', N'Meeting', N'b3b25c62-2d46-4661-9070-b877087b3102', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-12T12:26:25.050' AS DateTime), CAST(N'2019-03-12T12:26:25.050' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	  ,(N'98047320-3d15-411e-aa25-953b2f3d08bf', N'Status', N'da751316-da6b-4b06-be59-f6322cb4ffc7', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-12T14:28:37.863' AS DateTime),  CAST(N'2019-03-12T14:28:37.863' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	  ,(N'8a7c0fb3-eb42-482d-b26c-d7bde5a67a75', N'Code Review Check', N'4588a593-20d3-4af9-8851-3513be8cd2df', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-12T12:57:43.843' AS DateTime), CAST(N'2019-03-12T12:57:43.843' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
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

MERGE INTO [dbo].[StatusReportingConfigurationOption] AS Target
USING ( VALUES
      (N'a36252ad-2532-47cc-abce-0af57a2d6930', N'6b12b5b3-9ad3-4100-bdad-3ae5d0b912a9', N'a69f6e29-1ec1-4686-a158-4c66bc903d76', CAST(N'2019-03-12T12:26:25.050' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	 ,(N'6604bda6-fa5d-4b3e-b9db-75cb60b5c916', N'8a7c0fb3-eb42-482d-b26c-d7bde5a67a75', N'dfe38c65-cd5e-48c1-91d1-68a902be2a30', CAST(N'2019-03-12T12:57:43.843' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	 ,(N'b2bddcf1-0339-42e6-bdc4-a990e73a4730', N'98047320-3d15-411e-aa25-953b2f3d08bf', N'b8e4a61b-cc0c-4317-95b3-a743dd53e136', CAST(N'2019-03-12T14:28:37.863' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	 ,(N'9c61b744-3f56-4571-9312-db83d6c53c68', N'6b12b5b3-9ad3-4100-bdad-3ae5d0b912a9', N'fd9d6c9f-fc56-4222-8479-494a46fd718b', CAST(N'2019-03-12T12:26:25.050' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	 ,(N'73eba71e-6c8a-4f66-87b4-e3c6b647b834', N'8a7c0fb3-eb42-482d-b26c-d7bde5a67a75', N'a9bf44b3-67e9-4c1b-af3e-2907c53444d3', CAST(N'2019-03-12T12:57:43.843' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
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
      (N'6e43f320-399b-44e3-a99e-3a99b2b52292', N'98047320-3d15-411e-aa25-953b2f3d08bf', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-12T14:28:37.863' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	 ,(N'abe06ce3-9c00-4b31-922e-9a2dbcaefc64', N'8a7c0fb3-eb42-482d-b26c-d7bde5a67a75', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', CAST(N'2019-03-12T12:57:43.843' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	 ,(N'f625371b-a253-4514-8beb-b85cad556ee4', N'8a7c0fb3-eb42-482d-b26c-d7bde5a67a75', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-12T12:57:43.843' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	 ,(N'b80ebbb5-93bf-4805-b79b-ca87a850ab75', N'98047320-3d15-411e-aa25-953b2f3d08bf', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-12T14:28:37.863' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	 ,(N'fb1a1ef7-6a3e-4779-94f6-d272194a201f', N'6b12b5b3-9ad3-4100-bdad-3ae5d0b912a9', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-12T12:26:25.050' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	 ,(N'71217040-c452-4cd1-a04f-f15c8a6f3f07', N'6b12b5b3-9ad3-4100-bdad-3ae5d0b912a9', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-12T12:26:25.050' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
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
     (N'06b4714b-66b7-4e3f-b7e5-3bfb5d0c1a4b', N'b2bddcf1-0339-42e6-bdc4-a990e73a4730', N'', N'', N'{"textField":"Status report Status report"}', N'Status report', CAST(N'2019-03-12T18:33:52.657' AS DateTime), CAST(N'2019-03-12T18:33:52.697' AS DateTime), N'000d7682-e46d-48c6-b7d8-b6509fabb3c0')
	,(N'd61a5270-27bc-4c27-a190-80cfa6b0d458', N'a36252ad-2532-47cc-abce-0af57a2d6930', N'', N'', N'{"textField":"Meeting Notes","textArea2":"Meeting NotesMeeting NotesMeeting Notes"}', N'Meeting', CAST(N'2019-03-13T10:09:19.677' AS DateTime), CAST(N'2019-03-13T10:09:19.683' AS DateTime), N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64')
	,(N'ac985188-6b10-4c2b-bc2e-846410e0aaf8', N'6604bda6-fa5d-4b3e-b9db-75cb60b5c916', N'', N'', N'{"textField":"code review report","description":"code review report code review report","isChecked":true}', N'code review report', CAST(N'2019-03-12T18:38:15.053' AS DateTime), CAST(N'2019-03-12T18:38:15.080' AS DateTime), N'db9458b5-d28b-4dd5-a059-69eea129df6e')
	,(N'd9e04d7a-7ab2-47de-8de9-b4fe26702a63', N'a36252ad-2532-47cc-abce-0af57a2d6930', N'', N'', N'{"textField":"Meeting Notes","textArea2":"Meeting Notes Meeting Notes"}', N'Meeting Notes', CAST(N'2019-03-13T10:07:18.243' AS DateTime), CAST(N'2019-03-13T10:07:18.277' AS DateTime), N'5e22e01a-bf81-46c5-8a64-600600e0313d')
	,(N'dca53acc-d061-4f4e-9d87-d3e814859982', N'b2bddcf1-0339-42e6-bdc4-a990e73a4730', N'', N'', N'{"textField":"Report for daily"}', N'Daily Report', CAST(N'2019-03-12T18:36:51.020' AS DateTime), CAST(N'2019-03-12T18:36:51.077' AS DateTime), N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f')
	,(N'b00607bb-edce-4ecc-b919-e1768369d499', N'6604bda6-fa5d-4b3e-b9db-75cb60b5c916', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/backgrounds-min-dd53d4a6-26a6-4721-b16f-0756b8b5b190.jpg', N'backgrounds-min.jpg', N'{"textField":"review is completed","description":"review is completed","isChecked":true}', N'code review', CAST(N'2019-03-12T18:40:03.047' AS DateTime), CAST(N'2019-03-12T18:40:03.067' AS DateTime), N'e38b057f-aa4e-4e63-b10a-74aa252aa004')
)

AS Source ([Id], [StatusReportingConfigurationOptionId], [FilePath], [FileName], [FormDataJson], [Description], [SubmittedDateTime], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [StatusReportingConfigurationOptionId] = Source.[StatusReportingConfigurationOptionId],
		   [FilePath] = source.[FilePath],
		   [FileName] = source.[FileName],
		   [FormDataJson] = Source.[FormDataJson],
		   [Description] = source.[Description],
		   [SubmittedDateTime] = source.[SubmittedDateTime],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [StatusReportingConfigurationOptionId], [FilePath], [FileName], [FormDataJson], [Description], [SubmittedDateTime], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [StatusReportingConfigurationOptionId], [FilePath], [FileName], [FormDataJson], [Description], [SubmittedDateTime], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[CanteenFoodItem] AS Target
USING ( VALUES
     (N'cb2fd905-7c88-4b38-b02a-089f8f665dc4', @CompanyId, N'choco Pie', 10.0000, CAST(N'2019-03-13T17:09:17.360' AS DateTime), NULL, CAST(N'2019-03-13T17:09:17.360' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'b5b5966e-b10a-4b84-918d-4b72a7ec6c64', @CompanyId, N'Hide & Sick', 30.0000, CAST(N'2019-03-13T17:07:24.970' AS DateTime), NULL, CAST(N'2019-03-13T17:07:24.970' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'993be6d5-8c64-4276-9deb-54a4552fd499', @CompanyId, N'od Day Biscuts', 20.0000, CAST(N'2019-03-13T17:05:53.723' AS DateTime), NULL, CAST(N'2019-03-13T17:05:53.723' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'15c55453-9e8b-41e3-bf1a-554e710fcb99', @CompanyId, N'Bin yumitos', 10.0000, CAST(N'2019-03-13T17:05:39.397' AS DateTime), NULL, CAST(N'2019-03-13T17:05:39.397' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'4ef8712e-f3bf-44b7-99a6-69dd8cf14c07', @CompanyId, N'Five star', 10.0000, CAST(N'2019-03-13T17:05:04.307' AS DateTime), NULL, CAST(N'2019-03-13T17:05:04.307' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'bd01d6d7-36fb-4b96-bc2a-6c41d58b6523', @CompanyId, N'50 - 50 Biscuts', 10.0000, CAST(N'2019-03-13T17:07:10.043' AS DateTime), NULL,  CAST(N'2019-03-13T17:07:10.043' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'e113d883-b7c6-4709-b6ba-7211532a9418', @CompanyId, N'Lays (Red)', 10.0000, CAST(N'2019-03-13T17:06:08.667' AS DateTime), NULL,CAST(N'2019-03-13T17:06:08.667' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'6b7853a7-5923-4368-95e5-b3b1c2c9b089', @CompanyId, N'Coffee Bytes', 10.0000, CAST(N'2019-03-13T17:08:05.317' AS DateTime), NULL,  CAST(N'2019-03-13T17:08:05.317' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'b226c0d9-2679-43fd-84df-b4fa5f651b75', @CompanyId, N'Dairy Milk', 10.0000, CAST(N'2019-03-13T17:07:50.840' AS DateTime), NULL, CAST(N'2019-03-13T17:07:50.840' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'e6969138-617c-437a-8c19-e1e9cc4a5612', @CompanyId, N'Lays (Green)', 10.0000, CAST(N'2019-03-13T17:06:32.917' AS DateTime), NULL, CAST(N'2019-03-13T17:06:32.917' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
)

AS Source ([Id], [CompanyId], [FoodItemName], [Price], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [FoodItemName] = source.[FoodItemName],
		   [Price] = source.[Price],
		   [ActiveFrom] = Source.[ActiveFrom],
		   [ActiveTo] = source.[ActiveTo],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [FoodItemName], [Price], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [FoodItemName], [Price], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[UserCanteenCredit] AS Target
USING ( VALUES
     (N'26098635-c25a-4490-b32b-18ab4579df7c', N'db9458b5-d28b-4dd5-a059-69eea129df6e', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'e45e0704-337a-4f44-9f58-1f7a00ebcc90', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'9ee3254c-984c-4472-806e-43ec12d5da36', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'754ce6e6-74dc-4608-8095-46bbb9b7bfbc', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'0088bbd1-a113-4ecc-a818-49e7ae5682ef', N'5e22e01a-bf81-46c5-8a64-600600e0313d', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'e7d7f9b1-e496-441f-b469-5fdafd6fc860', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'3d05f8ed-e89d-4955-a6fc-77bdd357bec4', N'0019af86-8618-4f46-9dfa-a41d9e98275f', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'8710df2d-5eb8-4fc5-b328-d4d2862b85d1', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'd39f6acd-cc9d-48a0-a448-dbf1a36b8506', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'99d102b7-d564-4093-9900-f04d39044430', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', 250.0000, NULL, CAST(N'2019-03-13T17:04:25.240' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
)

AS Source ([Id], [CreditedToUserId], [CreditedByUserId], [Amount], [IsOffered], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CreditedToUserId] = Source.[CreditedToUserId],
		   [CreditedByUserId] = source.[CreditedByUserId],
		   [Amount] = source.[Amount],
		   [IsOffered] = source.[IsOffered],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CreditedToUserId], [CreditedByUserId], [Amount], [IsOffered], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CreditedToUserId], [CreditedByUserId], [Amount], [IsOffered], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[UserPurchasedCanteenFoodItem] AS Target
USING ( VALUES
     (N'3d39ea87-fbfa-4a30-947e-6e3fdc072544', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', N'e6969138-617c-437a-8c19-e1e9cc4a5612', 1, CAST(N'2019-03-13T17:14:43.510' AS DateTime))
	,(N'a522275c-db87-43c8-8a4e-19bb8e0d7647', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', N'bd01d6d7-36fb-4b96-bc2a-6c41d58b6523', 1, CAST(N'2019-03-13T17:20:35.430' AS DateTime))
	,(N'cbf455c2-88c0-4f48-84b4-e25f8e84ab26', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', N'b5b5966e-b10a-4b84-918d-4b72a7ec6c64', 1, CAST(N'2019-03-13T17:20:48.667' AS DateTime))
	,(N'46674a33-00b1-4c51-a7a9-81389a209bd5', N'5e22e01a-bf81-46c5-8a64-600600e0313d', N'cb2fd905-7c88-4b38-b02a-089f8f665dc4', 1, CAST(N'2019-03-13T17:22:33.023' AS DateTime))
	,(N'dbaa1257-dd3b-495c-a6e7-c1b8f0e40afd', N'5e22e01a-bf81-46c5-8a64-600600e0313d', N'15c55453-9e8b-41e3-bf1a-554e710fcb99', 1, CAST(N'2019-03-13T17:22:58.640' AS DateTime))
	,(N'49725834-04c8-43ae-b030-66e738bc611e', N'5e22e01a-bf81-46c5-8a64-600600e0313d', N'4ef8712e-f3bf-44b7-99a6-69dd8cf14c07', 1, CAST(N'2019-03-13T17:22:58.640' AS DateTime))
	,(N'17bf39a1-3aaa-44dd-af50-197c78753e8c', N'5e22e01a-bf81-46c5-8a64-600600e0313d', N'b226c0d9-2679-43fd-84df-b4fa5f651b75', 1, CAST(N'2019-03-13T17:22:58.640' AS DateTime))
	,(N'679dbf72-86c8-4c36-9806-b1f266297fbc', N'5e22e01a-bf81-46c5-8a64-600600e0313d', N'e113d883-b7c6-4709-b6ba-7211532a9418', 1, CAST(N'2019-03-13T17:22:58.640' AS DateTime))
	,(N'de1a543c-2373-4af5-812f-6d12ce07aa78', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', N'993be6d5-8c64-4276-9deb-54a4552fd499', 1, CAST(N'2019-03-13T17:26:44.250' AS DateTime))
	,(N'f63db3bd-6c8c-404a-acd4-90e1b3bedeaa', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', N'b5b5966e-b10a-4b84-918d-4b72a7ec6c64', 1, CAST(N'2019-03-13T17:26:44.250' AS DateTime))
	,(N'11f01220-378b-4beb-9b48-e1701c3a461b', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', N'15c55453-9e8b-41e3-bf1a-554e710fcb99', 1, CAST(N'2019-03-13T17:26:44.250' AS DateTime))
	,(N'0d50dc72-a1b2-49f6-97f8-da2913dd9a1b', N'0019af86-8618-4f46-9dfa-a41d9e98275f', N'4ef8712e-f3bf-44b7-99a6-69dd8cf14c07', 1, CAST(N'2019-03-13T17:27:23.927' AS DateTime))
	,(N'52785c71-0689-4fa6-9b87-7ae05df5d869', N'0019af86-8618-4f46-9dfa-a41d9e98275f', N'b226c0d9-2679-43fd-84df-b4fa5f651b75', 1, CAST(N'2019-03-13T17:27:23.927' AS DateTime))
	,(N'fcd180cc-be81-4cc7-8593-764cfc6d7d49', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', N'bd01d6d7-36fb-4b96-bc2a-6c41d58b6523', 1, CAST(N'2019-03-13T17:28:13.110' AS DateTime))
	,(N'afb7e4d8-3ac6-4d82-8d7d-776c34df8d1b', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', N'e113d883-b7c6-4709-b6ba-7211532a9418', 1, CAST(N'2019-03-13T17:28:13.110' AS DateTime))
	,(N'ec9f1833-e826-4859-91b3-842f18b38143', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', N'e6969138-617c-437a-8c19-e1e9cc4a5612', 1, CAST(N'2019-03-13T17:28:13.110' AS DateTime))
	,(N'a3bd3ca5-b829-470c-bc7c-859e68ee6f93', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', N'b5b5966e-b10a-4b84-918d-4b72a7ec6c64', 1, CAST(N'2019-03-13T17:28:13.110' AS DateTime))
	,(N'de747832-aa96-4891-84f6-d98761587e7c', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', N'b226c0d9-2679-43fd-84df-b4fa5f651b75', 1, CAST(N'2019-03-13T17:28:52.567' AS DateTime))
	,(N'dd4c3fe3-85df-4b79-8503-1f4996f82475', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', N'15c55453-9e8b-41e3-bf1a-554e710fcb99', 1, CAST(N'2019-03-13T17:28:52.567' AS DateTime))
	,(N'44204383-862c-4c36-b7f8-c0a3ea3db7d5', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', N'6b7853a7-5923-4368-95e5-b3b1c2c9b089', 1, CAST(N'2019-03-13T17:28:52.567' AS DateTime))
	,(N'150efd9b-5469-454d-88fa-a42862d2191c', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', N'b5b5966e-b10a-4b84-918d-4b72a7ec6c64', 1, CAST(N'2019-03-13T17:29:30.490' AS DateTime))
	,(N'99d60981-6987-4f23-8da9-2b5fad9a3bfe', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', N'993be6d5-8c64-4276-9deb-54a4552fd499', 1, CAST(N'2019-03-13T17:29:30.490' AS DateTime))
	,(N'853eecad-b5d9-4a04-b4fe-00f09f8b1a45', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', N'15c55453-9e8b-41e3-bf1a-554e710fcb99', 1, CAST(N'2019-03-13T17:29:30.490' AS DateTime))
	,(N'1c4220ee-0532-4dd3-bdcd-30b4fc0ada97', N'db9458b5-d28b-4dd5-a059-69eea129df6e', N'e6969138-617c-437a-8c19-e1e9cc4a5612', 1, CAST(N'2019-03-13T17:24:51.637' AS DateTime))
	,(N'048244fc-53b1-4a13-9cf4-d1ca1cea1cc1', N'db9458b5-d28b-4dd5-a059-69eea129df6e', N'6b7853a7-5923-4368-95e5-b3b1c2c9b089', 1, CAST(N'2019-03-13T17:24:51.637' AS DateTime))
	,(N'b7020e49-6a7a-4cc8-afe2-0289889c37b8', N'db9458b5-d28b-4dd5-a059-69eea129df6e', N'15c55453-9e8b-41e3-bf1a-554e710fcb99', 1, CAST(N'2019-03-13T17:24:51.637' AS DateTime))
	,(N'5a5f2b85-d25c-46f8-8452-d0f071ac6274', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', N'bd01d6d7-36fb-4b96-bc2a-6c41d58b6523', 1, CAST(N'2019-03-13T17:25:38.007' AS DateTime))
	,(N'f3e36088-5b39-45ee-a292-84e65a1e92f6', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', N'15c55453-9e8b-41e3-bf1a-554e710fcb99', 1, CAST(N'2019-03-13T17:25:38.007' AS DateTime))
	,(N'f358d84f-3f19-4147-b684-658de5bf62e8', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', N'e113d883-b7c6-4709-b6ba-7211532a9418', 1, CAST(N'2019-03-13T17:25:38.007' AS DateTime))
)

AS Source ([Id], [UserId], [FoodItemId], [Quantity], [PurchasedDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserId] = Source.[UserId],
		   [FoodItemId] = source.[FoodItemId],
		   [Quantity] = source.[Quantity],
		   [PurchasedDateTime] = source.[PurchasedDateTime]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [UserId], [FoodItemId], [Quantity], [PurchasedDateTime]) VALUES ([Id], [UserId], [FoodItemId], [Quantity], [PurchasedDateTime]);

MERGE INTO [dbo].[FoodOrder] AS Target
USING ( VALUES
     (N'eb1a8f59-71dc-4229-951a-0108dcbf14ef', @CompanyId, N'Chapathi,Roti,panir', 300.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-11T00:00:00.000' AS DateTime), CAST(N'2019-03-13T12:57:44.437' AS DateTime), NULL, CAST(N'2019-03-13T12:57:44.443' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'8126e349-d32c-4418-86a9-0cc1db27493f', @CompanyId, N'Veg Biryani,CurdRice', 300.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T12:45:00.103' AS DateTime), NULL, CAST(N'2019-03-13T12:45:00.107' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'ec4e2f3f-b64e-49fe-a529-1ba0514f5b6f', @CompanyId, N'curdrice,bi', 200.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-08T00:00:00.000' AS DateTime), CAST(N'2019-03-13T13:00:14.207' AS DateTime), NULL, CAST(N'2019-03-13T13:00:14.210' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'e48630eb-33d3-45db-8ddc-279ee62d3474', @CompanyId, N'pulka,caju curruy,paneer,Egg Biryani', 800.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-15T00:00:00.000' AS DateTime), CAST(N'2019-03-13T17:33:25.693' AS DateTime), NULL, CAST(N'2019-03-13T17:33:25.697' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'2a1e0a66-2c20-452a-a3f5-7e67f14c4611', @CompanyId, N'Dum biryani,chapathi,roti,kaju', 500.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-07T00:00:00.000' AS DateTime), CAST(N'2019-03-13T13:02:10.540' AS DateTime), NULL, CAST(N'2019-03-13T13:02:10.547' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'0cc08f7b-5623-4784-9742-998f732647f8', @CompanyId, N'france Biryani,Veg Biryani', 500.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-16T00:00:00.000' AS DateTime), CAST(N'2019-03-13T17:34:10.090' AS DateTime), NULL, CAST(N'2019-03-13T17:34:10.093' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'3a41a64c-bb82-4239-8fde-99d2c7baf9d4', @CompanyId, N'Veg Biryani,Lolipop Biryani', 650.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-06T00:00:00.000' AS DateTime), CAST(N'2019-03-13T17:35:52.627' AS DateTime), NULL, CAST(N'2019-03-13T17:35:52.627' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'3aee4f95-e7cf-4e74-a911-a37bffb97133', @CompanyId, N'Roti,paneer', 250.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-03-13T17:38:17.747' AS DateTime), NULL, CAST(N'2019-03-13T17:38:17.750' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'b76291f4-baaa-4b34-b8ab-d049f8ff06fd', @CompanyId, N'Curd Rice,bi,veg Biryani,Egg Biryani', 700.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-14T00:00:00.000' AS DateTime), CAST(N'2019-03-13T17:32:36.817' AS DateTime), NULL, CAST(N'2019-03-13T17:32:36.847' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'837e7df5-7ebc-4d73-968b-e9d073276e8b', @CompanyId, N'Roti,Pulka,paneer,kaju', 750.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-05T00:00:00.000' AS DateTime), CAST(N'2019-03-13T17:36:25.727' AS DateTime), NULL, CAST(N'2019-03-13T17:36:25.730' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'bffcde95-8122-4b47-b68f-ed2945748c3d', @CompanyId, N'chapathi,kaju,veg Biryani,Roti', 500.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-13T00:00:00.000' AS DateTime), CAST(N'2019-03-13T12:43:30.930' AS DateTime), NULL, CAST(N'2019-03-13T12:43:30.933' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'7aa4a33a-5e91-4438-99d2-fdef80f4a04d', @CompanyId, N'Butter Non,paneer,Roti', 500.0000, NULL, N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'995f20b0-416a-4611-9bb9-cd6470a30aac', CAST(N'2019-03-18T00:00:00.000' AS DateTime), CAST(N'2019-03-13T17:40:41.627' AS DateTime), NULL, CAST(N'2019-03-13T17:40:41.630' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
)

AS Source ([Id], [CompanyId], [FoodItemName], [Amount], [Comment], [ClaimedByUserId], [StatusSetByUserId], [FoodOrderStatusId], [OrderedDateTime], [StatusSetDateTime], [Reason], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [FoodItemName] = source.[FoodItemName],
		   [Amount] = source.[Amount],
		   [Comment] = source.[Comment],
		   [ClaimedByUserId] = Source.[ClaimedByUserId],
		   [StatusSetByUserId] = source.[StatusSetByUserId],
		   [FoodOrderStatusId] = source.[FoodOrderStatusId],
		   [OrderedDateTime] = source.[OrderedDateTime],
		   [StatusSetDateTime] = source.[StatusSetDateTime],
		   [Reason] = source.Reason,
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [FoodItemName], [Amount], [Comment], [ClaimedByUserId], [StatusSetByUserId], [FoodOrderStatusId], [OrderedDateTime], [StatusSetDateTime], [Reason], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [FoodItemName], [Amount], [Comment], [ClaimedByUserId], [StatusSetByUserId], [FoodOrderStatusId], [OrderedDateTime], [StatusSetDateTime], [Reason], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[File] AS Target
USING ( VALUES
     (N'879cdda4-137e-49d0-bb56-0b0fb31a0d61', NULL, N'backgrounds-min.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/backgrounds-min-ed95002f-906c-47b5-bd58-113a763d51ce.jpg', CAST(N'2019-03-13T12:57:44.457' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'eb1a8f59-71dc-4229-951a-0108dcbf14ef', NULL, NULL, NULL, @CompanyId)
	,(N'295c73dc-443f-4bf0-bea1-226769b76c3c', NULL, N'backgrounds-min.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/backgrounds-min-00771168-5da7-423d-a148-483e0f7508ad.jpg', CAST(N'2019-03-13T17:36:25.760' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',  NULL, N'837e7df5-7ebc-4d73-968b-e9d073276e8b', NULL, NULL, NULL, @CompanyId)
	,(N'627451aa-90d4-42d3-a6ea-4a3023a88406', NULL, N'220px-Ricoh_500_camera_front.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/220px-Ricoh_500_camera_front-2f5f9460-f069-4a9d-b626-724d1567cecc.jpg', CAST(N'2019-03-13T13:00:14.223' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'ec4e2f3f-b64e-49fe-a529-1ba0514f5b6f', NULL, NULL, NULL, @CompanyId)
	,(N'69cc3d6a-eb96-43ea-85ee-7c891cee77b4', NULL, N'backgrounds-min.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/backgrounds-min-7ff92682-8779-417d-94f4-31f3787b9dcc.jpg', CAST(N'2019-03-13T13:02:10.563' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'2a1e0a66-2c20-452a-a3f5-7e67f14c4611', NULL, NULL, NULL, @CompanyId)	
	,(N'ba9f2817-4027-41b2-a905-8093946d254e', NULL, N'1.png', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/1-ffe47143-049a-44ee-a9b1-9429e7c7ea43.png', CAST(N'2019-03-13T17:32:36.870' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'b76291f4-baaa-4b34-b8ab-d049f8ff06fd', NULL, NULL, NULL, @CompanyId)
	,(N'86567abc-0062-4aa1-a877-9fc5e977ccf5', NULL, N'7978-inspirational-desktop-wallpaper-free_9936.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/7978-inspirational-desktop-wallpaper-free_9936-cf27ca1f-5292-4a82-b971-6ca6450f4acf.jpg', CAST(N'2019-03-13T17:38:17.767' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'3aee4f95-e7cf-4e74-a911-a37bffb97133', NULL, NULL, NULL, @CompanyId)
	,(N'ebdd95a5-fdcc-4e1c-9574-a3574af683df', NULL, N'backgrounds-min.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/backgrounds-min-a8cdaf62-f276-4696-bb3d-85cfaec5ed1e.jpg', CAST(N'2019-03-13T17:33:25.713' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'e48630eb-33d3-45db-8ddc-279ee62d3474', NULL, NULL, NULL, @CompanyId)
	,(N'f2acc4b0-ead7-4cac-a9e1-ca090e26aaa7', NULL, N'backgrounds-min.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/backgrounds-min-d6367a18-2c19-4182-bae3-7bc9fa23782c.jpg', CAST(N'2019-03-13T12:43:37.453' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'bffcde95-8122-4b47-b68f-ed2945748c3d', NULL, NULL, NULL, @CompanyId)
	,(N'bf5c4181-7727-440c-bc85-d7d2adb04b51', NULL, N'backgrounds-min.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/backgrounds-min-178ac0b4-ebf2-4ecd-8d97-c60ac43c5222.jpg', CAST(N'2019-03-13T17:34:10.103' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'0cc08f7b-5623-4784-9742-998f732647f8', NULL, NULL, NULL, @CompanyId)
	,(N'2e0c77e8-d538-4744-bafd-e6dc46816351', NULL, N'Princess-Arrows-facebook-timeline-cover.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/Princess-Arrows-facebook-timeline-cover-24996f85-129a-403f-a7f9-986de58057ed.jpg', CAST(N'2019-03-13T12:45:00.120' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'8126e349-d32c-4418-86a9-0cc1db27493f', NULL, NULL, NULL, @CompanyId)
	,(N'074d2b9c-6695-4140-8696-f771432abfa4', NULL, N'7978-inspirational-desktop-wallpaper-free_9936.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/7978-inspirational-desktop-wallpaper-free_9936-eaa164dd-6abd-488e-888d-c5ce0af21a16.jpg', CAST(N'2019-03-13T17:35:52.640' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f',  NULL, N'3a41a64c-bb82-4239-8fde-99d2c7baf9d4', NULL, NULL, NULL, @CompanyId)
	,(N'ec4fb9c0-5d41-4fc4-83af-fb7eed15fab7', NULL, N'backgrounds-min.jpg', N'https://bviewstorage.blob.core.windows.net/localsiteuploads/backgrounds-min-5cc7701c-b3fd-4eb2-8c46-d8b1c7a448a7.jpg', CAST(N'2019-03-13T17:40:41.647' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', NULL, N'7aa4a33a-5e91-4438-99d2-fdef80f4a04d', NULL, NULL, NULL, @CompanyId)
)

AS Source ([Id], [UserStoryId], [FileName], [FilePath], [CreatedDateTime], [CreatedByUserId],[LeadId], [FoodOrderId], [EmployeeId], [StatusReportingId], [IsTimeSheetUpload], [CompanyId]) 
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserStoryId] = Source.[UserStoryId],
		   [FileName] = source.[FileName],
		   [FilePath] = source.[FilePath],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [LeadId] = Source.[LeadId],
		   [FoodOrderId] = source.[FoodOrderId],
		   [EmployeeId] = source.[EmployeeId],
		   [StatusReportingId] = source.[StatusReportingId],
		   [IsTimeSheetUpload] = source.[IsTimeSheetUpload],
		   [CompanyId] = source.[CompanyId]

WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [UserStoryId], [FileName], [FilePath], [CreatedDateTime], [CreatedByUserId], [LeadId], [FoodOrderId], [EmployeeId], [StatusReportingId], [IsTimeSheetUpload], [CompanyId]) VALUES ([Id], [UserStoryId], [FileName], [FilePath], [CreatedDateTime], [CreatedByUserId], [LeadId], [FoodOrderId], [EmployeeId], [StatusReportingId], [IsTimeSheetUpload], [CompanyId]) ;

MERGE INTO [dbo].[FoodOrderUser] AS Target
USING ( VALUES
     (N'60261812-41a2-41a3-ad3b-003af32a39cd', N'3aee4f95-e7cf-4e74-a911-a37bffb97133', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-13T17:38:17.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'941c8ad2-6f00-4e0f-906c-064a1c5c8235', N'0cc08f7b-5623-4784-9742-998f732647f8', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-13T17:34:10.097' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'a750210d-9043-4b05-9b86-1e6fddb04da7', N'e48630eb-33d3-45db-8ddc-279ee62d3474', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-13T17:33:25.700' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'f7298a0b-ab1e-40f4-8fb2-221ab9cad73e', N'b76291f4-baaa-4b34-b8ab-d049f8ff06fd', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-13T17:32:36.863' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'574163fd-302c-4cfb-8f6f-2596dc0d0743', N'837e7df5-7ebc-4d73-968b-e9d073276e8b', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', CAST(N'2019-03-13T17:36:25.750' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'5018e46b-d09f-4085-b901-36008843dc75', N'2a1e0a66-2c20-452a-a3f5-7e67f14c4611', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-13T13:02:10.550' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'309e2f6a-8daf-4b4b-be22-3f955dbec1fb', N'837e7df5-7ebc-4d73-968b-e9d073276e8b', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-13T17:36:25.750' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'2874e64e-5000-49ad-8d20-41d6e67ee589', N'eb1a8f59-71dc-4229-951a-0108dcbf14ef', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-13T12:57:44.447' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'aac61640-2f2c-4153-95b7-490cc2ecc7db', N'7aa4a33a-5e91-4438-99d2-fdef80f4a04d', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-13T17:40:41.637' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'ecba1d1e-fcb6-408f-af4e-4d970b06158a', N'8126e349-d32c-4418-86a9-0cc1db27493f', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-13T12:45:00.110' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'4d73be0f-028a-4cef-af7c-5129fb2705d3', N'bffcde95-8122-4b47-b68f-ed2945748c3d', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-13T12:43:30.953' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'e9f7228b-6f0d-411d-a65e-660f7a8110fa', N'7aa4a33a-5e91-4438-99d2-fdef80f4a04d', N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', CAST(N'2019-03-13T17:40:41.637' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'bb66a792-d656-448e-a849-695ef9c36b07', N'eb1a8f59-71dc-4229-951a-0108dcbf14ef', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-13T12:57:44.447' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'f6904fcc-8bd8-4ab1-90fb-6f1a90da555d', N'8126e349-d32c-4418-86a9-0cc1db27493f', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-13T12:45:00.110' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'8d1bc6d7-24fc-4874-b0d2-7261728a4a41', N'bffcde95-8122-4b47-b68f-ed2945748c3d', N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', CAST(N'2019-03-13T12:43:30.953' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'20b26917-ddde-4b3c-aaef-74a4713d444b', N'837e7df5-7ebc-4d73-968b-e9d073276e8b', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-13T17:36:25.750' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'aac2f387-bbba-4e94-a1ac-87b7d3005277', N'e48630eb-33d3-45db-8ddc-279ee62d3474', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-13T17:33:25.700' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'03c420e1-370f-4f22-b35e-8cd25be1e738', N'0cc08f7b-5623-4784-9742-998f732647f8', N'e38b057f-aa4e-4e63-b10a-74aa252aa004', CAST(N'2019-03-13T17:34:10.097' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'006f718b-05b9-4d75-8849-93c14bc5c44a', N'e48630eb-33d3-45db-8ddc-279ee62d3474', N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', CAST(N'2019-03-13T17:33:25.700' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'374e3584-fb45-48b1-9e12-95d4b1daf366', N'ec4e2f3f-b64e-49fe-a529-1ba0514f5b6f', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-13T13:00:14.217' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'd160235f-ae37-4822-8877-a36e0a7890b8', N'3a41a64c-bb82-4239-8fde-99d2c7baf9d4', N'5e22e01a-bf81-46c5-8a64-600600e0313d', CAST(N'2019-03-13T17:35:52.633' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'2706ef61-8fe5-47eb-9fda-ab35054d2f1c', N'8126e349-d32c-4418-86a9-0cc1db27493f', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-13T12:45:00.110' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'10d57271-e3f2-4289-bf4a-c3d30381f212', N'3a41a64c-bb82-4239-8fde-99d2c7baf9d4', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-13T17:35:52.633' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'1f15d0f6-7899-434b-a2cf-cb04e0059831', N'3a41a64c-bb82-4239-8fde-99d2c7baf9d4', N'0019af86-8618-4f46-9dfa-a41d9e98275f', CAST(N'2019-03-13T17:35:52.633' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'613940ba-feab-461e-99e9-cbd20b04f4dd', N'7aa4a33a-5e91-4438-99d2-fdef80f4a04d', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-13T17:40:41.637' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'bb55563d-367e-45c7-aee4-d75c461aaf5a', N'bffcde95-8122-4b47-b68f-ed2945748c3d', N'db9458b5-d28b-4dd5-a059-69eea129df6e', CAST(N'2019-03-13T12:43:30.953' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'b44494d8-a022-4255-9c44-d83e63986c6e', N'b76291f4-baaa-4b34-b8ab-d049f8ff06fd', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-13T17:32:36.863' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'601b33d3-6d09-4810-8ad1-d9eb4a3eacd5', N'3aee4f95-e7cf-4e74-a911-a37bffb97133', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-13T17:38:17.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'0d76a02c-e4e6-4c10-ab54-dcc51ae9668a', N'ec4e2f3f-b64e-49fe-a529-1ba0514f5b6f', N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', CAST(N'2019-03-13T13:00:14.217' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'3a2ef33d-5e56-4f13-87c9-e56cc0f96721', N'2a1e0a66-2c20-452a-a3f5-7e67f14c4611', N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', CAST(N'2019-03-13T13:02:10.550' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'819f4874-3573-46a5-bb7a-f3de5a55e71f', N'b76291f4-baaa-4b34-b8ab-d049f8ff06fd', N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', CAST(N'2019-03-13T17:32:36.863' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
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

MERGE INTO [dbo].[UserStorySpentTime] AS Target
USING ( VALUES
		 (N'acf230c0-73d9-49be-a897-0c50397c9d25', N'f633c431-f38f-402b-bd8d-7f16b495bd76', 1200, 60, N'TEST', N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T00:00:00.000' AS DateTime), N'8008e5e4-9060-41af-80ec-bcb5baf7c22c', 0, CAST(N'2019-03-22T16:02:42.777' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL, NULL)
        ,(N'18bedb03-51ec-4880-85e6-26fe2db4250a', N'e1f9c151-0dca-4d93-a68b-5974bb7e2eca', 1200, 240, N'TEST', N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T00:00:00.000' AS DateTime), N'8008e5e4-9060-41af-80ec-bcb5baf7c22c', 0, CAST(N'2019-03-22T16:02:22.113' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL, NULL)
        ,(N'87c01151-8438-474c-ad17-3713be5e3e36', N'f5e1d216-e3c0-4d83-b56d-59302a85827c', 480, 60, N'TEST', N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T00:00:00.000' AS DateTime), N'8008e5e4-9060-41af-80ec-bcb5baf7c22c', 0, CAST(N'2019-03-22T16:04:02.257' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL, NULL)
        ,(N'a11d1b32-f5d3-49ca-a820-38cae291e0e3', N'7a110ece-fbc2-43ab-b02f-fd3e42f2472d', 360, 300, N'TEST', N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T00:00:00.000' AS DateTime), N'8008e5e4-9060-41af-80ec-bcb5baf7c22c', 0, CAST(N'2019-03-22T16:03:32.250' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971',  NULL, NULL)
        ,(N'9fc010d0-b051-4628-8ff5-538c071c24f8', N'62b3c0f8-d0f8-493e-83b9-8e7c463099a4', 300, 600, N'TEST', N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T00:00:00.000' AS DateTime), N'8008e5e4-9060-41af-80ec-bcb5baf7c22c', 0, CAST(N'2019-03-22T16:03:19.210' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL, NULL)
        ,(N'45beab2b-2ee1-46ae-b7c7-554c2e600430', N'963c9fe7-f822-4b5a-a7de-9f7be098bb90', 1200, 60, N'TEST', N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T00:00:00.000' AS DateTime), N'8008e5e4-9060-41af-80ec-bcb5baf7c22c', 0, CAST(N'2019-03-22T16:03:04.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971',  NULL, NULL)
        ,(N'5df5c01e-00ec-40bd-b4ae-5e2d027b7f8b', N'c9b482a5-a0dc-40e8-84e4-347d67a8ec34', 1200, 240, N'TEST', N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T00:00:00.000' AS DateTime), N'8008e5e4-9060-41af-80ec-bcb5baf7c22c', 0, CAST(N'2019-03-22T16:02:32.880' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971',  NULL, NULL)
        ,(N'1bba934a-babb-4ba7-b3f2-875942a59516', N'035ef61d-60c2-4633-a66f-216c4040be49', 1200, 60, N'TEST', N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T00:00:00.000' AS DateTime), N'8008e5e4-9060-41af-80ec-bcb5baf7c22c', 0, CAST(N'2019-03-22T16:02:53.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971',  NULL, NULL)
        ,(N'5e92ce46-c002-4f3a-95f4-a2f3d4ee07a0', N'83c07f12-610d-47d3-87ff-1d8b8e8f93de', 420, 60, N'TEST', N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-03-12T00:00:00.000' AS DateTime), CAST(N'2019-03-13T00:00:00.000' AS DateTime), N'8008e5e4-9060-41af-80ec-bcb5baf7c22c', 0, CAST(N'2019-03-22T16:03:48.827' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL, NULL)
)
AS Source ([Id], [UserStoryId], [SpentTimeInMin], [RemainingTimeInMin], [Comment], [UserId], [DateFrom], [DateTo], [LogTimeOptionId], [UserInput], [CreatedDateTime], [CreatedByUserId]
, [SpentTime], [InActiveDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserStoryId] = Source.[UserStoryId],
		   [SpentTimeInMin] = source.[SpentTimeInMin],
		   [RemainingTimeInMin] = source.[RemainingTimeInMin],
		   [Comment] = source.[Comment],
		   [UserId] = source.[UserId],
		   [DateFrom] = source.[DateFrom],
		   [DateTo] = source.[DateTo],
		   [LogTimeOptionId] = source.[LogTimeOptionId],
		   [UserInput] = source.[UserInput],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [SpentTime] = Source.[SpentTime],
           [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [UserStoryId], [SpentTimeInMin], [RemainingTimeInMin], [Comment], [UserId], [DateFrom], [DateTo], [LogTimeOptionId], [UserInput], [CreatedDateTime], [CreatedByUserId], [SpentTime], [InActiveDateTime]) VALUES ([Id], [UserStoryId], [SpentTimeInMin], [RemainingTimeInMin], [Comment], [UserId], [DateFrom], [DateTo], [LogTimeOptionId], [UserInput], [CreatedDateTime], [CreatedByUserId],[SpentTime], [InActiveDateTime]);

MERGE INTO [dbo].[UserStorySubType] AS Target 
USING ( VALUES 
 (N'EAF063CB-A1AB-40E6-8EFC-E3A6CD953A21', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', N'UI Integration', CAST(N'2019-03-13T06:19:56.113' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971' )
, (N'569C8DCA-F91A-4DEA-AAA9-1C463EF4EA9A', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', N'Api definition', CAST(N'2018-10-26T11:36:20.480' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
,(N'C20688E2-AEB7-468C-A6B4-5E12910BD7FC', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', N'UI definition', CAST(N'2018-10-26T11:36:20.480' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
,(N'36A04489-98B4-4FF4-B449-C2E9C971A275', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', N'DB', CAST(N'2018-10-26T11:36:20.480' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
,(N'4388C66A-2AC6-45F7-92E3-A02BD11CA8B6', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', N'API', CAST(N'2018-10-26T11:36:20.480' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
,(N'8F259916-B6D4-464A-9334-B392A5CBD757', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', N'UI', CAST(N'2018-10-26T11:36:20.480' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
)
AS Source ([Id], [CompanyId], [UserStorySubTypeName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id 
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId], 
           [UserStorySubTypeName]      = Source.[UserStorySubTypeName],
		   [CreatedDateTime] = Source.[CreatedDateTime],
	       [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [CompanyId], [UserStorySubTypeName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [UserStorySubTypeName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ReviewTemplate] AS Target
USING ( VALUES    
	    (N'D36EB922-C82F-478E-9D17-15C6E0127CBD',  N'{"TemplateJson": ["Is any Loops or Cursors used ?", "Is any functions Used..?", "Weather follewed DB Guidelines ?"]}',N'36A04489-98B4-4FF4-B449-C2E9C971A275', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'3C873F7D-A6F7-4B7A-A221-6C12837CCA39',  N'{"TemplateJson": ["Is Followed API Defination Contraints ?", "Is Alignment is Good..?", "Is It understandable for Developers ?"]}',N'569C8DCA-F91A-4DEA-AAA9-1C463EF4EA9A', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'A2992C10-A627-4819-A645-29D81488F6F5',  N'{"TemplateJson": ["Is Followed UI  Defination Contraints ?", "Is Alignment is Good..?", "Is It understandable for  Developers ?"]}',N'C20688E2-AEB7-468C-A6B4-5E12910BD7FC', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'2CD47A26-1CDA-403C-B528-90800506AB52',  N'{"TemplateJson": ["Is validations correct or Not.. ?", "Is Provided any security..?", "Weather  Flexibility Or Not ?"]}',N'4388C66A-2AC6-45F7-92E3-A02BD11CA8B6', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
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

MERGE INTO [dbo].[UserStoryReviewTemplate] AS Target
USING ( VALUES    
	    (N'59F7B293-68AA-4F4E-BE60-5D353300643B',  N'D36EB922-C82F-478E-9D17-15C6E0127CBD',N'A69A1636-9EE6-4BC3-8F73-04CF0DC56C3D', N'127133F1-4427-4149-9DD6-B02E0E036971',N'Good' ,1,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'A7D3CDB7-417F-4127-A73E-E0BE987EDD9A',  N'D36EB922-C82F-478E-9D17-15C6E0127CBD',N'066E793B-FC9A-478A-8F2F-06FB158052D7', N'127133F1-4427-4149-9DD6-B02E0E036971',N'Have to Improve' ,1,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'DC399BF4-E907-414F-8F2C-7A2F4083D628',  N'A2992C10-A627-4819-A645-29D81488F6F5',N'5DE9E4F6-C7CA-4390-9D68-17DB10155D71', N'127133F1-4427-4149-9DD6-B02E0E036971',N'Excellent', 1,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'3AFDDDF6-935F-43C0-B016-D2E1D86C3686',  N'3C873F7D-A6F7-4B7A-A221-6C12837CCA39',N'83C07F12-610D-47D3-87FF-1D8B8E8F93DE', N'127133F1-4427-4149-9DD6-B02E0E036971',N'acceptable' ,1,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [ReviewTemplateId], [UserStoryId], [ReviewerId],[ReviewComments],[IsAccepted], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [ReviewTemplateId] = Source.[ReviewTemplateId],
		   [UserStoryId] = source.[UserStoryId],
		   [ReviewerId] = Source.[ReviewerId],
		   [ReviewComments] = Source.[ReviewComments],
		   [IsAccepted] = Source.[IsAccepted],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [ReviewTemplateId], [UserStoryId], [ReviewerId],[ReviewComments],[IsAccepted], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [ReviewTemplateId], [UserStoryId], [ReviewerId],[ReviewComments],[IsAccepted], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[UserStoryReview] AS Target
USING ( VALUES    
	    (N'8691191C-736A-491C-9CC3-9C3947E30753',  N'DC399BF4-E907-414F-8F2C-7A2F4083D628',N'{"AnswerJson": ["Yes", "Yes", "Yes"]}',CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'D3D07AAD-C910-4405-BCDF-AEE8248D3FCD',  N'DC399BF4-E907-414F-8F2C-7A2F4083D628',N'{"AnswerJson": ["Yes", "Yes", "Yes"]}',CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'9011A54B-2946-4094-A58F-3493B169C57C',  N'A7D3CDB7-417F-4127-A73E-E0BE987EDD9A',N'{"AnswerJson": ["Yes", "Yes", "Yes"]}',CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'F73B5400-448E-43F0-95E9-A50ED4F048A3',  N'59F7B293-68AA-4F4E-BE60-5D353300643B',N'{"AnswerJson": ["Yes", "Yes", "Yes"]}',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [UserStoryReviewTemplateId], [AnswerJson], [SubmittedDateTime], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [UserStoryReviewTemplateId] = Source.[UserStoryReviewTemplateId],
		   [AnswerJson] = source.[AnswerJson],
		   [SubmittedDateTime] = Source.[SubmittedDateTime],		  
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [UserStoryReviewTemplateId], [AnswerJson], [SubmittedDateTime], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [UserStoryReviewTemplateId], [AnswerJson], [SubmittedDateTime], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseCategory] AS Target
USING ( VALUES    
	    (N'0E050BE7-FD1D-4E61-B0A3-776BECF4CB8E',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'IT and Internet Expences',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'D4D4C82A-164E-49BA-9D73-2E4B2605456C',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Auto mobile expences',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'CA68F1CD-0C73-4021-9C56-00D0D28EA7AB',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Office Supplies',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'2A9ABB65-BF32-4025-8A3B-C8A6CF0C7A5D',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Other Expenses',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [CompanyId], [CategoryName],[Image],[AccountCode],[Description], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [CategoryName] = source.[CategoryName],	  
		   [Image] = Source.[Image],
		   [AccountCode] = Source.[AccountCode],
		   [Description] = Source.[Description],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [CategoryName],[Image],[AccountCode],[Description], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [CategoryName],[Image],[AccountCode],[Description], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseReportStatus] AS Target
USING ( VALUES    
	    (N'7F9971D0-8226-4870-95FA-BEA7D59125F5',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Achived',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL),
		(N'3DAA3CEE-B073-4D3E-A942-CBB654BD729F',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Submitted',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',1),
		(N'3D484B8A-9EB5-4A08-A42D-A6E1870D6257',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Approved',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL),
		(N'20192D11-57DF-40A3-81D6-B524A2E5C123',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Rejected',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971' ,NULL),
		(N'FC20D699-6B97-4764-8643-033F463F2D40',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Reimbursed',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',NULL)
		)
AS Source ([Id], [CompanyId], [Name],[Description] ,[CreatedDateTime], [CreatedByUserId], [IsDefault])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [Name]      = source.[Name],	 
		   [Description]      = source.[Description],	 	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [IsDefault]          = Source.[IsDefault]       	   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [Name], [CreatedDateTime], [CreatedByUserId], [IsDefault]) VALUES  ([Id], [CompanyId], [Name], [CreatedDateTime], [CreatedByUserId],[IsDefault]);

MERGE INTO [dbo].[Merchant] AS Target
USING ( VALUES    
	    (N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', N'maira',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'5e22e01a-bf81-46c5-8a64-600600e0313d', N'james',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'db9458b5-d28b-4dd5-a059-69eea129df6e', N'david',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', N'Ani',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'e38b057f-aa4e-4e63-b10a-74aa252aa004', N'AJAY',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'mickel',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'0019af86-8618-4f46-9dfa-a41d9e98275f', N'vinay',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', N'viliams',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', N'robert',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', N'jairam',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [MerchantName],[Description] ,[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
		   [MerchantName]      = source.[MerchantName],	 
		   [Description]      = source.[Description],	 	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id],  [MerchantName],[Description], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id],  [MerchantName],[Description], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[PaymentStatus] AS Target
USING ( VALUES    
	    (N'154FC7EF-0ABC-435D-9A2E-51CB18DE964F',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Succuss',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL),
		(N'86A5DAE0-3CE6-4E72-A493-3AB6CB8AEB87',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Fail',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL),
		(N'66F95C6C-25C7-49C5-804C-5CD88D891FE1',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Pending',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', 1)
		)
AS Source ([Id], [CompanyId], [PaymentStatus],[CreatedDateTime], [CreatedByUserId],[IsDefault])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [PaymentStatus]   = source.[PaymentStatus],	   	 	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
		   [IsDefault]          = Source.[IsDefault]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [PaymentStatus],[CreatedDateTime], [CreatedByUserId],[IsDefault]) VALUES   ([Id], [CompanyId], [PaymentStatus],[CreatedDateTime], [CreatedByUserId],[IsDefault]);

MERGE INTO [dbo].[ExpenseReport] AS Target
USING ( VALUES    
	    (N'EAA6DF86-F929-468D-99CA-F69144F27FF7',  N'Test',N'Software ',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'7F9971D0-8226-4870-95FA-BEA7D59125F5',10000,5000, 0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'62585EEA-93CB-46EA-9891-6C8136775F74',  N'test1',N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'3DAA3CEE-B073-4D3E-A942-CBB654BD729F',10000,10000,0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'1B037D8C-FCA6-4F65-A54E-390BFD33C545',  N'Test3', N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'3D484B8A-9EB5-4A08-A42D-A6E1870D6257',10000,20000,0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'5B0D2D36-6C73-4EF4-98A7-50C15DB4B9AA',  N'Test2',N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'3DAA3CEE-B073-4D3E-A942-CBB654BD729F',10000,50000,0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'154ECB11-6E06-4DA4-BCF7-D48DA07A95BF',  N'test4',N'Software ',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'FC20D699-6B97-4764-8643-033F463F2D40',10000,0,    0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',  N'test5',N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'3DAA3CEE-B073-4D3E-A942-CBB654BD729F',10000,0,    0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [ReportTitle], [BusinessPurpose],[DurationFrom],[DurationTo],[ReportStatusId],[AdvancePayment],[AmountToBeReimbursed],[IsReimbursed],[UndoReimbursement],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [ReportTitle] = Source.[ReportTitle],
		   [BusinessPurpose]      = source.[BusinessPurpose],	   
		    [DurationFrom]      = source.[DurationFrom],
			[DurationTo]      = source.[DurationTo],
			[ReportStatusId]      = source.[ReportStatusId],
			[AdvancePayment]      = source.[AdvancePayment],
			[AmountToBeReimbursed]      = source.[AmountToBeReimbursed],
			[IsReimbursed]      = source.[IsReimbursed],
			[UndoReimbursement]      = source.[UndoReimbursement],	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [ReportTitle], [BusinessPurpose],[DurationFrom],[DurationTo],[ReportStatusId],[AdvancePayment],[AmountToBeReimbursed],[IsReimbursed],[UndoReimbursement],[CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [ReportTitle], [BusinessPurpose],[DurationFrom],[DurationTo],[ReportStatusId],[AdvancePayment],[AmountToBeReimbursed],[IsReimbursed],[UndoReimbursement],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Mode] AS Target
USING ( VALUES    
 (N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'COD', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
 ,(N'A0EBEE4B-4CA5-4C06-9001-FA011C2E43FB', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Payment', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
  )
AS Source  ([Id], [CompanyId], [ModeName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [CompanyId]      = source.[CompanyId],
		   [ModeName]      = source.[ModeName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]     	   
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [ModeName], [CreatedDateTime], [CreatedByUserId]) VALUES   ([Id], [CompanyId], [ModeName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Customer] AS Target
USING ( VALUES    
	    (N'17947499-E01B-41C9-BE25-4E97ACA20B2A',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'Divya', N'd@gmail.com ',N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'0DA65173-9015-4AF9-8C0F-683E939BA063',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'Geetha',N'g@gmail.com', N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'750A9903-E772-474A-A421-B036D8ABF731',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'sudha',N's@gmail.com' ,N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'B3EC1FAE-E9CE-468B-9C05-86337B144083',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'harika',N'h@gmail.com', N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'23C5C6E7-1DF4-4675-9D05-A8AEF2FE3E70',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'teja',N'T@gmail.com ',N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'DAABC1CF-7B86-40EB-9E32-B7AF2CB93312',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'Mahesh',N'm@gmail.com', N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [CompanyId], [CustomerName],[ContactEmail],[AddressLine1],[AddressLine2],[City],[StateId],[CountryId],[PostalCode],[MobileNumber],[Notes],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [CustomerName]      = source.[CustomerName],	   
		    [ContactEmail]      = source.[ContactEmail],
			[AddressLine1]      = source.[AddressLine1],
			[AddressLine2]      = source.[AddressLine2],
			[City]      = source.[City],
			[StateId]      = source.[StateId],
			[CountryId]      = source.[CountryId],
			[PostalCode]      = source.[PostalCode],
			[MobileNumber]      = source.[MobileNumber],
			[Notes]      = source.[Notes],	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		       	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [CustomerName],[ContactEmail],[AddressLine1],[AddressLine2],[City],[StateId],[CountryId],[PostalCode],[MobileNumber],[Notes],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [CustomerName],[ContactEmail],[AddressLine1],[AddressLine2],[City],[StateId],[CountryId],[PostalCode],[MobileNumber],[Notes],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Invoice] AS Target
USING ( VALUES    
  (N'd328e49f-6211-45e7-b225-0a3e1648324d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'aa093867-45fa-4797-88a7-1f0b953965e9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'01a8f69d-4baf-4239-9389-2400534d40af', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'26668536-e9ef-408f-a000-2a20c39200af', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1e2b435c-0f88-460f-8163-72db669cc976', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'12f1d580-69c2-42b6-9a98-7bed48601527', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'525a9b87-a559-45c9-b6c7-b569da70077d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'676c1785-d872-4e92-8b2f-c043645bb324', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'47577c50-7b51-4522-82e7-c9935e18b3de', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0e888feb-a433-457e-91c6-db08c58ec150', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'06e846f9-de32-46af-930a-f039d54fa8f7', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'588222af-14c9-4acc-87c0-fa99a3c06285', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'936318da-8b44-4569-99cc-fada0f1cea00', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source ([Id], [CompanyId], [CompnayLogo], [BillToCustomerId], [ProjectId], [InvoiceTypeId], [InvoiceNumber], [Date], [DueDate], [Discount], [Notes], [Terms], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [CompnayLogo]      = source.[CompnayLogo],	   
		    [BillToCustomerId]      = source.[BillToCustomerId],
			[ProjectId]      = source.[ProjectId],
			[InvoiceTypeId]      = source.[InvoiceTypeId],
			[InvoiceNumber]      = source.[InvoiceNumber],
			[Date]      = source.[Date],
			[DueDate]      = source.[DueDate],
			[Discount]      = source.[Discount],
			[Notes]      = source.[Notes],
			[Terms]      = source.[Terms],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		      	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [CompnayLogo], [BillToCustomerId], [ProjectId], [InvoiceTypeId], [InvoiceNumber], [Date], [DueDate], [Discount], [Notes], [Terms], [CreatedDateTime], [CreatedByUserId])VALUES ([Id], [CompanyId], [CompnayLogo], [BillToCustomerId], [ProjectId], [InvoiceTypeId], [InvoiceNumber], [Date], [DueDate], [Discount], [Notes], [Terms], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseComment] AS Target
USING ( VALUES    
	    (N'E8EEA80C-9C25-4787-BC76-C8DCAD20D36A', N'6A35EB12-C866-4D65-8B70-189DFDEC6DF8',N'Completed', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',NULL),
		(N'1A79AB09-0554-4023-883D-DABE9435C6A9' ,N'D1BE307A-6B02-4AB8-96A0-8F48E863E60C',N'Returned', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL),
		(N'5BAF1524-A297-4C89-8DFA-FD883D6E7D77', N'4193D145-DCAF-47FC-B633-9BC5D8B1E114',N'Paid', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',NULL),
		(N'AA5A1060-9772-43CA-A914-043F9B79F48F' ,N'A6DEB011-745E-42C0-AE71-A93B45DCCC79',N'paid', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL),
		(N'EEB6B5A0-F8AC-44DB-B986-9E98C5AAF876' ,N'CF237784-F87B-4FF8-8479-B2CBF81EC28D',N'paid', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',NULL),
		(N'B9569466-7DD5-41C8-B3DE-0DAFD0417151' ,N'AE965C00-2B86-4FE7-B9B3-BE80A3E44049',N'paid', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL )
		)
AS Source ([Id], [ExpenseId],[Comment],[CreatedDateTime], [CreatedByUserId],[InActiveDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [ExpenseId]      = source.[ExpenseId],	   
		   [Comment] = Source.[Comment],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],     
		   [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [ExpenseId],[Comment],[CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) VALUES  ([Id], [ExpenseId],[Comment],[CreatedDateTime], [CreatedByUserId],[InActiveDateTime]);

MERGE INTO [dbo].[ExpenseReportHistory] AS Target
USING ( VALUES    
	    (N'49C11968-48DB-414C-82DB-D04A20094152', N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF', N'#ssms',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',NULL),
		(N'DBFD0595-9987-4A9D-9F91-A31C86F7ECBA' ,N'1B037D8C-FCA6-4F65-A54E-390BFD33C545', N'whole office related',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL),
		(N'4FC0BA5A-7C30-471B-ABE4-C8DF22AC23FB', N'5B0D2D36-6C73-4EF4-98A7-50C15DB4B9AA', N'repaired',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',NULL),
		(N'0A73FE87-623A-4C11-84F5-D9DAD626791D' ,N'62585EEA-93CB-46EA-9891-6C8136775F74', N'Newly',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL),
		(N'22BFEFF4-EACC-4545-B0D3-48A39244881B' ,N'154ECB11-6E06-4DA4-BCF7-D48DA07A95BF', N'whole spenyt cost',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971',NULL),
		(N'A6CD4052-9861-4D61-A53D-FBC17B405948' ,N'EAA6DF86-F929-468D-99CA-F69144F27FF7', N'Every day fare',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971', NULL)
		)
AS Source ([Id], [ExpenseReportId],[Description],[CreatedDateTime], [CreatedByUserId],[InActiveDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [ExpenseReportId]      = source.[ExpenseReportId],	   
		   [Description] = Source.[Description],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],     
		   [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [ExpenseReportId],[Description],[CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) VALUES  ([Id], [ExpenseReportId],[Description],[CreatedDateTime], [CreatedByUserId],[InActiveDateTime]);

MERGE INTO [dbo].[InvoiceType] AS Target
USING ( VALUES    
 (N'478452c8-024e-42d9-95b7-1c4d18934619', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Credit memo', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'ast due invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Interim invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Recurring invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Final invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pro forma invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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

MERGE INTO [dbo].[InvoiceCategory] AS Target
USING ( VALUES    
 (N'75c2c76b-9945-455b-87ee-013df61e8b89', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Progress Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Standard Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'83eba0af-e288-4024-abfe-27d681baa5c9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Commercial Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Recurring Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pending Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Timesheet', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source ([Id], [CompanyId], [InvoiceCategoryName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [CompanyId]      = source.[CompanyId],	   
		   [InvoiceCategoryName] = Source.[InvoiceCategoryName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [InvoiceCategoryName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [InvoiceCategoryName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceItem] AS Target
USING ( VALUES    
  (N'98182867-fd61-475c-89e0-0082652b94cf', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5fa1da48-3e56-418b-bc1c-00c0b83e796e', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'286b46bb-4a7e-40f6-a96e-03257838ced0', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'61548a6e-9ac3-45be-b77a-0455704a912d', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd4b5b3e9-f8a4-43a1-ab39-04c28d5aa4df', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eefe8510-eff2-4863-959e-060cfe49e0eb', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1657d40-41fe-40c1-a1d9-092d117e2c32', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'70e041dc-c0ab-49f9-80d2-0ba27d683c81', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'fdc1d5f2-aeb1-4c1a-af79-124d59404c28', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'14a8b3fd-e68e-48e1-946b-1497eb376410', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7f5fd838-4ef7-43fe-9a69-14dfef3048c0', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e747e37e-da5c-4c6c-8d64-1556e4e1b78e', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ce4243f6-6526-40b6-bea9-158caf1df138', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1c6befce-ab89-46b2-8f82-168f84e29797', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1fed110c-fb71-4432-962a-1d7e414c4215', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'04109a37-4c58-478d-965d-1e8e8bb83c4f', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3e65a52d-b7e0-42c1-a058-212c6b9553cc', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5de820cd-a2c0-4bdb-9eb0-22b36696296e', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'785ad474-3fe5-42d0-8ae1-230a14ff3f0d', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'67af22e5-c513-48ec-9962-23478004ed40', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'90109cea-0a36-4388-8e01-23c5dca7275a', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8693a678-9b2d-4f02-8214-2432876e2445', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd56d24bf-fe3a-424d-bf4b-25d3de6c9ef8', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'74195f26-bd82-4b23-a602-292edbe5a7f6', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'596de6fa-8a39-4bbd-bd2e-296dfa374bcc', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ab438f0f-97cb-4f56-8be1-2aa4130e7f67', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1fb5430a-7a4d-4f6a-ac1f-2ba0abaff7d2', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'95381142-f987-4419-babc-2c2bcdf8afb5', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2100935e-7667-4fd5-abfc-2d95bb2f3586', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd797bc51-173c-47aa-930e-2f7239c8e70a', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f24fd52b-4aac-4432-8494-317c70184d31', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3e7936ac-28f8-43e1-bf10-31bfd863a732', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9c2ef4e4-d15b-4054-9aed-32bcaf9cffec', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'81b91934-759f-4b4b-ba12-32e9f70ac232', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9c5ab9c1-0d12-4167-8e63-33f2878ff861', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'43a8e952-1814-4eca-890a-35aba994bdd6', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'49870005-fd76-496b-a2c7-369ff34f0bd7', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a7033979-f98d-4980-9817-37cb2954d2b3', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2363f6bb-f2b5-40bb-9b29-398c68a3a68d', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e3907699-878b-41b9-86fe-3a0d62958e03', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f268981c-54c9-403f-92a9-3adc2e265a3a', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3f6bc819-15db-4a3b-ad99-3b31cc6248ff', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2b66baf1-a2de-4831-a27f-3bb8322ddd1b', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7b2bdfc0-933b-4b0d-b666-3c104f6eb3de', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'79fea7d6-c726-4608-b59e-3c5b9562e99d', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd548ac5c-2fa6-486c-87ca-40c9426bc6b8', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b37b2b1a-f547-4fce-97a6-415a34883bf7', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9762868f-742f-4f43-b3ff-4307892d2a93', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3b097953-0eee-4075-ba3d-443ed8d85722', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7260652e-be6d-4e63-a850-44bd12f94e1c', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f12ab5ae-b67a-4231-a99d-45441d3d573b', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b9af9fd1-b8ab-47ad-877c-4690bf919ce9', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1e21be5d-eaab-4fc8-b344-46c3464321d0', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'84cc8e57-bc46-4df3-b4d9-46f00513a15c', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c455a0ec-d42f-44a0-a9c1-47305e524569', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'61b3f2d5-bea8-4b0b-8db0-47c18bf0cc7a', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ad086654-2841-4730-8a53-4815f2112af0', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'512a4a4c-ef8b-4271-bbfb-491cb0908f9c', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'54c47bf5-0d23-4068-80cd-49da2915ed5d', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5c1f192f-00ea-43db-a5e4-4c3901311237', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8482933e-b885-4be9-81eb-4d3a80bac426', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7754db8f-b8b9-4c74-9f70-4dffbbe93854', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f0495f7b-660c-463c-bd3b-4f2c77ad6265', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'95cf8038-a5cc-42ec-bc4c-4f5160463829', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4284433e-8f62-4ed9-95fc-4f77a5f776de', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'77d40325-d1bb-41f2-b568-501ac6c3ebd6', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8d6b3051-983e-420a-b1ee-503676eb381b', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'759b2a18-12f3-474c-affa-50dfa824d295', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd8fd9a23-f9c7-45af-a626-5236e364f44e', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8f592873-dede-44dc-9076-5529e19bf978', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a1ae7641-387a-4f46-90df-56e08a38c654', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a8ccec6a-7998-40de-9265-572d3a2115ff', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'47d62d90-6579-4003-ad94-5b92d30fec4d', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd881db2d-fdd3-4cab-9ee1-5c97c9037af9', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'74306456-a22b-420a-a3ee-5d20a307c710', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8184ded7-4d68-489e-9b08-5e338b8a5473', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'26387280-4b8f-4d32-aeff-5fb013e27172', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'82f5715c-9fd6-4590-bf77-615d0d25bbd1', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e91166b8-9247-4925-963f-664922f8c8f3', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'06fa33e0-515b-448e-81c1-66f1a9f5bfff', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'10b02796-60b8-4c70-b3ae-6875cc484b53', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dc8ceb85-75d9-4de1-a64b-689a0281d604', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8c2ec10b-cd71-4de9-8822-68e657e33da5', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0ddb45a1-6ba0-4c91-8631-6aa8e55fcd70', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'777b081d-b106-4e05-99d0-6b234356ab87', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'39242d72-b761-4040-9924-6bf2eb4968c0', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0b83aba3-b37f-47f5-9bf4-6c087dc92e9d', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cceb0c65-0810-4de0-9367-6c31e0542575', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1a27865-c9db-4c30-8525-6da8842321da', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c30c59ad-6465-4465-ae20-72190676dc03', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0f7265b5-aac4-43ee-9d5f-7577e9d6f428', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1566e9f4-8bbb-46cf-acaf-75f8c9c28602', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'81380e7e-f610-4c65-82fc-76447e269d00', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f2c04c95-75b7-4f75-b087-798b13af63a6', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7ae60129-02a7-4beb-b02b-7c94d8ada65c', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7ec3c9df-116c-4a83-b7c2-7e4d86d7d9ec', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd7ed2c3c-86a2-4c85-9fa8-7e7c611cc63f', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eacf4104-0f8d-4c30-898a-7e8a3e35ce9f', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'584e4d00-b98d-4b60-8ec5-84362c25f13d', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'87d788d5-1cb8-48e3-b20f-845f005cdbde', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7bfb87e8-cfb1-433a-90c4-8544cdcefd9f', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7167a6de-cdda-4b29-b2b3-886713d1b0b1', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'776b98f1-5590-4858-8356-888be762b76e', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e08f8217-32ab-4aad-bedf-8969fb7ae8b8', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'41a8ba69-f372-4523-a283-8a14c8f31a92', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd449bd27-f66c-4561-88c2-8b7687b1a83e', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a5959bc6-47be-4f0f-85e8-8c823d409ad7', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'da734b91-610b-48c6-9195-8e015b8deb2e', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'baff9e4e-f6e1-4a1a-bead-8e7e00d62123', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3c233cb9-17ed-4677-baaa-8f0f43aebb16', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'edfe31b3-72c5-4701-8f72-903cd39a3560', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'75ddcc11-8a14-4af4-82c4-90af1841a25f', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1d209f53-df60-474d-a017-90df9aadf970', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e53d8bec-c7d7-4678-8a97-92cd75cb3dbf', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a7d8fbae-7ec8-453c-9e0f-9604bd5edef0', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e752ca03-4ec9-4a63-ba2c-9663e6fc3f48', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cf164c07-c530-4ef0-886e-985fcc1e4b80', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a2bcc262-f3d9-4167-b71e-989c13f483f8', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e3631df3-994f-4894-ace6-9ba7844f8e0d', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'542d6a53-56e9-4dbd-993c-9cb911ad308d', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'88ea5b75-8e3b-407e-a09c-9cca6f3a20b4', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0db09882-7ef3-4341-88be-9f98e1f5e8cf', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'04aa0e98-84e5-4b85-8b6e-9fc7a1400316', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1b394521-bd8b-4eca-878d-a326b98d86b3', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3909ba1d-64df-458b-a15c-a4099cee85f8', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'27b22124-a2ca-4a37-afa6-a57badf1bff2', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd7aa192c-2c93-4ee5-b27b-a90c799bef51', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4d3be028-6cb5-45b1-a62a-a9e5079c2646', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8a26d4aa-6937-43bc-9c5e-aa72745c6121', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'907c267b-daf1-4971-8130-ad1945fd9fe6', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'bff0d963-09bb-41f0-b987-ad6ba144f0f4', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4a5c6126-dba0-4f0e-8968-af912648132c', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'24e2cab8-30c9-4d89-af84-b041ff10844d', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3ee6e890-eaee-4cfa-bb9b-b13834e36a4c', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f35faf51-ac0c-45d0-a602-b4c4e084b3c4', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e8553206-c2e4-4559-91eb-b5afb93e69fa', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f07162f4-381c-46e9-8965-b6052649192f', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'19261f99-13aa-4f82-92e9-b708a775fa61', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'76301fd4-2571-497a-8f38-b7d96f6683c2', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'67d9018a-db05-4f81-aaf1-b9d2b1e0d980', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2c3cd800-147b-4e04-8b53-bbcd4154a6c3', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'36ddf271-1170-4ecb-98be-bbfd99289d91', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'62aa5add-1a6a-40c1-b443-c11415d397e5', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'904d5830-c905-4fcf-af16-c143034504cd', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6252200d-8008-4053-b650-c1e71bffb32e', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a60b1bbc-27d7-47b0-b58f-c1e886227772', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eb19bd5c-06ce-4540-8537-c2046b29f742', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8cb74984-e5cb-4788-8dc7-c28767e9b0c8', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'906ef9d0-b651-46fa-bf4e-c2b60b18b3c1', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8118be4d-aa51-4684-886a-c2f1488b975b', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5a5b0bbd-b5d7-4868-a2f3-c59124b7eb15', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ce5416aa-1a3e-4cec-93ee-c5c8f7ffb2e9', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8cf12359-aee3-4a04-a4da-c6bcf2e0d22f', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'93583f43-f736-4781-aae6-c74bb6e351b5', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f0d5e3e8-5a09-4f10-93ee-c74d1970bae4', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eab89a3b-52aa-48f4-8294-c7fecab2f6bb', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'85d48bc1-155a-4640-b433-c80817b00328', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'98b93756-12d1-4832-a6e4-c83618a56d08', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3e410931-21f4-48d1-b322-c8a686278b82', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'80907f85-8a7a-4035-a0f5-c93f49389b9b', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'028e4c75-b1c4-46e8-9f60-c9daa159e01d', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0f822bf8-883a-4c56-9143-ca064362b536', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'178c3871-c080-4642-a8d0-cd28511c7518', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b57d6773-6236-4ef4-88e7-cd4818c3a480', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5dab71a7-d58f-46b7-a3fb-cf177c271156', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3db3f2d4-9995-4f12-8764-cf2394038f09', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'383bfc5c-a150-4031-a407-d0132f16ea72', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0e1ed4d4-cc0b-431e-81e8-d098a0741614', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2bc96846-d841-4d34-afda-d1032c1fd125', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'549dcacd-f913-415a-8567-d2110c238af7', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ed9e02a5-0197-4095-b903-d23e34197d9f', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f4797bea-57d3-48aa-b16c-d262eab4ec5c', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4aa2c7cc-14ba-4a72-95af-d38d4bdb40ef', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cc86c118-a89a-4dcd-8368-d4b338510c89', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4e1cb95b-fb63-4ee1-9195-d5382c5e14ba', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5c90bf06-e95a-446e-9c96-d548bff80816', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'63a58b82-83d7-4ab5-ba16-d5a4c4404d90', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8483cfa7-d21d-4eb2-8edb-d6fd38752b7d', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'81cce4ff-9827-4a3e-a3fb-d73294170705', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6a486c22-7521-45f9-9df7-d7cd5f67df66', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'23141416-e163-4290-ab14-d91f5bc5985a', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'662e5ed2-caa8-481e-a760-da903ee3c69d', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e00cddc6-71b1-4a15-bbed-dce455fe3447', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'fde20420-adab-4b05-993c-ddb620d8440e', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dee62a46-5412-4f15-a104-debfce22cd49', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4b0d94b1-8f17-4d59-8a75-e0238e19fcab', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'421b7c0c-fa36-46d8-bf6a-e031ffdbb727', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cde4d86b-91c2-4900-b90a-e04470c00fc4', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c070bdb0-3d54-461d-ac2c-e08266346dba', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'72344257-b9de-4954-828d-e154db5e95e4', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c3b3c613-1bc5-4b2b-8e25-e1893bdaf25d', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b0b9b809-b9c9-4db2-90c5-e40279e904c4', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a70993c7-54f8-4e2c-aa4e-e44b181b0757', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9e7f2724-a2c5-442d-88d1-e475c4ecb58c', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3b8d990a-5e3d-4906-b50e-e68b243ca922', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f985d674-d117-4b2c-8b9b-e6facac8c901', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4489e056-4c82-4b8d-8013-e7114a7b2293', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eebdae8f-e6b9-46a6-82ba-e71384f9a20e', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b217cb09-44be-4a8e-bcb3-e723fe3ce8dd', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eb02a27c-3c03-4fc7-ac39-e7fc107b186c', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'bba96cff-e0df-4afd-add0-ead6cba436b9', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9c4da309-10be-4c75-aac5-eb1cb08b7300', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b80e4987-a0df-46bd-9a80-ec03248dd3c1', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5e374449-3e62-4e90-8caa-ec28a088cc45', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1c57c3d-0fec-4c0d-ac13-ecf3d8ed3a64', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dbc7c832-860b-4cb9-85bc-ee2e4bd33fdf', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ed971607-26ac-415f-abb5-ee471bbc8ec3', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'85665861-25a3-48be-8e0b-efee48ce7ed9', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'27fe295b-f872-4eb2-8978-f465a791f4a7', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ccbf759c-2f44-4a86-9853-f8989a6c4412', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ff8cd3bf-5620-495b-9d10-fa1d2f84db47', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e0109c71-88b1-444c-9d76-fb2e53694193', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'324b1481-783e-4d71-a120-fc7e476f08da', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'52125ee2-a4fa-499b-b2a9-fe2bfc621010', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8b4a1cb5-a01e-4aeb-bb23-fe3b61b896a8', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5fb26701-1a21-457d-8ae9-ff7487f24576', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source ([Id], [InvoiceId], [DisplayName], [Description], [Price], [SKU], [Group], [ModeId], [InvoiceCategoryId], [Notes], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [InvoiceId]      = source.[InvoiceId],
		   [DisplayName]      = source.[DisplayName],	
		   [Description]      = source.[Description],	
		   [Price]      = source.[Price],	
		   [SKU]      = source.[SKU],	
		   [Group]      = source.[Group],	
		   [ModeId]      = source.[ModeId],	
		   [InvoiceCategoryId]      = source.[InvoiceCategoryId],		   
		   [Notes] = Source.[Notes],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [InvoiceId], [DisplayName], [Description], [Price], [SKU], [Group], [ModeId], [InvoiceCategoryId], [Notes], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [InvoiceId], [DisplayName], [Description], [Price], [SKU], [Group], [ModeId], [InvoiceCategoryId], [Notes], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[PaymentType] AS Target
USING ( VALUES    
 (N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'PayTm', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'66776be4-2371-4a64-bed5-dc4a720f7ce5', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'OnlineBanking', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'd8023bed-8683-4df6-a61c-e0be735661e9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'ATM', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source ([Id], [CompanyId], [PaymentTypeName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [CompanyId]      = source.[CompanyId],
		   [PaymentTypeName]      = source.[PaymentTypeName],	
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [PaymentTypeName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [PaymentTypeName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Payment] AS Target
USING ( VALUES    
  (N'63e72da6-e5a7-4d27-a4d1-0552940a5a88', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3547c1fa-dede-40f7-a9ed-160d1e45a9af', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'694896d7-a92f-4be1-8d4e-22c390b4a1b9', N'0e888feb-a433-457e-91c6-db08c58ec150', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f7fd8bf7-1754-462e-83f4-40037ef42bcd', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'94719bc9-5fc0-4df0-9597-4976fd7b8d0d', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'86443703-cd56-4b70-8779-4a8756302907', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f5fa216c-c43b-402f-bd1f-4b2f36b658dd', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5130ddac-203a-415b-b5c0-55492bd87919', N'936318da-8b44-4569-99cc-fada0f1cea00', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'563c38c7-9c38-4ac1-9ab0-58dff5118a43', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ce27048e-dcad-400c-9d0f-58ee001a24a5', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c5736f32-86ee-45cb-b2f1-5eb48ad6ea7c', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3de9f668-6ee9-4bca-b293-671b1d73ac72', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5634191e-5240-46f7-a54e-6d0039dca227', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'649d6c5d-f24c-4a98-9ec1-6f38d08b645f', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c43d3b2a-c32a-4c56-9bb4-7141e84f8873', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'893268b6-7836-4f52-8bbb-745f81d05145', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'716b81d5-a04f-4e78-8ecd-8f50bd0e14bf', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'13f98624-31c1-4774-85e8-9412fcb5454b', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6f0ad3a2-571c-4792-912f-ad8aade4c7cf', N'01a8f69d-4baf-4239-9389-2400534d40af', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a0ac9641-319a-4b83-b32c-b1876b210824', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b44781d4-c105-4ead-8638-b238da021757', N'26668536-e9ef-408f-a000-2a20c39200af', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e8cf308f-c379-4578-889f-b28fce67306f', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ad2fb6aa-bb64-4bd8-8e77-b64057a9a07c', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'37ab1cd0-2490-4978-b79a-bb97045ac0ca', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ca5d33df-c5de-4f4a-ba57-bf30d1d59b4f', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'deaf3216-8422-40f8-984c-d7d9076a8353', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'016d50e7-6b39-4df8-8fd5-e4d5398625be', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'95817e42-37a5-435f-8925-e51d355f3fed', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6cd62a35-e6c4-4ddc-b947-e8ee914c30c1', N'1e2b435c-0f88-460f-8163-72db669cc976', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'383ff7c9-a090-4aa8-becf-f153c9158500', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c284a63d-8afa-4d71-b7d1-f42457a69571', N'676c1785-d872-4e92-8b2f-c043645bb324', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8b43356d-74f8-4d2d-b9d3-f4d25d9a405b', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'193f724e-2010-472b-98b5-f5b1b1315faa', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'30c4083f-dc6a-4352-b29c-f9a1966c554a', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cc6adb25-f7ab-4996-b00a-fb44cdff3e74', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'122d9f87-ed83-437b-a5c9-fe5d97b139a0', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source  ([Id], [InvoiceId], [PaymentTypeId], [Date], [Amount], [Notes], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [InvoiceId]      = source.[InvoiceId],
		   [PaymentTypeId]      = source.[PaymentTypeId],
		    [Date]      = source.[Date],
		    [Amount]      = source.[Amount],
		    [Notes]      = source.[Notes],	
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [InvoiceId], [PaymentTypeId], [Date], [Amount], [Notes], [CreatedDateTime], [CreatedByUserId]) VALUES   ([Id], [InvoiceId], [PaymentTypeId], [Date], [Amount], [Notes], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceTask] AS Target
USING ( VALUES   
  (N'44fe6a0c-3d46-4f38-9d98-05783f71e153', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ddd3c583-f233-4a63-a996-06c17d845e89', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2d1ea379-1171-494a-a4c1-0c67de211e85', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6524fc06-9109-4891-84a8-0f7e07107e81', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a6e64874-c024-4050-98df-0f8ea60b9202', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'30e9c96a-28b2-4359-94b9-13fdd8bc2349', N'26668536-e9ef-408f-a000-2a20c39200af', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'af2fcdc3-8580-464a-955f-1561f97c7fe5', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b6ceb5d3-f5f4-4cd7-993e-15b3ad52cca4', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6205ae3d-9ed0-4efe-8056-18dfb5b69c4e', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'059a2653-4df6-4c89-8013-1dc482332277', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f3915cd6-5d95-4bd0-b70b-1ec902268535', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c82d0f11-4a7d-48f4-8d73-237a7147c09d', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dbc2bfb7-604f-46dd-9fdd-24a77eee46af', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dc37963d-c2a6-4c52-b7eb-263d79547294', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ba4fea09-2fc8-4361-a7c0-2653f0e8409c', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'301752a6-ba2f-4e0c-b467-2a43b37b92a1', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f0ba74fa-3df0-4457-97a5-2f3310ce56f3', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'acf09085-54c2-4de4-ba73-466570b90f40', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5b7a4143-5b3b-492f-bb0a-4897ece6599d', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'58644965-5dc2-4b6e-970d-48b1be5f8e98', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6044d181-fe3a-411c-af3e-4e1eff8a6d74', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'134476bb-c0f5-4d0e-a7de-4e90028c5490', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8cb51c53-7ae3-469e-a593-4efab32b21b8', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd1427ed9-3b9d-4cb8-ad32-4efffc5d72e9', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'07c64347-735e-45d3-87e7-55de4674368d', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7add047c-a0e2-492e-addc-580ae160f36a', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7b257a16-cbc7-4954-8685-5a6c6ee18d20', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2bb51e96-87ef-4eb9-a341-60b9ab43e0b1', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4e9d0bd0-f74e-4647-a433-62d23e2af799', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'35865ad4-2eba-409c-bcb3-6388f1d92209', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c37ee45e-ef8d-48ec-b24e-6667a8d952dc', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b962f1b7-59ca-41a4-a71d-6754cae8782c', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1d69bb1-5580-4c87-8e2d-67c112eade6a', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'458216c1-3ed6-4b43-afd3-6aba79893c37', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1555858a-1105-4bd2-9865-6c3321b8d7a6', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2a4d3878-414f-45ba-a046-6dd5dcd9b92f', N'26668536-e9ef-408f-a000-2a20c39200af', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0740e0a0-0042-4c55-b004-716dfd302b03', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b2d73113-6e02-47f1-80a4-71e2ce1bcbf0', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c1023512-0d0c-434d-ad83-78dda5979ebe', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2d791d3b-1441-4c8e-a147-7e5e4e1be096', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f250196d-7d8b-4cf4-95a2-8399f449b26c', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b8578596-8fa5-4297-9760-84d64e43333f', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b5328e9a-3c93-44fd-a5b3-84f370e4ac62', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a15fe6e2-33eb-400b-b386-86072ab7b10a', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'04ebcf24-e417-44c8-834f-87fdac0ba2bd', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9411d0f3-2e62-4a94-a7fe-8a9dd1f94ec7', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1d362bb9-baf7-4812-a645-8c2c068fa152', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9320bcfd-dc02-46d2-93ea-8e5df55139b8', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c90aef45-8bff-4bf4-8bd3-95fa8042d94d', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1d30d4af-2131-4672-ad05-974f59ab21a2', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0e73a209-f225-4659-bb83-98f425401167', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2d7a782e-df3a-436c-bc27-99749d1bc751', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8d3083fa-7e4a-4c0c-ae95-a4b2f65bb797', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'52eb6f7f-53aa-429b-b24f-a71436b0f7cc', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0ee49e53-2851-4de1-ace6-a92fcd11c010', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd0de012f-5bf6-42c9-8c3c-b077150dbb5a', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'87729242-70e2-4cd1-a617-b61c3e2a44e0', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0496c88a-e0a3-4429-ade8-b99a4a12d48d', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cbbb36e2-0ed2-4090-86de-bf6415ca00e3', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'74aeb439-d5b5-4c83-a93a-c3d5d558604e', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd76d1026-9288-4ad5-942c-c46709f376a7', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'50c8f238-3bd6-4e05-a5ef-c7058253d84d', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'459fc0b8-ffe0-4528-9164-c990776b5be5', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1fef87bb-c5d7-4f25-adeb-cbecd423d74c', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0f7d0874-cb68-4fc5-a085-ccfe92b69ccb', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd94bcc2d-f365-4405-9617-ce14e88d4aab', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8feb42cc-a7d6-4aac-b7a9-d39e4cb125b9', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'56d8e99e-5bbf-4fad-9b7d-d9052568ce41', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'34e548ae-ecf2-45ba-bcec-e6de325870aa', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7e687dfe-fe0e-44e2-8223-f106ee5fa02d', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7c8f73b0-e98c-4de5-860b-f608caf979f5', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c0d808f5-1153-4a7c-bb1d-fe96069f9c78', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')

)
AS Source  ([Id], [InvoiceId], [Task], [Rate], [Hours], [Item], [Price], [Quantity], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [InvoiceId]      = source.[InvoiceId],
		   [Task]      = source.[Task],
		   [Rate]      = source.[Rate],

		   [Hours]      = source.[Hours],
		   [Item]      = source.[Item],
		   [Price]      = source.[Price],
		   [Quantity]      = source.[Quantity],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [InvoiceId], [Task], [Rate], [Hours], [Item], [Price], [Quantity], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [InvoiceId], [Task], [Rate], [Hours], [Item], [Price], [Quantity], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseCategory] AS Target
USING ( VALUES    
	    (N'0E050BE7-FD1D-4E61-B0A3-776BECF4CB8E',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'IT and Internet Expences',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'D4D4C82A-164E-49BA-9D73-2E4B2605456C',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Auto mobile expences',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'CA68F1CD-0C73-4021-9C56-00D0D28EA7AB',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Office Supplies',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'2A9ABB65-BF32-4025-8A3B-C8A6CF0C7A5D',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Other Expenses',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [CompanyId], [CategoryName],[Image],[AccountCode],[Description], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [CategoryName] = source.[CategoryName],	  
		   [Image] = Source.[Image],
		   [AccountCode] = Source.[AccountCode],
		   [Description] = Source.[Description],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [CategoryName],[Image],[AccountCode],[Description], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [CategoryName],[Image],[AccountCode],[Description], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseReportStatus] AS Target
USING ( VALUES    
	    (N'7F9971D0-8226-4870-95FA-BEA7D59125F5',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Achived',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'3DAA3CEE-B073-4D3E-A942-CBB654BD729F',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Submitted',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'3D484B8A-9EB5-4A08-A42D-A6E1870D6257',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Approved',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'20192D11-57DF-40A3-81D6-B524A2E5C123',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Rejected',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'FC20D699-6B97-4764-8643-033F463F2D40',  N'4AFEB444-E826-4F95-AC41-2175E36A0C16',N'Reimbursed',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [CompanyId], [Name],[Description] ,[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [Name]      = source.[Name],	 
		   [Description]      = source.[Description],	 	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [Name], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [Name], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Merchant] AS Target
USING ( VALUES    
	    (N'1c90bbeb-d85d-4bfb-97f5-48626f6ceb27', N'maira',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'5e22e01a-bf81-46c5-8a64-600600e0313d', N'james',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'db9458b5-d28b-4dd5-a059-69eea129df6e', N'david',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'e7499fa4-ebf5-4f82-bed1-6e23e42ac13f', N'Ani',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'e38b057f-aa4e-4e63-b10a-74aa252aa004', N'AJAY',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f', N'mickel',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'0019af86-8618-4f46-9dfa-a41d9e98275f', N'vinay',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'b3a4e6fa-9f71-441d-bbb6-ad1155243d64', N'viliams',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'000d7682-e46d-48c6-b7d8-b6509fabb3c0', N'robert',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'52789cf1-dae3-4fc8-88ad-e874fe1d6b34', N'jairam',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [MerchantName],[Description] ,[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
		   [MerchantName]      = source.[MerchantName],	 
		   [Description]      = source.[Description],	 	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id],  [MerchantName],[Description], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id],  [MerchantName],[Description], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseReport] AS Target
USING ( VALUES    
	    (N'EAA6DF86-F929-468D-99CA-F69144F27FF7',  N'Test',N'Software ',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'7F9971D0-8226-4870-95FA-BEA7D59125F5',10000,5000, 0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'62585EEA-93CB-46EA-9891-6C8136775F74',  N'test1',N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'3DAA3CEE-B073-4D3E-A942-CBB654BD729F',10000,10000,0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'1B037D8C-FCA6-4F65-A54E-390BFD33C545',  N'Test3', N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'3D484B8A-9EB5-4A08-A42D-A6E1870D6257',10000,20000,0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'5B0D2D36-6C73-4EF4-98A7-50C15DB4B9AA',  N'Test2',N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'3DAA3CEE-B073-4D3E-A942-CBB654BD729F',10000,50000,0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'154ECB11-6E06-4DA4-BCF7-D48DA07A95BF',  N'test4',N'Software ',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'FC20D699-6B97-4764-8643-033F463F2D40',10000,0,    0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',  N'test5',N'Software',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),N'3DAA3CEE-B073-4D3E-A942-CBB654BD729F',10000,0,    0,0,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [ReportTitle], [BusinessPurpose],[DurationFrom],[DurationTo],[ReportStatusId],[AdvancePayment],[AmountToBeReimbursed],[IsReimbursed],[UndoReimbursement],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [ReportTitle] = Source.[ReportTitle],
		   [BusinessPurpose]      = source.[BusinessPurpose],	   
		    [DurationFrom]      = source.[DurationFrom],
			[DurationTo]      = source.[DurationTo],
			[ReportStatusId]      = source.[ReportStatusId],
			[AdvancePayment]      = source.[AdvancePayment],
			[AmountToBeReimbursed]      = source.[AmountToBeReimbursed],
			[IsReimbursed]      = source.[IsReimbursed],
			[UndoReimbursement]      = source.[UndoReimbursement],	 
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [ReportTitle], [BusinessPurpose],[DurationFrom],[DurationTo],[ReportStatusId],[AdvancePayment],[AmountToBeReimbursed],[IsReimbursed],[UndoReimbursement],[CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [ReportTitle], [BusinessPurpose],[DurationFrom],[DurationTo],[ReportStatusId],[AdvancePayment],[AmountToBeReimbursed],[IsReimbursed],[UndoReimbursement],[CreatedDateTime], [CreatedByUserId]);

--MERGE INTO [dbo].[Expense] AS Target
--USING ( VALUES    
--	    (N'A6DEB011-745E-42C0-AE71-A93B45DCCC79', N'Software',N'D4D4C82A-164E-49BA-9D73-2E4B2605456C',N'154FC7EF-0ABC-435D-9A2E-51CB18DE964F',N'127133F1-4427-4149-9DD6-B02E0E036971',NULL,N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',NULL,0,N'9F806E2F-B41A-4354-B0FB-485F7E115787',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'D1BE307A-6B02-4AB8-96A0-8F48E863E60C' ,N'Software',N'0E050BE7-FD1D-4E61-B0A3-776BECF4CB8E',N'154FC7EF-0ABC-435D-9A2E-51CB18DE964F',N'127133F1-4427-4149-9DD6-B02E0E036971',NULL,N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',NULL,0,N'9F806E2F-B41A-4354-B0FB-485F7E115787',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'4193D145-DCAF-47FC-B633-9BC5D8B1E114', N'Software',N'CA68F1CD-0C73-4021-9C56-00D0D28EA7AB',N'154FC7EF-0ABC-435D-9A2E-51CB18DE964F',N'127133F1-4427-4149-9DD6-B02E0E036971',NULL,N'5B0D2D36-6C73-4EF4-98A7-50C15DB4B9AA',N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',NULL,0,N'9F806E2F-B41A-4354-B0FB-485F7E115787',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'CF237784-F87B-4FF8-8479-B2CBF81EC28D' ,N'Software',N'0E050BE7-FD1D-4E61-B0A3-776BECF4CB8E',N'154FC7EF-0ABC-435D-9A2E-51CB18DE964F',N'127133F1-4427-4149-9DD6-B02E0E036971',NULL,N'62585EEA-93CB-46EA-9891-6C8136775F74',N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',NULL,0,N'9F806E2F-B41A-4354-B0FB-485F7E115787',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'AE965C00-2B86-4FE7-B9B3-BE80A3E44049' ,N'Software',N'2A9ABB65-BF32-4025-8A3B-C8A6CF0C7A5D',N'154FC7EF-0ABC-435D-9A2E-51CB18DE964F',N'127133F1-4427-4149-9DD6-B02E0E036971',NULL,N'5B0D2D36-6C73-4EF4-98A7-50C15DB4B9AA',N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',NULL,0,N'9F806E2F-B41A-4354-B0FB-485F7E115787',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'6A35EB12-C866-4D65-8B70-189DFDEC6DF8' ,N'Software',N'0E050BE7-FD1D-4E61-B0A3-776BECF4CB8E',N'154FC7EF-0ABC-435D-9A2E-51CB18DE964F',N'127133F1-4427-4149-9DD6-B02E0E036971',NULL,N'154ECB11-6E06-4DA4-BCF7-D48DA07A95BF',N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF',NULL,0,N'9F806E2F-B41A-4354-B0FB-485F7E115787',CAST(N'2019-03-04T00:00:00.000' AS DateTime),CAST(N'2020-03-04T00:00:00.000' AS DateTime),10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
--		)
--AS Source ([Id], [Description], [ExpenseCategoryId],[PaymentStatusId],[ClaimedByUserId],[CashPaidThroughId],[ExpenseReportId],[ExpenseStatusId],[BillReceiptId],[ClaimReimbursement],[MerchantId],[ReceiptDate],[ExpenseDate],[Amount],[CreatedDateTime], [CreatedByUserId])
--ON Target.Id = Source.Id
--WHEN MATCHED THEN
--UPDATE SET 
--           [Description] = Source.[Description],
--		   [ExpenseCategoryId]      = source.[ExpenseCategoryId],	   
--		    [PaymentStatusId]      = source.[PaymentStatusId],
--			[ClaimedByUserId]      = source.[ClaimedByUserId],
--			[CashPaidThroughId]      = source.[CashPaidThroughId],
--			[ExpenseReportId]      = source.[ExpenseReportId],
--			[ExpenseStatusId]      = source.[ExpenseStatusId],
--			[MerchantId]      = source.[MerchantId],
--			[BillReceiptId]      = source.[BillReceiptId],
--			[ClaimReimbursement] = Source.[ClaimReimbursement],
--			[ReceiptDate] = Source.[ReceiptDate],
--			[Amount] = Source.[Amount],
--           [CreatedDateTime] = Source.[CreatedDateTime],
--           [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN
--INSERT([Id], [Description], [ExpenseCategoryId],[PaymentStatusId],[ClaimedByUserId],[CashPaidThroughId],[ExpenseReportId],[ExpenseStatusId],[BillReceiptId],[ClaimReimbursement],[MerchantId],[ReceiptDate],[ExpenseDate],[Amount],[CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [Description], [ExpenseCategoryId],[PaymentStatusId],[ClaimedByUserId],[CashPaidThroughId],[ExpenseReportId],[ExpenseStatusId],[BillReceiptId],[ClaimReimbursement],[MerchantId],[ReceiptDate],[ExpenseDate],[Amount],[CreatedDateTime], [CreatedByUserId]);

--MERGE INTO [dbo].[ExpenseSplit] AS Target
--USING ( VALUES    
--	    (N'B776380B-6F26-4A3B-813F-690E24AE0566', N'6A35EB12-C866-4D65-8B70-189DFDEC6DF8',N'0E050BE7-FD1D-4E61-B0A3-776BECF4CB8E',N'',10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'03FB97B2-469C-4994-94D2-C2FE1ECBEE9D' ,N'D1BE307A-6B02-4AB8-96A0-8F48E863E60C',N'0E050BE7-FD1D-4E61-B0A3-776BECF4CB8E',N'',10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'8D06AA6D-F698-4DB3-BE60-A39E6E91FC0F', N'CF237784-F87B-4FF8-8479-B2CBF81EC28D',N'0E050BE7-FD1D-4E61-B0A3-776BECF4CB8E',N'',10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'EAB7DA84-26FE-45FA-AD20-5520E199E3FD' ,N'AE965C00-2B86-4FE7-B9B3-BE80A3E44049',N'2A9ABB65-BF32-4025-8A3B-C8A6CF0C7A5D',N'',10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'37130141-B76E-4C41-A395-BD8CF8F50F45' ,N'A6DEB011-745E-42C0-AE71-A93B45DCCC79',N'D4D4C82A-164E-49BA-9D73-2E4B2605456C',N'',10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'FC5C4BE6-3F5C-4B2E-A743-30B247243AF2' ,N'4193D145-DCAF-47FC-B633-9BC5D8B1E114',N'CA68F1CD-0C73-4021-9C56-00D0D28EA7AB',N'',10000,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
--		)
--AS Source ([Id], [ExpenseId], [ExpenseCategoryId],[Amount],[Description],[CreatedDateTime], [CreatedByUserId])
--ON Target.Id = Source.Id
--WHEN MATCHED THEN
--UPDATE SET 
--           [ExpenseId] = Source.[ExpenseId],
--		   [ExpenseCategoryId]      = source.[ExpenseCategoryId],	   

--			[Description] = Source.[Description],
--			[Amount] = Source.[Amount],
--           [CreatedDateTime] = Source.[CreatedDateTime],
--           [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN
--INSERT([Id], [ExpenseId], [ExpenseCategoryId],[Amount],[Description],[CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [ExpenseId], [ExpenseCategoryId],[Amount],[Description],[CreatedDateTime], [CreatedByUserId]);

--MERGE INTO [dbo].[ExpensePaidUser] AS Target
--USING ( VALUES    
--	    (N'236B93EC-72E9-4206-A243-98FAA94F0CBE', N'6A35EB12-C866-4D65-8B70-189DFDEC6DF8',N'CC79CA1F-4EC5-47C3-AE22-1AAF57B6FE4B',N'60000',112456785,NULL,CAST(N'2019-03-29T00:00:00.000' AS DateTime),N'Siva',N'Ongole',N'IFSC1111023456',707, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'65863AAF-93EA-4BA5-B96F-803595BF27EC' ,N'D1BE307A-6B02-4AB8-96A0-8F48E863E60C',N'CC79CA1F-4EC5-47C3-AE22-1AAF57B6FE4B',N'10000',112456785,NULL,CAST(N'2019-03-29T00:00:00.000' AS DateTime),N'Siva',N'Ongole',N'IFSC1111023456',707, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'D30A4D94-B27F-41E3-A090-69689F207CD1', N'4193D145-DCAF-47FC-B633-9BC5D8B1E114',N'CC79CA1F-4EC5-47C3-AE22-1AAF57B6FE4B',N'20000',112456785,NULL,CAST(N'2019-03-29T00:00:00.000' AS DateTime),N'Siva',N'Ongole',N'IFSC1111023456',707, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'AD0E1287-41C5-43AA-8758-9B4C762B0D06' ,N'A6DEB011-745E-42C0-AE71-A93B45DCCC79',N'CC79CA1F-4EC5-47C3-AE22-1AAF57B6FE4B',N'10000',112456785,NULL,CAST(N'2019-03-29T00:00:00.000' AS DateTime),N'Siva',N'Ongole',N'IFSC1111023456',707, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'255A0ADE-2A89-423C-B03D-7D713593D277' ,N'CF237784-F87B-4FF8-8479-B2CBF81EC28D',N'CC79CA1F-4EC5-47C3-AE22-1AAF57B6FE4B',N'50000',112456785,NULL,CAST(N'2019-03-29T00:00:00.000' AS DateTime),N'Siva',N'Ongole',N'IFSC1111023456',707, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'FD42D41F-E91C-4F24-B633-8783216BA5F0' ,N'AE965C00-2B86-4FE7-B9B3-BE80A3E44049',N'CC79CA1F-4EC5-47C3-AE22-1AAF57B6FE4B',N'70000',112456785,NULL,CAST(N'2019-03-29T00:00:00.000' AS DateTime),N'Siva',N'Ongole',N'IFSC1111023456',707, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
--		)
--AS Source ([Id], [ExpenseId],[PaidByUserId],[PaidAmount],[AccountNumber],[PaymentReference],[PaymentDate],[AccountHolderName],[Branch],[IFSC],[SOSCode],[CreatedDateTime], [CreatedByUserId])
--ON Target.Id = Source.Id
--WHEN MATCHED THEN
--UPDATE SET 

--		   [ExpenseId]      = source.[ExpenseId],	
--		   [PaidByUserId]      = source.[PaidByUserId],	
--		    [PaidAmount]      = source.[PaidAmount],	
--		   [AccountNumber] = Source.[AccountNumber],
--		   [PaymentReference] = Source.[PaymentReference],
--		   [PaymentDate] = Source.[PaymentDate],
--		   [AccountHolderName] = Source.[AccountHolderName],
--		   [Branch] = Source.[Branch],
--		   [IFSC] = Source.[IFSC],
--		   [SOSCode] = Source.[SOSCode],
--           [CreatedDateTime] = Source.[CreatedDateTime],
--           [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN
--INSERT([Id], [ExpenseId],[PaidByUserId],[PaidAmount],[AccountNumber],[PaymentReference],[PaymentDate],[AccountHolderName],[Branch],[IFSC],[SOSCode],[CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [ExpenseId],[PaidByUserId],[PaidAmount],[AccountNumber],[PaymentReference],[PaymentDate],[AccountHolderName],[Branch],[IFSC],[SOSCode],[CreatedDateTime], [CreatedByUserId]);

--MERGE INTO [dbo].[BillReceipt] AS Target
--USING ( VALUES    
--	    (N'AF8AE8CC-D6A8-4F00-A28F-4E1DFDA80149', N'Bakerys',N'Pictures',N'6A35EB12-C866-4D65-8B70-189DFDEC6DF8',N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCFB', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'051BDBD6-766F-4BE6-B13F-C1F53B286959' ,N'Maintenamnce',N'Pictures',N'D1BE307A-6B02-4AB8-96A0-8F48E863E60C',N'1B037D8C-FCA6-4F65-A54E-390BFD33C545',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'212C998C-7FB8-4585-84A7-91EBEF196F48', N'Elecronics',N'Pictures',N'4193D145-DCAF-47FC-B633-9BC5D8B1E114',N'5B0D2D36-6C73-4EF4-98A7-50C15DB4B9AA',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'ACF70190-9CF5-4D0C-8E7F-928C0C07AB3D' ,N'Pints',N'Pictures',N'A6DEB011-745E-42C0-AE71-A93B45DCCC79',N'62585EEA-93CB-46EA-9891-6C8136775F74',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'74591B14-FACC-4144-A1E8-EF22E2F7E7D3' ,N'Offencess',N'Pictures',N'CF237784-F87B-4FF8-8479-B2CBF81EC28D',N'154ECB11-6E06-4DA4-BCF7-D48DA07A95BF',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'5F936903-2BFA-4251-AF9E-72A903FC9DC3' ,N'Hotels',N'Pictures',N'AE965C00-2B86-4FE7-B9B3-BE80A3E44049',N'EAA6DF86-F929-468D-99CA-F69144F27FF7',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
--		)
--AS Source ([Id],[ReceiptImagePath],[ReceiptName], [ExpenseId],[ExpenseReportId],[CreatedDateTime], [CreatedByUserId])
--ON Target.Id = Source.Id
--WHEN MATCHED THEN
--UPDATE SET 

--		   [ReceiptImagePath]      = source.[ReceiptImagePath],	
--		   [ReceiptName]      = source.[ReceiptName],	
--		   [ExpenseId]      = source.[ExpenseId],	
--		   [ExpenseReportId]      = source.[ExpenseReportId],	
--           [CreatedDateTime] = Source.[CreatedDateTime],
--           [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN
--INSERT([Id],[ReceiptImagePath],[ReceiptName], [ExpenseId],[ExpenseReportId],[CreatedDateTime], [CreatedByUserId]) VALUES  ([Id],[ReceiptImagePath],[ReceiptName], [ExpenseId],[ExpenseReportId],[CreatedDateTime], [CreatedByUserId]);

--MERGE INTO [dbo].[Customer] AS Target
--USING ( VALUES    
--	    (N'17947499-E01B-41C9-BE25-4E97ACA20B2A',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'Divya', N'd@gmail.com ',N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'0DA65173-9015-4AF9-8C0F-683E939BA063',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'Geetha',N'g@gmail.com', N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'750A9903-E772-474A-A421-B036D8ABF731',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'sudha',N's@gmail.com' ,N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971' ),
--		(N'B3EC1FAE-E9CE-468B-9C05-86337B144083',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'harika',N'h@gmail.com', N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'23C5C6E7-1DF4-4675-9D05-A8AEF2FE3E70',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'teja',N'T@gmail.com ',N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
--		(N'DAABC1CF-7B86-40EB-9E32-B7AF2CB93312',N'4AFEB444-E826-4F95-AC41-2175E36A0C16',  N'Mahesh',N'm@gmail.com', N'Ongole',NULL,N'AP',N'28221d82-8890-4f11-9bea-535a269f9a8b',N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb',515001,123456,NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
--		)
--AS Source ([Id], [CompanyId], [CustomerName],[ContactEmail],[AddressLine1],[AddressLine2],[City],[StateId],[CountryId],[PostalCode],[MobileNumber],[Notes],[CreatedDateTime], [CreatedByUserId])
--ON Target.Id = Source.Id
--WHEN MATCHED THEN
--UPDATE SET 
--           [CompanyId] = Source.[CompanyId],
--		   [CustomerName]      = source.[CustomerName],	   
--		    [ContactEmail]      = source.[ContactEmail],
--			[AddressLine1]      = source.[AddressLine1],
--			[AddressLine2]      = source.[AddressLine2],
--			[City]      = source.[City],
--			[StateId]      = source.[StateId],
--			[CountryId]      = source.[CountryId],
--			[PostalCode]      = source.[PostalCode],
--			[MobileNumber]      = source.[MobileNumber],
--			[Notes]      = source.[Notes],	 
--           [CreatedDateTime] = Source.[CreatedDateTime],
--           [CreatedByUserId] = Source.[CreatedByUserId]

--WHEN NOT MATCHED BY TARGET THEN
--INSERT([Id], [CompanyId], [CustomerName],[ContactEmail],[AddressLine1],[AddressLine2],[City],[StateId],[CountryId],[PostalCode],[MobileNumber],[Notes],[CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [CustomerName],[ContactEmail],[AddressLine1],[AddressLine2],[City],[StateId],[CountryId],[PostalCode],[MobileNumber],[Notes],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Invoice] AS Target
USING ( VALUES    
  (N'd328e49f-6211-45e7-b225-0a3e1648324d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'aa093867-45fa-4797-88a7-1f0b953965e9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'01a8f69d-4baf-4239-9389-2400534d40af', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'26668536-e9ef-408f-a000-2a20c39200af', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1e2b435c-0f88-460f-8163-72db669cc976', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'12f1d580-69c2-42b6-9a98-7bed48601527', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'525a9b87-a559-45c9-b6c7-b569da70077d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'17947499-e01b-41c9-be25-4e97aca20b2a', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'676c1785-d872-4e92-8b2f-c043645bb324', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'47577c50-7b51-4522-82e7-c9935e18b3de', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'23c5c6e7-1df4-4675-9d05-a8aef2fe3e70', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0e888feb-a433-457e-91c6-db08c58ec150', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'478452c8-024e-42d9-95b7-1c4d18934619', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'06e846f9-de32-46af-930a-f039d54fa8f7', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'750a9903-e772-474a-a421-b036d8abf731', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'588222af-14c9-4acc-87c0-fa99a3c06285', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'0da65173-9015-4af9-8c0f-683e939ba063', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'936318da-8b44-4569-99cc-fada0f1cea00', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'b3ec1fae-e9ce-468b-9c05-86337b144083', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pictures', N'daabc1cf-7b86-40eb-9e32-b7af2cb93312', N'068eeaea-b54f-47e3-9064-5d2ae28badff', N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'123', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(N'2019-04-04T00:00:00.000' AS DateTime), CAST(1000.00000 AS Numeric(10, 5)), NULL, NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source ([Id], [CompanyId], [CompnayLogo], [BillToCustomerId], [ProjectId], [InvoiceTypeId], [InvoiceNumber], [Date], [DueDate], [Discount], [Notes], [Terms], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 
           [CompanyId] = Source.[CompanyId],
		   [CompnayLogo]      = source.[CompnayLogo],	   
		    [BillToCustomerId]      = source.[BillToCustomerId],
			[ProjectId]      = source.[ProjectId],
			[InvoiceTypeId]      = source.[InvoiceTypeId],
			[InvoiceNumber]      = source.[InvoiceNumber],
			[Date]      = source.[Date],
			[DueDate]      = source.[DueDate],
			[Discount]      = source.[Discount],
			[Notes]      = source.[Notes],
			[Terms]      = source.[Terms],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
		      	   
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [CompnayLogo], [BillToCustomerId], [ProjectId], [InvoiceTypeId], [InvoiceNumber], [Date], [DueDate], [Discount], [Notes], [Terms], [CreatedDateTime], [CreatedByUserId])VALUES ([Id], [CompanyId], [CompnayLogo], [BillToCustomerId], [ProjectId], [InvoiceTypeId], [InvoiceNumber], [Date], [DueDate], [Discount], [Notes], [Terms], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseComment] AS Target
USING ( VALUES    
	    (N'E8EEA80C-9C25-4787-BC76-C8DCAD20D36A', N'6A35EB12-C866-4D65-8B70-189DFDEC6DF8',N'Completed', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'1A79AB09-0554-4023-883D-DABE9435C6A9' ,N'D1BE307A-6B02-4AB8-96A0-8F48E863E60C',N'Returned', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'5BAF1524-A297-4C89-8DFA-FD883D6E7D77', N'4193D145-DCAF-47FC-B633-9BC5D8B1E114',N'Paid', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'AA5A1060-9772-43CA-A914-043F9B79F48F' ,N'A6DEB011-745E-42C0-AE71-A93B45DCCC79',N'paid', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'EEB6B5A0-F8AC-44DB-B986-9E98C5AAF876' ,N'CF237784-F87B-4FF8-8479-B2CBF81EC28D',N'paid', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'B9569466-7DD5-41C8-B3DE-0DAFD0417151' ,N'AE965C00-2B86-4FE7-B9B3-BE80A3E44049',N'paid', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [ExpenseId],[Comment],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [ExpenseId]      = source.[ExpenseId],	   
		   [Comment] = Source.[Comment],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [ExpenseId],[Comment],[CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [ExpenseId],[Comment],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[ExpenseReportHistory] AS Target
USING ( VALUES    
	    (N'49C11968-48DB-414C-82DB-D04A20094152', N'C3A75B3B-F3E8-4E2C-8E6B-05DE1D059FCF', N'#ssms',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'DBFD0595-9987-4A9D-9F91-A31C86F7ECBA' ,N'1B037D8C-FCA6-4F65-A54E-390BFD33C545', N'whole office related',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'4FC0BA5A-7C30-471B-ABE4-C8DF22AC23FB', N'5B0D2D36-6C73-4EF4-98A7-50C15DB4B9AA', N'repaired',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'0A73FE87-623A-4C11-84F5-D9DAD626791D' ,N'62585EEA-93CB-46EA-9891-6C8136775F74', N'Newly',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'22BFEFF4-EACC-4545-B0D3-48A39244881B' ,N'154ECB11-6E06-4DA4-BCF7-D48DA07A95BF', N'whole spenyt cost',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'A6CD4052-9861-4D61-A53D-FBC17B405948' ,N'EAA6DF86-F929-468D-99CA-F69144F27FF7', N'Every day fare',CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
		)
AS Source ([Id], [ExpenseReportId],[Description],[CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [ExpenseReportId]      = source.[ExpenseReportId],	   
		   [Description] = Source.[Description],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [ExpenseReportId],[Description],[CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [ExpenseReportId],[Description],[CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceType] AS Target
USING ( VALUES    
 (N'478452c8-024e-42d9-95b7-1c4d18934619', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Credit memo', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'4cee06e4-8f87-4bfd-954a-2f8b94718b93', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'ast due invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'c826c6a2-b236-4ded-95e9-3dd761eddd59', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Interim invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'00e67b6e-10f2-4b24-abdb-612c7b20bec8', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Recurring invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'a9af6a97-b58c-44d6-9998-d432b7e42a55', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Final invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'871a2edb-d93d-4c6b-96fd-fc628c6d555f', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pro forma invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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

MERGE INTO [dbo].[InvoiceCategory] AS Target
USING ( VALUES    
 (N'75c2c76b-9945-455b-87ee-013df61e8b89', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Progress Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Standard Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'83eba0af-e288-4024-abfe-27d681baa5c9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Commercial Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Recurring Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Pending Invoice', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Timesheet', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source ([Id], [CompanyId], [InvoiceCategoryName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [CompanyId]      = source.[CompanyId],	   
		   [InvoiceCategoryName] = Source.[InvoiceCategoryName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [InvoiceCategoryName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [InvoiceCategoryName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceItem] AS Target
USING ( VALUES    
  (N'98182867-fd61-475c-89e0-0082652b94cf', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5fa1da48-3e56-418b-bc1c-00c0b83e796e', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'286b46bb-4a7e-40f6-a96e-03257838ced0', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'61548a6e-9ac3-45be-b77a-0455704a912d', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd4b5b3e9-f8a4-43a1-ab39-04c28d5aa4df', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eefe8510-eff2-4863-959e-060cfe49e0eb', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1657d40-41fe-40c1-a1d9-092d117e2c32', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'70e041dc-c0ab-49f9-80d2-0ba27d683c81', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'fdc1d5f2-aeb1-4c1a-af79-124d59404c28', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'14a8b3fd-e68e-48e1-946b-1497eb376410', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7f5fd838-4ef7-43fe-9a69-14dfef3048c0', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e747e37e-da5c-4c6c-8d64-1556e4e1b78e', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ce4243f6-6526-40b6-bea9-158caf1df138', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1c6befce-ab89-46b2-8f82-168f84e29797', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1fed110c-fb71-4432-962a-1d7e414c4215', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'04109a37-4c58-478d-965d-1e8e8bb83c4f', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3e65a52d-b7e0-42c1-a058-212c6b9553cc', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5de820cd-a2c0-4bdb-9eb0-22b36696296e', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'785ad474-3fe5-42d0-8ae1-230a14ff3f0d', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'67af22e5-c513-48ec-9962-23478004ed40', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'90109cea-0a36-4388-8e01-23c5dca7275a', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8693a678-9b2d-4f02-8214-2432876e2445', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd56d24bf-fe3a-424d-bf4b-25d3de6c9ef8', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'74195f26-bd82-4b23-a602-292edbe5a7f6', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'596de6fa-8a39-4bbd-bd2e-296dfa374bcc', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ab438f0f-97cb-4f56-8be1-2aa4130e7f67', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1fb5430a-7a4d-4f6a-ac1f-2ba0abaff7d2', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'95381142-f987-4419-babc-2c2bcdf8afb5', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2100935e-7667-4fd5-abfc-2d95bb2f3586', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd797bc51-173c-47aa-930e-2f7239c8e70a', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f24fd52b-4aac-4432-8494-317c70184d31', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3e7936ac-28f8-43e1-bf10-31bfd863a732', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9c2ef4e4-d15b-4054-9aed-32bcaf9cffec', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'81b91934-759f-4b4b-ba12-32e9f70ac232', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9c5ab9c1-0d12-4167-8e63-33f2878ff861', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'43a8e952-1814-4eca-890a-35aba994bdd6', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'49870005-fd76-496b-a2c7-369ff34f0bd7', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a7033979-f98d-4980-9817-37cb2954d2b3', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2363f6bb-f2b5-40bb-9b29-398c68a3a68d', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e3907699-878b-41b9-86fe-3a0d62958e03', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f268981c-54c9-403f-92a9-3adc2e265a3a', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3f6bc819-15db-4a3b-ad99-3b31cc6248ff', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2b66baf1-a2de-4831-a27f-3bb8322ddd1b', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7b2bdfc0-933b-4b0d-b666-3c104f6eb3de', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'79fea7d6-c726-4608-b59e-3c5b9562e99d', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd548ac5c-2fa6-486c-87ca-40c9426bc6b8', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b37b2b1a-f547-4fce-97a6-415a34883bf7', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9762868f-742f-4f43-b3ff-4307892d2a93', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3b097953-0eee-4075-ba3d-443ed8d85722', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7260652e-be6d-4e63-a850-44bd12f94e1c', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f12ab5ae-b67a-4231-a99d-45441d3d573b', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b9af9fd1-b8ab-47ad-877c-4690bf919ce9', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1e21be5d-eaab-4fc8-b344-46c3464321d0', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'84cc8e57-bc46-4df3-b4d9-46f00513a15c', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c455a0ec-d42f-44a0-a9c1-47305e524569', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'61b3f2d5-bea8-4b0b-8db0-47c18bf0cc7a', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ad086654-2841-4730-8a53-4815f2112af0', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'512a4a4c-ef8b-4271-bbfb-491cb0908f9c', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'54c47bf5-0d23-4068-80cd-49da2915ed5d', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5c1f192f-00ea-43db-a5e4-4c3901311237', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8482933e-b885-4be9-81eb-4d3a80bac426', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7754db8f-b8b9-4c74-9f70-4dffbbe93854', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f0495f7b-660c-463c-bd3b-4f2c77ad6265', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'95cf8038-a5cc-42ec-bc4c-4f5160463829', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4284433e-8f62-4ed9-95fc-4f77a5f776de', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'77d40325-d1bb-41f2-b568-501ac6c3ebd6', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8d6b3051-983e-420a-b1ee-503676eb381b', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'759b2a18-12f3-474c-affa-50dfa824d295', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd8fd9a23-f9c7-45af-a626-5236e364f44e', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8f592873-dede-44dc-9076-5529e19bf978', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a1ae7641-387a-4f46-90df-56e08a38c654', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a8ccec6a-7998-40de-9265-572d3a2115ff', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'47d62d90-6579-4003-ad94-5b92d30fec4d', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd881db2d-fdd3-4cab-9ee1-5c97c9037af9', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'74306456-a22b-420a-a3ee-5d20a307c710', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8184ded7-4d68-489e-9b08-5e338b8a5473', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'26387280-4b8f-4d32-aeff-5fb013e27172', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'82f5715c-9fd6-4590-bf77-615d0d25bbd1', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e91166b8-9247-4925-963f-664922f8c8f3', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'06fa33e0-515b-448e-81c1-66f1a9f5bfff', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'10b02796-60b8-4c70-b3ae-6875cc484b53', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dc8ceb85-75d9-4de1-a64b-689a0281d604', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8c2ec10b-cd71-4de9-8822-68e657e33da5', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0ddb45a1-6ba0-4c91-8631-6aa8e55fcd70', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'777b081d-b106-4e05-99d0-6b234356ab87', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'39242d72-b761-4040-9924-6bf2eb4968c0', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0b83aba3-b37f-47f5-9bf4-6c087dc92e9d', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cceb0c65-0810-4de0-9367-6c31e0542575', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1a27865-c9db-4c30-8525-6da8842321da', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c30c59ad-6465-4465-ae20-72190676dc03', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0f7265b5-aac4-43ee-9d5f-7577e9d6f428', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1566e9f4-8bbb-46cf-acaf-75f8c9c28602', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'81380e7e-f610-4c65-82fc-76447e269d00', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f2c04c95-75b7-4f75-b087-798b13af63a6', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7ae60129-02a7-4beb-b02b-7c94d8ada65c', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7ec3c9df-116c-4a83-b7c2-7e4d86d7d9ec', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd7ed2c3c-86a2-4c85-9fa8-7e7c611cc63f', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eacf4104-0f8d-4c30-898a-7e8a3e35ce9f', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'584e4d00-b98d-4b60-8ec5-84362c25f13d', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'87d788d5-1cb8-48e3-b20f-845f005cdbde', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7bfb87e8-cfb1-433a-90c4-8544cdcefd9f', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7167a6de-cdda-4b29-b2b3-886713d1b0b1', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'776b98f1-5590-4858-8356-888be762b76e', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e08f8217-32ab-4aad-bedf-8969fb7ae8b8', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'41a8ba69-f372-4523-a283-8a14c8f31a92', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd449bd27-f66c-4561-88c2-8b7687b1a83e', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a5959bc6-47be-4f0f-85e8-8c823d409ad7', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'da734b91-610b-48c6-9195-8e015b8deb2e', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'baff9e4e-f6e1-4a1a-bead-8e7e00d62123', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3c233cb9-17ed-4677-baaa-8f0f43aebb16', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'edfe31b3-72c5-4701-8f72-903cd39a3560', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'75ddcc11-8a14-4af4-82c4-90af1841a25f', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1d209f53-df60-474d-a017-90df9aadf970', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e53d8bec-c7d7-4678-8a97-92cd75cb3dbf', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a7d8fbae-7ec8-453c-9e0f-9604bd5edef0', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e752ca03-4ec9-4a63-ba2c-9663e6fc3f48', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cf164c07-c530-4ef0-886e-985fcc1e4b80', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a2bcc262-f3d9-4167-b71e-989c13f483f8', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e3631df3-994f-4894-ace6-9ba7844f8e0d', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'542d6a53-56e9-4dbd-993c-9cb911ad308d', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'88ea5b75-8e3b-407e-a09c-9cca6f3a20b4', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0db09882-7ef3-4341-88be-9f98e1f5e8cf', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'04aa0e98-84e5-4b85-8b6e-9fc7a1400316', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1b394521-bd8b-4eca-878d-a326b98d86b3', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3909ba1d-64df-458b-a15c-a4099cee85f8', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'27b22124-a2ca-4a37-afa6-a57badf1bff2', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd7aa192c-2c93-4ee5-b27b-a90c799bef51', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4d3be028-6cb5-45b1-a62a-a9e5079c2646', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8a26d4aa-6937-43bc-9c5e-aa72745c6121', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'907c267b-daf1-4971-8130-ad1945fd9fe6', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'bff0d963-09bb-41f0-b987-ad6ba144f0f4', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4a5c6126-dba0-4f0e-8968-af912648132c', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'24e2cab8-30c9-4d89-af84-b041ff10844d', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3ee6e890-eaee-4cfa-bb9b-b13834e36a4c', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f35faf51-ac0c-45d0-a602-b4c4e084b3c4', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e8553206-c2e4-4559-91eb-b5afb93e69fa', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f07162f4-381c-46e9-8965-b6052649192f', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'19261f99-13aa-4f82-92e9-b708a775fa61', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'76301fd4-2571-497a-8f38-b7d96f6683c2', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'67d9018a-db05-4f81-aaf1-b9d2b1e0d980', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2c3cd800-147b-4e04-8b53-bbcd4154a6c3', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'36ddf271-1170-4ecb-98be-bbfd99289d91', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'62aa5add-1a6a-40c1-b443-c11415d397e5', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'904d5830-c905-4fcf-af16-c143034504cd', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6252200d-8008-4053-b650-c1e71bffb32e', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a60b1bbc-27d7-47b0-b58f-c1e886227772', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eb19bd5c-06ce-4540-8537-c2046b29f742', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8cb74984-e5cb-4788-8dc7-c28767e9b0c8', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'906ef9d0-b651-46fa-bf4e-c2b60b18b3c1', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8118be4d-aa51-4684-886a-c2f1488b975b', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5a5b0bbd-b5d7-4868-a2f3-c59124b7eb15', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ce5416aa-1a3e-4cec-93ee-c5c8f7ffb2e9', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8cf12359-aee3-4a04-a4da-c6bcf2e0d22f', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'93583f43-f736-4781-aae6-c74bb6e351b5', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f0d5e3e8-5a09-4f10-93ee-c74d1970bae4', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eab89a3b-52aa-48f4-8294-c7fecab2f6bb', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'85d48bc1-155a-4640-b433-c80817b00328', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'98b93756-12d1-4832-a6e4-c83618a56d08', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3e410931-21f4-48d1-b322-c8a686278b82', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'80907f85-8a7a-4035-a0f5-c93f49389b9b', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'028e4c75-b1c4-46e8-9f60-c9daa159e01d', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0f822bf8-883a-4c56-9143-ca064362b536', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'178c3871-c080-4642-a8d0-cd28511c7518', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b57d6773-6236-4ef4-88e7-cd4818c3a480', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5dab71a7-d58f-46b7-a3fb-cf177c271156', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3db3f2d4-9995-4f12-8764-cf2394038f09', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'383bfc5c-a150-4031-a407-d0132f16ea72', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0e1ed4d4-cc0b-431e-81e8-d098a0741614', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2bc96846-d841-4d34-afda-d1032c1fd125', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'549dcacd-f913-415a-8567-d2110c238af7', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ed9e02a5-0197-4095-b903-d23e34197d9f', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f4797bea-57d3-48aa-b16c-d262eab4ec5c', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4aa2c7cc-14ba-4a72-95af-d38d4bdb40ef', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cc86c118-a89a-4dcd-8368-d4b338510c89', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4e1cb95b-fb63-4ee1-9195-d5382c5e14ba', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5c90bf06-e95a-446e-9c96-d548bff80816', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'63a58b82-83d7-4ab5-ba16-d5a4c4404d90', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8483cfa7-d21d-4eb2-8edb-d6fd38752b7d', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'81cce4ff-9827-4a3e-a3fb-d73294170705', N'26668536-e9ef-408f-a000-2a20c39200af', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6a486c22-7521-45f9-9df7-d7cd5f67df66', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'23141416-e163-4290-ab14-d91f5bc5985a', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'662e5ed2-caa8-481e-a760-da903ee3c69d', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e00cddc6-71b1-4a15-bbed-dce455fe3447', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'fde20420-adab-4b05-993c-ddb620d8440e', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dee62a46-5412-4f15-a104-debfce22cd49', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4b0d94b1-8f17-4d59-8a75-e0238e19fcab', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'421b7c0c-fa36-46d8-bf6a-e031ffdbb727', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cde4d86b-91c2-4900-b90a-e04470c00fc4', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c070bdb0-3d54-461d-ac2c-e08266346dba', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'72344257-b9de-4954-828d-e154db5e95e4', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c3b3c613-1bc5-4b2b-8e25-e1893bdaf25d', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b0b9b809-b9c9-4db2-90c5-e40279e904c4', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a70993c7-54f8-4e2c-aa4e-e44b181b0757', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9e7f2724-a2c5-442d-88d1-e475c4ecb58c', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3b8d990a-5e3d-4906-b50e-e68b243ca922', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f985d674-d117-4b2c-8b9b-e6facac8c901', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4489e056-4c82-4b8d-8013-e7114a7b2293', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eebdae8f-e6b9-46a6-82ba-e71384f9a20e', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b217cb09-44be-4a8e-bcb3-e723fe3ce8dd', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'eb02a27c-3c03-4fc7-ac39-e7fc107b186c', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'dd80e4f9-b1f4-4125-9d46-7345db065262', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'bba96cff-e0df-4afd-add0-ead6cba436b9', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9c4da309-10be-4c75-aac5-eb1cb08b7300', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b80e4987-a0df-46bd-9a80-ec03248dd3c1', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5e374449-3e62-4e90-8caa-ec28a088cc45', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1c57c3d-0fec-4c0d-ac13-ecf3d8ed3a64', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dbc7c832-860b-4cb9-85bc-ee2e4bd33fdf', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ed971607-26ac-415f-abb5-ee471bbc8ec3', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'85665861-25a3-48be-8e0b-efee48ce7ed9', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'27fe295b-f872-4eb2-8978-f465a791f4a7', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ccbf759c-2f44-4a86-9853-f8989a6c4412', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ff8cd3bf-5620-495b-9d10-fa1d2f84db47', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e0109c71-88b1-444c-9d76-fb2e53694193', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'1f7aabe2-876b-4e5c-9c9d-0f7a99fde58e', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'324b1481-783e-4d71-a120-fc7e476f08da', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'ab24fa6a-91fc-417f-a116-7487ef3e9578', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'52125ee2-a4fa-499b-b2a9-fe2bfc621010', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'75c2c76b-9945-455b-87ee-013df61e8b89', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8b4a1cb5-a01e-4aeb-bb23-fe3b61b896a8', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'83eba0af-e288-4024-abfe-27d681baa5c9', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5fb26701-1a21-457d-8ae9-ff7487f24576', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Pictures', N'for test', CAST(10000.00000 AS Numeric(10, 5)), N'/''sku?/', N'Customer', N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'3b2ecff9-dc76-4ba7-82b1-5e45201ee6d1', N'Specifies', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source ([Id], [InvoiceId], [DisplayName], [Description], [Price], [SKU], [Group], [ModeId], [InvoiceCategoryId], [Notes], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [InvoiceId]      = source.[InvoiceId],
		   [DisplayName]      = source.[DisplayName],	
		   [Description]      = source.[Description],	
		   [Price]      = source.[Price],	
		   [SKU]      = source.[SKU],	
		   [Group]      = source.[Group],	
		   [ModeId]      = source.[ModeId],	
		   [InvoiceCategoryId]      = source.[InvoiceCategoryId],		   
		   [Notes] = Source.[Notes],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [InvoiceId], [DisplayName], [Description], [Price], [SKU], [Group], [ModeId], [InvoiceCategoryId], [Notes], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [InvoiceId], [DisplayName], [Description], [Price], [SKU], [Group], [ModeId], [InvoiceCategoryId], [Notes], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[PaymentType] AS Target
USING ( VALUES    
 (N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'PayTm', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'66776be4-2371-4a64-bed5-dc4a720f7ce5', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'OnlineBanking', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'd8023bed-8683-4df6-a61c-e0be735661e9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'ATM', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source ([Id], [CompanyId], [PaymentTypeName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [CompanyId]      = source.[CompanyId],
		   [PaymentTypeName]      = source.[PaymentTypeName],	
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT([Id], [CompanyId], [PaymentTypeName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [PaymentTypeName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Payment] AS Target
USING ( VALUES    
  (N'63e72da6-e5a7-4d27-a4d1-0552940a5a88', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3547c1fa-dede-40f7-a9ed-160d1e45a9af', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'694896d7-a92f-4be1-8d4e-22c390b4a1b9', N'0e888feb-a433-457e-91c6-db08c58ec150', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f7fd8bf7-1754-462e-83f4-40037ef42bcd', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'94719bc9-5fc0-4df0-9597-4976fd7b8d0d', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'86443703-cd56-4b70-8779-4a8756302907', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f5fa216c-c43b-402f-bd1f-4b2f36b658dd', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5130ddac-203a-415b-b5c0-55492bd87919', N'936318da-8b44-4569-99cc-fada0f1cea00', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'563c38c7-9c38-4ac1-9ab0-58dff5118a43', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ce27048e-dcad-400c-9d0f-58ee001a24a5', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c5736f32-86ee-45cb-b2f1-5eb48ad6ea7c', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3de9f668-6ee9-4bca-b293-671b1d73ac72', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5634191e-5240-46f7-a54e-6d0039dca227', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'649d6c5d-f24c-4a98-9ec1-6f38d08b645f', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c43d3b2a-c32a-4c56-9bb4-7141e84f8873', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'893268b6-7836-4f52-8bbb-745f81d05145', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'716b81d5-a04f-4e78-8ecd-8f50bd0e14bf', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'13f98624-31c1-4774-85e8-9412fcb5454b', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6f0ad3a2-571c-4792-912f-ad8aade4c7cf', N'01a8f69d-4baf-4239-9389-2400534d40af', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a0ac9641-319a-4b83-b32c-b1876b210824', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b44781d4-c105-4ead-8638-b238da021757', N'26668536-e9ef-408f-a000-2a20c39200af', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e8cf308f-c379-4578-889f-b28fce67306f', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ad2fb6aa-bb64-4bd8-8e77-b64057a9a07c', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'37ab1cd0-2490-4978-b79a-bb97045ac0ca', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ca5d33df-c5de-4f4a-ba57-bf30d1d59b4f', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'deaf3216-8422-40f8-984c-d7d9076a8353', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'016d50e7-6b39-4df8-8fd5-e4d5398625be', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'95817e42-37a5-435f-8925-e51d355f3fed', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6cd62a35-e6c4-4ddc-b947-e8ee914c30c1', N'1e2b435c-0f88-460f-8163-72db669cc976', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'383ff7c9-a090-4aa8-becf-f153c9158500', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c284a63d-8afa-4d71-b7d1-f42457a69571', N'676c1785-d872-4e92-8b2f-c043645bb324', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8b43356d-74f8-4d2d-b9d3-f4d25d9a405b', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'193f724e-2010-472b-98b5-f5b1b1315faa', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'30c4083f-dc6a-4352-b29c-f9a1966c554a', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cc6adb25-f7ab-4996-b00a-fb44cdff3e74', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'122d9f87-ed83-437b-a5c9-fe5d97b139a0', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'84e7d41c-c92b-4dec-a20e-bc8f069e8523', CAST(N'2019-03-04T00:00:00.000' AS DateTime), CAST(10000.00000 AS Numeric(10, 5)), N'Test', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source  ([Id], [InvoiceId], [PaymentTypeId], [Date], [Amount], [Notes], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [InvoiceId]      = source.[InvoiceId],
		   [PaymentTypeId]      = source.[PaymentTypeId],
		    [Date]      = source.[Date],
		    [Amount]      = source.[Amount],
		    [Notes]      = source.[Notes],	
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [InvoiceId], [PaymentTypeId], [Date], [Amount], [Notes], [CreatedDateTime], [CreatedByUserId]) VALUES   ([Id], [InvoiceId], [PaymentTypeId], [Date], [Amount], [Notes], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[Mode] AS Target
USING ( VALUES    
 (N'331ac4e6-fb24-4115-8f80-7284afc454c9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'COD', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
 ,(N'A0EBEE4B-4CA5-4C06-9001-FA011C2E43FB', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Payment', CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
  )
AS Source  ([Id], [CompanyId], [ModeName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [CompanyId]      = source.[CompanyId],
		   [ModeName]      = source.[ModeName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]

WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [ModeName], [CreatedDateTime], [CreatedByUserId]) VALUES   ([Id], [CompanyId], [ModeName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[InvoiceTask] AS Target
USING ( VALUES   
  (N'44fe6a0c-3d46-4f38-9d98-05783f71e153', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ddd3c583-f233-4a63-a996-06c17d845e89', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2d1ea379-1171-494a-a4c1-0c67de211e85', N'28131d97-48b5-49e7-a41a-cf3057de27f9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6524fc06-9109-4891-84a8-0f7e07107e81', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a6e64874-c024-4050-98df-0f8ea60b9202', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'30e9c96a-28b2-4359-94b9-13fdd8bc2349', N'26668536-e9ef-408f-a000-2a20c39200af', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'af2fcdc3-8580-464a-955f-1561f97c7fe5', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b6ceb5d3-f5f4-4cd7-993e-15b3ad52cca4', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6205ae3d-9ed0-4efe-8056-18dfb5b69c4e', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'059a2653-4df6-4c89-8013-1dc482332277', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f3915cd6-5d95-4bd0-b70b-1ec902268535', N'1e2b435c-0f88-460f-8163-72db669cc976', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c82d0f11-4a7d-48f4-8d73-237a7147c09d', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dbc2bfb7-604f-46dd-9fdd-24a77eee46af', N'676c1785-d872-4e92-8b2f-c043645bb324', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'dc37963d-c2a6-4c52-b7eb-263d79547294', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ba4fea09-2fc8-4361-a7c0-2653f0e8409c', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'301752a6-ba2f-4e0c-b467-2a43b37b92a1', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f0ba74fa-3df0-4457-97a5-2f3310ce56f3', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'acf09085-54c2-4de4-ba73-466570b90f40', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5b7a4143-5b3b-492f-bb0a-4897ece6599d', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'58644965-5dc2-4b6e-970d-48b1be5f8e98', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6044d181-fe3a-411c-af3e-4e1eff8a6d74', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'134476bb-c0f5-4d0e-a7de-4e90028c5490', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8cb51c53-7ae3-469e-a593-4efab32b21b8', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd1427ed9-3b9d-4cb8-ad32-4efffc5d72e9', N'd328e49f-6211-45e7-b225-0a3e1648324d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'07c64347-735e-45d3-87e7-55de4674368d', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7add047c-a0e2-492e-addc-580ae160f36a', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7b257a16-cbc7-4954-8685-5a6c6ee18d20', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2bb51e96-87ef-4eb9-a341-60b9ab43e0b1', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'4e9d0bd0-f74e-4647-a433-62d23e2af799', N'e3c50819-5d97-4f01-9555-58e4e165d07d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'35865ad4-2eba-409c-bcb3-6388f1d92209', N'01a8f69d-4baf-4239-9389-2400534d40af', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c37ee45e-ef8d-48ec-b24e-6667a8d952dc', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b962f1b7-59ca-41a4-a71d-6754cae8782c', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'e1d69bb1-5580-4c87-8e2d-67c112eade6a', N'ee11c892-e98e-456b-9f71-74ed20bc3256', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'458216c1-3ed6-4b43-afd3-6aba79893c37', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1555858a-1105-4bd2-9865-6c3321b8d7a6', N'93364d88-e5a5-4b29-be8a-b079b18548b9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2a4d3878-414f-45ba-a046-6dd5dcd9b92f', N'26668536-e9ef-408f-a000-2a20c39200af', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0740e0a0-0042-4c55-b004-716dfd302b03', N'41e03c22-a9f8-4c42-b3a6-b47857501e47', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b2d73113-6e02-47f1-80a4-71e2ce1bcbf0', N'31d28f3f-9ed8-4a1e-a908-cb678ad9c533', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c1023512-0d0c-434d-ad83-78dda5979ebe', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2d791d3b-1441-4c8e-a147-7e5e4e1be096', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f250196d-7d8b-4cf4-95a2-8399f449b26c', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b8578596-8fa5-4297-9760-84d64e43333f', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b5328e9a-3c93-44fd-a5b3-84f370e4ac62', N'e1bc4bb4-a83d-4190-aa24-cedd9f70a1e6', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a15fe6e2-33eb-400b-b386-86072ab7b10a', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'04ebcf24-e417-44c8-834f-87fdac0ba2bd', N'60b980a2-1ed3-4bf6-904b-fc74297352e0', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9411d0f3-2e62-4a94-a7fe-8a9dd1f94ec7', N'5e2ff8c0-ba8c-44d0-b368-10156bdd357b', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1d362bb9-baf7-4812-a645-8c2c068fa152', N'936318da-8b44-4569-99cc-fada0f1cea00', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9320bcfd-dc02-46d2-93ea-8e5df55139b8', N'268c95b2-f62f-4660-9b4d-4d4d79f3a422', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c90aef45-8bff-4bf4-8bd3-95fa8042d94d', N'06e846f9-de32-46af-930a-f039d54fa8f7', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1d30d4af-2131-4672-ad05-974f59ab21a2', N'5f685a42-ce6a-4e0c-9555-67534ee3850d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0e73a209-f225-4659-bb83-98f425401167', N'cf15dcac-3bbf-45eb-9e3b-8e4b2819fce4', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2d7a782e-df3a-436c-bc27-99749d1bc751', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8d3083fa-7e4a-4c0c-ae95-a4b2f65bb797', N'25e626c9-2a1e-460b-81cd-761bd7a5c29e', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'52eb6f7f-53aa-429b-b24f-a71436b0f7cc', N'256ca9ed-f9d8-40cd-b093-dec49dc79921', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0ee49e53-2851-4de1-ace6-a92fcd11c010', N'12f1d580-69c2-42b6-9a98-7bed48601527', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd0de012f-5bf6-42c9-8c3c-b077150dbb5a', N'962f417f-f257-4f7f-bf3a-13c2bf2a43f2', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'87729242-70e2-4cd1-a617-b61c3e2a44e0', N'8433e965-274c-4f70-b7c2-5dce034ffe58', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0496c88a-e0a3-4429-ade8-b99a4a12d48d', N'6dd7aa25-10eb-4d86-a88a-f9083b69c81d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cbbb36e2-0ed2-4090-86de-bf6415ca00e3', N'5fc28b20-62e2-45bc-8dc3-8185efbd15aa', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'74aeb439-d5b5-4c83-a93a-c3d5d558604e', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd76d1026-9288-4ad5-942c-c46709f376a7', N'fc5a9e30-f8ab-4379-912a-d42dd59dbed3', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'50c8f238-3bd6-4e05-a5ef-c7058253d84d', N'fa7e0c5a-0b0b-440a-8b03-3e72d3e4b5c3', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'459fc0b8-ffe0-4528-9164-c990776b5be5', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1fef87bb-c5d7-4f25-adeb-cbecd423d74c', N'aa093867-45fa-4797-88a7-1f0b953965e9', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0f7d0874-cb68-4fc5-a085-ccfe92b69ccb', N'd00f153f-40aa-44d0-9bb8-5f7d084f1421', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd94bcc2d-f365-4405-9617-ce14e88d4aab', N'588222af-14c9-4acc-87c0-fa99a3c06285', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8feb42cc-a7d6-4aac-b7a9-d39e4cb125b9', N'1a4b523e-87a7-4bc6-8b19-4f8c86a3aad6', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'56d8e99e-5bbf-4fad-9b7d-d9052568ce41', N'47577c50-7b51-4522-82e7-c9935e18b3de', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'34e548ae-ecf2-45ba-bcec-e6de325870aa', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 2', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7e687dfe-fe0e-44e2-8223-f106ee5fa02d', N'0e888feb-a433-457e-91c6-db08c58ec150', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7c8f73b0-e98c-4de5-860b-f608caf979f5', N'525a9b87-a559-45c9-b6c7-b569da70077d', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c0d808f5-1153-4a7c-bb1d-fe96069f9c78', N'056f598c-6c3d-43cf-bb07-1801b4163e33', N'Project Module', CAST(10000.00000 AS Numeric(10, 5)), CAST(20.00 AS Numeric(10, 2)), N'Sprint 1', CAST(10000.00000 AS Numeric(10, 5)), 2, CAST(N'2019-03-04T00:00:00.000' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)
AS Source  ([Id], [InvoiceId], [Task], [Rate], [Hours], [Item], [Price], [Quantity], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET 

		   [InvoiceId]      = source.[InvoiceId],
		   [Task]      = source.[Task],
		   [Rate]      = source.[Rate];

MERGE INTO [dbo].[EmployeeWorkConfiguration] AS Target 
USING ( VALUES 
	 (N'e7abf434-2be3-44f0-960a-376ea8240f76', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'a6a2231a-09ec-43b1-89b3-44d5bedb110f', N'906de613-43ba-4563-ae6b-1f31512d0665', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'86666f6b-902b-4b27-bd9d-5850189c761e', N'f2e604db-6317-4b08-805a-598c7881e821', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'8c3e2c49-8f09-4fbe-91da-8b7925173b7d', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'9f11acd3-3177-4c80-b683-bf94ad4e04e8', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'b0ca1b78-63f6-4eda-98d5-c6db01edf424', N'83e2deee-4943-4435-9cc9-5be3204775f4', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'b300ea1b-7a9d-4d99-ad2e-e3b2ba95fa92', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'cf97c53d-33a5-4aea-a65e-e4d208e91a05', N'a841612d-894a-4539-adab-25f183b57315', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'5e0660f2-529e-49f6-a91d-e68147713716', N'331f0c6e-c573-4b69-b6d2-a1e548794967', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
	,(N'5edb956d-3d71-4974-b784-ea380e3b414e', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', CAST(10.00 AS Decimal(8, 2)), CAST(50.00 AS Decimal(8, 2)), CAST(N'2019-04-01T18:19:47.757' AS DateTime), NULL, CAST(N'2019-04-01T18:19:47.757' AS DateTime), N'f6ae7214-2b1b-46fd-a775-9ff356cd6e0f')
)
AS Source ([Id],[EmployeeId],[MinAllocatedHours],[MaxAllocatedHours],[ActiveFrom],[ActiveTo],[CreatedDateTime],[CreatedByUserId])
ON Target.Id = Source.Id 
WHEN MATCHED THEN 
UPDATE SET [EmployeeId]  = Source.[EmployeeId], 
           [MinAllocatedHours] = Source.[MinAllocatedHours],
		   [MaxAllocatedHours] = source.[MaxAllocatedHours],
		   [ActiveFrom] = source.[ActiveFrom],
		   [ActiveTo] = source.[ActiveTo],
		   [CreatedDateTime] = Source.[CreatedDateTime],
	       [CreatedByUserId] = Source.[CreatedByUserId]
		   	   
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[EmployeeId],[MinAllocatedHours],[MaxAllocatedHours],[ActiveFrom],[ActiveTo],[CreatedDateTime],[CreatedByUserId]) VALUES ([Id],[EmployeeId],[MinAllocatedHours],[MaxAllocatedHours],[ActiveFrom],[ActiveTo],[CreatedDateTime],[CreatedByUserId]);

MERGE INTO [dbo].[UserActiveDetails] AS Target 
USING ( VALUES 
 (N'882ff156-251b-4463-8d83-01d5102dca56', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', CAST(N'2018-01-08T00:00:00.000' AS DateTime), CAST(N'2018-05-31T00:00:00.000' AS DateTime), CAST(N'2018-01-08T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'98e5f824-1439-444b-92f9-028c16a6c84b', N'5E22E01A-BF81-46C5-8A64-600600E0313D', CAST(N'2018-01-02T00:00:00.000' AS DateTime), CAST(N'2018-01-27T00:00:00.000' AS DateTime), CAST(N'2018-01-02T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'e5f55df7-19ab-49ab-ba97-0358706276f2', N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', CAST(N'2018-05-10T00:00:00.000' AS DateTime), NULL, CAST(N'2018-05-10T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'da0555ca-5da6-4f24-9336-045626d1b5f5', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', CAST(N'2017-12-04T00:00:00.000' AS DateTime), NULL, CAST(N'2017-12-04T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'27564689-a156-4767-b0fb-08758cc42e70', N'E38B057F-AA4E-4E63-B10A-74AA252AA004', CAST(N'2018-03-07T00:00:00.000' AS DateTime), NULL, CAST(N'2018-03-07T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'0c755695-0b11-40c7-ae1a-0fc694305fa8', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', CAST(N'2018-01-19T00:00:00.000' AS DateTime), CAST(N'2018-02-03T00:00:00.000' AS DateTime), CAST(N'2018-01-19T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'1d42a73d-07fc-488f-bbe5-10782ac0e94e', N'0019AF86-8618-4F46-9DFA-A41D9E98275F', CAST(N'2017-05-22T00:00:00.000' AS DateTime), CAST(N'2017-07-31T00:00:00.000' AS DateTime), CAST(N'2017-05-22T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'9e1f8696-6166-47e7-ae6a-10ab8616d63f', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', CAST(N'2016-01-18T00:00:00.000' AS DateTime), CAST(N'2017-05-01T00:00:00.000' AS DateTime), CAST(N'2016-01-18T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'5b5e831b-b877-4ecf-a624-14ca7aa74e21', N'127133F1-4427-4149-9DD6-B02E0E036971', CAST(N'2017-09-12T00:00:00.000' AS DateTime), NULL, CAST(N'2017-09-12T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'e469592e-d746-4d8b-860a-14f94910182d', N'127133F1-4427-4149-9DD6-B02E0E036972', CAST(N'2016-10-17T00:00:00.000' AS DateTime), NULL, CAST(N'2016-10-17T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'7525b364-84da-4d7d-b0f4-166dbac12e81', N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', CAST(N'2017-06-01T00:00:00.000' AS DateTime), CAST(N'2018-03-17T00:00:00.000' AS DateTime), CAST(N'2017-06-01T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'1219706b-86c5-4801-b6ed-1c152393d88d', N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', CAST(N'2017-06-05T00:00:00.000' AS DateTime), NULL, CAST(N'2017-06-05T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
,(N'e67cd0bf-c1a6-49dd-b5e0-24d3fec2200d', N'e852f9a7-1a08-49d3-b706-55dbb6b798a2', CAST(N'2018-02-08T00:00:00.000' AS DateTime), CAST(N'2018-06-05T00:00:00.000' AS DateTime), CAST(N'2018-02-08T00:00:00.000' AS DateTime), N'c71797de-8161-484a-bbbb-c146947ec520')
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

MERGE INTO [dbo].[CurrencyConversion] AS Target
USING ( VALUES
  (N'2b4d48ad-bf7e-4c73-b35b-161eca922601', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'0916c24b-cae2-4beb-afb6-3ddaf9d6fa5c', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 48.89,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'df62370c-fc3d-4b48-9dec-1e9db40ac13a', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'c9ec506a-a7cf-442e-9234-ee391ef5da0f', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 0.69,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9d9d96dc-5d75-49ad-ba30-5440d1548a7a', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'b3d21322-50dd-4e89-a070-e3039dfa420e', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 0.63,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'12effcaa-678d-45c5-b8c1-6764b0ee0445', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'de37922a-b1a1-48c1-a899-677c6522968b', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 51.70,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'3082fd9a-442b-4abf-934b-6e9bd0bd0b2e', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'ef41ea39-e84c-44e1-8d74-4c7ca82bd9b7', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 0.57,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b6765e16-eb21-4d6c-9c8c-759ac143de61', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'1f8a1142-defd-496e-a69c-264cbf7bedd1', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 78.08,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2092c412-b1ea-47fa-b528-7f917083d564', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'e4c3bbca-c1b6-473e-82ca-2ed57580f1dd', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 10.08,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6dedf321-4fd4-4c2e-895f-a13a1f9be164', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'951d4867-94a4-4aab-8613-d142c56e9f77', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 32.30,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'f284b4aa-e2c9-4db2-bc41-c51b3bdf4599', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'3865593a-f458-415f-9cd5-e086a041cc0b', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 0.008,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd3ef59ea-723c-4e1c-a37e-cb296051593a', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'5caf4a23-db0d-4695-953a-649153c6a4c9', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 0.89,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'48645b8a-b2c3-452c-8237-d6471aef85d9', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'e1df9c69-5724-4244-8691-7691d3b0f16f', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 8.87,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7e575972-d933-45f3-8dc9-f0a1d8972990', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'7c7189e8-31da-4d88-979e-a1ca35d354f0', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 0.0049,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'61979091-4152-414f-9661-f27bd2ba664f', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'73bfc3f8-1bce-4ff8-8364-98e684362830', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 78.02,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b49155dc-2c12-4d8a-b973-f63c504c2b7f', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'b55e1651-496c-477e-b98b-4972d0795092', N'df549957-74cc-4622-a094-05f64973f092', CAST(N'2019-05-08T09:23:24.827' AS DateTime), 0.58,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
)																					  
AS Source ([Id], [CompanyId], [CurrencyFromId], [CurrencyToId], [EffectiveDateTime], [CurrencyRate], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CompanyId] = Source.[CompanyId],
		   [CurrencyFromId] = source.[CurrencyFromId],
		   [EffectiveDateTime] = source.[EffectiveDateTime],
		    [CurrencyRate] = source.[CurrencyRate],
		   [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [CompanyId], [CurrencyFromId], [CurrencyToId], [EffectiveDateTime], [CurrencyRate], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [CurrencyFromId], [CurrencyToId], [EffectiveDateTime], [CurrencyRate], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[PayGrade] AS Target 
USING ( VALUES 
 (N'2d807d99-a051-49b5-878a-b05853fb427d', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'PayGrade 1', CAST(N'2019-05-07T10:31:35.093' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'3edf787f-9966-452a-924d-b4ad865716af', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'PayGrade 2', CAST(N'2019-05-06T12:56:45.820' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'PayGrade 3', CAST(N'2019-05-07T09:50:17.440' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'05D80F46-7C06-4B35-A56C-966BC187C32E', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'PayGrade 4', CAST(N'2019-05-06T12:50:59.933' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
) 
AS Source ([Id], [CompanyId], [PayGradeName],  [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId],
           [PayGradeName] = Source.[PayGradeName],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [CompanyId], [PayGradeName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [PayGradeName], [CreatedDateTime], [CreatedByUserId]);	   

MERGE INTO [dbo].[ContractType] AS Target 
USING ( VALUES 
  (N'b15ab115-5d25-408c-b6fe-71d1a9acd79f', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Full-Time',  CAST(N'2019-05-06T12:27:55.420' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL, NULL)
, (N'01383892-b17f-4d75-9e79-811c9cf9a663', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Part-Time',  CAST(N'2019-05-06T12:28:25.567' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL, NULL)
) 
AS Source ([Id], [CompanyId], [ContractTypeName], [CreatedDateTime], [CreatedByUserId], [TerminationDate], [TerminationReason])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId],
           [ContractTypeName] = Source.[ContractTypeName],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [TerminationDate] = Source.[TerminationDate],
		   [TerminationReason] = Source.[TerminationReason]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [CompanyId], [ContractTypeName], [CreatedDateTime], [CreatedByUserId], [TerminationDate], [TerminationReason]) VALUES ([Id], [CompanyId], [ContractTypeName], [CreatedDateTime], [CreatedByUserId], [TerminationDate], [TerminationReason]);	   

MERGE INTO [dbo].[RateType] AS Target 
USING ( VALUES 
 (N'458ab78a-b728-41fe-b9bb-3fa1fb16621c', N'RateType 1', N'50.00',N'4AFEB444-E826-4F95-AC41-2175E36A0C16', CAST(N'2019-05-06T12:50:59.933' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'0514dfc9-542e-4241-b4ef-7e564ad0d9a7', N'RateType 2', N'75.50',N'4AFEB444-E826-4F95-AC41-2175E36A0C16', CAST(N'2019-05-06T12:57:47.477' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'79c51748-f6a4-4a96-ac80-847f75faf254', N'RateType 3', N'20.50',N'4AFEB444-E826-4F95-AC41-2175E36A0C16', CAST(N'2019-05-06T12:56:45.820' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'3e9e9952-dbdd-4e9e-ba03-8eb25cebc1c7', N'RateType 4', N'40.00',N'4AFEB444-E826-4F95-AC41-2175E36A0C16', CAST(N'2019-05-07T10:31:35.093' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'4ed62b55-31dd-4751-9d7a-efc386003570', N'RateType 5', N'35.2', N'4AFEB444-E826-4F95-AC41-2175E36A0C16', CAST(N'2019-05-07T09:50:17.440' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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
  (N'4eb441d2-3074-49bb-b776-14c93fcd8f2e', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'PaidBreaks', 1,  CAST(N'2019-05-06T12:57:47.477' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'971aa01d-60b2-4464-a804-28a4e860e0ff', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Causual Break', 0,  CAST(N'2019-05-07T09:50:17.440' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c61bcf3b-2852-40b5-a9b0-5caaab4601ea', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'Office Break', 0,  CAST(N'2019-05-06T12:56:45.820' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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

MERGE INTO [dbo].[EmployeeEmergencyContact] AS Target 
USING ( VALUES 
  (N'f128db06-44c2-468e-adda-17c177bece84', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', N'6E1B5094-C614-4158-BAB3-DC136AFD1F89', N'Amar', N'arvei', NULL, NULL, N'2782726789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'74ac0ac5-98c6-44c3-bfe2-2e9ea8ca43de', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', N'F8EF8E9C-97CC-4B59-B05A-B8D9077AB635', N'Amar', N'Pullela', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'14ac8002-f1c9-4c79-a439-313770b4cac6', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', N'6E1B5094-C614-4158-BAB3-DC136AFD1F89', N'jai', N'kappala', NULL, NULL, N'2868774156789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7df7672d-a2bb-46b9-a863-395c79990fe7', N'83e2deee-4943-4435-9cc9-5be3204775f4', N'F8EF8E9C-97CC-4B59-B05A-B8D9077AB635', N'Amar', N'Pullela', NULL, NULL, N'288888888456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'15051f1e-2a84-4dde-a27d-3c2b79435fe3', N'b1286b23-1362-4c47-bc94-0549099e9393', N'F8EF8E9C-97CC-4B59-B05A-B8D9077AB635', N'chares', N'haric', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'a3a2c4c1-b65c-4234-801c-40ec81d6cf76', N'91431adf-309d-4c0a-86ce-0774af22ff05', N'6E1B5094-C614-4158-BAB3-DC136AFD1F89', N'Amar', N'Pullela', NULL, NULL, N'278678668', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8616a721-c2c4-484a-85b8-44cbcd66484e', N'906de613-43ba-4563-ae6b-1f31512d0665', N'F8EF8E9C-97CC-4B59-B05A-B8D9077AB635', N'harish', N'abhi', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1d97c503-613e-4eb7-90ba-5c208fe5eda3', N'331f0c6e-c573-4b69-b6d2-a1e548794967', N'6E1B5094-C614-4158-BAB3-DC136AFD1F89', N'Amar', N'Pullela', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'75f1c7a0-e96c-44e7-af7f-6630be9e6a4d', N'a841612d-894a-4539-adab-25f183b57315', N'F8EF8E9C-97CC-4B59-B05A-B8D9077AB635', N'Amar', N'Pullela', NULL, NULL, N'8667856789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'cc9a1c69-2208-4663-aa9e-83de5d97a17a', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', N'6E1B5094-C614-4158-BAB3-DC136AFD1F89', N'syamal', N'Pullela', NULL, NULL, N'287786789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7be3f150-285a-452a-a0e0-b4b027e03e03', N'f2e604db-6317-4b08-805a-598c7881e821', N'F8EF8E9C-97CC-4B59-B05A-B8D9077AB635', N'Amar', N'Pullela', NULL, NULL, N'123456789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'10ca777b-013e-425c-86e0-e367cb8bbe30', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', N'6E1B5094-C614-4158-BAB3-DC136AFD1F89', N'jayachandra', N'Pullela', NULL, NULL, N'2877256789', N'987456123', 1, 1, N'Ongole', N'Brundavan Nagar', NULL, NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', CAST(N'2019-05-08T20:56:47.677' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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
  (N'1256a6b8-7000-4093-b734-4a1eff25d73c', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'T005s',56, N'63053486-89d4-47b6-ab2a-934a9f238812', CAST(N'2019-05-08T19:45:01.557' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
, (N'2cbeb547-d8c5-4399-b6cc-570de8e17570', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'TO59Q',456, N'1210DB37-93F7-4347-9240-E978A270B707', CAST(N'2019-05-08T19:45:01.557' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-05-08T19:45:01.557' AS DateTime))
, (N'fb7d940b-6dbf-4890-a696-5ca1d961ae0c', N'4afeb444-e826-4f95-ac41-2175e36a0c16', N'TTJX', 185, N'63053486-89D4-47B6-AB2A-934A9F238812', CAST(N'2019-05-08T19:45:01.557' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
) 
AS Source ([Id], [CompanyId], [SoftLabelName],[SoftLabelValue] ,[BranchId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId],
           [SoftLabelName] = Source.[SoftLabelName],
		    [SoftLabelValue] = Source.[SoftLabelValue],
	       [InActiveDateTime] = Source.[InActiveDateTime],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [BranchId] = Source.[BranchId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [CompanyId], [SoftLabelName],[SoftLabelValue], [BranchId], [CreatedDateTime], [CreatedByUserId],  [InActiveDateTime]) VALUES ([Id], [CompanyId], [SoftLabelName],[SoftLabelValue], [BranchId], [CreatedDateTime], [CreatedByUserId],[InActiveDateTime]);	   

MERGE INTO [dbo].[EmployeeLicence] AS Target 
USING ( VALUES 
  (N'0bd5adc7-fb28-420a-b173-0b6de598d953', N'f2e604db-6317-4b08-805a-598c7881e821', N'2d7a45f3-e7e6-4e98-a30d-3137f0a7b279', N'123456', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'5b39a6a7-3b66-42b9-9080-0d0ed546b4e4', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', N'2d7a45f3-e7e6-4e98-a30d-3137f0a7b279', N'5249', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'fd913fae-71df-42db-ae14-21c1dcf5e01f', N'b1286b23-1362-4c47-bc94-0549099e9393', N'2d7a45f3-e7e6-4e98-a30d-3137f0a7b279', N'32692', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2831a36e-58bf-4164-9ffc-29041b790645', N'906de613-43ba-4563-ae6b-1f31512d0665', N'3230fd7b-6eac-4687-9bcf-ac4e2ee74f70', N'53988', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'd9b3accd-900d-471f-a8be-2ba67c14b07b', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', N'3230fd7b-6eac-4687-9bcf-ac4e2ee74f70', N'2588', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971') 
, (N'78a5b4e3-12c7-482d-ac17-3fb36e5850a9', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', N'3230fd7b-6eac-4687-9bcf-ac4e2ee74f70', N'39922', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'bd1d3c3d-bf44-47d9-9915-44c878063d4f', N'a841612d-894a-4539-adab-25f183b57315', N'268ac176-bbeb-43cc-b6a1-52769cdb076f', N'242639', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c0882f16-f7ef-4e73-b575-9174e9f2f591', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', N'268ac176-bbeb-43cc-b6a1-52769cdb076f', N'29878', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'12369ea9-1fe3-4dca-a90a-bb01b2c487e1', N'83e2deee-4943-4435-9cc9-5be3204775f4', N'268ac176-bbeb-43cc-b6a1-52769cdb076f', N'46886', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'1249f754-c000-4112-9f3d-dff16a00043d', N'91431adf-309d-4c0a-86ce-0774af22ff05', N'7b244ce2-86fc-4dbc-999e-a4ff8cd963b1', N'98420', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'c09e867f-3638-4035-8354-e7225826e7d6', N'331f0c6e-c573-4b69-b6d2-a1e548794967', N'7b244ce2-86fc-4dbc-999e-a4ff8cd963b1', N'98452', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'438ee9f2-3167-4a1f-8a86-eb1001b5031b', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', N'7b244ce2-86fc-4dbc-999e-a4ff8cd963b1', N'29898', CAST(N'2019-05-08T21:15:17.080' AS DateTime), CAST(N'2021-04-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:15:17.080' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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
  (N'65f0adbc-de6b-44cd-9ed5-242c47bd5973', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', N'001.JPJ', N'FG001', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'be516b09-f9c8-401c-95d0-53f884868fb4', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', N'001.JPJ', N'CD3001', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b240d4a3-3015-4e92-8a3b-5abb11e9e918', N'91431adf-309d-4c0a-86ce-0774af22ff05', N'001.JPJ', N'GDFG001', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'61d74ac9-82b4-42ec-b336-77d305741b33', N'83e2deee-4943-4435-9cc9-5be3204775f4', N'001.JPJ', N'24G851', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'ad327707-7842-4386-8959-7abedd3abbf0', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', N'001.JPJ', N'IG001', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'40e6de27-b771-4bba-b649-92efbc579af7', N'906de613-43ba-4563-ae6b-1f31512d0665', N'001.JPJ', N'IFG001', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'2aa9d0e5-313f-49d6-8749-a616c6d73683', N'a841612d-894a-4539-adab-25f183b57315', N'001.JPJ', N'40531', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'689c49ba-e6b5-409f-a105-b4a4e8310d98', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', N'001.JPJ', N'IFG001', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'0b506db7-f559-4793-a18a-c49a7670efb0', N'b1286b23-1362-4c47-bc94-0549099e9393', N'001.JPJ', N'IFG001', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b470a928-e1c4-462b-ab3e-de6bab79c3b0', N'331f0c6e-c573-4b69-b6d2-a1e548794967', N'001.JPJ', N'45G001', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'38e6caa1-9515-4ec1-8f42-e487d37ba895', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', N'001.JPJ', N'IFG001', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'43532688-32f7-4e41-b06d-ebc98f0b2768', N'f2e604db-6317-4b08-805a-598c7881e821', N'001.JPJ', N'IFG45601', CAST(N'2019-05-08T20:42:09.710' AS DateTime), CAST(N'2021-01-01T00:00:00.000' AS DateTime), NULL, N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), NULL, CAST(N'2019-05-08T20:42:09.710' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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
INSERT([Id], [EmployeeId], [Document], [DocumentNumber], [IssuedDate], [ExpiryDate], [EligibleStatus], [CountryId], [EligibleReviewDate], [Comments], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [EmployeeId], [Document], [DocumentNumber], [IssuedDate], [ExpiryDate], [EligibleStatus], [CountryId], [EligibleReviewDate], [Comments], [ActiveFrom], [ActiveTo], [CreatedDateTime], [CreatedByUserId]);	   
 
MERGE INTO [dbo].[EmployeeContactDetails] AS Target 
USING ( VALUES 
  (N'12c2be00-3114-4464-a71c-0ea0e8213106', N'B1286B23-1362-4C47-BC94-0549099E9393', N'UK', N'SF Road', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'chaithu@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'Harish', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'84f66096-b2b2-4a09-b682-2a2ff608ac3c', N'91431ADF-309D-4C0A-86CE-0774AF22FF05', N'UK', N'SF Road', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'maria@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'Stish', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'69fd956d-0338-4ec7-b333-328f6dcde94f', N'906DE613-43BA-4563-AE6B-1F31512D0665', N'UK', N'SF Road', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'mahesh@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'sankar', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'adeb7265-7d10-4125-bdac-3bc01e6cf285', N'A841612D-894A-4539-ADAB-25F183B57315', N'UK', N'SF Road', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'jai@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'giridar', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'89f18584-7e58-4621-b176-7ee3a11133ef', N'30F6A3DD-D686-4F55-A3FC-473E5ED76976', N'UK', N'SF Road', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'prakash@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'Prasanna', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'6eb84f92-b1f4-4db4-96f7-8334f64fdd31', N'A3D2EA8F-046F-43D3-9F96-4773EB3FB225', N'UK', N'SF Road', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'abhi@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'Srihari', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'953fec21-d5e4-4bf9-b8d3-8c88053986c6', N'F2E604DB-6317-4B08-805A-598C7881E821', N'UK', N'SF Road', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'kishna@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'hari', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'8524368f-21d8-4e48-952d-9b69eb837f27', N'83E2DEEE-4943-4435-9CC9-5BE3204775F4', N'Ongole', N'anjayya roas', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'naveem@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'Srihari', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'bb9a85d8-11f0-43f7-aee1-a231db874bfa', N'331F0C6E-C573-4B69-B6D2-A1E548794967', N'London', N'london', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'suneel@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'Srihari', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971' )
, (N'08514ec4-3adc-463a-b7a7-a8715bd1deb4', N'7A5CEE67-75AC-40F7-BC1F-AA5608AF9F2F', N'US', N'nrth us', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'T@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'Srihari', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'777ea720-8549-439f-9446-c4fe94646583', N'B0D579BE-FD46-40F7-B3C6-C52393F2B1E9', N'Ongole', N'anjayya roas', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'T@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'kalyani', N'mother', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9dd8599b-cd82-4355-a6f2-f8b91e246c14', N'F7A58F30-EA2F-452D-96A6-DB023885B2B7', N'Hyderabad', N'Mytrivanam', N'500001', N'eafdf9c6-c4d2-42d0-86eb-4b70197ff1bb', NULL, N'123456789', NULL, N'T@gamil.com', N'a@gmail.com', N'28221d82-8890-4f11-9bea-535a269f9a8b', N'vamsi', N'Father', CAST(N'1992-02-01T00:00:00.000' AS DateTime), CAST(N'2019-05-08T21:08:53.870' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
) 
AS Source ([Id], [EmployeeId], [Address1], [Address2], [PostalCode], [CountryId], [HomeTelephoneno], [Mobile], [WorkTelephoneno], [WorkEmail], [OtherEmail], [StateId], [ContactPersonName], [Relationship], [DateOfBirth], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET 
           [EmployeeId] = Source.[EmployeeId],
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
		   [StateId] = Source.[StateId],
		   [ContactPersonName] = Source.[ContactPersonName],
		   [Relationship] = Source.[Relationship],
		   [DateOfBirth] = Source.[DateOfBirth]

WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [EmployeeId], [Address1], [Address2], [PostalCode], [CountryId], [HomeTelephoneno], [Mobile], [WorkTelephoneno], [WorkEmail], [OtherEmail], [StateId], [ContactPersonName], [Relationship], [DateOfBirth], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [EmployeeId], [Address1], [Address2], [PostalCode], [CountryId], [HomeTelephoneno], [Mobile], [WorkTelephoneno], [WorkEmail], [OtherEmail], [StateId], [ContactPersonName], [Relationship], [DateOfBirth], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[EmployeeDesignation] AS Target 
USING ( VALUES 
 (N'0a4f9c10-db36-4a26-9ef9-20f24da0e5ae', N'8E667960-30BB-401C-BA46-04855E8338AF', N'b1286b23-1362-4c47-bc94-0549099e9393', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'5fcfe05a-1c7f-42ad-b4f8-16db842dca8b', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'124b7731-08ab-4cff-93f7-500f283fb172', N'BAAB0072-5CE8-41FB-906D-238790B11D8A', N'a3d2ea8f-046f-43d3-9f96-4773eb3fb225', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'5fcfe05a-1c7f-42ad-b4f8-16db842dca8b', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'7b1eda29-15a2-406b-a0c3-5766b8508e60', N'13C2CA23-C733-4A80-A863-2F595A45F61A', N'b0d579be-fd46-40f7-b3c6-c52393f2b1e9', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'5fcfe05a-1c7f-42ad-b4f8-16db842dca8b', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'3f7a3049-92d3-4f36-889a-6d333d5c2db2', N'4FE44AB0-5A2D-4BB1-936C-4DE4B59C1AF6', N'a841612d-894a-4539-adab-25f183b57315', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'5fcfe05a-1c7f-42ad-b4f8-16db842dca8b', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'641a3b54-13fd-4532-a93f-6efd18a31506', N'6ABDF2FB-7B5E-4B03-9F6D-7D34F4B4E544', N'30f6a3dd-d686-4f55-a3fc-473e5ed76976', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'b11b4670-7782-4a8e-89c0-18613d542d5c', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'1e27d1f5-0d55-4375-9989-984fdd08046e', N'B3AD9C71-C061-449C-AEB2-5A942DCB5031', N'91431adf-309d-4c0a-86ce-0774af22ff05', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'b11b4670-7782-4a8e-89c0-18613d542d5c', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'45d97812-2ffb-40f9-a232-9cec9e6978f1', N'3CA7F983-7B24-44AF-B09C-842C3750082F', N'331f0c6e-c573-4b69-b6d2-a1e548794967', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'b11b4670-7782-4a8e-89c0-18613d542d5c', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'49f30233-6dc3-47dd-a8d2-ad05119c9c3c', N'52258648-A287-4A98-95F6-A7DEF3474431', N'83e2deee-4943-4435-9cc9-5be3204775f4', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'77fe372f-563b-48f3-9672-5b8209ed5314', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'fe35f0d0-4393-4c7b-a057-d9c6c3f2c196', N'07BF1621-EDC6-47C3-B8C4-8D8B60CF79E3', N'f2e604db-6317-4b08-805a-598c7881e821', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'77fe372f-563b-48f3-9672-5b8209ed5314', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'8dd04997-808f-4564-9608-e75462697ecf', N'66554F41-1131-493F-8E59-CDD080026D11', N'7a5cee67-75ac-40f7-bc1f-aa5608af9f2f', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'77fe372f-563b-48f3-9672-5b8209ed5314', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'75087e76-8daf-4ac5-8999-fa9da02b7403', N'D36F88CE-F2D4-4CA4-BF4A-DF30C7840C2D', N'f7a58f30-ea2f-452d-96a6-db023885b2b7', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'ad10cdad-a1f4-42fc-8af9-772a76e9f590', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
,(N'1b2820b5-7200-498b-8d69-fe3f8372d824', N'8AD63A99-FA7D-481F-80C5-DFB6FBC5041F', N'906de613-43ba-4563-ae6b-1f31512d0665', N'5DA1BE2D-C3AB-4A17-AE90-31C77DAC052A', N'ED204EF4-1727-4E1F-B545-4C145E7C1299', N'ad10cdad-a1f4-42fc-8af9-772a76e9f590', NULL, CAST(N'2021-04-01T00:00:00.000' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), NULL, CAST(N'2019-05-08T21:44:57.510' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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
	   
MERGE INTO [dbo].[PayGradeRate] AS Target 
USING ( VALUES 
 (N'2331e800-7a1e-4d55-b220-045944c639e2', N'2d807d99-a051-49b5-878a-b05853fb427d', N'3e9e9952-dbdd-4e9e-ba03-8eb25cebc1c7', CAST(N'2019-05-07T10:31:35.093' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'bbf015ab-68fb-4eec-8f39-1796540effbd', N'2d807d99-a051-49b5-878a-b05853fb427d', N'4ed62b55-31dd-4751-9d7a-efc386003570', CAST(N'2019-05-06T12:56:45.820' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-05-06T12:50:59.933' AS DateTime))
,(N'972d6fe7-3762-4e14-aecb-275fe5226012', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'79c51748-f6a4-4a96-ac80-847f75faf254', CAST(N'2019-05-06T12:50:59.933' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'd9bfaa9a-2e0d-4f33-856a-2cc062ca4047', N'2d807d99-a051-49b5-878a-b05853fb427d', N'458ab78a-b728-41fe-b9bb-3fa1fb16621c', CAST(N'2019-05-06T12:56:45.820' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'dd61e4a6-b32d-4932-ac63-4dd6d715e8dd', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'0514dfc9-542e-4241-b4ef-7e564ad0d9a7', CAST(N'2019-05-06T12:50:59.933' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'fdcb1549-d58f-4588-8d70-58857e915566', N'2d807d99-a051-49b5-878a-b05853fb427d', N'79c51748-f6a4-4a96-ac80-847f75faf254', CAST(N'2019-05-07T10:31:35.093' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-05-06T12:50:59.933' AS DateTime))
,(N'e3891bbf-71b3-48bb-b126-6a52bec6e0fc', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'3e9e9952-dbdd-4e9e-ba03-8eb25cebc1c7', CAST(N'2019-05-07T09:50:17.440' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'e8f5360e-1d0e-402d-8e27-7985fa89642c', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'4ed62b55-31dd-4751-9d7a-efc386003570', CAST(N'2019-05-07T09:50:17.440' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-05-06T12:50:59.933' AS DateTime))
,(N'9f2a2e85-b559-4a09-8bbc-7cd55073190f', N'2d807d99-a051-49b5-878a-b05853fb427d', N'0514dfc9-542e-4241-b4ef-7e564ad0d9a7', CAST(N'2019-05-07T10:31:35.093' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'1f4b9cdf-589a-4685-91c1-80d53dbe4ccd', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'79c51748-f6a4-4a96-ac80-847f75faf254', CAST(N'2019-05-07T09:50:17.440' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'25bde93f-3a3c-4b56-b535-8681fa95ea5c', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'458ab78a-b728-41fe-b9bb-3fa1fb16621c', CAST(N'2019-05-07T09:50:17.440' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'2fabcd03-621f-42b1-8c09-a01a250cc290', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'0514dfc9-542e-4241-b4ef-7e564ad0d9a7', CAST(N'2019-05-07T09:50:17.440' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'847b085d-151a-40b9-ba9b-a1808f9bec5a', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'4ed62b55-31dd-4751-9d7a-efc386003570', CAST(N'2019-05-06T12:50:59.933' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'f2759ee9-a559-4278-9c31-a8ecbb85183c', N'2d807d99-a051-49b5-878a-b05853fb427d', N'3e9e9952-dbdd-4e9e-ba03-8eb25cebc1c7', CAST(N'2019-05-06T12:56:45.820' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-05-06T12:50:59.933' AS DateTime))
,(N'5bcaf0e7-9711-4ded-a065-cc0678036a17', N'2d807d99-a051-49b5-878a-b05853fb427d', N'0514dfc9-542e-4241-b4ef-7e564ad0d9a7', CAST(N'2019-05-06T12:56:45.820' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'd38c09d2-9efb-406c-a8a9-d490cc124cb0', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'458ab78a-b728-41fe-b9bb-3fa1fb16621c', CAST(N'2019-05-06T12:50:59.933' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'5dc16230-b632-4897-ab86-d8524e4df67e', N'2d807d99-a051-49b5-878a-b05853fb427d', N'79c51748-f6a4-4a96-ac80-847f75faf254', CAST(N'2019-05-06T12:56:45.820' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'31153c51-9777-4e6b-9f3d-d921f105f8fb', N'2d807d99-a051-49b5-878a-b05853fb427d', N'4ed62b55-31dd-4751-9d7a-efc386003570', CAST(N'2019-05-07T10:31:35.093' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', CAST(N'2019-05-06T12:50:59.933' AS DateTime))
,(N'b80d7b07-292c-441c-b207-db322ca7d9a1', N'2d807d99-a051-49b5-878a-b05853fb427d', N'458ab78a-b728-41fe-b9bb-3fa1fb16621c', CAST(N'2019-05-07T10:31:35.093' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
,(N'b77039ae-28e6-4308-bee6-ecd348e5891b', N'80d56629-2c05-4d16-a25f-f1af9128cbc0', N'3e9e9952-dbdd-4e9e-ba03-8eb25cebc1c7', CAST(N'2019-05-06T12:50:59.933' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971', NULL)
) 
AS Source ([Id], [PayGradeId], [RateId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [PayGradeId]  = Source.[PayGradeId],
           [RateId] = Source.[RateId],
	       [InActiveDateTime] = Source.[InActiveDateTime],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [PayGradeId], [RateId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) VALUES ([Id], [PayGradeId], [RateId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]);	   

MERGE INTO [dbo].[FeedBackType] AS Target 
USING (VALUES 
		 (N'42C0960C-D162-4FEA-B985-F24D8CF79F75',N'4AFEB444-E826-4F95-AC41-2175E36A0C16','Compnay',CAST(N'2018-03-01T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'EADE1575-B43F-4E98-ABFF-5875532F59CB',N'4AFEB444-E826-4F95-AC41-2175E36A0C16','Employee',CAST(N'2018-03-01T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971'),
		(N'FA3ABE1D-EFA1-4861-A7A0-8B951BA438BF',N'4AFEB444-E826-4F95-AC41-2175E36A0C16','Maintenance',CAST(N'2018-03-01T00:00:00.000' AS DateTime), N'127133F1-4427-4149-9DD6-B02E0E036971')
)
AS Source ([Id],[CompanyId],[FeedBackTypeName],[CreatedDateTime],[CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId]  = Source.[CompanyId],
		   [FeedBackTypeName] = Source.[FeedBackTypeName],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[CompanyId],[FeedBackTypeName],[CreatedDateTime],[CreatedByUserId]) VALUES ([Id],[CompanyId],[FeedBackTypeName],[CreatedDateTime],[CreatedByUserId]);

MERGE INTO [dbo].[Permission] AS Target 
USING ( VALUES 
		(N'2E59F1AF-FE0B-4C5C-B3C4-16FCD4725F44', N'127133F1-4427-4149-9DD6-B02E0E036971','2019-04-18',0,0,NULL,N'734F000C-8035-4A15-8E51-9FF13462B80D','01:00:01.533',60,1,'2019-04-17 16:56:18.533',N'127133F1-4427-4149-9DD6-B02E0E036971')
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

MERGE INTO [dbo].LeaveApplication AS Target 
USING ( VALUES 
		(N'BB3EA960-9F77-490B-9C58-F097F4690A95',N'127133F1-4427-4149-9DD6-B02E0E036971','2019-04-19',NULL,'D2184B73-FD09-460B-9B13-81600A0C8084','2019-04-19','2019-04-19',0,NULL,'3C6F106A-160F-4644-86B8-6214123ACA0E',NULL,CAST(N'2019-04-19 10:17:58.240' AS DateTime),'127133F1-4427-4149-9DD6-B02E0E036971')
	  )

AS Source ([Id],[UserId],[LeaveAppliedDate],[LeaveReason],[LeaveTypeId],[LeaveDateFrom],[LeaveDateTo],[IsDeleted],[OverallLeaveStatusId],[FromLeaveSessionId],[ToLeaveSessionId],[CreatedDateTime],[CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [UserId] = Source.[UserId],
           [LeaveAppliedDate] = Source.[LeaveAppliedDate],
		   [LeaveReason] = Source.[LeaveReason],
		   [LeaveTypeId] = Source.[LeaveTypeId],
		   [LeaveDateFrom] = Source.[LeaveDateFrom],
		   [LeaveDateTo] = Source.[LeaveDateTo],
		   [IsDeleted] = Source.[IsDeleted],
		   [OverallLeaveStatusId] = Source.[OverallLeaveStatusId],
		   [FromLeaveSessionId] = Source.[FromLeaveSessionId],
		   [ToLeaveSessionId] = Source.[ToLeaveSessionId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id],[UserId],[LeaveAppliedDate],[LeaveReason],[LeaveTypeId],[LeaveDateFrom],[LeaveDateTo],[IsDeleted],[OverallLeaveStatusId],[FromLeaveSessionId],[ToLeaveSessionId],[CreatedDateTime],[CreatedByUserId]) VALUES ([Id],[UserId],[LeaveAppliedDate],[LeaveReason],[LeaveTypeId],[LeaveDateFrom],[LeaveDateTo],[IsDeleted],[OverallLeaveStatusId],[FromLeaveSessionId],[ToLeaveSessionId],[CreatedDateTime],[CreatedByUserId]);

MERGE INTO [dbo].[WorkflowEligibleStatusTransition] AS Target 
USING ( VALUES 
		 (N'5bc6f15a-2bd6-434f-9e94-05d23dd7bea6', N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', N'4b959ca8-1b72-45c0-9199-1b274b099860', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'2325ca68-8ac3-4f2e-b5b6-0b2f4c8d6a26', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', N'47332259-7d32-479d-a704-569c00f2b0b3', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'dd9db945-a190-43cb-ad43-0d01d0776884', N'e1418ce8-a51b-4de5-aff3-42f8a588e3ae', N'7503dace-d75a-4df1-b687-64334263b908', N'D', NULL, N'e36ca831-a26e-414d-80cf-8c340cc3b395', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'45ff1c27-d9d0-47c2-83bb-14d14979b4ed', N'4b959ca8-1b72-45c0-9199-1b274b099860', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'71ce75a8-94a4-44da-8325-1fd57d376964', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', N'4b959ca8-1b72-45c0-9199-1b274b099860', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'4033d021-5321-46a7-a518-38ee2feea62b', N'4b959ca8-1b72-45c0-9199-1b274b099860', N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'a5be01ec-dd53-4bf3-9cd2-3d29498197a7', N'47332259-7d32-479d-a704-569c00f2b0b3', N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'3dc093a0-d65c-4ed0-bef5-41ff72b7d653', N'b3b17186-6d07-4416-878d-f78a73a753fc', N'47332259-7d32-479d-a704-569c00f2b0b3', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'b2480923-0394-4d97-9498-42ade3ad3fb9', N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', N'47332259-7d32-479d-a704-569c00f2b0b3', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'61e3007b-a0c9-4ca7-8c7d-54bc1961883b', N'4b959ca8-1b72-45c0-9199-1b274b099860', N'47332259-7d32-479d-a704-569c00f2b0b3', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'893f5e80-8983-4431-a651-5a338f5e3b0e', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', N'b3b17186-6d07-4416-878d-f78a73a753fc', N'Nearest([Saturday, Wednesday], D) +2', NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'edaf36ff-d740-4b1a-891b-5e32663cba6d', N'b3b17186-6d07-4416-878d-f78a73a753fc', N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'9f2adbff-6386-490b-8574-64a6ff1ac693', N'67260e91-cdef-41d0-aebc-c48fd4de814d', N'4b959ca8-1b72-45c0-9199-1b274b099860', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'7ed3ac10-7cc0-4bdf-95b1-74e838eb1fac', N'4b959ca8-1b72-45c0-9199-1b274b099860', N'd348204e-a7d4-40c1-a5ad-7a667d8f4216', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'ac96a178-060c-4377-bec3-7611c669984d', N'4b959ca8-1b72-45c0-9199-1b274b099860', N'b3b17186-6d07-4416-878d-f78a73a753fc', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'6fefed10-d75d-48f2-952e-77e7aad3762d', N'd348204e-a7d4-40c1-a5ad-7a667d8f4216', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'f3ac4083-b752-43c7-835b-82284cda78e2', N'b3b17186-6d07-4416-878d-f78a73a753fc', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'61965af4-afc3-464a-85f7-8b9a532dd44c', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'cf98ef06-18b8-46b8-be42-9144916eefdf', N'd348204e-a7d4-40c1-a5ad-7a667d8f4216', N'b3b17186-6d07-4416-878d-f78a73a753fc', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'06cfebc5-4483-4dcd-8383-920aa3a531e0', N'7503dace-d75a-4df1-b687-64334263b908', N'e1418ce8-a51b-4de5-aff3-42f8a588e3ae', NULL, NULL, N'e36ca831-a26e-414d-80cf-8c340cc3b395', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'b278b9e6-7214-4239-81d8-9d5cb048de34', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', N'47332259-7d32-479d-a704-569c00f2b0b3', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'd82a7034-874b-4ecd-b7d6-9e8fd2c2a2ca', N'47332259-7d32-479d-a704-569c00f2b0b3', N'4b959ca8-1b72-45c0-9199-1b274b099860', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'1ee1a9d2-84c2-4d1a-a61a-aeaacd94871d', N'4b959ca8-1b72-45c0-9199-1b274b099860', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'3c252585-c15c-4812-a31c-af2a1b306074', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', N'Nearest([Saturday, Wednesday], D)', NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'8a82dfe3-f038-4dbd-aa39-b00d49db4450', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'b018ad62-3295-4071-b99e-b23a5af8703c', N'47332259-7d32-479d-a704-569c00f2b0b3', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', N'D', NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'6cd62a77-cd8c-49ac-92af-baf53be9eede', N'67260e91-cdef-41d0-aebc-c48fd4de814d', N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'689c3ac0-7e81-4250-b1bf-bb3b0cc34d61', N'b3b17186-6d07-4416-878d-f78a73a753fc', N'4b959ca8-1b72-45c0-9199-1b274b099860', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'5751f5c1-3977-4ba5-ae25-cffd0542ac46', N'd348204e-a7d4-40c1-a5ad-7a667d8f4216', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'bc5f7d13-baa1-4d35-a861-de64d3b16f17', N'67260e91-cdef-41d0-aebc-c48fd4de814d', N'e1418ce8-a51b-4de5-aff3-42f8a588e3ae', NULL, NULL, N'e36ca831-a26e-414d-80cf-8c340cc3b395', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'b143280c-f4b9-4f28-b5aa-e3362c2374d3', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', N'4b959ca8-1b72-45c0-9199-1b274b099860', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'592ff211-59b1-4e9c-839f-ef4b0d680e59', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'aa75b25b-c7c2-4dfb-9622-fb7d90abc9d4', N'b3b17186-6d07-4416-878d-f78a73a753fc', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'cca6915c-0d75-42c5-8623-fe70c64a9031', N'd348204e-a7d4-40c1-a5ad-7a667d8f4216', N'47332259-7d32-479d-a704-569c00f2b0b3', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'19838854-379e-453a-b48f-fecc4079ca7b', N'd348204e-a7d4-40c1-a5ad-7a667d8f4216', N'16ba9fd4-aa96-4b6c-909c-488ca4d4e9fd', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'1491a48d-755f-42b7-8994-fee370911a56', N'b3b17186-6d07-4416-878d-f78a73a753fc', N'd348204e-a7d4-40c1-a5ad-7a667d8f4216', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'D5E6066E-F522-4871-B86D-25B316EFC566', N'E1418CE8-A51B-4DE5-AFF3-42F8A588E3AE', N'A199BC2B-FD31-45C7-BE83-1092C2A53AC5', NULL, NULL, N'029E3CE3-2D85-4956-BF78-C86C4DA8E217', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'D397B345-BF43-47D9-85D6-4C6C65086FED', N'A199BC2B-FD31-45C7-BE83-1092C2A53AC5', N'A50D34C9-F1C5-41B3-A9B9-63759FA3446F', NULL, NULL, N'029E3CE3-2D85-4956-BF78-C86C4DA8E217', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'3EF0C723-B6C1-4E43-8DFB-C3C87D1DC540', N'A199BC2B-FD31-45C7-BE83-1092C2A53AC5', N'E1418CE8-A51B-4DE5-AFF3-42F8A588E3AE', NULL, NULL, N'029E3CE3-2D85-4956-BF78-C86C4DA8E217', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'D552B2AF-FF59-42DB-9AE2-F0B17171C22F', N'A199BC2B-FD31-45C7-BE83-1092C2A53AC5', N'C6E85DA3-649B-45FF-83B0-3C127BDD7712', NULL, NULL, N'029E3CE3-2D85-4956-BF78-C86C4DA8E217', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'984C73CB-308E-40C9-AEA3-4383DC2515DF', N'A50D34C9-F1C5-41B3-A9B9-63759FA3446F', N'E1418CE8-A51B-4DE5-AFF3-42F8A588E3AE', NULL, NULL, N'029E3CE3-2D85-4956-BF78-C86C4DA8E217', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'9DA46471-0988-4BCB-9FD6-BA353F5D7FA6', N'733bfb1b-ef72-4586-9c09-ab9d4ad296d5', N'6D74145A-AF62-4AF0-B786-802247A7D593', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'389D1F39-E507-46BA-813E-9C64C4CA4CFD', N'6D74145A-AF62-4AF0-B786-802247A7D593', N'bc978f0d-6a8b-450f-85ae-e88ba37b06a2', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
		,(N'6356AD23-0EFB-4AD6-9C72-28507EC26EF7', N'6D74145A-AF62-4AF0-B786-802247A7D593', N'47332259-7d32-479d-a704-569c00f2b0b3', NULL, NULL, N'b7a0a6e4-fa8f-4600-894d-0c66d89456d9', CAST(N'2018-08-13T06:15:46.710' AS DateTime), N'd6e5fce3-1d48-41e1-b712-72af2c3e9ec3')
)
AS Source ([Id], [FromWorkflowUserStoryStatusId], [ToWorkflowUserStoryStatusId], [Deadline], [DisplayName], [WorkflowId], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [FromWorkflowUserStoryStatusId] = Source.[FromWorkflowUserStoryStatusId],
	       [ToWorkflowUserStoryStatusId] = Source.[ToWorkflowUserStoryStatusId],
	       [Deadline] = Source.[Deadline],
	       [DisplayName] = Source.[DisplayName],
	       [WorkflowId] = Source.[WorkflowId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [FromWorkflowUserStoryStatusId], [ToWorkflowUserStoryStatusId], [Deadline], [DisplayName], [WorkflowId], [CreatedDateTime], [CreatedByUserId])
VALUES ([Id], [FromWorkflowUserStoryStatusId], [ToWorkflowUserStoryStatusId], [Deadline], [DisplayName], [WorkflowId], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[TimeSheetHistory] AS Target 
USING ( VALUES 
		 (N'77BF0FB4-54B5-4F7C-AE55-065E3441B7F3', N'4829CC3A-0DD3-4F99-9A7C-014AD4239BF5', N'4880E839-E8A9-48A2-9515-075569F619E0', NULL, N'2019-07-10T00:00:00.000', N'InTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'B31A1EDD-9BA4-4401-87D8-5B0570928081', N'2E996097-334D-439A-A3E4-06055BC76175', N'0EF2DD9F-FB1C-4DA9-BBA5-0A17EAFB9AEC', NULL, N'2019-06-17T04:12:42.210', N'OutTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'D9528258-26EF-4736-92E3-0131B05044DD', N'21F7B83C-80CA-4F0E-AC16-06EBF152205C', N'EBB03E30-803B-4C6D-8D50-0DB166834BB1', NULL, N'2019-07-14T06:15:45:425', N'LunchBreakStartTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'B5BA648F-392F-4580-8F53-A5DA1A2D81CD', N'9D73FD2F-506D-414C-9662-081971E07851', N'62B11C9A-FAB2-4997-B3DA-103789B33CA2', NULL, N'2019-07-14T07:15:32:564', N'LunchBreakEndTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'A1FB0088-0A4E-4A2D-8F62-C82A9BA8300A', N'F871A055-60BB-4813-8419-087B56765B0D', N'D7D6348C-988D-4383-BF83-11F5238A1FE3', NULL, N'2019-07-14T08:25:45:215', N'InTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'B5EB9ECC-FE14-4995-A8E2-600E0D0CE758', N'E26C3A5D-0A50-4996-B3C4-09CC3AF026AC', N'A0ABCBD0-FC1C-4837-8F62-506CF23F6C88', NULL, N'2019-02-14T03:05:51:105', N'OutTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'A3E5B153-C0A6-4144-B4A3-EC1C482CDD8A', N'51739426-D656-480B-B9AA-0BCA39C2FA73', N'771DEBCD-315C-4AA9-96C0-66726C6A0EF3', NULL, N'2019-06-21T08:25:45:215', N'LunchBreakStartTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'0BD0F7F8-0F88-4B23-BAD3-D78BEF924EB2', N'D24EF264-5BE4-4D2A-BA76-0C28595533B7', N'45BD60EA-CD85-4F86-927F-75D7207F28AB', NULL, N'2019-07-17T10:23:34:000', N'LunchBreakEndTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'AB9E2A21-7E25-4395-B5DB-9A0CF9412F92', N'0D1542EC-E93D-4D62-9332-1322C5DD99A6', N'E715EB0E-BFFB-4759-8375-8853B8D1526B', NULL, N'2019-09-04T01:14:51:325', N'InTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'8F8B8FF7-C2B2-4E17-8527-7508C1B03AC6', N'1144748D-199B-4DBD-9661-1725C0289C97', N'A989BBC0-805A-4D2B-AB3D-94ED50A8E329', NULL, N'2019-11-24T11:25:40:221', N'OutTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'017BFE30-D8E4-4721-9D08-C9361233C819', N'2FFBB393-5350-4CDE-B90C-1B1BD76D156F', N'ABC3A16A-E604-4CEF-838E-A39ABE86DE10', NULL, N'2019-02-26T06:34:15:352', N'LunchBreakStartTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'34262865-A86C-48D5-AA4D-374C6793A2BB', N'509BD9F8-C6ED-4089-9410-230623C05706', N'3B63F9A2-CFEF-4507-A43F-A40F5F7F1600', NULL, N'2019-08-30T04:21:47:220', N'LunchBreakEndTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'6A97D3DD-B75E-4946-8F62-C2300AB56A62', N'5C44258B-C8AA-42C5-A391-291D09C963B4', N'27709B30-8544-4976-AF96-AD28CD01B07B', NULL, N'2019-04-24T08:25:45:215', N'InTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'FD1FFA41-6456-49BA-8756-DC74F37D21B1', N'D7F4AFE1-C566-48EB-BE62-3127183DCF2A', N'DCA3ABAD-6A18-40F4-8673-BBC514AB1CCD', NULL, N'2019-03-14T08:25:45:215', N'OutTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'0C61B6EC-48C6-49CB-8893-F38CF2BFAE9A', N'BB28EAF9-7934-463D-9B8B-406E0F66E023', N'A7AD00E8-344E-4FE1-9800-BE9551BAA54A', NULL, N'2019-09-16T08:25:45:215', N'LunchBreakStartTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'A14916F1-C841-4634-B7AE-A8F1D92249C7', N'9B457BC0-A040-4F14-8228-46DB216E172E', N'457773D4-F21C-4A6A-8B7F-C806BD2EF3EB', NULL, N'2019-04-29T08:25:45:215', N'LunchBreakEndTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'4CDA6139-7333-4AEE-8F30-7C0C8EEC89A1', N'1F3BD063-B36E-462E-A68C-4E3781FF2E30', N'5CFD2171-26B2-4C14-9F29-D085B12C7A3E', NULL, N'2019-06-14T08:25:45:215', N'InTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'AB42761A-4291-4A34-9779-A007B84FF402', N'FF3DE312-1F02-4087-B08D-58A8D8A8B8AF', N'FE4678B9-8E36-42B0-8E58-E2732C2DA9A0', NULL, N'2019-01-31T08:25:45:215', N'OutTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'5666DD33-3977-4524-A0AF-4EAB4A5FAC91', N'7B89B4DB-F90C-4162-9EE4-5CAF95D19C68', N'B5C52B1B-89E6-4364-8DD7-E85B970B1631', NULL, N'2019-06-14T08:25:45:215', N'LunchBreakStartTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		,(N'9D857344-EFD6-421E-BE2E-E90BADD09809', N'75E7D77B-8AE2-4BFA-A086-5CB89D3A2018', N'A6FCE96A-AE8C-4FCA-A0F8-F76CA1E94157', NULL, N'2019-01-24T08:25:45:215', N'LunchBreakEndTime', CAST(N'2019-06-11T00:00:00.000' AS DateTime), N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
)
AS Source ([Id], [TimeSheetid], [UserBreakid], [OldValue], [NewValue], [FieldName], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [TimeSheetId] = Source.[TimeSheetId],	
		   [UserBreakid] = Source.[UserBreakId],
		   [OldValue] = Source.[OldValue],
		   [NewValue] = Source.[NewValue],
		   [FieldName] = Source.[FieldName],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [TimeSheetid], [UserBreakid], [OldValue], [NewValue], [FieldName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [TimeSheetid], [UserBreakid], [OldValue], [NewValue], [FieldName], [CreatedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[UserBreak] AS Target 
USING ( VALUES 
			 (N'771DEBCD-315C-4AA9-96C0-66726C6A0EF3', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
		    ,(N'A7AD00E8-344E-4FE1-9800-BE9551BAA54A', N'5E22E01A-BF81-46C5-8A64-600600E0313D', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'A989BBC0-805A-4D2B-AB3D-94ED50A8E329', N'0B2921A9-E930-4013-9047-670B5352F308', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'5CFD2171-26B2-4C14-9F29-D085B12C7A3E', N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'0EF2DD9F-FB1C-4DA9-BBA5-0A17EAFB9AEC', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'62B11C9A-FAB2-4997-B3DA-103789B33CA2', N'E38B057F-AA4E-4E63-B10A-74AA252AA004', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'EBB03E30-803B-4C6D-8D50-0DB166834BB1', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'FE4678B9-8E36-42B0-8E58-E2732C2DA9A0', N'0019AF86-8618-4F46-9DFA-A41D9E98275F', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'A0ABCBD0-FC1C-4837-8F62-506CF23F6C88', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'27709B30-8544-4976-AF96-AD28CD01B07B', N'127133F1-4427-4149-9DD6-B02E0E036971', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'ABC3A16A-E604-4CEF-838E-A39ABE86DE10', N'127133F1-4427-4149-9DD6-B02E0E036972', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'3B63F9A2-CFEF-4507-A43F-A40F5F7F1600', N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'45BD60EA-CD85-4F86-927F-75D7207F28AB', N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'DCA3ABAD-6A18-40F4-8673-BBC514AB1CCD', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'D7D6348C-988D-4383-BF83-11F5238A1FE3', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'457773D4-F21C-4A6A-8B7F-C806BD2EF3EB', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'A6FCE96A-AE8C-4FCA-A0F8-F76CA1E94157', N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'E715EB0E-BFFB-4759-8375-8853B8D1526B', N'0019AF86-8618-4F46-9DFA-A41D9E98275F', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'B5C52B1B-89E6-4364-8DD7-E85B970B1631', N'0B2921A9-E930-4013-9047-670B5352F308', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
			,(N'4880E839-E8A9-48A2-9515-075569F619E0', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'2019-01-15', 0, N'2019-01-15T06:43:00.000', N'2019-01-15T06:53:00.000', N'4EB441D2-3074-49BB-B776-14C93FCD8F2E')
)
AS Source ([Id], [UserId], [Date], [IsOfficeBreak], [BreakIn], [BreakOut], [BreakTypeId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserId] = Source.[UserId],
		   [Date] = Source.[Date],
		   [IsOfficeBreak] = Source.[IsOfficeBreak],
		   [BreakIn] = Source.[BreakIn], 
		   [BreakOut] = Source.[BreakOut],
		   [BreakTypeId] = Source.[BreakTypeId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [UserId], [Date], [IsOfficeBreak], [BreakIn], [BreakOut], [BreakTypeId]) values([Id], [UserId], [Date], [IsOfficeBreak], [BreakIn], [BreakOut], [BreakTypeId]);

MERGE INTO [dbo].[Message] AS Target 
USING ( VALUES 
			(N'17C928C6-D458-46C4-8DFB-8356DF5FCC25', N'419FD248-297A-4F0A-B7C7-1451AE94F94A', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'2019-07-10T11:21:54.245')
		   ,(N'C1B86E90-EB77-475E-BA88-B52E946F8AB9', N'249F7038-77AC-45C8-80DD-14F7DA48305D', N'5E22E01A-BF81-46C5-8A64-600600E0313D', N'0019AF86-8618-4F46-9DFA-A41D9E98275F', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'5E22E01A-BF81-46C5-8A64-600600E0313D', N'2019-07-10T11:21:54.245')
		   ,(N'1082F3A3-A0A3-4AFA-868F-C190F52E7CCD', N'CB97B839-09EE-41E3-A931-2CA2D1BA972F', N'0B2921A9-E930-4013-9047-670B5352F308', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', N'0CCE225B-51C8-4517-82F7-8B6BB5C108CD', NULL, N'0B2921A9-E930-4013-9047-670B5352F308', N'2019-07-10T11:21:54.245')
		   ,(N'69303060-C19D-4BF3-92D2-B15295A793FB', N'4D38F882-D612-455E-9C73-2E400E2FB5B2', N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', N'127133F1-4427-4149-9DD6-B02E0E036971', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', N'2019-07-10T11:21:54.245')
		   ,(N'FD258D12-6BF1-4FE0-9CED-8EE91DA1DE09', N'03BE2A26-EF55-452B-BC84-44A2152F5A45', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', N'127133F1-4427-4149-9DD6-B02E0E036972', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', N'2019-07-10T11:21:54.245')
		   ,(N'EB373036-38A4-41F9-80A0-89096B3067AC', N'C3314C8A-743A-432D-8071-4798088AF11B', N'E38B057F-AA4E-4E63-B10A-74AA252AA004', N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', N'0CCE225B-51C8-4517-82F7-8B6BB5C108CD', NULL, N'E38B057F-AA4E-4E63-B10A-74AA252AA004', N'2019-07-10T11:21:54.245')
		   ,(N'03792EFD-A139-4766-84B2-CE5F116B8C7D', N'A575F96A-55AE-4561-90EC-5897BAE41582', N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'2019-07-10T11:21:54.245')
		   ,(N'54F0DBAB-87B0-4DAC-993A-54B6E466565F', N'E026D8CB-DC9C-432B-84EE-6A525F3ABBD6', N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', N'5E22E01A-BF81-46C5-8A64-600600E0313D', N'0CCE225B-51C8-4517-82F7-8B6BB5C108CD', NULL, N'0019AF86-8618-4F46-9DFA-A41D9E98275F', N'2019-07-10T11:21:54.245')
		   ,(N'7A00A03C-F91F-407C-917B-0891C9597F60', N'0625A40C-7FC9-4241-B139-7DB451E6E181', N'127133F1-4427-4149-9DD6-B02E0E036971', N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', N'2019-07-10T11:21:54.245')
		   ,(N'A74EAD32-9D91-4AEF-BADE-311AF92DB45F', N'9D459667-1704-4BC4-8545-8257C3C7BFEF', N'0019AF86-8618-4F46-9DFA-A41D9E98275F', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'127133F1-4427-4149-9DD6-B02E0E036971', N'2019-07-10T11:21:54.245')
		   ,(N'0E225282-5B3A-4BC3-9BFB-850CE18E64B0', N'E84A8512-E21B-4168-9B04-86DBF69DACF7', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', N'0B2921A9-E930-4013-9047-670B5352F308', N'0CCE225B-51C8-4517-82F7-8B6BB5C108CD', NULL, N'127133F1-4427-4149-9DD6-B02E0E036972', N'2019-07-10T11:21:54.245')
		   ,(N'557F2319-F3A7-4D38-BF44-1A7BAA3E7EF8', N'F8D8A81D-4FB9-4CA6-91C6-883C44CD1996', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'127133F1-4427-4149-9DD6-B02E0E036971', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', N'2019-07-10T11:21:54.245')
		   ,(N'BED81302-AB50-472F-A5BD-D1EAF23304C2', N'26ACAC1F-D83B-40D8-BFA2-B02F6534F056', N'0019AF86-8618-4F46-9DFA-A41D9E98275F', N'0B2921A9-E930-4013-9047-670B5352F308', N'0CCE225B-51C8-4517-82F7-8B6BB5C108CD', NULL, N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', N'2019-07-10T11:21:54.245')
		   ,(N'78D4CFB2-18B7-4246-A380-1375368F9398', N'7B2BCAC0-CA22-43A8-B40C-B5A49AF1A13A', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', N'2019-07-10T11:21:54.245')
		   ,(N'12E3661C-EDB9-48EC-9591-CFA1A3803F43', N'A63F7EE3-D550-4EA4-8962-C78CFBCD5C55', N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', N'5E22E01A-BF81-46C5-8A64-600600E0313D', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'127133F1-4427-4149-9DD6-B02E0E036971', N'2019-07-10T11:21:54.245')
		   ,(N'E1918BB5-25C6-4BEB-AC0A-BFF6E293C299', N'2EF93F0C-CEC9-4FC8-A761-D1B4B62C6CFF', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'127133F1-4427-4149-9DD6-B02E0E036971', N'0CCE225B-51C8-4517-82F7-8B6BB5C108CD', NULL, N'0B2921A9-E930-4013-9047-670B5352F308', N'2019-07-10T11:21:54.245')
		   ,(N'23AF5503-C696-48FA-BE80-FA6A2AF071CD', N'468FCDE2-C855-421D-9B18-DCF8DF9DB89D', N'127133F1-4427-4149-9DD6-B02E0E036971', N'5E22E01A-BF81-46C5-8A64-600600E0313D', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', N'2019-07-10T11:21:54.245')
		   ,(N'6593C6A6-A6B9-4F37-BFBB-4F0A3AA33A41', N'5642CD33-5324-47F6-901A-E6ACEDCB3C16', N'E38B057F-AA4E-4E63-B10A-74AA252AA004', N'127133F1-4427-4149-9DD6-B02E0E036972', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'2019-07-10T11:21:54.245')
		   ,(N'F9D107A1-5745-40DF-ABBF-A6B644A7BA9E', N'25279882-570F-4DAD-A82F-F3AC75DA9D38', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', N'0B2921A9-E930-4013-9047-670B5352F308', N'0CCE225B-51C8-4517-82F7-8B6BB5C108CD', NULL, N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'2019-07-10T11:21:54.245')
		   ,(N'85268BE9-1295-4F6F-9E6D-E79D887716F1', N'F2F8569D-37F4-4FD2-8B0A-FAD8DEADB4EA', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'0B2921A9-E930-4013-9047-670B5352F308', N'08F69869-D9B9-47E6-920A-49E6C773A76B', NULL, N'127133F1-4427-4149-9DD6-B02E0E036971', N'2019-07-10T11:21:54.245')
)
AS Source ([Id], [ChannelId], [SenderUserId], [ReceiverUserId], [MessageTypeId], [TextMessage], [CreatedByUserId], [CreatedDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [ChannelId] = Source.[ChannelId],
		   [SenderUserId] = Source.[SenderUserId],
		   [ReceiverUserId] = Source.[ReceiverUserId],
		   [MessageTypeId] = Source.[MessageTypeId],
		   [TextMessage] = Source.[TextMessage],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [CreatedDateTime] = Source.[CreatedDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [ChannelId], [SenderUserId], [ReceiverUserId], [MessageTypeId], [TextMessage], [CreatedByUserId], [CreatedDateTime]) VALUES ([Id], [ChannelId], [SenderUserId], [ReceiverUserId], [MessageTypeId], [TextMessage], [CreatedByUserId], [CreatedDateTime]);

MERGE INTO [dbo].[UserFcmDetails] AS Target 
USING ( VALUES 
			(N'3B1A6D35-BF4C-4310-93E8-9DDEED04CD88', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'Test', N'2019-07-11T01:23:54.248')
		   ,(N'D4CA89E9-8C40-4D26-B49A-73268DDFDA00', N'5E22E01A-BF81-46C5-8A64-600600E0313D', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'36350AAE-EA5B-4F49-AB1D-E9A750362877', N'0B2921A9-E930-4013-9047-670B5352F308', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'FA9807E7-CE1C-437F-918F-66B613EAB12A', N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'650B1FA6-B45E-4EA1-99DC-A6EA9F7EA8C3', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'9F7DC0F8-9AE3-46B8-B6C4-5F1715E774ED', N'E38B057F-AA4E-4E63-B10A-74AA252AA004', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'283E017A-4C0F-4177-9171-BEC8BAC813BC', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'AC53D55B-32BF-4E44-8B35-3741E234EA74', N'0019AF86-8618-4F46-9DFA-A41D9E98275F', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'321B37A8-792B-45BD-8E8C-7D401120A9D6', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'8E89A403-92D5-4977-9BB3-3B71CED536CC', N'127133F1-4427-4149-9DD6-B02E0E036971', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'A1E2C726-3200-4CAA-98FE-C2464C31F2B4', N'127133F1-4427-4149-9DD6-B02E0E036972', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'77CFBA25-1D69-496F-996E-CEEDE912165B', N'000D7682-E46D-48C6-B7D8-B6509FABB3C0', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'0ABB562D-B743-4A81-A763-2F309AF592D5', N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'E2232420-3271-4863-9F43-1403B7C33698', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'CB31F084-5066-4F80-8BB1-E5DC8D753700', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'5E25D57B-120F-4E4E-842C-EA44A71ED11E', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'6B060356-06FF-49FE-A20B-FC17AEB9A228', N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'5EF6D95A-3CF6-4F49-9BCF-A4C0D412431F', N'0B2921A9-E930-4013-9047-670B5352F308', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'3BAE6D54-42E0-4983-8A94-CCF0B14566CD', N'0019AF86-8618-4F46-9DFA-A41D9E98275F', N'Test',N'2019-07-11T01:23:54.248')
		   ,(N'E816CDEE-7B45-4F2C-BD78-B8E496E6000A', N'127133F1-4427-4149-9DD6-B02E0E036972', N'Test',N'2019-07-11T01:23:54.248')
)
AS Source ([Id], [UserId], [FcmToken], [CreatedDateTime])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [UserId] = Source.[UserId],
		   [FcmToken] = Source.[FcmToken],
		   [CreatedDateTime] = Source.[CreatedDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [UserId], [FcmToken], [CreatedDateTime]) VALUES ([Id], [UserId], [FcmToken], [CreatedDateTime]);
		    
MERGE INTO [dbo].[ProcessDashboard] AS Target 
USING ( VALUES
			(N'E8AE98B4-FA17-410F-AD15-D73350D53A0D', N'05BB6D88-AFD2-4C3F-AE30-075F561FFF2B', 1, N'2019-07-11T05:32:23.222', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		   ,(N'19AA3196-37E8-4322-BDFB-0E70A23953F0', N'5142C4AA-B831-403D-AE98-07C9398DE111', 1, N'2019-07-11T05:32:23.222', N'127133F1-4427-4149-9DD6-B02E0E036971')
		   ,(N'39AD5977-9CD6-48C5-90AA-8E5EAD92028F', N'E3ADACA0-B8C9-41B4-B0D5-09EE60B12F20', 1, N'2019-07-11T05:32:23.222', N'1C90BBEB-D85D-4BFB-97F5-48626F6CEB27')
		   ,(N'0DAEDEFC-4364-4246-875E-9AC01802ADD1', N'4B34D328-9401-43B6-BE50-0B1916A3865C', 1, N'2019-07-11T05:32:23.222', N'5E22E01A-BF81-46C5-8A64-600600E0313D')
		   ,(N'E39F4AFB-F6D3-4BB9-9AD2-963572F9832B', N'01FBFB3F-16F7-46B1-9503-2597763CE685', 1, N'2019-07-11T05:32:23.222', N'0B2921A9-E930-4013-9047-670B5352F308')
		   ,(N'2549D379-9077-4CD1-B942-B5CA47B65132', N'E31EEED8-9048-4F4E-B8DA-2D57CA535778', 1, N'2019-07-11T05:32:23.222', N'DB9458B5-D28B-4DD5-A059-69EEA129DF6E')
		   ,(N'89CEE3B3-6D74-4329-B1F7-B8A83C9C5016', N'A2311594-5D75-4A72-AA26-377C0A587487', 1, N'2019-07-11T05:32:23.222', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F')
		   ,(N'E76040B3-6A65-43B9-B3EB-E7ED48A45998', N'C4B73DC1-D186-4F6A-9B43-40E20BE078E1', 1, N'2019-07-11T05:32:23.222', N'E38B057F-AA4E-4E63-B10A-74AA252AA004')
		   ,(N'EC06EB03-C5E0-41E7-846B-7C3B4AA43B03', N'4F6AD92E-38A2-46D0-B16B-46EC51E0666D', 1, N'2019-07-11T05:32:23.222', N'0019AF86-8618-4F46-9DFA-A41D9E98275F')
		   ,(N'D402CEE0-74EC-4520-8467-AB119926893A', N'037E41B7-AEE6-4171-A8E7-4878AE0F82FD', 1, N'2019-07-11T05:32:23.222', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64')
		   ,(N'86C8F872-9ACF-40A7-AE3F-23E36DB6C576', N'FF4047B8-39B1-42D2-8910-4E60ED38AAC7', 1, N'2019-07-11T05:32:23.222', N'127133F1-4427-4149-9DD6-B02E0E036972')
		   ,(N'80E61575-058F-4D7A-B0EB-2AE471D98EB2', N'51D88383-916B-4590-85CC-4E97CC6F33CF', 1, N'2019-07-11T05:32:23.222', N'000D7682-E46D-48C6-B7D8-B6509FABB3C0')
		   ,(N'F3B7C39B-8DDF-497B-B919-56770CE7B2AF', N'941069AA-D073-4604-866C-56471E0E868C', 1, N'2019-07-11T05:32:23.222', N'52789CF1-DAE3-4FC8-88AD-E874FE1D6B34')
		   ,(N'700D75E1-67F1-49E5-92EC-B8384E581CFB', N'2D4FCC04-F220-4545-AEE4-565FFC7792E2', 1, N'2019-07-11T05:32:23.222', N'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F')
		   ,(N'7294B6A3-7FA8-441F-AD06-2920B053E463', N'B3105E68-7705-4D85-8567-572C8519D139', 1, N'2019-07-11T05:32:23.222', N'127133F1-4427-4149-9DD6-B02E0E036971')
		   ,(N'CE80DDDA-01BA-41E9-82A9-6EB5C5BFC477', N'B98833A8-8C9F-44DD-AD37-573B7C249C59', 1, N'2019-07-11T05:32:23.222', N'B3A4E6FA-9F71-441D-BBB6-AD1155243D64')
		   ,(N'EC4442E1-75F8-4AD3-BDF4-27E7781A4797', N'3304DA13-AED9-4294-89DB-57B3D781495A', 1, N'2019-07-11T05:32:23.222', N'5E22E01A-BF81-46C5-8A64-600600E0313D')
		   ,(N'815691CF-2890-4F50-B8A2-F3012EE2BCA3', N'ABAFC577-8261-4E3F-95CC-59E8807DF29A', 1, N'2019-07-11T05:32:23.222', N'E38B057F-AA4E-4E63-B10A-74AA252AA004')
		   ,(N'328A524B-1C17-4EEF-9AA0-6CB0BC021FBC', N'436B041E-EC20-4E0F-85FC-600B7C3E067A', 1, N'2019-07-11T05:32:23.222', N'127133F1-4427-4149-9DD6-B02E0E036972')
		   ,(N'4474BD4B-B7F1-4DF8-BAC0-53ACB6516AA6', N'28F3D700-6B57-41C2-952C-61288FAFDE32', 1, N'2019-07-11T05:32:23.222', N'E7499FA4-EBF5-4F82-BED1-6E23E42AC13F') 
)
AS Source ([Id], [GoalId], [DashboardId], [GeneratedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [GoalId] = Source.[GoalId],
		   [DashboardId] = Source.[DashboardId],
		   [GeneratedDateTime] = Source.[GeneratedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [GoalId], [DashboardId], [GeneratedDateTime], [CreatedByUserId]) 
VALUES ([Id], [GoalId], [DashboardId], [GeneratedDateTime], [CreatedByUserId]);

MERGE INTO [dbo].[LeaveAllowance] AS Target
USING ( VALUES
  (N'29bb0733-c229-4b46-a0fe-0c00107163d2', N'4afeb444-e826-4f95-ac41-2175e36a0c16', 2015, 12, CAST(N'2019-07-17T10:04:21.157' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'72cbfc8d-f0c5-4edf-98ff-41a8fdedf8cb', N'4afeb444-e826-4f95-ac41-2175e36a0c16', 2016, 13, CAST(N'2019-07-17T10:04:10.210' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'7073f368-c4bb-4990-a830-45d39ac30be8', N'4afeb444-e826-4f95-ac41-2175e36a0c16', 2018, 14, CAST(N'2019-07-17T10:03:19.993' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b92d3d1c-918e-4910-bf7e-80d727133abd', N'4afeb444-e826-4f95-ac41-2175e36a0c16', 2017, 11, CAST(N'2019-07-17T10:03:55.230' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'b2322748-1033-4252-9311-91fdd1214e81', N'4afeb444-e826-4f95-ac41-2175e36a0c16', 2019, 11, CAST(N'2019-07-17T10:02:00.893' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
, (N'9c1f84fd-698d-4c90-a73c-e2d02ec3370b', N'4afeb444-e826-4f95-ac41-2175e36a0c16', 2020, 12, CAST(N'2019-07-17T10:03:34.650' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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

MERGE INTO [dbo].[RateSheet] AS Target
USING ( VALUES
	(newid(), N'4afeb444-e826-4f95-ac41-2175e36a0c16', 'Rate Sheet Holidays', '4C2B62D5-A062-470F-AE96-B1A4C7A70280', CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ),CONVERT(INT, RAND() * 100 ),CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ),CAST(N'2019-03-01T19:41:04.277' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971'),
	(newid(), N'4afeb444-e826-4f95-ac41-2175e36a0c16', 'Rate Sheet Holidays', 'FD9C639C-C15E-4120-BB9F-5AD7799C2648', CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ),CONVERT(INT, RAND() * 100 ),CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ), CONVERT(INT, RAND() * 100 ), CAST(N'2019-03-01T19:41:04.277' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036971')
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

 
INSERT INTO EmployeeRateSheet(Id, RateSheetEmployeeId, RateSheetId, CompanyId, RateSheetName, RateSheetForId, RateSheetStartDate,RateSheetEndDate,RatePerHour,RatePerHourMon, RatePerHourTue,RatePerHourWed,
RatePerHourThu,RatePerHourFri,RatePerHourSat,RatePerHourSun,CreatedDateTime,CreatedByUserId,UpdatedDateTime,UpdatedByUserId,InActiveDateTime, RateSheetCurrencyId)
SELECT newid(), e.Id , r.Id, r.CompanyId, r.RateSheetName, r.RateSheetForId, GETDATE(),DATEADD(month, 3, getdate()),r.RatePerHour,r.RatePerHourMon, r.RatePerHourTue,r.RatePerHourWed,
r.RatePerHourThu,r.RatePerHourFri,r.RatePerHourSat,r.RatePerHourSun,r.CreatedDateTime,r.CreatedByUserId,r.UpdatedDateTime,r.UpdatedByUserId,r.InActiveDateTime,
(select CC.Id from Company CM INNER JOIN SYS_Currency SC on SC.Id = CM.CurrencyId INNER JOIN Currency CC ON CC.CurrencyCode = SC.CurrencyCode AND CM.ID = CC.CompanyId where CM.Id= @CompanyId) from 
RateSheet r
LEFT JOIN Employee e on 1= 1
LEFT JOIN EmployeeRateSheet er on r.id = er.RateSheetId and e.Id = er.RateSheetEmployeeId
WHERE er.Id is null


MERGE INTO [dbo].[Job] AS Target 
USING ( VALUES 
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'IT' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Maria@gmail.com%' AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()), GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971'),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'IT' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%James@gmail.com%'AND CompanyId = @CompanyId), DATEADD(year, -2, GetDate()),GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971'),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'Sales' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%David@gmail.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971'),
 	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'Sales' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Martinez@gmail.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971'),
 	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'Sales' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Rodriguez@gmail.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971'),
 	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'Finance' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%JamesSmith@gmail.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971'),
 	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'Finance' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Hernandez@gmail.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971'),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'Finance' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Mary@gmail.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971'),
 	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'Administration' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Michael@gmail.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971'),
	 (NEWID(),(SELECT Id FROM [Designation] WHERE [DesignationName] = 'Software Engineer' AND CompanyId = @CompanyId),(SELECT Id FROM [EmploymentStatus] WHERE [EmploymentStatusName] = 'Full-Time Employee' AND CompanyId = @CompanyId),(SELECT Id FROM [JobCategory] WHERE [JobCategoryType] = 'Professionals' AND CompanyId = @CompanyId),(SELECT Id FROM [Department] WHERE [DepartmentName] = 'Administration' AND CompanyId = @CompanyId),(SELECT Id FROM [Branch] WHERE [BranchName] = 'Birmingham' AND CompanyId = @CompanyId),(SELECT E.Id FROM EMPLOYEE E JOIN [User] U ON E.UserId = U.Id WHERE UserName LIKE '%Robert@gmail.com%' AND CompanyId = @CompanyId),DATEADD(year, -2, GetDate()),GetDate(), N'127133f1-4427-4149-9dd6-b02e0e036971')
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



END