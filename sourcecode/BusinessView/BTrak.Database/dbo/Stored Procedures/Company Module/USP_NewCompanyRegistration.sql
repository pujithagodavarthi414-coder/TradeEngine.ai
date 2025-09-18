-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-08-01 00:00:00.000'
-- Purpose      To register new company
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC USP_NewCompanyRegistration @CompanyName = 'swwa',@IsActiveOnMobile = 1,@SiteAddress = 'ssa',@WorkEmail = 'sas@gmail.com',@Password = 'gLecZwWSUvmzSo/oExEc+O1DCxC5YLZvANKvv6GUALYTjpwi',@IndustryId = '744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71',@FirstName = 'Sai',@MobileNumber = '232984458053241'
-------------------------------------------------------------------------------
CREATE PROCEDURE USP_NewCompanyRegistration
(  
 @CompanyName NVARCHAR(250) = NULL,
 @SiteAddress NVARCHAR(250) = NULL,
 @WorkEmail NVARCHAR(250) = NULL,
 @TeamSize INT = NULL,
 @IsRemoteAccess BIT = NULL,
 @Password NVARCHAR(250) = NULL,
 @IndustryId UNIQUEIDENTIFIER = NULL,
 @MainUseCaseId UNIQUEIDENTIFIER = NULL,
 @CountryId UNIQUEIDENTIFIER = NULL,
 @IsActiveOnMobile BIT = NULL, 
 @TimeZoneId UNIQUEIDENTIFIER = NULL,
 @CurrencyId UNIQUEIDENTIFIER = NULL,
 @NumberFormatId UNIQUEIDENTIFIER = NULL,
 @DateFormatId UNIQUEIDENTIFIER = NULL,
 @TimeFormatId UNIQUEIDENTIFIER = NULL,
 @FirstName NVARCHAR(100) = NULL,
 @MobileNumber NVARCHAR(40) = NULL,
 @LastName NVARCHAR(100) = NULL,
 @IsDemoData BIT = NULL,
 @IsSoftWare BIT = NULL,
 @Language NVARCHAR(10)= NULL,
 @TrailPeriod INT = NULL,
 @ReDirectionUrl NVARCHAR(500) = NULL,
 @SiteDomain NVARCHAR(500) = NULL,
 @RegisterSiteAddress NVARCHAR(Max) = NULL,
 @CompanyAuthenticationId UNIQUEIDENTIFIER = NULL,
 @UserAuthenticationId UNIQUEIDENTIFIER = NULL,
 @RoleId UNIQUEIDENTIFIER = NULL,
 @RoleListXml XML = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    BEGIN TRY
        
        IF(@CompanyName =  '') SET @CompanyName = NULL
       
        IF(@MainUseCaseId = '00000000-0000-0000-0000-000000000000') SET @MainUseCaseId = NULL
        
        IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL
        
        IF(@TimeFormatId = '00000000-0000-0000-0000-000000000000') SET @TimeFormatId = NULL
        
        IF(@TimeZoneId = '00000000-0000-0000-0000-000000000000') SET @TimeZoneId = NULL
        
        IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET @CurrencyId = NULL
        
        IF(@NumberFormatId = '00000000-0000-0000-0000-000000000000') SET @NumberFormatId = NULL
        
        IF(@DateFormatId = '00000000-0000-0000-0000-000000000000') SET @DateFormatId = NULL

        IF(@RoleId = '00000000-0000-0000-0000-000000000000') SET @RoleId = NULL

        IF(@CompanyName IS NULL)
        BEGIN
           
		   RAISERROR(50011,16,2,'CompanyName')

        END  
		
        --ELSE IF(@MobileNumber IS NULL)
        --BEGIN
           
        --   RAISERROR(50011,16,2,'MobileNumber')

        --END

        ELSE IF(@SiteAddress IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'SiteAddress')

        END 
		
		ELSE IF(@SiteAddress LIKE '% %')
		BEGIN
           
           RAISERROR(50011,16,2,'SiteAddressSpace')

        END 
		
        ELSE IF(@WorkEmail IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'WorkMail')

        END 
		
		ELSE IF((SELECT COUNT(@WorkEmail) WHERE @WorkEmail NOT LIKE '%_@_%.__%') > 0)
        BEGIN
           
           RAISERROR(50011,16,2,'WorkMailInVaild')

        END 

        ELSE IF(@Password IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'Password')

        END
		 
        ELSE IF(@FirstName IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'FirstNameProvide')

        END 
		ELSE IF(@LastName IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'LastName')

        END 
        ELSE IF(@IndustryId IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'TypeofIndustry')

        END
        ELSE
        BEGIN
        
        DECLARE @CompanyNameCount INT = (SELECT COUNT(1) FROM Company WHERE CompanyName = @CompanyName AND InActiveDateTime IS NULL)

        DECLARE @SiteAddressCount INT = (SELECT COUNT(1) FROM Company WHERE SiteAddress = @SiteAddress AND InActiveDateTime IS NULL)

		DECLARE @RegisteredEmailCount INT = (SELECT COUNT(1) FROM Company WHERE WorkEmail = @WorkEmail AND InActiveDateTime IS NULL)

        DECLARE @MobileNumberCount INT = (SELECT COUNT(1) FROM [User] WHERE MobileNo = @MobileNumber AND @MobileNumber != NULL AND @MobileNumber!=''  AND InActiveDateTime IS NULL)

		--DECLARE @WorkEmailCount INT = (SELECT COUNT(1) FROM [User] WHERE UserName = @WorkEmail AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL)
        
        DECLARE @DefaultUserId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')
        
		IF (@CompanyNameCount > 0)
        BEGIN

            RAISERROR(50001,16,1,'CompanyName')

        END
        ELSE IF (@SiteAddressCount > 0)
        BEGIN

            RAISERROR(50001,16,1,'SiteAddress')

        END
        --ELSE IF (@RegisteredEmailCount > 0)
        --BEGIN

        --    RAISERROR(50001,16,1,'Email')

        --END
		ELSE IF (@MobileNumberCount > 0)
        BEGIN

            RAISERROR(50001,16,1,'MobileNumber')

        END
        --ELSE IF (@WorkEmailCount > 0)
        --BEGIN

        --    RAISERROR(50001,16,1,'Email')

        --END
        ELSE
        BEGIN
        
            DECLARE @NewCompanyId UNIQUEIDENTIFIER = @CompanyAuthenticationId --NEWID() 

            DECLARE @NewUserId UNIQUEIDENTIFIER = NEWID() 

            DECLARE @CurrentDate DATETIME = GETDATE()

                       INSERT INTO [dbo].[Company](
                                                   [Id],
                                                   [CompanyName],
                                                   [SiteAddress],
                                                   [WorkEmail],
                                                   [Password],
                                                   [IndustryId],
                                                   [MainUseCaseId],
                                                   [PhoneNumber],
                                                   [CountryId],
                                                   [TimeZoneId],
                                                   [CurrencyId],
                                                   [NumberFormatId],
                                                   [DateFormatId],
                                                   [TimeFormatId],
                                                   [TeamSize],
                                                   [CreatedDateTime],
												   [IsDemoDataCleared],
												   [IsRemoteAccess],
												   [IsDemoData],
												   [IsSoftWare],
												   [Language],
												   [TrailDays],
												   [ReDirectionUrl],
												   [SiteDomain],
												   [RegistrerSiteAddress],
                                                   [CompanyAuthenticationId]
                                                  )
                                            SELECT @NewCompanyId,
                                                   @CompanyName,
                                                   @SiteAddress,
                                                   @WorkEmail,
                                                   @Password,
                                                   @IndustryId,
                                                   @MainUseCaseId,
                                                   @MobileNumber,
                                                   @CountryId,
                                                   @TimeZoneId,
                                                   @CurrencyId,
                                                   @NumberFormatId,
                                                   @DateFormatId,
                                                   @TimeFormatId,
                                                   @TeamSize,
                                                   @Currentdate,
												   0,
												   ISNULL(@IsRemoteAccess,0),
												   @IsDemoData,
												   @IsSoftWare,
												   @Language,
												   @TrailPeriod,
												   @ReDirectionUrl,
												   @SiteDomain,
												   @RegisterSiteAddress,
                                                   @CompanyAuthenticationId

                       INSERT INTO CompanyModule(
                                                 [Id],
                                                 [CompanyId],
                                                 [ModuleId],
                                                 [IsActive],
												 [IsEnabled],
                                                 [CreatedDateTime],
                                                 [CreatedByUserId]
                                                )
                                          SELECT NEWID(),
                                                 @NewCompanyId,
                                                 M.Id,
                                                 CASE WHEN M.IsSystemModule = 1 THEN 1 ELSE 0 END,
												 CASE WHEN M.IsSystemModule = 1 THEN 1 ELSE 0 END,
                                                 @Currentdate,
                                                 @NewUserId
                                                 FROM Module M 
												 --JOIN IndustryModule IM ON IM.ModuleId = M.Id AND IM.IndustryId = @IndustryId
												 WHERE M.InactiveDateTime IS NULL

                       --DECLARE @RoleId UNIQUEIDENTIFIER = NEWID()
                       IF(@RoleId IS NULL)
                       BEGIN
                        SET @RoleId = NEWID()
                       END
					   INSERT INTO [Role](
						                   Id,
										   RoleName,
										   CompanyId,
										   CreatedByUserId,
										   CreatedDateTime
										  )
									SELECT @RoleId,
									       'Super Admin',
										   @NewCompanyId,
										   @DefaultUserId,
										   @CurrentDate

					    INSERT INTO [User](
                                           [Id],
                                           CompanyId,
                                           [SurName],
                                           [FirstName],
                                           [UserName],
                                           [Password],
                                           [IsActive],
                                           [TimeZoneId],
                                           [MobileNo],
                                           [IsActiveOnMobile],
                                           [RegisteredDateTime],
                                           [CreatedDateTime],
                                           [CreatedByUserId],
                                           [UserAuthenticationId]
                                          )
                                    SELECT @NewUserId,
                                           @NewCompanyId,
                                           @LastName,
                                           @FirstName,
                                           @WorkEmail,
                                           @Password,
                                           1,
                                           @TimeZoneId,
                                           @MobileNumber,
                                           CASE WHEN @IsActiveOnMobile IS NULL THEN 0 ELSE @IsActiveOnMobile END,
                                           @CurrentDate,
                                           @CurrentDate,
                                           @DefaultUserId,
                                           @UserAuthenticationId

                        INSERT INTO UserRole
					    	        (Id
					    	        ,UserId
					    	        ,RoleId
					    	        ,CreatedByUserId
					    	        ,CreatedDateTime)
					    	 SELECT NEWID()
					    	        ,@NewUserId
					    		    ,@RoleId
					    		    ,@DefaultUserId
					    		    ,@Currentdate

                      DECLARE @NewEmployeeId UNIQUEIDENTIFIER = NEWID()
                      
					  DECLARE @NewUserActiveDetailsId UNIQUEIDENTIFIER = NEWID()

					   INSERT INTO UserActiveDetails(
                                                      Id,
                                                      UserId,
                                                      ActiveFrom,
                                                      ActiveTo,
                                                      CreatedDateTime,
                                                      CreatedByUserId
                                                     )
                                               SELECT @NewUserActiveDetailsId,
                                                      @NewUserId,
                                                      GETDATE(),
                                                      NULL,
                                                      @Currentdate,
                                                      @DefaultUserId

                    INSERT INTO Employee(
                                           [Id],
                                           [UserId],
										   [EmployeeNumber],
                                           [CreatedDateTime],
                                           [CreatedByUserId]
                                          )
                                    SELECT @NewEmployeeId,
                                           @NewUserId,
										   'EM ' + CAST((SELECT COUNT(1) + 1 FROM Employee) AS NVARCHAR(100)),
                                           @CurrentDate,
                                           @DefaultUserId
            
            DECLARE @NewEntityId UNIQUEIDENTIFIER

   --         INSERT INTO [dbo].[Entity](Id,EntityName,CreatedDateTime,CreatedByUserId,CompanyId)
   --         SELECT @NewEntityId,@CompanyName,GETDATE(),@DefaultUserId,@NewCompanyId
            
   --         INSERT INTO [dbo].[EntityBranch]([Id],[EntityId],[BranchId],[CreatedByUserId],[CreatedDateTime])
   --         SELECT NEWID(),E.Id,E.Id,@DefaultUserId,GETDATE()
   --         FROM Entity E
   --         WHERE E.CompanyId = @NewCompanyId
            
   --         INSERT INTO [dbo].[Branch]([Id],[CompanyId],[BranchName],[CreatedDateTime],[CreatedByUserId])
			--SELECT @NewEntityId,@NewCompanyId,@CompanyName,@Currentdate,@NewUserId

            MERGE INTO [dbo].[Country] AS Target
	        USING ( VALUES 
	        		(NEWID(),@NewCompanyId, N'Belgium',  N'+32', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Antarctica', N'+672', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Albania', N'+355', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'France', N'+33', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'India', N'+91', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Brazil', N'+55', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Bangladesh', N'+880', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Japan', N'+81', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Dhaka', N'+880', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'England',  N'+44', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Canada', N'+1', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'China', N'+86', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Algola', N'+244', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Europe', N'+45', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Afganisthan', N'+93', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId),
	        		(NEWID(),@NewCompanyId, N'Uk', N'+44', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @NewUserId)
	        		) 
	        AS Source ([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId])
	        ON Target.Id = Source.Id  
	        WHEN MATCHED THEN 
	        UPDATE SET [CompanyId]  = Source.[CompanyId],
	                   [CountryName] = Source.[CountryName],
	                   [CreatedDateTime] = Source.[CreatedDateTime],
	                   [CreatedByUserId] = Source.[CreatedByUserId],
	                   [CountryCode] = Source.[CountryCode]
	        WHEN NOT MATCHED BY TARGET THEN 
	        INSERT([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId]) 
	        VALUES ([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId]);

             DECLARE @InnerCountryId UNIQUEIDENTIFIER = (SELECT Id FROM Country 
                                                        WHERE CompanyId = @NewCompanyId
                                                              AND CountryName = (SELECT CountryName FROM SYS_Country WHERE Id = @CountryId)
                                                              AND InActiveDateTime IS NULL)
            
            IF(@InnerCountryId IS NULL)
            BEGIN
                
               SET @InnerCountryId = (SELECT TOP (1) Id FROM Country WHERE CompanyId = @NewCompanyId AND InActiveDateTime IS NULL)

            END

            INSERT INTO [dbo].[Intro] (Id,UserId,ModuleId,CreatedByUserId,CreatedDateTime,EnableIntro)
            SELECT NEWID(),@NewUserId,M.Id AS ModuleId,@NewUserId,GETDATE(),1
            FROM Module M
            WHERE M.Id IN (
            SELECT ModuleId FROM CompanyModule CM 
            WHERE CM.CompanyId = @NewCompanyId 
                  --AND CM.IsActive = 1 AND CM.IsEnabled = 1
                  AND CM.InActiveDateTime IS NULL
            )

            DECLARE @Entity TABLE
            (
                EntityId UNIQUEIDENTIFIER    
            )

            INSERT INTO @Entity(EntityId)
            EXEC [dbo].[USP_UpsertEntity] @EntityName = @CompanyName,@IsBranch = 1,@TimeZoneId='c527b633-9fb6-4d9f-be87-5172dbe87d18',@OperationsPerformedBy = @NewUserId,@CountryId = @InnerCountryId

            SET @NewEntityId = (SELECT EntityId FROM @Entity)

            INSERT INTO [dbo].[EmployeeEntity]([Id],EmployeeId,EntityId,[CreatedByUserId],[CreatedDateTime])
            SELECT NEWID(),@NewEmployeeId,@NewEntityId,@NewUserId,GETDATE()

            INSERT INTO [dbo].[EmployeeEntityBranch] ([Id],[EmployeeId],[BranchId],[CreatedByUserId],[CreatedDateTime])
            SELECT NEWID(),@NewEmployeeId,@NewEntityId,@NewUserId,GETDATE()

			INSERT INTO [dbo].[EmployeeBranch] ([Id],[EmployeeId],[BranchId],[CreatedByUserId],[CreatedDateTime],ActiveFrom,ActiveTo)
            SELECT NEWID(),@NewEmployeeId,@NewEntityId,@NewUserId,GETDATE(),GETDATE(),NULL

            IF(EXISTS(SELECT * FROM Company WHERE Id = @NewCompanyId  AND IndustryId ='744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71'))
            BEGIN
                IF(@RoleListXml IS NOT NULL)
				BEGIN
                    DECLARE @RoleList TABLE 
			        (
				        Id UNIQUEIDENTIFIER ,
				        RoleName NVARCHAR(800),
                        IsDeveloper BIT, 
                        IsAdministrator BIT
			        )

					INSERT INTO @RoleList (Id, RoleName, IsDeveloper, IsAdministrator)
					SELECT Id, RoleName, IsDeveloper, IsAdministrator FROM (
					SELECT	x.value('Id[1]','UNIQUEIDENTIFIER') AS Id,
                    x.value('RoleName[1]','nvarchar(800)') AS RoleName,
                    x.value('IsDeveloper[1]','BIT') AS IsDeveloper,
                    x.value('IsAdministrator[1]','BIT') AS IsAdministrator
					FROM  @RoleListXml.nodes('/GenericListOfRoleDetailsOutputModel/ListItems/RoleDetailsOutputModel') XmlData(x) ) T

                    INSERT INTO [Role](
						            Id,
									RoleName,
									CompanyId,
									CreatedByUserId,
									CreatedDateTime,
                                    IsDeveloper,
                                    IsAdministrator
									)
							SELECT Id,
									RoleName,
									@NewCompanyId,
									@DefaultUserId,
									@CurrentDate,
                                    IsDeveloper,
                                    IsAdministrator
                                    FROM @RoleList
				END
            END

            DECLARE @EscuteScript NVARCHAR(MAX) = ''

                    --TODO
            SELECT @EscuteScript = @EscuteScript + '  EXEC [dbo].' + ScriptFileId + ' @CompanyId = ''' 
                                                                           + CONVERT(NVARCHAR(50),@NewCompanyId) + ''',@RoleId = ''' 
                                                                           + CONVERT(NVARCHAR(50),@RoleId) + ''',@UserId = ''' 
                                                                           + CONVERT(NVARCHAR(50),@NewUserId) + ''''
                    FROM DeploymentScript
                    ORDER BY ScriptFileExecutionOrder

                    EXECUTE(@EscuteScript);

			--EXEC [USP_CompanyTestDataInsertScript] @CompanyId = @NewCompanyId,@UserId = @NewUserId (inserting through api)
           
            SELECT @NewCompanyId AS CompanyId,@NewUserId AS UserId,@RoleId AS RoleId

          END
          END
        END TRY
        BEGIN CATCH
            THROW
        END CATCH
END
GO
