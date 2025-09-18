CREATE PROCEDURE [dbo].[Marker161]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


DELETE PTTS FROM [PayrollTemplateTaxSlab] PTTS
JOIN [TaxSlabs] TS ON TS.Id = PTTS.TaxSlabId
JOIN Country C ON C.Id = TS.CountryId
WHERE TS.CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)

DELETE TS FROM [TaxSlabs] TS
JOIN Country C ON C.Id = TS.CountryId
WHERE C.CompanyId = @CompanyId AND TS.CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)

MERGE INTO [dbo].[TaxSlabs] AS Target 
USING (VALUES 
         (NEWID(),'Upto 60 years',NULL,NULL,NULL,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,60,NULL,NULL,NULL,3,0,0,NULL,(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	    ,(NEWID(),'Age 60-80',NULL,NULL,NULL,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,60,80,NULL,NULL,NULL,2,0,0,NULL,(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	    ,(NEWID(),'Above 80 years',NULL,NULL,NULL,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,80,NULL,NULL,NULL,NULL,1,0,0,NULL,(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	    ,(NEWID(),'Slabs',NULL,NULL,NULL,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,100,NULL,NULL,NULL,4,0,0,NULL,(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ) 
AS Source ([Id],[Name],[FromRange],[ToRange],[TaxPercentage],[ActiveFrom],[ActiveTo],[MinAge],[MaxAge],[ForMale],[ForFemale],[Handicapped],[Order],[IsArchived],[IsFlatRate],[ParentId],[CountryId],[CreatedDateTime],[CreatedByUserId],[InactiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [Name] = Source.[Name],
           [FromRange] = Source.[FromRange],
		   [ToRange] = Source.[ToRange],
		   [TaxPercentage] = Source.[TaxPercentage],
		   [ActiveFrom] = Source.[ActiveFrom],
		   [ActiveTo] = Source.[ActiveTo],
		   [MinAge] = Source.[MinAge],
		   [MaxAge] = Source.[MaxAge],
		   [ForMale] = Source.[ForMale],
		   [ForFemale] = Source.[ForFemale],
		   [Handicapped] = Source.[Handicapped],
		   [Order] = Source.[Order],
		   [IsArchived] = Source.[IsArchived],
		   [IsFlatRate] = Source.[IsFlatRate],
		   [ParentId] = Source.[ParentId],
		   [CountryId] = Source.[CountryId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [InactiveDateTime] = Source.[InactiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Name], [FromRange], [ToRange], [TaxPercentage], [ActiveFrom], [ActiveTo], [MinAge], [MaxAge], [ForMale], [ForFemale], [Handicapped], [Order], [IsArchived], [IsFlatRate], [ParentId], [CountryId],[CreatedDateTime],[CreatedByUserId],[InactiveDateTime]) 
VALUES ([Id], [Name], [FromRange], [ToRange], [TaxPercentage], [ActiveFrom], [ActiveTo], [MinAge], [MaxAge], [ForMale], [ForFemale], [Handicapped], [Order], [IsArchived], [IsFlatRate], [ParentId], [CountryId],[CreatedDateTime],[CreatedByUserId],[InactiveDateTime]);


MERGE INTO [dbo].[TaxSlabs] AS Target 
USING (VALUES 
        (NEWID(),'0-2.5L',0.0000,250000.0000,0.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Upto 60 years' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'2.5-5L',250001.0000,500000.0000,5.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Upto 60 years' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'5-10L',500001.0000,1000000.0000,20.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Upto 60 years' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'Above 10L',1000001.0000,NULL,30.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Upto 60 years' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
      	 
	   ,(NEWID(),'Upto 3L',0.0000,300000.0000,0.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Age 60-80' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'3.0-5.0L',300001.0000,500000.0000,5.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Age 60-80' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'5.0-10.0L',500001.0000,1000000.0000,20.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Age 60-80' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'Above 10.0L',1000001.0000,NULL,30.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Age 60-80' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   	
	   ,(NEWID(),'upto 5L',0.0000,500000.0000,0.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Above 80 years' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'B/w 5-10L',500001.0000,1000000.0000,20.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Above 80 years' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'Above 10.0 L',1000001.0000,NULL,30.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Above 80 years' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	  	
	   ,(NEWID(),'upto 2.5L',0.0000,250000.0000,0.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Slabs' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'2.5-5.0 L',250001.0000,500000.0000,5.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Slabs' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'5-7.5L',500001.0000,750000.0000,10.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Slabs' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'7.5-10L',750001.0000,1000000.0000,15.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Slabs' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'10-12.5L',1000001.0000,1250000.0000,20.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Slabs' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'12.5-15L',1250001.0000,1500000.0000,25.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Slabs' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ,(NEWID(),'above 15L',1500001.0000,NULL,30.0000,CAST(N'2019-01-01 00:00:00.000' AS DateTime), NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,(SELECT Id FROM [TaxSlabs] WHERE Name ='Slabs' AND CountryId = (SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId)),(SELECT TOP(1) Id FROM Country WHERE CountryName ='India' AND CompanyId = @CompanyId),GETDATE(),@UserId,NULL)
	   ) 
AS Source ([Id],[Name],[FromRange],[ToRange],[TaxPercentage],[ActiveFrom],[ActiveTo],[MinAge],[MaxAge],[ForMale],[ForFemale],[Handicapped],[Order],[IsArchived],[IsFlatRate],[ParentId],[CountryId],[CreatedDateTime],[CreatedByUserId],[InactiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [Id] = Source.[Id],
           [Name] = Source.[Name],
           [FromRange] = Source.[FromRange],
		   [ToRange] = Source.[ToRange],
		   [TaxPercentage] = Source.[TaxPercentage],
		   [ActiveFrom] = Source.[ActiveFrom],
		   [ActiveTo] = Source.[ActiveTo],
		   [MinAge] = Source.[MinAge],
		   [MaxAge] = Source.[MaxAge],
		   [ForMale] = Source.[ForMale],
		   [ForFemale] = Source.[ForFemale],
		   [Handicapped] = Source.[Handicapped],
		   [Order] = Source.[Order],
		   [IsArchived] = Source.[IsArchived],
		   [IsFlatRate] = Source.[IsFlatRate],
		   [ParentId] = Source.[ParentId],
		   [CountryId] = Source.[CountryId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
		   [InactiveDateTime] = Source.[InactiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Name], [FromRange], [ToRange], [TaxPercentage], [ActiveFrom], [ActiveTo], [MinAge], [MaxAge], [ForMale], [ForFemale], [Handicapped], [Order], [IsArchived], [IsFlatRate], [ParentId], [CountryId],[CreatedDateTime],[CreatedByUserId],[InactiveDateTime]) 
VALUES ([Id], [Name], [FromRange], [ToRange], [TaxPercentage], [ActiveFrom], [ActiveTo], [MinAge], [MaxAge], [ForMale], [ForFemale], [Handicapped], [Order], [IsArchived], [IsFlatRate], [ParentId], [CountryId],[CreatedDateTime],[CreatedByUserId],[InactiveDateTime]);

END

GO
