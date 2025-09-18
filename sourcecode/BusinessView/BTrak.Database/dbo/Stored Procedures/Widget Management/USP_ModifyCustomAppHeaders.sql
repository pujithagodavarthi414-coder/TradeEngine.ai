-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-03-09 00:00:00.000'
-- Purpose      To modify Custom App headers
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_ModifyCustomAppHeaders] @WidgetQuery='select * from [User]',@OperationsPerformedBy='54910103-9ebe-4020-a347-4be1cbfc36be', @IsDataRequired = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ModifyCustomAppHeaders]
(
	@WidgetQuery NVARCHAR(MAX) = NULL,
	@FilterQuery NVARCHAR(MAX) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@CustomWidgetId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
		BEGIN

			IF(@FilterQuery IS NOT NULL)
			BEGIN
				SET @WidgetQuery = 'SELECT * FROM ( ' + @WidgetQuery + ' ) DUMMYBTRAKWIDGETTABLE ' + @FilterQuery 
			END

			DECLARE @QueryHeaders NVARCHAR(MAX) = ''

			IF OBJECT_ID('DynamicSqlQuery','U') IS NOT NULL

			DROP TABLE DynamicSqlQuery
			
			DECLARE @TableName NVARCHAR(100) = '##Temp' + CONVERT(VARCHAR(14),CONVERT(DECIMAL(14, 0), RAND() * POWER(CAST(10 AS BIGINT), 14)))

			SET @QueryHeaders = 'SELECT * INTO ' + @TableName + ' FROM ( ' + @WidgetQuery + ' ) T '

			EXEC(@QueryHeaders)

			 DECLARE @WidgetQueryJson NVARCHAR(MAX) 

			IF(@CustomWidgetId IS NOT NULL)
			BEGIN

				Create table #TempTable (
				[Field] varchar(250), 
				[Filter] varchar(250),
				[MaxLength] varchar(250),
				[Precision] varchar(250),
				[IsNullable] bit
				)

				INSERT INTO #TempTable	
				SELECT [Field] = c.name, 
						[Filter] = t.name,
						[MaxLength] = c.max_length,
						[Precision] = c.precision,
						[IsNullable] = c.is_nullable
					FROM tempdb.sys.columns AS c
					INNER JOIN tempdb.sys.types AS t 
					ON c.system_type_id = t.system_type_id
					AND t.system_type_id = t.user_type_id
					WHERE  object_id = Object_id('tempdb..' + @TableName)

					SELECT [Field] INTO #Field FROM #TempTable

			Merge CustomAppColumns AS TARGET
			Using #TempTable AS SOURCE
			ON TARGET.ColumnName = SOURCE.Field  AND TARGET.CompanyId = @CompanyId  AND Target.CustomWidgetId = @CustomWidgetId
				WHEN MATCHED 
				THEN
				UPDATE SET [ColumnName] = SOURCE.[Field],
			[UpdatedDateTime] = GETUTCDATE()
			WHEN NOT MATCHED BY TARGET  
				THEN 
			INSERT (Id,CustomWidgetId,ColumnName,ColumnType,CompanyId,CreatedByUserId,CreatedDateTime,UpdatedByUserId,UpdatedDateTime,[Precision],[IsNullable],[MaxLength]) Values
			(newID(),@CustomWidgetId,SOURCE.Field,SOURCE.[Filter],@companyId,@OperationsPerformedBy,GETUTCDATE()
			,@OperationsPerformedBy,GETUTCDATE(),SOURCE.[Precision],SOURCE.[IsNullable],SOURCE.[MaxLength]) 
			WHEN NOT MATCHED BY SOURCE AND TARGET.ColumnName NOT IN (SELECT [Field] FROM #Field)  AND TARGET.CompanyId = @CompanyId  AND Target.CustomWidgetId = @CustomWidgetId
			THEN DELETE;

			END
			
		END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO