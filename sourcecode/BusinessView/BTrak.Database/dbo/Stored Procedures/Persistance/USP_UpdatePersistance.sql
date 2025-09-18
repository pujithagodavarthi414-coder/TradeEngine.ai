
-------------------------------------------------------------------------------
-- Author       Manoj Kumar
-- Created      '2019-12-5 00:00:00.000'
-- Purpose      To Save or Update the Persistance
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpdatePersistance] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ReferenceId='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_UpdatePersistance]
(
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @IsUserLevel BIT = 0,
   @PersistanceJson NVARCHAR(MAX)  = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

	SET NOCOUNT ON
	BEGIN TRY

		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
		IF(@IsUserLevel IS NULL) SET @IsUserLevel = 0

		IF(@ReferenceId IS NULL)
		BEGIN 
			RAISERROR(50011, 16, 2, 'Reference Id')
		END
		
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF(@HavePermission = '1')	
			BEGIN
				
				DECLARE @Currentdate DATETIME = GETDATE()
	
				DECLARE @PersistanceId UNIQUEIDENTIFIER = (SELECT Id FROM Persistance WHERE ReferenceId = @ReferenceId 
															AND ((UserId = @OperationsPerformedBy) OR (@IsUserLevel = 0 and IsUserLevel = 0)))

				IF(@PersistanceId IS NULL)
				BEGIN

					SET @PersistanceId = NEWID();

					INSERT INTO [Persistance]( [Id]
											,[ReferenceId]
											,[IsUserLevel]
											,[PersistanceJson]
											,[UserId]
											,[CreatedByUserId]
											,[CreatedDateTime])
								SELECT @PersistanceId,
									   @ReferenceId,
									   @IsUserLevel,
									   @PersistanceJson,
									   CASE WHEN @IsUserLevel = 1 THEN @OperationsPerformedBy ELSE NULL END,
									   @OperationsPerformedBy,
									   @Currentdate

				END

				ELSE
				BEGIN

					UPDATE [Persistance] SET [PersistanceJson] = @PersistanceJson,
											 [IsUserLevel] = @IsUserLevel,
											 [UserId] = (CASE WHEN @IsUserLevel = 1 THEN @OperationsPerformedBy ELSE NULL END),
											 [UpdatedDateTime] = @Currentdate,
											 [UpdatedByUserId] = @OperationsPerformedBy
										 WHERE Id = @PersistanceId

					SELECT [Id] FROM Persistance WHERE ReferenceId = @ReferenceId

				END

			END

			ELSE
			BEGIN
					RAISERROR (@HavePermission,11, 1)
			END
			
		END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO