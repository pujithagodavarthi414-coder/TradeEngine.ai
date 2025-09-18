-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-07-30 00:00:00.000'
-- Purpose      To save or update announcement read
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------------------------------------
--EXEC  [dbo].[USP_UpsertAnnouncementRead] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@UserId = '127133F1-4427-4149-9DD6-B02E0E036971',@AnnouncementId = 'E04A0E63-A9B0-443C-8FF5-00268D4B0BD8'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertAnnouncementRead]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@UserId UNIQUEIDENTIFIER = NULL
	,@AnnouncementId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON

	BEGIN TRY
	 
	 IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	 
	 IF (@HavePermission = '1')
     BEGIN
		
		IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

		IF(@AnnouncementId = '00000000-0000-0000-0000-000000000000') SET @AnnouncementId = NULL
		
		IF(@UserId IS NULL)
		BEGIN

			RAISERROR(50011,16, 2, 'Users')

		END
		ELSE IF(@AnnouncementId IS NULL)
		BEGIN
			
		   	RAISERROR(50002,16,1,'Announcement')

		END
		ELSE
		BEGIN
			
			DECLARE @RecordsCount INT = 0
			
			DECLARE @CurrentDate DATETIME = GETDATE()

			UPDATE [dbo].[UserAnnouncementRead] SET ReadDateTime = @CurrentDate
													,UpdatedByUserId = @OperationsPerformedBy
													,UpdatedDateTime = @CurrentDate
								WHERE AnnouncementId = @AnnouncementId
								      AND UserId = @UserId

		END

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