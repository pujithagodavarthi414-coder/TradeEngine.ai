-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Save or Update the BoardTypeUi
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertBoardTypeUi]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@BoardTypeUiName='Kanban Bug',@BoardTypeUiView='_KanBanBugSheet'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertBoardTypeUi]
(
  @BoardTypeUiId UNIQUEIDENTIFIER = NULL,
  @BoardTypeUiName NVARCHAR(250) = NULL,
  @BoardTypeUiView NVARCHAR(250) = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
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

		DECLARE @BoardTypeUiIdCount INT = (SELECT COUNT(1) FROM BoardTypeUi WHERE Id = @BoardTypeUiId)

		DECLARE @BoardTypeUiNameCount INT = (SELECT COUNT(1) FROM BoardTypeUi WHERE BoardTypeUiName = @BoardTypeUiName )

		DECLARE @UpdateBoardTypeUiNameCount INT = (SELECT COUNT(1) FROM BoardTypeUi WHERE BoardTypeUiName = @BoardTypeUiName AND (@BoardTypeUiId IS NULL OR Id <> @BoardTypeUiId))

		IF(@BoardTypeUiIdCount = 0 AND @BoardTypeUiId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'BoardTypeUi')
		END

		ELSE IF(@BoardTypeUiNameCount > 0 AND @BoardTypeUiId IS NULL)
		BEGIN
			RAISERROR(50001,16,1,'BoardTypeUi')
		END

		ELSE IF(@UpdateBoardTypeUiNameCount > 0 AND @BoardTypeUiId IS NOT NULL)
		BEGIN
			RAISERROR(50001,16,1,'BoardTypeUi')
		END

		ELSE
		BEGIN

		DECLARE @IsLatest BIT = (CASE WHEN @BoardTypeUiId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM BoardTypeUi WHERE Id = @BoardTypeUiId) = @TimeStamp THEN 1 ELSE 0 END END )

		IF(@IsLatest = 1)
		BEGIN

		DECLARE @Currentdate DATETIME = GETDATE()

		IF(@BoardTypeUiId IS NULL)
		BEGIN

			SET @BoardTypeUiId = NEWID()
				INSERT INTO [dbo].[BoardTypeUi](
				                                Id,
				                                BoardTypeUiName,
							                    BoardTypeUiView,
				                             --   CompanyId,
				                                CreatedDateTime,
				                                CreatedByUserId,
												InActiveDateTime
											   )
				                         SELECT @BoardTypeUiId,
				                                @BoardTypeUiName,
							                    @BoardTypeUiView,
				                            --    @CompanyId,
				                                @Currentdate,
				                                @OperationsPerformedBy,
												CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
		
		END
		ELSE
		BEGIN

		UPDATE [dbo].[BoardTypeUi]
			SET  BoardTypeUiName		=		 @BoardTypeUiName,
		         BoardTypeUiView		=		 @BoardTypeUiView,
	            -- CompanyId				=		 @CompanyId,
	             UpdatedDateTime		=		 @Currentdate,
	            UpdatedByUserId			=		 @OperationsPerformedBy,
				InActiveDateTime		=        CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
			WHERE Id = @BoardTypeUiId

		END

			SELECT Id FROM [dbo].[BoardTypeUi] WHERE Id = @BoardTypeUiId
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
GO
