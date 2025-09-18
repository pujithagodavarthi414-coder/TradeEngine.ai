-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Get the Roles By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetRolesDropDown]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@SearchText = 'CEO'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetRolesDropDown]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
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

	      SELECT R.Id RoleId,
				 R.RoleName
		  FROM  [dbo].[Role] AS R WITH (NOLOCK)
		  WHERE R.InactiveDateTime IS NULL
		        AND (R.CompanyId = @CompanyId)
				AND (@SearchText IS NULL OR R.RoleName LIKE '%'+ @SearchText+'%')
				AND (R.IsHidden = 0 OR R.IsHidden IS NULL)
		  ORDER BY RoleName ASC 

	END
	 ELSE
	 RAISERROR(@HavePermission,11,1)
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END