-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Skill Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEmployeeSkillDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeSkillDetails]
(
   @EmployeeSkillId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		  IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		  IF (@SortDirection = NULL) SET @SortDirection = 'ASC'

		  IF (@SortBy = NULL) SET @SortBy = 'skillName'
	      
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF (@SearchText = '') SET @SearchText = NULL

		  SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

	      SELECT E.Id EmployeeId,
				 ES.Id EmployeeSkillId,
				 E.UserId,
				 ES.Comments,
				 ES.DateFrom,
				 ES.DateTo,
				 ES.SkillId,
				 S.SkillName,
				 ES.[YearsOfExperience],
				 ES.[TimeStamp],
				 CASE WHEN ES.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				 TotalCount = COUNT(1) OVER()
		  FROM  [dbo].EmployeeSkill ES WITH (NOLOCK)
				JOIN Employee E ON E.Id = ES.EmployeeId  AND E.InActiveDateTime IS NULL
		        JOIN [User] U ON U.Id = E.UserId  AND U.InActiveDateTime IS NULL
				LEFT JOIN Skill S ON S.Id = ES.SkillId  AND S.InActiveDateTime IS NULL
		  WHERE (@EmployeeSkillId IS NULL OR ES.Id = @EmployeeSkillId)
		       AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
			   AND U.CompanyId = @CompanyId
		       AND (@SearchText IS NULL 
					OR (S.SkillName LIKE @SearchText)
					OR (ES.Comments LIKE @SearchText)
					OR (ES.[YearsOfExperience] LIKE @SearchText)
					)
			   AND (@IsArchived IS NULL 
			         OR (@IsArchived = 1 AND ES.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND ES.InActiveDateTime IS NULL))
		  ORDER BY 
		     CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'skillName') THEN  S.SkillName
							  WHEN(@SortBy = 'Comments') THEN  ES.Comments
                              WHEN(@SortBy = 'YearsOfExperience') THEN CAST(ES.YearsOfExperience AS SQL_VARIANT)      
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                          CASE WHEN(@SortBy = 'skillName') THEN  S.SkillName
							   WHEN(@SortBy = 'Comments') THEN  ES.Comments
                               WHEN(@SortBy = 'YearsOfExperience') THEN CAST(ES.YearsOfExperience AS SQL_VARIANT)    
                          END
                      END DESC

		  OFFSET ((@PageNo - 1) * @PageSize) ROWS

          FETCH NEXT @PageSize ROWS ONLY
		END
		ELSE

		   RAISERROR(@HavePermission,11,1)

	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END
