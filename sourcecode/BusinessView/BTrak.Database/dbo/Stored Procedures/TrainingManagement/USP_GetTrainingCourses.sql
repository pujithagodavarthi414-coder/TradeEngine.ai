-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-03 00:00:00.000'
-- Purpose      to fetch training courses lite in order to use them in select dropdowns or to view
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetTrainingCourses]
(
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
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT TOP 1 CompanyId FROM [User] WHERE [Id] = @OperationsPerformedBy)

				SELECT Id, CourseName, CourseDescription, ValidityInMonths FROM TrainingCourse WHERE CompanyId = @CompanyId AND IsArchived = 0 ORDER BY CourseName
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