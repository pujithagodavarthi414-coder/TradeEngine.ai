-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-19 00:00:00.000'
-- Purpose      To Save NotificationType
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertNotificationType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @NotificationTypeName = 'New Data Added'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertNotificationType]
(
	@NotificationTypeId UNIQUEIDENTIFIER = NULL,
	@NotificationTypeName NVARCHAR(500) = NULL,
	@FeatureId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
    IF (@HavePermission = '1')
    BEGIN
        IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	    
	    IF (@FeatureId = '00000000-0000-0000-0000-000000000000') SET @FeatureId = NULL
	    
	    IF (@NotificationTypeName = '') SET @NotificationTypeName = NULL
	    
	    IF(@NotificationTypeName IS NULL)
	    BEGIN
	      
	      RAISERROR(50011,16, 2, 'NotificationTypeName')
	    
	    END
	    ELSE IF(@FeatureId IS NULL)
	    BEGIN
	      
	      RAISERROR(50011,16, 2, 'Feature')
	    
	    END
	    ELSE 
	    BEGIN
	    
        DECLARE @CurrentDate DATETIME = GETDATE()
	    
	   IF(@NotificationTypeId IS NULL)
	   BEGIN

	   SET @NotificationTypeId = NEWID()
        
		INSERT INTO [dbo].[NotificationType](
	    		            Id,
	    		            FeatureId,
	    		            NotificationTypeName,
	    		            CreatedDateTime,
	    		            CreatedByUserId
	    				    )
	    		     SELECT @NotificationTypeId,
	    		            @FeatureId,
	    		            @NotificationTypeName,
	    		            @Currentdate,
	    		            @OperationsPerformedBy
	    					
				END
				ELSE
				BEGIN

				UPDATE [NotificationType]
				  SET FeatureId = @FeatureId,
				     NotificationTypeName = @NotificationTypeName,
					 UpdatedByUserId = @OperationsPerformedBy,
					 UpdatedDateTime = @CurrentDate
					 WHERE Id = @NotificationTypeId

				END
            
        SELECT Id FROM [dbo].[NotificationType] WHERE Id = @NotificationTypeId
	    
	    END
    END
	ELSE
          RAISERROR (@HavePermission,11, 1)

	END TRY
	BEGIN CATCH

		EXEC USP_GetErrorInformation

	END CATCH
END
GO

