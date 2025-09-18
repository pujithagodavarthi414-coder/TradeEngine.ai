-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Job Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeJobDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeJobDetails]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
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

			  SET @SearchText = '%'+ @SearchText+'%'

			  SELECT E.Id EmployeeId,
					 J.Id EmployeeJobDetailId,
			         U.FirstName,
					 U.SurName,
					 U.UserName Email,
					 J.DesignationId,
					 D.DesignationName,
					 J.EmploymentStatusId,
					 ES.EmploymentStatusName EmploymentStatus,
					 ES.IsPermanent,
					 J.JobCategoryId,
					 JC.JobCategoryType JobCategoryName,
					 J.JoinedDate,
					 J.DepartmentId,
					 DE.DepartmentName,
					 J.BranchId,
					 B.BranchName,
					 J.[TimeStamp],
					 J.NoticePeriodInMonths,
					 U.FirstName + ' ' + U.SurName UserName,
					 CASE WHEN J.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					 TotalCount = COUNT(1) OVER()

			  FROM  [dbo].Job J WITH (NOLOCK)
					JOIN Employee E ON E.Id = J.EmployeeId AND E.InActiveDateTime IS NULL
			        JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
					JOIN EmploymentStatus ES ON ES.Id = J.EmploymentStatusId AND ES.InActiveDateTime IS NULL
					JOIN JobCategory JC ON JC.Id = J.JobCategoryId AND JC.InActiveDateTime IS NULL
					LEFT JOIN Designation D ON D.Id = J.DesignationId AND D.InActiveDateTime IS NULL
					LEFT JOIN Department DE ON DE.Id = J.DepartmentId AND DE.InActiveDateTime IS NULL
					LEFT JOIN Branch B ON B.Id = J.BranchId AND B.InActiveDateTime IS NULL
			  WHERE (@EmployeeId IS NULL OR E.Id = @EmployeeId)
					AND U.CompanyId = @CompanyId
			       AND (@SearchText IS NULL 
				        OR (E.NickName LIKE @SearchText)
					    OR (U.FirstName LIKE @SearchText)
						OR (U.SurName LIKE @SearchText)
						OR (U.UserName LIKE @SearchText))
				   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND J.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND J.InActiveDateTime IS NULL))
			  ORDER BY U.FirstName + ' ' +ISNULL(U.SurName,'') ASC

			  OFFSET ((@PageNo - 1) * @PageSize) ROWS

			FETCH NEXT @PageSize ROWS ONLY
		END

	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END