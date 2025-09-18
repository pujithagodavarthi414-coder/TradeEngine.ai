CREATE PROCEDURE [dbo].[USP_MasterDataDeploymentScript]
AS
BEGIN
	
    MERGE INTO [dbo].[DeploymentScript] AS Target 
    USING ( VALUES 
        		(N'5A641D0A-B4A7-491A-A4C6-2A0623B85712', N'Marker1',1,'Praneeth', NULL),
                (N'02FB54DF-9BE6-4AF5-B68D-239727977AFF', N'Marker2',2,'Praneeth', NULL),
                (N'F2696AC3-7C38-4DEA-A274-0EF0652CF7EC', N'Marker3',3,'Pujitha', NULL),
				(N'2F02B098-5A53-4ACA-B866-8B12134C863C', N'Marker4',4,'Pujitha', NULL),
				(N'10D6CD5D-5213-48D8-8BB3-DE11ADC790F2', N'Marker5',5,'Sudharshan', NULL)
            )         
    AS Source ([Id], [ScriptFileId], [ScriptFileExecutionOrder], [ScriptFileAddedByDeveloper], [ScriptFileAppliedDateTime]) 
    ON Target.Id = Source.Id 
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id], [ScriptFileId], [ScriptFileExecutionOrder], [ScriptFileAddedByDeveloper], [ScriptFileAppliedDateTime])  
    VALUES([Id], [ScriptFileId], [ScriptFileExecutionOrder], [ScriptFileAddedByDeveloper], [ScriptFileAppliedDateTime]);

	DECLARE @DefaultUserId UNIQUEIDENTIFIER = NULL
        
    SET @DefaultUserId = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')
        
    IF(@DefaultUserId IS NULL)
    BEGIN
            
        SET @DefaultUserId = NEWID()
        
        MERGE INTO [dbo].[User] AS Target 
        USING ( VALUES 
        		(@DefaultUserId,N'Snovasys', N'Support', N'Snovasys.Support@Support', N'Test123!', 1, N'1234567890', 1,GETDATE(),GETDATE(),@DefaultUserId)
        ) 
        AS Source ([Id], [SurName], [FirstName], [UserName], [Password], [IsActive], [MobileNo], [IsActiveOnMobile],[RegisteredDateTime], [CreatedDateTime], [CreatedByUserId]) 
        ON Target.Id = Source.Id  
        WHEN MATCHED THEN 
        UPDATE SET [SurName] = Source.[SurName],
        	        [FirstName] = Source.[FirstName],
        	        [UserName] = Source.[UserName],
        	        [Password] = Source.[Password],
        	        [IsActive] = Source.[IsActive],
        	        [MobileNo] = Source.[MobileNo],
        	        [IsActiveOnMobile] = Source.[IsActiveOnMobile],
        	        [RegisteredDateTime] = Source.[RegisteredDateTime],
        	        [CreatedDateTime] = Source.[CreatedDateTime],
        		    [CreatedByUserId] = Source.[CreatedByUserId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [SurName], [FirstName], [UserName], [Password], [IsActive], [MobileNo], [IsActiveOnMobile],[RegisteredDateTime], [CreatedDateTime], [CreatedByUserId]) 
        VALUES ([Id], [SurName], [FirstName], [UserName], [Password], [IsActive], [MobileNo], [IsActiveOnMobile],[RegisteredDateTime], [CreatedDateTime], [CreatedByUserId]);
           
    END

    MERGE INTO [dbo].[Industry] AS Target 
    USING (VALUES 
        	(N'2DE12A78-1B37-40CB-9AFF-B28B1675ED85','Creative / Digital / Marketing / Advertising',CAST(N'2018-03-01T00:00:00.000' AS DateTime))
        	,(N'C11D10CB-F287-4647-B2EA-A98D6A0373B5','Business consulting',CAST(N'2018-03-01T00:00:00.000' AS DateTime))
        	,(N'4494B8BB-7AC1-44A4-89E1-7200B7BE121E','Financial services',CAST(N'2018-03-01T00:00:00.000' AS DateTime))
        	,(N'A7F9CD6B-5439-4B2C-AD81-C042B6CA5EC8','Professional services',CAST(N'2018-03-01T00:00:00.000' AS DateTime))
        	,(N'744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71','IT',CAST(N'2018-03-01T00:00:00.000' AS DateTime))
        	,(N'6F396616-BE40-4A3E-8AEE-0C7562C97DFB','Legal',CAST(N'2018-03-01T00:00:00.000' AS DateTime))
        	,(N'93BC5E0B-06A2-48C6-BAEC-0AFAB5BBEA20','Construction',CAST(N'2018-03-01T00:00:00.000' AS DateTime))
        	,(N'B4FCE3AF-E3C8-480A-A117-74989AF3F6E5','Other services',CAST(N'2018-03-01T00:00:00.000' AS DateTime))
        	,(N'4E77F9C3-4389-4493-AADC-B2C0D70AAC6F','Other',CAST(N'2018-03-01T00:00:00.000' AS DateTime))
        	,(N'2364A441-470D-434A-940F-CEFA7E669B88','Charity',CAST(N'2020-01-01T00:00:00.000' AS DateTime))
			,(N'7499F5E3-0EF2-4044-B840-2411B68302F9','Remote Working Software',CAST(N'2020-01-01T00:00:00.000' AS DateTime))
            ,(N'FEC07283-AA98-41E1-B3D3-28CD6C6C5D97','HR Software',CAST(N'2020-01-01T00:00:00.000' AS DateTime))
            ,(N'3AA49D13-76C9-4842-840E-4AC759B65DF8','Practice management',CAST(N'2020-01-01T00:00:00.000' AS DateTime))
			,(N'BBBB8092-EBCC-43FF-A039-5E3BD2FACE51','Energy Sector',CAST(N'2020-01-01T00:00:00.000' AS DateTime))
			,(N'97973F64-4F4C-46B5-B096-4CC5D4AD8B20','Employee monitoring system',CAST(N'2020-10-08T00:00:00.000' AS DateTime))
    )
    AS Source ([Id],[IndustryName],[CreatedDateTime])
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [Id] = Source.[Id],
        		[IndustryName] = Source.[IndustryName],
        		[CreatedDateTime] = Source.[CreatedDateTime]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id],[IndustryName],[CreatedDateTime]) 
    VALUES ([Id],[IndustryName],[CreatedDateTime]);	

    MERGE INTO [dbo].[TimeZone] AS Target 
        USING ( VALUES 
		        ( N'225527D5-C90C-49F4-AB0D-8CD8D111D9DF', 'Afghanistan Time', N'AFT', N'AF', N'Afghanistan', N'Asia/Kabul', N'+0430', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 270),
		        ( N'17CE295F-600D-404C-93A8-6758F4FF4AA6', 'Central European Summer Time', N'CEST', N'AL', N'Albania', N'Europe/Tirane', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'7945794D-A16D-4849-B0B4-8D3EA5CA30C1', 'Central European Time', N'CET', N'DZ', N'Algeria', N'Africa/Algiers', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'8BC24E23-AA23-45A0-BB09-CAF901EBC53C', 'Samoa Standard Time', N'SST', N'AS', N'American Samoa', N'Pacific/Pago_Pago', N'-1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -660),
		        ( N'B435B2E3-8812-46EE-A990-4A9AF5F498B5', 'Central European Summer Time', N'CEST', N'AD', N'Andorra', N'Europe/Andorra', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'83B1FAE3-2C9B-4907-A674-3B212224B055', 'West Africa Time', N'	WAT', N'AO', N'Angola', N'Africa/Luanda', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'68C042F6-E98A-44B3-A41E-86424EAB4366', 'Atlantic Standard Time', N'AST', N'AI', N'Anguilla', N'America/Anguilla', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'70E08651-EA91-4043-8272-3414A514E9E9', 'Casey Time', N'CAST', N'AQ', N'Antarctica', N'Antarctica/Casey', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'CD15270C-83A9-4A6E-B7E7-F468D63D262F', 'Davis Time', N'DAVT', N'AQ', N'Antarctica', N'Antarctica/Davis', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'EEA914D8-353B-44CC-8D26-D0830C737048', 'Dumont-dUrville Time ', N'DDUT', N'AQ', N'Antarctica', N'Antarctica/DumontDUrville', N'+1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 600),
		        ( N'2014252B-0891-4F24-9BFD-086195590965', 'Mawson Time', N'MAWT', N'AQ', N'Antarctica', N'Antarctica/Mawson', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'234BAA17-D412-4297-A253-853675DBBAF5', 'New Zealand Daylight Time', N'NZDT', N'AQ', N'Antarctica', N'Antarctica/McMurdo', N'+1300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 780),
		        ( N'2ADD537C-676A-4806-9131-491EEDB5699D', 'Chile Summer Time', N'CLST', N'AQ', N'Antarctica', N'Antarctica/Palmer', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'21159268-0B7E-4DF5-ACEC-73618574D6CA', 'Argentina Time', N'ART', N'AQ', N'Antarctica', N'Antarctica/Rothera', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'ABD1C17A-0E22-49C2-BB88-790646BFC1F0', 'Syowa Time', N'SYOT', N'AQ', N'Antarctica', N'Antarctica/Syowa', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'32D532A2-670C-46F6-9347-41C361AB2E5E', 'Central European Summer Time', N'CEST', N'AQ', N'Antarctica', N'Antarctica/Troll', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'0609EFE2-12D8-46B0-9D1F-111660BD57FA', 'Vostok Time', N'VOST', N'AQ', N'Antarctica', N'Antarctica/Vostok', N'+0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 360),
		        ( N'524100C0-AC07-4C75-BACB-AF428A400AF3', 'Atlantic Standard Time', N'AST', N'AG', N'Antigua and Barbuda', N'America/Antigua', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'03060910-AF82-4F11-9CAF-D414C649EE95', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/Buenos_Aires', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'BC3F87DF-C406-48F7-947B-1EB0B16DC8AF', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/Catamarca', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'B0B604E0-7A45-4200-9180-4E6B2767A99A', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/Cordoba', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'638CA424-B14D-4BE3-9C47-8551051B634B', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/Jujuy', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'E55D2E8D-DECB-4F00-B5F3-365EAA4459B4', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/La_Rioja', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'201B8BDA-3B53-4F6E-A0ED-38923C0E0091', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/Mendoza', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'32F21A3D-9D7B-4B92-A214-1737542459F8', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/Rio_Gallegos', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'1917F6A8-11A5-48E5-A0C7-D92BFF42837E', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/Salta', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'10BB1521-A9F9-482C-98E5-2A226AACBEBD', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/San_Juan', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'1844F56C-7F7A-4319-84A5-4634C7C8A9F1', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/San_Luis', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'8A4BC798-A9D7-4696-953A-6724D3B5DD49', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/Tucuman', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'734FE72C-3149-4FAD-8766-9A45E957E3F1', 'Argentina Time', N'ART', N'AR', N'Argentina', N'America/Argentina/Ushuaia', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'ABDF9623-5C42-4172-92B5-D563B3BBD3A3', 'Armenia Time', N'AMT', N'AM', N'Armenia', N'Asia/Yerevan', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'F37C5DED-6CB6-4695-B677-85753BDE5A38', 'Atlantic Standard Time', N'AST', N'AW', N'Aruba', N'America/Aruba', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'E40DE3D8-70F4-4B95-90A5-F3D3848992C5', 'Australian Eastern Daylight Savings Time', N'AEDT', N'AU', N'Australia', N'Antarctica/Macquarie', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'161B7F96-1355-45DE-A00F-83218110BD48', 'Australian Central Daylight Saving Time', N'ACDT', N'AU', N'Australia', N'Australia/Adelaide', N'+1030', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 630),
		        ( N'F3DF4952-126D-4A42-AA7F-EA2B1BE69969', 'Australian Eastern Standard Time', N'AEST', N'AU', N'Australia', N'Australia/Brisbane', N'+1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 600),
		        ( N'3285A519-8A0D-4ECC-ADDB-7BDE09106F93', 'Australian Central Daylight Saving Time', N'ACDT', N'AU', N'Australia', N'Australia/Broken_Hill', N'+1030', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 630),
		        ( N'E49F9F66-DBA2-4D57-B53D-1D584A5835B5', 'Australian Eastern Daylight Savings Time', N'AEDT', N'AU', N'Australia', N'Australia/Currie', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'910E7AC0-0F44-43E0-8261-5940219EEE70', 'Australian Central Standard Time', N'ACST', N'AU', N'Australia', N'Australia/Darwin', N'+0930', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 570),
		        ( N'51388F5B-2284-461A-8793-CED96CEE9803', 'Austrslian Central Western Standard Time', N'ACWST', N'AU', N'Australia', N'Australia/Eucla', N'+0845', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 525),
		        ( N'C2AC1A94-F71B-43CE-9060-7A008C0BF85D', 'Australian Eastern Daylight Savings Time', N'AEDT', N'AU', N'Australia', N'Australia/Hobart', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'D9E3FDDF-C03B-4A66-9968-7EECDF0936D9', 'Australian Eastern Standard Time', N'AEST', N'AU', N'Australia', N'Australia/Lindeman', N'+1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 600),
		        ( N'E737556B-E01F-49BE-A7A6-20D8B0BE83BC', 'Lord Howe Standard Time', N'LHST', N'AU', N'Australia', N'Australia/Lord_Howe', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'17F13343-C9C9-492F-9E28-C2AF7B087E5E', 'Australian Eastern Daylight Savings Time', N'AEDT', N'AU', N'Australia', N'Australia/Melbourne', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'6A8E857E-4004-4260-A5E0-B3667788BFC8', 'Australian Western Standard Time', N'AWST', N'AU', N'Australia', N'Australia/Perth', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'07762993-DAA8-44B5-ADF1-5A9D44A77C87', 'Australian Eastern Daylight Savings Time', N'AEDT', N'AU', N'Australia', N'Australia/Sydney', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'3BBAAFB2-A3F8-480B-810D-2BB1957B1A11', 'Central European Summer Time', N'CEST', N'AT', N'Austria', N'Europe/Vienna', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'8495072F-9217-4968-B269-FD0C208A83D2', 'Azerbaijan Time', N'AZT', N'AZ', N'Azerbaijan', N'Asia/Baku', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'083DF840-6EEB-4B44-B089-5EFAFDEE5B36', 'Eastern Daylight Time', N'EDT', N'BS', N'Bahamas', N'America/Nassau', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'956DA73B-5D90-4901-B86C-4384662B75A6', 'Atlantic Standard Time', N'AST', N'BH', N'Bahrain', N'Asia/Bahrain', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'F8C56122-FA95-493D-9427-5027D8E1C0FF', 'British Summer Time', N'BST', N'BD', N'Bangladesh', N'Asia/Dhaka', N'+0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 360),
		        ( N'FF7F43A4-D67D-41D3-B2AD-1C425C6409F0', 'Atlantic Standard Time', N'AST', N'BB', N'Barbados', N'America/Barbados', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'B98CE6A4-A804-4F10-AD3B-50C3B3CFBB88', 'Moscow Time', N'MSK', N'BY', N'Belarus', N'Europe/Minsk', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'820BAD58-D98B-42D1-83EF-795BEC10C433', 'Central European Summer Time', N'CEST', N'BE', N'Belgium', N'Europe/Brussels', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'E83F4AF9-84DF-4E71-8B7C-C0111EF60DCB', 'Central Standard Time', N'CST', N'BZ', N'Belize', N'America/Belize', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'BB896C90-BAAA-4DD9-AB82-94B67F800643', 'West Africa Time', N'WAT', N'BJ', N'Benin', N'Africa/Porto-Novo', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'B9E66E5C-2D37-4F7D-8DDC-8B0CF0D103D8', 'Atlantic Daylight Time', N'ADT', N'BM', N'Bermuda', N'Atlantic/Bermuda', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'44D937F5-C12A-4201-A183-C5960D3A9B9A', 'Bhutan Time', N'BTT', N'BT', N'Bhutan', N'Asia/Thimphu', N'+0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 360),
		        ( N'8E1D4998-24D4-491C-B7E7-ECEF509C0AEB', 'Bolivia Time', N'BOT', N'BO', N'Bolivia, Plurinational State of', N'America/La_Paz', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'DDA61372-35D2-4675-8C35-3657B772C39C', 'Atlantic Standard Time', N'AST', N'BQ', N'Bonaire, Sint Eustatius and Saba', N'America/Kralendijk', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'9BAA3669-9F25-438F-9EEB-CE5DDA427CD0', 'Central European Summer Time', N'CEST', N'BA', N'Bosnia and Herzegovina', N'Europe/Sarajevo', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'56744016-47A5-4A5B-A870-971163F2C39E', 'Central Africa Time', N'CAT', N'BW', N'Botswana', N'Africa/Gaborone', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'E25ABFB0-8B75-4588-BF9F-67DF2687FC84', 'Brasília time', N'BRT', N'BR', N'Brazil', N'America/Araguaina', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'92F5C101-FE26-46ED-9578-A0EAFAEC4317', 'Brasília time', N'BRT', N'BR', N'Brazil', N'America/Bahia', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'293EB3D2-3999-40A7-A6D9-B759F161B072', 'Brasília time', N'BRT', N'BR', N'Brazil', N'America/Belem', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'4009341D-4B6E-4BB0-B941-467270EB0032', 'Armenia Time', N'AMT', N'BR', N'Brazil', N'America/Boa_Vista', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'AAFAC0A2-9D6F-4F32-838C-5021A6677004', 'Armenia Time', N'AMT', N'BR', N'Brazil', N'America/Campo_Grande', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'019FACE7-2670-4508-AB36-E9A73E60B9F9', 'Brasília time', N'BRT', N'BR', N'Brazil', N'America/Cuiaba', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'2F193ED4-A106-42CC-8720-9CD37976A862', 'Australian Central Time', N'ACT', N'BR', N'Brazil', N'America/Eirunepe', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'1EBEB74A-A2E6-4895-838A-393E50831905', 'Brasília time', N'BRT', N'BR', N'Brazil', N'America/Fortaleza', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'B76DB854-AE55-4FF9-9620-B2B624CEA76B', 'Brasília time', N'BRT', N'BR', N'Brazil', N'America/Maceio', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'24EA908F-B273-4EB3-B024-404147FC2745', 'Armenia Time', N'AMT', N'BR', N'Brazil', N'America/Manaus', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'6AE8A3DB-D686-4083-A07D-07CB086DF2CE', 'Fernando de Noronha Time', N'FNT', N'BR', N'Brazil', N'America/Noronha', N'-0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -120),
		        ( N'8697A7AA-DDA5-4AAE-8645-5CEEF401DF1F', 'Armenia Time', N'AMT', N'BR', N'Brazil', N'America/Porto_Velho', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'36F0B6F5-1DBE-428D-A964-458157007672', 'Brasília time', N'BRT', N'BR', N'Brazil', N'America/Recife', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'C53F4A75-3022-47F3-A46D-80A8E384E3D5', 'Australian Central Time', N'ACT', N'BR', N'Brazil', N'America/Rio_Branco', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'F189467B-6508-4712-A307-E8AE8AB71DDC', 'Brasília time', N'BRT', N'BR', N'Brazil', N'America/Santarem', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'E7F6EF1A-CF51-4079-A85F-95D7621DC771', 'Brasília time', N'BRT', N'BR', N'Brazil', N'America/Sao_Paulo', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'209672F9-90A1-4767-833A-8D9D55D37E43', 'Indian Chagos Time', N'IOT', N'IO', N'British Indian Ocean Territory', N'Indian/Chagos', N'+0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 360),
		        ( N'BD5A3654-F2C3-469B-B8A2-7B8FB80C16A3', 'Brunei Darussalam Time', N'BNT', N'BN', N'Brunei Darussalam', N'Asia/Brunei', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'35FD0998-9A14-4ED8-AB8E-1B19A531725B', 'Eastern European Summer Time', N'EEST', N'BG', N'Bulgaria', N'Europe/Sofia', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'33923E5E-323B-4AA2-B807-B6133C255DD7', 'Greenwich Mean Time', N'GMT', N'BF', N'Burkina Faso', N'Africa/Ouagadougou', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'E59420BB-358C-4133-AA01-768BCB6B06F4', 'Central Africa Time', N'CAT', N'BI', N'Burundi', N'Africa/Bujumbura', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'23C68043-357F-47EE-A35B-80D2B76C97BC', 'Indochina Time', N'ICT', N'KH', N'Cambodia', N'Asia/Phnom_Penh', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'43F12AD1-21CB-425F-943C-BFDCE006E012', 'West Africa Time', N'WAT', N'CM', N'Cameroon', N'Africa/Douala', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'23B47BC5-E354-4A2F-A0FB-99A1E17732E0', 'Eastern Standard Time', N'EST', N'CA', N'Canada', N'America/Atikokan', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'56CCCBE3-3B96-45CF-83E9-6D7DA1148F8D', 'Atlantic Standard Time', N'AST', N'CA', N'Canada', N'America/Blanc-Sablon', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'C15D1B1C-603C-4E42-8ECB-831A696D19D7', 'Mountain Daylight Time', N'MDT', N'CA', N'Canada', N'America/Cambridge_Bay', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'1BA48BCC-E0D6-40E7-A3C8-43AF858C450B', 'Mountain Standard Time', N'MST', N'CA', N'Canada', N'America/Creston', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'90523BED-DD4E-4DF5-9780-30176AB0A5A3', 'Pacific Time Zone', N'PDT', N'CA', N'Canada', N'America/Dawson', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'E78890AB-AAC4-4EA8-9BD2-58F23E9FE19D', 'Mountain Standard Time', N'MST', N'CA', N'Canada', N'America/Dawson_Creek', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'F582AF4E-B2E0-4D48-AFE3-5D0856C313F6', 'Mountain Daylight Time', N'MDT', N'CA', N'Canada', N'America/Edmonton', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'A15D70B3-B8CC-47DC-AB80-749D49E6312F', 'Mountain Standard Time', N'MST', N'CA', N'Canada', N'America/Fort_Nelson', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'E5CFC692-C83B-4C6E-9D6C-D8E11EDE22A7', 'Atlantic Daylight Time', N'ADT', N'CA', N'Canada', N'America/Glace_Bay', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'357EBE78-89CC-40F7-ABDA-5BE497CD1E30', 'Atlantic Daylight Time', N'ADT', N'CA', N'Canada', N'America/Goose_Bay', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'2BED2A83-76E0-4C5B-A963-A565FD697288', 'Atlantic Daylight Time', N'ADT', N'CA', N'Canada', N'America/Halifax', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'1A92A39E-098B-4C90-BD6E-F6E04185AF56', 'Mountain Daylight Time', N'MDT', N'CA', N'Canada', N'America/Inuvik', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'2A68AA8F-36CF-40CF-B010-7414C3E94E28', 'Eastern Daylight Time', N'EDT', N'CA', N'Canada', N'America/Iqaluit', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'B5D53B9C-4E85-424F-B58C-D0B3BD7B23C2', 'Atlantic Daylight Time', N'ADT', N'CA', N'Canada', N'America/Moncton', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'EA85EEB2-270E-4FEB-B0AA-5DA63C35F5C1', 'Eastern Daylight Time', N'EDT', N'CA', N'Canada', N'America/Nipigon', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'99CB85C8-BFDC-466F-9BBC-49BB195A1D3A', 'Eastern Daylight Time', N'EDT', N'CA', N'Canada', N'America/Pangnirtung', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'280BFFBE-2B5B-4713-9542-1FBB4CA5368F', 'Central Daylight Time', N'CDT', N'CA', N'Canada', N'America/Rainy_River', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'E975A4B0-7980-4A56-B4C5-4D3A5A561F91', 'Central Daylight Time', N'CDT', N'CA', N'Canada', N'America/Rankin_Inlet', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'09D206ED-C32A-43ED-A083-67DFD29E8D0E', 'Central Standard Time', N'CST', N'CA', N'Canada', N'America/Regina', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'6DAC8FCF-A613-4957-A67A-6A07212DF599', 'Central Daylight Time', N'CDT', N'CA', N'Canada', N'America/Resolute', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'48563EED-7182-406F-8478-93DD518A88CA', 'Newfoundland Daylight Time', N'NDT', N'CA', N'Canada', N'America/St_Johns', N'-0230', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -150),
		        ( N'94DEFDAD-098A-4F77-8053-0DB0E5B4AF9B', 'Central Standard Time', N'CST', N'CA', N'Canada', N'America/Swift_Current', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'4D2D05EA-320A-4DE5-BBEC-D5039625479E', 'Eastern Daylight Time', N'EDT', N'CA', N'Canada', N'America/Thunder_Bay', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'AD43A21C-D551-4283-AD4F-B1DA1A2EE91A', 'Eastern Daylight Time', N'EDT', N'CA', N'Canada', N'America/Toronto', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'12AA7E35-C882-4F77-9865-0B2E8C0B6627', 'Pacific Time Zone', N'PDT', N'CA', N'Canada', N'America/Vancouver', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'DD13934E-2E84-4E87-B344-C17132BC47E3', 'Pacific Time Zone', N'PDT', N'CA', N'Canada', N'America/Whitehorse', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'F40D27CE-EF13-4E71-A344-8B5D361061E2', 'Central Daylight Time', N'CDT', N'CA', N'Canada', N'America/Winnipeg', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'8305FF2C-2CAB-4AD3-905F-F4C0AB767408', 'Mountain Daylight Time', N'MDT', N'CA', N'Canada', N'America/Yellowknife', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'25222264-D0D7-4CD2-8DF0-E6A0AA5C6BF8', 'Cape Verde Time', N'CVT', N'CV', N'Cape Verde', N'Atlantic/Cape_Verde', N'-0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -60),
		        ( N'841E42BF-FB1A-4CE0-9063-6BF46C3E1724', 'Eastern Standard Time', N'EST', N'KY', N'Cayman Islands', N'America/Cayman', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'3470DB39-B63F-41E3-A73D-29DD5FC63A53', 'West Africa Time', N'WAT', N'CF', N'Central African Republic', N'Africa/Bangui', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'A4F52230-414C-487F-AC1E-EEA76BA3E39D', 'West Africa Time', N'WAT', N'TD', N'Chad', N'Africa/Ndjamena', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'E84834AE-6E7A-4C6D-86E4-A5FCAF9FB53B', 'Chile Summer Time', N'CLST', N'CL', N'Chile', N'America/Punta_Arenas', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'A28D7376-FB83-4B7D-A1B1-6DE2BAAD49F7', 'Chile Summer Time', N'CLST', N'CL', N'Chile', N'America/Santiago', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'C951AB38-B0A9-4C44-B8F5-4B7C17534800', 'Easter Island Summer Time', N'EASST', N'CL', N'Chile', N'Pacific/Easter', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'55EA598B-4EEC-4DAF-8036-BA0612B220BA', 'Central Standard Time', N'CST', N'CN', N'China', N'Asia/Shanghai', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'3DDE441E-0B62-4E02-994A-AC1704334DB7', 'Central Standard Time', N'URUT', N'CN', N'China', N'Asia/Urumqi', N'+0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 360),
		        ( N'79CC345A-AF96-4689-9703-D7AB0A6B3744', 'Christmas Island Time', N'CXT', N'CX', N'Christmas Island', N'Indian/Christmas', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'02E52056-782D-460D-A6AC-F13DB7D3E357', 'Cocos Islands Time', N'CCT', N'CC', N'Cocos (Keeling) Islands', N'Indian/Cocos', N'+0630', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 390),
		        ( N'76D6C69C-9587-489B-9558-CE6741B42878', 'Colombia Time', N'COT', N'CO', N'Colombia', N'America/Bogota', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'038E4CA1-109C-4E81-822D-596340C83B42', 'East Africa Time', N'EAT', N'KM', N'Comoros', N'Indian/Comoro', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'900A75DC-9240-4DF1-A409-E266876F4518', 'West Africa Time', N'WAT', N'CG', N'Congo', N'Africa/Brazzaville', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'195D97F2-CFA9-4650-9A23-7E2C211D7136', 'West Africa Time', N'WAT', N'CD', N'Congo, the Democratic Republic of the', N'Africa/Kinshasa', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'8A7C8F06-AB4C-46E7-8AF8-15AA98D3E4C3', 'Central Africa Time', N'CAT', N'CD', N'Congo, the Democratic Republic of the', N'Africa/Lubumbashi', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'F2F12A1C-7CC7-4976-9B26-B6866AD8C022', 'Cook Island Time', N'CKT', N'CK', N'Cook Islands', N'Pacific/Rarotonga', N'-1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -600),
		        ( N'B1C8C17C-08A5-48E7-B85D-0FE068DB2F03', 'Central Standard Time', N'CST', N'CR', N'Costa Rica', N'America/Costa_Rica', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'252339A1-7D61-45B4-A634-B2746D30637E', 'Central European Summer Time', N'CEST', N'HR', N'Croatia', N'Europe/Zagreb', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'02774182-E302-4DD0-A0A4-DA9883686F77', 'Central Daylight Time', N'CDT', N'CU', N'Cuba', N'America/Havana', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'CD8794AF-D1A8-4323-91F7-E0DA3D28B88B', 'Atlantic Standard Time', N'AST', N'CW', N'Curaçao', N'America/Curacao', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'1EEFAA0F-66FD-4A7C-BF5C-382D0178910F', 'Eastern European Summer Time', N'EEST', N'CY', N'Cyprus', N'Asia/Famagusta', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'081BE5C4-9C8E-43E3-9E89-283D180F5DB9', 'Eastern European Summer Time', N'EEST', N'CY', N'Cyprus', N'Asia/Nicosia', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'344C9CC3-16B5-40B8-9B8A-77ABC0332D06', 'Central European Summer Time', N'CEST', N'CZ', N'Czech Republic', N'Europe/Prague', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'D2629403-75A9-4D79-B97F-BB54E176635A', 'Greenwich Mean Time', N'GMT', N'CI', N'Côte dIvoire', N'Africa/Abidjan', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'EC3471CC-7DD4-46A7-8D09-51DF83078D51', 'Central European Summer Time', N'CEST', N'DK', N'Denmark', N'Europe/Copenhagen', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'DC37B178-0C0E-476D-9927-E1AA6531B378', 'East Africa Time', N'EAT', N'DJ', N'Djibouti', N'Africa/Djibouti', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'60E2BC16-A227-4BB9-A5C5-73465B321B5D', 'Atlantic Standard Time', N'AST', N'DM', N'Dominica', N'America/Dominica', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'E182B095-5F13-4A5B-AF0C-0D82C539E652', 'Atlantic Standard Time', N'AST', N'DO', N'Dominican Republic', N'America/Santo_Domingo', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'05DBB43A-0387-4E31-A991-DDD8C97F3E12', 'Ecuador Time', N'ECT', N'EC', N'Ecuador', N'America/Guayaquil', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'87F36DE0-ECF3-48E5-AE85-1C74AA3730AF', 'Galapagos Time', N'GALT', N'EC', N'Ecuador', N'Pacific/Galapagos', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'B7AA95A0-B168-479A-B109-1DC05943EAF9', 'Eastern European Time', N'EET', N'EG', N'Egypt', N'Africa/Cairo', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'05C85310-6DF3-4A16-9D34-DA48B8E78501', 'Central Standard Time', N'CST', N'SV', N'El Salvador', N'America/El_Salvador', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'24E6746F-00BA-430F-A0E3-994C6BC3CAD0', 'West Africa Time', N'WAT', N'GQ', N'Equatorial Guinea', N'Africa/Malabo', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'DAEA4E06-1153-4CB6-B904-1B1297C685E3', 'East Africa Time', N'EAT', N'ER', N'Eritrea', N'Africa/Asmara', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'FA273303-09AD-4068-BE76-C106FFD54CDF', 'Eastern European Summer Time', N'EEST', N'EE', N'Estonia', N'Europe/Tallinn', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'7347F463-D0DD-4EB8-B547-A53927CC2EB6', 'East Africa Time', N'EAT', N'ET', N'Ethiopia', N'Africa/Addis_Ababa', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'2C99B602-0E54-47E8-9E7C-4E939B8574EE', 'Falkland Islands Time', N'FKT', N'FK', N'Falkland Islands (Malvinas)', N'Atlantic/Stanley', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'E3983855-94CD-4857-9488-A78FC5D8CDF7', 'Western European Summer Time', N'WEST', N'FO', N'Faroe Islands', N'Atlantic/Faroe', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'3D1C0352-D074-4517-A21A-8FE3582BA2AB', 'Fiji Time', N'FJT', N'FJ', N'Fiji', N'Pacific/Fiji', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'27D3D0E1-B308-4AEA-B6E9-1B4BF827360D', 'Eastern European Summer Time', N'EEST', N'FI', N'Finland', N'Europe/Helsinki', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'7C1D6210-AA71-4326-94ED-096A15C69F7D', 'Central European Summer Time', N'CEST', N'FR', N'France', N'Europe/Paris', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'7AC90025-1211-4821-A3CE-A172BB01CDA0', 'French Guiana Time', N'GFT', N'GF', N'French Guiana', N'America/Cayenne', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'79E069F3-04B8-46AD-894D-05815D4D3E6F', 'Gambier Time', N'GAMT', N'PF', N'French Polynesia', N'Pacific/Gambier', N'-0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -540),
		        ( N'987A6497-5641-428D-AF73-96F12373C90F', 'Marquesas Time', N'MART', N'PF', N'French Polynesia', N'Pacific/Marquesas', N'-0930', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -570),
		        ( N'E88AA286-F024-43BD-8007-9D820EF33561', 'Tahiti Time', N'TAHT', N'PF', N'French Polynesia', N'Pacific/Tahiti', N'-1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -600),
		        ( N'D5FA035F-DDCC-48E2-AFF3-E935B2A01BE6', 'French Southern and Antarctic Time ', N'TFT', N'TF', N'French Southern Territories', N'Indian/Kerguelen', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'C8060540-2A96-4927-8EFF-3CA7975E4FD3', 'West Africa Time', N'WAT', N'GA', N'Gabon', N'Africa/Libreville', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'1B46CCA3-E773-44C6-8A1C-33008F63349A', 'Greenwich Mean Time', N'GMT', N'GM', N'Gambia', N'Africa/Banjul', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'859A8D95-916B-4923-AAA9-7A1BF7552F6C', 'Georgia Standard Time', N'GET', N'GE', N'Georgia', N'Asia/Tbilisi', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'0B2FC447-1A43-425A-936C-D69BB59E83D0', 'Central European Summer Time', N'CEST', N'DE', N'Germany', N'Europe/Berlin', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'6FEDB0FF-18AF-42EE-B7AF-4EFB26552272', 'Central European Summer Time', N'CEST', N'DE', N'Germany', N'Europe/Busingen', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'C965347D-F29E-4966-9094-BF2E3ED8BC46', 'Greenwich Mean Time', N'GMT', N'GH', N'Ghana', N'Africa/Accra', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'CB2FFB6B-C7AC-42D3-A344-D013BAAC872C', 'Central European Summer Time', N'CEST', N'GI', N'Gibraltar', N'Europe/Gibraltar', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'B74CBA4B-379D-43F7-A1DD-497E08917524', 'Eastern European Summer Time', N'EEST', N'GR', N'Greece', N'Europe/Athens', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'557c436a-5d19-4eeb-a677-93ea2609eaf1', 'Greenwich Mean Time', N'GMT', N'GL', N'Greenland', N'America/Danmarkshavn', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'B5D34A78-74BA-40AB-8C3D-09E33CB6FD10', 'Western Greenland Summer Time', N'WGST', N'GL', N'Greenland', N'America/Nuuk', N'-0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -120),
		        ( N'3321E0C6-AAC8-485A-B38F-5A5F982009F3', 'Eastern Greenland Summer Time', N'EGST', N'GL', N'Greenland', N'America/Scoresbysund', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'E9942192-4BA2-4276-8810-73B629896FEA', 'Atlantic Daylight Time', N'ADT', N'GL', N'Greenland', N'America/Thule', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'FD46CB0A-05A4-4B63-9FAB-14239FD4293A', 'Atlantic Standard Time', N'AST', N'GD', N'Grenada', N'America/Grenada', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'89D29DB1-A606-4BA4-B440-6504511A61EC', 'Atlantic Standard Time', N'AST', N'GP', N'Guadeloupe', N'America/Guadeloupe', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'B65E60CA-186C-4018-B069-EF60D9885466', 'Chamorro Standard Time', N'CHST', N'GU', N'Guam', N'Pacific/Guam', N'+1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 600),
		        ( N'D43E01B5-09CA-4C61-BEE6-B57AF160544F', 'Central Standard Time', N'CST', N'GT', N'Guatemala', N'America/Guatemala', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'9F74FB7F-05BB-4B4A-8165-36EC830E0390', 'British Summer Time', N'BST', N'GG', N'Guernsey', N'Europe/Guernsey', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'5A3CE824-D065-4075-85DD-6DEAC567DA0E', 'Greenwich Mean Time', N'GMT', N'GN', N'Guinea', N'Africa/Conakry', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'DAED0BA8-2F5A-45E2-8CA5-3009A3FEF0F8', 'Greenwich Mean Time', N'GMT', N'GW', N'Guinea-Bissau', N'Africa/Bissau', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'7906F783-F7DB-4AA9-B13B-3E960DBB76E0', 'Guyana Time', N'GYT', N'GY', N'Guyana', N'America/Guyana', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'50088594-E564-439A-86C2-08BD02255A77', 'Eastern Daylight Time', N'EDT', N'HT', N'Haiti', N'America/Port-au-Prince', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'7B932906-9581-4B60-BB15-477D9A0A2928', 'Central European Summer Time', N'CEST', N'VA', N'Holy See (Vatican City State)', N'Europe/Vatican', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'CF1AFA3D-D5E6-4B50-AFAB-3584C44F37BC', 'Central Standard Time', N'CST', N'HN', N'Honduras', N'America/Tegucigalpa', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'57C20E1C-1824-46F9-921B-79D06C1B332E', 'Hong Kong Time', N'HKT', N'HK', N'Hong Kong', N'Asia/Hong_Kong', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'45B5ECED-A803-41E9-BC6A-1A3FFF92CE02', 'Central European Summer Time', N'CEST', N'HU', N'Hungary', N'Europe/Budapest', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'18D474E7-2EAF-4A8B-AF24-05B7482AC43E', 'Greenwich Mean Time', N'GMT', N'IS', N'Iceland', N'Atlantic/Reykjavik', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'c527b633-9fb6-4d9f-be87-5172dbe87d18', 'India Standard Time', N'IST', N'IN', N'India', N'Asia/Kolkata', N'+0530', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 330),
		        ( N'8BFA87DA-D171-4917-991E-646DC87A9640', 'Western Indonesia Time', N'WIB', N'ID', N'Indonesia', N'Asia/Jakarta', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'982FE498-A4C5-49C9-8A86-E2D10467B864', 'Eastern Indonesia Time', N'WIT', N'ID', N'Indonesia', N'Asia/Jayapura', N'+0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 540),
		        ( N'A8C3DFE1-F70D-403B-870D-23DECA5F00CD', 'Central Indonesia Time', N'WITA', N'ID', N'Indonesia', N'Asia/Makassar', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'95594F5E-220A-4D0D-8A52-B928CF18FB54', 'Western Indonesia Time', N'WIB', N'ID', N'Indonesia', N'Asia/Pontianak', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'A9950205-FEB3-4C28-AA5C-8F61FDD05AEA', 'Iran Daylight Time', N'IRDT', N'IR', N'Iran, Islamic Republic of', N'Asia/Tehran', N'+0330', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 210),
		        ( N'07BF2187-C57F-45D5-A729-BF793FC55E43', 'Atlantic Standard Time', N'AST', N'IQ', N'Iraq', N'Asia/Baghdad', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'3EF37A4F-390A-4E8B-AA26-853D2B1B9B5C', 'Ireland Standard Time', N'IST', N'IE', N'Ireland', N'Europe/Dublin', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'8AB91683-66F5-4283-B0E9-D70D8935B68C', 'British Summer Time', N'BST', N'IM', N'Isle of Man', N'Europe/Isle_of_Man', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'FCEAC52D-9842-4066-836B-FD7AFEAAC641', 'Israel Daylight Time', N'IDT', N'IL', N'Israel', N'Asia/Jerusalem', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'750548B0-E636-4577-9D02-2A08A057318A', 'Central European Summer Time', N'CEST', N'IT', N'Italy', N'Europe/Rome', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'70311355-2C55-4C1F-9F40-E1813C160F03', 'Eastern Standard Time', N'EST', N'JM', N'Jamaica', N'America/Jamaica', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'C4D92A1E-7D61-47B0-9331-CB5FA0903F50', 'Japan Standard Time', N'JST', N'JP', N'Japan', N'Asia/Tokyo', N'+0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 540),
		        ( N'AAC2F095-F881-4140-8886-60C0383C6A63', 'British Summer Time', N'BST', N'JE', N'Jersey', N'Europe/Jersey', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'5DA61364-76AE-4DEE-8771-0391CD2C42A7', 'Eastern European Summer Time', N'EEST', N'JO', N'Jordan', N'Asia/Amman', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'EEFEF063-8337-426E-815D-08174E1C23D9', 'Alma-Ata Time', N'ALMT', N'KZ', N'Kazakhstan', N'Asia/Almaty', N'+0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 360),
		        ( N'DCA5DF33-39FC-4682-ADCD-EAD68070DA3A', 'Moscow Daylight Time', N'MSD+1', N'KZ', N'Kazakhstan', N'Asia/Aqtau', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'2035511A-1F59-4B9A-8036-00640D885B79', 'Aqtobe Time', N'AQTT', N'KZ', N'Kazakhstan', N'Asia/Aqtobe', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'1698D18D-25C9-4CB5-AA2D-DA4108DFDFBC', 'Moscow Daylight Time', N'MSD+1', N'KZ', N'Kazakhstan', N'Asia/Atyrau', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'08344F32-C538-4796-A0A8-563EA865CC3D', 'Oral Summer Time', N'ORAST', N'KZ', N'Kazakhstan', N'Asia/Oral', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'8CE6AA97-0EFE-4D04-A843-7FCA24A81F61', 'Qyzylorda Summer Time', N'QYZST', N'KZ', N'Kazakhstan', N'Asia/Qostanay', N'+0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 360),
		        ( N'66540F9B-1F60-4881-99FC-56B254771761', 'Moskow Standard Time', N'MSK+2', N'KZ', N'Kazakhstan', N'Asia/Qyzylorda', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'70BF3455-1D03-4F37-8D4F-BC116BCC01C9', 'East Africa Time', N'EAT', N'KE', N'Kenya', N'Africa/Nairobi', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'B35FCC63-31AA-41FE-8F40-10D9F9877FE9', 'Phoenix Island Time', N'PHOT', N'KI', N'Kiribati', N'Pacific/Enderbury', N'+1300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 780),
		        ( N'C7E4C682-2B40-4CBF-8229-E309AA7C08C9', 'Central European Summer Time', N'LINT', N'KI', N'Kiribati', N'Pacific/Kiritimati', N'+1400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 840),
		        ( N'25AEBF05-5E5F-48EF-877E-777715BBB9B2', 'Gilbert Island Time', N'GILT', N'KI', N'Kiribati', N'Pacific/Tarawa', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'96F1C70E-5E94-4E99-9B33-AD6467373D0C', 'Korea Standard Time ', N'KST', N'KP', N'Korea, Democratic People s Republic of', N'Asia/Pyongyang', N'+0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 540),
		        ( N'2ED91408-173A-4CC0-BE3B-12B620D9E65D', 'Korea Standard Time ', N'KST', N'KR', N'Korea, Republic of', N'Asia/Seoul', N'+0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 540),
		        ( N'82834ABF-1D21-4E46-97EB-E9B43FF91CB1', 'Atlantic Standard Time', N'AST', N'KW', N'Kuwait', N'Asia/Kuwait', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'189F234F-8689-4127-B0E5-9E8EADDB01AA', 'Kyrgyzstan Summer Time	', N'KGST', N'KG', N'Kyrgyzstan', N'Asia/Bishkek', N'+0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 360),
		        ( N'0C5FD76E-FC10-4A79-8654-748EA6BA7814', 'Indochina Time ', N'ICT', N'LA', N'Lao People s Democratic Republic', N'Asia/Vientiane', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'C176D1D3-A4FD-4C00-8895-4791D2C490FE', 'Eastern European Summer Time', N'EEST', N'LV', N'Latvia', N'Europe/Riga', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'071573A9-2D9B-4DFD-BA81-108526B56AE9', 'Eastern European Summer Time', N'EEST', N'LB', N'Lebanon', N'Asia/Beirut', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'59A4A635-088D-462A-BC12-9C07206EADC0', 'South Africa Standard Time', N'SAST', N'LS', N'Lesotho', N'Africa/Maseru', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'D9C4169E-11DF-4431-8133-5811CE1FD537', 'Greenwich Mean Time', N'GMT', N'LR', N'Liberia', N'Africa/Monrovia', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'C3D10E01-A28B-413B-A01A-03E592C510EE', 'Eastern European Time', N'EET', N'LY', N'Libya', N'Africa/Tripoli', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'876CCA7A-B44A-40AB-98C5-87019E1DB1B5', 'Central European Summer Time', N'CEST', N'LI', N'Liechtenstein', N'Europe/Vaduz', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'ABC35F84-7C32-4A42-A686-C7E5499EB12A', 'Eastern European Summer Time', N'EEST', N'LT', N'Lithuania', N'Europe/Vilnius', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'AE46BD87-2C99-48C2-AE2F-40A2BB309B50', 'Central European Summer Time', N'CEST', N'LU', N'Luxembourg', N'Europe/Luxembourg', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'11D7B812-15B6-4B5C-B263-7476D7F191F8', 'Central Standard Time', N'CST', N'MO', N'Macao', N'Asia/Macau', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'9DFE9B2F-362F-4B2A-8E3D-071C7AB8C69B', 'Central European Summer Time', N'CEST', N'MK', N'Macedonia, the Former Yugoslav Republic of', N'Europe/Skopje', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'FA92E154-6C92-41CA-8EF0-FF7FB019F17A', 'East Africa Time', N'EAT', N'MG', N'Madagascar', N'Indian/Antananarivo', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'A1122FA2-219D-4D4B-A996-E2885ADA466F', 'Central Africa Time', N'CAT', N'MW', N'Malawi', N'Africa/Blantyre', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'1584EF20-390E-4961-8940-111BA5B9D16C', 'Malaysia Time', N'MYT', N'MY', N'Malaysia', N'Asia/Kuala_Lumpur', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'5075583E-FF5A-4994-A3DC-200D6A2C6915', 'Malaysia Time', N'MYT', N'MY', N'Malaysia', N'Asia/Kuching', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'7FCFFB3B-2206-4BCD-95C3-06E2A7B247A9', 'Maldives Time', N'MVT', N'MV', N'Maldives', N'Indian/Maldives', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'0987568A-0808-4260-8494-252D00EEDC31', 'Greenwich Mean Time ', N'GMT', N'ML', N'Mali', N'Africa/Bamako', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'7D33048F-9A7E-48C9-BD66-F619DB50C89C', 'Central European Summer Time', N'CEST', N'MT', N'Malta', N'Europe/Malta', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'7924A917-E151-4C9A-A1D2-FE067576E6C9', 'Pacific Time', N'+12', N'MH', N'Marshall Islands', N'Pacific/Kwajalein', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'37962DFB-0323-4257-A01A-FDDBCF525016', 'Pacific MAjuro Time', N'+12', N'MH', N'Marshall Islands', N'Pacific/Majuro', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'89FC97A9-81BE-400B-ABC0-454704677ECB', 'Atlantic Standard Time', N'AST', N'MQ', N'Martinique', N'America/Martinique', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'8DF40C7B-7062-477F-824C-6B7C136912DC', 'Greenwich Mean Time ', N'GMT', N'MR', N'Mauritania', N'Africa/Nouakchott', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'4A86C739-1216-4939-B721-F173C5820557', 'Mauritius Time', N'MUT', N'MU', N'Mauritius', N'Indian/Mauritius', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'55E9061B-48C1-4B1B-B0CA-92965306ED1F', 'East Africa Time', N'EAT', N'YT', N'Mayotte', N'Indian/Mayotte', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'0971D5A2-648F-48FF-8C13-80F95623A6A6', 'Central Time Zone', N'CDT', N'MX', N'Mexico', N'America/Bahia_Banderas', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'9A2C8B5E-6E1B-4E7B-9500-4A0835EA2903', 'Eastern Standard Time ', N'EST', N'MX', N'Mexico', N'America/Cancun', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'63103E4E-D1C6-47CA-B177-E8D524300F83', 'Mountain Daylight Time', N'MDT', N'MX', N'Mexico', N'America/Chihuahua', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'1FC90F75-3BEE-46FF-94A3-6BC6812B5F94', 'Mountain Standard Time ', N'MST', N'MX', N'Mexico', N'America/Hermosillo', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'16617074-C9EE-4B90-956C-F6C0A5B6E4B2', 'Central Time Zone', N'CDT', N'MX', N'Mexico', N'America/Matamoros', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'16B78399-5888-4807-BD37-416D8F852AEB', 'Mountain Daylight Time', N'MDT', N'MX', N'Mexico', N'America/Mazatlan', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'9A0E00FC-DBCB-4D61-8E78-F3165BF06F12', 'Central Time Zone', N'CDT', N'MX', N'Mexico', N'America/Merida', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'637F7B70-1AF2-4917-A65C-2FF775CA81F5', 'Central Time Zone', N'CDT', N'MX', N'Mexico', N'America/Mexico_City', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'BD4E7AB0-6384-42A7-8101-6039FBB9DEB4', 'Central Time Zone', N'CDT', N'MX', N'Mexico', N'America/Monterrey', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'616EADDA-A34A-4DC4-BB0C-EC93E90615C2', 'Mountain Daylight Time', N'MDT', N'MX', N'Mexico', N'America/Ojinaga', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'4C89245B-7D89-45ED-A5CC-0B68FF2B889E', 'Pacific Daylight Time', N'PDT', N'MX', N'Mexico', N'America/Tijuana', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'31B6208F-74A0-4FCE-AEAB-14F97E9E6A44', 'Chuuk Time ', N'CHUT', N'FM', N'Micronesia, Federated States of', N'Pacific/Chuuk', N'+1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 600),
		        ( N'EE372F00-03A7-4B80-AD04-3CFBC75C9BB2', 'Kosrae Time', N'KOST', N'FM', N'Micronesia, Federated States of', N'Pacific/Kosrae', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'994CF5B8-75C8-46F2-BF97-AB0CC0D6A27B', 'Pohnpei Standard Time', N'PONT', N'FM', N'Micronesia, Federated States of', N'Pacific/Pohnpei', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'34B9032D-CEF3-4F33-A187-A03D9342C13F', 'Eastern European Summer Time', N'EEST', N'MD', N'Moldova, Republic of', N'Europe/Chisinau', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'E12CA9F1-7BA5-4698-A765-4D945BE3D6FA', 'Central European Summer Time', N'CEST', N'MC', N'Monaco', N'Europe/Monaco', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'43E85DE1-E7E1-443B-BD3E-B30804970963', 'Choibalsan Time ', N'CHOT', N'MN', N'Mongolia', N'Asia/Choibalsan', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'49BF2646-2483-4EAE-B9B7-9A44AD0D2571', 'Hovd Time', N'HOVT', N'MN', N'Mongolia', N'Asia/Hovd', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'BFF170E6-7D7D-4C4C-A749-F37A46FC8E15', 'Ulaanbaatar Time', N'ULAT', N'MN', N'Mongolia', N'Asia/Ulaanbaatar', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'A3BBB87F-5EF3-4281-98A7-74E7430A6573', 'Central European Summer Time', N'CEST', N'ME', N'Montenegro', N'Europe/Podgorica', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'3FC4692E-934C-4063-862A-42299E4B8305', 'Atlantic Standard Time', N'AST', N'MS', N'Montserrat', N'America/Montserrat', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'89E2BADB-4C79-4FC9-8564-3530116CA554', 'Western European Summer Time', N'WEST', N'MA', N'Morocco', N'Africa/Casablanca', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'0880785E-1F31-4F4A-ABB4-020F6A41FA94', 'Central Africa Time', N'CAT', N'MZ', N'Mozambique', N'Africa/Maputo', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'861234FF-735F-4E92-991F-C9F2AE1E0748', 'Myanmar Standard Time', N'MMT', N'MM', N'Myanmar', N'Asia/Yangon', N'+0630', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 390),
		        ( N'E06A3574-B8CD-4063-A749-60D197AAD149', 'Central Africa Time', N'CAT', N'NA', N'Namibia', N'Africa/Windhoek', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'BDE47503-2450-44BF-B31A-5394F44B29B6', 'Nauru Time', N'NRT', N'NR', N'Nauru', N'Pacific/Nauru', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'79EE8AC6-5B43-4FF1-B30F-D7A2D98D4C49', 'Nepal Time ', N'NPT', N'NP', N'Nepal', N'Asia/Kathmandu', N'+0545', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 345),
		        ( N'F4D4E8B3-44E1-4BDC-A3DE-44B67927571E', 'Central European Summer Time', N'CEST', N'NL', N'Netherlands', N'Europe/Amsterdam', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'C6B35D46-2366-4FD5-8B3B-140C30F5FFD9', 'New Caledonia Time', N'NCT', N'NC', N'New Caledonia', N'Pacific/Noumea', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'038B0D23-0EAD-4313-AAF9-2600AA8DFB1F', 'New Zealand Daylight Time', N'NZDT', N'NZ', N'New Zealand', N'Pacific/Auckland', N'+1300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 780),
		        ( N'42D4A2DF-AB82-4F1E-89A5-0454FA1B8EBF', 'Chatham Standard Time', N'CHAST', N'NZ', N'New Zealand', N'Pacific/Chatham', N'+1345', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 825),
		        ( N'C4CB9C07-9A16-4230-9B1A-BE4AA78A7FA3', 'Central Standard Time', N'CST', N'NI', N'Nicaragua', N'America/Managua', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'F0B830B7-275E-4B1D-820A-BD9593DCC875', 'West Africa Time ', N'WAT', N'NE', N'Niger', N'Africa/Niamey', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'5B110F97-ECA0-4194-80C2-DE634DABF535', 'West Africa Time ', N'WAT', N'NG', N'Nigeria', N'Africa/Lagos', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'746256E3-C202-4D56-AA10-E3D8E26DD876', 'Niue Time', N'NUT', N'NU', N'Niue', N'Pacific/Niue', N'-1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -660),
		        ( N'15ECCAD6-955D-4CA2-A9D7-FA0A34B91CE8', 'Norfolk Daylight Time ', N'NFDT', N'NF', N'Norfolk Island', N'Pacific/Norfolk', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'4DDCBF49-9476-420F-94BD-57B3050EEEFD', 'Chamorro Standard Time  ', N'ChST', N'MP', N'Northern Mariana Islands', N'Pacific/Saipan', N'+1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 600),
		        ( N'C431DFBD-62AD-47D0-A4C7-E6ED2583E4D1', 'Central European Summer Time', N'CEST', N'NO', N'Norway', N'Europe/Oslo', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'37B8B4AA-3080-464C-B199-E2598659A164', 'Gulf Standard Time ', N'GST', N'OM', N'Oman', N'Asia/Muscat', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'07C11E04-0098-4910-ABC6-15D4FAAF53B3', 'Pakistan Standard Time ', N'PKT', N'PK', N'Pakistan', N'Asia/Karachi', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'C4115050-8635-4B00-92D6-A65EA2FBE63A', 'Palau Time', N'+09', N'PW', N'Palau', N'Pacific/Palau', N'+0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 540),
		        ( N'B53310DD-55E0-46F4-8B04-102E5DAC2ADE', 'Eastern European Summer Time', N'EEST', N'PS', N'Palestine, State of', N'Asia/Gaza', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'FD40B4DF-29B7-43A4-80E5-969301293491', 'Eastern European Summer Time', N'EEST', N'PS', N'Palestine, State of', N'Asia/Hebron', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'D7F829CF-3C4F-4032-A1AA-4246E30DB216', 'Eastern Standard Time', N'EST', N'PA', N'Panama', N'America/Panama', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'13EE973A-71F1-460D-A11D-7B019547ABD9', 'British Summer Time  ', N'BST', N'PG', N'Papua New Guinea', N'Pacific/Bougainville', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'09115522-2F3F-4354-B144-AA6BD8312F27', 'Papua New Guinea Time', N'PGT', N'PG', N'Papua New Guinea', N'Pacific/Port_Moresby', N'+1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 600),
		        ( N'98B0AE98-67FF-4D74-A924-1F77DE0F8476', 'Paraguay Summer Time', N'PYST', N'PY', N'Paraguay', N'America/Asuncion', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'C1055931-6B34-46D6-8343-60B136F66559', 'Peru Time', N'PET', N'PE', N'Peru', N'America/Lima', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'C23EB287-9E60-4C29-BDB3-6739A08E68E6', 'Pacific Standard Time ', N'PST', N'PH', N'Philippines', N'Asia/Manila', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'8D523907-5B36-4588-BD9C-B18CD10061D5', 'Pacific Standard Time ', N'PST', N'PN', N'Pitcairn', N'Pacific/Pitcairn', N'-0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -480),
		        ( N'FC401C64-6236-4A31-9C4A-FC2F9A21F903', 'Central European Summer Time', N'CEST', N'PL', N'Poland', N'Europe/Warsaw', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'ED772C50-7EA9-4DC5-8515-1FF43925EE2E', 'Azores Standard Time ', N'AZOST', N'PT', N'Portugal', N'Atlantic/Azores', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'CBE9D912-B2E1-41BB-8270-B895CC9E0EBA', 'Western European Summer Time', N'WEST', N'PT', N'Portugal', N'Atlantic/Madeira', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'15C60D46-7362-47C2-B00E-C8D840518364', 'Western European Summer Time', N'WEST', N'PT', N'Portugal', N'Europe/Lisbon', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'9EFA8D68-4A77-4AA4-BED4-5359DD7BED5D', 'Atlantic Standard Time', N'AST', N'PR', N'Puerto Rico', N'America/Puerto_Rico', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'F23190E3-499F-4DA5-B7A0-49595FC5299F', 'Atlantic Standard Time', N'AST', N'QA', N'Qatar', N'Asia/Qatar', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'0236B15D-A99B-40A7-A124-FB2BF46AB8A9', 'Eastern European Summer Time', N'EEST', N'RO', N'Romania', N'Europe/Bucharest', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'6EB4498D-BD2D-43A1-877D-5C82E607333F', 'Anadyr Time', N'ANAT', N'RU', N'Russian Federation', N'Asia/Anadyr', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'9A19FA4D-99EF-4BDA-BA56-84A436C8BB78', 'Moscow Standard Time ', N'MSK+4', N'RU', N'Russian Federation', N'Asia/Barnaul', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'3387859D-2EBA-4C07-9591-A74EAF4BCF86', 'Yakutsk Time', N'YAKT', N'RU', N'Russian Federation', N'Asia/Chita', N'+0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 540),
		        ( N'12473584-BD5B-47D0-8F47-01C9FF384F5F', 'Irkutsk Time', N'IRKT', N'RU', N'Russian Federation', N'Asia/Irkutsk', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'6E613F29-F287-4521-A264-2C5B8364F165', 'Kamchatka Time', N'PETT', N'RU', N'Russian Federation', N'Asia/Kamchatka', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'E55BD0B3-56E7-489B-826C-2D83433E1675', 'Yakutsk Time', N'YAKT', N'RU', N'Russian Federation', N'Asia/Khandyga', N'+0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 540),
		        ( N'A4ABADD7-248F-4ADD-93A1-A4B1DE3F347C', 'Krasnoyarsk Time', N'KRAT', N'RU', N'Russian Federation', N'Asia/Krasnoyarsk', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'A27F2496-CD0F-4128-9E94-DCBD5AB6AB20', 'Magadan Time', N'MAGT', N'RU', N'Russian Federation', N'Asia/Magadan', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'11D49D75-BE51-418F-9282-1674532D492A', 'Krasnoyarsk Time', N'KRAT', N'RU', N'Russian Federation', N'Asia/Novokuznetsk', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'4E5F4086-BEF9-4B75-9128-81FC86373115', 'Novosibirsk Time', N'NOVT', N'RU', N'Russian Federation', N'Asia/Novosibirsk', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'80CAD3F5-1862-49C8-BA2C-017F205817C8', 'Omsk Standard Time', N'OMST', N'RU', N'Russian Federation', N'Asia/Omsk', N'+0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 360),
		        ( N'D6B606DD-55B9-4573-A11B-FEF70FEA4E05', 'Sakhalin Time ', N'SAKT', N'RU', N'Russian Federation', N'Asia/Sakhalin', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'949C273A-B0A5-4DFE-81A0-B25B1266E821', 'Srednekolymsk Time ', N'SRET', N'RU', N'Russian Federation', N'Asia/Srednekolymsk', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'D35DB9C1-7A79-4A25-96D8-510AD1568DBE', 'Moscow Daylight Time', N'MSD+3', N'RU', N'Russian Federation', N'Asia/Tomsk', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'781BA6DE-DB0E-47C4-820D-377DFBDB7740', 'Vladivostok Time', N'VLAT', N'RU', N'Russian Federation', N'Asia/Ust-Nera', N'+1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 600),
		        ( N'D4BE688F-1B40-417A-9637-09A453369616', 'Vladivostok Time', N'VLAT', N'RU', N'Russian Federation', N'Asia/Vladivostok', N'+1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 600),
		        ( N'AEBAE693-40FA-4066-98BD-D4371CD694F2', 'Yakutsk Time', N'YAKT', N'RU', N'Russian Federation', N'Asia/Yakutsk', N'+0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 540),
		        ( N'04E9B6C5-AE89-4980-AADE-5D2F9E99AE09', 'Yekaterinburg Time ', N'YEKT', N'RU', N'Russian Federation', N'Asia/Yekaterinburg', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'383F1E4A-1512-44DE-AF3F-B3F69B5BD1F2', 'Moscow Standard Time', N'MSK+1', N'RU', N'Russian Federation', N'Europe/Astrakhan', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'11AAE107-E295-488C-BB83-40ADC28DC996', 'Eastern European Time', N'EET', N'RU', N'Russian Federation', N'Europe/Kaliningrad', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'C1CB49E4-9BBB-4393-B2E8-76684D2F5134', 'Moscow Standard Time', N'MSK', N'RU', N'Russian Federation', N'Europe/Kirov', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'B54ECA10-5EE7-440B-94CB-D6B8524AB18F', 'Moscow Standard Time', N'MSK', N'RU', N'Russian Federation', N'Europe/Moscow', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'F7C138E4-824C-4BDD-B527-06A112F73D46', 'Samara Time', N'SAMT', N'RU', N'Russian Federation', N'Europe/Samara', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'117E7252-9E92-4A92-A86E-68FA9FC28E46', 'Moscow Daylight Time', N'MSD', N'RU', N'Russian Federation', N'Europe/Saratov', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'D2597123-8FC7-49F4-9D93-7D7CC1DEDC17', 'Moscow Standard Time', N'MSK+1', N'RU', N'Russian Federation', N'Europe/Ulyanovsk', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'CCF33F15-C5E8-4666-921D-8D152E4E11E4', 'Volgograd Time', N'VOLT', N'RU', N'Russian Federation', N'Europe/Volgograd', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'635BFA94-37EE-4C52-BDF6-69E7770FA836', 'Central Africa Time', N'CAT', N'RW', N'Rwanda', N'Africa/Kigali', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'5D09B83F-7773-4232-9F65-4E0040DE53C1', 'Réunion Time ', N'RET', N'RE', N'Réunion', N'Indian/Reunion', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'EAA9E616-1883-4604-BC5B-5B7148902A9B', 'Atlantic Standard Time', N'AST', N'BL', N'Saint Barthélemy', N'America/St_Barthelemy', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'3E3C6CF4-98BF-4C40-96F5-C8C95CCA7998', 'Greenwich Mean Time ', N'GMT', N'SH', N'Saint Helena, Ascension and Tristan da Cunha', N'Atlantic/St_Helena', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'AE16FC24-CBE7-4B15-959E-A320C81FBB61', 'Atlantic Standard Time', N'AST', N'KN', N'Saint Kitts and Nevis', N'America/St_Kitts', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'1856A8E6-6E14-4AD1-82C5-DDB362E55855', 'Atlantic Standard Time', N'AST', N'LC', N'Saint Lucia', N'America/St_Lucia', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'FB60CBAD-2BE7-4399-A178-6400A4895EF2', 'Atlantic Standard Time', N'AST', N'MF', N'Saint Martin (French part)', N'America/Marigot', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'B710547C-5845-47B9-B348-50B25944E5A1', 'Pierre & Miquelon Standard Time', N'PMST', N'PM', N'Saint Pierre and Miquelon', N'America/Miquelon', N'-0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -120),
		        ( N'33C5B7F8-BBE0-4C99-9481-BF993D4D3BE0', 'Atlantic Standard Time', N'AST', N'VC', N'Saint Vincent and the Grenadines', N'America/St_Vincent', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'358E05EA-5F81-44E6-B2A7-7919F834BB20', 'Western Standard Time ', N'WST', N'WS', N'Samoa', N'Pacific/Apia', N'+1400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 840),
		        ( N'9DB1066F-DA5D-4E2D-A98B-24A43C85A113', 'Central European Summer Time', N'CEST', N'SM', N'San Marino', N'Europe/San_Marino', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'F0679C1D-BDA2-4BBA-9FF5-5276D0E13736', 'Greenwich Mean Time ', N'GMT', N'ST', N'Sao Tome and Principe', N'Africa/Sao_Tome', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'685e353e-ebf4-493c-9bff-a57df5d09f10', 'Arab Standard Time', N'AST', N'SA', N'Saudi Arabia', N'Asia/Riyadh', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'40CFD297-0214-4E6C-A30F-A1EBDEB0E891', 'Greenwich Mean Time ', N'GMT', N'SN', N'Senegal', N'Africa/Dakar', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'6385619F-6C99-4B07-A718-B3D36EE93511', 'Central European Summer Time', N'CEST', N'RS', N'Serbia', N'Europe/Belgrade', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'F622DC97-7976-4FC2-AEF2-E502EA7180E7', 'Seychelles Time', N'SCT', N'SC', N'Seychelles', N'Indian/Mahe', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'207430D9-7ACB-4EC3-8BEB-2B08710FA237', 'Greenwich Mean Time ', N'GMT', N'SL', N'Sierra Leone', N'Africa/Freetown', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'15F325CA-9E7B-42CB-9FEB-DDCB3CD08C0A', 'Singapore Standard Time', N'SST', N'SG', N'Singapore', N'Asia/Singapore', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'C10D344A-A559-42A8-837E-3AD41F92FF7B', 'Atlantic Standard Time ', N'AST', N'SX', N'Sint Maarten (Dutch part)', N'America/Lower_Princes', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'86F634E8-9F86-4225-8169-E9B00F6C175D', 'Central European Summer Time', N'CEST', N'SK', N'Slovakia', N'Europe/Bratislava', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'5DFB77A1-28BC-4599-9B06-757D4CD8D3CB', 'Central European Summer Time', N'CEST', N'SI', N'Slovenia', N'Europe/Ljubljana', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'02EE6714-E514-4823-8322-B1AB5D299B8B', 'Solomon Islands Time', N'SBT', N'SB', N'Solomon Islands', N'Pacific/Guadalcanal', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'B8BF4363-BC22-4B0C-862F-F8FEF2790612', 'East Africa Time', N'EAT', N'SO', N'Somalia', N'Africa/Mogadishu', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'C6B5904B-1770-4C9E-991D-BC6E0FFC5A22', 'South African Standard Time', N'SAST', N'ZA', N'South Africa', N'Africa/Johannesburg', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'72EE290C-9209-432A-BC9C-A7258EB49304', 'Gulf Standard Time ', N'GST', N'GS', N'South Georgia and the South Sandwich Islands', N'Atlantic/South_Georgia', N'-0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -120),
		        ( N'144F77A9-3A13-4239-B55C-FCEC741E0B82', 'East Africa Time', N'EAT', N'SS', N'South Sudan', N'Africa/Juba', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'398A7FCA-1832-4536-9914-438A57591A93', 'Central European Summer Time', N'CEST', N'ES', N'Spain', N'Africa/Ceuta', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'23D4E8B0-0D0D-4C6C-8D2A-8C2431D91D09', 'Western European Summer Time', N'WEST', N'ES', N'Spain', N'Atlantic/Canary', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'C238C7EB-D89D-4356-B22A-C7185A7197DE', 'Central European Summer Time', N'CEST', N'ES', N'Spain', N'Europe/Madrid', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'A93E7C7C-DD07-498A-BE8F-BA6C76C3EE44', 'Indian Standard Time', N'IST', N'LK', N'Sri Lanka', N'Asia/Colombo', N'+0530', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 330),
		        ( N'F1E3B838-10A6-4324-851A-8F9AAA4DD68B', 'Central Africa Time', N'CAT', N'SD', N'Sudan', N'Africa/Khartoum', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'AFB2F899-770C-48E4-A131-55B0E585686B', 'Suriname Time', N'SRT', N'SR', N'Suriname', N'America/Paramaribo', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'21785083-762D-4F21-90D3-90713314D645', 'Central European Summer Time', N'CEST', N'SJ', N'Svalbard and Jan Mayen', N'Arctic/Longyearbyen', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'8AC0BD56-AF40-40C4-B6C1-A037A835318A', 'South African Standard Time  ', N'SAST', N'SZ', N'Swaziland', N'Africa/Mbabane', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'2017D54D-EB46-4BBD-B4EF-23A7B0A0AFB7', 'Central European Summer Time', N'CEST', N'SE', N'Sweden', N'Europe/Stockholm', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'F5F50D33-F560-41AB-AD5E-E0C2D0FE9A67', 'Central European Summer Time', N'CEST', N'CH', N'Switzerland', N'Europe/Zurich', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'19425BF7-FCAB-4BCB-90C5-DE64CA818F38', 'Eastern European Summer Time', N'EEST', N'SY', N'Syrian Arab Republic', N'Asia/Damascus', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'46E2633F-7148-41AD-8D1B-AAE1F0C4033F', 'Central Standard Time', N'CST', N'TW', N'Taiwan, Province of China', N'Asia/Taipei', N'+0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 480),
		        ( N'44EC10E8-910E-40D9-BB79-31D9521787D8', 'Tajikistan Time', N'TJT', N'TJ', N'Tajikistan', N'Asia/Dushanbe', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'F825F630-35F2-49CF-83F6-092BC650AF9F', 'East Africa Time', N'EAT', N'TZ', N'Tanzania, United Republic of', N'Africa/Dar_es_Salaam', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'15A624C4-DF3A-4507-B4DB-1E5A4C55CF11', 'Indochina Time', N'ICT', N'TH', N'Thailand', N'Asia/Bangkok', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'ACEC511F-F61F-4405-BE2E-49B132816E2F', 'East Timor Time', N'TLT', N'TL', N'Timor-Leste', N'Asia/Dili', N'+0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 540),
		        ( N'6724653E-6671-4F8A-946A-E12EDCED09CA', 'Greenwich Mean Time', N'GMT', N'TG', N'Togo', N'Africa/Lome', N'+0000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 0),
		        ( N'1046BCB6-F915-4BD3-92A9-B8A9DDD8F28C', 'Tokelau Time', N'TKT', N'TK', N'Tokelau', N'Pacific/Fakaofo', N'+1300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 780),
		        ( N'76AA991C-BB29-4AB4-8BB0-1C7FF8214047', 'Tonga Time', N'TOT', N'TO', N'Tonga', N'Pacific/Tongatapu', N'+1300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 780),
		        ( N'C9788B22-B9F1-4649-AA2C-A5E3E2719C33', 'Atlantic Standard Time', N'AST', N'TT', N'Trinidad and Tobago', N'America/Port_of_Spain', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'3B4582AA-4857-4FC1-8D96-13AF62891520', 'Central European Time', N'CET', N'TN', N'Tunisia', N'Africa/Tunis', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'01F05307-0A4B-4BCB-A11E-4168F8D4680A', 'Turkey Time', N'TRT', N'TR', N'Turkey', N'Europe/Istanbul', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'7239AB7B-F773-484F-893C-4726E8D34CBF', 'Turkmenistan Time', N'TMT', N'TM', N'Turkmenistan', N'Asia/Ashgabat', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'AACB4391-947A-48C7-BA07-B1400D5B4679', 'Eastern Daylight Time', N'EDT', N'TC', N'Turks and Caicos Islands', N'America/Grand_Turk', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'E7431F81-5170-45D6-94BB-7570A3448510', 'Tuvalu Time ', N'TVT', N'TV', N'Tuvalu', N'Pacific/Funafuti', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'9EB057D8-131E-43C5-8ED5-71B431A666F3', 'East Africa Time', N'EAT', N'UG', N'Uganda', N'Africa/Kampala', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'5BD6F50C-CF37-4B25-BDDC-C1CEF2CFE141', 'Eastern European Summer Time', N'EEST', N'UA', N'Ukraine', N'Europe/Kiev', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'3257F041-EB46-46F9-BA36-6CA4919D96D1', 'Moscow Standard Time ', N'MSK', N'UA', N'Ukraine', N'Europe/Simferopol', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'59952B08-4728-46B3-88E9-36F12303A746', 'Eastern European Summer Time', N'EEST', N'UA', N'Ukraine', N'Europe/Uzhgorod', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'900158C9-5980-4873-8FA5-6EDB444BCD04', 'Eastern European Summer Time', N'EEST', N'UA', N'Ukraine', N'Europe/Zaporozhye', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'8FA3FD39-B6AE-4C99-A7ED-3AA0DAC7A3B4', 'Gulf Standard Time', N'GST', N'AE', N'United Arab Emirates', N'Asia/Dubai', N'+0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 240),
		        ( N'75C68C65-4A3B-4DFE-8B19-1D29F42C6274', 'British Summer Time', N'BST', N'GB', N'United Kingdom', N'Europe/London', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'B8B992DD-05B6-4A75-AF37-B1BDC5152F18', 'Hawaii-Aleutian Daylight Time ', N'HDT', N'US', N'United States', N'America/Adak', N'-0900', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -540),
		        ( N'DDD728E5-2513-412F-BA99-D54E0CE03278', 'Alaska Daylight Time', N'AKDT', N'US', N'United States', N'America/Anchorage', N'-0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -480),
		        ( N'36E0E2C0-A23B-4891-8C34-4F0A1F8D825D', 'Mountain Daylight Time', N'MDT', N'US', N'United States', N'America/Boise', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'4C0C0A67-865E-4B01-8E20-F575D44763E3', 'Central Time Zone', N'CDT', N'US', N'United States', N'America/Chicago', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'B3F42E85-619E-4E29-A467-C9CFC8516D6B', 'Mountain Daylight Time', N'MDT', N'US', N'United States', N'America/Denver', N'-0600', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -360),
		        ( N'6FFBE380-5B56-4959-99B0-B019A47B2ABA', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/Detroit', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'ED08D894-B784-4A1B-BFC0-1E5F67ED5A6F', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/Indiana/Indianapolis', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'9BEBE8B3-6947-47F3-B4CD-41172E35D081', 'Central Time Zone', N'CDT', N'US', N'United States', N'America/Indiana/Knox', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'F3FC8854-F7FA-446A-92F2-167030E49776', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/Indiana/Marengo', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'26FD5C7A-B25E-4875-8382-5A1AC9BB4BAA', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/Indiana/Petersburg', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'22CA73B3-1B1E-405C-B3A1-62A03549FA1C', 'Central Time Zone', N'CDT', N'US', N'United States', N'America/Indiana/Tell_City', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'30AAE8F5-E8F6-4D5D-B4EB-7A37255EF178', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/Indiana/Vevay', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'2D182E88-4F53-4EC1-A84F-A9F34BA7DA0A', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/Indiana/Vincennes', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'47E5CD7A-9B0B-4B8A-B0D1-89787840AF8E', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/Indiana/Winamac', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'B12EE944-7A1F-45F2-A7FB-B3D5F94BE494', 'Alaska Daylight Time', N'AKDT', N'US', N'United States', N'America/Juneau', N'-0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -480),
		        ( N'04D6DA6D-5361-4A51-8877-7A53B894DCA5', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/Kentucky/Louisville', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'AD656FF7-0758-4D03-BACC-55D7D5F9C0EF', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/Kentucky/Monticello', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'C9548B7C-4343-4514-92D1-53E61E850A54', 'Pacfic Daylight Time', N'PDT', N'US', N'United States', N'America/Los_Angeles', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'609817CD-0002-4C63-803D-545666F1BC99', 'Central Time Zone', N'CDT', N'US', N'United States', N'America/Menominee', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'01E46337-C8CA-4097-AEDE-26D4735CC159', 'Alaska Daylight Time', N'AKDT', N'US', N'United States', N'America/Metlakatla', N'-0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -480),
		        ( N'7A7D3705-A652-4EC8-B2B3-244D667A08A5', 'Eastern Daylight Time', N'EDT', N'US', N'United States', N'America/New_York', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'C5530C73-03C2-4C7E-BD84-E5BCAA7C4F64', 'Alaska Daylight Time ', N'AKDT', N'US', N'United States', N'America/Nome', N'-0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -480),
		        ( N'BA7AEC65-7FC9-4013-A8C4-D38F7A73BE77', 'Central Time Zone', N'CDT', N'US', N'United States', N'America/North_Dakota/Beulah', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'E522650B-FF84-49AD-AB2A-79E5CA1EE0E3', 'Central Time Zone', N'CDT', N'US', N'United States', N'America/North_Dakota/Center', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'2642DEAD-A33D-4D7F-881C-27AFCA8227B7', 'Central Time Zone', N'CDT', N'US', N'United States', N'America/North_Dakota/New_Salem', N'-0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -300),
		        ( N'016C2D5C-10B8-4B1C-963D-0AF33D9BA4E6', 'Mountain Standard Time', N'MST', N'US', N'United States', N'America/Phoenix', N'-0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -420),
		        ( N'5FF9597D-E26E-47A2-908F-1CF9F5A07B17', 'Alaska Daylight Time ', N'AKDT', N'US', N'United States', N'America/Sitka', N'-0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -480),
		        ( N'CD76CB2A-B1F7-43DF-A356-EF630E1E0B6C', 'Alaska Daylight Time ', N'AKDT', N'US', N'United States', N'America/Yakutat', N'-0800', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -480),
		        ( N'47DA5B56-9901-41E3-BEC7-9D627413B9F1', 'Hawaii Standard Time ', N'HST', N'US', N'United States', N'Pacific/Honolulu', N'-1000', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -600),
		        ( N'9B432E86-11E0-4813-A3A0-4A1B280E86F9', 'Samoa Standard Time  ', N'SST', N'UM', N'United States Minor Outlying Islands', N'Pacific/Midway', N'-1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -660),
		        ( N'ACF82F5F-2ABA-4E36-975C-949465058435', 'Wake Time', N'WAKT', N'UM', N'United States Minor Outlying Islands', N'Pacific/Wake', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'55F22D23-C882-4BCD-83DD-838AEB90DFFD', 'Uruguay Standard Time ', N'UYT', N'UY', N'Uruguay', N'America/Montevideo', N'-0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -180),
		        ( N'4F1A2211-B668-4812-9D96-836090737E65', 'Uzbekistan Time ', N'UZT', N'UZ', N'Uzbekistan', N'Asia/Samarkand', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'3AE95021-44F1-4E89-915A-E5F1F903FD46', 'Uzbekistan Time', N'UZT', N'UZ', N'Uzbekistan', N'Asia/Tashkent', N'+0500', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 300),
		        ( N'DBB02E5B-A29D-4AA9-B260-4842B86154ED', 'Vanuatu Standard Time', N'VUT', N'VU', N'Vanuatu', N'Pacific/Efate', N'+1100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 660),
		        ( N'C26F9BD6-C978-46DC-9177-B976E1C1964F', 'Venezuelan Standard Time', N'VET', N'VE', N'Venezuela, Bolivarian Republic of', N'America/Caracas', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'B407C742-0957-4926-95A7-1297BD9BA072', 'Israeli Daylight Time ', N'IDT', N'VN', N'Viet Nam', N'Asia/Ho_Chi_Minh', N'+0700', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 420),
		        ( N'BAF81286-C2FA-41F1-8B1D-7C449BDD6BDA', 'Atlantic Standard Time', N'AST', N'VG', N'Virgin Islands, British', N'America/Tortola', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'BD675DF1-14CA-4575-9008-3D666CA5DCD5', 'Atlantic Standard Time', N'AST', N'VI', N'Virgin Islands, U.S.', N'America/St_Thomas', N'-0400', CAST(N'2021-12-01 06:16:18.460' AS DateTime), -240),
		        ( N'E42C384A-759F-4DA1-85B7-40101E293A41', 'Wallis & Futuna Time', N'WFT', N'WF', N'Wallis and Futuna', N'Pacific/Wallis', N'+1200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 720),
		        ( N'6BDBE16F-F83A-47D2-AD07-8E584F3B4887', 'Western European Summer Time', N'WEST', N'EH', N'Western Sahara', N'Africa/El_Aaiun', N'+0100', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 60),
		        ( N'5C5FDCB1-DCF1-4FF5-B85E-6E3F24C85B65', 'Atlantic Standard Time', N'AST', N'YE', N'Yemen', N'Asia/Aden', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180),
		        ( N'635BC5AF-C948-441A-85AC-9276BEA873EB', 'Central Africa Time', N'CAT', N'ZM', N'Zambia', N'Africa/Lusaka', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'7E636107-2B8A-4D3F-A4D7-6654AA42E165', 'Central Africa Time', N'CAT', N'ZW', N'Zimbabwe', N'Africa/Harare', N'+0200', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 120),
		        ( N'47BDFAFD-B50E-4876-A77B-094CEBDD8637', 'Eastern European Summer Time', N'EEST', N'AX', N'Åland Islands', N'Europe/Mariehamn', N'+0300', CAST(N'2021-12-01 06:16:18.460' AS DateTime), 180)
			     )																																										
		AS Source([Id], [TimeZoneName], [TimeZoneAbbreviation], [CountryCode], [CountryName], [TimeZone], [TimeZoneOffset], [CreatedDateTime], [OffsetMinutes])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET 
			       [CreatedDateTime] = Source.[CreatedDateTime],
				   [TimeZoneName] = Source.[TimeZoneName],
				   [TimeZoneAbbreviation] = Source.[TimeZoneAbbreviation],
				   [CountryCode] = Source.[CountryCode],
				   [CountryName] = Source.[CountryName],
				   [TimeZone] = Source.[TimeZone],
				   [TimeZoneOffset] = source.[TimeZoneOffset],
                   [OffsetMinutes] = source.[OffsetMinutes]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT([Id], [TimeZoneName], [TimeZoneAbbreviation], [CountryCode], [CountryName], [TimeZone], [TimeZoneOffset], [CreatedDateTime], [OffsetMinutes]) 
		VALUES([Id], [TimeZoneName], [TimeZoneAbbreviation], [CountryCode], [CountryName], [TimeZone], [TimeZoneOffset], [CreatedDateTime], [OffsetMinutes]);

    MERGE INTO [dbo].[Feature] AS Target 
    USING ( VALUES 
		(N'7EEE0735-9D75-49D9-88FE-710B2B466107', N'View audits', NULL, 'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, 'F46D2E60-4AD5-4882-BF54-C75BD26A0ED1', CAST(N'2020-04-10T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'71677129-594B-4BA0-8D8D-B632A603CBD8', N'View projects in audits', NULL, 'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, 'F46D2E60-4AD5-4882-BF54-C75BD26A0ED1', CAST(N'2020-04-10T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        , (N'bfc75ce3-5d68-4925-81ea-00976c6f662f', N'Manage region', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'0125c44b-d3b6-4d40-8795-910bcf6bddf1', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a6cd2213-5d0f-4656-9961-00aa07ce13f8', N'Add or update employee job', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7e174395-8f84-4930-8394-2cecd6ae7cee', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd619a93e-e87d-43e2-ae49-022dd79380bd', N'Manage time format', NULL, N'632c2c2e-3527-45b1-9de8-6043a12f3942', 1, N'43638781-b54a-4f49-b1c8-4d1f2821ea98', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5416a640-3f1a-461f-a0a0-0260434a7f98', N'View leaves', NULL, N'f80dd978-f979-4990-b084-59c48e272a2e', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0d8663cb-49f3-49db-8679-030207ca3fc5', N'Manage testcase automation type', NULL, N'37e0c505-fa24-426b-8da6-5fd17fc5bea2', 1, N'49c19c1f-c877-4972-997c-291598456c4c', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'445311b1-285f-4cc7-8fa4-04e7c5221a3e', N'Manage education levels', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'efa76132-e5fb-44f8-99ba-6e428ce9f55a', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'EBCAE677-B157-4795-ABB1-2CA8B351652A', N'admin dashboard menuitem', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'95fb2411-51c5-46c7-b712-05612528e302', N'My work', NULL, NULL, 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'373da4e5-faa3-4656-8800-057e15eaafb1', N'Notifications', NULL, NULL, 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'76545d51-8bc0-46dc-b5d3-603051c6e797', N'Manage form type', NULL, N'438c6f61-ca8a-4ae9-8d29-ddf92f30ff01', 1, N'6bdc7d4f-8fa7-49f6-bd23-8e80963069e7', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'C8DF56DF-5438-4876-8B5E-5D46BB3FA087', N'Manage custom form Submissions', NULL, N'438c6f61-ca8a-4ae9-8d29-ddf92f30ff01', 1, N'6bdc7d4f-8fa7-49f6-bd23-8e80963069e7', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'465e3538-c86a-42af-b865-0586f1816029', N'Status reporting', NULL, NULL, 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8ca7b841-31a8-48d2-b6d1-3f299be90cb7', N'Add or update status reporting configuration', NULL, N'465e3538-c86a-42af-b865-0586f1816029', 1, N'7e174395-8f84-4930-8394-2cecd6ae7cee', CAST(N'2019-05-24T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'436eac34-e8e1-4d15-8b26-061144ff0f90', N'View employee contact details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a91cf15f-692e-4328-8d57-0851bc66ec8c', N'HR management', NULL, NULL, 1, N'f6ab769c-671a-48c5-94b0-1eaf5c3fca85', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'fd3f1d35-6728-45d5-a3a8-0d1f5797f0c2', N'View employee bank details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'c8ef072c-6f7c-4bb7-8c66-0d64f0c838b5', N'Mark damaged assest', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a280c7f1-0584-4db8-abc8-0d9f1cafdc3b', N'Work items having others dependency', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'dbe32fd3-e64e-46ce-a87c-0f06ed2995e6', N'Employee spent time', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'ee635c28-0fc2-420a-8c23-0f44db2f5b4c', N'Manage payment method', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'5db10b91-afd5-41e3-aec5-fefd40613d78', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'f12c7ecf-418b-4978-a113-131c5a8938e7', N'Add or update employee skills', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'e81e64e5-4438-4df4-aae0-146dca7d6703', N'Manage identification type', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'8564de2d-598a-4dae-93a7-22b146af8fc7', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5d7d8b8f-640e-4cb7-bafc-16f3b2157bd3', N'Ability to chat', NULL, N'2d6aae92-06e4-487a-939e-b5d66d682fe0', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7bb99906-39c1-4015-84b5-17011ce1925d', N'Employee work allocation', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'1e02c356-57e3-4c30-85f6-6dc50a873b17', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'67b892c5-ea3b-4a7a-96d8-172e167717ab', N'View employee language details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'ae2eb7e5-8e9d-4032-a1f6-1743a91fd810', N'Manage branch', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'eb729085-0411-4298-9fa5-5318b0225b22', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'22deba23-471f-4f96-b458-1a53a540ac99', N'Add or update food item', NULL, N'93ff3297-9fa5-48e3-adf3-4954a8c51720', 1, N'5608103b-b7f4-4621-85cd-dcbc8e693b9b', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd84d5f4f-39db-4cbe-af74-1f40179b00c4', N'Add or update asset', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'e1ef26e2-bd55-49c9-bea3-209972ed4f14', N'Manage date format', NULL, N'632c2c2e-3527-45b1-9de8-6043a12f3942', 1, N'f87b675f-4584-4779-a7e2-d6f99183cb3f', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'2313706d-52a9-4e22-acef-226ec64fbdaa', N'View employment contract details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'2c22916f-b80b-4c51-9534-23f698de120b', N'Approve or reject leave', NULL, N'f80dd978-f979-4990-b084-59c48e272a2e', 1, N'1EC88BED-7062-4C8B-A638-D49EE842054D', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'c0667777-ca0e-4b12-9f42-242dd20fda45', N'Spent time details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'108cf941-2cd4-45d9-9fc3-ede94def73ce', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'15a34738-c863-40cf-a67a-24a2c2b6b176', N'Manage bug priority', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'a8eb5ee4-6a58-4471-b1a5-b49476b59142', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B13B316D-3725-41D2-9CFE-E556C97BA29D', N'Manage integrations', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'a8eb5ee4-6a58-4471-b1a5-b49476b59142', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'78c66541-ea81-4054-b289-2584c191e50c', N'View employee work experience details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'e10ddae0-39e4-4010-9981-269fea0991d5', N'Enable notifications', NULL, N'373da4e5-faa3-4656-8800-057e15eaafb1', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9ee8fef9-e6df-4a42-abe6-27b8f1416a15', N'Manage country', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'8684df02-da84-4852-9710-062b90ca67fe', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'c692c6ce-e6ac-4090-b41b-295066edd3cc', N'Credit amount', NULL, N'93ff3297-9fa5-48e3-adf3-4954a8c51720', 1, N'5608103b-b7f4-4621-85cd-dcbc8e693b9b', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8a67d6d6-48af-4720-9c6b-296208dc93de', N'All goals', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'85e02f29-e3e5-4428-9e77-2a42b190cdda', N'Process dashboard', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6272fa8f-5e85-4a66-87f5-2a5c33729e0a', N'Manage time sheet management', NULL, NULL, 1, N'98679521-f7ed-404e-9192-2088cddddc01', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'721aee4b-bb75-4db0-b351-2ba2b5505229', N'Access testrepo', NULL, N'90db7546-442f-49ee-ba98-3d8a78383c6c', 1, NULL, CAST(N'2019-05-25T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'14e13b03-7429-44b6-9c23-2e5e81ff60cc', N'Every day target status', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'1e02c356-57e3-4c30-85f6-6dc50a873b17', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'e6f4c002-ab0d-435c-a044-2f9527155f50', N'Archive project', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'b2117c2a-99a0-4676-bdfe-31b0dabecfb7', N'Apply leave', NULL, N'f80dd978-f979-4990-b084-59c48e272a2e', 1, N'7e174395-8f84-4930-8394-2cecd6ae7cee', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'871c9f44-8d4f-4b8c-8b0b-353ddd87edc2', N'Manage permission reason', NULL, N'6272fa8f-5e85-4a66-87f5-2a5c33729e0a', 1, N'22ef53e5-44be-434f-9800-91c57ac8e5a5', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8dd962b3-b283-4827-bb0a-37b60c24cecf', N'Recently purchased assets', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0ad0284c-da57-4bdc-a7e0-38dc65688b5c', N'Manage paygrade', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'bd7e3ccf-59ab-4ca2-bd8b-7a2347eca698', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'212d77e7-3e63-4d44-9747-391523ee722f', N'View roles', NULL, N'a3b4484c-4f5a-4aa5-8d98-5c8696d6a09f', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3680a22e-fbe2-4372-8be5-3bd283a8eece', N'Archive submitted status report', NULL, N'465e3538-c86a-42af-b865-0586f1816029', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4258ddde-da15-48e1-97be-3c72ecae70b2', N'View employee credits', NULL, N'93ff3297-9fa5-48e3-adf3-4954a8c51720', 1, N'5608103b-b7f4-4621-85cd-dcbc8e693b9b', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'90db7546-442f-49ee-ba98-3d8a78383c6c', N'Testrepo Management', NULL, NULL, 1, NULL, CAST(N'2019-05-25T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7172c444-bc93-444d-a0b4-3e81a34e4da7', N'View employee report to details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'2d18db5b-c8c8-47e7-b4a2-4291f4c65f36', N'Late employee', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9affad6c-00de-483f-a5f2-442e68ada2cc', N'View employee membership details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'b289aac5-5e1b-4e6d-8aa1-443259b4e7f0', N'Recently assigned assets', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3e8484ea-92c6-44e0-afc0-4464eb709046', N'Employees current working or backlog work items', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'455a85c4-bd8d-4425-b978-44d17778520d', N'View status reports', NULL, N'465e3538-c86a-42af-b865-0586f1816029', 1, N'C6BDF208-A173-4895-8CFF-B3C28ADA28CB', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd94cd095-9cc6-4eeb-8f4f-45c70fc91b0a', N'Manage button type', NULL, N'6272fa8f-5e85-4a66-87f5-2a5c33729e0a', 1, N'f50bbd69-e04e-4aed-89c2-2b5015b4d87e', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'92ad11c0-c155-471e-b7e9-461eccdb5dd4', N'View room temperature', NULL, N'b126c444-24d6-4bf1-a91c-dbbc314c3872', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9c6ee407-2de4-4398-8cda-463724d2c376', N'Update food order', NULL, N'57b2b1c6-d2a9-424e-a131-ae9e48ec6d33', 1, N'9094c735-76ab-49dd-bc7e-57a3fb137a7c', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'fa6ee079-e906-4749-b6f7-47230d7cb3ef', N'Manage currency', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'bdd334bb-0a19-441f-af87-2b79b8b97cc6', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        --Leaves management
        ,(N'b59bd701-8ec3-465e-9208-4888da83dd61', N'Manage leaves management', NULL, NULL, 1, N'f2e58549-8f82-4d0d-b48f-0938a2781140', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0bf8995a-4f92-476d-93c7-5759a5538fd4', N'Manage leave status', NULL, N'b59bd701-8ec3-465e-9208-4888da83dd61', 1, N'578aa947-e43c-43f7-adda-c1ffa510f1d6', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0414396d-e747-4367-b043-7a383f441b56', N'Manage leave session', NULL, N'b59bd701-8ec3-465e-9208-4888da83dd61', 1, N'e7cda6b2-2776-4edc-8db4-c3de0696567f', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'e3a243db-9e1a-4d74-8cae-f22b47696679', N'Manage holiday', NULL, N'D02A0437-2541-4134-83C0-E4B68127D830', 1, N'7bea3da7-bf80-4bb0-93eb-f0748fb402a7', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        ,(N'FADCC22E-EDE2-4EB0-B929-9B14630D31A0', N'Leave type configuration', NULL, N'f80dd978-f979-4990-b084-59c48e272a2e', 1, N'16b0fd89-4a84-4077-b8d5-089ae6eb9114', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9794D340-655A-4422-B826-2CF9C0F478E3', N'Add or Edit Leave Type', NULL, N'b59bd701-8ec3-465e-9208-4888da83dd61', 1, N'16b0fd89-4a84-4077-b8d5-089ae6eb9114', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F7EFF14E-2FE7-4FD6-AA79-7ED7D87495A0', N'Manage restriction type', NULL, N'b59bd701-8ec3-465e-9208-4888da83dd61', 1, N'E5060FD0-41F0-4F19-AB3D-404C09D2042B', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'C559FB2B-5659-4200-825C-7F95CE70C685', N'Manage leave formula', NULL, N'b59bd701-8ec3-465e-9208-4888da83dd61', 1, N'253609AB-DBED-4954-9892-BBCBDEC032C7', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'31CC4268-9C82-4CEB-912B-B00D6D5CE89A', N'View company wide leaves', NULL, N'f80dd978-f979-4990-b084-59c48e272a2e', 1, N'01F1A280-56D3-4464-B7C8-5FE6A0A9B1FE', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'CAE857EC-31A9-474C-9BBF-ABCB4E8670DA', N'Apply leave on behalf of others', NULL, N'f80dd978-f979-4990-b084-59c48e272a2e', 1, N'7e174395-8f84-4930-8394-2cecd6ae7cee', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        ,(N'391c62fc-92f4-4587-af59-48e92bec68cc', N'Add or update channel', NULL, N'2d6aae92-06e4-487a-939e-b5d66d682fe0', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'137fa14c-e705-499e-acdf-4926eecf74ee', N'View forms', NULL, N'438c6f61-ca8a-4ae9-8d29-ddf92f30ff01', 1, N'6D984760-7DC2-4929-ABB0-F1EEED4B7B60', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'93ff3297-9fa5-48e3-adf3-4954a8c51720', N'Canteen management', NULL, NULL, 1, N'5608103b-b7f4-4621-85cd-dcbc8e693b9b', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4c3792a3-6c4d-4af4-a6bc-4a87d6a066ec', N'Manage process dashboard status', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'099f2029-eacb-428d-b5c6-77a6a5e8a7f6', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'31773c75-d2da-4f39-9202-4b0280814756', N'Projects actively running goals', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'53ef12a9-3722-4cd6-83b3-4bd3d5eeb486', N'Add or update employee immigration', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'11d37b68-7ea8-4ba8-9e46-4f979fa20821', N'Recently damaged assets ', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a87250cb-0da7-410c-89a5-511f322292fb', N'Manage designation', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'd92f1ddd-cbd4-4364-9d3a-b7fe685a4438', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'16881033-B027-4477-BE6B-D0CB0DBD3D21', N'Manage time zone', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'0BA971CA-5202-4426-8660-3CFE3C7EAD44', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'69360404-1a1d-48c7-bac0-515274f101ab', N'Asset history', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'94c74250-5d25-4973-909e-51c280ad09c6', N'Project management', NULL, NULL, 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        -- ,(N'51ff182e-45c9-43bb-a813-53b92dc21e46', N'Manage work item sub type', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'28e8026d-7962-4d1d-9db3-11d0fc7a5c65', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'bbef84fb-e684-4903-baeb-541a8d8efbff', N'Add or update employee bank details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'30307BAB-E865-496D-BD38-172732465610', N'View employee shift details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'85603293-1e1d-40bb-a6e7-54db88340d0f', N'Workflow management', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'cf6ec321-aa8f-49da-b71f-49056b12d70f', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'c3dbc2ea-06a9-41f9-97da-55893b767a34', N'Archive form', NULL, N'438c6f61-ca8a-4ae9-8d29-ddf92f30ff01', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'bfbed52e-d5d3-4d4d-b658-56126de36550', N'Manage System Apps', NULL, N'dabae0ce-06c1-49bc-a409-a5390cb3b700', 1, N'469F786A-BC3D-4D21-8CA6-2E228A6A68F0', CAST(N'2019-05-22T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'A52A9252-52FF-4795-9627-F910450C48EB', N'Manage dashboards', NULL, N'dabae0ce-06c1-49bc-a409-a5390cb3b700', 1, N'E1FBFCF0-B3F7-432B-A439-472A29E57C06', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'bccd1084-e715-499f-9d5d-572f062155ff', N'View employee education details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'bc75fdf3-7e5e-4fa2-b210-5852c41dd0c4', N'Manage work item replan type', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'50c82790-e879-41e8-99b6-3cb6b16e16f3', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'b2d12af0-193f-4133-a6db-587d1c3bb293', N'Archive user', NULL, N'528f8181-5941-4098-aecc-6c43153f7dfe', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a07c27b5-1c6c-4cf9-9dfd-58aebc149192', N'Add user', NULL, N'528f8181-5941-4098-aecc-6c43153f7dfe', 1, N'3fa32fa4-c63e-4565-aec1-a0ffbd6ef317', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'f80dd978-f979-4990-b084-59c48e272a2e', N'Leave management', NULL, NULL, 1, N'1C39BF90-28EA-4AB5-A8F6-FF6188D46790', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'f3aedc05-a81c-4f8f-b7f7-5b07c128ce12', N'View projects', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'B30DC3F6-1411-4A09-88F1-13FEFE3B1275', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'e92554b4-1583-4240-84de-145619b020ad', N'Can schedule userstory', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a3b4484c-4f5a-4aa5-8d98-5c8696d6a09f', N'Role management', NULL, NULL, 1, N'd27596ad-d704-4317-870a-8dbcd374fb93', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'619d02ee-49e0-4afd-8639-5cd82effc5d3', N'Manage state', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'6f386f41-a4da-43c0-9d17-e92ef32f452d', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'bb2292a7-7bb6-4606-9d92-5d54fe0693e8', N'View locations', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'37e0c505-fa24-426b-8da6-5fd17fc5bea2', N'Manage testrepo management', NULL, NULL, 1, N'414183ce-67f3-4769-b464-7edbf2e3b9a1', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'632c2c2e-3527-45b1-9de8-6043a12f3942', N'Manage company structure', NULL, NULL, 1, N'9fd1a218-04d9-4862-9aab-ecb367a7868c', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a6adc4b4-11e5-440b-b472-62624eaf8f79', N'Add or update product', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4a2e2eac-1234-4a8f-8ebd-63c68264dfb4', N'Assets allocated to me', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'30139536-4a53-4ed8-8645-646da6e8c3e3', N'View employee skill details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --  ,(N'7056a1d4-d08a-4bb5-8c4e-650ccc7f670a', N'Work allocation', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'bc3f0ad1-d9c5-400a-ba4d-65f57a35c45b', N'Add permission', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'93C062DB-4B83-4477-9B44-2197ECFAA070', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'c4269551-fc5d-4850-ba65-66b91d390833', N'View todays timesheet', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'93c062db-4b83-4477-9b44-2197ecfaa070', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'cd677a9d-5d4d-4640-8134-66d9f27992c5', N'Manage crud operation', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'4d6e8ecf-96ca-4964-825b-78beeab44f5c', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'219ddacb-a233-4a59-bde8-68b6543bfc02', N'Manage reporting methods', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'33f2b918-0433-4908-8ae0-1235b9f45e51', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'b38b3588-bd01-4bcf-bdf0-6937d4189037', N'Manage feed back type', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'604df0df-a1db-4bc2-b35b-67a8e2a39414', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0a345822-1bf4-45fd-9021-69a09258d126', N'View employee job details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'ac2f36c6-6b03-4ce5-9e23-6a4691afee75', N'Add or update employee work experience details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3b7cae23-30a6-4bb6-80d4-6ba115607eeb', N'Update permission', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'9c40e52d-42e3-4868-ad98-37ecaa466459', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'528f8181-5941-4098-aecc-6c43153f7dfe', N'Security', NULL, NULL, 1, N'3fa32fa4-c63e-4565-aec1-a0ffbd6ef317', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9227d745-cd7f-41ed-90ac-6d2430341185', N'Submit status report', NULL, N'465e3538-c86a-42af-b865-0586f1816029', 1, 'C6BDF208-A173-4895-8CFF-B3C28ADA28CB', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'99646779-a28c-4615-9aca-6f2495adf07a', N'Add or update employee emergency contact details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0f264fa6-38e1-483a-a3dc-116f78aa978f', N'Add or update employee dependent contact details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-08-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'ea9785b3-8ad8-416c-8194-6f9a3cb9cd05', N'Bug report', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'1e02c356-57e3-4c30-85f6-6dc50a873b17', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'e1ca9eb5-e315-4783-8cf5-703516063e54', N'Asset comment', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'65013efd-16c8-4e7f-9a26-71401ea74b45', N'Purchase food item', NULL, N'93ff3297-9fa5-48e3-adf3-4954a8c51720', 1, N'5608103b-b7f4-4621-85cd-dcbc8e693b9b', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7774a180-fb01-4996-9ef3-7186b2f47556', N'View timesheet feed', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F633A5A4-C36B-4947-AD31-BB4A4BA46F93', N'Submit Timesheet', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3845D5C9-E786-49E2-8262-5C2E251257EF', N'Approve or reject Timesheet', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'568f51e0-bda3-47c2-9c3e-71ee6d717565', N'Add or update employee reporting to details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6c8108c8-6d9b-439c-acee-7358037f1c20', N'Dashboard management', NULL, NULL, 1, NULL, CAST(N'2019-05-22T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'cefaa542-8c5f-494c-af67-73c8df15f82a', N'Manage company location', NULL, N'632c2c2e-3527-45b1-9de8-6043a12f3942', 1, N'ffb57af0-97d2-4555-8dce-a2185bc9da73', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'56d7d787-2a41-4c43-95a9-73ee1d6090b9', N'Manage number format', NULL, N'632c2c2e-3527-45b1-9de8-6043a12f3942', 1, N'06eb3937-1c7e-48b5-b767-cf63e2e518f3', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'33f49110-324c-441a-a16c-741dd89da5a2', N'Work items having dependency on me', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'439defcd-5c44-4009-b63a-743b2379a9b8', N'Add or update employee education details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd73ea2aa-b26f-4a83-a089-7488ca345167', N'Archive role', NULL, N'a3b4484c-4f5a-4aa5-8d98-5c8696d6a09f', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', N'Time sheet management', NULL, NULL, 1, N'5fe009b5-83d1-40a6-8b29-7ac939087916', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --  ,(N'96466483-d687-4c74-bbdf-787a274ba7e2', N'Manage authorization', NULL, NULL, 1, N'3eac66b8-5377-42c0-aa3c-0a4e88f82b6e', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a366c067-9182-418f-a853-79130167001a', N'Manage memberships', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'e6726ecd-accd-484b-a7d2-b9b4ca3f6373', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'aa593aba-a5a5-4207-bf67-79a487bd441e', N'Food items list', NULL, N'93ff3297-9fa5-48e3-adf3-4954a8c51720', 1, N'5608103b-b7f4-4621-85cd-dcbc8e693b9b', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7ed5eac4-0065-42ec-9999-79c858198845', N'Add or update form', NULL, N'438c6f61-ca8a-4ae9-8d29-ddf92f30ff01', 1, N'84EA97BC-887B-4E06-8318-24D03830D8DE', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4da88661-17d9-430f-b4d9-7b91ed93562a', N'Manage accessible ip adresses ', NULL, N'6272fa8f-5e85-4a66-87f5-2a5c33729e0a', 1, N'40bc40ee-376c-4cbb-a93b-129874766ee4', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'ace153d5-0c46-4aa1-b93d-7e89b01dad07', N'Add or update location', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'e0fd7b15-c67a-447d-ad26-81232fa7424e', N'Employee work items', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'1e02c356-57e3-4c30-85f6-6dc50a873b17', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9A3EC77C-4F4A-467A-995E-82B46C746A61', N'Manage leave type', NULL, N'B59BD701-8EC3-465E-9208-4888DA83DD61', 1, N'16B0FD89-4A84-4077-B8D5-089AE6EB9114', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'22117779-4744-4b8a-a21e-836699ca7951', N'Archive status report configuration', NULL, N'465e3538-c86a-42af-b865-0586f1816029', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8c947af0-c7cd-4f5c-b755-8396918b11df', N'Reset password', NULL, N'528f8181-5941-4098-aecc-6c43153f7dfe', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4a987fa8-231d-49be-ad46-84482a32bda4', N'View project activity', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'1d1eaea4-200a-497e-beac-86f15103fedb', N'Manage rate type', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'09c7663d-4695-4a4f-8626-62d91fb4e79f', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'1ea77455-1eca-4d7d-a75b-86ff45b3555e', N'Add project', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'90157706-eee6-47c2-90d7-87d180575c49', N'Add or update employee job details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'34722f45-6282-4f36-89ce-8976a344ae05', N'Manage employment type', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'91d6d36e-2123-4f7d-9d7e-922784abf82e', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'f45cf108-9817-4071-8220-898cf40099f8', N'Forgot password', NULL, N'528f8181-5941-4098-aecc-6c43153f7dfe', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd1865698-9c7e-4d5d-b076-89ce8bf99e43', N'Log time report', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'bc4d77d4-0c34-42b1-a8f6-8a7008cd6111', N'Delete Dashboard', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL , CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9E47F20C-73BF-43DE-B044-B8FB48CF3B33', N'Hide Dashboard', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL , CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'AD35BA30-115D-426B-A37B-8243759ED747', N'Edit Dashboard', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL , CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'FD20B706-42B1-432D-AEEF-92C28AC7EF10', N'Dashboard menu item', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL , CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'1557DCD6-B1DE-44DB-8E4B-3BA4D2994383', N'Drag Apps', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL , CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'997B1D56-8559-41EF-A7C9-C50ACB123697', N'Add Dashboard', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL , CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'105b8e1c-d81b-478f-95a0-8c88d2d80be9', N'View historical timesheet', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'7e174395-8f84-4930-8394-2cecd6ae7cee', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'78d5f664-aa1f-4350-8496-8de690af0ec8', N'Work items waiting for qa approval', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'1e02c356-57e3-4c30-85f6-6dc50a873b17', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'fe80145a-d9ac-444c-ab67-8e7b2b41a2ce', N'Manage reference type', NULL, N'90db7546-442f-49ee-ba98-3d8a78383c6c', 1, N'e79ccaaa-4fd8-4e08-8b25-2219a68991b3', CAST(N'2019-05-25T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'fa1ed611-c599-4c74-83bc-90caa3ee73ae', N'Add or update role', NULL, N'a3b4484c-4f5a-4aa5-8d98-5c8696d6a09f', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'f369ff94-f64c-4028-94e5-91d6cff2c74a', N'Punch card', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'e37b1251-07e8-4c9e-98a8-929731dfd938', N'Organization chart', NULL, NULL, 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'88e15818-cf58-4ada-a5c5-9391aeddfc18', N'Feature usage report', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'776a34c2-4548-4aa2-8042-96966e2f2c1d', N'Employee presence', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd4f3dd2b-b33a-46d5-8e81-96c2de17d996', N'Manage pay frequency', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'e5e7f454-31e4-4142-9f8a-f190fc4b6364', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'1349a291-4e98-4918-b923-96fb0bbbfd06', N'Manage project management', NULL, NULL, 1, N'8e71ac50-5ece-4daf-8ea9-f8c05524155b', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'b208c678-b63a-42e5-882b-976cd91592c6', N'Manage field', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'8e71ac50-5ece-4daf-8ea9-f8c05524155b', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'ab1218db-d348-45db-bf5a-9808dc00651e', N'Add or update timesheet entry', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'93C062DB-4B83-4477-9B44-2197ECFAA070', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'05209b4c-7ce9-4e00-9be3-989798603b01', N'Add or update employee personal details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'E202F210-5592-4881-9534-9B90D9582058', N'Manage work item type', NULL, N'1349A291-4E98-4918-B923-96FB0BBBFD06', 1, N'2101CE07-8A97-4F31-BE6D-8B1866D70DD4', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a701fb6f-f1e3-42b0-9b4d-9b9f7c248f1e', N'Can edit other employee details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a5609408-2e26-4d9f-bcf4-a17d6cc7ff6b', N'View employee salary details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'cfa1fee1-8aec-4f59-bc54-a2b729383e85', N'Manage department', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'd1549921-c8c5-4060-ba74-5dda709c2140', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'bc7411c4-f26c-4b60-9264-a2e1e969b538', N'Manage contract type', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'44fcd975-3a72-49b9-b5c5-ee9e1e31c33d', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'dabae0ce-06c1-49bc-a409-a5390cb3b700', N'App management', NULL, NULL, 1, N'AD9E065E-42B4-4599-8FD5-EFED7B25DEF3', CAST(N'2019-05-22T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8E0FE086-DCBA-49ED-8D04-792040852FC2', N'Manage Custom Apps', NULL, N'dabae0ce-06c1-49bc-a409-a5390cb3b700', 1, N'0CC26498-39AB-4171-9081-CBA41FD3C26B', CAST(N'2019-05-22T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8d4f4dd9-5911-4ba9-9a9d-a57b8e27f4e7', N'All food orders', NULL, N'57b2b1c6-d2a9-424e-a131-ae9e48ec6d33', 1, N'c5d5412e-d175-492a-8d78-e0c766a39afd', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7f9a4596-1826-4387-a347-a58df0734376', N'Add or update employee identification details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'c7d3b037-0015-4919-8e26-ab6113e55932', N'My adhoc work', NULL, N'95fb2411-51c5-46c7-b712-05612528e302', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'aa7c7dfb-efa4-483e-8478-ab7db2ad7e4d', N'View employee personal details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8b28cda0-0f05-4999-850e-acbc3856f39d', N'Add or update vendor', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd0078582-63ec-4d11-b765-ace25477ee7d', N'Employee working days', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'53a073fe-3781-451c-bf0c-adb4eac85d10', N'Bill amount on daily basis', NULL, N'57b2b1c6-d2a9-424e-a131-ae9e48ec6d33', 1, N'c5d5412e-d175-492a-8d78-e0c766a39afd', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'57b2b1c6-d2a9-424e-a131-ae9e48ec6d33', N'Food orders management', NULL, NULL, 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'cb1bbdb1-6e69-4913-9329-b08cf4aa407e', N'Unarchive project', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'892e870a-a4b7-4a63-8119-b10eaa88a871', N'View employee immigration details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'81425352-61da-47bd-98e6-b133ebe20da6', N'Update user', NULL, N'528f8181-5941-4098-aecc-6c43153f7dfe', 1, N'3fa32fa4-c63e-4565-aec1-a0ffbd6ef317', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'f39d781c-c236-4a14-8b6b-b1bf3520cf9c', N'View employee identification details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3d2c8442-f298-4169-ba46-b319b6bc929c', N'Delete leave', NULL, N'f80dd978-f979-4990-b084-59c48e272a2e', 1, N'01F1A280-56D3-4464-B7C8-5FE6A0A9B1FE', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'e3e572ef-f2fd-4643-9982-b4a7abbc8422', N'Employee index', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'1e02c356-57e3-4c30-85f6-6dc50a873b17', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3cc69bc9-b410-459e-bf0e-b5172a522ff6', N'Recent individual food orders', NULL, N'57b2b1c6-d2a9-424e-a131-ae9e48ec6d33', 1, N'c5d5412e-d175-492a-8d78-e0c766a39afd', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', N'Asset management', NULL, NULL, 1, N'96b0caca-8cb1-4717-a15a-688fd3c6148a', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'2d6aae92-06e4-487a-939e-b5d66d682fe0', N'Chat', NULL, NULL, 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5f2e2bdc-7943-4217-90c8-b8886b24d9aa', N'Goals to archive', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8804fdea-94da-4444-8f09-b8cfc55281e8', N'Add or update employee languages', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8ca4a51c-4921-4fa8-8b56-b8cff868563f', N'Actively running goals', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'c580af28-8780-4c4d-baf4-b8eeb7be4411', N'All goals with advanced search', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'dfd183e6-8040-420e-8c26-bcf5b7df7799', N'Manage soft label', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'46206820-706e-4507-b5a5-b136a05641e0', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7e51ec66-fde3-4beb-b7c6-bd3ae84f3ab3', N'Canteen purchases summary', NULL, N'93ff3297-9fa5-48e3-adf3-4954a8c51720', 1, N'5608103b-b7f4-4621-85cd-dcbc8e693b9b', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'de865dbd-b6d6-43ad-a560-bd71f9da4266', N'View vendors', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		
	    ,(N'1D1FF3E5-D8F4-4C19-BD66-827D11901DC8', N'Archive vendor', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
	    ,(N'3722a977-2578-43c3-bba6-bdf79b741e10', N'View users', NULL, N'528f8181-5941-4098-aecc-6c43153f7dfe', 1, N'3fa32fa4-c63e-4565-aec1-a0ffbd6ef317', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'17586dd4-752e-4451-bd0e-be98c8e22276', N'Manage board type workflow', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'09cef79e-95b7-4da3-a9e6-28444da341c1', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'f0310f7f-2194-4e3b-9c80-bf2851340803', N'Leaves report', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7deed649-510a-436d-8ba4-c03aaad18ec4', N'Add or update employee salary details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'bd151ba2-9eff-4fdb-9b1a-c2067f61fe65', N'View organization chart', NULL, N'e37b1251-07e8-4c9e-98a8-929731dfd938', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4feff215-0fdc-4592-a942-c36ae2b94c9e', N'Offers credited to users summary', NULL, N'93ff3297-9fa5-48e3-adf3-4954a8c51720', 1, N'5608103b-b7f4-4621-85cd-dcbc8e693b9b', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'68a49f78-4db9-4f7d-b302-c3ed039f5b4c', N'QA performance', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'1e02c356-57e3-4c30-85f6-6dc50a873b17', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'cdb3341d-78a1-43f5-989b-c4c7df8133ca', N'Manage project role permissions', NULL, N'94C74250-5D25-4973-909E-51C280AD09C6', 1, N'76415f91-34c8-42c9-abcd-fe0b275c6759', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4b3ae462-92e1-4c49-88b9-c7067f93ac9b', N'Reset others password', NULL, N'528f8181-5941-4098-aecc-6c43153f7dfe', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'1edd2dbb-a375-4b04-8358-c88db76a4841', N'Transition deadline', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'0614b0ee-79d3-412d-9c7a-4e8b94b8f661', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'368b22ee-2089-4ab6-a400-c8abdd34d886', N'Add or update employee contact details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6370060e-fb2d-426b-b057-c8f246df9cbb', N'view all employees', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'1EC88BED-7062-4C8B-A638-D49EE842054D', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F34F02D8-BA29-48E3-B1A0-AB85ECF4EC94', N'View reporting employees', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'1EC88BED-7062-4C8B-A638-D49EE842054D', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    --,(N'cdfeeab0-9924-41a5-8dad-caf8520bbb6c', N'Assets activity', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'61007e4c-7b0f-48a0-a726-cc485b6cb2a1', N'Manage goal replan type', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'b51a8508-4335-4980-8420-366e821a478f', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'36414f52-41ba-4640-b59f-cc71241dbc2d', N'Manage testcase type', NULL, N'37e0c505-fa24-426b-8da6-5fd17fc5bea2', 1, N'c0e85ecf-becc-4d51-bd9e-1f2b2f45aeaf', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7e00ac86-7c91-4794-a268-cd7547ce8f33', N'Manage company introduced by option', NULL, N'632c2c2e-3527-45b1-9de8-6043a12f3942', 1, N'2749d0d6-3eeb-486b-8fa7-31c5fc3fca6e', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'11af3467-bec6-45a6-9f73-cdb4f929c346', N'View employee emergency contact details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'ef993fe2-e6e2-4222-b7ac-cdde6078bdf0', N'Manage nationalities', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'9d8a7f8c-8bc4-4073-9e06-fb5a471acf9b', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a08125f4-0fa4-400f-9b35-cf7e2595fa2e', N'Manage main use case', NULL, N'632c2c2e-3527-45b1-9de8-6043a12f3942', 1, N'014f5ef7-2857-483c-a923-f51674d2f361', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0a72c152-55d5-4e4a-927d-d1a292914074', N'Manage languages', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'1c4655b2-6e8f-4c74-b481-20475f1c62c2', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'09e6746a-c4a4-46c9-b3fb-d2672c9607c2', N'Manage subscription paid by', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8eba255a-7973-43d9-be0f-d2abdfc281a7', N'Conduct form', NULL, N'438c6f61-ca8a-4ae9-8d29-ddf92f30ff01', 1, N'AAB76E39-2D73-4E95-A8B6-A887EEDF3799', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'f16639b3-d220-4794-8b94-d4a6fc227316', N'Late employees count vs date', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'f299291f-e1e3-4cc3-bdf1-d4ada32e9a89', N'Add or update status report', NULL, N'465e3538-c86a-42af-b865-0586f1816029', 1, N'7e174395-8f84-4930-8394-2cecd6ae7cee', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'fb695abc-cb26-4e36-ad0e-d4e0f40f7354', N'Assign assets to employee', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'015319b6-d705-4676-b3a6-d637a7081761', N'Employee attendence', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'82cc4ed8-919e-42ce-8fa4-d66a322f063c', N'Activity report', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'da71cb6d-2758-4528-bbff-d6f31ebb80b1', N'Dev quality', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'1e02c356-57e3-4c30-85f6-6dc50a873b17', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'eca49f6e-a93e-472b-a792-da759ced660e', N'Imminent deadlines', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'b126c444-24d6-4bf1-a91c-dbbc314c3872', N'Room temperature', NULL, NULL, 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'21b790a1-6abe-44a2-93ea-dbd38ed7a5a3', N'Manage ShiftTiming', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'a2805944-7543-4af3-a111-5bb99814d1a6', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd40387da-c5bc-4512-93c5-dd0d2bdd83c9', N'View assets with advanced search', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'177d8cd2-ae16-4289-8453-dd4431fd20be', N'View permissions', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, N'9c40e52d-42e3-4868-ad98-37ecaa466459', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'438c6f61-ca8a-4ae9-8d29-ddf92f30ff01', N'Applications', NULL, NULL, 1, N'AAB76E39-2D73-4E95-A8B6-A887EEDF3799', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'356ca902-c88a-41b2-a976-e08289af01e3', N'Manage skills', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'997aa425-e2f3-4bcd-8c67-a3822115fe59', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8B8716C2-5278-4E82-83E9-75967FAC8FC5', N'Add or update applications', NULL, N'438c6f61-ca8a-4ae9-8d29-ddf92f30ff01', 1,  N'C295D278-82E4-4810-BF2C-3CD77DF3A99B', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B6A89133-F7EA-4846-A9B9-CF0B07C8751C', N'View applications', NULL, N'438c6f61-ca8a-4ae9-8d29-ddf92f30ff01', 1,  N'38F0CA53-BC90-43FE-B41B-40A5792321DF', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        --app settings
        ,(N'E5E99C6D-04F2-4940-921E-0648213D7ADF', N'Manage Master settings', NULL, NULL, 1, N'84A9CE6B-077B-48CD-9C98-681759FEDDFE', CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B7FEBDFD-C2FD-41C6-A795-7DBF32054A41', N'Manage app settings', NULL, N'E5E99C6D-04F2-4940-921E-0648213D7ADF', 1, N'F8B42F51-1459-4976-B367-4186D6CE1BC8', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'E5A39D73-6EF6-4C40-8B39-2AD14F78FF7C', N'Manage company settings', NULL, N'E5E99C6D-04F2-4940-921E-0648213D7ADF', 1, N'ADDEB342-4D6C-4CE7-82E7-0707486B18B2', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'027A6BA8-D6E8-493B-995E-A16376101C20', N'Manage time configuration settings', NULL, N'90DB7546-442F-49EE-BA98-3D8A78383C6C', 1, N'FD96EBFC-46A9-4B90-B25D-84F22A7C9DEF', CAST(N'2019-10-12T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --Expense Management
	    ,(N'2CDAADB0-F0CB-4513-B547-13A8652143B3', N'Manage expense management', NULL, NULL, 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'CCA06C43-92A4-4D45-AE25-FFBD4450FD6C', N'Manage expense category', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'D54EF735-0454-426A-AC2B-C5022EC3832F', N'Manage merchant', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2019-10-12T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        ,(N'60f55765-521b-42f7-a6e0-e0b16538aec3', N'View live dashboard', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'974f7bce-c3b0-45d3-ab65-b0b6c4cd7fa1', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'14de641a-b105-4fa6-a655-e16b265a2bea', N'Add food order', NULL, N'57b2b1c6-d2a9-424e-a131-ae9e48ec6d33', 1, N'9094c735-76ab-49dd-bc7e-57a3fb137a7c', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'32a2f1a9-b85f-4621-bf8e-e426a5534666', N'Manage payment type', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'021d3073-e3eb-4656-bc8f-b1ba2da9f431', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd02a0437-2541-4134-83c0-e4b68127d830', N'Manage hr management', NULL, NULL, 1, N'99844a61-6a16-44df-b86f-f641ec371184', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'794b029d-4835-48ce-8ad1-e4ba17c4203f', N'Asset price management', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8c91a450-4fb3-4d80-98f4-e67648e60862', N'View status reporting configuration', NULL, N'465e3538-c86a-42af-b865-0586f1816029', 1, N'C8178EBF-E229-4E99-95B2-06F6D506D24C', CAST(N'2019-05-24T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd5694b15-8c1d-4d0c-9543-e7e75e44f05d', N'View food orders', NULL, N'57b2b1c6-d2a9-424e-a131-ae9e48ec6d33', 1, N'9094c735-76ab-49dd-bc7e-57a3fb137a7c', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'a4fd2d93-caa7-44b5-806f-f45db6ae1322', N'Add or update employment contract', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7e174395-8f84-4930-8394-2cecd6ae7cee', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'5b095b31-5fc0-4b91-9c0f-f6fdf1a1cc91', N'Permissions management', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'b77ff349-875a-4401-aee9-d15189f7752b', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'af4ec845-3d4a-4010-b968-f701a878673d', N'Manage project type', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'1edd0d41-eb3e-4373-8b86-eab2e477b8c9', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd3ace3d7-9dc8-4672-9ddd-fb18cdc88e68', N'Work allocation summary', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'68164900-1943-4cec-8a6d-dc0de194c5d6', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'f38b833b-d383-48d5-a0f0-fbb399f61c47', N'Add or update employee memberships', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'26A3ADE1-2F97-4FC1-874C-E6C063B5762D', N'Add or update employee shifts', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --,(N'ae9230c0-b997-4804-a639-ff0968afbfba', N'Manage status reporting', NULL, NULL, 1, N'aab76e39-2d73-4e95-a8b6-a887eedf3799', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd4220276-c1c7-4b45-ab38-ff326bb37908', N'My project work', NULL, N'95fb2411-51c5-46c7-b712-05612528e302', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'371fe420-4525-4d53-b977-ff5b6a6cdd90', N'delete permissions', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'E83B3AE8-E25B-4D5A-8D1E-3A4F28B85C09', N'Manage  relation ship', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'99844a61-6a16-44df-b86f-f641ec371184', CAST(N'2019-05-25T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'CA80EDD9-0CCB-4009-820B-704B14089677', N'View employee dependent contact details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'891CC46B-CBAF-49A7-9974-A3FD6824C483', N'Manage gender', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'D5FF153B-7AB6-480A-8826-18CA2F619287', N'Manage marital statuses', NULL, N'6b49dfe1-e79c-4845-a2f3-7518d72ccfeb', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0BCB4B35-8EB5-46D2-A0CC-53D1945A87F2', N'Manage testcase status', NULL, N'37e0c505-fa24-426b-8da6-5fd17fc5bea2', 1, N'DA773AF5-5376-4BAA-8547-F806FDC110AE', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'A3726A74-D39C-4791-8057-F0C1862FA08D', N'Snap live dashboard', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'974f7bce-c3b0-45d3-ab65-b0b6c4cd7fa1', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0777C967-C399-4766-B1E6-F4C54AC0615A', N'View list of assets', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, N'96B0CACA-8CB1-4717-A15A-688FD3C6148A', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3F644A8B-6603-4BD2-B4F7-7644D3316396', N'View product details', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        --All canteen credit
        ,(N'814BCE6B-8162-425F-8222-64E802DE881E', N'Can view users canteen summary', NULL, N'93ff3297-9fa5-48e3-adf3-4954a8c51720', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'77542576-004C-4F28-83D3-B39194375246', N'Select log time report', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'06C2FB6B-8225-4B04-B700-FE50D5DD70F3', N'View my work with advanced search', NULL, '95FB2411-51C5-46C7-B712-05612528E302', 1, NULL, CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'1EBFF0E0-605F-4EDE-8725-ACEA74C55E8D', N'Manage job category', NULL, 'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'1E49A59E-CE77-4DEF-9227-BB6B6BFDB327', CAST(N'2019-07-09 18:49:31.420' AS DateTime), @DefaultUserId, NULL, NULL)
        --  ,(N'EE655B63-06B5-4525-821E-57522BF98C57', N'Board type api',NULL, N'1349A291-4E98-4918-B923-96FB0BBBFD06', 1, N'A6D1AA37-D26B-4185-AA27-B4D349666963', CAST(N'2019-06-07 16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'2BCB92A0-7244-4013-ABB1-897A39F15B30', N'Add Or Update Adhoc work', NULL, '95FB2411-51C5-46C7-B712-05612528E302', 1, NULL, CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'AF236801-408D-4B33-A350-61EE8F194F87', N'Employee Work Log Report', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'f6f891be-ef7d-4aad-b537-e080e15039df', CAST(N'2019-09-17 11:04:57.450' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'A860BC87-85B4-428E-836D-CF733C6B677D', N'User historical report', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-09-17 11:11:59.613' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F2527D3F-087A-414D-9959-572E21386AC5', N'Goal level reports', NULL, '94c74250-5d25-4973-909e-51c280ad09c6' , 1, NULL ,CAST(N'2019-09-17 11:11:59.613' AS DateTime), @DefaultUserId, NULL, NULL)
        --Document management
        ,(N'7644F6BE-48A6-490D-91B6-3DB5B8CB41A6', N'Document management', NULL, NULL, 1, N'08D880E7-138F-4093-918F-32EBC3529A26', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6C301455-7A81-40C5-916C-625D86C423CF', N'Manage Store management', NULL, N'7644F6BE-48A6-490D-91B6-3DB5B8CB41A6', 1, N'482FE404-DEBC-4691-B012-89B19A035CC4', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'52B77431-8DA0-4814-AAB6-309FE61321B8', N'View stores', NULL, N'7644F6BE-48A6-490D-91B6-3DB5B8CB41A6', 1, N'8B260C7F-A613-4DFA-A84D-1D7EC92414A7', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3A7F384D-7D9C-4C74-AB31-DCE678C9FCA7', N'Edit stores', NULL, N'7644F6BE-48A6-490D-91B6-3DB5B8CB41A6', 1, N'482FE404-DEBC-4691-B012-89B19A035CC4', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3E142FFB-CBE5-4C34-A5BE-9FD3C6D037DA', N'Review file', NULL, N'7644F6BE-48A6-490D-91B6-3DB5B8CB41A6', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B437D951-7587-4335-B03E-62C4D5600B19', N'Create folder', NULL, N'7644F6BE-48A6-490D-91B6-3DB5B8CB41A6', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'D7816276-1B93-49CC-8E51-99762414E152', N'View files', NULL, N'7644F6BE-48A6-490D-91B6-3DB5B8CB41A6', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'AB204D2C-2577-43EE-98A0-FA87A85CFE99', N'Upload files', NULL, N'7644F6BE-48A6-490D-91B6-3DB5B8CB41A6', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        ,(N'3D569305-47CE-4674-AC8D-A830B9D1FD2B', N'View testrepo reports', NULL, '90db7546-442f-49ee-ba98-3d8a78383c6c' , 1,NULL,CAST(N'2019-09-17 11:11:59.613' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'42DB79B4-37FD-46CE-A4B2-89348955DF44', N'Manage work item status', NULL, N'1349a291-4e98-4918-b923-96fb0bbbfd06', 1, N'D476B25E-9113-4F3E-8FDB-AE506A98F6AE', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6C3C7DAF-4DFE-4EC6-A37F-3EDD607B43C3', N'View Colleagues Productivity', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        
	    --Billing management
        ,(N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', N'Billing management', NULL, NULL, 1, N'0C70B2E5-D55A-4308-AAE6-3018DB70CC2E', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7670BA49-3296-4EBF-A5A6-36F46832ADC4', N'Add or Update Client', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, N'527C70B0-78A2-41CA-AFA0-6B0897E7B66B', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8C09C431-9C80-4E69-9869-B5E949BD017E', N'Manage import or export client', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, N'527C70B0-78A2-41CA-AFA0-6B0897E7B66B', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'25308DB9-8310-42C4-8995-615DFAA4C607', N'View recently active clients', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, N'527C70B0-78A2-41CA-AFA0-6B0897E7B66B', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'85A65EC4-D828-4DDE-AC62-33CDB3F01592', N'Manage invoice schedule', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'D6E8394F-38D7-4B18-8B63-283152326BF5', N'View expenses', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1 ,N'9B9CD039-5DE1-1984-D1A2-59E1C204834B', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'11EFDBAA-43AE-427C-B831-078B594BEEF1', N'Add or update expense', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'496FBF72-200F-47D3-9813-9F074F886CA4', N'Archive expense', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7F6C2F9E-C678-4544-86AF-BC32D8BB3F1B', N'Approve or reject expense', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'A4DE6A99-E3E1-4BC4-9EF4-560076FA7440', N'Share expense', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'694E21F0-BC3C-41A9-AADB-BEEA256029C6', N'View invoice', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, N'57E39DF4-417D-C89C-AF47-79C90AF8B986', CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'38234110-8A67-46CC-AB82-370A8F6F0CE6', N'Add or update invoice', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2020-03-17T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'C1DB6780-AC21-4BB4-A945-017F7DFAA904', N'Archive or unarchive invoice', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2020-03-17T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'9CE82415-885E-483B-80B8-235911073681', N'Download or share invoice', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2020-03-17T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'97478AD6-E466-4A8E-9BF5-BCEC1930AFA8', N'View estimate', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2020-03-06T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'634D217D-9A66-4107-9539-E82FEE70AF78', N'Add or update estimate', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2020-03-17T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'3470BB01-6130-4152-A9C1-47F9AB4F3B1C', N'Archive or unarchive estimate', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2020-03-17T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'1DA2769E-2A76-4A39-A1FD-DCAB9983647C', N'View or manage invoice status', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2020-03-18T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        
        --activity tracker
            --,(N'E725A1B5-5339-47FB-83F2-4E00AE5731BA', N'Manage Activity tracker', NULL, NULL, 1, N'8DECF504-6042-4436-AD9C-CB9DB90B1D9E', CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
            --,(N'F10C49F5-69DA-425B-8CDE-923FF63F28A5', N'Manage activity config', NULL, N'E725A1B5-5339-47FB-83F2-4E00AE5731BA', 1, N'00E89988-8162-4163-911F-77A19B4517CC', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        --Activity Tracker
        ,(N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D',N'Activity tracker',NULL,NULL,1,N'17C99886-A0A2-4F39-ABFD-A57623F681D7',CAST(N'2019-09-30T13:08:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5FAFD236-4EA0-4CDD-907A-29EC2D7678BE',N'View employee activity time usage',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D',1,N'CA70991C-4C10-4467-8AC0-9E640E568471',CAST(N'2019-09-30T13:08:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'70D3FBAF-8027-449B-A5F1-C226313DADBA', N'View employee web app usage',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D',1,N'9C3DB57E-97C4-4876-8AEC-4309E2E91B06',CAST(N'2019-09-30T13:08:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'9CB69D96-A99A-49C6-B158-B58535897610', N'View activity dashboard', NULL, N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, N'7506F55E-5830-4EB8-B8FF-AB76983339EA', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6648F5B5-529C-445F-BF70-97C74F101A28', N'View application usage reports', NULL , N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, '20332498-8964-4EA5-AC17-AF75D3306BEC', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5DA852AD-8375-43FE-93E3-53194F76BA7B', N'Manage apps and urls', NULL , N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, '106AED6C-54AD-4F4B-B949-DD291DB229BE', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'E3E6E572-2CDD-4077-9164-CFF274BAB507', N'View Activity screenshots',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, N'9D79A55F-0308-4695-BA2C-2411756BBB92', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
  	    ,(N'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5', N'View activity reports for all employee',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'D5C91A1A-D04B-4FF5-92F8-CF6AF30C9BEE', N'Enable employee tracking',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, '1EC88BED-7062-4C8B-A638-D49EE842054D', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'DF6FC91A-BDCE-4577-8660-58A5F21F9C70', N'View tracked information of userstory', NULL, N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', N'Can have activity tracker',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'C694C3B9-9872-4449-974F-CFC319840186', N'Can access tracker reports',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'4ACAA8AC-DE32-4D33-9F96-9DF5E1ABDEA9', N'Can view live screen',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'1E853726-8E02-43DA-A2A1-A0A4D702DFFC', N'Manage application category',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'FB013D44-4B00-4F0B-B122-02389E44AEB7', N'View activity reports',NULL,N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F10C49F5-69DA-425B-8CDE-923FF63F28A5', N'Manage activity config', NULL, N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, N'00E89988-8162-4163-911F-77A19B4517CC', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5B8E8857-9142-4277-95C8-26E4378B4D2E', N'Manage activity modes', NULL, N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, N'00E89988-8162-4163-911F-77A19B4517CC', CAST(N'2020-11-11 18:19:09.210' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'36AD0274-2E7E-406D-87D0-3514075709A7', N'Assign adhoc work to all users', NULL, '95FB2411-51C5-46C7-B712-05612528E302', 1, NULL, CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'02CCA450-E08F-4871-9DA0-E6DA4285C382', N'View all adhoc works', NULL, '95FB2411-51C5-46C7-B712-05612528E302', 1, NULL, CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3B054C8C-1647-4DE2-A0F8-79E370F668D3', N'Archive adhoc work', NULL, '95FB2411-51C5-46C7-B712-05612528E302', 1, NULL, CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'24EE1473-4632-4234-AD10-B1F358F567C4', N'Park adhoc work', NULL, '95FB2411-51C5-46C7-B712-05612528E302', 1, NULL, CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'1191C5D3-66F1-419D-9F72-9532B8B4675E', N'Delete Goal Filter', NULL, N'94C74250-5D25-4973-909E-51C280AD09C6', 1, NULL ,CAST(N'2019-09-17 11:11:59.613' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'C3952AAF-4448-4DEA-8C84-C28FCD822364', N'Manage Feedback', NULL, NULL, 1, N'AD9E065E-42B4-4599-8FD5-EFED7B25DEF3', CAST(N'2019-09-17 11:11:59.613' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'21C33A76-B4BE-48D2-8965-D84F5B94DAB8', N'View Feedback', NULL, 'C3952AAF-4448-4DEA-8C84-C28FCD822364',1,'AD9E065E-42B4-4599-8FD5-EFED7B25DEF3',CAST(N'2019-09-17 11:11:59.613' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'679C1903-999A-4CDA-8880-75E4CED26727', N'Publish as default', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B424B603-1997-4E6F-8E32-82AD90097950', N'Manage app filters', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5EEF57B0-050C-4B2D-AFBD-B70F10DEA233', N'Manage Soft label Configurations', NULL, N'1349A291-4E98-4918-B923-96FB0BBBFD06', 1, N'E509B606-1F21-406F-9BE6-6A9C98B6E567', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'47813006-C1BA-4F74-AB00-621CC82828AC', N'Configure webhooks', NULL,  N'2d6aae92-06e4-487a-939e-b5d66d682fe0', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        ,(N'7B7129F0-BFCE-4D84-AE0C-56F5EB2148C3', N'Booking management', NULL, NULL, 1, N'C6473BB4-C002-4482-A7C9-02BB38AA2BD1', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'cde6b924-bc12-4ea3-821e-455fff6d2c65', N'Venue', NULL, N'7B7129F0-BFCE-4D84-AE0C-56F5EB2148C3', 1, N'AD3EAD96-F273-4CCA-9D24-C122C84FE120', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'159E546D-CC90-4DA4-A470-362A1B2477E8', N'Can change visualisation type', NULL, N'6C8108C8-6D9B-439C-ACEE-7358037F1C20', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'367445F8-54C9-4848-A216-ABFA23B14AEA', N'Log for idle time', NULL, N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)

	    --payroll management
        ,(N'BEF56867-343C-485F-989D-9B157AAFED2F', N'Manage payroll component', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'E1FBFCF0-B3F7-432B-A439-472A29E57C06', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'40F9CFEC-717E-4091-837F-DCB1219326A1', N'Manage payroll template', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'6CC68DAB-3E6A-4F98-A4B1-72B3D72E7916', N'Payroll role configuration', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'61312A34-7556-4A1E-9FEF-DFB2B592B7FF', N'Payroll branch configuration', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'8A856A6D-F5F3-4207-9390-BBDE1E991983', N'Payroll gender configuration', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'E65F528C-2B37-4462-B393-84C597ADC571', N'Payroll marital status configuration', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'BC3EF1A5-4906-4006-B28C-09631A3411BA', N'Tax slabs', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'7E271B24-EED5-4E58-BB1D-2628C7EF61FF', N'Professional tax ranges', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'25391559-1629-4772-BB51-E94A834C1774', N'Payroll frequency', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'7121765F-5B22-4FBC-9975-E6BD1B66F21D', N'View employee bonus', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'82E88771-B74E-46C2-AFE9-CDCB10D653B0', N'Configure Employee payroll templates', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'63191182-2313-486D-BE32-4513D814F24E', N'Resignation Status', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'973B4192-D284-4EE6-AF7F-E714247A4CEC', N'Employee Resignation', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        --(N'82E88771-B74E-46C2-AFE9-CDCB10D653B0', N'Configure Employee payroll templates', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'495B187C-C8E4-4D48-83D5-209D90E2B1CC', N'Configure Payroll status', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'B2BEE500-1AA1-43C6-8C3F-637809C326EC', N'Payroll template configuration', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'D3A115A2-6E15-4CE5-8F52-6FFEE145FEA6', N'Tax allowance', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'BEE9D8FD-BC11-49ED-915F-E5F554A3C66D', N'Employee tax allowance details', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'886D492F-D091-452B-88FE-CA4B13DBFF2A', N'Leave encashment settings', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'4542DE20-63BE-4CF3-BEFB-3D040897BC24', N'Financial year configurations', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'eb729085-0411-4298-9fa5-5318b0225b22', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'BEF333FC-7839-4CF9-AACE-16597EA48E86', N'Employee account details', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'642D9BD8-610A-426E-86D2-AC66706D7B00', N'Payroll management', NULL, NULL, 1, N'3A08BF7F-FB9B-46C9-93E9-28BEE0D028E0', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'1CBAE3D3-D06C-42C7-BC67-3A7E1D6A5883', N'Payroll run', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
        (N'FBC1FD87-EBE4-4181-AF08-E2DAE768C8E9', N'Payroll run employee', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'86D8CAC3-3953-4FCB-955D-1129E9F8CF60', N'Payroll calculation configurations', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'DC499C59-A9A0-4DC3-A179-64128E994AC4', N'Employee creditor details', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'AF7A7997-4CE2-41B8-813D-9AE6DF46797E', N'Employee payroll details', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'656502D8-3898-4451-8609-5F9BBCF23463', N'Download employee salary certificate', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'3631B1E9-B9CA-4CE4-B33B-3DDBA2B2459E', N'Approve employee tax allowances', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'E50D0E15-8A69-488B-9391-27659FA2AB4A', N'Tds settings', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'83B1EF70-F371-42AF-A8C5-A1632033D4B7', N'Hourly tds configuration', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'7CD55073-755E-4126-A4B7-E880BA223AC3', N'Days of week configuration', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'3B2AFE42-A447-454D-8873-C42E218FBFFD', N'Allowance time', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'2DDDBEBA-63F7-423D-B522-1181B5782DDE', N'Contract pay settings', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'8AF0BA30-3BB3-4C0B-9450-43E05D5FBD59', N'View employee loan installment', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'7E12ED2E-0A76-450F-95DF-16EB35A3EA23', N'Employee loans', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'D9FDF976-5055-42CA-87F6-644EA5BF1F2E', N'Approve employee loans', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'513B41A3-BA1A-4A5C-94B9-1FAEDCBCE6DD', N'Add or edit employee loan installment', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'7A11C52B-30C2-4923-977C-3C4D0F87A4CC', N'Edit payslip', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'2CCA224D-9693-450A-B47B-7B1142350A07', N'Manage rate tag library', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'12E01F5C-3064-415A-BE33-EAB6DE261F8C', N'Manage employee rate tag', NULL,N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'3C0C75B9-46D8-4AE4-8BB5-36A0721F27D6', N'Rate tag allowance time', NULL,N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'EB5AF322-1502-4F00-92B0-A2EADA7D08EA', N'Manage specific day', NULL,N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'eb729085-0411-4298-9fa5-5318b0225b22', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'58822DB6-B5DF-4431-A851-45AF8D9AEC1E', N'Manage rate tag configuration', NULL,N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'87ABB450-990F-4D24-94FC-739C1A664C7B', N'Archive payroll', NULL,N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'7517DF07-DEEC-4329-B080-A3F3ABAC620D', N'Manage bank', NULL,N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'eb729085-0411-4298-9fa5-5318b0225b22', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'EB2770FE-58A1-42AA-B388-8B57A45B990A', N'Manage payroll bands', NULL,N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'82D718AA-3BD1-4180-BD9C-B3130D5C89B1', N'Employee previous company tax', NULL,N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
	    (N'B50D9A50-06CB-4D9B-8227-617CDAF016FD', N'Add/Update employee bonus', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		
	    ,(N'5E73B957-3BCE-4B54-825E-C28417B57F11', N'Manage overall settings', NULL, N'632C2C2E-3527-45B1-9DE8-6043A12F3942', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'A7E7B4B9-CC2B-4FC4-BF0D-35056656A7B4', N'Manage system settings', NULL, N'632C2C2E-3527-45B1-9DE8-6043A12F3942', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7742336E-E00A-4B98-8D84-F27528F28339', N'Manage project settings', NULL, '94C74250-5D25-4973-909E-51C280AD09C6' , 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'24B393DB-44CE-4833-946D-61D842C70431', N'Manage HR settings', NULL, 'A91CF15F-692E-4328-8D57-0851BC66EC8C', 1, N'1EC88BED-7062-4C8B-A638-D49EE842054D', CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'543FB7FC-86C8-4E06-8723-D96CDFC082E6', N'Manage timesheet settings', NULL,  '6B49DFE1-E79C-4845-A2F3-7518D72CCFEB', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7C46BC39-A7E7-4A2D-B85E-ED7D403A2439', N'Manage leave settings', NULL, 'F80DD978-F979-4990-B084-59C48E272A2E', 1, N'1EC88BED-7062-4C8B-A638-D49EE842054D', CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'ED1D4558-BA92-4BCC-A580-EC0C0488E2A5', N'Manage payroll settings', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'1EC88BED-7062-4C8B-A638-D49EE842054D', CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        ,(N'9FBD5371-1754-C320-761B-2E7053CB3915', N'Manage assets settings', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B6DBF40D-5F58-8471-F5D5-F1E214A6AC6B', N'Manage audit settings', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4D093E75-2A43-487B-1B8F-907B82BC14E8', N'Manage roster settings', NULL, N'1F913475-F189-4329-9ABB-61D1801F257D', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
       
        ,(N'5B5CB01B-E4D8-6535-E62C-4F6A3D78D013', N'View project reports', NULL, N'94C74250-5D25-4973-909E-51C280AD09C6', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'A949A58A-54AF-AC31-CD59-132E8C2894FC', N'Manage status reports settings', NULL, N'465e3538-c86a-42af-b865-0586f1816029', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6891F830-14E0-60C8-DFDB-D5C4F7DE6CD4', N'Manage app builder settings', NULL, N'dabae0ce-06c1-49bc-a409-a5390cb3b700', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
       
        ,(N'20BCA242-E5A9-D2D1-742A-D5C10C74B19A', N'View expenses reports', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'30A64BA9-2FDB-5E1D-F0D6-71BFC54656F3', N'Manage expense settings', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F65E7934-FABD-FC07-6452-C76EA98A93C0', N'Manage invoice settings', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'A2B0408B-C34E-4D7C-979C-CBD8D57E6AD7', N'View assets reports', NULL, N'0017687d-b4f5-48ef-bbb1-b5cfee2906d9', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'295FDC02-A1E0-3936-2412-7D2B3C5E6565', N'View company productivity', NULL, N'632C2C2E-3527-45B1-9DE8-6043A12F3942', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'90D34DB6-7E47-4075-60BA-A1897B292398', N'View branch productivity', NULL, N'632C2C2E-3527-45B1-9DE8-6043A12F3942', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'76F2AFDA-9701-59D2-8679-68C13F2DEC4D', N'View productivity', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, N'E1D15A92-E89C-6C90-9EFA-C7E585D94C31', CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)

	    --Custom fields
	    ,(N'63051871-d91b-43d1-8c5b-3f1b85f12a64', N'Add or edit custom fields for project management', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'd36e5e73-0491-410e-a850-76dcbe5da0d1', N'Delete custom fields for project management', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'33755276-74C6-4253-AA05-A713B28B9FB2', N'Can submit custom fields for project management', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'd7a843d5-4e31-4e82-aea5-e77b22e24613', N'Add or edit custom fields for HR management', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'74fbafbc-fd1f-4dc7-9fa0-3c459412f31d', N'Delete custom fields for HR management', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'494B94A6-9AD5-44AE-A1C5-477059D4F675', N'Can submit custom fields for HR management', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		 
	    ,(N'8B154265-6F3D-4222-BF8F-89A6BBB3AD29', N'Add,edit,delete custom fields for invoices', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6098A309-B0CB-4A22-A586-7B1D743DFCB1', N'Can submit custom fields for invoices', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)

	    ,(N'7E498DC2-F0A4-4DA4-A457-6741EADE5A33', N'Add,edit,delete  custom fields for expenses', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'25FC903D-3D8B-4DE3-8514-E5BED581F866', N'Can submit custom fields for expenses', NULL, N'2CDAADB0-F0CB-4513-B547-13A8652143B3', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		 
	    ,(N'48BD5E94-1E22-423D-98E4-BDA63427D0E5', N'Add,edit,delete  custom fields for assests', NULL, N'0017687D-B4F5-48EF-BBB1-B5CFEE2906D9', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'AB8838C6-14A1-499E-BA0C-79B39904D2B4', N'Can submit custom fields for assests', NULL, N'0017687D-B4F5-48EF-BBB1-B5CFEE2906D9', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		 
	    ,(N'F14A8B90-C070-4117-A932-1EEBCEC05978', N'Manage Rate Sheet', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'4DFEBB9E-B080-4043-8FB6-81E2049D1546', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'0392812F-4B3E-4166-A601-04D58FE4EA5D', N'Manage Peak Hour', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'DBC9E524-EF08-426B-87E7-AF73DFCD89AA', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'A2BF7CDA-EF3B-49D6-B1E4-C786CE15BB9B', N'Manage Employee Ratesheet', NULL,N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'1F913475-F189-4329-9ABB-61D1801F257D', N'Manage Roster', NULL, NULL, 1, N'9B244E95-4636-481F-8D67-A3583E821313', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'EACD1105-3B6F-48B9-A8CA-140592482A8F', N'Create Roster', NULL, '1F913475-F189-4329-9ABB-61D1801F257D', 1, N'9B244E95-4636-481F-8D67-A3583E821313', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'F0D5BA0D-464F-4019-849C-C27E4681BD78', N'View Roster', NULL, '1F913475-F189-4329-9ABB-61D1801F257D', 1, N'9B244E95-4636-481F-8D67-A3583E821313', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'5A221595-8A31-47EA-A830-84267C3A5E7E', N'Edit Roster', NULL, '1F913475-F189-4329-9ABB-61D1801F257D', 1, N'9B244E95-4636-481F-8D67-A3583E821313', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'FEBDDCA7-8581-4701-B80D-D77CB603F30F', N'Approve Roster', NULL, '1F913475-F189-4329-9ABB-61D1801F257D', 1, N'9B244E95-4636-481F-8D67-A3583E821313', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)

	    ,(N'09900C86-081A-4584-8237-0DB406A6D7BA', N'View payroll reports', NULL, '642D9BD8-610A-426E-86D2-AC66706D7B00', 1,NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)

	    ,(N'B9DFC655-C29C-4E04-8731-9B0E6E197C56', N'Manage badges', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'eb729085-0411-4298-9fa5-5318b0225b22', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F829742D-BA2D-4194-8EF0-67DEC1470310', N'Can assign badge to employee', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'951FF220-922A-4CCB-9971-07E64376DD2E', N'View badges assigned to employee', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'FF9D085A-3931-49A8-9DAE-A543BA6AA381', N'Can pass an announcement', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'A70176B7-768B-4CA0-B31D-3BE7378AC6B7', N'Can view Organization chart', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'C3DE241D-F502-4D86-9B89-DFCDC3DF6ED5', N'Configure performance', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5040A778-B439-4C29-8C46-E8C5D34C3414', N'Can access performance', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5E34726C-6368-49D0-88D8-7E4F4E7D0161', N'Can approve performance', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'78635301-7668-4B60-9D3E-5D8C1C160C55', N'Manage induction work', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6A0731F7-BCA3-44CD-998B-5743267FB789', N'Manage exit work', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'22491EAE-8323-4B0B-9FB4-900FE6FA0BE4', N'Invitee for signature', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
	    ,(N'0C94E4A7-5F29-49E8-9611-3FBB1CFBDA19', N'User Upload', NULL, N'528f8181-5941-4098-aecc-6c43153f7dfe', 1, N'3fa32fa4-c63e-4565-aec1-a0ffbd6ef317', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'76dd0670-0b77-4e5c-92d5-7b9a41da34a7', N'Work Item Upload', NULL, N'94c74250-5d25-4973-909e-51c280ad09c6', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)

	    ,(N'5CE961F7-32D2-4C38-9781-38353C120644', N'Can create reminders', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
        ,(N'C1FB7F26-C9F3-42C7-8ADE-2848B7597F97', N'Employee logtime details report', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, N'7E174395-8F84-4930-8394-2CECD6AE7CEE', CAST(N'2019-09-17 11:11:59.613' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'FD29AEFC-42A6-4866-82A9-FE843D36D380', N'View company details', NULL, '632c2c2e-3527-45b1-9de8-6043a12f3942', 1, N'2749d0d6-3eeb-486b-8fa7-31c5fc3fca6e', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'6D3995AB-307C-46B6-8B11-2260635FF383', N'Upsert company details', NULL, '632c2c2e-3527-45b1-9de8-6043a12f3942', 1, N'2749d0d6-3eeb-486b-8fa7-31c5fc3fca6e', CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'A3B9B81A-109B-445D-9AEA-6B8A2B71C884', N'Can have full access to company', NULL, N'2d6aae92-06e4-487a-939e-b5d66d682fe0', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'C0621DE0-2F3F-44FC-9D02-E46597EFE300', N'View employee app tracker complete report', NULL, N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', 1, NULL, CAST(N'2020-04-20T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)

        --Audit management
        ,(N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', N'Audit management', NULL, NULL, 1, NULL, CAST(N'2020-04-10T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'E019ECCC-E398-40DC-A95C-EC0F3771C258', N'Access audits', NULL, 'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, 'B30DC3F6-1411-4A09-88F1-13FEFE3B1275', CAST(N'2020-04-10T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    --,(N'7EEE0735-9D75-49D9-88FE-710B2B466107', N'View audits', NULL, 'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, 'F46D2E60-4AD5-4882-BF54-C75BD26A0ED1', CAST(N'2020-04-10T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    --,(N'570177D3-0429-4AA8-BFFE-254E1E2B2E51', N'View all adhoc works', NULL, 'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'47380C9D-2EC7-4106-8AEE-8C14A1A7FFFA', N'View question types', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-04-20T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'DD4B5A49-9594-4106-9954-995C095F5D7D', N'Add or update question type', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-04-20T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'286D2D57-0E8A-4B6F-9F7D-B3518BE4C7E7', N'Archive or unarchive question type', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-04-20T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8D791593-1F3B-4789-A141-762B32B43218', N'View master question types', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-04-29T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'98D0109C-88BE-4F7E-AF71-395E64F78D36', N'Add or update master question type', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-04-29T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9766BAEA-2FA5-4ACA-939F-DBA85F4E1058', N'Archive or unarchive master question type', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-04-29T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'BA2464BF-C6F9-4B3B-995E-F7833FEA70B0', N'Can view audit complaince report', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-04-20T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7FA4281E-9EC9-4AEA-BF8A-A7D613F019EA', N'Can view audit non complaince report', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-04-20T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'049CFA7D-BC33-45B6-BB38-F94479A51CA2', N'Can view number of audits submitted', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-04-20T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)


        --training management
        ,(N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', N'Training management', NULL, NULL, 1, NULL, CAST(N'2020-05-29T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'7BDFD84F-2416-47B4-BE9E-0E16F2617EA6', N'View training courses', NULL, N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', 1, NULL, CAST(N'2020-05-29T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'F915CD54-9E07-4E23-BB2C-89AB326B8335', N'View training reports', NULL, N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', 1, NULL, CAST(N'2020-05-29T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'60D74B68-47D9-4D4E-A624-C59910283289', N'Add or update training course', NULL, N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', 1, NULL, CAST(N'2020-06-01T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F2CB1EF2-D544-4491-9026-148F53FD404B', N'Assign or unassign training course', NULL, N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', 1, NULL, CAST(N'2020-06-02T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9A5E3E71-AB44-4145-A6C3-912A0B0F6FCC', N'Archive training course', NULL, N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', 1, NULL, CAST(N'2020-06-03T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F59F9F21-5833-409E-9861-717C7C013806', N'View training assignments', NULL, N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', 1, NULL, CAST(N'2020-06-04T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3515DD83-E79D-484D-ACDB-29809881107B', N'Add or update assignment status', NULL, N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', 1, NULL, CAST(N'2020-06-05T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'86939EFF-6229-469B-AC9F-9C91FE5B1EDA', N'Authorisation', NULL, NULL, 1, N'B559A6B0-E37F-45BD-A1A4-73190522B491', CAST(N'2019-09-17 11:11:59.613' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'67058FD4-7264-4ECB-8E0B-4CEE0E4380CB', N'Alternate sign in', NULL, N'86939EFF-6229-469B-AC9F-9C91FE5B1EDA', 1, N'B559A6B0-E37F-45BD-A1A4-73190522B491', CAST(N'2019-09-17 11:11:59.613' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'92CE56F9-26FF-4E9C-A974-CF9F0490D4A6', N'View user status history', NULL,N'2d6aae92-06e4-487a-939e-b5d66d682fe0', 1, NULL, CAST(N'2020-06-05T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'CFD444ED-0FB8-46CA-81D0-829A2C51CAC4', N'View training matrix', NULL, N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', 1, NULL, CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8E7CAC53-4831-40B7-AB4C-3F4F8F084751', N'View training record', NULL, N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', 1, NULL, CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
		 
	    ,(N'23DA003F-D1FC-4AC5-B051-F1F1A4D9DD16', N'View audit conduct timeline report', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL, CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B65C336F-5739-484B-A6BE-0DDB9825E8D6', N'Manage document templates', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
		
	    -- Scripts
	    ,(N'C18522C7-81F5-460E-93C6-E830F5848869', N'Manage scripts', NULL, N'6C8108C8-6D9B-439C-ACEE-7358037F1C20', 1, NULL, CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'D61A12E0-1902-44AD-9DB9-2E8CE155947A', N'View group messages', NULL,  N'2d6aae92-06e4-487a-939e-b5d66d682fe0', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    --Company structure
        ,(N'5C7980DA-71DB-45BA-988E-BB0E5528AF58', N'Manage company hierarchy', NULL, NULL, 1, NULL, CAST(N'2019-07-02T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'49C8F995-EE29-4E55-B136-B2A6D7219D6A', N'View company structure', NULL, N'5C7980DA-71DB-45BA-988E-BB0E5528AF58', 1, NULL, CAST(N'2019-06-07T16:18:05.277' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'117299CA-8FC4-4EE0-83DD-EAAA0B10505F', N'Add or Edit company structure', NULL,  N'5C7980DA-71DB-45BA-988E-BB0E5528AF58', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'BD446D02-EFE4-4E63-B83B-C5463B395640', N'Delete company structure', NULL,  N'5C7980DA-71DB-45BA-988E-BB0E5528AF58', 1, NULL, CAST(N'2019-05-03T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)

        --Business Units
        ,(N'6C966874-025C-465B-9D9E-C69546DC58D9', N'Manage business unit', NULL, NULL, 1, NULL, CAST(N'2020-11-10 06:09:05.550' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'E467AA34-60DD-4821-95DF-989DB2E1B7B1', N'View business unit', NULL, N'6C966874-025C-465B-9D9E-C69546DC58D9', 1, NULL, CAST(N'2020-11-10 06:09:05.550' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'83D2EE67-0359-44DF-A1D3-9B9CE3F4F4EC', N'Add or Edit business unit', NULL,  N'6C966874-025C-465B-9D9E-C69546DC58D9', 1, NULL, CAST(N'2020-11-10 06:09:05.550' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'EE98BB8F-E5A6-40B8-A3C4-49AA57CC0061', N'Delete business unit', NULL,  N'6C966874-025C-465B-9D9E-C69546DC58D9', 1, NULL, CAST(N'2020-11-10 06:09:05.550' AS DateTime), @DefaultUserId, NULL, NULL)

	    ,(N'38CED01C-DB50-4999-ABC3-EAE960DD51DB', N'Manage system exports', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'2B447F3A-8022-43A7-B145-731D5F6678F6', N'Manage system imports', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)

	    ,(N'2255D42A-9F95-453A-9FD8-A10CCE9909D1', N'Generic workflows', NULL,  NULL, 1, NULL, CAST(N'2020-09-28T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'D5767665-D117-44A8-B5D1-375363B1FD68', N'Can access workflow status', NULL,  N'2255D42A-9F95-453A-9FD8-A10CCE9909D1', 1, NULL, CAST(N'2020-09-28T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)

	    ,(N'47DA5B02-11CC-4B83-B20A-78C08DDCDE2E', N'Manage payments', NULL, NULL, 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'D3C8C1AD-7DE2-42A9-A67C-54E4DAF075E2', N'Manage accounts and billing', NULL, N'47DA5B02-11CC-4B83-B20A-78C08DDCDE2E', 1, NULL, CAST(N'2020-10-05T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
	    ,(N'A33C61F3-9C23-4BC4-8A74-6516D60D4C08', N'Edit Form Data', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'5BA15ECB-2A87-43F8-8FE8-A554D41C848A', N'Manage CRM', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'A8FD1565-9563-4C44-B07D-410685297523', N'View CRM', NULL, N'6c8108c8-6d9b-439c-acee-7358037f1c20', 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'C521DB70-B7C1-4751-B41A-CD6C5108E366', N'Configure probation', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0AA22480-9E86-4254-82CE-64E530E6A8BB', N'Can access probation', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B921C1DE-3B10-4D33-B538-578DC1D99BCC', N'Can approve probation', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'552395B3-AEB2-41C2-A07F-89B27B1DF8B4', N'Manage timesheet status', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F371622B-3CEC-46D0-AE2D-99349C1B0098', N'Generate or submit payroll', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, NULL, CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'57AE5D56-B002-4A69-9FB9-2C01E3589130', N'Approve or reject payroll', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, NULL, CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'DC0E9E15-1203-4506-8E2F-E6ABE88DAC00', N'Pay payroll', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, NULL, CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'9E9EF19F-76C6-40C5-A5E1-09EA5A3F79BA', N'Configure KYC', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-01T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        
	)  AS Source ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [FeatureName] = Source.[FeatureName], 
        	    [ParentFeatureId] = Source.[ParentFeatureId],
        	    [IsActive] = Source.[IsActive],
        	    [CreatedDateTime] = Source.[CreatedDateTime],
        		[CreatedByUserId] = Source.[CreatedByUserId],
        		[UpdatedDateTime] = Source.[UpdatedDateTime],
        		[UpdatedByUserId] = Source.[UpdatedByUserId],
        		[MenuItemId] = Source.[MenuItemId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId])
    VALUES ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[Feature] AS Target 
	USING ( VALUES 
		(N'6AAEC58E-DE60-4ED4-A923-65644D76A7C2', N'Manage Webhook', NULL, N'2D6AAE92-06E4-487A-939E-B5D66D682FE0', 1, N'DFF07A85-8683-478F-B5A8-182D75541726', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'40AC6FAE-794D-47E9-B968-1B7E175EE93B', N'Manage htmltemplate', NULL, N'd02a0437-2541-4134-83c0-e4b68127d830', 1, N'FBAD26C8-866F-4662-AB51-118724099613', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'D0AE20C9-BF9C-4389-8904-E9557D7B498F', N'View monthly payroll details', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, N'D197333A-627C-438C-8D82-CB5FECF23912', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	)  AS Source ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureName] = Source.[FeatureName], 
			    [ParentFeatureId] = Source.[ParentFeatureId],
			    [IsActive] = Source.[IsActive],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId],
				[MenuItemId] = Source.[MenuItemId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId])
	VALUES ([Id], [FeatureName],[Description], [ParentFeatureId]
    , [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[Feature] AS Target 
	USING ( VALUES 
		(N'3216B685-9281-4D49-A9F1-B3694584CDA8', N'Add or update action category', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'69A7C9F7-FB0A-4A79-A583-501EF98FEB52', N'View action category', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'BC7608B8-DB69-45CA-9EDA-D58B2C53AD31', N'Archive or unarchive action category', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'D6AB31F1-77EA-42E6-AF88-3FB810E6028A', N'View audit rating', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'50AE7EC0-CD77-464D-9739-29857771F778', N'Add or update audit rating', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'511B1B19-0213-4543-8A54-658B7109C257', N'Archive or unarchive audit rating', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'C78F8D41-A5BD-49FC-B8E3-6E3B59AC9034', N'Add or update audit risk', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'85540515-9519-4D84-AA23-0DCF4C7815A0', N'View audit risk', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'1FF6899E-C2C0-44BE-B21B-76BC70AD4C36', N'Archive or unachive audit risk', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'8C60C33E-1FE7-4483-8BCC-971CA2935008', N'Add documents for question', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'D234DE9D-3698-4A62-BA41-0A93FAE75F33', N'Add or update audit priority', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'09BA0A39-D73B-4438-A4B7-B0BA911878BF', N'View audit priority', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'7ADEDC2F-5ACF-4460-8853-A46D3E3734ED', N'Archive or unachive audit priority', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'6F4E9038-A24C-4D14-B36E-5853200CCA70', N'Add or update audit impact', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'CE38473E-5C96-42C6-AA42-6EEDE76553C4', N'View audit impact', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'C8F7B712-F3DD-499B-9E36-87BC182DB66C', N'Archive or unachive audit impact', NULL, N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', 1, NULL , CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	)  AS Source ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureName] = Source.[FeatureName], 
			    [ParentFeatureId] = Source.[ParentFeatureId],
			    [IsActive] = Source.[IsActive],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId],
				[MenuItemId] = Source.[MenuItemId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId])
	VALUES ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[Feature] AS Target 
	USING ( VALUES 
		(N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', N'Recruitment management', NULL, NULL, 1, NULL, CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'D3F572E3-25D4-4C5C-A6D8-32A3CBBFC77C', N'View recruitment', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, N'1113527A-ACCA-4F47-AC45-2E96079269A6', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'EEB5AD07-D04E-445C-9EDC-6E917E08D030', N'Manage interview rating types', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'97EE1B04-044F-44D5-8D5A-707113512C5B', N'Manage document types', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'8F8C51FA-D6C9-49CE-BA73-60FBF2CD77F9', N'Manage hiring status', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'9DABF053-D39F-4FC9-88D1-3DAA1A46D2CD', N'Archive job opening', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'C7D10B20-E2D7-41C2-9F95-048A33D974A1', N'Link interview process', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'1901D9EE-1A93-4535-835D-39DDDC82F454', N'Manage interview process', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'51A64097-7524-45E7-A2CF-E0E121F5B619', N'View candidate documents', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'A14FB958-09F3-424E-8FB8-CB5B295C38FA', N'View candidate skills', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'807385CE-3516-4AF8-AF73-1102CA4258EE', N'View candidate jobs', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'FDE6F348-10C1-4DD3-A8E7-9373B9078D89', N'Manage job opening status', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'C4570212-B4B9-4757-BA3F-C87A93F5EFBE', N'View candidates', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'8CEF5444-63F9-4AF8-8EC3-D8F485F319E3', N'Add candidate details', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'779592A3-6F1C-4AF0-806C-26B46B85CC76', N'Edit candidate details', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'C0929BFE-96CE-4FF3-8DD9-FF63BEBFBEDE', N'Manage sources', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'306F884F-A47F-4531-AAA0-37353654D9D5', N'Manage interview types', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'C334FA0D-A0D3-4FE5-AD07-CA1A30B06BE2', N'view candidate experience', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'BE787980-CF4A-45C4-A79C-F422E145875C', N'Add or edit job opening', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'F7518593-DAA7-49EB-A7BE-8726107AB58D', N'Manage candidate documents', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'2853548E-C0DC-45F0-A1FB-960A53CF7BA7', N'Manage cancel interview schedule', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		--,(N'068F14E5-BA6B-4F19-9A88-7F8162710826', N'Manage interview reschedule', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'E31FF25D-84A2-41D1-87A8-0B3AF661AB38', N'Add or update interview schedule', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'75D0A775-3D68-4624-A6FA-A4C37F19A944', N'View job opening', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'0E15892A-0716-4833-8325-DEF5EDF98627', N'Link candidate to job opening', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'052EF8CA-91D8-4DE6-99C3-1A13ACFBE8F2', N'Link job opening  to candidate', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'152EF8CA-91D8-4DE6-99C3-1A13ACFBE8F3', N'Archive candidate', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'48CD09C7-EDB0-4F98-989D-D50DC0C70084', N'View candidate education details', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'DF1A5AFE-F908-41F3-A034-6B3C525F71F0', N'View candidate history', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'0B1A5AFE-F908-41F3-A034-6B3C525F71F0', N'Convert candidate to employee', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'7AA105DD-6C7C-4878-B0EA-DDCC80D37C12', N'Hired documents', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'FC458F87-4C8E-4EF4-A2E7-B2E499501CE8', N'View recruitment schedule', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, N'DBF0C7E8-30D5-4C9D-A21C-19CB01B44763', GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'C8D9C9F2-BFA4-4619-9F96-C3A7177947EF', N'View schedule confirmation', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, N'DBF0C7E8-30D5-4C9D-A21C-19CB01B44763', GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'4B068355-DAFF-412C-A6B4-3133BEB75C6D', N'View interview feedback', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, N'DBF0C7E8-30D5-4C9D-A21C-19CB01B44763', GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'A6D2EF4B-D73E-4437-B812-09E9C3B243DC', N'Send offer letter', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1, NULL, GETDATE(), @DefaultUserId, NULL, NULL)
		,(N'3862F720-C148-4649-A32D-97025811D35A', N'View candidate bryntum schedule', NULL, N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', 1,NULL, GETDATE(), @DefaultUserId, NULL, NULL)
	)  AS Source ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureName] = Source.[FeatureName], 
			    [ParentFeatureId] = Source.[ParentFeatureId],
			    [IsActive] = Source.[IsActive],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId],
				[MenuItemId] = Source.[MenuItemId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId])
	VALUES ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[Feature] AS Target 
	USING ( VALUES 
		(N'7EBFBDB0-EE66-4A16-902E-18A62CD0E8C9', N'Resource usage report', NULL, N'94C74250-5D25-4973-909E-51C280AD09C6', 1, N'B30DC3F6-1411-4A09-88F1-13FEFE3B1275', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'86762993-C543-43D1-9034-647B1095CA5A', N'Project usage report', NULL, N'94C74250-5D25-4973-909E-51C280AD09C6', 1, N'B30DC3F6-1411-4A09-88F1-13FEFE3B1275', CAST(N'2019-05-21T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', N'Trading', NULL, NULL, 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'3E0071E1-6E5D-4596-8436-161A28B45BE2', N'Add or update client', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6F4BDCDC-0C35-4E93-BA29-F3028E27CBD2', N'Manage import or export client', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'5661A6BD-01CE-441F-9FD8-42BD7B64E06E', N'Manage Purchase contract configuration', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'562FA0CA-B2F8-4409-8DAE-9FAE4452D8F8', N'Create Leads', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'C29A9771-221F-4735-8F94-8CEBCB166B29', N'Add contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9118FCEE-C6C6-456A-A985-D87C971FC59F', N'Manage client settings', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'625ADDB4-955D-4765-B598-9A062CFF8C3C', N'View contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'96EADE43-EDAC-4775-BB75-861670E75EB3', N'View Trading', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, N'05F97EE8-693F-4B52-A905-66B34680C10A', CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'BFC7E7FC-D279-4A7E-86C5-668ED8EBA996', N'View Purchase Executions', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9740C489-A3F3-4065-8748-07A42759D159', N'View Leads', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'51AFE938-42A3-4751-8A9C-5EBDB00F3713', N'Archive contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0DB33301-CA08-4816-A828-2BB0E4DECE99', N'Add Purchase Execution', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'FA8279C1-4AE8-4F73-B0E9-28F338D82BDC', N'Edit contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'86C43591-3484-46FE-ADA2-390BB74FA2DE', N'View credit logs', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'886C95D6-541C-47E9-859E-0E37665ED818', N'Manage Addresses', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'552AF980-1F38-47E3-9614-50B7030C31C1', N'View client KYC history', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'C23ED0F6-9569-429B-8B59-1D5979EAA3AE', N'View email templates', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4B53DE09-5A6D-4556-8C85-AEC44CE00E9F', N'Edit email templates', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B98A20A9-46B6-4E5C-8109-3E8F01F0B71A', N'Manage contract status', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'662DDC92-7F9B-41B0-814C-72423D6033C9', N'Manage invoice status', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'2FEA469E-93C0-48E2-B27B-382895A4F782', N'Manage tolerance', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'81FF012E-B1C9-44BD-9B41-D39879B39A48', N'Manage payment condition', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'6437C206-EDBE-48F2-B525-E71DD4B73460', N'Manage contract templates', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B07A30B6-1067-4A5E-B913-76F1177BE357', N'Manage trade templates', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'E4A82106-3B35-4B7E-A1D0-950CE39EAA7C', N'Can have all execution steps', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'C521DB70-B7C1-4751-B41A-CD6C5108E366', N'Configure probation', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'0AA22480-9E86-4254-82CE-64E530E6A8BB', N'Can access probation', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B921C1DE-3B10-4D33-B538-578DC1D99BCC', N'Can approve probation', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'552395B3-AEB2-41C2-A07F-89B27B1DF8B4', N'Manage timesheet status', NULL, N'a91cf15f-692e-4328-8d57-0851bc66ec8c', 1, NULL, CAST(N'2019-05-20T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'F371622B-3CEC-46D0-AE2D-99349C1B0098', N'Generate or submit payroll', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, NULL, CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'57AE5D56-B002-4A69-9FB9-2C01E3589130', N'Approve or reject payroll', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, NULL, CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'DC0E9E15-1203-4506-8E2F-E6ABE88DAC00', N'Pay payroll', NULL, N'642D9BD8-610A-426E-86D2-AC66706D7B00', 1, NULL, CAST(N'2019-12-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'5F1BFEFA-F657-41D0-81FA-0F4C1AD069E1', N'Manage Vessel Confirmation Status', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'4FF9DD26-6466-402B-9B24-3217830E087F', N'Manage Port Category', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'5ABBF5BD-0B94-410E-BA08-C8B364643F06', N'View and Accept or Reject Q88', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
	
	)  AS Source ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureName] = Source.[FeatureName], 
			    [ParentFeatureId] = Source.[ParentFeatureId],
			    [IsActive] = Source.[IsActive],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId],
				[MenuItemId] = Source.[MenuItemId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId])
	VALUES ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    MERGE INTO [dbo].[Module] AS Target 
    USING ( VALUES 
        	(N'4a58c560-58c6-4e49-9c1b-316a4db58d5a',0, N'Process Dashboard', CAST(N'2019-03-11T09:57:46.820' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'12c29cf7-cc76-4436-9de1-3ae02dd1bd39',0, N'Test Repo', CAST(N'2019-03-11T09:57:46.827' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'3ff89b1f-9856-477d-af3c-40cf20d552fc',0, N'HR Management', CAST(N'2019-03-11T09:57:46.763' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'a3f36a17-53e1-4cb4-bf71-668fcdbb683a',0, N'Audits', CAST(N'2019-03-11T09:57:46.823' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'6f06cead-6aab-4f05-b3ef-832ca114a9ee',0, N'Live Process Dashboard', CAST(N'2019-03-11T09:57:46.823' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'94bd961b-a1a1-4c00-ad63-8b47f24be404',1, N'Role Management', CAST(N'2019-03-11T09:57:46.807' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'a941d345-4cc8-4cf2-829a-aca177ca30cf',0, N'Time Sheet', CAST(N'2019-03-11T09:57:46.810' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'c1224c25-327c-44c6-97c0-b888195fce9f',0, N'User Management', CAST(N'2019-03-11T09:57:46.810' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',0, N'Projects', CAST(N'2019-03-11T09:57:46.800' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'48acffde-44a8-4ca9-bb9d-eb439eb10700',0, N'Leaves', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'94410E90-BC12-4A39-BCA4-57576761F6CB',0, N'Company Structure', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'5205492C-EB9A-4B52-BBB8-4377501930A2',0, N'Expense Management', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'F353078E-A359-43B3-AC89-489DB438EE07',0, N'Chat', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'991FA5E4-D85B-4F1C-9970-33625164327A',1, N'Settings', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904',0, N'Asset management', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5',0, N'Canteen management', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'3C10C01F-C571-496C-B7AF-2BEDD36838B5',0, N'Leave management', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F',0, N'Status reporting', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'E6C10627-B14C-4808-9B14-3FB91FB274AC',0, N'Food orders management', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'317FA168-F501-444C-B1C5-14C598DC18F3',0, N'Forms', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'BC1AD640-8322-4190-9D33-B07652294EE3',0, N'Notifications', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'FC1B8596-034E-4DFF-BA37-822C1F5DC843',0, N'Organization chart', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'B1FDED15-15C6-4F45-9EAD-63F8A37351F9',0, N'Room temperature', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F',0, N'Security', CAST(N'2019-03-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'9C9684AD-E2C2-485C-A66C-B6D388337BD5',0, N'Activity tracker', CAST(N'2019-05-22T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'4EE851A4-0572-4101-989D-25026A3DEDF4',0, N'Dashboard management', CAST(N'2019-05-22T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'68B12C14-5489-4F7D-83F9-340730874EB7',0, N'Document management', CAST(N'2019-05-22T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',0, N'Billing management', CAST(N'2019-05-22T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'5B098F2E-1FE0-4C31-8E9F-F62A182DAC3D',0, N'Feedback', CAST(N'2019-05-22T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'A17DF4B9-7B27-4272-B545-A38BEB761CE4',0, N'Booking management', CAST(N'2020-01-22T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
			(N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303',0, N'Payroll management', CAST(N'2020-02-11T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
			(N'D8535273-0E2F-4A34-ADAF-B8DA48A4F90E',0, N'Roster management', CAST(N'2020-01-22T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'E23D114E-86E8-4883-B104-C7C6679745B1',0, N'Custom applications', CAST(N'2020-04-22T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
			(N'5CF2D2BA-1008-423A-B312-9C75979A1672',0, N'Authorisation',  CAST(N'2019-05-22T09:57:46.803' AS DateTime), @DefaultUserId, NULL, NULL),
			(N'ABC7458E-3C13-4056-85A3-75F0B61A5320',0, N'Training management', CAST(N'2020-05-29T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL),
			(N'5A31FC4E-BA93-4BED-B914-E44A5176C673',0, N'Recruitment management', GETDATE(), @DefaultUserId, NULL, NULL),
            (N'05E222F2-6EA3-4CA6-8788-52416E67475F',0, N'Trading', GETDATE(), @DefaultUserId, NULL, NULL)
    ) 
    AS Source ([Id], [IsSystemModule] ,[ModuleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [ModuleName] = Source.[ModuleName],
        		[IsSystemModule] = Source.[IsSystemModule],
        	    [CreatedDateTime] = Source.[CreatedDateTime],
        		[CreatedByUserId] = Source.[CreatedByUserId],
        		[UpdatedDateTime] = Source.[UpdatedDateTime],
        		[UpdatedByUserId] = Source.[UpdatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id],[IsSystemModule], [ModuleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES ([Id], [IsSystemModule],[ModuleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);   

--------------------------------------------------------------------------------------------------------------------------------------------------------

    MERGE INTO [dbo].[FeatureModule] AS Target 
    USING ( VALUES 
			(N'2A5B5CF7-E965-4991-99F6-5020BD5E053A', N'7EEE0735-9D75-49D9-88FE-710B2B466107', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'F94F1012-B031-446A-9F5F-7E7A5CD2853B', N'71677129-594B-4BA0-8D8D-B632A603CBD8', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'381c2b6d-5579-4a2e-b5d7-021edffe53da', N'0017687D-B4F5-48EF-BBB1-B5CFEE2906D9', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'764c5692-5ddd-4d6c-9516-feda7c57b813', N'5C7980DA-71DB-45BA-988E-BB0E5528AF58', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'ca3793be-3ced-40c4-afe9-fe33d187b57a', N'49C8F995-EE29-4E55-B136-B2A6D7219D6A', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'60c4d036-94cc-4e83-8a1e-7ed783d0e6a5', N'117299CA-8FC4-4EE0-83DD-EAAA0B10505F', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'25907e87-9409-49ed-9ee6-231447bddbd2', N'BD446D02-EFE4-4E63-B83B-C5463B395640', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'609DB6CA-CBC7-4D16-807F-3BAFF4C32E26', N'5C7980DA-71DB-45BA-988E-BB0E5528AF58', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'9FC57988-C7FA-427B-8E9C-BD8FD6716912', N'49C8F995-EE29-4E55-B136-B2A6D7219D6A', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'36046FA5-6B0B-4117-B545-0DA2D477780B', N'117299CA-8FC4-4EE0-83DD-EAAA0B10505F', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'1E3D21A0-1101-4FBE-B406-D36D6D26EB72', N'BD446D02-EFE4-4E63-B83B-C5463B395640', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
			(N'ed437dc1-1abf-41a2-8cc5-067b39a63636', N'93FF3297-9FA5-48E3-ADF3-4954A8C51720', N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5', CAST(N'2019-03-11T10:39:52.810' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'96065bdc-f865-45cf-a1d9-08f3b3c003dd', N'2D6AAE92-06E4-487A-939E-B5D66D682FE0', N'F353078E-A359-43B3-AC89-489DB438EE07', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'79ED4A11-698E-452B-9627-0BCB4B6F7FAA', N'632C2C2E-3527-45B1-9DE8-6043A12F3942', N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL),
            (N'1067d8b5-d511-4b60-a776-10fe1a380464', N'57B2B1C6-D2A9-424E-A131-AE9E48EC6D33', N'E6C10627-B14C-4808-9B14-3FB91FB274AC', CAST(N'2019-03-11T10:42:08.223' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'64f6a01a-1ccf-4e72-95d2-11ed09e49b35', N'438C6F61-CA8A-4AE9-8D29-DDF92F30FF01', N'317FA168-F501-444C-B1C5-14C598DC18F3', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'238F2D87-90D0-430F-B500-B136083E7106', N'8B8716C2-5278-4E82-83E9-75967FAC8FC5', N'E23D114E-86E8-4883-B104-C7C6679745B1', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'923FB55D-465E-47A0-8D93-DFA7E8F9052E', N'B6A89133-F7EA-4846-A9B9-CF0B07C8751C', N'E23D114E-86E8-4883-B104-C7C6679745B1', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'1128d30d-e10d-45e2-a183-1607739d4d06', N'A91CF15F-692E-4328-8D57-0851BC66EC8C', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'8ea23855-3b49-4188-aee4-1855b2ecb3ab', N'F80DD978-F979-4990-B084-59C48E272A2E', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'b4060736-7cce-43fd-a71e-1c364a8149db', N'373DA4E5-FAA3-4656-8800-057E15EAAFB1', N'BC1AD640-8322-4190-9D33-B07652294EE3', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            --(N'0d50bed2-bd69-4713-aa54-2258161ad31a', N'E37B1251-07E8-4C9E-98A8-929731DFD938', N'FC1B8596-034E-4DFF-BA37-822C1F5DC843', CAST(N'2019-03-11T10:37:31.960' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'84686af3-b16c-4351-b593-290162b6f221', N'94C74250-5D25-4973-909E-51C280AD09C6', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'639db24f-9086-4964-87e3-2afb753a337c', N'A3B4484C-4F5A-4AA5-8D98-5C8696D6A09F', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'bdb57a3a-dbfc-4df8-a0d9-2b966c063092', N'B126C444-24D6-4BF1-A91C-DBBC314C3872', N'B1FDED15-15C6-4F45-9EAD-63F8A37351F9', CAST(N'2019-03-11T10:44:24.160' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'f1f55892-83c2-4ccf-93b8-2e48f23fa014', N'528F8181-5941-4098-AECC-6C43153F7DFE', N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'2e7f01c3-e37e-48a6-8810-3207e5122b1a', N'465E3538-C86A-42AF-B865-0586F1816029', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-03-11T10:39:52.797' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'6B719D02-7FD0-4F07-AEFE-9FBE2015733E', N'6B49DFE1-E79C-4845-A2F3-7518D72CCFEB', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'ecdab8f0-6972-42e9-b15b-33951d94284b', N'A07C27B5-1C6C-4CF9-9DFD-58AEBC149192', N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'69b31324-d0af-432a-8576-344911c69947', N'B2D12AF0-193F-4133-A6DB-587D1C3BB293', N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F', CAST(N'2019-03-11T10:41:34.427' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'e2dfac6b-36b3-47c1-9979-351b5dd409db', N'F45CF108-9817-4071-8220-898CF40099F8', N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'c199330d-69b7-471b-b374-35a6c5dc51a9', N'4B3AE462-92E1-4C49-88B9-C7067F93AC9B', N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F', CAST(N'2019-03-11T10:37:31.977' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'86803401-5c90-4458-bfb1-3a8ccba5bda6', N'8C947AF0-C7CD-4F5C-B755-8396918B11DF', N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F', CAST(N'2019-03-11T10:20:48.170' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'73d4caab-60b7-4202-a96b-3c28d30afbd7', N'81425352-61DA-47BD-98E6-B133EBE20DA6', N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'da64ae74-0f97-46a9-99bd-3d64d892796b', N'3722A977-2578-43C3-BBA6-BDF79B741E10', N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F', CAST(N'2019-03-11T10:34:24.403' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'625d5466-47f6-44ac-b564-3d80e5b67d38', N'FA1ED611-C599-4C74-83BC-90CAA3EE73AE', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'e8cb6ec8-afb1-4bbe-911e-3ddca19f03de', N'D73EA2AA-B26F-4A83-A089-7488CA345167', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-03-11T10:41:34.433' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'dd9f5459-100e-484b-9e72-3f0870476b67', N'212D77E7-3E63-4D44-9747-391523EE722F', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-03-11T10:39:52.807' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'b30dc337-82fe-4d95-8c2e-3f144efdf804', N'4A987FA8-231D-49BE-AD46-84482A32BDA4', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'e17466b8-08f7-44dd-ba39-41fc159f6dfe', N'8CA4A51C-4921-4FA8-8B56-B8CFF868563F', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:30:51.860' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'944fe56e-bbca-467f-9e69-458eefaf7e4f', N'1EA77455-1ECA-4D7D-A75B-86FF45B3555E', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'61b05413-acbc-4c9f-9441-4988c01741cf', N'8A67D6D6-48AF-4720-9C6B-296208DC93DE', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'38c2ff90-0d51-46a8-ae2d-4c37deba602d', N'C580AF28-8780-4C4D-BAF4-B8EEB7BE4411', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'64e4155a-85cd-4aa9-afe1-4cc9b0f4990e', N'5F2E2BDC-7943-4217-90C8-B8886B24D9AA', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:36:26.113' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'a453ff78-f024-4e68-83d2-4eb2ae039cce', N'E6F4C002-AB0D-435C-A044-2F9527155F50', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:42:08.257' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'2a89dcfa-fb04-4b42-be09-4fe172d736a8', N'EA9785B3-8AD8-416C-8194-6F9A3CB9CD05', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'b8dbdd84-2760-4521-bf38-50adf2fa5295', N'DA71CB6D-2758-4528-BBFF-D6F31EBB80B1', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'1721f41a-ccb3-49b4-900b-58868c72b062', N'E3E572EF-F2FD-4643-9982-B4A7ABBC8422', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'3bfda953-8a01-405f-a01b-617f8d057deb', N'E0FD7B15-C67A-447D-AD26-81232FA7424E', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:42:08.240' AS DateTime), @DefaultUserId, NULL, NULL),
            --(N'535715c0-7d6b-4342-bb78-63cd30da6c72', N'7BB99906-39C1-4015-84B5-17011CE1925D', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'c428a1a5-9751-4bef-bfc4-66479fd116d3', N'3E8484EA-92C6-44E0-AFC0-4464EB709046', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:19:29.457' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'b5fafffe-a2f1-45e5-9151-668d6ed20298', N'14E13B03-7429-44B6-9C23-2E5E81FF60CC', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:44:24.157' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'af410646-32b5-4c5f-965a-66e15dd53b44', N'ECA49F6E-A93E-472B-A792-DA759CED660E', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:30:51.857' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'6565a70e-6523-43c2-86d0-7342b75c2923', N'85E02F29-E3E5-4428-9E77-2A42B190CDDA', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:39:52.817' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'a1646ede-96e0-44a8-b36f-7666d39408c9', N'31773C75-D2DA-4F39-9202-4B0280814756', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'7495905d-33e0-4930-893c-7a43c1c334d4', N'68A49F78-4DB9-4F7D-B302-C3ED039F5B4C', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'8167aa3f-1aed-4644-a4ee-8566acfac3b3', N'CB1BBDB1-6E69-4913-9329-B08CF4AA407E', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:20:48.137' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'e6bc984a-74ad-4041-b64d-87c3d7734062', N'33F49110-324C-441A-A16C-741DD89DA5A2', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:30:51.870' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'2ac4dde6-5c1f-4cc8-b852-896a50dcbf32', N'A280C7F1-0584-4DB8-ABC8-0D9F1CAFDC3B', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'32e2ce50-e26e-4447-b9d9-8984679879e0', N'78D5F664-AA1F-4350-8496-8DE690AF0EC8', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'e773044c-afea-47af-a6b9-8cb2226a2f20', N'60F55765-521B-42F7-A6E0-E0B16538AEC3', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:39:52.800' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'd2f63412-ccc8-42c4-bff0-8ce64563a602', N'F3AEDC05-A81C-4F8F-B7F7-5B07C128CE12', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'cda3e4d4-5874-46b8-a631-a8c250e17700', N'e92554b4-1583-4240-84de-145619b020ad', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            --(N'a903c510-59a2-484e-b8f1-8d7550613f62', N'7056A1D4-D08A-4BB5-8C4E-650CCC7F670A', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:36:26.080' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'4dfaabcf-27ff-4e5f-9df3-900368a8cec8', N'D3ACE3D7-9DC8-4672-9DDD-FB18CDC88E68', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'581ed887-2876-435c-be38-90881fe9de11', N'82CC4ED8-919E-42CE-8FA4-D66A322F063C', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'834f4e6a-2dbc-45aa-8d8e-97eee8e28d96', N'015319B6-D705-4676-B3A6-D637A7081761', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'af5092b6-adda-49d2-bd7d-9a2847d197a4', N'776A34C2-4548-4AA2-8042-96966E2F2C1D', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:39:52.803' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'd9566f9e-ada9-4504-9b51-9bbaba682804', N'DBE32FD3-E64E-46CE-A87C-0F06ED2995E6', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:30:51.843' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'abaa9fcf-fdc7-4f72-a800-9c7e690e3f3b', N'D0078582-63EC-4D11-B765-ACE25477EE7D', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'eb063b7a-4499-472c-9cd0-9feadf719248', N'88E15818-CF58-4ADA-A5C5-9391AEDDFC18', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'9836ab70-a809-48fe-bda6-a016c671d1f1', N'2D18DB5B-C8C8-47E7-B4A2-4291F4C65F36', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'339bf3fc-5cdf-4d0b-b486-a27bd0972de6', N'F16639B3-D220-4794-8B94-D4A6FC227316', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'1d1140aa-5861-402f-9327-a5232d6a1a41', N'F0310F7F-2194-4E3B-9C80-BF2851340803', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'3a7b95e0-a63a-4783-af0a-aad5e8a04f2b', N'D1865698-9C7E-4D5D-B076-89CE8BF99E43', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'765b36d2-e2a5-4879-9e7b-ad384c352474', N'C0667777-CA0E-4B12-9F42-242DD20FDA45', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'b91692ea-26a1-4e4d-9d83-b1edaf3851cc', N'AB1218DB-D348-45DB-BF5A-9808DC00651E', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:19:29.440' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'cb6be98e-642c-4a5b-84eb-b9456ac3fb73', N'BC3F0AD1-D9C5-400A-BA4D-65F57A35C45B', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'c30fc454-e003-49e9-b2de-c342f0d1c468', N'371FE420-4525-4D53-B977-FF5B6A6CDD90', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'48fd005f-f314-4162-878a-c4ae5c72385b', N'F369FF94-F64C-4028-94E5-91D6CFF2C74A', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:20:48.167' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'8cdb3150-f459-4857-8861-c5b57624d106', N'3B7CAE23-30A6-4BB6-80D4-6BA115607EEB', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'4f3437fa-2b65-46c4-b35e-da3cfa6b36fa', N'105B8E1C-D81B-478F-95A0-8C88D2D80BE9', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'1f1a4498-36e3-444c-902e-daab6c4d0428', N'177D8CD2-AE16-4289-8453-DD4431FD20BE', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'8250cbbf-f765-4110-883d-db9976512736', N'7774A180-FB01-4996-9EF3-7186B2F47556', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'0BBC099C-3A42-409B-AB21-5AF0396DD27E', N'F633A5A4-C36B-4947-AD31-BB4A4BA46F93', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'9D64672D-1368-4010-A0F9-0CC8BCE93AD9', N'3845D5C9-E786-49E2-8262-5C2E251257EF', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'038cfaed-80d1-4a6c-af96-dc0db8537b78', N'C4269551-FC5D-4850-BA65-66B91D390833', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-03-11T10:42:08.260' AS DateTime), @DefaultUserId, NULL, NULL),
            --(N'720c44a8-86ce-45d5-b90c-dd1502b03299', N'BD151BA2-9EFF-4FDB-9B1A-C2067F61FE65', N'FC1B8596-034E-4DFF-BA37-822C1F5DC843', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'd2a372d2-2ebe-4d72-96e7-dd82525383c0', N'22DEBA23-471F-4F96-B458-1A53A540AC99', N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5', CAST(N'2019-03-11T10:39:52.773' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'902cea7f-2615-4d98-872e-e1e421415329', N'7E51EC66-FDE3-4BEB-B7C6-BD3AE84F3AB3', N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5', CAST(N'2019-03-11T10:44:24.133' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'1e5d96a5-afe2-4d91-a4ff-e2ae3ce910b3', N'C692C6CE-E6AC-4090-B41B-295066EDD3CC', N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5', CAST(N'2019-03-11T10:44:24.117' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'7cb4eefb-6c79-4d4b-a446-e375e2469ced', N'AA593ABA-A5A5-4207-BF67-79A487BD441E', N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5', CAST(N'2019-03-11T10:42:08.240' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'1a11359f-1b96-49cc-bc72-eccaa1204005', N'4FEFF215-0FDC-4592-A942-C36AE2B94C9E', N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5', CAST(N'2019-03-11T10:37:31.967' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'd43f945c-dfda-4581-875c-ed90374058bb', N'65013EFD-16C8-4E7F-9A26-71401EA74B45', N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5', CAST(N'2019-03-11T10:30:51.877' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'e8f46e49-54e1-4390-ac87-efe1d584b94f', N'4258DDDE-DA15-48E1-97BE-3C72ECAE70B2', N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5', CAST(N'2019-03-11T10:36:26.087' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'851f25e1-9f9f-457a-92f7-f0cf4e003b20', N'92AD11C0-C155-471E-B7E9-461ECCDB5DD4', N'B1FDED15-15C6-4F45-9EAD-63F8A37351F9', CAST(N'2019-03-11T10:41:34.423' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'3660e240-b3d6-46f3-841d-f9140a1c3a68', N'14DE641A-B105-4FA6-A655-E16B265A2BEA', N'E6C10627-B14C-4808-9B14-3FB91FB274AC', CAST(N'2019-03-11T10:42:08.233' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'baf07308-e06b-4010-82b5-f9cb345f0f8d', N'8D4F4DD9-5911-4BA9-9A9D-A57B8E27F4E7', N'E6C10627-B14C-4808-9B14-3FB91FB274AC', CAST(N'2019-03-11T10:36:26.110' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'c955bdb8-4179-4d84-9383-f9de8185907d', N'53A073FE-3781-451C-BF0C-ADB4EAC85D10', N'E6C10627-B14C-4808-9B14-3FB91FB274AC', CAST(N'2019-03-11T10:44:24.120' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'6df277ae-eba7-4bfd-817e-fabf6a9cf2d9', N'3CC69BC9-B410-459E-BF0E-B5172A522FF6', N'E6C10627-B14C-4808-9B14-3FB91FB274AC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
            (N'4609af1d-b230-4aa0-88c6-fece9e75dda1', N'9C6EE407-2DE4-4398-8CDA-463724D2C376', N'E6C10627-B14C-4808-9B14-3FB91FB274AC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'9E1511B5-D7EE-4EC9-841A-FA18AC213305', N'D5694B15-8C1D-4D0C-9543-E7E75E44F05D', N'E6C10627-B14C-4808-9B14-3FB91FB274AC', CAST(N'2019-03-19T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'CA0E3015-8BF2-4005-A78A-D44293C9E80A', N'D84D5F4F-39DB-4CBE-AF74-1F40179B00C4', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-19T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'6CF9AE64-788D-4CF0-8076-65A922914A43', N'A6ADC4B4-11E5-440B-B472-62624EAF8F79', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-19T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'10955903-CB8B-464F-A3A8-AF0DD04BDC51', N'E1CA9EB5-E315-4783-8CF5-703516063E54', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-19T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'A4E5B5BA-989D-4640-827A-F7B9EB575422', N'69360404-1A1D-48C7-BAC0-515274F101AB', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	--(N'BC8FEB9C-1967-48D6-9AA9-49576073108E', N'794B029D-4835-48CE-8AD1-E4BA17C4203F', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'208D839A-76F3-4F4A-9A41-3AF5C11AB4FD', N'C8EF072C-6F7C-4BB7-8C66-0D64F0C838B5', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	--(N'07D93E7F-E42F-41F1-A108-2191120793A2', N'CDFEEAB0-9924-41A5-8DAD-CAF8520BBB6C', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'210DCD3D-B497-40CC-A65C-E80F3065E825', N'4A2E2EAC-1234-4A8F-8EBD-63C68264DFB4', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'6938250A-3120-407B-894E-554E22D8DAF5', N'FB695ABC-CB26-4E36-AD0E-D4E0F40F7354', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'F53B8C8F-4CBE-41EA-B801-0572026BD163', N'B289AAC5-5E1B-4E6D-8AA1-443259B4E7F0', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'91AD370E-86A8-40C0-BD2D-509651094112', N'11D37B68-7EA8-4BA8-9E46-4F979FA20821', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'8F16B26D-C2BA-47F8-A366-209B5B73A623', N'8DD962B3-B283-4827-BB0A-37B60C24CECF', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'C59F1726-CF73-4128-983A-73FBB94465AE', N'D40387DA-C5BC-4512-93C5-DD0D2BDD83C9', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'01F663BC-089C-4E87-937D-8B61EACC8EA1', N'ACE153D5-0C46-4AA1-B93D-7E89B01DAD07', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-04-10 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'9F3E2AFB-DE18-4979-9CDD-1BB116B4F396', N'BB2292A7-7BB6-4606-9D92-5D54FE0693E8', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'4052E81C-8E23-45B4-9331-09878D3F2C56', N'8B28CDA0-0F05-4999-850E-ACBC3856F39D', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'D984CA25-0654-46EF-9D49-036BF84851D7', N'DE865DBD-B6D6-43AD-A560-BD71F9DA4266', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-04-18 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),

			(N'BA29EFB1-63C7-4E2C-941E-F47E02B1F2D2', N'1D1FF3E5-D8F4-4C19-BD66-827D11901DC8', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-04-18 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),

        	--(N'BD143D4B-22D8-4B9A-AEE8-978BE416B644', N'F299291F-E1E3-4CC3-BDF1-D4ADA32E9A89', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F',CAST(N'2019-04-18 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'26382338-93C1-4349-9E65-E6DB38CFE3FD', N'22117779-4744-4B8A-A21E-836699CA7951', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-04-18 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'A58DB6D3-78C0-48BF-8DD1-982D7C0BFB21', N'3680A22E-FBE2-4372-8BE5-3BD283A8EECE', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-04-19 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'E89DCFA6-36F4-4BB5-AFB2-5233BD44BD43', N'9227D745-CD7F-41ED-90AC-6D2430341185', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'16CA0511-DDCE-47A1-B38A-D2616ED3D109', N'455A85C4-BD8D-4425-B978-44D17778520D', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'AFD7CCD1-1F99-48E7-BCA6-790DC2B1A13B', N'7ED5EAC4-0065-42EC-9999-79C858198845', N'317FA168-F501-444C-B1C5-14C598DC18F3', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'2BC340D0-9D69-48B5-A281-A514E59E9639', N'C3DBC2EA-06A9-41F9-97DA-55893B767A34', N'317FA168-F501-444C-B1C5-14C598DC18F3', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'F063013F-4D19-4029-8125-B6F53EFB3A11', N'8EBA255A-7973-43D9-BE0F-D2ABDFC281A7', N'E23D114E-86E8-4883-B104-C7C6679745B1', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'EB25814F-2B49-42AD-8C2D-5DC62386814C', N'137FA14C-E705-499E-ACDF-4926EECF74EE', N'317FA168-F501-444C-B1C5-14C598DC18F3', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'A3A00DD4-1C1C-4AEB-A5EA-AA140413154B', N'B2117C2A-99A0-4676-BDFE-31B0DABECFB7', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'78DE2B71-94C7-4701-A152-40AE5BF9BFF6', N'2C22916F-B80B-4C51-9534-23F698DE120B', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'894E3A8C-19C7-4690-BB4E-2E96DA6BD3EC', N'3D2C8442-F298-4169-BA46-B319B6BC929C', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'0BE2D79A-DD34-440F-BAF6-108513578AC0', N'5416A640-3F1A-461F-A0A0-0260434A7F98', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'61273488-DE83-4341-84FB-1E0E0818AAE3', N'5D7D8B8F-640E-4CB7-BAFC-16F3B2157BD3', N'F353078E-A359-43B3-AC89-489DB438EE07', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'70B9BB12-2E42-46BD-92FD-67B48AD701D1', N'391C62FC-92F4-4587-AF59-48E92BEC68CC', N'F353078E-A359-43B3-AC89-489DB438EE07', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'E6977B0A-5070-452D-AE55-EE86D86C6031', N'E10DDAE0-39E4-4010-9981-269FEA0991D5', N'BC1AD640-8322-4190-9D33-B07652294EE3', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'2B25D149-53DC-4F40-AD8B-C7DAD41D9580', N'A3726A74-D39C-4791-8057-F0C1862FA08D', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:39:52.800' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'4FE0512A-1F43-4138-BC86-605361B09B7F', N'0777C967-C399-4766-B1E6-F4C54AC0615A', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'69C7D282-4CC3-4066-83FD-7C550D5CC159', N'3F644A8B-6603-4BD2-B4F7-7644D3316396', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-03-19T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	--HRM																													  
        	(N'FD899495-D0B9-447F-B5AF-5DC65C4A1778', N'05209B4C-7CE9-4E00-9BE3-989798603B01', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'33DFE797-B029-4B9F-8D5F-FC9273DF38E0', N'368B22EE-2089-4AB6-A400-C8ABDD34D886', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'36339149-1EE2-4D48-9AA5-6463D35CB164', N'99646779-A28C-4615-9ACA-6F2495ADF07A', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'f516bd4c-d53c-428f-8d00-ea492395d369', N'0F264FA6-38E1-483A-A3DC-116F78AA978F', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-08-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'F5BF9CD2-72EB-4F8D-B007-FF339EAA5B99', N'53EF12A9-3722-4CD6-83B3-4BD3D5EEB486', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	--(N'209D77FD-3F16-449F-BA90-A3AA8ABA3E97', N'A6CD2213-5D0F-4656-9961-00AA07CE13F8', N'3FF89B1F-9856-477D-AF3C-40CF20D552F 1, CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'96E66835-70A4-421F-9B18-C47AA1DDFA56', N'A4FD2D93-CAA7-44B5-806F-F45DB6AE1322', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'ACBD9033-D8A0-4CD4-9C2B-321E2C8DCC86', N'7DEED649-510A-436D-8BA4-C03AAAD18EC4', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'E9EACF9F-D3EF-4CAA-B6ED-0AACF27F8CDA', N'568F51E0-BDA3-47C2-9C3E-71EE6D717565', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'845EF387-BD7E-4583-B2AD-B66E6D77F35A', N'AC2F36C6-6B03-4CE5-9E23-6A4691AFEE75', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'D8B84375-95EA-47CA-8F8B-224CDB2868F5', N'F12C7ECF-418B-4978-A113-131C5A8938E7', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'996A88AB-B9B4-42C9-995D-8459BDDE6AD1', N'8804FDEA-94DA-4444-8F09-B8CFC55281E8', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'89E8C054-B888-4876-AEF6-83CEC7630B8E', N'F38B833B-D383-48D5-A0F0-FBB399F61C47', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'2D8A68C5-D5DD-473D-A180-E9B18CECA1BD', N'26A3ADE1-2F97-4FC1-874C-E6C063B5762D', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'A8EFF64C-BEDF-497B-863A-E4CE24AA47DC', N'439DEFCD-5C44-4009-B63A-743B2379A9B8', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'9E015D50-21B6-4F61-BE2E-7CCAB368F7FE', N'BBEF84FB-E684-4903-BAEB-541A8D8EFBFF', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'309FFF5B-A57C-4418-80DF-EDBB858F961C', N'30307BAB-E865-496D-BD38-172732465610', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'019FE321-5508-4790-B41C-CF6E7FB0B9CA', N'FD3F1D35-6728-45D5-A3A8-0D1F5797F0C2', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'9A1B71F2-BA9C-4EC6-9CEE-FE98090937EC', N'6370060E-FB2D-426B-B057-C8F246DF9CBB', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'DFE9F6D2-6F52-4272-9E84-BE5887FB870E', N'F34F02D8-BA29-48E3-B1A0-AB85ECF4EC94', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'D576B650-CD0C-4F5D-9DEF-466F127D161C', N'436EAC34-E8E1-4D15-8B26-061144FF0F90', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'29B56DD5-184E-49C2-BB0F-E4DB91DF8AAC', N'BCCD1084-E715-499F-9D5D-572F062155FF', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'E96B42E5-FEE0-4345-8A70-0AB9133D8ACF', N'11AF3467-BEC6-45A6-9F73-CDB4F929C346', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'5F2C6FD4-80EC-4AED-B0E6-1AFB7D025F2D', N'892E870A-A4B7-4A63-8119-B10EAA88A871', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'DDF8CED2-11D4-4302-B8EC-90C93C91CE55', N'0A345822-1BF4-45FD-9021-69A09258D126', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'6EAD86B1-B83A-4253-B64A-8B82D2FC24B5', N'67B892C5-EA3B-4A7A-96D8-172E167717AB', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'956FCEF1-85AA-48EE-B4F3-025FEFD9AF28', N'F39D781C-C236-4A14-8B6B-B1BF3520CF9C', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'D81E2459-6B73-4509-8D23-2F1FF8BF655D', N'9AFFAD6C-00DE-483F-A5F2-442E68ADA2CC', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'FB0248E7-8A6B-482A-9637-2D694597F0B4', N'AA7C7DFB-EFA4-483E-8478-AB7DB2AD7E4D', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'134F3901-8E09-4989-B7D9-4B30C16F7A4A', N'7172C444-BC93-444D-A0B4-3E81A34E4DA7', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'1746AFF1-C666-4170-B2CF-9BFAC7E4BCF2', N'A5609408-2E26-4D9F-BCF4-A17D6CC7FF6B', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'E4660CF7-8E7D-4C4C-9764-D4C08CBC7A55', N'30139536-4A53-4ED8-8645-646DA6E8C3E3', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'F19F8CE8-B762-4F23-B4D7-FD86C7263253', N'78C66541-EA81-4054-B289-2584C191E50C', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'EABED5C2-E9C8-4AD9-BC8F-E54600C385FD', N'2313706D-52A9-4E22-ACEF-226EC64FBDAA', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'0F7ABE7B-A337-402C-9A2F-C7A97CE57E80', N'7F9A4596-1826-4387-A347-A58DF0734376', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'AE43F3E2-04FA-4541-9690-1B35D09CB3E1', N'90157706-EEE6-47C2-90D7-87D180575C49', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'F46757BB-3CCA-467C-A83B-64D38197402B', N'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-23T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'F2E16EDC-06AF-4BAF-B5C7-CD85D70F0B4E', N'E83B3AE8-E25B-4D5A-8D1E-3A4F28B85C09', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'568F2CD4-7E86-441D-BEA0-B6FC0455FA15', N'CA80EDD9-0CCB-4009-820B-704B14089677', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'4278B3E9-CA83-465F-B735-F1A6316E66A3', N'891CC46B-CBAF-49A7-9974-A3FD6824C483', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)    
        	,(N'BE860779-EA04-4A16-A227-821EC9362B92', N'D5FF153B-7AB6-480A-8826-18CA2F619287', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)    
        		
        	--manage HR management
        	,(N'7DE4D0E2-5DDB-4654-A09E-9917088C8B36',N'D02A0437-2541-4134-83C0-E4B68127D830',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'826111A0-6699-47F4-B502-CD1A58FC0EF3',N'BC7411C4-F26C-4B60-9264-A2E1E969B538',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'B075CBEA-713E-4E8B-AABF-A38349E35345',N'CFA1FEE1-8AEC-4F59-BC54-A2B729383E85',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'B56EFC46-3EEC-49EA-B3E2-7382DF391EC1',N'FA6EE079-E906-4749-B6F7-47230D7CB3EF',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'B45467A4-0591-4E08-92C0-03D9F85118F9',N'EE635C28-0FC2-420A-8C23-0F44DB2F5B4C',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'50C12720-1E48-4DA4-B8A8-836B6C736E38',N'A87250CB-0DA7-410C-89A5-511F322292FB',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'42F2516B-1FD4-4F9D-AFA6-2D9482F400D6',N'16881033-B027-4477-BE6B-D0CB0DBD3D21',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        
        	,(N'AD3B05F9-679C-43A9-9A9A-C2D34A8052C1',N'0AD0284C-DA57-4BDC-A7E0-38DC65688B5C',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'09BC56FA-E72A-4C83-97B8-37DE65722C67',N'1D1EAEA4-200A-497E-BEAC-86F15103FEDB',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	--,(N'FEAAD79C-6352-4EE7-9EDD-F2B482229B83', N'DFD183E6-8040-420E-8C26-BCF5B7DF7799', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'F17CD172-376B-4B66-980D-8D6AEE36CDF1',N'9EE8FEF9-E6DF-4A42-ABE6-27B8F1416A15',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'980D237C-5506-4D35-AD12-51E15039224A',N'BFC75CE3-5D68-4925-81EA-00976C6F662F',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'DE9438F3-5CD6-4F1D-99D6-06B001B7E556',N'AE2EB7E5-8E9D-4032-A1F6-1743A91FD810',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'40F1103D-BDA5-4C52-B211-C7C0276C4C01',N'E81E64E5-4438-4DF4-AAE0-146DCA7D6703',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'62930750-4338-4949-A9FE-7EE4919799C7',N'EF993FE2-E6E2-4222-B7AC-CDDE6078BDF0',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'0CAA27D7-DED5-49B4-A4B6-23F6C5C5EC6E',N'619D02EE-49E0-4AFD-8639-5CD82EFFC5D3',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'E3408D54-CA9A-4C6C-92E6-233F43A0CF43',N'34722F45-6282-4F36-89CE-8976A344AE05',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'3CC2E6CC-A011-449E-BB8B-2FD7518D7FC1',N'D4F3DD2B-B33A-46D5-8E81-96C2DE17D996',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'833A7119-CBB0-4774-9D0A-02DBE2AE97C3',N'219DDACB-A233-4A59-BDE8-68B6543BFC02',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'B9BAB3D0-5AEE-4508-96FD-BCA60336A4AA',N'445311B1-285F-4CC7-8FA4-04E7C5221A3E',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	--,(N'BA9C6CC1-A5C3-4F7E-B2AC-8EDA6DF2BEDE', N'EBCAE677-B157-4795-ABB1-2CA8B351652A', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'CB88AE95-A73E-4A68-B96D-097F4D0CBD1F',N'356CA902-C88A-41B2-A976-E08289AF01E3',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'ED16590A-1254-4176-9621-3E303274FD2E',N'0A72C152-55D5-4E4A-927D-D1A292914074',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'20BD5F11-C95A-47A2-BC46-E35A863C8227',N'A366C067-9182-418F-A853-79130167001A',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'935E9DE2-88F1-4DA1-9D3B-5EEFFDEF9627', N'09E6746A-C4A4-46C9-B3FB-D2672C9607C2', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	--,(N'E26A599F-832D-48B7-B6D2-19FACCE32F55', N'FE80145A-D9AC-444C-AB67-8E7B2B41A2CE', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'4A6A376D-FF75-4139-A562-E5E59796C484',N'21B790A1-6ABE-44A2-93EA-DBD38ED7A5A3',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'F72F0905-AD4B-4EDE-B2B1-0C969B32AD0D',N'32A2F1A9-B85F-4621-BF8E-E426A5534666',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'C42D457D-DA9E-48B9-8D92-DBCAF2CFD860',N'1EBFF0E0-605F-4EDE-8725-ACEA74C55E8D',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        		
        	,(N'01A6CE1D-1270-4B6B-8540-50C5A2DD4D7A',N'0BCB4B35-8EB5-46D2-A0CC-53D1945A87F2',N'12c29cf7-cc76-4436-9de1-3ae02dd1bd39',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	--Manage Projectmanagement
        	,(N'55514DA5-455F-4A71-9C88-A0B6CF623F77',N'1349A291-4E98-4918-B923-96FB0BBBFD06',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'B9B1ACDB-C834-407A-9FDA-827F1DF608B3',N'17586DD4-752E-4451-BD0E-BE98C8E22276',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	--,(N'A27EEEFB-5BAE-4395-AF93-090A55E13C2F', N'CD677A9D-5D4D-4640-8134-66D9F27992C5', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'6C34218B-8B31-4E58-B0A7-3DBB978372DA',N'AF4EC845-3D4A-4010-B968-F701A878673D',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'0A70BE47-AD87-4988-9190-EA32E36871B8',N'61007E4C-7B0F-48A0-A726-CC485B6CB2A1',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'CB605708-A24F-4982-88B2-FC951651539C',N'15A34738-C863-40CF-A67A-24A2C2B6B176',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'306F5361-FAE9-4438-82AA-EA3C58A77F86',N'4C3792A3-6C4D-4AF4-A6BC-4A87D6A066EC',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'1B5D9D2E-7B27-4117-B939-5AB3E2ED6092',N'BC75FDF3-7E5E-4FA2-B210-5852C41DD0C4',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	--,(N'2F0D0587-7E07-4695-B0DE-FD42B50812B1', N'E202F210-5592-4881-9534-9B90D9582058', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	--,(N'DE6BD2F5-86FC-4587-A8AA-96B50B89F19B',N'51FF182E-45C9-43BB-A813-53B92DC21E46',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	--,(N'25904A80-B836-4DBA-97DB-CEA5D32750F5', N'5B095B31-5FC0-4B91-9C0F-F6FDF1A1CC91', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'94326828-4F7A-442F-A51F-D75173AF64F9',N'85603293-1E1D-40BB-A6E7-54DB88340D0F',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	--,(N'EEE7C942-D8D9-4B17-A814-E02D717BF3EB', N'1EDD2DBB-A375-4B04-8358-C88DB76A4841', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'0C9BE76D-715C-4562-B16C-04A75144D66F',N'42DB79B4-37FD-46CE-A4B2-89348955DF44',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	
        	--Timesheet management
        	,(N'F3D468DD-0C48-41D9-8C2B-0553CDE0431C',N'6272FA8F-5E85-4A66-87F5-2A5C33729E0A',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'5E31FF29-4A9B-49B9-A79B-3456F5553C03',N'D94CD095-9CC6-4EEB-8F4F-45C70FC91B0A',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'7DE3598E-9616-4A25-9F36-C54BD871CCE7',N'871C9F44-8D4F-4B8C-8B0B-353DDD87EDC2',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'5C7DC14F-9141-4D51-B633-CA97C26002DE',N'B38B3588-BD01-4BCF-BDF0-6937D4189037',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'9814DA30-A847-4354-B865-1BCEB8114F8A', N'3D569305-47CE-4674-AC8D-A830B9D1FD2B', N'12C29CF7-CC76-4436-9DE1-3AE02DD1BD39', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        		
        	--Leaves managment
        	,(N'EBF632C7-7983-41D4-A82B-CE9A0D7AA198',N'B59BD701-8EC3-465E-9208-4888DA83DD61',N'3C10C01F-C571-496C-B7AF-2BEDD36838B5',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'86A95234-8C58-45CF-82DF-5D94593A48BD',N'9A3EC77C-4F4A-467A-995E-82B46C746A61',N'3C10C01F-C571-496C-B7AF-2BEDD36838B5',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'9C01F49C-B635-43A8-8DD9-F0F1233C98B3',N'0BF8995A-4F92-476D-93C7-5759A5538FD4',N'3C10C01F-C571-496C-B7AF-2BEDD36838B5',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'059EA6F3-2DA6-4C6F-A92F-2B5637773CCD',N'0414396D-E747-4367-B043-7A383F441B56',N'3C10C01F-C571-496C-B7AF-2BEDD36838B5',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'90A82383-3EAF-4E67-B10F-42407A1DECDA',N'E3A243DB-9E1A-4D74-8CAE-F22B47696679',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'2429D464-44E6-451E-A657-B2024411551D', N'FADCC22E-EDE2-4EB0-B929-9B14630D31A0', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'156A828A-02DD-4E81-95BA-B2EA37C85A08', N'9794D340-655A-4422-B826-2CF9C0F478E3', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'B108F772-DA76-412A-A9A2-F3EDDF85B747', N'F7EFF14E-2FE7-4FD6-AA79-7ED7D87495A0', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'7D281098-507D-45E4-A687-0A795F771611', N'C559FB2B-5659-4200-825C-7F95CE70C685', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'5DC5EDBE-8A30-478F-ABCD-521F1F67F6AA', N'CAE857EC-31A9-474C-9BBF-ABCB4E8670DA', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL)
        		
        	--status reporting
        	--,(N'832F0FF5-D59C-43F8-8C71-3F719547A96D', N'AE9230C0-B997-4804-A639-FF0968AFBFBA', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'145F2114-5C9E-44EC-8131-496AC0B4917D', N'76545D51-8BC0-46DC-B5D3-603051C6E797', N'317FA168-F501-444C-B1C5-14C598DC18F3', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'D0AA19D3-82CC-4DA1-AABF-1CB0ECAF7B35', N'C8DF56DF-5438-4876-8B5E-5D46BB3FA087', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'B09A7708-D035-4B4A-B925-F74692F3D135', N'8CA7B841-31A8-48D2-B6D1-3F299BE90CB7', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-05-24T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'A1E41A92-E31C-4728-A12E-B622075651B2', N'8C91A450-4FB3-4D80-98F4-E67648E60862', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-05-24T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	--Testrail management
        	,(N'1493A320-6D73-41A6-B73E-2F0BC854B601',N'37E0C505-FA24-426B-8DA6-5FD17FC5BEA2',N'12c29cf7-cc76-4436-9de1-3ae02dd1bd39',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'86A8948C-6F02-4142-8401-B37DE350A691',N'0D8663CB-49F3-49DB-8679-030207CA3FC5',N'12c29cf7-cc76-4436-9de1-3ae02dd1bd39',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'F9E4B909-371F-4450-B736-BE359DB50118',N'36414F52-41BA-4640-B59F-CC71241DBC2D',N'12c29cf7-cc76-4436-9de1-3ae02dd1bd39',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	--,(N'1E8E89B6-6D29-46BA-AB93-F4859D73D18C',N'96466483-D687-4C74-BBDF-787A274BA7E2',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'0F783F5E-C678-4B64-878A-BAE9C2D1B7FB',N'4DA88661-17D9-430F-B4D9-7B91ED93562A',N'A941D345-4CC8-4CF2-829A-ACA177CA30CF',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'F8F1EECD-88B5-4163-8034-00CFEE6D9C4E', N'90DB7546-442F-49EE-BA98-3D8A78383C6C', N'12C29CF7-CC76-4436-9DE1-3AE02DD1BD39', CAST(N'2019-05-25T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'0D485A40-D84B-4F41-86A7-5746E04C4DA0', N'721AEE4B-BB75-4DB0-B351-2BA2B5505229', N'12C29CF7-CC76-4436-9DE1-3AE02DD1BD39', CAST(N'2019-05-25T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        		
        	--Workspace management
        	,(N'CE600C55-5B54-4FDB-94DA-D9F2FB76B93E', N'6C8108C8-6D9B-439C-ACEE-7358037F1C20', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'54C137FF-76BC-4699-AB29-A5CD851320E4',N'BFBED52E-D5D3-4D4D-B658-56126DE36550',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'4EEC30A6-6672-4524-BD3F-E2C47EB781E3',N'A52A9252-52FF-4795-9627-F910450C48EB',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'1373A97B-4AB6-4F87-B185-F72E8D204D34',N'8E0FE086-DCBA-49ED-8D04-792040852FC2',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'E43095BC-7449-4115-ADA4-962B4CC333C0',N'DABAE0CE-06C1-49BC-A409-A5390CB3B700',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'00E1B016-6576-4E70-B3F0-734F5DF83581', N'BC4D77D4-0C34-42B1-A8F6-8A7008CD6111', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'ED3E22CB-CBEB-464D-9B08-C8E5BF569524', N'FD20B706-42B1-432D-AEEF-92C28AC7EF10', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'D6964124-BF9F-4971-AC7E-30B38269E42C', N'AD35BA30-115D-426B-A37B-8243759ED747', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'E2CEA912-557E-409B-AA83-69E43B1C508F', N'9E47F20C-73BF-43DE-B044-B8FB48CF3B33', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'13A9FE99-831A-49A5-91B2-6CF77A215EF3', N'1557DCD6-B1DE-44DB-8E4B-3BA4D2994383', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'CC8301EE-2112-48C4-94E7-835BD515735B', N'997B1D56-8559-41EF-A7C9-C50ACB123697', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            --company struture
        	,(N'5A855A7B-FF7C-47BF-9EEC-704574369F4A',N'A08125F4-0FA4-400F-9B35-CF7E2595FA2E',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'BAB18C1E-010B-4C57-ADED-A9B8F074DC42',N'7E00AC86-7C91-4794-A268-CD7547CE8F33',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'342E4E2A-59DE-4684-96B9-1B6CE89A8937',N'E1EF26E2-BD55-49C9-BEA3-209972ED4F14',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'087D2672-15E5-4926-82DD-24DC51487EE3',N'56D7D787-2A41-4C43-95A9-73EE1D6090B9',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'3F83DEA9-B196-4221-A01B-657577881056',N'D619A93E-E87D-43E2-AE49-022DD79380BD',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'F6C9706B-294C-4B27-8F0E-AA240C89C580',N'CEFAA542-8C5F-494C-AF67-73C8DF15F82A',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'40A499E9-51DC-42BA-B0FA-86B0D1585E08', N'CDB3341D-78A1-43F5-989B-C4C7DF8133CA', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)    
        	,(N'B3F4CAB7-6DA4-465C-ACF6-A405CE909759', N'FD29AEFC-42A6-4866-82A9-FE843D36D380', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)    
        	,(N'1BC6D2F0-3263-4BC2-ACB6-48FB29C4137E', N'6D3995AB-307C-46B6-8B11-2260635FF383', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)    
        	--My work
        	,(N'DE12B50D-F25E-4C90-927A-5E0C855B82CB', N'95FB2411-51C5-46C7-B712-05612528E302', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)    
            ,(N'BD931D98-C7EC-4D1F-9D71-32EF508E8060', N'D4220276-C1C7-4B45-AB38-FF326BB37908', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)    
            ,(N'C0E04468-0B92-4813-B36A-FFF6CF37E73E', N'C7D3B037-0015-4919-8E26-AB6113E55932', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-05-22T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)    
        	,(N'C6E66A1C-CB86-4B6A-AD26-B7501E086CA3', N'77542576-004C-4F28-83D3-B39194375246', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-03-11T10:48:51.907' AS DateTime), N'C6E66A1C-CB86-4B6A-AD26-B7501E086CA3', NULL, NULL)
        	,(N'A24A5510-FFD8-449B-8A20-5F38B1909376', N'06C2FB6B-8225-4B04-B700-FE50D5DD70F3', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-07-02T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	--,(N'2D4DFA21-362B-414C-8C2D-2E03BBD4CD99',N'EE655B63-06B5-4525-821E-57522BF98C57',N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'D28BA522-42B6-465B-9E82-94CABA8511DE', N'2BCB92A0-7244-4013-ABB1-897A39F15B30', N'94BD961B-A1A1-4C00-AD63-8B47F24BE404', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'E6C8E98F-1ECF-4B6A-AFFA-1711C42A09F6', N'AF236801-408D-4B33-A350-61EE8F194F87', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-09-17 11:09:08.420' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'F9F4B388-D69B-4116-8B22-45D0A6300FBF', N'A860BC87-85B4-428E-836D-CF733C6B677D', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-09-17 11:15:10.843' AS DateTime), @DefaultUserId, NULL, NULL)
        
        	,(N'00B0F36B-581C-482E-A7F2-5A5589789D2E', N'F2527D3F-087A-414D-9959-572E21386AC5', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-09-17 11:15:10.843' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'29D84640-E1CF-4910-A9CB-BC8A6E05A223', N'36AD0274-2E7E-406D-87D0-3514075709A7', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'FEFF0A2B-7303-40A3-AAB9-4AFF79CD4F04', N'02CCA450-E08F-4871-9DA0-E6DA4285C382', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'9590DE02-18C5-4A34-84DB-31AD1F94444C', N'3B054C8C-1647-4DE2-A0F8-79E370F668D3', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'7039D5A3-CEB6-4198-8F93-2C35EC087174', N'24EE1473-4632-4234-AD10-B1F358F567C4', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	---Settings
			,(N'31BF3CD8-FE64-479F-974C-C43B03DE72B8', N'5E73B957-3BCE-4B54-825E-C28417B57F11', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'4869DEC0-27CB-4131-96E7-6C78D266018F', N'A7E7B4B9-CC2B-4FC4-BF0D-35056656A7B4', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'C856B6BC-2356-4DEC-BA4D-CE4223DE9815', N'7742336E-E00A-4B98-8D84-F27528F28339', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'92603E91-4D0F-46AC-AECC-3E01A642B6BA', N'24B393DB-44CE-4833-946D-61D842C70431', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'097A0EBD-CAE4-4E5A-85EB-DE5E34518FA5', N'543FB7FC-86C8-4E06-8723-D96CDFC082E6', N'A941D345-4CC8-4CF2-829A-ACA177CA30CF', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'F44A1459-F606-4A9D-844E-D5E9F1F98E0B', N'7C46BC39-A7E7-4A2D-B85E-ED7D403A2439', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'1B3A5C21-97A6-417E-9942-3EA0CE890F5B', N'ED1D4558-BA92-4BCC-A580-EC0C0488E2A5', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
                
            ,(N'F2F7A252-CE2E-60BC-F98A-E52C4924273F', N'9FBD5371-1754-C320-761B-2E7053CB3915', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'6B8D80F6-4306-A0FC-BE14-C4105A419E73', N'B6DBF40D-5F58-8471-F5D5-F1E214A6AC6B', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'6F2B4E2E-8173-D13D-42C5-54EC304AC1A4', N'4D093E75-2A43-487B-1B8F-907B82BC14E8', N'D8535273-0E2F-4A34-ADAF-B8DA48A4F90E', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
                
            ,(N'FC2421C5-B592-18CA-FE58-B9C1DB158AE3', N'5B5CB01B-E4D8-6535-E62C-4F6A3D78D013', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'2BE9CB54-71A6-9DF7-C809-BEF461AF920E', N'A949A58A-54AF-AC31-CD59-132E8C2894FC', N'9B2B922B-EF24-420F-AECE-5DF01E2FFC7F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'C9439BDF-D82B-40AD-291E-DE86C180DA12', N'6891F830-14E0-60C8-DFDB-D5C4F7DE6CD4', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
                
            ,(N'54E98B6B-1B15-9CD7-B414-C70C6C17C615', N'20BCA242-E5A9-D2D1-742A-D5C10C74B19A', N'5205492C-EB9A-4B52-BBB8-4377501930A2', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'C7F7B2A9-3702-7C34-2A61-5B6C174B36B1', N'30A64BA9-2FDB-5E1D-F0D6-71BFC54656F3', N'5205492C-EB9A-4B52-BBB8-4377501930A2', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'6CD5A3CD-BA9C-7474-EBA2-9FB7AB5EDC5B', N'F65E7934-FABD-FC07-6452-C76EA98A93C0', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'D924FE14-3207-828F-3168-8F4CAEA426CA', N'A2B0408B-C34E-4D7C-979C-CBD8D57E6AD7', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		    ,(N'7C07A0D4-52F1-B6E2-B150-B21C43CDA14C', N'295FDC02-A1E0-3936-2412-7D2B3C5E6565', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		    ,(N'1E4C513C-AE80-E73F-5E1E-3D56AD136F49', N'90D34DB6-7E47-4075-60BA-A1897B292398', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'67FA48C0-5957-9462-182F-EA764B0252ED', N'76F2AFDA-9701-59D2-8679-68C13F2DEC4D', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:30:51.860' AS DateTime), @DefaultUserId, NULL, NULL)

        	--Master settings   
            ,(N'03B525C7-0199-4EA7-AE32-F2026CCB187D',N'E5E99C6D-04F2-4940-921E-0648213D7ADF',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
            ,(N'64495462-279B-404D-AC93-C5F71AD0C672',N'B7FEBDFD-C2FD-41C6-A795-7DBF32054A41',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'AC138302-5FCF-455A-AA0F-FD6A6BB66E10',N'E5A39D73-6EF6-4C40-8B39-2AD14F78FF7C',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'4416FF17-B5E7-4A8D-8903-4817284F6D15',N'027A6BA8-D6E8-493B-995E-A16376101C20',N'12C29CF7-CC76-4436-9DE1-3AE02DD1BD39',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	--Expense management
			,(N'6ACA3B6C-87D3-48CA-9E5F-EBC6251B27DE',N'2CDAADB0-F0CB-4513-B547-13A8652143B3',N'5205492C-EB9A-4B52-BBB8-4377501930A2',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'49314590-8E10-43CC-B6EA-A6CE0E8590AE',N'CCA06C43-92A4-4D45-AE25-FFBD4450FD6C',N'5205492C-EB9A-4B52-BBB8-4377501930A2',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'DADE91D3-2257-4839-AEB9-6CD509D8B8B1',N'D54EF735-0454-426A-AC2B-C5022EC3832F',N'5205492C-EB9A-4B52-BBB8-4377501930A2',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
			--Document management
        	,(N'2D97872F-31A4-4442-BBF3-F4F2DFF22816', N'7644F6BE-48A6-490D-91B6-3DB5B8CB41A6', N'68B12C14-5489-4F7D-83F9-340730874EB7',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'B74BBA0D-F795-4C8D-BC88-DFC2B3C47A0E', N'6C301455-7A81-40C5-916C-625D86C423CF', N'68B12C14-5489-4F7D-83F9-340730874EB7',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'234E57A7-23D1-40BB-9873-751393ABA585', N'52B77431-8DA0-4814-AAB6-309FE61321B8', N'68B12C14-5489-4F7D-83F9-340730874EB7',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'F6C67BA0-5220-4C17-8073-7D7FC56BF728', N'3A7F384D-7D9C-4C74-AB31-DCE678C9FCA7', N'68B12C14-5489-4F7D-83F9-340730874EB7',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'2D1E59DE-2C29-4CB5-8FDC-C3B26D717FAE', N'3E142FFB-CBE5-4C34-A5BE-9FD3C6D037DA', N'68B12C14-5489-4F7D-83F9-340730874EB7',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'610d787d-30e4-4943-9c4e-7e2f20b3d36d', N'B437D951-7587-4335-B03E-62C4D5600B19', N'68B12C14-5489-4F7D-83F9-340730874EB7',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'8920491D-4128-48C0-9296-F24FD5CEE6F4', N'D7816276-1B93-49CC-8E51-99762414E152', N'68B12C14-5489-4F7D-83F9-340730874EB7',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'3FDD4750-EB6C-4F98-99B5-A308B6B0E9D1', N'AB204D2C-2577-43EE-98A0-FA87A85CFE99', N'68B12C14-5489-4F7D-83F9-340730874EB7',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
				
			--Billing management
        	,(N'58B58AC3-5989-485A-A667-E94F1CA7F97F', N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'1003C15C-11F8-4BD3-B73C-AF5D94AA12DC', N'7670BA49-3296-4EBF-A5A6-36F46832ADC4', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'F5147FCB-0BFD-42A2-96A7-610CA53ADF91', N'8C09C431-9C80-4E69-9869-B5E949BD017E', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'E503722A-D62B-4D31-9DE1-E05A3D1A68D1', N'25308DB9-8310-42C4-8995-615DFAA4C607', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'4C9819F5-D29C-4D83-878F-FAA2C3C793D4', N'85A65EC4-D828-4DDE-AC62-33CDB3F01592', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'D2B8355C-BADF-4002-A695-6CFB01735B18', N'D6E8394F-38D7-4B18-8B63-283152326BF5', N'5205492C-EB9A-4B52-BBB8-4377501930A2',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'AC46754B-9DAB-41AB-A444-A9B784A79720', N'11EFDBAA-43AE-427C-B831-078B594BEEF1', N'5205492C-EB9A-4B52-BBB8-4377501930A2',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'DEA826C3-8E56-457D-8E8C-8D8822CFC5C7', N'496FBF72-200F-47D3-9813-9F074F886CA4', N'5205492C-EB9A-4B52-BBB8-4377501930A2',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'9EE48637-A501-4A70-9A2D-D308103F6024', N'7F6C2F9E-C678-4544-86AF-BC32D8BB3F1B', N'5205492C-EB9A-4B52-BBB8-4377501930A2',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'DA9B95A2-9B2F-4663-B4AC-9CAD209AA12D', N'A4DE6A99-E3E1-4BC4-9EF4-560076FA7440', N'5205492C-EB9A-4B52-BBB8-4377501930A2',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'456EE8C2-BF12-4212-BD9C-465F2904E094', N'694E21F0-BC3C-41A9-AADB-BEEA256029C6', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'6F4644E9-D025-4A53-AB55-C33783216D9B', N'38234110-8A67-46CC-AB82-370A8F6F0CE6', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'CAD922C7-401E-42CC-9401-7330728EE535', N'C1DB6780-AC21-4BB4-A945-017F7DFAA904', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'3ABF9DB4-98A9-4C8F-8FA5-5AC213F27360', N'9CE82415-885E-483B-80B8-235911073681', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'A8E7F3A7-F76C-44FE-9321-294373EE6155', N'97478AD6-E466-4A8E-9BF5-BCEC1930AFA8', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2020-03-06T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'C36E2D0C-D60A-4B4D-8AED-E7D13029C683', N'634D217D-9A66-4107-9539-E82FEE70AF78', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2020-03-06T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'7C4040D7-3014-4B07-AE70-73BF37AF9AD5', N'3470BB01-6130-4152-A9C1-47F9AB4F3B1C', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2020-03-06T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'2B658459-CC0C-4FEA-805B-C74D1A16DF98', N'1DA2769E-2A76-4A39-A1FD-DCAB9983647C', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2020-03-18T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)

        	--Activity Tracker
        	,(N'59EC376C-5197-495E-B1CE-4E33670F3973', N'7FFA6DB5-225A-4A78-A44D-949F9B15E57D', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'148BDBD2-4937-48F9-84C3-D4854815CBF3', N'5FAFD236-4EA0-4CDD-907A-29EC2D7678BE', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'CC89145B-00DF-4DAB-82E9-1E882ED85492', N'70D3FBAF-8027-449B-A5F1-C226313DADBA', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'FDCE9220-399F-491D-8F6E-7454FB206061', N'F10C49F5-69DA-425B-8CDE-923FF63F28A5', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'E15D1685-C1EC-4F5B-B432-13AF34683CAB', N'5B8E8857-9142-4277-95C8-26E4378B4D2E', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2020-11-11 18:22:52.030' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'ED3E12F8-8B76-4242-BC50-7ECF0CF6942F', N'367445F8-54C9-4848-A216-ABFA23B14AEA', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	--,(N'20D16338-5524-44F6-A7A0-08CACCBB6F46', N'E725A1B5-5339-47FB-83F2-4E00AE5731BA', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'551ABD08-1443-4033-BDFC-2DACF5932D5A', N'9CB69D96-A99A-49C6-B158-B58535897610', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'5EFEAB40-85D6-4F07-ADD8-08D578A74B2D', N'6648F5B5-529C-445F-BF70-97C74F101A28', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-11-06 13:51:51.540' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'FA779554-5D1E-43D5-BC6C-6ACD73F53E8E', N'5DA852AD-8375-43FE-93E3-53194F76BA7B', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-11-06 13:51:51.540' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'9B4A753A-9298-4C8A-9983-C0616C5B8C47', N'E3E6E572-2CDD-4077-9164-CFF274BAB507', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'3CB27A8F-5DCE-4DAB-9CE0-19EA09D4C570', N'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'550008C1-28A0-4105-AA06-ED07140D2883', N'D5C91A1A-D04B-4FF5-92F8-CF6AF30C9BEE', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)				
			,(N'18044A10-1EE6-4AF7-AA4B-7603400A77C9', N'DF6FC91A-BDCE-4577-8660-58A5F21F9C70', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'B578AEE4-6428-4434-9838-2F8B94CB4257', N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'6489E03C-33BB-406D-A787-01B28B22B334', N'C694C3B9-9872-4449-974F-CFC319840186', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'F1F67598-9F4C-44B4-955D-55DC123A1AAA', N'4ACAA8AC-DE32-4D33-9F96-9DF5E1ABDEA9', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'34662DCD-3867-4D4F-9D21-6745762895B0', N'1E853726-8E02-43DA-A2A1-A0A4D702DFFC', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'72CCC5A0-75AF-421C-B088-7A88AFCFC455', N'FB013D44-4B00-4F0B-B122-02389E44AEB7', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)

        	,(N'B2B5AE4D-0D2A-49D4-BEFA-0CA458F11FA2',N'C3952AAF-4448-4DEA-8C84-C28FCD822364',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'BBB1BB76-C92B-4F95-8F2D-566105C49C6F',N'21C33A76-B4BE-48D2-8965-D84F5B94DAB8',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'DB8BB97F-9035-4114-90B5-B3391F157DC9', N'1191C5D3-66F1-419D-9F72-9532B8B4675E', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'0E742F16-DFF1-47EF-ADFB-58EEEB14A2E7', N'679C1903-999A-4CDA-8880-75E4CED26727', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)		
        	,(N'59A4C0A0-8B3D-4294-878D-5C9AB3A7123D', N'B424B603-1997-4E6F-8E32-82AD90097950', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)		
        	,(N'4C95B5C1-E0FD-4F11-A1A7-01DC1726D09A', N'5EEF57B0-050C-4B2D-AFBD-B70F10DEA233', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'B30781FA-2257-427F-B225-5E820D773653', N'31CC4268-9C82-4CEB-912B-B00D6D5CE89A', N'3C10C01F-C571-496C-B7AF-2BEDD36838B5', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'79C76004-5A50-4157-9EA0-9DFAC594378E', N'159E546D-CC90-4DA4-A470-362A1B2477E8', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)		
        	,(N'404248F0-75CE-4D5C-AB54-767C5E958537', N'7B7129F0-BFCE-4D84-AE0C-56F5EB2148C3', N'A17DF4B9-7B27-4272-B545-A38BEB761CE4', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
        	(N'd3261ec0-caa2-464c-b454-441b739e3a25', N'cde6b924-bc12-4ea3-821e-455fff6d2c65', N'A17DF4B9-7B27-4272-B545-A38BEB761CE4', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'E7BD1958-6454-45A4-8FEF-BAC97B45DB09',N'E202F210-5592-4881-9534-9B90D9582058',N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB',CAST(N'2019-12-31T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
        	,(N'621289CF-49F2-426E-AFCA-33D8F3AFD31C',N'814BCE6B-8162-425F-8222-64E802DE881E',N'573EC90C-3A0B-4ED8-A744-978F3A16CBE5',CAST(N'2019-12-31T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL),

			--payroll management
				(N'4A07D070-07D9-4B94-BE20-407D2F0D9FC6', N'642D9BD8-610A-426E-86D2-AC66706D7B00', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'26349BFA-A8AF-4879-A19A-072F385083FF', N'BEF56867-343C-485F-989D-9B157AAFED2F', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'B4490207-57F0-4D61-8DC3-4DE7CBBF1E5E', N'40F9CFEC-717E-4091-837F-DCB1219326A1', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'5A777F6D-57B8-40C6-BDE8-96098C372F63', N'6CC68DAB-3E6A-4F98-A4B1-72B3D72E7916', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'AB70DC44-3C58-44FD-9B9B-8C08741B2C11', N'61312A34-7556-4A1E-9FEF-DFB2B592B7FF', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'58805D18-7F99-4235-81F1-33A3A4CF0722', N'8A856A6D-F5F3-4207-9390-BBDE1E991983', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'8223ECD0-4514-4449-9998-75B7B8CC7243', N'E65F528C-2B37-4462-B393-84C597ADC571', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'edc92ca9-5947-4a08-b3f3-c613dd5e8de7', N'BC3EF1A5-4906-4006-B28C-09631A3411BA', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'04b38a9a-f1e8-4aa5-a2ac-eadd1b8c40e2', N'7E271B24-EED5-4E58-BB1D-2628C7EF61FF', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'f85c0c0d-7b4d-4700-8e20-66bf81939690', N'25391559-1629-4772-BB51-E94A834C1774', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'22fd78e4-fa8e-4c02-a79d-b67d493983b6', N'7121765F-5B22-4FBC-9975-E6BD1B66F21D', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'48F4EAB9-F00F-4270-89AE-A965F42A0BA5', N'B50D9A50-06CB-4D9B-8227-617CDAF016FD', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'4E5A4F37-9634-48B6-A16F-4BA37B232835', N'63191182-2313-486D-BE32-4513D814F24E', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'F99B92C9-780B-4AF0-B602-5F2EA2DE1764', N'973B4192-D284-4EE6-AF7F-E714247A4CEC', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'65E7CF55-C19E-4302-996C-0A9AE85F8BA4', N'82E88771-B74E-46C2-AFE9-CDCB10D653B0', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'B258572A-14E0-45A4-935C-1E42FB81FA26', N'B2BEE500-1AA1-43C6-8C3F-637809C326EC', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'F06472CE-AD2B-445F-8AA7-26BD6C582B4C', N'495B187C-C8E4-4D48-83D5-209D90E2B1CC', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'E45BB292-9AED-4765-BC99-2436BD9362BC', N'D3A115A2-6E15-4CE5-8F52-6FFEE145FEA6', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'06E8D679-CB5E-4F4A-999A-03FED84DCFC8', N'BEE9D8FD-BC11-49ED-915F-E5F554A3C66D', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'1A415D19-9353-4027-9B94-BE7863553754', N'886D492F-D091-452B-88FE-CA4B13DBFF2A', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'666ACC3D-6B99-4DF1-ACA9-14A8448C6D48', N'4542DE20-63BE-4CF3-BEFB-3D040897BC24', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'2066EB3A-A3E1-4925-8315-91B3BE757B4A', N'BEF333FC-7839-4CF9-AACE-16597EA48E86', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'FEA41AB7-5C69-4C85-AED9-7FC8A3260C38', N'642D9BD8-610A-426E-86D2-AC66706D7B00', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'AAEFCDB2-C585-415B-A965-3B030AF1991F', N'1CBAE3D3-D06C-42C7-BC67-3A7E1D6A5883', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'15906178-C74D-4F5C-9FA3-026BAADF10A0', N'FBC1FD87-EBE4-4181-AF08-E2DAE768C8E9', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'C80840C5-D460-4544-8B49-D8EEA243904B', N'86D8CAC3-3953-4FCB-955D-1129E9F8CF60', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'8C9A8B87-69D2-4D2A-9273-81B4BB444623', N'DC499C59-A9A0-4DC3-A179-64128E994AC4', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'037163D5-E8D6-42BF-AD14-733881C6307E', N'47813006-C1BA-4F74-AB00-621CC82828AC', N'F353078E-A359-43B3-AC89-489DB438EE07', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'81D61282-AFCF-4790-BC50-EB3EA5178E5D', N'AF7A7997-4CE2-41B8-813D-9AE6DF46797E', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'339285E1-46DA-470A-A5DF-E2484FDAFEA7', N'656502D8-3898-4451-8609-5F9BBCF23463', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'EF4D933C-8EBE-4656-9D4A-8670024F2068', N'3631B1E9-B9CA-4CE4-B33B-3DDBA2B2459E', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
        	,(N'2081098E-EAF2-4335-ACE5-FA7095F253E6', N'C1FB7F26-C9F3-42C7-8ADE-2848B7597F97', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-09-17 11:15:10.843' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'548374EF-9ADC-417F-A14F-13E7477E36CE', N'09900C86-081A-4584-8237-0DB406A6D7BA', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			--custom fields
		    ,(N'51d44629-37bc-401d-b95c-9a8edc1d8707', N'63051871-d91b-43d1-8c5b-3f1b85f12a64', N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		    ,(N'85d10a28-d6df-4895-b8e1-855f208028d5', N'd36e5e73-0491-410e-a850-76dcbe5da0d1', N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		    ,(N'4b9ac55c-7812-4b6c-8936-f5cbe4ac3943', N'd7a843d5-4e31-4e82-aea5-e77b22e24613', N'3ff89b1f-9856-477d-af3c-40cf20d552fc',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		    ,(N'22d87fcf-bcbf-4580-9485-4176f4f83ffb', N'74fbafbc-fd1f-4dc7-9fa0-3c459412f31d', N'3ff89b1f-9856-477d-af3c-40cf20d552fc',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		    ,(N'29D43A5B-0354-4538-9819-355FD59F7C4C', N'33755276-74C6-4253-AA05-A713B28B9FB2', N'3926f534-ede8-4c47-8a44-bfdd2b7f76db',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		    ,(N'AD68B31E-E3E0-4CD2-A6F7-291274DCE389', N'494B94A6-9AD5-44AE-A1C5-477059D4F675', N'3ff89b1f-9856-477d-af3c-40cf20d552fc',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			--roster
			,(N'F1426F78-21A5-4815-BD61-19EDA9E4784E', N'A2BF7CDA-EF3B-49D6-B1E4-C786CE15BB9B', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'19BEB6EC-9984-4BAF-9384-46F8C5FB509A', N'F14A8B90-C070-4117-A932-1EEBCEC05978', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'EE5B10CB-DC8B-419C-A3A1-DBF260BBE239', N'0392812F-4B3E-4166-A601-04D58FE4EA5D', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC',CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'19016018-362E-47A4-9168-80A4317A098F', N'1F913475-F189-4329-9ABB-61D1801F257D', N'D8535273-0E2F-4A34-ADAF-B8DA48A4F90E', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'CE5F9136-BFED-4360-BEF9-09445EEB0A9E', N'EACD1105-3B6F-48B9-A8CA-140592482A8F', N'D8535273-0E2F-4A34-ADAF-B8DA48A4F90E', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'1ED1D830-7EE7-421F-BBB0-93AE454A0ACE', N'F0D5BA0D-464F-4019-849C-C27E4681BD78', N'D8535273-0E2F-4A34-ADAF-B8DA48A4F90E', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'0AA284C1-A8F6-4E82-BB86-3F4F713EA334', N'5A221595-8A31-47EA-A830-84267C3A5E7E', N'D8535273-0E2F-4A34-ADAF-B8DA48A4F90E', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'12B302FE-3757-4B5F-A3A0-E17CC9250B0D', N'FEBDDCA7-8581-4701-B80D-D77CB603F30F', N'D8535273-0E2F-4A34-ADAF-B8DA48A4F90E', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)

			--badges

			,(N'8C25B73C-AB61-4F40-9ECD-7D48DDFC674E', N'B9DFC655-C29C-4E04-8731-9B0E6E197C56', N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2019-03-11T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
			,(N'347131A3-9FA7-47D8-8B28-F8696824EB43', N'F829742D-BA2D-4194-8EF0-67DEC1470310', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'413415B9-C5DB-4302-A7A8-A902803B7F2D', N'951FF220-922A-4CCB-9971-07E64376DD2E', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'ADEA4D1C-CB13-430A-98D9-FD9D511B7E33', N'FF9D085A-3931-49A8-9DAE-A543BA6AA381', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'E1E2CE8E-BB95-4A77-80DF-2A07CF123CD9', N'78635301-7668-4B60-9D3E-5D8C1C160C55', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'13D110CB-F351-4209-A2C2-CC8AEF6EC5D3', N'22491EAE-8323-4B0B-9FB4-900FE6FA0BE4', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'14225600-8153-414E-9A46-31E35639CB96', N'6A0731F7-BCA3-44CD-998B-5743267FB789', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
				
			,(N'A085B01B-5219-410E-8266-DBD507CE2104', N'A70176B7-768B-4CA0-B31D-3BE7378AC6B7', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'4B7069FC-9885-4FB9-9D2A-EEA72B6AF175', N'C3DE241D-F502-4D86-9B89-DFCDC3DF6ED5', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'E35FB031-6D81-4663-A8DE-F1D45E4DF04C', N'5040A778-B439-4C29-8C46-E8C5D34C3414', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'29CE7D07-A635-48CE-BDB6-5530F97CF33A', N'5E34726C-6368-49D0-88D8-7E4F4E7D0161', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'C73FB599-369F-48EF-B836-CC77CDD03A2F', N'5CE961F7-32D2-4C38-9781-38353C120644', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)

				,(N'FFB1CE7A-B14C-4525-9AD4-7FAD5594A178', N'0C94E4A7-5F29-49E8-9611-3FBB1CFBDA19', N'3BFBDDBE-1FFE-4AB1-AFF0-EE4C692B713F', CAST(N'2020-04-08T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'28B25487-4F55-4DDD-B493-E81AAC170E11', N'76dd0670-0b77-4e5c-92d5-7b9a41da34a7', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)

            --Audit management
			,(N'570177D3-0429-4AA8-BFFE-254E1E2B2E51', N'02CCA450-E08F-4871-9DA0-E6DA4285C382', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'E69B00FD-98BA-48BC-9008-FDE6995F19C9', N'DB1620F0-2996-4635-A56B-6D2B6C7B47D2', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'655396BE-EEF9-4F57-B3EC-7582FF579EF1', N'47380C9D-2EC7-4106-8AEE-8C14A1A7FFFA', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'358F6503-D425-4830-9B5A-61FE686037B9', N'E019ECCC-E398-40DC-A95C-EC0F3771C258', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'2C659A4B-B0D3-4EBC-934B-883CD99DFB57', N'DD4B5A49-9594-4106-9954-995C095F5D7D', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			--,(N'2A5B5CF7-E965-4991-99F6-5020BD5E053A', N'7EEE0735-9D75-49D9-88FE-710B2B466107', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'27AAFE0E-CC19-4582-84ED-2A31CE120FB3', N'286D2D57-0E8A-4B6F-9F7D-B3518BE4C7E7', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'8A4B1261-A8CB-4896-BA18-B1BECA419471', N'8D791593-1F3B-4789-A141-762B32B43218', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'CEE73B79-8496-45C2-BAB4-8A4EE5D28CD8', N'98D0109C-88BE-4F7E-AF71-395E64F78D36', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'34D49C68-C2A5-42EB-83DC-BD0F94A19537', N'9766BAEA-2FA5-4ACA-939F-DBA85F4E1058', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'7397027A-62A6-4706-A93A-30CCC93AC21C', N'BA2464BF-C6F9-4B3B-995E-F7833FEA70B0', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'A16F0E48-3DFD-4517-BE0B-57F4551BBDF9', N'7FA4281E-9EC9-4AEA-BF8A-A7D613F019EA', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'F176B35B-9E3B-43F5-A972-64ACFBB44716', N'049CFA7D-BC33-45B6-BB38-F94479A51CA2', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'AD021A52-B8F7-4AF0-B55C-8D6548C45D2A', N'A3B9B81A-109B-445D-9AEA-6B8A2B71C884', N'F353078E-A359-43B3-AC89-489DB438EE07', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'203D2F65-4B8E-4D1A-8982-F776EECCCF7B', N'C0621DE0-2F3F-44FC-9D02-E46597EFE300', N'9C9684AD-E2C2-485C-A66C-B6D388337BD5', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL)

            --training management
            ,(N'78EB9F68-47D2-49DF-B35D-F0F6053FD85B', N'D6418CAB-48C7-491D-B1DF-F9A30CBEBD46', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-05-29T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'06F60B90-3255-4775-BED2-C04CBF66269A', N'7BDFD84F-2416-47B4-BE9E-0E16F2617EA6', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-05-29T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'8DAFB85D-EFDA-4A6A-AAC4-E23CC93FBA8B', N'60D74B68-47D9-4D4E-A624-C59910283289', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-06-01T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'459A30BA-7DE3-4916-BD82-1E9D0C3B5AFF', N'F2CB1EF2-D544-4491-9026-148F53FD404B', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-06-02T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'6713780A-C4AC-4648-81F2-5770BE1B677C', N'9A5E3E71-AB44-4145-A6C3-912A0B0F6FCC', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-06-03T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'FB75F35E-0DC6-4F8E-9426-7F95A09FCEBE', N'F59F9F21-5833-409E-9861-717C7C013806', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-06-04T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'EBF830EA-9F9D-4748-91AC-E7CA5058AC17', N'3515DD83-E79D-484D-ACDB-29809881107B', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-06-05T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'BB90E80B-EB99-4461-BCF7-C5A6FA06639E', N'86939EFF-6229-469B-AC9F-9C91FE5B1EDA', N'5CF2D2BA-1008-423A-B312-9C75979A1672', CAST(N'2020-04-08T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'96FBB965-CACA-4952-AB0B-5ABE80639719', N'67058FD4-7264-4ECB-8E0B-4CEE0E4380CB', N'5CF2D2BA-1008-423A-B312-9C75979A1672', CAST(N'2019-03-11T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'BE36F953-C929-4973-A63D-453DE97C300A', N'92CE56F9-26FF-4E9C-A974-CF9F0490D4A6', N'F353078E-A359-43B3-AC89-489DB438EE07', CAST(N'2019-04-17 12:32:41.200' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'62E688E1-8285-4317-9F04-241F1DFC504D', N'CFD444ED-0FB8-46CA-81D0-829A2C51CAC4', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'BC60F5EB-929A-42E2-A97D-15167A23D747', N'8E7CAC53-4831-40B7-AB4C-3F4F8F084751', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'0F9CBA86-EE27-49DD-A3CE-249ADE29B142', N'B65C336F-5739-484B-A6BE-0DDB9825E8D6', N'3ff89b1f-9856-477d-af3c-40cf20d552fc',CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)

			,(N'E69A7ED3-2947-486C-A6B7-7BC00341774A', N'F915CD54-9E07-4E23-BB2C-89AB326B8335', N'ABC7458E-3C13-4056-85A3-75F0B61A5320',CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'C5C3C067-1538-406E-9FB5-8FB6C67B57DE', N'6C3C7DAF-4DFE-4EC6-A37F-3EDD607B43C3', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB',CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        
			,(N'DC9944A1-F54A-4867-88BC-F04461F646C2', N'C18522C7-81F5-460E-93C6-E830F5848869', N'4EE851A4-0572-4101-989D-25026A3DEDF4',CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'40EDDB2F-131F-42BB-90AA-9FA8E9008C3F', N'D61A12E0-1902-44AD-9DB9-2E8CE155947A', N'F353078E-A359-43B3-AC89-489DB438EE07',CAST(N'2020-06-09T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
		
			,(N'44222FBA-2130-4049-B38A-75559C598AD5',N'38CED01C-DB50-4999-ABC3-EAE960DD51DB',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2020-10-05T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
			,(N'178E94C9-D1B6-4B86-B016-DCAC14F18480',N'2B447F3A-8022-43A7-B145-731D5F6678F6',N'991FA5E4-D85B-4F1C-9970-33625164327A',CAST(N'2020-10-05T10:48:51.907' AS DateTime),@DefaultUserId,NULL,NULL)
			,(N'0768028F-469B-46E6-BBB2-DF96B824594C', N'2255D42A-9F95-453A-9FD8-A10CCE9909D1', N'E23D114E-86E8-4883-B104-C7C6679745B1',CAST(N'2020-09-28T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'E15C851E-B036-4F8A-A07D-BAF90ACF623F', N'D5767665-D117-44A8-B5D1-375363B1FD68', N'E23D114E-86E8-4883-B104-C7C6679745B1',CAST(N'2020-09-28T00:00:00.000' AS DateTime), @DefaultUserId, NULL, NULL)
        
            --Business Unit
            ,(N'68BD3BE0-0FB3-4AFF-BA68-78B0F07E64C4', N'6C966874-025C-465B-9D9E-C69546DC58D9', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'65C4BCE0-708F-462E-9DFE-4D7CA4B40550', N'E467AA34-60DD-4821-95DF-989DB2E1B7B1', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'C2129636-3E2E-4A89-8930-45DC2A350BAF', N'83D2EE67-0359-44DF-A1D3-9B9CE3F4F4EC', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'3B1224F3-D6FB-4115-82AE-E2846435C066', N'EE98BB8F-E5A6-40B8-A3C4-49AA57CC0061', N'94410E90-BC12-4A39-BCA4-57576761F6CB', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'06302BCA-37C8-42A2-B430-DF6CDD0B597A', N'6C966874-025C-465B-9D9E-C69546DC58D9', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'9C948861-E4A4-47FB-89EF-C16D67F892E1', N'E467AA34-60DD-4821-95DF-989DB2E1B7B1', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'A395D6F1-C7EC-4025-853C-DD5B993B3B51', N'83D2EE67-0359-44DF-A1D3-9B9CE3F4F4EC', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'3E628B23-EDE4-48B2-94F0-356CB4370786', N'EE98BB8F-E5A6-40B8-A3C4-49AA57CC0061', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)

	        ,(N'62BE302D-7354-4D1F-9575-6A7E7A7F0219', N'8B154265-6F3D-4222-BF8F-89A6BBB3AD29', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'BCDAA82C-61F1-4B28-BF23-C7F105417CBD', N'6098A309-B0CB-4A22-A586-7B1D743DFCB1', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'60D16510-86ED-4B01-9722-FCC6E2F7A792', N'7E498DC2-F0A4-4DA4-A457-6741EADE5A33', N'5205492C-EB9A-4B52-BBB8-4377501930A2', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'816B16F4-532F-446F-8C1A-7489B81A18A5', N'25FC903D-3D8B-4DE3-8514-E5BED581F866', N'5205492C-EB9A-4B52-BBB8-4377501930A2', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'EDC66F70-0D40-455B-8ABF-51E9E11D3568', N'48BD5E94-1E22-423D-98E4-BDA63427D0E5', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'1792B50D-61D3-41B1-874F-AF0CB97F8014', N'AB8838C6-14A1-499E-BA0C-79B39904D2B4', N'26B9D4A9-5AC7-47D0-AB1F-0D6AAA9EC904', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)

	        ,(N'557622D4-480C-409C-896C-F853AC8B0B7E', N'47DA5B02-11CC-4B83-B20A-78C08DDCDE2E', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
	        ,(N'180AA632-C46D-43A5-8026-53B3E4D63303', N'D3C8C1AD-7DE2-42A9-A67C-54E4DAF075E2', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2020-11-10 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
				
            ,(N'704C6D4D-6D1D-41AA-B5A0-D8D7CF5F51DB', N'A33C61F3-9C23-4BC4-8A74-6516D60D4C08', N'4EE851A4-0572-4101-989D-25026A3DEDF4', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)		
				
	        ,(N'2A3B254D-89E5-4972-869D-DB5A07F47747', N'5BA15ECB-2A87-43F8-8FE8-A554D41C848A', N'317FA168-F501-444C-B1C5-14C598DC18F3', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)		
	        ,(N'D2BFDD14-ECDC-47EF-9281-505F8FC846F7', N'A8FD1565-9563-4C44-B07D-410685297523', N'317FA168-F501-444C-B1C5-14C598DC18F3', CAST(N'2019-12-31T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)		

	        ,(N'31433E74-A5DE-491C-96EF-A42F4716BF61', N'B13B316D-3725-41D2-9CFE-E556C97BA29D', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2021-01-19 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'17B5EE49-2AA7-4018-A368-0ED8AE0C62D5', N'C521DB70-B7C1-4751-B41A-CD6C5108E366', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'E6FC17BA-C5A6-466C-BF37-A4D4362D30F5', N'0AA22480-9E86-4254-82CE-64E530E6A8BB', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'EBA8588D-9B89-41F0-9743-024C99E758DD', N'B921C1DE-3B10-4D33-B538-578DC1D99BCC', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'468A7765-CE4B-436D-AE9D-218A39D93D16', N'552395B3-AEB2-41C2-A07F-89B27B1DF8B4', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		    ,(N'C4A3CB74-2F62-45CE-874D-9649FB3AB3F0', N'F371622B-3CEC-46D0-AE2D-99349C1B0098', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'927061E6-4C5D-4B58-956A-F7B79BB60492', N'57AE5D56-B002-4A69-9FB9-2C01E3589130', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'2E612545-80BF-4247-849E-52F7FB559EBD', N'DC0E9E15-1203-4506-8E2F-E6ABE88DAC00', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-20T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'D6A9E85D-AD8B-4383-8892-8CA38A9E152A','9E9EF19F-76C6-40C5-A5E1-09EA5A3F79BA',N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'4960188E-114D-4EBA-8C94-14717AF99D79','6D92E5D6-EC20-4DFE-81DC-FA0CE8065127',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'E95475D2-0982-41A4-8E52-F26A7EF3EA31','3E0071E1-6E5D-4596-8436-161A28B45BE2',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'43742110-9578-4BFA-81D2-2B457D20D8EC','6F4BDCDC-0C35-4E93-BA29-F3028E27CBD2',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'1A6405A6-94EF-47BA-A10D-37301FA3E495','5661A6BD-01CE-441F-9FD8-42BD7B64E06E',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'BD34E8AD-1482-4534-8D2F-909DF902438A','562FA0CA-B2F8-4409-8DAE-9FAE4452D8F8',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'A01BB3BC-930B-44C1-A450-7B6360CD3050','C29A9771-221F-4735-8F94-8CEBCB166B29',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'4DADBE22-1F17-4E46-A981-EB70541981CF','9118FCEE-C6C6-456A-A985-D87C971FC59F',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'FD39F1EC-7A33-49BB-98E0-7F94592887DB','625ADDB4-955D-4765-B598-9A062CFF8C3C',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'14A21787-B806-4FE3-8413-6CBAE456F949','96EADE43-EDAC-4775-BB75-861670E75EB3',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'D47B3101-D641-4E9C-96E2-7EDE79EF52F8','BFC7E7FC-D279-4A7E-86C5-668ED8EBA996',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'550E1D87-3EC9-46FB-A57F-351CD5194F0E','9740C489-A3F3-4065-8748-07A42759D159',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'C0DF8753-B43E-4D95-92B5-736D9A0382BB','51AFE938-42A3-4751-8A9C-5EBDB00F3713',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'FD3E834B-ED2E-4763-A9F9-57A31E911D4D','0DB33301-CA08-4816-A828-2BB0E4DECE99',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'B0B235B0-2072-4E97-888F-2CC807A63DD2','FA8279C1-4AE8-4F73-B0E9-28F338D82BDC',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'AADD0DC6-8FE3-4416-B8F9-12DD87E212D0','86C43591-3484-46FE-ADA2-390BB74FA2DE',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'D893180B-EF1F-4524-94BC-64711A79CFEE','886C95D6-541C-47E9-859E-0E37665ED818',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'BDC5748F-C2EC-4A65-9D55-B6B833BCC1FA','552AF980-1F38-47E3-9614-50B7030C31C1',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'73711496-E82D-40F1-AB88-601EE4E1CF06','C23ED0F6-9569-429B-8B59-1D5979EAA3AE',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'77365EA8-104A-4AA7-8FDA-732C607C6C5D','4B53DE09-5A6D-4556-8C85-AEC44CE00E9F',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'B3D48E55-7241-4297-A22B-05F256C1F6A2','B98A20A9-46B6-4E5C-8109-3E8F01F0B71A',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'CF908AE2-FFF0-48EE-8E71-3C1D04EF693F','662DDC92-7F9B-41B0-814C-72423D6033C9',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'F39859F6-274E-4910-A018-AC616AF59D26','2FEA469E-93C0-48E2-B27B-382895A4F782',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'E6A4A457-BFE5-4D0C-A710-7931EE8D33E9','81FF012E-B1C9-44BD-9B41-D39879B39A48',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'CB46A7DD-8AEB-48DD-ABBB-885A57B3E0E9','6437C206-EDBE-48F2-B525-E71DD4B73460',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
            ,(N'68683E14-7CF2-4ADC-BEC8-45389D524563','B07A30B6-1067-4A5E-B913-76F1177BE357',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)

			,(N'095046C0-09D4-4760-9067-C57D32B71CEB','5F1BFEFA-F657-41D0-81FA-0F4C1AD069E1',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'EB7ADA21-2704-45BA-B9E9-E761B052A0E3','4FF9DD26-6466-402B-9B24-3217830E087F',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
			,(N'BD2F09CE-D788-4D0C-B75B-9304F69A18C8','5ABBF5BD-0B94-410E-BA08-C8B364643F06',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
	)
    AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [FeatureId] = Source.[FeatureId],
        	    [ModuleId] = Source.[ModuleId],
        	    [CreatedDateTime] = Source.[CreatedDateTime],
        		[CreatedByUserId] = Source.[CreatedByUserId],
        		[UpdatedDateTime] = Source.[UpdatedDateTime],
        		[UpdatedByUserId] = Source.[UpdatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
    VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[FeatureModule] AS Target 
	USING ( VALUES 
		(N'0D530391-DECD-4BFD-A44B-A7461E189098', N'6AAEC58E-DE60-4ED4-A923-65644D76A7C2', N'F353078E-A359-43B3-AC89-489DB438EE07', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	) 
	AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureId] = Source.[FeatureId],
			    [ModuleId] = Source.[ModuleId],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);

	MERGE INTO [dbo].[FeatureModule] AS Target 
	USING ( VALUES 
			(N'25B27925-0BAD-4F4E-8E99-F98E39232BA9', '94C74250-5D25-4973-909E-51C280AD09C6', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'678EA67A-92AD-46E3-8FB9-62F66526022C', 'E6F4C002-AB0D-435C-A044-2F9527155F50', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'8C52F0EC-31B8-47BF-B2BE-5DC393474288', '1EA77455-1ECA-4D7D-A75B-86FF45B3555E', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'39903365-9BB8-4191-94F3-6DBDE7FAA1C1', 'CB1BBDB1-6E69-4913-9329-B08CF4AA407E', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'AC799FB9-FA1C-479C-8560-CA3FDDE77FF1', 'CDB3341D-78A1-43F5-989B-C4C7DF8133CA', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'8D1298CF-99AA-4EDE-989D-F90B0A5F74BF', '2255D42A-9F95-453A-9FD8-A10CCE9909D1', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'8850889C-A20D-45B5-B71C-CF4090ACF80B', 'D5767665-D117-44A8-B5D1-375363B1FD68', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	) 
	AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureId] = Source.[FeatureId],
			    [ModuleId] = Source.[ModuleId],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[FeatureModule] AS Target 
	USING ( VALUES 
		(N'6055D37C-B3C2-4565-AD52-04D83CAA454A', N'40AC6FAE-794D-47E9-B968-1B7E175EE93B', N'3FF89B1F-9856-477D-AF3C-40CF20D552FC', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	) 
	AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureId] = Source.[FeatureId],
			    [ModuleId] = Source.[ModuleId],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[FeatureModule] AS Target 
	USING ( VALUES 
		(N'726FF590-1C76-48A0-BAED-B17EF7590872', N'D0AE20C9-BF9C-4389-8904-E9557D7B498F', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		) 
	AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureId] = Source.[FeatureId],
				[ModuleId] = Source.[ModuleId],
				[CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[FeatureModule] AS Target 
	USING ( VALUES 
		(N'54376F79-CDB1-4B7C-B385-49042B106967', N'3216B685-9281-4D49-A9F1-B3694584CDA8', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'D5F98D98-45B5-48E3-B16A-CC4864C0DD15', N'69A7C9F7-FB0A-4A79-A583-501EF98FEB52', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'72B01426-4DAB-4DCA-BCB5-7C5FAAE741DD', N'BC7608B8-DB69-45CA-9EDA-D58B2C53AD31', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'E25AAFB9-F118-4AF0-AADB-33757EA5BFB6', N'C78F8D41-A5BD-49FC-B8E3-6E3B59AC9034', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'161D9947-5801-4616-9471-334B4B73BE47', N'85540515-9519-4D84-AA23-0DCF4C7815A0', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'3E03C168-9098-49B0-8906-150E65BF53CE', N'1FF6899E-C2C0-44BE-B21B-76BC70AD4C36', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'C2455896-9299-4799-A541-2F194E293921', N'8C60C33E-1FE7-4483-8BCC-971CA2935008', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'A34FFD03-573B-481B-9A3B-BB1137F01325', N'D234DE9D-3698-4A62-BA41-0A93FAE75F33', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'4809A85F-0103-4985-9977-32D29D346F6A', N'09BA0A39-D73B-4438-A4B7-B0BA911878BF', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'A46DE8DB-EC9B-4188-8877-3C9F1F07B553', N'7ADEDC2F-5ACF-4460-8853-A46D3E3734ED', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'BC1BEDE3-E114-49DF-A4FA-E57310BDE030', N'6F4E9038-A24C-4D14-B36E-5853200CCA70', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'9CFDDFEC-3D29-4508-B31F-13E4146D746C', N'CE38473E-5C96-42C6-AA42-6EEDE76553C4', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'79EBD8DF-3DA0-4852-A8F5-0191FDBEA974', N'C8F7B712-F3DD-499B-9E36-87BC182DB66C', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'1567509A-0999-4BAE-B6D8-6DDEB47A75B8', N'D6AB31F1-77EA-42E6-AF88-3FB810E6028A', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'5400E61C-98D7-4085-9DC5-A1F27EAB5B36', N'50AE7EC0-CD77-464D-9739-29857771F778', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'B7EB8317-9B01-4994-A0DF-5F4DC103658B', N'511B1B19-0213-4543-8A54-658B7109C257', N'A3F36A17-53E1-4CB4-BF71-668FCDBB683A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	) 
	AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureId] = Source.[FeatureId],
			    [ModuleId] = Source.[ModuleId],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[FeatureModule] AS Target 
	USING ( VALUES 
		(N'36E0EF56-D596-4F92-B4EC-0752E5DC430D', N'E50D0E15-8A69-488B-9391-27659FA2AB4A', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'AA4821A1-EE63-4490-AD93-D76DCE5B1409', N'83B1EF70-F371-42AF-A8C5-A1632033D4B7', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'A22103BE-CC8D-4D84-BC93-8000B46B1437', N'7CD55073-755E-4126-A4B7-E880BA223AC3', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'2AB3CB97-55D4-48F5-B04D-1F81C9C8A5F7', N'3B2AFE42-A447-454D-8873-C42E218FBFFD', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'5A185E12-C0F2-45C1-83E2-AAD480468BEE', N'2DDDBEBA-63F7-423D-B522-1181B5782DDE', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'25068A73-2AD8-4CD7-B170-25A4E9C2D00E', N'8AF0BA30-3BB3-4C0B-9450-43E05D5FBD59', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'942491EA-9F77-4D38-884A-BFEE89897B85', N'7E12ED2E-0A76-450F-95DF-16EB35A3EA23', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'F74846B6-F829-41F2-A30A-1DC299828229', N'D9FDF976-5055-42CA-87F6-644EA5BF1F2E', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'629A6A34-3DBE-46FB-B692-4FBC2A6B09B3', N'513B41A3-BA1A-4A5C-94B9-1FAEDCBCE6DD', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'ACB55A43-B9FA-4942-BF3B-A7668E97B0B7', N'7A11C52B-30C2-4923-977C-3C4D0F87A4CC', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'CAF44A07-6EEE-419A-8D0E-1B992C8E8275', N'2CCA224D-9693-450A-B47B-7B1142350A07', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'118454C2-CEF8-4A2E-8C16-18C63E8DA438', N'12E01F5C-3064-415A-BE33-EAB6DE261F8C', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'D4105F00-DA23-4CEE-8277-23845721107B', N'3C0C75B9-46D8-4AE4-8BB5-36A0721F27D6', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'245F65E1-BA11-46F7-A0C7-DB14E7373FC3', N'EB5AF322-1502-4F00-92B0-A2EADA7D08EA', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'4F78B59C-6444-4D0D-9DDF-19B2D6FD27C6', N'58822DB6-B5DF-4431-A851-45AF8D9AEC1E', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'DDF5C8F6-4851-45FF-B30B-EB134A9A3FFC', N'87ABB450-990F-4D24-94FC-739C1A664C7B', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'D9ECFE63-F904-413D-86AB-260DC4777A1B', N'7517DF07-DEEC-4329-B080-A3F3ABAC620D', N'991FA5E4-D85B-4F1C-9970-33625164327A', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'3192A51B-ECFD-4712-B217-29E1556F98A4', N'EB2770FE-58A1-42AA-B388-8B57A45B990A', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'5BAEE5F9-20A5-4498-868A-E9AD2A861391', N'82D718AA-3BD1-4180-BD9C-B3130D5C89B1', N'E22162E8-FC78-43F8-BFE1-DF94DA6B2303', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		) 
	AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureId] = Source.[FeatureId],
			    [ModuleId] = Source.[ModuleId],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[FeatureModule] AS Target 
	USING ( VALUES 
		(N'33A3AD2E-C4A8-4585-BF03-599E06748C21', N'5F3CF240-9329-44C5-A03A-BA83EC5F9D77', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'7014BAB6-B028-4A2F-A924-B282CFC2299C', N'D3F572E3-25D4-4C5C-A6D8-32A3CBBFC77C', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'41368497-3FD1-4993-BB4F-3D6B7E5A11C4', N'EEB5AD07-D04E-445C-9EDC-6E917E08D030', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'491F6B98-51ED-4E0C-A075-F5B612978E54', N'97EE1B04-044F-44D5-8D5A-707113512C5B', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'0EB013EA-DA8A-43B7-910C-2175C30CB9DA', N'8F8C51FA-D6C9-49CE-BA73-60FBF2CD77F9', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'D5CFB919-3520-484B-B49C-26261059C2AD', N'9DABF053-D39F-4FC9-88D1-3DAA1A46D2CD', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'641FF994-04E0-4FD5-A25A-131E82A4ADF7', N'C7D10B20-E2D7-41C2-9F95-048A33D974A1', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'8310ABB8-5CD4-4C59-B482-1F72E72600B6', N'1901D9EE-1A93-4535-835D-39DDDC82F454', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'F6060F2B-684D-43A2-B7B0-932FCAB7CD22', N'51A64097-7524-45E7-A2CF-E0E121F5B619', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'D8B81886-4D48-445A-B0DC-90C6BAB6D3B9', N'A14FB958-09F3-424E-8FB8-CB5B295C38FA', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'57668B32-6C8A-4C6E-B0E0-4FFE09F0CE57', N'807385CE-3516-4AF8-AF73-1102CA4258EE', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'CA9AC19D-DF33-45A5-BE9E-D7DB8F8B8232', N'FDE6F348-10C1-4DD3-A8E7-9373B9078D89', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'B68D509F-9FE3-45D2-AAA6-004E674B1288', N'C4570212-B4B9-4757-BA3F-C87A93F5EFBE', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'437816AD-1FEA-45F3-A57D-48E8E6AF4142', N'8CEF5444-63F9-4AF8-8EC3-D8F485F319E3', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'DE199DF4-3170-408B-9ABA-A51CDA411FCA', N'779592A3-6F1C-4AF0-806C-26B46B85CC76', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'109F5EE6-C809-4740-89F9-4C80548A3527', N'BE787980-CF4A-45C4-A79C-F422E145875C', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'F61670DA-BBA0-4823-8A49-DE1CE8B85595', N'F7518593-DAA7-49EB-A7BE-8726107AB58D', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'EB6AFF3B-9D88-48EB-A877-6D764C3A3BC8', N'2853548E-C0DC-45F0-A1FB-960A53CF7BA7', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		--,(N'08ED4C5C-F6A8-4557-8A4C-D8767E6C2C25', N'068F14E5-BA6B-4F19-9A88-7F8162710826', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'7BAC03AD-3FDB-435C-A341-58AE00F6A348', N'E31FF25D-84A2-41D1-87A8-0B3AF661AB38', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'B98DBA79-A05A-4282-B13A-246B1B7800AA', N'C0929BFE-96CE-4FF3-8DD9-FF63BEBFBEDE', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'3CE49269-73F8-4F2D-B5B4-898383466F96', N'306F884F-A47F-4531-AAA0-37353654D9D5', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'1392CDA2-1069-4CB8-A8C2-9173556745C1', N'C334FA0D-A0D3-4FE5-AD07-CA1A30B06BE2', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'D9191781-3130-4AEE-B81E-0F2605CCCC2F', N'0E15892A-0716-4833-8325-DEF5EDF98627', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'EC20311A-1686-4469-B52B-BF1339F742EA', N'052EF8CA-91D8-4DE6-99C3-1A13ACFBE8F2', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'6FAAA437-F210-4A8E-AA53-255D384B9931', N'75D0A775-3D68-4624-A6FA-A4C37F19A944', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'009F5EE6-C809-4740-89F9-4C80548A352B', N'152EF8CA-91D8-4DE6-99C3-1A13ACFBE8F3', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'2451ECCD-3739-41AB-9145-246679165931', N'48CD09C7-EDB0-4F98-989D-D50DC0C70084', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'21BDFD36-7755-457B-9A37-60C683AD0FAF', N'DF1A5AFE-F908-41F3-A034-6B3C525F71F0', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'31BDFD36-2755-457B-9A37-60C683AD0FAF', N'0B1A5AFE-F908-41F3-A034-6B3C525F71F0', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'CB10A696-A2FE-4DFD-A408-65938602F8CD', N'7AA105DD-6C7C-4878-B0EA-DDCC80D37C12', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'B681BB6C-26D4-4FD7-8418-6919685B27AD', N'FC458F87-4C8E-4EF4-A2E7-B2E499501CE8', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'EAACE6D4-C412-4E65-B7ED-61FCF896F147', N'C8D9C9F2-BFA4-4619-9F96-C3A7177947EF', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'5578473F-8169-4907-879B-169E2F131DCC', N'4B068355-DAFF-412C-A6B4-3133BEB75C6D', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'CFCA7AF5-D829-4A9E-8FFF-EC830AB0E166', N'A6D2EF4B-D73E-4437-B812-09E9C3B243DC', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'2FB321AE-20F2-4F3E-8A29-E90CD9026C6E', N'3862F720-C148-4649-A32D-97025811D35A', N'5A31FC4E-BA93-4BED-B914-E44A5176C673', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	
	) 
	AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureId] = Source.[FeatureId],
			    [ModuleId] = Source.[ModuleId],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


	MERGE INTO [dbo].[FeatureModule] AS Target 
	USING ( VALUES 
		(N'4B5BA80E-598A-465B-9E52-DD2DCCC081B9', N'7EBFBDB0-EE66-4A16-902E-18A62CD0E8C9', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL),
		(N'53659979-EB36-49C0-AF75-89F8B5CAC178', N'86762993-C543-43D1-9034-647B1095CA5A', N'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	) 
	AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureId] = Source.[FeatureId],
			    [ModuleId] = Source.[ModuleId],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);
    
     MERGE INTO [dbo].[Feature] AS Target 
		USING ( VALUES 
		 (N'3A490C51-AD08-411C-8BB2-22A37911EF41', N'Can cancel purchase contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'0CF3ECE6-46AD-43B4-9382-A086D959C81B', N'Can archive purchase contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'44DBF728-A7F9-4987-8FB5-D9B72EEACF85', N'Can add or edit purchase contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'C668C903-CFAC-4690-9047-41EE1A8B328C', N'Can view purchase contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'6CCE2D83-AE85-4A88-99E3-DB572BD60613', N'Can share purchase contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'E342925E-3BD9-4FAA-B887-CB5FB0B78B41', N'Approve or Reject purchase contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'E2C56CD2-2501-4710-97FA-76C4BD32CAE6', N'Generate purchase contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		--------
		,(N'EC5C7117-125D-4C85-8A2F-259D2FE9B3C8', N'Can cancel sales contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'0407A400-3F0F-4472-B9E0-F052F54D6756', N'Can archive sales contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'CAEA403F-DBC0-4F32-99DB-3D05F8599D01', N'Can add or edit sales contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'939050C7-11C5-4168-9EC0-024D7241C68E', N'Can view sales contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'855F3633-41FA-4FE9-85B7-9F1A28BFE60B', N'Can share sales contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'2A8B7810-070A-410D-8891-3AD071A65B74', N'Approve or Reject sales contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'E3E9A90D-73CA-4EC9-8ECB-7EC7E8925D19', N'Generate sales contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		------------
		,(N'76770F2F-A0E3-437B-8B92-F2B1F49B1C66', N'Can cancel vessel contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'2966A54F-45D1-4CD0-884C-6C50EE836AFF', N'Can add or edit vessel contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'DF1773EE-6D52-4C08-99F7-B59BD122516C', N'Can view vessel contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'80C7E3A2-87A6-494B-8C1C-F6A1B92075B1', N'Can share vessel contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		---------------
		,(N'AD389009-E3E7-4BC5-93AA-6B0E170B2064', N'Can add or edit linked contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'CE9D1676-2A1B-431C-B007-117F15621277', N'Can view linked contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'43E0ED0A-5D55-401D-9369-0ABB63B72629', N'Share execution steps', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'4D4FE201-F779-4F0A-BE1A-3818C61ED4B7', N'Approve or reject execution steps', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'1B35A190-8C7C-40DF-8DD0-18FF8B14AB80', N'Generate execution steps', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'43A74C0F-9CD7-4B57-8384-63F6651F89A9', N'View switch bl', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'CA6E492F-25B6-4E8F-ABFF-F68C75A36ACE', N'Add or Update switch bl', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		-------------
		,(N'928B7A9E-A27F-4204-A552-5D09A4BB9527', N'Can view invoicing queue', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'62BDBF9D-1427-4067-B23D-247182FAB0CF', N'Can view invoicing payables', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'A582F44E-0163-418B-80F7-259654CD9566', N'Manage invoicing payables status', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'18B05C99-DDD0-4E26-B94A-64593591E0D9', N'Can view invoicing receivables', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'8CA108A1-8CC6-407F-AD1C-4C051DB8AE3D', N'Can edit invoicing queue', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'FC10632E-E4B7-4AE0-B882-AAE323658E76', N'Can share invoicing queue', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
       -----------------
	    ,(N'AEC24CC9-B83F-4A1C-8692-814D43093606', N'Can view all purchase contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'DE1BD201-CE21-48EC-B2BC-43EC7C5CFB32', N'Can view all sales contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'40299F24-F6BF-488B-B86C-F4F651AC0910', N'Can view all vessel contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'6A7B22DF-D2D4-4893-AC3C-7CC8E901B0A1', N'Can view all invoice queues', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
	    ---------
		,(N'E7FA5A30-CCAE-40A4-AD9B-5DB3F2210EB9', N'Can add rfq', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'EFC4A660-C3E7-41A5-90BD-7E55B33A554C', N'Can view rfq', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'F4E3B0CA-87FB-4593-A649-49C5F447BA75', N'Can convert rfq to vessel contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'229547CA-A74A-4105-B168-6580D6CB1453', N'Share rfq', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'6BA90895-FC5A-440F-A7BB-1144212D066C', N'Can view all linked contracts', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'9F33DAC6-4EAE-46F2-9B41-687599366FB0', N'Manage invoicing receivables status', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)

        --------
	    ,(N'FA47825C-4296-45F1-81BF-34E446A79151', N'View purchase contract history', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'E6D29D19-A758-4CEB-9573-3D3095C30538', N'View sales contract history', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'ECB277DA-52B5-4AD4-84A1-FE8B2669274F', N'View invoice queue history', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
	    ,(N'0CFE6898-7FF2-432B-9AD5-8A7C2282D589', N'View vessel contract history', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'3DCF0C72-244C-4F49-87A8-BDFDE94FFA1D', N'Can Reupload file', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'218096C9-1D0F-4DF4-9F37-B9697C824793', N'Can Reinitiate step', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		,(N'23A7830E-5AE1-4916-930B-D0DE643413AA', N'Stamp Pdf', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
	)  AS Source ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [FeatureName] = Source.[FeatureName], 
			       [ParentFeatureId] = Source.[ParentFeatureId],
			       [IsActive] = Source.[IsActive],
			       [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId],
				   [UpdatedDateTime] = Source.[UpdatedDateTime],
				   [UpdatedByUserId] = Source.[UpdatedByUserId],
				   [MenuItemId] = Source.[MenuItemId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId])
		VALUES ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);
	
	 MERGE INTO [dbo].[FeatureModule] AS Target 
		USING ( VALUES 
			 (N'EB6B2CC7-0543-4524-8A0D-67FA484D8F53', N'3A490C51-AD08-411C-8BB2-22A37911EF41', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'6F915BCE-EA2B-4C21-AD11-10A3EA5C690C', N'0CF3ECE6-46AD-43B4-9382-A086D959C81B', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'591A4217-23C5-4356-ABF9-41CCF79488F4', N'44DBF728-A7F9-4987-8FB5-D9B72EEACF85', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'66DCC28E-5E3C-466D-9F0A-6E9BD80D42C6', N'C668C903-CFAC-4690-9047-41EE1A8B328C', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'FFB89D1E-FCE2-44C6-A4D0-04D865A9DF5E', N'6CCE2D83-AE85-4A88-99E3-DB572BD60613', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'CE852C12-80BA-4877-9AF8-6099C24069D8', N'EC5C7117-125D-4C85-8A2F-259D2FE9B3C8', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'9FE91C5A-6E3C-42A9-83DB-076ED9363C25', N'0407A400-3F0F-4472-B9E0-F052F54D6756', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'A6A8BD18-0812-4C58-AFD1-644ABEE9AE41', N'CAEA403F-DBC0-4F32-99DB-3D05F8599D01', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'E0E887EE-EA6C-45EE-9F20-17F980287952', N'939050C7-11C5-4168-9EC0-024D7241C68E', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'EBAF0404-9EAB-498A-9F89-8F3338D07D0C', N'855F3633-41FA-4FE9-85B7-9F1A28BFE60B', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'A4CF18E6-53B1-40AB-8A4C-F6594F78307C', N'76770F2F-A0E3-437B-8B92-F2B1F49B1C66', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'AFBFEFDB-D4A6-44A9-A095-3B2B1C890F2B', N'2966A54F-45D1-4CD0-884C-6C50EE836AFF', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'78F7B30B-4C1D-49AA-9A6A-EBDD850EEB9C', N'DF1773EE-6D52-4C08-99F7-B59BD122516C', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'783698A8-0A8E-4A24-95BA-6BA6E051127A', N'80C7E3A2-87A6-494B-8C1C-F6A1B92075B1', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'CB242636-5C26-407B-A57C-97FC985AA180', N'AD389009-E3E7-4BC5-93AA-6B0E170B2064', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'9066DD79-0832-4886-8AEB-65E83B73DCB1', N'CE9D1676-2A1B-431C-B007-117F15621277', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'EEDBEB50-9BA9-40ED-9291-E1E23F8B72E0', N'928B7A9E-A27F-4204-A552-5D09A4BB9527', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'0106E078-B517-4C32-AD5A-80BFB271A3B1', N'62BDBF9D-1427-4067-B23D-247182FAB0CF', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'360785A7-FCF3-49F3-B643-5FA7F28104EE', N'A582F44E-0163-418B-80F7-259654CD9566', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'65E71727-4A12-44FE-B330-2FCB3C5DF4FE', N'18B05C99-DDD0-4E26-B94A-64593591E0D9', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'A4DBB8FD-B939-40C6-BB42-DED22873BB9E', N'8CA108A1-8CC6-407F-AD1C-4C051DB8AE3D', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'9F6268E6-63D8-4F23-84C6-611B3D149F03', N'FC10632E-E4B7-4AE0-B882-AAE323658E76', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'CAA92B36-BF46-4FC7-A828-24B29A63176B', N'AEC24CC9-B83F-4A1C-8692-814D43093606', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'BEB8FE10-2644-48EA-B15F-CDF3270F077C', N'DE1BD201-CE21-48EC-B2BC-43EC7C5CFB32', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'D6191CB6-F2A1-49A5-96C9-722F1002682D', N'40299F24-F6BF-488B-B86C-F4F651AC0910', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'7D777E05-C6F7-44E2-BAE5-6B70274018F2', N'6A7B22DF-D2D4-4893-AC3C-7CC8E901B0A1', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'4D21C812-0138-47FD-953F-C9716AA2CE21', N'E7FA5A30-CCAE-40A4-AD9B-5DB3F2210EB9', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'AEEC5D31-6D2B-402A-84B1-20BF27F4D252', N'EFC4A660-C3E7-41A5-90BD-7E55B33A554C', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'390E5003-5CDF-4EBA-96BD-804F395D2E88', N'F4E3B0CA-87FB-4593-A649-49C5F447BA75', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'D91E1B5A-2B82-4A0A-B88C-5F3B64B08BE1', N'229547CA-A74A-4105-B168-6580D6CB1453', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'2397FE00-5814-40BA-A1AB-0783AA225454', N'6BA90895-FC5A-440F-A7BB-1144212D066C', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'6EF0512E-DBC8-4675-BA99-9ADD48C4085A', N'9F33DAC6-4EAE-46F2-9B41-687599366FB0', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'80CC4693-C48E-4F91-9746-FC2F48997063', N'FA47825C-4296-45F1-81BF-34E446A79151', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'8485E691-1622-427F-83BF-AE1175B8FC6A', N'E6D29D19-A758-4CEB-9573-3D3095C30538', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'7B3B3775-6879-47AB-9521-66AC428C897D', N'ECB277DA-52B5-4AD4-84A1-FE8B2669274F', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'1CE16513-9E6B-4C9B-BB5B-D394BAA92735', N'0CFE6898-7FF2-432B-9AD5-8A7C2282D589', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'278C7497-C7D4-4D1B-89D4-C6A0535DB6FB', N'E342925E-3BD9-4FAA-B887-CB5FB0B78B41', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'18817484-4D08-4652-8CB2-707444E4FA13', N'2A8B7810-070A-410D-8891-3AD071A65B74', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'127017F2-D6F8-4A7E-870E-DF8F2E4A2C9F', N'E3E9A90D-73CA-4EC9-8ECB-7EC7E8925D19', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'30FA7DCA-2B0E-4275-9CF2-92A77D7DC130', N'E2C56CD2-2501-4710-97FA-76C4BD32CAE6', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'886B9619-3B83-4597-934C-A863A67CF310', N'43E0ED0A-5D55-401D-9369-0ABB63B72629', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'52E13C77-A453-47D6-965B-4840F769CF9C', N'4D4FE201-F779-4F0A-BE1A-3818C61ED4B7', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'BC89A49A-EA15-4B65-A3DF-83EBF1567B2A', N'1B35A190-8C7C-40DF-8DD0-18FF8B14AB80', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'C5109E1F-928B-4D2D-8D5A-ADF73389ABDD', N'43A74C0F-9CD7-4B57-8384-63F6651F89A9', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'3A491868-B7F7-4051-AD57-C433C5F7E173', N'CA6E492F-25B6-4E8F-ABFF-F68C75A36ACE', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'7FFF64D4-E982-4D26-9F64-10B176B4DD45', N'3DCF0C72-244C-4F49-87A8-BDFDE94FFA1D', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'E16B7CEC-E77B-4B33-BC9F-5E1ED4D1F1A4', N'218096C9-1D0F-4DF4-9F37-B9697C824793', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			,(N'891F6B3F-F6D7-41ED-BDCE-A871ADD11F46', N'23A7830E-5AE1-4916-930B-D0DE643413AA', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId)
			    ) 
		AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId]) 
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [FeatureId] = Source.[FeatureId],
			       [ModuleId] = Source.[ModuleId],
			       [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId]) 
		VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId]);

		MERGE INTO [dbo].[Feature] AS Target 
		USING ( VALUES 
		 (N'B1D7677B-8852-44A9-8CAD-310C66A95C3A', N'Manage GRD', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
		 (N'DAF7B38F-14E4-4114-BD0B-EADF476F63E3', N'Manage Site', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
         (N'9C3D67F3-3F8F-4EFC-AA8E-50C9EADB36CA', N'Manage advanced invoices', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
		 (N'C8ECFF90-A5FC-424C-89EC-28B2EAB9E0FF', N'Manage Entry Form GroupeE or RomandeE', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
		 (N'EF549308-1F98-4DE0-AE91-39E879A66888', N'Manage TVA', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
		 (N'035DFB11-C824-4A77-B912-06904FFD1261', N'Manage Bank Account', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
		 (N'2C9ACE2E-2E40-4DB1-9393-13AF7FFF9380', N'Manage Solar Log', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
         (N'63E8ACFE-3FB9-4AD3-8942-81C5202845C0', N'Manage Entry form field', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
         (N'86B42A29-B500-48D3-92E7-1F00E9B77146', N'Manage Entry form field type', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
         (N'193013F3-3EBA-44AD-8790-2D89A735F6B4', N'Manage message field type', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'ECA06EFD-312B-41DA-902A-B0AED4A5DFF6', N'Manage Expense Booking', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'D3DE5D81-3CDA-4067-A61B-0D20EAA4E351', N'Manage Payment Receipt', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'82E563BD-8B27-4222-9EFE-E1711FCF8F22', N'Manage Credit Note', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'8BBF8457-2BFC-4397-B237-3A04261C32B7', N'Manage Master Account', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'E63E21DD-88A6-45CD-A911-17C46499640D', N'Manage Mode or Terms of Payment', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
         (N'4665BABC-287D-478D-8B13-6881D850351F', N'Manage Port Details', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
         (N'1EA9D6B6-7FE5-43C1-9560-3C699E0D2A4B', N'Create Leads', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
         (N'CD246AB0-85ED-4B32-8FAA-5F8F5CDF966B', N'View Leads', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'28311887-ADF2-4EFB-94E4-E6E80924A99D', N'View Client Invoices', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'3961903F-C0E8-4286-9EFD-4CB6E1811641', N'Add Client Invoices', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
         (N'3C00F76A-457E-4068-9DF2-DF9F2F9EE3CD', N'Manage Consignee', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL),
         (N'49467AE3-2CE2-4ADF-A746-3A2D2E580A60', N'Manage Consigner', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'62E67D96-E050-4284-B9B1-EA7B6C7B123E', N'Add Purchase Execution', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'FEB5D233-5BD8-4067-B7BB-395BD37F727E', N'View Purchase Executions', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'A4037EBC-8EA9-4FA0-AC60-F5E02657F356', N'Manage Client Types', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'D56C2E52-C358-4E4B-BEA3-36CB22890B75', N'Manage Addresses', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
		 ,(N'50072B93-FF15-40DE-BE29-4F1176B58816', N'Share Q88', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'12382C96-64C2-48A3-B579-E8FED7CA0EF5', N'Accept / Reject Q88', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'43E98590-DD41-467A-A7EC-0E5F8D673313', N'View purchase contract history', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'C4E8F1E4-FCFA-4173-82D1-3DA8D7B83010', N'View sales contract history', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'E1E7D1D4-B370-4A91-A14B-787C160C28C6', N'View invoice queue contract history', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'6F4CDD8C-A805-424A-BBF1-882F90165C76', N'View vessel contract history', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'D9EE766D-AF1F-4E5A-82EA-98B5A68D431F', N'Approve or reject purchase contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'3EAAF3E9-E519-4774-B632-1E0EB87BAEDA', N'Approve or reject sales contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'178B6607-058F-4217-9F63-B9CB50353638', N'Generate purchase contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'815A2B65-3214-420D-BE0C-77832A8DF545', N'Generate sales contract', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'79648E7E-3323-42B1-B517-7E67502A28C3', N'Share execution steps', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'5F6E7B34-4AFC-41BF-89B3-B0A9C46A3D3F', N'Approve or reject steps', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
         ,(N'BCCA7B36-8460-4824-9483-DACD2544CA08', N'Generate Steps', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2021-10-08 17:39:32.367' AS DateTime), @DefaultUserId, NULL, NULL)
    
        )  AS Source ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [FeatureName] = Source.[FeatureName], 
			       [ParentFeatureId] = Source.[ParentFeatureId],
			       [IsActive] = Source.[IsActive],
			       [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId],
				   [UpdatedDateTime] = Source.[UpdatedDateTime],
				   [UpdatedByUserId] = Source.[UpdatedByUserId],
				   [MenuItemId] = Source.[MenuItemId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId])
		VALUES ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);
	
      MERGE INTO [dbo].[FeatureModule] AS Target 
		USING ( VALUES 
			(N'D0F47294-7DF9-49B0-8265-D2E7B564D752', N'B1D7677B-8852-44A9-8CAD-310C66A95C3A', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'54585C3B-B578-43B5-9F61-8D206ECAA86E', N'DAF7B38F-14E4-4114-BD0B-EADF476F63E3', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'B933ED0E-7C5E-4178-A985-41AA3048DB8D', N'9C3D67F3-3F8F-4EFC-AA8E-50C9EADB36CA', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'28FC0B42-E44A-4603-841C-7A171C75D039', N'C8ECFF90-A5FC-424C-89EC-28B2EAB9E0FF', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'3E3F5C26-7301-4FED-89DD-6A94C60E4CC3', N'EF549308-1F98-4DE0-AE91-39E879A66888', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'45319D27-742A-4F0B-9954-7F73CC17E165', N'035DFB11-C824-4A77-B912-06904FFD1261', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'1739A624-5C6A-4FE4-A196-691EDF57FBC9', N'2C9ACE2E-2E40-4DB1-9393-13AF7FFF9380', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'0ECC9256-1B4B-4C0E-B93A-40B32BC8F23D', N'63E8ACFE-3FB9-4AD3-8942-81C5202845C0', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'72CC72C6-F88F-456C-A2F5-D1E04D0945A4', N'193013F3-3EBA-44AD-8790-2D89A735F6B4', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'2D5780BB-DC54-4541-BA91-7E68B3B8D18D', N'ECA06EFD-312B-41DA-902A-B0AED4A5DFF6', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'72B3F6C7-190B-43E1-BE4E-6AFE5B4B90BE', N'D3DE5D81-3CDA-4067-A61B-0D20EAA4E351', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'7BB14392-5086-4FE6-972F-7A3F5C2C079E', N'82E563BD-8B27-4222-9EFE-E1711FCF8F22', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'1F7376BA-A4CC-4E81-92D6-1F1435C230E8', N'8BBF8457-2BFC-4397-B237-3A04261C32B7', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'45D76103-991D-4102-9E60-329F79ABFFF9', N'E63E21DD-88A6-45CD-A911-17C46499640D', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'882C52DD-7565-4134-B245-D074B49C8059', N'4665BABC-287D-478D-8B13-6881D850351F', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'AD488217-3D3C-49A9-A16A-D6ACE4B25C20', N'1EA9D6B6-7FE5-43C1-9560-3C699E0D2A4B', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'663B092C-9191-4E3F-ADF1-929780DEFC16', N'CD246AB0-85ED-4B32-8FAA-5F8F5CDF966B', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'7C421512-1696-4AF8-A478-3EA28E661408', N'28311887-ADF2-4EFB-94E4-E6E80924A99D', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
           ,(N'F40CA1F3-AA88-4353-B3E4-A38E3F0ABA82', N'3961903F-C0E8-4286-9EFD-4CB6E1811641', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'514504E8-6189-42FD-B85D-690DA6426441', N'3C00F76A-457E-4068-9DF2-DF9F2F9EE3CD', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'5263417A-86E5-4C6C-BF4E-ECB1833894BC', N'49467AE3-2CE2-4ADF-A746-3A2D2E580A60', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'7B3B0F40-2A2D-4D5E-8E01-122B5028A9C1', N'62E67D96-E050-4284-B9B1-EA7B6C7B123E', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'D7B164FB-DEE0-43E8-8F59-CE19011F94D1', N'FEB5D233-5BD8-4067-B7BB-395BD37F727E', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'208260EC-3406-4AB0-8FC7-1561F27D7E8F', N'A4037EBC-8EA9-4FA0-AC60-F5E02657F356', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'4AEEFFAC-CBE3-4A68-AB7C-7FEC3A3CF07B', N'D56C2E52-C358-4E4B-BEA3-36CB22890B75', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
		   ,(N'09159DE0-DF7C-4D15-B179-A802D3BB639F', N'50072B93-FF15-40DE-BE29-4F1176B58816', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'B79D6ADA-A8E4-4205-B140-083C276AA557', N'12382C96-64C2-48A3-B579-E8FED7CA0EF5', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'6C4A0358-8036-44C4-96B6-879190632DF9', N'43E98590-DD41-467A-A7EC-0E5F8D673313', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'B2348C65-D949-4013-ABE2-5F8B6D5824F0', N'C4E8F1E4-FCFA-4173-82D1-3DA8D7B83010', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'621163D1-AA65-49AB-894C-9ABC94AEE378', N'E1E7D1D4-B370-4A91-A14B-787C160C28C6', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'1ACC2E79-8976-4A51-88D5-31DD4700D6BA', N'6F4CDD8C-A805-424A-BBF1-882F90165C76', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'273DE827-A597-490F-910A-E124EDAFBCA6', N'D9EE766D-AF1F-4E5A-82EA-98B5A68D431F', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'EEC04338-676B-4402-89D5-BF7F8BE5EB0D', N'3EAAF3E9-E519-4774-B632-1E0EB87BAEDA', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'84DD7AAD-02EE-4CBD-85E3-E7D7CD2EEA86', N'178B6607-058F-4217-9F63-B9CB50353638', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'318BF593-5DC4-46BB-927E-D39DCA12CB1C', N'815A2B65-3214-420D-BE0C-77832A8DF545', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'FF624C4B-BE6D-4793-A3F5-A761DB3DA2AF', N'79648E7E-3323-42B1-B517-7E67502A28C3', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'DF732315-DBF1-4759-8220-05C1F6E0CC74', N'5F6E7B34-4AFC-41BF-89B3-B0A9C46A3D3F', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
	       ,(N'6CDCDCA8-63DD-419C-B099-DF816084B6C7', N'BCCA7B36-8460-4824-9483-DACD2544CA08', N'05E222F2-6EA3-4CA6-8788-52416E67475F', CAST(N'2019-05-21T10:48:51.907' AS DateTime), @DefaultUserId,NULL,NULL)
        ) 
		AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [FeatureId] = Source.[FeatureId],
			       [ModuleId] = Source.[ModuleId],
			       [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId],
				   [UpdatedDateTime] = Source.[UpdatedDateTime],
				   [UpdatedByUserId] = Source.[UpdatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
		VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);

    MERGE INTO [dbo].[Feature] AS Target 
	USING ( VALUES 
         (N'6437C206-EDBE-48F2-B525-E71DD4B73460', N'Manage contract templates', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'B07A30B6-1067-4A5E-B913-76F1177BE357', N'Manage trade templates', NULL, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', 1, NULL, CAST(N'2022-01-31T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'25C58D4C-A42C-4BA7-A510-9694E6CF9E97', N'Manage template configuration', NULL, N'71063FB9-DCD1-469B-9AA7-81DEB2CECE1B', 1, NULL, CAST(N'2021-10-01T12:57:21.880' AS DateTime), @DefaultUserId, NULL, NULL)
    )  AS Source ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureName] = Source.[FeatureName], 
			    [ParentFeatureId] = Source.[ParentFeatureId],
			    [IsActive] = Source.[IsActive],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId],
				[MenuItemId] = Source.[MenuItemId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId])
	VALUES ([Id], [FeatureName],[Description], [ParentFeatureId], [IsActive], [MenuItemId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);


    MERGE INTO [dbo].[FeatureModule] AS Target 
	USING ( VALUES 
		 (N'CB46A7DD-8AEB-48DD-ABBB-885A57B3E0E9','6437C206-EDBE-48F2-B525-E71DD4B73460',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'68683E14-7CF2-4ADC-BEC8-45389D524563','B07A30B6-1067-4A5E-B913-76F1177BE357',N'05E222F2-6EA3-4CA6-8788-52416E67475F',CAST(N'2021-10-01 07:05:16.660' AS DateTime), @DefaultUserId, NULL, NULL)
        ,(N'51FC1A9D-5446-450C-A1F9-B7BFFE5D1579', N'25C58D4C-A42C-4BA7-A510-9694E6CF9E97', N'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',CAST(N'2020-03-18T10:48:51.907' AS DateTime), @DefaultUserId, NULL, NULL)
	) 
	AS Source ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FeatureId] = Source.[FeatureId],
			    [ModuleId] = Source.[ModuleId],
			    [CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId],
				[UpdatedDateTime] = Source.[UpdatedDateTime],
				[UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
	VALUES ([Id], [FeatureId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);

    DECLARE @UserId UNIQUEIDENTIFIER = NULL,@CompanyId UNIQUEIDENTIFIER = NULL,@SQLQuery NVARCHAR(MAX) = '',@RoleId UNIQUEIDENTIFIER = NULL

    DECLARE @DeploymentScriptFilesList TABLE
    (
        FileId NVARCHAR(250),
		ExecutionOrder INT
    )

    INSERT INTO @DeploymentScriptFilesList(FileId,ExecutionOrder)
    
    SELECT ScriptFileId,ScriptFileExecutionOrder
        FROM DeploymentScript
        WHERE ScriptFileAppliedDateTime IS NULL
        ORDER BY ScriptFileExecutionOrder

    DECLARE Cursor_Script CURSOR
        FOR SELECT Id AS ComapnyId
            FROM Company
         
        OPEN Cursor_Script
         
            FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId
             
            WHILE @@FETCH_STATUS = 0
            BEGIN
               
               SET @UserId = (SELECT U.Id FROM [User] U 
                              INNER JOIN UserCompany AS UC ON UC.UserId = U.Id
                              INNER JOIN Company C ON C.Id = UC.CompanyId 
                                         AND U.UserName = C.WorkEmail 
                                         AND U.InActiveDateTime IS NULL 
                                         AND UC.CompanyId = @CompanyId)
               
               SET @RoleId = (SELECT TOP (1) Id FROM [Role] WHERE CompanyId = @CompanyId AND RoleName =  N'Super admin' AND InactiveDateTime IS NULL)
               
               IF(@UserId IS NULL)
                 SET @UserId = (SELECT TOP (1) U.Id 
                                    FROM [User] U 
                                    INNER JOIN UserCompany AS UC ON UC.UserId = U.Id
                                    WHERE U.Id IN (SELECT UserId FROM UserRole UR WHERE UR.RoleId = @RoleId) AND UC.CompanyId = @CompanyId);
                
                IF(@RoleId IS NOT NULL AND @CompanyId IS NOT NULL AND @UserId IS NOT NULL)
                BEGIN
                    
                    SELECT @SQLQuery = @SQLQuery + ' EXEC [dbo].' + FileId + ' @CompanyId = ''' + CONVERT(NVARCHAR(50),@CompanyId) 
                                    + ''',@UserId = ''' + CONVERT(NVARCHAR(50),@UserId) + ''',@RoleId = ''' + CONVERT(NVARCHAR(50),@RoleId) + ''''
                    FROM @DeploymentScriptFilesList ORDER BY ExecutionOrder

                    EXEC(@SQLQuery)

                END

                FETCH NEXT FROM Cursor_Script INTO 
                @CompanyId
                
                SELECT @UserId = NULL,@RoleId = NULL,@SQLQuery = ''
        
            END
             
        CLOSE Cursor_Script
         
        DEALLOCATE Cursor_Script

        UPDATE DeploymentScript SET ScriptFileAppliedDateTime = GETDATE() WHERE ScriptFileAppliedDateTime IS NULL

END
