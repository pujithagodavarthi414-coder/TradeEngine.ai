CREATE PROCEDURE [dbo].[USP_UpsertGenericStatus]
(
  @WorkFlowId UNIQUEIDENTIFIER = NULL,
  @GenericStatusId UNIQUEIDENTIFIER = NULL,
  @Status NVARCHAR(MAX) NULL,
  @ReferenceId UNIQUEIDENTIFIER = NULL,
  @ReferenceTypeId UNIQUEIDENTIFIER = NULL,
  @StatusColor NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
          
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  DECLARE @CurrentDate DATETIME = GETDATE()
		  DECLARE @OldValue NVARCHAR(MAX) = NULL
		  DECLARE @NewValue NVARCHAR(MAX) = NULL
		  IF (@StatusColor = '') SET @StatusColor = NULL
          IF (@HavePermission = '1')
          BEGIN
		     
			 DECLARE @GenericStatusCount INT = (SELECT COUNT(1) FROM [GenericStatus] WHERE  IsArchived IS NULL AND (Id = @GenericStatusId OR  (ReferenceId = @ReferenceId AND ReferenceTypeId = @ReferenceTypeId)))

			 IF(@GenericStatusCount = 0)
		         BEGIN

		               SET @GenericStatusId = NEWID()

		                INSERT INTO [dbo].[GenericStatus](
									      Id,
									      WorkflowId,
									      ReferenceId,
										  ReferenceTypeId,
										  [Status],
										  CompanyId,
										  StatusColor,
									      CreatedDateTime,
									      CreatedByUserId
									      )
								  SELECT  @GenericStatusId,
										  @WorkFlowId,
										  @ReferenceId,
										  @ReferenceTypeId,
										  @Status,
										  @CompanyId,
										  @StatusColor,
										  @CurrentDate,
										  @OperationsPerformedBy

								INSERT INTO [dbo].[WorkFlowStatusHistory](
												 [Id], 
                                                 [OldValue], 
                                                 [NewValue], 
                                                 [Description], 
												 [WorkFlowStatusReferenceId],
                                                 [CreatedDateTime], 
                                                 [CreatedByUserId]
                                                )
                                          SELECT NEWID(),
                                                 NULL,
                                                 @Status,
                                                 'StatusChangedTo',
                                                 @GenericStatusId,
                                                 GETDATE(),
                                                 @OperationsPerformedBy
				END
				ELSE
				BEGIN

						IF(@GenericStatusId IS NULL)
						BEGIN
							SELECT @GenericStatusId =  Id FROM [GenericStatus] WHERE ReferenceId = @ReferenceId AND ReferenceTypeId = @ReferenceTypeId AND IsArchived IS NULL
						END 

						SET  @OldValue = (SELECT [Status] FROM [GenericStatus] WHERE IsArchived IS NULL AND (Id = @GenericStatusId OR (ReferenceId = @ReferenceId AND ReferenceTypeId = @ReferenceTypeId)))
						UPDATE [dbo].[GenericStatus]
									SET   [Status] = @Status,
										   WorkflowId = ISNULL(@WorkflowId, (SELECT WorkFlowId FROM GenericStatus WHERE Id = @GenericStatusId)),
										  UpdatedDateTime = @CurrentDate,
										  UpdatedByUserId = @OperationsPerformedBy,
										  StatusColor = ISNULL(@StatusColor, (SELECT StatusColor FROM GenericStatus WHere Id = @GenericStatusId))										  
										  WHERE IsArchived IS NULL AND (Id = @GenericStatusId OR (ReferenceId = @ReferenceId AND ReferenceTypeId = @ReferenceTypeId))

										  INSERT INTO [dbo].[GenericStatusHistory](
												 [Id], 
                                                 [OldValue], 
                                                 [NewValue], 
                                                 [Description], 
												 [GenericStatusReferenceId],
                                                 [CreatedDateTime], 
                                                 [CreatedByUserId]
                                                )
                                          SELECT NEWID(),
                                                 @OldValue,
                                                 @Status,
                                                 'StatusChangedFrom',
                                                 @GenericStatusId,
                                                 GETDATE(),
                                                 @OperationsPerformedBy

				END
				SELECT Id FROM GenericStatus WHERE Id = @GenericStatusId			
		 END
		 ELSE
                 
		   RAISERROR (@HavePermission,11, 1)
                   
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO

