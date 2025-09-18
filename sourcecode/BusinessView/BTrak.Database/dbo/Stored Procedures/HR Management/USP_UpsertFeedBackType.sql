-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-24 00:00:00.000'
-- Purpose      To Save or update the Feed Back Type
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertFeedBackType] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived = 0,@FeedBackTypeName = 'siva'
CREATE PROCEDURE USP_UpsertFeedBackType
(
@FeedBackTypeId UNIQUEIDENTIFIER = NULL,
@FeedBackTypeName NVARCHAR(250) = NULL,
@TimeStamp TIMESTAMP = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER,
@IsArchived BIT = NULL
)
AS
BEGIN
   
  SET NOCOUNT ON

  BEGIN TRY
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	IF(@FeedBackTypeId = '00000000-0000-0000-0000-000000000000') SET @FeedBackTypeId = NULL

	IF(@FeedBackTypeName = '' ) SET @FeedBacktypeName = NULL

	IF(@FeedBackTypeName IS NULL)
    BEGIN
	  
	  RAISERROR(50011,16,2,'FeedbackType')

	END
	ELSE
	BEGIN
	  
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
    BEGIN
                
      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	  DECLARE @FeedBackTypeIdCount INT = (SELECT COUNT(1) FROM FeedBackType 
		                                    WHERE @CompanyId = CompanyId AND @FeedBackTypeId = Id)

	  DECLARE @FeedBackNameCount INT = (SELECT COUNT(1) FROM FeedBackType 
		                                  WHERE  @FeedBackTypeName = FeedBackTypeName AND  @CompanyId = CompanyId AND 
		                                  (@FeedBackTypeId IS NULL OR @FeedBackTypeId <> Id))
                
	IF(@FeedBackTypeIdCount = 0 AND @FeedBackTypeId IS NOT NULL)
	BEGIN
		  
	  RAISERROR(50002,16, 1,'FeedBackType')

	END
	ELSE IF(@FeedBackNameCount > 0)
	BEGIN
		   
	  RAISERROR(50001,16,1,'FeedBackType')

	END
	ELSE
	BEGIN

	  DECLARE @IsLatest INT = (CASE WHEN @FeedBackTypeId IS NULL THEN 1 
		                           ELSE CASE WHEN (SELECT [TimeStamp] FROM FeedBackType 
		                                           WHERE Id=@FeedBackTypeId) = @TimeStamp THEN 1 
								             ELSE 0 END END )

	IF(@IsLatest = 1)
	BEGIN

	  DECLARE @CurrentDate DATETIME = GETDATE()

	  IF(@FeedBackTypeId IS NULL)
	  BEGIN

		SET @FeedBackTypeId = NEWID()
			  INSERT INTO FeedBackType(
			                           Id,
			                           CompanyId,
			                           FeedBackTypeName,
			                           CreatedDateTime,
			                           CreatedByUserId,
									   InActiveDateTime
									   )
								SELECT @FeedBackTypeId,
								       @CompanyId,
									   @FeedBackTypeName,
									   @CurrentDate,
									   @OperationsPerformedBy,
									   CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
		
		END
		ELSE
		BEGIN

		UPDATE FeedBackType
			SET CompanyId			   = 		 @CompanyId,
				FeedBackTypeName	   = 		 @FeedBackTypeName,
			    CreatedDateTime		   = 		 @CurrentDate,
			    CreatedByUserId		   = 		 @OperationsPerformedBy,
				InActiveDateTime	   = 		 CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END
			WHERE Id = @FeedBackTypeId

		END
			   SELECT Id FROM FeedBackType WHERE Id = @FeedBackTypeId
	 END
     ELSE
		    
	   RAISERROR(50008,11, 1)
	 END

	 END
	 ELSE
		  
	   RAISERROR(@HavePermission,11,1)

     END

	 END TRY

	 BEGIN CATCH
	   THROW
	 END CATCH
END