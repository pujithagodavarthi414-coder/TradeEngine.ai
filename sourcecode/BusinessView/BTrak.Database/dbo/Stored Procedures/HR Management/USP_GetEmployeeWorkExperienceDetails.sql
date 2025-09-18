-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Work Experience Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmployeeWorkExperienceDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEmployeeWorkExperienceDetails]
(
   @EmployeeWorkExperienceId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
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

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		  IF (@SortDirection = NULL) SET @SortDirection = 'ASC'

		  IF (@SortBy = NULL) SET @SortBy = 'Company'
	      
	      IF(@SearchText = '') SET @SearchText = NULL

		  SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

	      SELECT E.Id EmployeeId,
				 ER.Id EmployeeWorkExperienceId,
				 E.UserId,
		         U.FirstName,
				 U.SurName,
				 U.UserName Email,
				 ER.Comments,
				 ER.DesignationId,
				 D.DesignationName AS DesignationName,
				 ER.Company,
				 ER.FromDate,
				 ER.ToDate,
				 ER.[TimeStamp],
				 U.FirstName + ' ' + U.SurName UserName,
				 CASE WHEN ER.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				 TotalCount = COUNT(1) OVER()

		  FROM  [dbo].EmployeeWorkExperience ER WITH (NOLOCK)
				JOIN Employee E ON E.Id = ER.EmployeeId  AND E.InactiveDateTime IS NULL
		        JOIN [User] U ON U.Id = E.UserId  AND U.InactiveDateTime IS NULL
				LEFT JOIN Designation D ON D.Id = ER.DesignationId AND D.InactiveDateTime IS NULL
		  WHERE  (@EmployeeWorkExperienceId IS NULL OR ER.Id = @EmployeeWorkExperienceId)
		       AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
			   AND U.CompanyId = @CompanyId
		       AND (@SearchText IS NULL 
			        OR (ER.Company LIKE @SearchText)
				    OR (D.DesignationName LIKE @SearchText)
					OR (REPLACE(CONVERT(NVARCHAR,ER.FromDate,106),' ','-') LIKE @SearchText)
					OR (REPLACE(CONVERT(NVARCHAR,ER.ToDate,106),' ','-') LIKE @SearchText)
					OR (ER.Comments LIKE @SearchText))
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND ER.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND ER.InActiveDateTime IS NULL))
		  ORDER BY 
		     CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'UserName')   THEN U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'Company')    THEN  ER.Company
                              WHEN(@SortBy = 'DesignationName')   THEN D.DesignationName
                              WHEN(@SortBy = 'FromDate')       THEN CAST(CONVERT(DATETIME,ER.FromDate,121) AS sql_variant)
                              WHEN(@SortBy = 'ToDate')         THEN CAST(CONVERT(DATETIME,ER.ToDate,121) AS sql_variant)
                              WHEN(@SortBy = 'Comments')    THEN ER.Comments
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'UserName')   THEN U.FirstName + ' ' + U.SurName
                              WHEN(@SortBy = 'Company')    THEN  ER.Company
                              WHEN(@SortBy = 'DesignationName')   THEN D.DesignationName
                              WHEN(@SortBy = 'FromDate')       THEN CAST(CONVERT(DATETIME,ER.FromDate,121) AS sql_variant)
                              WHEN(@SortBy = 'ToDate')         THEN CAST(CONVERT(DATETIME,ER.ToDate,121) AS sql_variant)
                              WHEN(@SortBy = 'Comments')    THEN ER.Comments
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