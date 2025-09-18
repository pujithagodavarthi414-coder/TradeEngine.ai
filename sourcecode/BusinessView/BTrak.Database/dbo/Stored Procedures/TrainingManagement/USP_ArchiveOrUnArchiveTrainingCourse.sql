-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-01 00:00:00.000'
-- Purpose      to archive or unarchive training courses
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_ArchiveOrUnArchiveTrainingCourse]
(
	@CourseId UNIQUEIDENTIFIER,
	@IsArchived BIT,
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
				UPDATE TrainingCourse SET IsArchived = @IsArchived WHERE Id = @CourseId
			END
		ELSE
			BEGIN
				RAISERROR (@HavePermission,11, 1)
			END
	END TRY  
	BEGIN CATCH 
		
		  EXEC USP_GetErrorInformation

	END CATCH

END
GO