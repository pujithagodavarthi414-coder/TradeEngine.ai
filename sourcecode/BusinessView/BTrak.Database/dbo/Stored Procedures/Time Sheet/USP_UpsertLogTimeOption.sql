-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-13 00:00:00.000'
-- Purpose      To Save or Update the LogTimeOption
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertLogTimeOption] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@LogTimeOption='SetTo'

CREATE PROCEDURE [dbo].[USP_UpsertLogTimeOption]
(
  @LogTimeOptionId  UNIQUEIDENTIFIER = NULL,
  @LogTimeOption  NVARCHAR(250) = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @IsArchived BIT = NULL,
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
	
	    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @LogTimeOptionIdCount INT = (SELECT COUNT(1) FROM LogTimeOption WHERE Id = @LogTimeOptionId)

		DECLARE @LogTimeOptionCount INT = (SELECT COUNT(1) FROM [LogTimeOption] WHERE LogTimeOption = @LogTimeOption AND (@LogTimeOptionId IS NULL OR Id <> @LogTimeOptionId))

		IF(@LogTimeOption IS NULL)
		BEGIN

		RAISERROR(50011,16, 2, 'LogTimeOption')

		END
		ELSE IF(@LogTimeOptionIdCount = 0 AND @LogTimeOptionId IS NOT NULL)
		BEGIN

			RAISERROR(50002,16, 1,'LogTimeOption')

		END
		
		ELSE IF(@LogTimeOptionCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'LogTimeOption')

		END
		ELSE
		BEGIN

		DECLARE @IsLatest BIT = (CASE WHEN @LogTimeOptionId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM LogTimeOption WHERE Id = @LogTimeOptionId) = @TimeStamp THEN 1 ELSE 0 END END)

		IF (@IsLatest = 1)
		BEGIN

		DECLARE @Currentdate DATETIME = GETDATE()

		IF(@LogTimeOptionId IS NULL)
		BEGIN

				SET @LogTimeOptionId = NEWID()
			     INSERT INTO [dbo].[LogTimeOption](
				                                   [Id],
							                       [LogTimeOption],
                                                   [CreatedDateTime],
							                       [CreatedByUserId],
												   [InactiveDateTime]
							                      )
				                            SELECT @LogTimeOptionId,
					                       		   @LogTimeOption,
					                       		   @Currentdate,
					                       		   @OperationsPerformedBy,
												   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

		END
		ELSE
		BEGIN

			UPDATE [dbo].[LogTimeOption]
				SET [LogTimeOption]			=	 @LogTimeOption,
                    [UpdatedDateTime]		=	 @Currentdate,
					[UpdatedByUserId]		=	 @OperationsPerformedBy,
					[InactiveDateTime]		=	 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
				WHERE Id = @LogTimeOptionId

		END

			SELECT Id FROM [dbo].[LogTimeOption] WHERE Id = @LogTimeOptionId
		END
		ELSE

		 RAISERROR(50008,11,1)

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
