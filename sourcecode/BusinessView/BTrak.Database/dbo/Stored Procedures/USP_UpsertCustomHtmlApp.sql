CREATE PROCEDURE [dbo].[USP_UpsertCustomHtmlApp]
(
   @CustomHtmlAppId UNIQUEIDENTIFIER = NULL,
   @ModuleIdsXml XML = NULL,
   @CustomHtmlAppName NVARCHAR(800)  = NULL,
   @Description NVARCHAR(4000) = NULL,
   @HtmlCode NVARCHAR(MAX) = NULL,
   @RoleIds XML = NULL,
   @ChartsDeatils XML = NULL,
   @IsArchived BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @TimeStamp TimeStamp = NULL,
   @FileUrls NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@CustomHtmlAppName = '') SET @CustomHtmlAppName = NULL

	    IF(@CustomHtmlAppName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'CustomHtmlAppName')

		END

		ELSE
		BEGIN

		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		   			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
				DECLARE @CustomHtmlAppIdIdCount INT = (SELECT COUNT(1) FROM [dbo].[CustomHtmlApp] WHERE Id = @CustomHtmlAppId AND CompanyId = @CompanyId)

				DECLARE @CustomHtmlAppNameCount INT = (SELECT COUNT(1) FROM [dbo].[CustomHtmlApp] WHERE CustomHtmlAppName = @CustomHtmlAppName AND CompanyId = @CompanyId AND (Id <> @CustomHtmlAppId OR @CustomHtmlAppId IS NULL))

				  DECLARE @WigetRoles TABLE
                (
                    [RoleId] [uniqueidentifier] NULL,
					[IsExist] [Bit] NULL
                ) 
                
                INSERT INTO @WigetRoles(RoleId)
                SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)')
                FROM @RoleIds.nodes('/ArrayOfGuid/guid') AS [Table]([Column])

				UPDATE @WigetRoles SET IsExist = IIF(CRW.Id IS NULL,0,1) FROM @WigetRoles WR LEFT JOIN CustomHtmlAppRoleConfiguration CRW ON CRW.RoleId = Wr.RoleId AND CRW.CustomHtmlAppId = @CustomHtmlAppId

				IF(@CustomHtmlAppIdIdCount = 0 AND @CustomHtmlAppId IS NOT NULL)
				BEGIN
					
					RAISERROR(50002,16, 1,'CustomHtmlAppName')

				END

				ELSE IF(@CustomHtmlAppNameCount > 0)
				BEGIN

					RAISERROR(50001,16,1,'CustomHtmlAppName')

				END		

				ELSE
				BEGIN

				DECLARE @IsLatest BIT = (CASE WHEN @CustomHtmlAppId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [dbo].[CustomHtmlApp] WHERE Id = @CustomHtmlAppId) = @TimeStamp
																THEN 1 ELSE 0 END END)

			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
					DECLARE @NewCustomHtmlAppId UNIQUEIDENTIFIER = NEWID()

					IF(@CustomHtmlAppId IS NULL)
					BEGIN
						
						INSERT INTO [dbo].CustomHtmlApp(
                                [Id],
                                [CustomHtmlAppName],
                                [HtmlCode],
                                [CreatedByUserId],
                                [CreatedDateTime],
                                [CompanyId],
                                [Description],
								[FileUrls],
								[Version])
                         SELECT @NewCustomHtmlAppId,
                                @CustomHtmlAppName,
                                @HtmlCode,
                                @OperationsPerformedBy,
                                @Currentdate,
                                @CompanyId,
                                @Description,
								@FileUrls,
								(SELECT CONVERT(VARCHAR(50), GETDATE(), 102) + '.0')

					 SET @CustomHtmlAppId = @NewCustomHtmlAppId
			       END
				   
				   ELSE
				   BEGIN

						DECLARE @PreviousHtmlCode NVARCHAR(MAX) = (SELECT HtmlCode FROM CustomHtmlApp WHERE Id = @CustomHtmlAppId)

						IF(@PreviousHtmlCode <> @HtmlCode)
						BEGIN

							INSERT INTO CustomHtmlVersion(
										[Id],
										[CustomHtmlAppId],
										[HtmlCode],
										[Version],
										[CreatedByUserId],
										[CreatedDateTime])
								 SELECT NEWID(),
										CA.Id,
										CA.HtmlCode,
										CA.[Version],
										ISNULL(UpdatedByUserId,CreatedByUserId),
										ISNULL(UpdatedDateTime,CreatedDateTime)
								  FROM [CustomHtmlApp] CA
								  WHERE CA.Id = @CustomHtmlAppId

						END
						
						DECLARE @Count NVARCHAR(10) = (SELECT  COUNT(1) FROM [CustomHtmlVersion]
													   WHERE (SELECT CONVERT(VARCHAR(50), GETDATE(), 102)) = SUBSTRING([version],1,10) 
													          AND CustomHtmlAppId = @CustomHtmlAppId)

						UPDATE [dbo].[CustomHtmlApp]
						SET [CustomHtmlAppName] = @CustomHtmlAppName
							,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							,CompanyId = @CompanyId
							,[UpdatedDateTime] = @Currentdate
							,[UpdatedByUserId] = @OperationsPerformedBy
							,[Description] = @Description
							,[HtmlCode] = @HtmlCode
							,[FileUrls] = @FileUrls
							,[Version] = (SELECT CONVERT(VARCHAR(50), GETDATE(), 102) + '.' + ISNULL(@Count,'0'))
						WHERE Id = @CustomHtmlAppId

				   END
			        
					--DECLARE @WidgetModuleConfiguration UNIQUEIDENTIFIER = (SELECT Id FROM WidgetModuleConfiguration WHERE WidgetId = ISNULL(@CustomHtmlAppId ,@NewCustomHtmlAppId) AND InActiveDateTime IS NULL)

					--IF(@WidgetModuleConfiguration IS NULL AND @ModuleId IS NOT NULL)
					--BEGIN

					-- INSERT INTO [dbo].[WidgetModuleConfiguration](
     --                       [Id],
     --                       [WidgetId],
     --                       [ModuleId],
     --                       [CreatedDateTime],
     --                       [CreatedByUserId])
     --                SELECT NEWID(),
     --                       ISNULL(@CustomHtmlAppId ,@NewCustomHtmlAppId), 
     --                       @ModuleId,
     --                       @Currentdate,
     --                       @OperationsPerformedBy
                   
					--END
					--ELSE
					--BEGIN

				 --  UPDATE [dbo].[WidgetModuleConfiguration]
				 --  SET WidgetId =  ISNULL(@CustomHtmlAppId ,@NewCustomHtmlAppId)
				 --     ,ModuleId = @ModuleId
				 --  	  ,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
				 --  	  ,[UpdatedDateTime] = @Currentdate
				 --  	  ,[UpdatedByUserId] = @OperationsPerformedBy
				 --  WHERE Id = @WidgetModuleConfiguration

					--END
				DECLARE @WigetModulesList TABLE
                (
                    ModuleId [uniqueidentifier] 
                ) 
                
                INSERT INTO @WigetModulesList(ModuleId)
                SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)')
                FROM @ModuleIdsXml.nodes('/ArrayOfGuid/guid') AS [Table]([Column])

				UPDATE WidgetModuleConfiguration SET InActiveDateTime =  @Currentdate WHERE WidgetId =  ISNULL(@CustomHtmlAppId ,@NewCustomHtmlAppId) AND InActiveDateTime IS NULL AND  ISNULL(@CustomHtmlAppId ,@NewCustomHtmlAppId) IS NOT NULL

				 INSERT INTO [dbo].[WidgetModuleConfiguration](
                            [Id],
                            [WidgetId],
                            [ModuleId],
                            [CreatedDateTime],
                            [CreatedByUserId])
                     SELECT NEWID(),
                            ISNULL(@CustomHtmlAppId ,@NewCustomHtmlAppId), 
                            ModuleId,
                            @Currentdate,
                            @OperationsPerformedBy
                     FROM @WigetModulesList


					UPDATE CustomHtmlAppRoleConfiguration SET InActiveDateTime = NULL WHERE RoleId IN (SELECT RoleId FROM @WigetRoles WHERE IsExist = 1) AND CustomHtmlAppId = @CustomHtmlAppId
					
					UPDATE CustomHtmlAppRoleConfiguration SET InActiveDateTime = @Currentdate WHERE RoleId NOT IN (SELECT RoleId FROM @WigetRoles) AND CustomHtmlAppId = @CustomHtmlAppId

					 INSERT INTO [dbo].CustomHtmlAppRoleConfiguration(
                            [Id],
                            [CustomHtmlAppId],
                            [RoleId],
                            [CreatedDateTime],
                            [CreatedByUserId])
                     SELECT NEWID(),
                          ISNULL(@CustomHtmlAppId ,@NewCustomHtmlAppId), 
                          T.RoleId,
                          @Currentdate,
                          @OperationsPerformedBy
                    FROM @WigetRoles T WHERE T.IsExist = 0

					SELECT @CustomHtmlAppId 

					END	
					ELSE
			  			RAISERROR (50008,11, 1)

				 END	

				END
				
				ELSE
				BEGIN

						RAISERROR (@HavePermission,11, 1)
						
				END
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO