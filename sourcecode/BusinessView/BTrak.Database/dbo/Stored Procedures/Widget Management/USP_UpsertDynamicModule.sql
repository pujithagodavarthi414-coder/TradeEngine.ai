--EXEC [dbo].[USP_UpsertDynamicModule] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @DynamicModuleId= 'fd3aa09f-5bfa-4c19-b8e9-962e994c23ec', @DynamicModuleName='868',@IsArchived = 1
---------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertDynamicModule]
(
   @DynamicModuleId UNIQUEIDENTIFIER = NULL,
   @DynamicModuleName NVARCHAR(250)  = NULL,
   @Description NVARCHAR(500) = NULL,
   @ModuleIcon NVARCHAR(max) = NULL,
   @ViewRole NVARCHAR(max) = NULL,
   @EditRole NVARCHAR(max) = NULL,
   @DynamicTabsXML XML = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@DynamicModuleName = '') SET @DynamicModuleName = NULL

	    IF(@DynamicModuleName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'DynamicModuleName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @DynamicModuleNameCount INT = (SELECT COUNT(1) FROM DynamicModule WHERE DynamicModuleName = @DynamicModuleName AND (Id <> @DynamicModuleId OR @DynamicModuleId IS NULL) AND InActiveDateTime IS NULL AND CompanyId = @CompanyId )

												  SELECT  IIF([Table].[Column].value('DynamicTabId[1]', 'varchar(1000)') ='',NULL,[Table].[Column].value('DynamicTabId[1]', 'uniqueidentifier')) DynamicTabId,
												         [Table].[Column].value('DynamicTabName[1]', 'varchar(1000)')DynamicTabName,
												         [Table].[Column].value('ViewRole[1]', 'varchar(max)')ViewRole ,
												         [Table].[Column].value('EditRole[1]', 'varchar(max)')EditRole  INTO #DynamicTabs
                                                  FROM @DynamicTabsXML.nodes('/GenericListOfDynamicTabs/ListItems/DynamicTabs') AS [Table]([Column])

					DECLARE @TabsCount INT = (SELECT COUNT(1) FROM(SELECT DynamicTabName,COUNT(1) Counts FROM #DynamicTabs GROUP BY DynamicTabName)T WHERE T.Counts >1 )

		IF(@DynamicModuleNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'DynamicModule')

		END		
		ELSE IF(@TabsCount >0)
		BEGIN

		RAISERROR(50001,16,1,'DynamicTab')

		END
		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = 
				(CASE WHEN @DynamicModuleId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM DynamicModule WHERE Id = @DynamicModuleId ) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			        
			       IF(@DynamicModuleId IS NULL)
				   BEGIN

				    SET @DynamicModuleId = NEWID()

			        INSERT INTO [dbo].DynamicModule(
			                    [Id],
			                    [DynamicModuleName],
								[Description],
								ModuleIcon,
								ViewRole,
								EditRole,
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId
								)
			             SELECT @DynamicModuleId,
			                    @DynamicModuleName,
								@Description,
								@ModuleIcon,
								@ViewRole,
								@EditRole,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId

                    INSERT INTO DynamicTab(
					            Id,
								DynamicModuleId,
								DynamicTabName,
								ViewRole,
								EditRole,
								CreatedByUserId,
								CreatedDateTime
					            )
						SELECT NEWID(),
						        @DynamicModuleId,
			                    DynamicTabName,
								ViewRole,
								EditRole,
			                    @OperationsPerformedBy,
								@Currentdate FROM #DynamicTabs
                    

					END
					ELSE
					BEGIN

				       	UPDATE [dbo].DynamicModule
			             SET    [DynamicModuleName] = @DynamicModuleName,
						        [ModuleIcon] = @ModuleIcon,
								[ViewRole] = @ViewRole,
								[EditRole] = @EditRole,
								[Description] = @Description,
			                    [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END, 
			                    [UpdatedDateTime] = @Currentdate,
			                    [UpdatedByUserId] = @OperationsPerformedBy,
								CompanyId = @CompanyId
							WHERE Id = @DynamicModuleId
				    	
      DELETE FROM DynamicTab  WHERE  DynamicModuleId = @DynamicModuleId AND Id NOT IN (SELECT DynamicTabId FROM #DynamicTabs WHERE DynamicTabId IS NOT NULL)

                    INSERT INTO DynamicTab(
					            Id,
								DynamicModuleId,
								DynamicTabName,
								ViewRole,
								EditRole,
								CreatedByUserId,
								CreatedDateTime
					            )
						SELECT NEWID(),
						        @DynamicModuleId,
			                    DynamicTabName,
								ViewRole,
								EditRole,
			                    @OperationsPerformedBy,
								@Currentdate 
								FROM #DynamicTabs
								WHERE DynamicTabId IS NULL

					  UPDATE DynamicTab SET 
					            DynamicTabName = T.DynamicTabName,
								UpdatedByUserId = @OperationsPerformedBy,
								ViewRole = t.ViewRole,
								EditRole = t.EditRole,
								UpdatedDateTime = @Currentdate
								FROM  #DynamicTabs T
								WHERE T.DynamicTabId = DynamicTab.Id and t.DynamicTabId IS NOT NULL

					END
                   
					SELECT Id FROM [dbo].DynamicModule WHERE Id = @DynamicModuleId

					END	
					ELSE

			  		RAISERROR (50008,11, 1)
				END
				
				ELSE
				BEGIN

						RAISERROR (@HavePermission,11, 1)
						
				END
			END
	    END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END