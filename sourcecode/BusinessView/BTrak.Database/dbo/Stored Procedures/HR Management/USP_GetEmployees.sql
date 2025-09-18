-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-22 00:00:00.000'
-- Purpose      To Get Employees By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployees] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEmployees]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER ,
   @SearchText NVARCHAR(250) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @EntityId UNIQUEIDENTIFIER = NULL
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
	      
		  IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
          
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF(@SearchText = '') SET @SearchText = NULL

	      SELECT E.Id,
		         E.UserId,
                 E.EmployeeNumber,
                 E.GenderId,
				 E.BranchId,
                 E.MaritalStatusId,
                 E.NationalityId,
                 E.DateofBirth,
                 E.Smoker,
                 E.MilitaryService,
                 E.NickName,
                 E.CreatedDateTime,
                 E.CreatedByUserId,
				 U.FirstName,
				 U.SurName,
				 U.FirstName + ' ' +ISNULL(U.SurName,'') EmployeeName,
				 U.ProfileImage
		  FROM  [dbo].[Employee] AS E WITH (NOLOCK)
		        JOIN [User] U ON U.Id = E.UserId
	            INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                       AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                       AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                           AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
		  WHERE (@EmployeeId IS NULL OR E.Id = @EmployeeId)
				AND U.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (E.NickName LIKE '%'+ @SearchText+'%'))
		  ORDER BY U.FirstName + ' ' +ISNULL(U.SurName,'') ASC

		  OFFSET ((@PageNo - 1) * @PageSize) ROWS

          FETCH NEXT @PageSize ROWS ONLY
	
	END

	 END TRY  
	 BEGIN CATCH 
		
		   EXEC USP_GetErrorInformation

	END CATCH
END