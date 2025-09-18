---------------------------------------------------------------------------------------
-- Author       RanadheerRanaVelaga
-- Created      '2019-07-08 00:00:00.000'
-- Purpose      To get goal tags
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------
-- EXEC USP_GetGoalTags @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@GoalId = 'FF4047B8-39B1-42D2-8910-4E60ED38AAC7'
----------------------------------------------------------------------------------------
CREATE PROCEDURE USP_GetGoalTags
(
 @GoalId UNIQUEIDENTIFIER = NULL,
 @Tag NVARCHAR(250) = NULL,
 @SearchText NVARCHAR(250) = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN

		DECLARE @GoalCount INT = (SELECT COUNT(1) FROM Goal WHERE Id = @GoalId )

		IF(@GoalCount = 1)
		BEGIN

		SELECT @GoalId AS GoalId,Id AS Tag FROM UfnSplit((SELECT Tag FROM Goal 
		                                 WHERE Id = @GoalId))
		 WHERE (@Tag IS NULL OR (Id = @Tag))
		   AND (@SearchText IS NULL OR (Id LIKE '%' + @SearchText + '%'))

		END
		ELSE
			
			RAISERROR(50002,11,1,'Goal')

		END
		ELSE

			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO
