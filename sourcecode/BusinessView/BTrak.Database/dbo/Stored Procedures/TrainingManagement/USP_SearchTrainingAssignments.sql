-------------------------------------------------------------------------------
-- Author       Nikilesh Rokkam
-- Created      '2020-06-03 00:00:00.000'
-- Purpose      to fetch training assignments
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SearchTrainingAssignments]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection VARCHAR(50)= NULL,
  @PageSize INT = NULL,
  @PageNumber INT = NULL,
  @SearchText NVARCHAR(250) = NULL,
  @UserIds NVARCHAR(MAX) = NULL,
  @CourseIds NVARCHAR(MAX) = NULL,
  @TimeZoneOffset INT
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
			DECLARE @OffsetLength INT = ((@PageNumber - 1) * @PageSize)

			DECLARE @TrainingCourse TABLE
			(
				UserId UNIQUEIDENTIFIER,
				UserFullName NVARCHAR(100),
				UserProfileImage NVARCHAR(800),
				AssignmentsJson nvarchar(max),
				TotalCount INT
			)

			DECLARE @Courses TABLE
			(
				CourseId UNIQUEIDENTIFIER
			)

			DECLARE @Users TABLE
			(
				UserId UNIQUEIDENTIFIER
			)

			IF(LEN(@CourseIds) > 0)
			BEGIN
				INSERT INTO @Courses
				SELECT * FROM UfnSplit(@CourseIds)
			END
			
			IF(LEN(@UserIds) > 0)
			BEGIN
				INSERT INTO @Users
				SELECT * FROM UfnSplit(@UserIds)
			END

			IF(@SortBy IS NULL ) SET  @SortBy = 'userFullName'

			IF(@SortDirection IS NULL ) SET  @SortDirection = 'ASC'

			IF(@PageSize IS NULL ) SET  @PageSize = 99999

			IF(@PageNumber IS NULL ) SET  @PageNumber = 1

			IF(@PageSize = 0)
			BEGIN
				SELECT @PageSize = 10, @PageNumber = 1
			END

			INSERT INTO @TrainingCourse
			SELECT U.Id AS UserId,
				U.FirstName +' '+ISNULL(U.SurName,'') as UserFullName,
				U.ProfileImage AS UserProfileImage,
				(SELECT TA.Id AS AssignmentId,
					TC.Id AS TrainingCourseId,
					TC.CourseName,
					AST.StatusName,
					TA.ValidityEndDate,
					TC.ValidityInMonths,
					AST.Id AS StatusId,
					AST.StatusColor,
					DATEADD(minute,-@TimeZoneOffset,TA.CreatedDateTime) AS 'CreatedDateTime',
					TA.StatusGivenDate,
					AST.Icon AS 'StatusIcon',
					AST.AddsValidity,
					AST.IsDefaultStatus
				FROM TrainingAssignment TA 
				LEFT JOIN TrainingCourse TC ON TC.Id = TA.TrainingCourseId
				LEFT JOIN AssignmentStatus AST ON AST.Id = TA.StatusId
				WHERE TA.UserId = U.Id
				AND TA.IsActive = 1
				AND TC.IsArchived = 0
				AND (@CourseIds IS NULL OR @CourseIds = '' OR TC.Id IN (SELECT * FROM @Courses))
				ORDER BY TC.CourseName
				FOR JSON PATH
				) AS AssignmentsJson,
				TotalCount = COUNT(1) OVER()
			FROM  [dbo].[User] U WITH (NOLOCK)
				LEFT JOIN [dbo].[Employee]E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
				LEFT JOIN EmployeeBranch EB ON 
					EB.EmployeeId = E.Id
					AND EB.[ActiveFrom] IS NOT NULL 
					AND 
					(
						EB.[ActiveTo] IS NULL 
						OR EB.[ActiveTo] >= GETDATE()
					)
			WHERE U.CompanyId = @CompanyId
				AND U.IsActive = 1
				AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
				AND (@SearchText IS NULL OR U.FirstName +' '+ISNULL(U.SurName,'') LIKE '%' + @SearchText + '%' )
				AND (@UserIds IS NULL OR @UserIds = '' OR U.Id IN (SELECT * FROM @Users))
				
			ORDER BY  U.FirstName +' '+ISNULL(U.SurName,'')  

			SET @OffsetLength = CASE WHEN @OffsetLength < (SELECT TOP 1 TotalCount FROM @TrainingCourse) THEN @OffsetLength ELSE 0 END

			IF(@PageSize IS NULL)
			BEGIN
				SELECT * FROM @TrainingCourse
				ORDER BY CASE WHEN @SortDirection = 'ASC' AND @SortBy = 'userFullName' THEN UserFullName END ASC,
					CASE WHEN @SortDirection = 'DESC' AND @SortBy = 'userFullName' THEN UserFullName END DESC
			END
			ELSE
			BEGIN
				SELECT * FROM @TrainingCourse
				ORDER BY CASE WHEN @SortDirection = 'ASC' AND @SortBy = 'userFullName' THEN UserFullName END ASC,
					CASE WHEN @SortDirection = 'DESC' AND @SortBy = 'userFullName' THEN UserFullName END DESC
				OFFSET @OffsetLength ROWS
					FETCH NEXT @PageSize Rows ONLY
			END
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