-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-247 00:00:00.000'
-- Purpose      To Save or Update the Permission Reason
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertPermissionReason] @PermissionReasonId=NULL,@ReasonName='testreason',@IsArchived=0,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPermissionReason]
(
  @PermissionReasonId UNIQUEIDENTIFIER = NULL,
  @ReasonName NVARCHAR(800) = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
        
			IF(@ReasonName = '') SET @ReasonName = NULL

			ELSE IF(@ReasonName IS NULL)
			BEGIN
			   
			    RAISERROR(50011,16, 2, 'Reason')
			END

			ELSE 
			BEGIN
      
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
				DECLARE @PermissionReasonIdCount INT = (SELECT COUNT(1) FROM [PermissionReason] WHERE Id = @PermissionReasonId AND CompanyId = @CompanyId)
       
				DECLARE @ReasonNameCount INT = (SELECT COUNT(1) FROM [PermissionReason] WHERE ReasonName = @ReasonName AND CompanyId = @CompanyId AND (@PermissionReasonId IS NULL OR Id <> @PermissionReasonId))
				
				DECLARE @IsToRaiseFkError BIT = (CASE WHEN EXISTS(SELECT Id FROM Permission WHERE PermissionReasonId = @PermissionReasonId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)

				IF(@PermissionReasonIdCount = 0 AND @PermissionReasonId IS NOT NULL)
				BEGIN
				
				    RAISERROR(50002,16, 1,'PermissionReason')
				
				END
				
				ELSE IF(@ReasonNameCount > 0)
				BEGIN
				
				    RAISERROR(50001,16,1,'PermissionReason')
				
				END
				
				ELSE IF (@IsArchived = 1 AND @IsToRaiseFkError = 1)
				BEGIN

					RAISERROR('DeletePermissionReasonInPermissionBeforeDeletingThisRecord',16,1)

				END
				ELSE
				BEGIN
				        
					DECLARE @IsLatest BIT = (CASE WHEN @PermissionreasonId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM PermissionReason WHERE Id = @PermissionReasonId) = @TimeStamp THEN 1 ELSE 0 END END )

					IF(@IsLatest = 1)
					BEGIN

							DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@PermissionReasonId IS NULL)
						BEGIN

						SET @PermissionReasonId = NEWID()
							INSERT INTO [dbo].[PermissionReason]
							                 (
							                    [Id],
							                    [ReasonName],
							                    [CompanyId],
							                    [CreatedDateTime],
							                    [CreatedByUserId],
												[InActiveDateTime]
							                 )
							 SELECT @PermissionReasonId,
							        @ReasonName,
							        @CompanyId,
							        @Currentdate,
							        @OperationsPerformedBy,
									CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
						
						END
						ELSE
						BEGIN

							UPDATE [dbo].[PermissionReason]
								SET [ReasonName]						  =  	  @ReasonName,
							                    [CompanyId]				  =  	  @CompanyId,
							                    [CreatedDateTime]		  =  	  @Currentdate,
							                    [CreatedByUserId]		  =  	  @OperationsPerformedBy,
												[InActiveDateTime]		  =  	  CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
								WHERE Id = @PermissionReasonId

						END
							 SELECT Id FROM [dbo].[PermissionReason] WHERE Id = @PermissionReasonId
					       
					     END
						 ELSE
								   
							RAISERROR(50008,11,1)
				 END
			END
		   END
        ELSE
        BEGIN
                 
           RAISERROR (@HavePermission,11, 1)
                    
       END  
       END TRY  
       BEGIN CATCH 
        
           THROW

       END CATCH
END