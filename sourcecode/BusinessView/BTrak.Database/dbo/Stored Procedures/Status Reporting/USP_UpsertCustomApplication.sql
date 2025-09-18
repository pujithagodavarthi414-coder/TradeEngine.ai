-------------------------------------------------------------------------------
-- Author       Geetha ch
-- Created      '2019-10-10 00:00:00.000'
-- Purpose      To Update or Save CustomApplication
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertCustomApplication] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertCustomApplication]
(
	@CustomApplicationId UNIQUEIDENTIFIER = NULL,
    @GenericFormId NVARCHAR(MAX) = NULL,
	@CustomApplicationName NVARCHAR(250) = NULL,
	@SelectedKeyIds VARCHAR(4000) = NULL,
	@SelectedPrivateKeyIds VARCHAR(4000) = NULL,
	@SelectedEnableTrendsKeyIds VARCHAR(4000) = NULL,
	@SelectedTagKeyIds VARCHAR(4000) = NULL,
	@DomainName NVARCHAR(250) = NULL,
	@PublicMessage NVARCHAR(500) = NULL,
	@Description NVARCHAR(MAX) = NULL,
	@RoleIds VARCHAR(4000) = NULL,
	@ModuleIds NVARCHAR(MAX) = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsPublished BIT = NULL,
	@IsApproveNeeded BIT = NULL,
    @AllowAnnonymous BIT = NULL,
	@OperationsPerformedBy  UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER = NULL,
	@SelectedFormsXml XML = NULL,
	@UsersXML XML = NULL,
    @IsArchived BIT = NULL,
	@IsPdfRequired BIT = NULL,
	@IsRedirectToEmails BIT = NULL,
	@WorkflowIds NVARCHAR(MAX) = NULL,
	@ToEmails NVARCHAR(MAX) = NULL,
	@ToRoleIds NVARCHAR(MAX) = NULL,
	@Subject NVARCHAR(MAX) = NULL,
	@Message NVARCHAR(MAX) = NULL,
	@IsRecordLevelPermissionEnabled BIT = 0,
	@RecordLevelPermissionFieldName NVARCHAR(500) = NULL,
	@ConditionalEnum INT = NULL,
	@ConditionsJson NVARCHAR(MAX) = NULL,
	@StageScenariosJson NVARCHAR(MAX) = NULL,
	@ApproveSubject NVARCHAR(MAX) = NULL,
	@ApproveMessage NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		IF (@HavePermission = '1')
        BEGIN

	  IF (@CustomApplicationName = '') SET @CustomApplicationName = NULL

	  IF (@SelectedKeyIds = '') SET @SelectedKeyIds = NULL
	  
	  IF (@SelectedTagKeyIds = '') SET @SelectedTagKeyIds = NULL

	  IF (@SelectedPrivateKeyIds = '') SET @SelectedPrivateKeyIds = NULL

	  IF (@SelectedEnableTrendsKeyIds = '') SET @SelectedEnableTrendsKeyIds = NULL

	  IF (@RecordLevelPermissionFieldName = '') SET @RecordLevelPermissionFieldName = NULL

	  IF (@IsRecordLevelPermissionEnabled IS NULL) SET @IsRecordLevelPermissionEnabled = 0

	  IF (@RoleIds = '') SET @RoleIds = NULL

	  IF(@ModuleIds = '')SET @ModuleIds  = NULL

	  --IF (@GenericFormId = '00000000-0000-0000-0000-000000000000') SET @GenericFormId = NULL
	  
	  

	  DECLARE @Temp TABLE ( 
	                        Id UNIQUEIDENTIFIER,
							GenericFormId UNIQUEIDENTIFIER,
							FormName NVARCHAR(250),
	                        CustomApplicationId UNIQUEIDENTIFIER
	  )

	  INSERT INTO @Temp(Id,GenericFormId,FormName,CustomApplicationId)
	  SELECT NEWID(), x.y.value('Id[1]', 'UNIQUEIDENTIFIER')
                   ,x.y.value('FormName[1]', 'NVARCHAR(250)')
				   ,@CustomApplicationId
			  FROM @SelectedFormsXml.nodes('/ArrayOfGenericFormUpsertInputModel/GenericFormUpsertInputModel') AS x(y)


			   DECLARE @Users TABLE ( 
	                        UserId UNIQUEIDENTIFIER
	                      )

						 IF(@UsersXML IS NOT NULL)
						 BEGIN

						  INSERT INTO @Users 
						  SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') TestSuiteSectionId FROM @UsersXML.nodes('/ArrayOfGuid/guid') AS [Table]([Column])

						 END

	  IF(@CustomApplicationName IS NULL)
	  BEGIN
		
		RAISERROR(50011,16, 2, 'ApplicationName')

	  END
	  IF(@SelectedFormsXml IS NULL)
	  BEGIN
		
		RAISERROR(50011,16, 2, 'GenericForm')

	  END
	  ELSE 
	  BEGIN

			IF (@CustomApplicationId = '00000000-0000-0000-0000-000000000000') SET @CustomApplicationId = NULL

			DECLARE @CustomApplicationIdCount INT = (SELECT COUNT(1) FROM CustomApplication WHERE Id = @CustomApplicationId)

			DECLARE @CustomApplicationNameCount INT = (SELECT COUNT(1) 
			                                           FROM CustomApplication CA
															INNER JOIN CustomApplicationForms CAF ON CAF.CustomApplicationId = CA.Id
			                                            WHERE CustomApplicationName = @CustomApplicationName AND CA.CompanyId = @CompanyId
													         AND (@CustomApplicationId IS NULL OR (CA.Id <> @CustomApplicationId))
			                                                 AND CA.InActiveDateTime IS NULL)

			IF(@CustomApplicationIdCount = 0 AND @CustomApplicationId IS NOT NULL)
			BEGIN
			
		
				RAISERROR(50002,16,1,'CustomApplication')

				

			END
			--ELSE IF(@CustomApplicationNameCount > 0 AND)
			--BEGIN
			
			--	RAISERROR(50001,16,1,'CustomApplicationName')
				
			--END

			ELSE
			BEGIN

			
			DECLARE @IsLatest BIT = (CASE WHEN @CustomApplicationId IS NULL THEN 1 ELSE CASE WHEN (SELECT TOP 1 [TimeStamp] FROM CustomApplication 
			                                                                                 WHERE Id = @CustomApplicationId) = @TimeStamp 
																				        THEN 1 ELSE 0 END END ) 
            DECLARE @Currentdate DATETIME = GETDATE()

            
			IF(@IsLatest = 1)
			BEGIN


				IF(@CustomApplicationId IS NULL)
				BEGIN

					SET @CustomApplicationId = NEWID()
				
					UPDATE @Temp SET CustomApplicationId = @CustomApplicationId
					
					INSERT INTO [dbo].[CustomApplication](
					            [Id],
								[CustomApplicationName],
								[PublicMessage],
								[Description],
					            [CreatedDateTime],
					            [CreatedByUserId],
								[InActiveDateTime],
								[IsPublished],
								IsApproveNeeded,
								AllowAnnonymous,
								IsPdfRequired,
								IsRedirectToEmails,
								[CompanyId],
								[WorkflowIds],
								[ToEmails],
								[ToRoleIds],
								[Subject],
								[Message],
								[IsRecordLevelPermissionEnabled],
								[RecordLevelPermissionFieldName],
								[ConditionalEnum],
								ConditionsJson,
								StageScenariosJson,
								[ApproveSubject],
								[ApproveMessage]
								)
					     SELECT @CustomApplicationId,
						        @CustomApplicationName,
								@PublicMessage,
								@Description,
					            @Currentdate,
								@OperationsPerformedBy,
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
								@IsPublished,
								@IsApproveNeeded,
								@AllowAnnonymous,
								@IsPdfRequired,
								@IsRedirectToEmails,
								@CompanyId,
								@WorkflowIds,
								@ToEmails,
								@ToRoleIds,
								@Subject,
								@Message,
								@IsRecordLevelPermissionEnabled,
								@RecordLevelPermissionFieldName,
								@ConditionalEnum,
								@ConditionsJson,
								@StageScenariosJson,
								@ApproveSubject,
								@ApproveMessage

				END	   
				ELSE
				BEGIN
					    
						UPDATE [dbo].[CustomApplication] 
						    SET [CustomApplicationName] = @CustomApplicationName
								,[PublicMessage] = @PublicMessage
								,[Description] = @Description
								,[UpdatedByUserId] = @OperationsPerformedBy
								,[UpdatedDateTime] = @Currentdate
								,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
								,[IsPublished] = @IsPublished
								,IsApproveNeeded = @IsApproveNeeded
								,AllowAnnonymous = @AllowAnnonymous
								,IsPdfRequired = @IsPdfRequired
								,IsRedirectToEmails = @IsRedirectToEmails
								,WorkflowIds = @WorkflowIds
								,ToEmails = @ToEmails
								,ToRoleIds = @ToRoleIds
								,[Subject] = @Subject
								,[Message] = @Message
								,IsRecordLevelPermissionEnabled = @IsRecordLevelPermissionEnabled
								,RecordLevelPermissionFieldName = @RecordLevelPermissionFieldName
								,ConditionalEnum = @ConditionalEnum
								,ConditionsJson = @ConditionsJson
								,StageScenariosJson = @StageScenariosJson
								,ApproveSubject = @ApproveSubject
								,ApproveMessage = @ApproveMessage
								FROM [CustomApplication] CA
						  WHERE CA.Id = @CustomApplicationId

				END
				
				DELETE FROM CustomApplicationForms WHERE CustomApplicationId = @CustomApplicationId
			
				 INSERT INTO CustomApplicationForms([Id], 
													[CustomApplicationId] , 
													[GenericFormId],
													[PublicUrl],
													[CreatedDateTime],
													[CreatedByUserId],
													[InActiveDateTime]
													)
											SELECT T.Id,
												   @CustomApplicationId,
												   GenericFormId,
												   @DomainName +'/application/application-form/' + @CustomApplicationName + '/' + T.FormName,
												   @Currentdate,
												   @OperationsPerformedBy,
												   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
												   FROM @Temp T 
				DELETE FROM CustomApplicationKey WHERE CustomApplicationId = @CustomApplicationId
				

			    DELETE FROM CustomApplicationRoleConfiguration WHERE CustomApplicationId = @CustomApplicationId

				 DECLARE @WigetModulesList TABLE
                (
                    ModuleId [uniqueidentifier] 
                ) 
                
                INSERT INTO @WigetModulesList(ModuleId)
                SELECT Id FROM dbo.UfnSplit(@ModuleIds) WHERE Id <> '0'

				UPDATE WidgetModuleConfiguration SET InActiveDateTime =  @Currentdate WHERE WidgetId =  @CustomApplicationId  AND InActiveDateTime IS NULL AND  @CustomApplicationId  IS NOT NULL

				 INSERT INTO [dbo].[WidgetModuleConfiguration](
                            [Id],
                            [WidgetId],
                            [ModuleId],
                            [CreatedDateTime],
                            [CreatedByUserId])
                     SELECT NEWID(),
                            @CustomApplicationId, 
                            ModuleId,
                            @Currentdate,
                            @OperationsPerformedBy
                       FROM @WigetModulesList

				INSERT INTO CustomApplicationRoleConfiguration(
				            Id
							,RoleId
							,CustomApplicationId
							,CreatedByUserId
							,CreatedDateTime)
					SELECT NEWID()
					       ,Id
						   ,@CustomApplicationId
						   ,@OperationsPerformedBy
						   ,@Currentdate
					FROM dbo.UfnSplit(@RoleIds) 

				
	       IF(@IsApproveNeeded =1 AND @UsersXML IS NOT NULL)
			BEGIN

			DELETE FROM ApprovalCustomApplicationForms WHERE CustomApplicationId = @CustomApplicationId AND @CustomApplicationId IS NOT NULL

				 INSERT INTO ApprovalCustomApplicationForms([Id], 
													[CustomApplicationId] , 
													[ApproverId],
													[CreatedDateTime],
													[CreatedByUserId],
													[InActiveDateTime]
													)
											SELECT NEWID(),
												   @CustomApplicationId,
												   UserId,
												   @Currentdate,
												   @OperationsPerformedBy,
												   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
												   FROM @Users T 

			END
				
				SELECT Id FROM [CustomApplication] WHERE Id = @CustomApplicationId

			END

			ELSE
			   
			   RAISERROR(50008,11,1)

		END

      END
	END
    END TRY
    BEGIN CATCH

         THROW

    END CATCH
END
GO