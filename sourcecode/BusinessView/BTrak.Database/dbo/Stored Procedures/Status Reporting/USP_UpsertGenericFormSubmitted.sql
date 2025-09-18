-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-09-30 00:00:00.000'
-- Purpose      To Update or Save Submitted GenericForms
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertGenericFormSubmitted] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@CustomApplicationId = '06C33C48-F600-4CCF-9E3F-D794A699C398',@FormJson = '{"textField":"dd","employeeName":"qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq","employeeSummary":"ddd"}'
 
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertGenericFormSubmitted]
(
	@GenericFormSubmittedId UNIQUEIDENTIFIER = NULL,
    @CustomApplicationId UNIQUEIDENTIFIER = NULL,
    @DataSetId UNIQUEIDENTIFIER = NULL,
    @DataSourceId UNIQUEIDENTIFIER = NULL,
    @FormId UNIQUEIDENTIFIER = NULL,
    @FormJson NVARCHAR(MAX) = NULL,
	@OperationsPerformedBy  UNIQUEIDENTIFIER = NULL,
    @IsArchived BIT = NULL,
    @IsApproved BIT = NULL,
    @IsFinalSubmit BIT = NULL,
	@PublicFormId UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  IF (@GenericFormSubmittedId = '00000000-0000-0000-0000-000000000000') SET @GenericFormSubmittedId = NULL
		DECLARE @Currentdate DATETIME = GETDATE(),@TodayCount INT

		IF(@PublicFormId IS NOT NULL)
		BEGIN
			SET @CustomApplicationId = (SELECT CustomApplicationId FROM CustomApplicationForms WHERE ID = @PublicFormId)
			SET @FormId = (SELECT GenericFormId FROM CustomApplicationForms WHERE ID = @PublicFormId)
		END

		 IF (@IsFinalSubmit IS NULL) SET @IsFinalSubmit = 0
	  
		--IF(@CustomApplicationId IS NULL)
		--BEGIN
		 
		--	RAISERROR(50011,16, 2, 'CustomApplication')

		--END
		--ELSE 
		IF(@FormJson IS NULL)
		BEGIN
		 
			RAISERROR(50011,16, 2, 'Formjson')

		END
		ELSE 
		BEGIN

			DECLARE @GenericFormSubmittedIdCount INT = (SELECT COUNT(1) FROM GenericFormSubmitted WHERE Id = @GenericFormSubmittedId)

			IF(@GenericFormSubmittedIdCount = 0 AND @GenericFormSubmittedId IS NOT NULL)
			BEGIN

				RAISERROR(50002,16,1,'GenericFormSubmitted')

			END
			ELSE
			BEGIN

				SET @TodayCount = (SELECT COUNT(1) FROM GenericFormSubmitted GFS WHERE CAST(CreatedDateTime AS DATE) = CAST(GETDATE() AS DATE))

				
				CREATE TABLE #Temp  
				(
					Id INT IDENTITY(1,1)
					,SourceKey NVARCHAR(250)
					,LogicalOperation NVARCHAR(5)
					,SourceValue NVARCHAR(250)
					,DestinationKey NVARCHAR(250)
					,DestinationValue NVARCHAR(250)
				)

				INSERT INTO #Temp(SourceKey,LogicalOperation,SourceValue,DestinationKey,DestinationValue)
				SELECT JSON_VALUE(Rulejson,'$.sourceKey') AS SourceKey
					   ,JSON_VALUE(Rulejson,'$.logicalOperation') AS LogicalOperation
					   ,JSON_VALUE(Rulejson,'$.sourceValue') AS SourceValue
					   ,JSON_VALUE(Rulejson,'$.destinationKey') AS DestinationKey
					   ,JSON_VALUE(Rulejson,'$.destinationValue') AS DestinationValue
				FROM CustomApplicationWorkflow WHERE CustomApplicationId = @CustomApplicationId AND WorkFlowTypeId = '0361770A-3F6D-4C86-AC7D-E2FA0DE428CA' --Type-1

				DECLARE @TableLength INT = (SELECT COUNT(1) FROM #Temp)

				DECLARE @Flag INT = 1 --(SELECT MIN(Id) FROM #Temp)
				,@SqlQuery NVARCHAR(MAX)
				,@SqlQuery1 NVARCHAR(MAX)
				    
				DECLARE @SourceValue NVARCHAR(MAX) = ''
				DECLARE @ModifiedJson NVARCHAR(MAX) = '',@QueryResult NVARCHAR(MAX) = ''

				WHILE(@Flag < = @TableLength)
				BEGIN
				    SET @QueryResult = ''
					SELECT @SqlQuery1 = 'SELECT @QueryResult = (JSON_VALUE('''+ @FormJson + ''',''$.' + SourceKey + '''))' 
					FROM #Temp WHERE Id = @Flag
				
				    SET @SourceValue = ''
				
					EXEC SP_EXECUTESQL @SqlQuery1,
					N'@QueryResult NVARCHAR(MAX) OUT',@SourceValue OUT
				
					IF(@SourceValue IS NOT NULL AND @SourceValue <> '')
					BEGIN
						
						SET @ModifiedJson = ''
				
						SELECT @SqlQuery = 'IF(''' + @SourceValue + '''' + LogicalOperation + '''' + SourceValue + ''')
						                      BEGIN 
													SET @FormJsonTemp = JSON_MODIFY(''' + @FormJson +''', ''$.' + DestinationKey + ''', ''' + DestinationValue + ''')
											  END'
						FROM #Temp
				        WHERE Id = @Flag

						EXEC SP_EXECUTESQL @SqlQuery, N'@FormJsonTemp NVARCHAR(MAX) OUT', @ModifiedJson OUT
				

						SET @FormJson = CASE WHEN @ModifiedJson = '' THEN @FormJson ELSE @ModifiedJson END
				
					END
				
					SELECT @Flag = @Flag + 1,@SqlQuery1 = NULL
				
				END

				CREATE TABLE #Temp1  
				(
					Id INT IDENTITY(1,1)
					,SourceKey NVARCHAR(250)
					,LogicalOperation NVARCHAR(5)
					,SourceValue NVARCHAR(250)
					,CustomApplicationKeyValues NVARCHAR(MAX)
					,CustomApplicationId UNIQUEIDENTIFIER
					,DestinationformId UNIQUEIDENTIFIER
				)

				INSERT INTO #Temp1(SourceKey,LogicalOperation,SourceValue,CustomApplicationKeyValues,CustomApplicationId,DestinationformId)
				SELECT JSON_VALUE(Rulejson,'$.sourceKey') AS SourceKey
					   ,JSON_VALUE(Rulejson,'$.logicalOperation') AS LogicalOperation
					   ,JSON_VALUE(Rulejson,'$.sourceValue') AS SourceValue
					   ,JSON_VALUE(Rulejson,'$.customApplicationKeyValues') AS CustomApplicationKeyValues
					   ,JSON_VALUE(Rulejson,'$.customApplicationId') AS CustomApplicationId
					   ,JSON_VALUE(Rulejson,'$.destinationFormId') AS DestinationFormId
				FROM CustomApplicationWorkflow WHERE CustomApplicationId = @CustomApplicationId AND WorkFlowTypeId = '93BB9E02-41D2-4402-B53D-FF919217072B' AND FormId = @FormId--Type-2

				SET @TableLength = (SELECT COUNT(1) FROM #Temp1)
				SET @Flag = 1
				DECLARE @DestinationformId UNIQUEIDENTIFIER 

				WHILE(@Flag < = @TableLength)
				BEGIN
				
					SET @DestinationformId = (SELECT DestinationformId FROM #Temp1 WHERE Id = @Flag)
					
					SELECT @SqlQuery1 = '',@QueryResult = ''

					SELECT @SqlQuery1 = 'SELECT @QueryResult = (JSON_VALUE('''+ @FormJson + ''',''$.' + SourceKey + '''))' 
					FROM #Temp1 WHERE Id = @Flag
				
				    SET @SourceValue = ''
				
					EXEC SP_EXECUTESQL @SqlQuery1,
					N'@QueryResult NVARCHAR(MAX) OUT',@SourceValue OUT

					IF(@SourceValue IS NOT NULL AND @SourceValue <> '')
					BEGIN
						
						SET @ModifiedJson = ''
						DECLARE @Sql NVARCHAR(MAX),@Value INT,@TempCustomApplicationId UNIQUEIDENTIFIER,@Keyvalues NVARCHAR(MAX)
						SELECT @SqlQuery = 'IF(''' + @SourceValue + '''' + LogicalOperation + '''' + SourceValue + ''')
						                      BEGIN 
													SET @Value = 1
											  END'
						FROM #Temp1
				        WHERE Id = @Flag

						EXEC SP_EXECUTESQL @SqlQuery, N'@Value INT OUT', @Value OUT
				
						IF(@Value IS NOT NULL AND @Value = 1)
						BEGIN
						
						SELECT @TempCustomApplicationId = CustomApplicationId,@Keyvalues = CustomApplicationKeyValues  FROM #Temp1
				        WHERE Id = @Flag

						SELECT @QueryResult = '',@Sql = NULL					

						SELECT @Sql = COALESCE(@Sql + ',','') + ' (JSON_VALUE('''+ @FormJson + ''',''$.' + Id + ''')) as ' + Id 
									FROM [dbo].[UfnSplit](@Keyvalues)
									WHERE Id IN (SELECT GF.[Key] FROM CustomApplicationKey CA INNER JOIN GenericFormKey GF ON GF.Id = CA.GenericFormKeyId
											 AND CA.CustomApplicationId = @TempCustomApplicationId AND CA.GenericFormId = @DestinationformId AND GF.InActiveDateTime IS NULL
											 GROUP BY GF.[Key])
						SET @Sql = 'SET @QueryResult = ( SELECT ' + @Sql + ' FOR JSON PATH)'

						IF(@Sql = '') SET @Sql = NULL

						--IF(@Sql IS NULL) 
						--BEGIN 
						--	        SELECT @Sql = COALESCE(@Sql + ',','') + ' '''' as ' + GF.[Key] 
						--				FROM CustomApplicationKey CA INNER JOIN GenericFormKey GF ON GF.Id = CA.GenericFormKeyId
						--										 AND CA.CustomApplicationId = @TempCustomApplicationId AND CA.GenericFormId = @FormId
						--			SELECT @Sql = 'SET @QueryResult = ( SELECT ' + @Sql +' FOR JSON PATH )'
						--END

		           EXEC SP_EXECUTESQL @Sql,
					N'@QueryResult NVARCHAR(MAX) OUT',@QueryResult OUT

					DECLARE @Count INT = (SELECT COUNT(1) 
					                             FROM [Ufn_StringSplit](@Keyvalues,',') T 
												 WHERE T.[Value] IN (SELECT GK.[Key] 
														                    FROM CustomApplicationKey CAK 
																			JOIN GenericFormKey GK ON CAK.GenericFormId = GK.GenericFormId 
																			 AND CAK.GenericFormKeyId = GK.Id 
																			 AND CAK.CustomApplicationId = @CustomApplicationId
																			 AND CAK.GenericFormId = @DestinationformId))

					IF(@Count > 0)
					BEGIN
					DECLARE @GenericFormId UNIQUEIDENTIFIER = NEWID()

					SET @TodayCount = (SELECT COUNT(1) FROM GenericFormSubmitted GFS WHERE CAST(CreatedDateTime AS DATE) = CAST(GETDATE() AS DATE))

					INSERT INTO [dbo].[GenericFormSubmitted](
					            [Id],
								[DataSourceId],
								[DataSetId],
					            [FormJson],
								[FormId],
								[CustomApplicationId],
								[UniqueNumber],
								[IsApproved],
					            [CreatedDateTime],
					            [CreatedByUserId],
								[InActiveDateTime]
								)
					     SELECT @GenericFormId,
								@DataSourceId,
								@DataSetId,
					            SUBSTRING(@QueryResult,2,LEN(@QueryResult) - 2),
								@DestinationformId,
								@TempCustomApplicationId,
								CONVERT(NVARCHAR,FORMAT (GETDATE(), 'ddMyyyy')) + CONVERT(NVARCHAR, ISNULL(@TodayCount, 0) + 1),
								@IsApproved,
					            @Currentdate,
								@OperationsPerformedBy,
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					END
				END
						SET @FormJson = CASE WHEN @ModifiedJson = '' THEN @FormJson ELSE @ModifiedJson END
				
					END
				
					SELECT @Flag = @Flag + 1,@SqlQuery1 = NULL

				END

				SET @TodayCount = (SELECT COUNT(1) FROM GenericFormSubmitted GFS WHERE CAST(CreatedDateTime AS DATE) = CAST(GETDATE() AS DATE))

				DECLARE @UniqueNumber NVARCHAR(250)
                
                SELECT @UniqueNumber = UniqueNumber FROM GenericFormSubmitted WHERE Id = @GenericFormSubmittedId
	
				IF(@GenericFormSubmittedId IS NULL)
				BEGIN

				IF(@UniqueNumber IS NULL)
					SET @UniqueNumber = CONVERT(NVARCHAR,FORMAT (GETDATE(), 'ddMyyyy')) + CONVERT(NVARCHAR, ISNULL(@TodayCount, 0) + 1)

					IF(@PublicFormId IS NOT NULL)
						BEGIN
							SET @CustomApplicationId = (SELECT CustomApplicationId FROM CustomApplicationForms WHERE ID = @PublicFormId)
							SET @FormId = (SELECT GenericFormId FROM CustomApplicationForms WHERE ID = @PublicFormId)
						END

					SET @GenericFormSubmittedId = NEWID()

					INSERT INTO [dbo].[GenericFormSubmitted](
					            [Id],
								[DataSourceId],
								[DataSetId],
					            [FormJson],
								[FormId],
								[CustomApplicationId],
								[UniqueNumber],
								IsApproved,
					            [CreatedDateTime],
					            [CreatedByUserId],
								[InActiveDateTime]
								)
					     SELECT @GenericFormSubmittedId,
								@DataSourceId,
								@DataSetId,
					            @FormJson,
								@FormId,
								@CustomApplicationId,
								@UniqueNumber,
								@IsApproved,
					            @Currentdate,
								@OperationsPerformedBy,
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
				END
				ELSE
				BEGIN
					
					UPDATE [dbo].[GenericFormSubmitted]
					    SET [FormJson] = @FormJson
							,[DataSetId]=@DataSetId
							,DataSourceId=@DataSourceId
						    ,[CustomApplicationId] = @CustomApplicationId
							,[FormId] = @FormId
							,IsApproved = @IsApproved
							,[UpdatedByUserId] = @OperationsPerformedBy
							,[UpdatedDateTime] = @Currentdate
							,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						WHERE Id = @GenericFormSubmittedId

				END
				
				INSERT INTO [dbo].[CustomApplicationTag]([Id],GenericFormSubmittedId,GenericFormKeyId,TagValue,[CreatedDateTime],[CreatedByUserId])
				SELECT NEWID(),@GenericFormSubmittedId,CAK.GenericFormKeyId,JD.[value],@Currentdate,@OperationsPerformedBy
				FROM CustomApplicationKey CAK
				     INNER JOIN GenericFormKey GFK ON GFK.Id = CAK.GenericFormKeyId
					            AND GFK.GenericFormId = @FormId 
								AND GFK.InActiveDateTime IS NULL
					 LEFT JOIN (SELECT [key],[value] FROM OPENJSON(@FormJson)) AS JD
					           ON JD.[key] COLLATE SQL_Latin1_General_CP1_CI_AS = GFK.[Key]
				WHERE CAK.GenericFormId = @FormId
				      AND CAK.CustomApplicationId = @CustomApplicationId
					  AND CAK.IsTag  = 1

				INSERT INTO [Trend](Id,GenericFormSubmittedId,GenericFormKeyId,TrendValue,CreatedByUserId,CreatedDateTime)
				SELECT NEWID(),@GenericFormSubmittedId,CAK.GenericFormKeyId,JD.[value],@OperationsPerformedBy,@Currentdate
				FROM CustomApplicationKey CAK
				     INNER JOIN GenericFormKey GFK ON GFK.Id = CAK.GenericFormKeyId
					            AND GFK.GenericFormId = @FormId 
								AND GFK.InActiveDateTime IS NULL
					 LEFT JOIN (SELECT [key],[value] FROM OPENJSON(@FormJson)) AS JD
					           ON JD.[key] COLLATE SQL_Latin1_General_CP1_CI_AS = GFK.[Key]
				WHERE CAK.GenericFormId = @FormId
				      AND CAK.CustomApplicationId = @CustomApplicationId
					  AND CAK.IsTrendsEnable  = 1

				IF( @OperationsPerformedBy IS NOT NULL)
					SELECT Id FROM [GenericFormSubmitted] WHERE Id = @GenericFormSubmittedId
				
				IF( @OperationsPerformedBy IS  NULL AND @IsFinalSubmit = 1)
					SELECT @UniqueNumber
				
				IF( @OperationsPerformedBy IS  NULL AND @IsFinalSubmit = 0)
					SELECT Id FROM [GenericFormSubmitted] WHERE Id = @GenericFormSubmittedId

		END

      END
    END TRY
    BEGIN CATCH

         THROW

    END CATCH
END
GO