
-------------------------------------------------------------------------------
-- Author       Manoj Kumar
-- Created      '2019-12-5 00:00:00.000'
-- Purpose      To Get the Persistance
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetPersistance] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ReferenceId='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetPersistance]
(
   @ReferenceId UNIQUEIDENTIFIER = NULL,
   @IsUserLevel BIT = 0,
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

					DECLARE @PersistanceId UNIQUEIDENTIFIER 
                     
					IF((SELECT [Id] FROM [Persistance] WHERE ReferenceId = @ReferenceId AND UserId = @OperationsPerformedBy AND @IsUserLevel = 1) IS NOT NULL)
					BEGIN

						SET @PersistanceId = (SELECT [Id] FROM [Persistance] WHERE ReferenceId = @ReferenceId AND UserId = @OperationsPerformedBy AND @IsUserLevel = 1)

					END
					ELSE
					BEGIN

						SET @PersistanceId = (SELECT [Id] FROM [Persistance] WHERE ReferenceId = @ReferenceId AND IsUserLevel = 0)

					END

					SELECT [Id] AS PersistanceId,
						   [ReferenceId],
						   [PersistanceJson]
					FROM [Persistance] WHERE Id = @PersistanceId

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