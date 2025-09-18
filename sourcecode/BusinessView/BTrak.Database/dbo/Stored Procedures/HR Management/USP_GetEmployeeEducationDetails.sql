-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Education Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmployeeEducationDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEmployeeEducationDetails]
(
   @EmployeeEducationId  UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @IsArchived BIT = NULL
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
	      
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			  IF(@SearchText = '') SET @SearchText = NULL

			  SET @SearchText = '%'+  RTRIM(LTRIM(@SearchText)) +'%'

			  IF (@SortDirection = NULL) SET @SortDirection = 'ASC'

			  IF (@SortBy = NULL) SET @SortBy = 'EducationLevel'

			  SELECT E.Id EmployeeId,
					 EM.Id EmployeeEducationDetailId,
					 E.UserId,
			         U.FirstName,
					 U.SurName,
					 U.UserName Email,
					 EM.EducationLevelId,
					 EM.GPA_Score GpaOrScore,
					 EM.Institute,
					 EM.MajorSpecialization,
					 EL.EducationLevel EducationLevel,
					 EM.StartDate,
					 EM.EndDate,
					 EM.[TimeStamp],
					 U.FirstName + ' ' + U.SurName UserName,
					 CASE WHEN EM.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					 TotalCount = COUNT(1) OVER()

			  FROM  [dbo].EmployeeEducation EM WITH (NOLOCK)
					JOIN Employee E ON E.Id = EM.EmployeeId AND E.InactiveDateTime IS NULL
			        JOIN [User] U ON U.Id = E.UserId AND U.InactiveDateTime IS NULL
					LEFT JOIN EducationLevel EL ON EL.Id = EM.EducationLevelId AND EL.InactiveDateTime IS NULL
			  WHERE EM.InActiveDateTime IS NULL
			  AND U.CompanyId = @CompanyId
			       AND (@EmployeeEducationId IS NULL OR EM.Id = @EmployeeEducationId)
			       AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
			       AND (@SearchText IS NULL 
						OR (EL.EducationLevel LIKE @SearchText)
						OR (EM.Institute LIKE @SearchText)
						OR (EM.GPA_Score LIKE @SearchText))
			      AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EM.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EM.InActiveDateTime IS NULL))
			  ORDER BY 
			          CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'UserName')         THEN  U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'EducationLevel')   THEN  EL.EducationLevel
                              WHEN(@SortBy = 'Institute')        THEN EM.Institute
                              WHEN(@SortBy = 'GpaOrScore')        THEN CAST(EM.GPA_Score AS NVARCHAR)
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'UserName')         THEN  U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'EducationLevel')   THEN  EL.EducationLevel
                              WHEN(@SortBy = 'Institute')        THEN EM.Institute
                              WHEN(@SortBy = 'GpaOrScore')        THEN CAST(EM.GPA_Score AS NVARCHAR)
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