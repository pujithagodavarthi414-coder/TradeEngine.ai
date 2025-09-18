-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Save or update the Widget
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertWidget] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WidgetName='Test',@IsArchived = 0,
--@RoleIds = '<ArrayOfGuid><guid>860484f4-2e1f-4a0a-bd36-3509611ea6e3</guid><guid>5a678ce2-f096-4da0-bacb-fcfdca40f573</guid></ArrayOfGuid>'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertWidget]
(
   @WidgetId UNIQUEIDENTIFIER = NULL,
   @WidgetName NVARCHAR(250)  = NULL,
   @Description NVARCHAR(1000)  = NULL,
   @RoleIds XML = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @TagsNames NVARCHAR(500)  = NULL,
   @TagsXml XML = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@WidgetName = '') SET @WidgetName = NULL

	    IF(@WidgetName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'WidgetName')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @WidgetIdCount INT = (SELECT COUNT(1) FROM Widget WHERE Id = @WidgetId AND CompanyId = @CompanyId )

		DECLARE @WidgetNameCount INT = (SELECT COUNT(1) FROM Widget WHERE WidgetName = @WidgetName AND CompanyId = @CompanyId AND (Id <> @WidgetId OR @WidgetId IS NULL))

		IF(@WidgetIdCount = 0 AND @WidgetId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'Widget')
		END

		ELSE IF(@WidgetNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'Widget')

		END		

		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @IsLatest BIT = (CASE WHEN @WidgetId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM Widget WHERE Id = @WidgetId) = @TimeStamp
																THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE @Currentdate DATETIME = GETDATE()
			       
				   IF(@WidgetId IS NULL)
				   BEGIN

				   SET @WidgetId = NEWID()

			        INSERT INTO [dbo].Widget(
			                    [Id],
			                    [WidgetName],
								[Description],
			                    [InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId],
								CompanyId)
			             SELECT @WidgetId,
			                    @WidgetName,
								@Description,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy,
								@CompanyId

					END
					ELSE
					BEGIN

					     UPDATE [dbo].Widget
			             SET    [WidgetName] = @WidgetName,
								[Description] = @Description,
			                    [InActiveDateTime]= CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    [UpdatedDateTime] = @Currentdate ,
			                    [UpdatedByUserId]  = @OperationsPerformedBy,
								CompanyId = @CompanyId
								WHERE Id = @WidgetId

					END
					 
                    CREATE TABLE #WigetRoles 
                    (
						[Id] [uniqueidentifier],
						[RoleId] [uniqueidentifier] NULL,
						[IsArchived] BIT NULL
                    ) 
					
                    INSERT INTO #WigetRoles(Id,RoleId,IsArchived)
                    SELECT  NEWID(), 
                            [Table].[Column].value('(text())[1]', 'Nvarchar(250)'),
							0
                    FROM @RoleIds.nodes('/ArrayOfGuid/guid') AS [Table]([Column])
                    
					UPDATE [dbo].WidgetRoleConfiguration
					       SET [InActiveDateTime] = @CurrentDate
						       ,[UpdatedDateTime] = @CurrentDate
							   ,[UpdatedByUserId] = @OperationsPerformedBy
							WHERE [WidgetId] = @WidgetId
					      
					INSERT INTO [dbo].WidgetRoleConfiguration(
			                    [Id],
			                    [WidgetId],
								[RoleId],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
			                    )
                         SELECT T.Id,
                                @WidgetId, 
                                T.RoleId,
							    @Currentdate,
                                @OperationsPerformedBy
                           FROM #WigetRoles T

					IF(@TagsXml IS NOT NULL)
					BEGIN
						   CREATE TABLE #Temp
						   (
						   TagId UNIQUEIDENTIFIER
						   )
						   INSERT INTO #Temp
						   SELECT  [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') TagId FROM
							@TagsXml.nodes('ArrayOfGuid/guid') AS [Table]([Column])

					DELETE FROM CustomTags  WHERE ReferenceId = @WidgetId AND TagId NOT IN (SELECT TagId FROM #Temp)

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
							 FROM #Temp T LEFT JOIN CustomTags CT ON T.TagId = CT.TagId AND CT.ReferenceId = @WidgetId
							 WHERE CT.TagId IS NULL
                   
				   END

			        SELECT Id FROM [dbo].Widget WHERE Id = @WidgetId

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
