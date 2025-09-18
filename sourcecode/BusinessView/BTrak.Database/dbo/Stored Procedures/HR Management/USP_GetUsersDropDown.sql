-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Get the Users By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetUsersDropDown]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @SearchText = 'Srihari U'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUsersDropDown]
(
  @OperationsPerformedBy  UNIQUEIDENTIFIER ,
  @SearchText NVARCHAR(250) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
        BEGIN
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
          
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
          IF(@SearchText = '') SET @SearchText = NULL
		  
		  IF(@SearchText IS NOT NULL)
			SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

            SELECT U.Id AS Id,
                   U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
				   U.ProfileImage,
				   U.UserName
           FROM  [dbo].[User] U WITH (NOLOCK)
           LEFT JOIN [dbo].[Employee]E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InactiveDateTime IS NULL
	       LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                  AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
           WHERE U.CompanyId = @CompanyId
                 AND (@SearchText IS NULL OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText))
	             AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
           ORDER BY  U.FirstName +' '+ISNULL(U.SurName,'')       
          
    END

	END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO