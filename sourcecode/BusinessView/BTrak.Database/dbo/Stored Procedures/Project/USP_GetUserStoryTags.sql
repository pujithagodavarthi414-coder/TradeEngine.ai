-------------------------------------------------------------------------------
-- Author       RanadheerRanaVelaga
-- Created      '2019-07-09 00:00:00.000'
-- Purpose      To Get UserStory Tags
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------
--EXEC [USP_GetUserStoryTags] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@UserStoryId = 'DC09D6A8-7D4A-4A03-9E17-BCA1595A1DF5'
----------------------------------------------------------------
CREATE PROCEDURE USP_GetUserStoryTags
(
 @OperationsPerformedBY UNIQUEIDENTIFIER,
 @UserStoryId  UNIQUEIDENTIFIER = NULL,
 @SearchText NVARCHAR(250) = NULL,
 @Tag NVARCHAR(250) = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN

			DECLARE @UserStoryCount INT = (SELECT COUNT(1) FROM UserStory WHERE Id = @UserStoryId)

			IF (@UserStoryCount = 1)
			BEGIN

				SELECT @UserStoryId AS UserStoryId,ID AS Tag
				      FROM UfnSplit((SELECT Tag FROM UserStory WHERE Id = @UserStoryId))
				WHERE (@SearchText IS NULL OR (ID LIKE '%' + @SearchText + '%'))
				  AND (@Tag IS NULL OR (ID = @Tag))

			END
			ELSE
				
				RAISERROR(50002,11,1,'User Story')

		END

		ELSE

			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO