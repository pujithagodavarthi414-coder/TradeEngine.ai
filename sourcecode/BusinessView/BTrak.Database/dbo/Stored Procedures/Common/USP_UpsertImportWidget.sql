CREATE PROCEDURE [dbo].[USP_UpsertImportWidget]
(
   @WidgetId UNIQUEIDENTIFIER = NULL,
   @RoleIds XML = NULL,
   @Description NVARCHAR(1000)  = NULL,
   @IsCustomWidget BIT = 0,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @TagsXml XML = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	                 IF(@Description = '')SET @Description = NULL

	                 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		             
		             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		             
		             DECLARE @Currentdate DATETIME = GETDATE()

					 IF(@IsCustomWidget IS NULL)SET @IsCustomWidget = 0
					 
                    CREATE TABLE #WigetRoles 
                    (
						[RoleId] [uniqueidentifier]
                    ) 
					
                    INSERT INTO #WigetRoles(RoleId)
                         SELECT   [Table].[Column].value('(text())[1]', 'Nvarchar(250)')
                    FROM @RoleIds.nodes('/ArrayOfGuid/guid') AS [Table]([Column])

					IF(@IsCustomWidget = 0)
                    BEGIN

					UPDATE Widget SET [Description] = @Description WHERE Id = @WidgetId AND @Description IS NOT NULL

					DELETE FROM [dbo].WidgetRoleConfiguration WHERE [WidgetId] = @WidgetId AND @RoleIds IS NOT NULL
					      
					INSERT INTO [dbo].WidgetRoleConfiguration(
			                    [Id],
			                    [WidgetId],
								[RoleId],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
			                    )
                         SELECT NEWID(),
                                @WidgetId, 
                                T.RoleId,
							    @Currentdate,
                                @OperationsPerformedBy
                           FROM #WigetRoles T

						    SELECT Id FROM [dbo].Widget WHERE Id = @WidgetId

				     END
					 ELSE
					 BEGIN

			     UPDATE CustomWidgets SET [Description] = @Description WHERE Id = @WidgetId AND @Description IS NOT NULL

			      DELETE FROM [dbo].CustomWidgetRoleConfiguration WHERE CustomWidgetId = @WidgetId AND @RoleIds IS NOT NULL
         	      
                  INSERT INTO [dbo].[CustomWidgetRoleConfiguration](
                                    [Id],
                                    [CustomWidgetId],
                                    [RoleId],
                                    [CreatedDateTime],
                                    [CreatedByUserId])
                             SELECT NEWID(),
                                    @WidgetId, 
                                    T.RoleId,
                                    @Currentdate,
                                    @OperationsPerformedBy
                               FROM #WigetRoles T 
			      			   WHERE @RoleIds IS NOT NULL

					SELECT Id FROM CustomWidgets  WHERE Id = @WidgetId

					 END

					IF(@TagsXml IS NOT NULL)
					BEGIN
						   
						   CREATE TABLE #Temp
						   (
						   TagId UNIQUEIDENTIFIER
						   )
						   INSERT INTO #Temp
						   SELECT  [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') TagId FROM
							@TagsXml.nodes('ArrayOfGuid/guid') AS [Table]([Column])

					DELETE FROM CustomTags  WHERE ReferenceId = @WidgetId 

			        INSERT INTO [dbo].CustomTags(
			                    [Id],
			                    [ReferenceId],
								[TagId],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
			                    )
                         SELECT NEWID(),
						        @WidgetId,
							    T.TagId,
								@Currentdate,
								@OperationsPerformedBy
							 FROM #Temp T
							                 
				   END
		     
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
