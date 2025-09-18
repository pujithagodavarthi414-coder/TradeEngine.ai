----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-09-24 00:00:00.000'
-- Purpose      To Save Client History by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_InsertClientHistory] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ClientId = '9DA6E96C-9E4B-486B-A221-DCE726337954', 
-- @OldValue = '649E763B-03F4-4377-939D-51D6EC7A07F2', @NewValue = '7548D6DE-2622-43AA-865D-3A8981DBC6B1', @FieldName = 'ClientAddressId',
-- @Description = 'ClientAddressId is changed from 649E763B-03F4-4377-939D-51D6EC7A07F2 to 7548D6DE-2622-43AA-865D-3A8981DBC6B1'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_InsertClientHistory]
(
  @ClientId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(250) = NULL,
  @NewValue NVARCHAR(250) = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @Description NVARCHAR(800) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

			DECLARE @ClientHistoryId UNIQUEIDENTIFIER = NEWID()

			DECLARE @Currentdate DATETIME = GETDATE()
		
			INSERT INTO [dbo].[ClientHistory](
						[Id],
						[ClientId],
						[OldValue],
						[NewValue],
						[FieldName],
						[Description],
						[CreatedDateTime],
						[CreatedByUserId]
						)
				 SELECT @ClientHistoryId,
						@ClientId,
						@OldValue,
						@NewValue,
						@FieldName,
						@Description,
						SYSDATETIMEOFFSET(),
						@OperationsPerformedBy

		END
		ELSE
		BEGIN

			RAISERROR(@HavePermission,11,1)

		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO