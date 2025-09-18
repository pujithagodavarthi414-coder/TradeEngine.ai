-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-01 00:00:00.000'
-- Purpose      To Get the trainingcourses
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_SearchTrainingCourse] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_SearchTrainingCourse]
(
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection VARCHAR(50)= NULL,
  @PageSize INT = NULL,
  @PageNumber INT = NULL,
  @SearchText NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT=NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF(@SortBy IS NULL ) SET  @SortBy = 'courseName'

			IF(@SortDirection IS NULL ) SET  @SortDirection = 'ASC'

			--IF(@PageSize IS NULL ) SET  @PageSize = (SELECT COUNT(1) FROM [dbo].[UserStoryHistory])

			IF(@PageNumber IS NULL ) SET  @PageNumber = 1

			IF(@PageSize = 0)
			BEGIN
				SELECT @PageSize = 10, @PageNumber = 1
			END

			DECLARE @OffsetLength INT = ((@PageNumber - 1) * @PageSize)
		   
			DECLARE @TrainingCourse TABLE
			(
				Id UNIQUEIDENTIFIER,
				CourseName NVARCHAR(100),
				CourseDescription NVARCHAR(800),
				ValidityInMonths INT,
				CompanyId UNIQUEIDENTIFIER,
				IsArchived BIT,
				TotalCount INT
			)

			INSERT INTO @TrainingCourse
			SELECT 
				Id,
				CourseName,
				CourseDescription,
				ValidityInMonths,
				CompanyId,
				IsArchived,
				TotalCount = COUNT(1) OVER() 
			FROM TrainingCourse
			WHERE @CompanyId = CompanyId
			AND (@IsArchived IS NULL OR (@IsArchived = IsArchived))
			AND (@SearchText IS NULL OR (CourseName LIKE '%' + @SearchText + '%') OR (CourseDescription LIKE '%' + @SearchText + '%'))
			
			SET @OffsetLength = CASE WHEN @OffsetLength < (SELECT TOP 1 TotalCount FROM @TrainingCourse) THEN @OffsetLength ELSE 0 END

			IF(@PageSize IS NULL)
			BEGIN
				SELECT * FROM @TrainingCourse
				ORDER BY CASE WHEN @SortDirection = 'ASC' AND @SortBy = 'courseName' THEN CourseName END ASC,
					CASE WHEN @SortDirection = 'ASC' AND @SortBy = 'courseDescription' THEN CourseDescription END ASC,
					CASE WHEN @SortDirection = 'ASC' AND @SortBy = 'validityInMonths' THEN ValidityInMonths END ASC,
					CASE WHEN @SortDirection = 'DESC' AND @SortBy = 'courseName' THEN CourseName END DESC,
					CASE WHEN @SortDirection = 'DESC' AND @SortBy = 'courseDescription' THEN CourseDescription END DESC,
					CASE WHEN @SortDirection = 'DESC' AND @SortBy = 'validityInMonths' THEN ValidityInMonths END DESC
			END
			ELSE
			BEGIN
				SELECT * FROM @TrainingCourse
				ORDER BY CASE WHEN @SortDirection = 'ASC' AND @SortBy = 'courseName' THEN CourseName END ASC,
						CASE WHEN @SortDirection = 'ASC' AND @SortBy = 'courseDescription' THEN CourseDescription END ASC,
						CASE WHEN @SortDirection = 'ASC' AND @SortBy = 'validityInMonths' THEN ValidityInMonths END ASC,
						CASE WHEN @SortDirection = 'DESC' AND @SortBy = 'courseName' THEN CourseName END DESC,
						CASE WHEN @SortDirection = 'DESC' AND @SortBy = 'courseDescription' THEN CourseDescription END DESC,
						CASE WHEN @SortDirection = 'DESC' AND @SortBy = 'validityInMonths' THEN ValidityInMonths END DESC
				OFFSET @OffsetLength ROWS
					FETCH NEXT @PageSize Rows ONLY
			END
		END
		ELSE
           RAISERROR (@HavePermission,11, 1)
	 END TRY  
	 BEGIN CATCH 
		  THROW
	END CATCH
END
GO