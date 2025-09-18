CREATE PROCEDURE [dbo].[USP_UpsertCustomWidget]
( 
	@CustomWidgetId UNIQUEIDENTIFIER = NULL,
	@CustomWidgetName NVARCHAR(800) = NULL,
	@Description NVARCHAR(1000) = NULL,
	@IsQuery bit = NULL,
    @IsMongoQuery bit = NULL,
	@WidgetQuery NVARCHAR(MAX) = NULL,
	@RoleIds XML = NULL,
	@ChartsDeatils XML = NULL,
	@IsArchived BIT = NULL,
	@IsEditable BIT = NULL,
	@IsProc BIT = NULL,
	@IsApi BIT = NULL,
	@ProcName NVARCHAR(250) = NULL,
	@DefaultColumnsXml XML = NULL,
	@ModuleIdsXML XML = NULL,
	@TagsXml XML = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
    @CollectionName NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
        IF(@CustomWidgetId = '00000000-0000-0000-0000-000000000000') SET @CustomWidgetId = NULL
        IF(@CustomWidgetName = '') SET @CustomWidgetName = NULL

		
					DECLARE @OldCustomWidgetName NVARCHAR(800) = NULL,
					         @OldWidgetQuery NVARCHAR(mAX) = NULL
                

		IF(@IsEditable IS NULL)SET @IsEditable = 0

        IF(@CustomWidgetName IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'CustomWidgetName')
        END
        ELSE
        BEGIN
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        DECLARE @WidgetsCount INT = (SELECT COUNT(1) FROM CustomWidgets WHERE Id = @CustomWidgetId AND CompanyId = @CompanyId)
        DECLARE @WidgetNameCount INT = 0
		
		SELECT @WidgetNameCount = COUNT(1),@OldCustomWidgetName = CustomWidgetName,@OldWidgetQuery = WidgetQuery FROM CustomWidgets 
		WHERE CustomWidgetName = @CustomWidgetName AND CompanyId = @CompanyId
		GRoUP BY CustomWidgetName,WidgetQuery

        IF(@WidgetsCount = 0 AND @CustomWidgetId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 1,'CustomWidget')
        END
        ELSE IF(@WidgetNameCount > 0 AND @CustomWidgetId IS NULL)
        BEGIN
            RAISERROR(50001,16,1,'CustomWidget')
        END     
        ELSE
        BEGIN
            DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
            IF (@HavePermission = '1')
            BEGIN
                    DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @NewWidgetId UNIQUEIDENTIFIER = NEWID()
                
                IF(@CustomWidgetId IS NULL)
                BEGIN
                    
                    
                    
                    INSERT INTO [dbo].CustomWidgets(
                                [Id],
                                [CustomWidgetName],
                                [WidgetQuery],
                                [CreatedByUserId],
                                [CreatedDateTime],
                                [CompanyId],
								[IsEditable],
                                [Description],
								[IsProc],
								[IsApi],
								[ProcName],
								[IsQuery],
                                [IsMongoQuery],
                                [CollectionName])
                         SELECT @NewWidgetId,
                                @CustomWidgetName,
                                @WidgetQuery,
                                @OperationsPerformedBy,
                                @Currentdate,
                                @CompanyId,
								@IsEditable,
                                @Description,
								@IsProc,
								@IsApi,
								@ProcName,
								@IsQuery,
                                @IsMongoQuery,
                                @CollectionName
								

			
				   
				   IF(@CustomWidgetName IS NOT NULL)
                    BEGIN
                     INSERT INTO CustomWidgetHistory(
                                [Id],
                                [CustomWidgetId],
                                [FieldName],
                                [NewValue],
                                [CreatedByUserId],
                                [CreatedDateTime])
                        SELECT NEWID(),
                                @NewWidgetId,
                                'WidgetName',
                                @CustomWidgetName,
                                @OperationsPerformedBy,
                                @Currentdate
                    END 
                    IF(@WidgetQuery IS NOT NULL)
                    BEGIN
                      INSERT INTO CustomWidgetHistory(
                                [Id],
                                [CustomWidgetId],
                                [FieldName],
                                [NewValue],
                                [CreatedByUserId],
                                [CreatedDateTime])
                        SELECT NEWID(),
                                @NewWidgetId,
                                'WidgetQuery',
                                @WidgetQuery,
                                @OperationsPerformedBy,
                                @Currentdate
                    END

					
						DECLARE @DefaultCoulmnDetail TABLE
                (  
					[CustomWidgetId] UNIQUEIDENTIFIER,
                    [Field] VARCHAR(MAX) NULL,
                    [Filter] VARCHAR(MAX) NULL,
					[IsNullable]  BIT NULL,
					[MaxLength] VARCHAR(MAX) NULL,
                    [SubQuery] NVARCHAR(MAX) NULL,
                    [SubQueryTypeId] NVARCHAR(MAX) NULL,
					[ColumnFormatTypeId] NVARCHAR(MAX) NULL,
					[Hidden] BIT NULL,
					[Width] DECIMAL NULL,
					[ColumnAltName] VARCHAR(MAX) NULL
                ) 

				INSERT INTO @DefaultCoulmnDetail(CustomWidgetId,Field,[Filter],[IsNullable],[MaxLength],SubQuery,SubQueryTypeId,ColumnFormatTypeId,[Hidden],[Width],[ColumnAltName])
                SELECT  @NewWidgetId,
						x.y.value('Field[1]', 'NVARCHAR(MAX)'),
						x.y.value('Filter[1]', 'NVARCHAR(MAX)'),
						x.y.value('IsNullable[1]', 'BIT'),
						x.y.value('MaxLength[1]', 'VARCHAR(MAX)'),
						x.y.value('SubQuery[1]', 'NVARCHAR(MAX)'),
						CASE WHEN x.y.value('SubQueryTypeId[1]', 'NVARCHAR(MAX)') = '' OR x.y.value('SubQueryTypeId[1]', 'NVARCHAR(MAX)') = NULL THEN NULL 
						ELSE x.y.value('SubQueryTypeId[1]', 'NVARCHAR(MAX)') END,
						CASE WHEN x.y.value('ColumnFormatTypeId[1]', 'NVARCHAR(MAX)') = '' OR x.y.value('ColumnFormatTypeId[1]', 'NVARCHAR(MAX)') = NULL THEN NULL 
						ELSE x.y.value('ColumnFormatTypeId[1]', 'NVARCHAR(MAX)') END,
						x.y.value('Hidden[1]', 'BIT'),
						x.y.value('Width[1]', 'DECIMAL'),
						x.y.value('ColumnAltName[1]', 'NVARCHAR(MAX)')
						FROM @DefaultColumnsXml.nodes('/ArrayOfCustomWidgetHeaderModel/CustomWidgetHeaderModel') AS x(y)

						SELECT [Field] INTO #Fields FROM @DefaultCoulmnDetail

					Merge CustomAppColumns AS TARGET
					Using @DefaultCoulmnDetail AS SOURCE
					ON TARGET.ColumnName = SOURCE.Field  AND TARGET.CompanyId = @CompanyId AND Target.CustomWidgetId = @NewWidgetId
					 WHEN MATCHED 
					 THEN
					 UPDATE SET [ColumnName] = SOURCE.[Field],
					 ColumnType = SOURCE.[Filter],
					 [IsNullable] = SOURCE.[IsNullable],
					 [MaxLength] = SOURCE.[MaxLength],
					 [SubQuery] = SOURCE.[SubQuery],
					 [SubQueryTypeId] = CAST(SOURCE.[SubQueryTypeId] AS UNIQUEIDENTIFIER),
					 [ColumnFormatTypeId] = CAST(SOURCE.[ColumnFormatTypeId] AS UNIQUEIDENTIFIER),
					 ColumnAltName = SOURCE.[ColumnAltName],
        		   [UpdatedDateTime] = GETUTCDATE(),
				   [Hidden] = SOURCE.[Hidden],
				   [Width] = SOURCE.[Width]
				    WHEN NOT MATCHED BY TARGET  
					 THEN 
					INSERT (Id,CustomWidgetId,ColumnName,ColumnType,CompanyId,CreatedByUserId,CreatedDateTime,UpdatedByUserId,UpdatedDateTime,[IsNullable],[MaxLength],[Hidden],[Width],[SubQueryTypeId],[ColumnFormatTypeId],[ColumnAltName]) Values
					(newID(),@NewWidgetId,SOURCE.Field,SOURCE.[Filter],@companyId,@OperationsPerformedBy,GETUTCDATE()
					,@OperationsPerformedBy,GETUTCDATE(),SOURCE.[IsNullable],SOURCE.[MaxLength],SOURCE.[Hidden],SOURCE.[Width],CAST(SOURCE.[SubQueryTypeId] AS UNIQUEIDENTIFIER),CAST(SOURCE.[ColumnFormatTypeId] AS UNIQUEIDENTIFIER),[ColumnAltName])
					WHEN NOT MATCHED BY SOURCE AND TARGET.ColumnName NOT IN (SELECT [Field] FROM #Fields)  AND TARGET.CompanyId = @CompanyId  AND Target.CustomWidgetId = @NewWidgetId
					THEN DELETE;
					DROP TABLE #Fields

                END
                ELSE
                BEGIN
				DECLARE @DefaultCoulmnDetails TABLE
                (  
					[CustomWidgetId] UNIQUEIDENTIFIER,
                    [Field] VARCHAR(MAX) NULL,
                    [Filter] VARCHAR(MAX) NULL,
					[IsNullable]  BIT NULL,
					[MaxLength] VARCHAR(MAX) NULL,
                    [SubQuery] NVARCHAR(MAX) NULL,
                    [SubQueryTypeId] NVARCHAR(MAX) NULL,
					[ColumnFormatTypeId] NVARCHAR(MAX) NULL,
					[Hidden] BIT NULL,
					[Width] DECIMAL NULL,
					[ColumnAltName] VARCHAR(MAX) NULL
                ) 

				INSERT INTO @DefaultCoulmnDetails(CustomWidgetId,Field,[Filter],[IsNullable],[MaxLength],SubQuery,SubQueryTypeId,ColumnFormatTypeId,[Hidden],[Width],[ColumnAltName])
                SELECT  @CustomWidgetId,
						x.y.value('Field[1]', 'NVARCHAR(MAX)'),
						x.y.value('Filter[1]', 'NVARCHAR(MAX)'),
						x.y.value('IsNullable[1]', 'BIT'),
						x.y.value('MaxLength[1]', 'VARCHAR(MAX)'),
						x.y.value('SubQuery[1]', 'NVARCHAR(MAX)'),
						CASE WHEN x.y.value('SubQueryTypeId[1]', 'NVARCHAR(MAX)') = '' OR x.y.value('SubQueryTypeId[1]', 'NVARCHAR(MAX)') = NULL THEN NULL 
						ELSE x.y.value('SubQueryTypeId[1]', 'NVARCHAR(MAX)') END,
						CASE WHEN x.y.value('ColumnFormatTypeId[1]', 'NVARCHAR(MAX)') = '' OR x.y.value('ColumnFormatTypeId[1]', 'NVARCHAR(MAX)') = NULL THEN NULL 
						ELSE x.y.value('ColumnFormatTypeId[1]', 'NVARCHAR(MAX)') END,
						x.y.value('Hidden[1]', 'BIT'),
						x.y.value('Width[1]', 'DECIMAL'),
						x.y.value('ColumnAltName[1]', 'NVARCHAR(MAX)')
						FROM @DefaultColumnsXml.nodes('/ArrayOfCustomWidgetHeaderModel/CustomWidgetHeaderModel') AS x(y)

						SELECT [Field] INTO #Field FROM @DefaultCoulmnDetails

					Merge CustomAppColumns AS TARGET
					Using @DefaultCoulmnDetails AS SOURCE
					ON TARGET.ColumnName = SOURCE.Field  AND TARGET.CompanyId = @CompanyId AND Target.CustomWidgetId = @CustomWidgetId
					 WHEN MATCHED 
					 THEN
					 UPDATE SET [ColumnName] = SOURCE.[Field],
					 ColumnType = SOURCE.[Filter],
					 [IsNullable] = SOURCE.[IsNullable],
					 [MaxLength] = SOURCE.[MaxLength],
					 [SubQuery] = SOURCE.[SubQuery],
					 [SubQueryTypeId] = CAST(SOURCE.[SubQueryTypeId] AS UNIQUEIDENTIFIER),
					  [ColumnFormatTypeId] = CAST(SOURCE.[ColumnFormatTypeId] AS UNIQUEIDENTIFIER),
        		   [UpdatedDateTime] = GETUTCDATE(),
				   [Hidden] = SOURCE.[Hidden],
				   [Width] = SOURCE.[Width],
				   [ColumnAltName]=SOURCE.[ColumnAltName]
				    WHEN NOT MATCHED BY TARGET  
					 THEN 
					INSERT (Id,CustomWidgetId,ColumnName,ColumnType,CompanyId,CreatedByUserId,CreatedDateTime,UpdatedByUserId,UpdatedDateTime,[IsNullable],[MaxLength],[Hidden],[Width],[SubQueryTypeId],[ColumnFormatTypeId],[ColumnAltName]) Values
					(newID(),@CustomWidgetId,SOURCE.Field,SOURCE.[Filter],@companyId,@OperationsPerformedBy,GETUTCDATE()
					,@OperationsPerformedBy,GETUTCDATE(),SOURCE.[IsNullable],SOURCE.[MaxLength],SOURCE.[Hidden],SOURCE.[Width],CAST(SOURCE.[SubQueryTypeId] AS UNIQUEIDENTIFIER),CAST(SOURCE.[ColumnFormatTypeId] AS UNIQUEIDENTIFIER),[ColumnAltName]);
					DROP TABLE #Field

                    IF( @OldCustomWidgetName <> @CustomWidgetName)
                    BEGIN
                      IF(@CustomWidgetName IS NULL) SET @CustomWidgetName = ''
                         INSERT INTO CustomWidgetHistory(
                                [Id],
                                [CustomWidgetId],
                                [FieldName],
                                [OldValue],
                                [NewValue],
                                [CreatedByUserId],
                                [CreatedDateTime])
                        SELECT NEWID(),
                                ISNULL(@CustomWidgetId,@NewWidgetId),
                                'WidgetName',
                                @OldCustomWidgetName,
                                @CustomWidgetName,
                                @OperationsPerformedBy,
                                @Currentdate
                    END
                    IF(@OldWidgetQuery <> @WidgetQuery)
                    BEGIN
                    
                      IF(@WidgetQuery IS NULL) SET @WidgetQuery = ''
                          INSERT INTO CustomWidgetHistory(
                                [Id],
                                [CustomWidgetId],
                                [FieldName],
                                [OldValue],
                                [NewValue],
                                [CreatedByUserId],
                                [CreatedDateTime])
                        SELECT NEWID(),
                                ISNULL(@CustomWidgetId,@NewWidgetId),
                                'WidgetQuery',
                                @OldWidgetQuery,
                                @WidgetQuery,
                                @OperationsPerformedBy,
                                @Currentdate
                    END
                    
                    UPDATE [dbo].CustomWidgets SET 
                                [CustomWidgetName] = @CustomWidgetName,
                                [Description] = @Description,
								[IsQuery] = @IsQuery,
                                [WidgetQuery] = @WidgetQuery,
                                InActiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                [UpdatedDateTime] = @Currentdate,
                                [UpdatedByUserId] = @OperationsPerformedBy,
								[IsProc] = @IsProc,
								[IsApi] = @IsApi,
								[ProcName] = @ProcName,
                                [IsMongoQuery] = @IsMongoQuery,
                                [CollectionName] = @CollectionName
                        WHERE Id = @CustomWidgetId
                END

				IF(@TagsXml IS NOT NULL)
					BEGIN
						   CREATE TABLE #Temp
						   (
						   Id UNIQUEIDENTIFIER
						   )
						   INSERT INTO #Temp
						   SELECT  [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') TagId FROM
							@TagsXml.nodes('ArrayOfGuid/guid') AS [Table]([Column])

					DELETE FROM CustomTags  WHERE ReferenceId = ISNULL(@CustomWidgetId,@NewWidgetId) 
					AND TagId NOT IN (SELECT Id FROM #Temp)

			        INSERT INTO [dbo].CustomTags(
			                    [Id],
			                    [ReferenceId],
								[TagId],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
			                    )
                         SELECT NEWID(),
						        ISNULL(@CustomWidgetId,@NewWidgetId),
							    T.Id,
								@Currentdate,
								@OperationsPerformedBy
							 FROM #Temp T LEFT JOIN CustomTags CT ON T.Id = CT.TagId AND CT.ReferenceId = @CustomWidgetId
							 WHERE CT.TagId IS NULL
                   
				   END
                 
				-- 	INSERT INTO [dbo].[CustomAppColumns](Id,CustomWidgetId,ColumnName,ColumnType,SubQuery,SubQueryTypeId,CompanyId,CreatedByUserId,CreatedDateTime,UpdatedByUserId,UpdatedDateTime,	
				--				[IsNullable],[MaxLength],[Hidden],[Width])
				--SELECT  NEWID(),
				--		ISNULL(@CustomWidgetId,@NewWidgetId),
				--		x.y.value('Field[1]', 'VARCHAR(MAX)'),
				--		x.y.value('Filter[1]', 'VARCHAR(MAX)'),
				--		x.y.value('SubQuery[1]', 'NVARCHAR(MAX)'),
				--		CASE WHEN x.y.value('SubQueryTypeId[1]', 'NVARCHAR(MAX)') = '' OR x.y.value('SubQueryTypeId[1]', 'NVARCHAR(MAX)') = NULL THEN NULL 
				--		ELSE CAST(x.y.value('SubQueryTypeId[1]', 'NVARCHAR(MAX)') AS UNIQUEIDENTIFIER)  END,
				--		@CompanyId,
				--		@OperationsPerformedBy,
				--		GETUTCDATE(),
				--		@OperationsPerformedBy,
				--		GETUTCDATE(),
				--		x.y.value('IsNullable[1]', 'BIT'),
				--		x.y.value('MaxLength[1]', 'VARCHAR(MAX)'),
				--		x.y.value('Hidden[1]', 'BIT'),
				--		x.y.value('Width[1]', 'DECIMAL')
				--		FROM @DefaultColumnsXml.nodes('/ArrayOfCustomWidgetHeaderModel/CustomWidgetHeaderModel') AS x(y)

              IF(@ModuleIdsXML IS NOT NULL)
			  BEGIN

			   CREATE TABLE #WigetModulesList 
                (
                    ModuleId [uniqueidentifier] INDEX IX1_ModuleId CLUSTERED
                ) 
                
                INSERT INTO #WigetModulesList(ModuleId)
                SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)')
                FROM @ModuleIdsXML.nodes('/ArrayOfGuid/guid') AS [Table]([Column])

				UPDATE WidgetModuleConfiguration SET InActiveDateTime =  @Currentdate WHERE WidgetId =  ISNULL(@CustomWidgetId ,@NewWidgetId)  AND InActiveDateTime IS NULL AND  ISNULL(@CustomWidgetId ,@NewWidgetId)  IS NOT NULL

				 INSERT INTO [dbo].[WidgetModuleConfiguration](
                            [Id],
                            [WidgetId],
                            [ModuleId],
                            [CreatedDateTime],
                            [CreatedByUserId])
                     SELECT NEWID(),
                            ISNULL(@CustomWidgetId ,@NewWidgetId), 
                            ModuleId,
                            @Currentdate,
                            @OperationsPerformedBy
                       FROM #WigetModulesList
               
			   END

                CREATE TABLE #WigetRoles 
                (
                    [RoleId] [uniqueidentifier] NULL  INDEX IX2_RoleId CLUSTERED
                ) 
                
                INSERT INTO #WigetRoles(RoleId)
                SELECT [Table].[Column].value('(text())[1]', 'Nvarchar(250)')
                FROM @RoleIds.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                
                UPDATE [dbo].CustomWidgetRoleConfiguration SET 
                                InActiveDateTime = @Currentdate,
                                [UpdatedDateTime] = @Currentdate,
                                [UpdatedByUserId] = @OperationsPerformedBy
                        WHERE CustomWidgetId = @CustomWidgetId
         
                INSERT INTO [dbo].CustomWidgetRoleConfiguration(
                            [Id],
                            [CustomWidgetId],
                            [RoleId],
                            [CreatedDateTime],
                            [CreatedByUserId])
                     SELECT NEWID(),
                          ISNULL(@CustomWidgetId ,@NewWidgetId), 
                          T.RoleId,
                          @Currentdate,
                          @OperationsPerformedBy
                    FROM #WigetRoles T
				

                DECLARE @WidgetVisulizationDetails TABLE
                (  
					[WidgetVisulizationDetailId] UNIQUEIDENTIFIER,
                    [ChartId] UNIQUEIDENTIFIER,
                    [VisulaizationName] NVARCHAR(MAX) NULL,
					[PersistanceJson]  NVARCHAR(MAX) NULL,
					[PivotMeasurersToDisplay] NVARCHAR(MAX) NULL,
                    [XCoOrdinate] NVARCHAR(MAX) NULL,
                    [YCoOrdinate] NVARCHAR(MAX) NULL,
                    [ChartType] NVARCHAR(MAX) NULL,
                    [IsDefault] BIT NULL,
                    [FilterQuery] NVARCHAR(MAX) NULL,
					[ColumnFormatQuery] NVARCHAR(MAX) NULL,
                    [DefaultColumns] NVARCHAR(MAX) NULL,
					[HeatMapMeasure] NVARCHAR(MAX) NULL,
					[ColumnAltName] NVARCHAR(MAX) NULL,
					[ChartColorJson] NVARCHAR(MAX) NULL
                ) 
                
               INSERT INTO @WidgetVisulizationDetails(WidgetVisulizationDetailId,ChartId,VisulaizationName,PersistanceJson,PivotMeasurersToDisplay,XCoOrdinate,YCoOrdinate,ChartType,IsDefault,FilterQuery,ColumnFormatQuery,DefaultColumns,HeatMapMeasure,[ColumnAltName],[ChartColorJson])
                SELECT NEWID()
				   ,CASE WHEN x.y.value('CustomApplicationChartId[1]','nvarchar(200)') = '' THEN NULL ELSE x.y.value('CustomApplicationChartId[1]','uniqueidentifier') END
                   ,x.y.value('VisualizationName[1]', 'NVARCHAR(MAX)')
				   ,x.y.value('PersistanceJson[1]', 'NVARCHAR(MAX)')
				   ,x.y.value('PivotMeasurersToDisplay[1]', 'NVARCHAR(MAX)')
                   ,x.y.value('XCoOrdinate[1]', 'NVARCHAR(MAX)')
                   ,x.y.value('YAxisDetails[1]', 'NVARCHAR(MAX)')
                   ,x.y.value('VisualizationType[1]', 'NVARCHAR(MAX)')
                   ,x.y.value('IsDefault[1]', 'BIT')
                   ,x.y.value('FilterQuery[1]', 'NVARCHAR(MAX)')
				    ,x.y.value('ColumnFormatQuery[1]', 'NVARCHAR(MAX)')
                   ,x.y.value('DefaultColumnsXml[1]', 'NVARCHAR(MAX)')
				   ,x.y.value('HeatMapMeasure[1]', 'NVARCHAR(MAX)')
				   ,x.y.value('ColumnAltName[1]', 'NVARCHAR(MAX)')
				   ,x.y.value('ChartColorJson[1]', 'NVARCHAR(MAX)')
              FROM @ChartsDeatils.nodes('/ArrayOfCustomAppChartModel/CustomAppChartModel') AS x(y)



              IF(@IsArchived IS NULL)
              BEGIN
              
			  CREATE TABLE #WidgetIds 
			  (
				Id UNIQUEIDENTIFIER
			  )

			  INSERT INTO #WidgetIds(Id)
			  SELECT Id FROM WorkspaceDashboards WSD WHERE CustomAppVisualizationId IN (
			  SELECT CAD.Id FROM CustomAppDetails CAD LEFT JOIN @WidgetVisulizationDetails WV ON WV.ChartId = CAD.Id AND CAD.IsDefault = 1
			  WHERE WV.ChartId IS NULL AND CAD.CustomApplicationId = @CustomWidgetId AND @CustomWidgetId IS not NULL
			  )

			  DELETE FROM CustomAppDetails WHERE CustomApplicationId = @CustomWidgetId AND Id NOT IN (SELECT ChartId FROM @WidgetVisulizationDetails WHERE ChartId IS NOT NULL)

                UPDATE CustomAppDetails SET [IsDefault] = CAD.IsDefault,
                                            [VisualizationName] = CAD.[VisulaizationName],
                                            [visualizationType] = CAD.[ChartType],											
											[PivotMeasurersToDisplay] = CAD.[PivotMeasurersToDisplay],
                                            [XCoOrdinate] = CAD.XCoOrdinate,
                                            [YCoOrdinate] = CAD.YCoOrdinate,
                                            [FilterQuery]  = CAD.FilterQuery,
                                            [DefaultColumns]  = CAD.DefaultColumns,
                                            [UpdatedDateTime]  = @Currentdate,
                                            [UpdatedByUserId] = @OperationsPerformedBy,
											[HeatMapMeasure] = CAD.HeatMapMeasure,
											[ColumnFormatQuery] = CAD.ColumnFormatQuery,
											[ColumnAltName] = CAD.[ColumnAltName],
                                            ChartColorJson = CAD.ChartColorJson
                                            FROM CustomAppDetails WVD JOIN @WidgetVisulizationDetails CAD  ON CAD.ChartId = WVD.Id

			  INSERT INTO CustomAppDetails(
                            [Id],
                            [CustomApplicationId],
                            [IsDefault],
                            [VisualizationName],
                            [visualizationType],
							[PivotMeasurersToDisplay],
                            [XCoOrdinate],
                            [YCoOrdinate],
                            [FilterQuery],
                            [DefaultColumns],
							[HeatMapMeasure],
                            [CreatedDateTime],
                            [CreatedByUserId],
							[ColumnFormatQuery],
							ColumnAltName,
                            ChartColorJson
                            )
                            SELECT WD.WidgetVisulizationDetailId,
                            ISNULL(@CustomWidgetId ,@NewWidgetId),
                            WD.IsDefault,
                            WD.VisulaizationName,
                            WD.ChartType,
							WD.PivotMeasurersToDisplay,
                            WD.XCoOrdinate,
                            WD.YCoOrdinate,
                            WD.FilterQuery,
                            WD.DefaultColumns,
							WD.HeatMapMeasure,
                            @Currentdate,
                            @OperationsPerformedBy,
							WD.ColumnFormatQuery,
							WD.ColumnAltName,
                            WD.ChartColorJson
                            FROM @WidgetVisulizationDetails WD WHERE ChartId IS NULL

							
					INSERT INTO [Persistance]( [Id]
											,[ReferenceId]
											,[IsUserLevel]
											,[PersistanceJson]
											,[UserId]
											,[CreatedByUserId]
											,[CreatedDateTime])
								SELECT NEWID(),
									   WD.WidgetVisulizationDetailId,
									   0,
									   WD.PersistanceJson,
									   null,
									   @OperationsPerformedBy,
									   @Currentdate
									   FROM @WidgetVisulizationDetails WD
 


					UPDATE WorkspaceDashboards SET CustomAppVisualizationId = (SELECT Id FROM [dbo].CustomAppDetails WHERE [CustomApplicationId] = ISNULL(@CustomWidgetId ,@NewWidgetId) AND IsDefault = 1)
					WHERE Id In (SELECT Id FROM #WidgetIds)

                END
                SELECT Id FROM [dbo].CustomWidgets WHERE Id = ISNULL(@CustomWidgetId ,@NewWidgetId)
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