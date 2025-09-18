-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-18 00:00:00.000'
-- Purpose      To Get Audit
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetAudit] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetAudit]
(
	@SortBy NVARCHAR(100) = NULL,
    @SortDirection VARCHAR(50)=NULL,
    @PageSize INT = NULL,
    @PageNumber INT = NULL,
    @FeatureId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
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
		
		IF (@FeatureId = '00000000-0000-0000-0000-000000000000') SET @FeatureId = NULL

		IF (@PageSize IS NULL) SET @PageSize = (SELECT COUNT(1) FROM [Audit])

		IF (@PageNumber IS NULL) SET @PageNumber = 1

		IF (@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'

		IF (@SortDirection IS NULL) SET @SortDirection = 'DESC'

		SELECT A.Id AS AuditId,
			   A.AuditJson,
			   A.IsOldAudit,
			   A.CreatedByUserId,
			   U.FirstName AS CreatedByUserFirstName,
			   U.SurName AS CreatedByUserSurName,
			   U.FirstName + ' ' + ISNULL(U.SurName,'') AS CreatedByUserFullName,
			   U.ProfileImage AS CreatedByUserProfileImage,
			   A.CreatedDateTime 
		FROM [Audit] A
			 INNER JOIN [User] U ON U.Id = A.CreatedByUserId AND U.InActiveDateTime IS NULL
		WHERE U.CompanyId = @CompanyId
		      AND (@FeatureId IS NULL OR @FeatureId = JSON_VALUE(A.AuditJson,'$.FeatureId'))
		ORDER BY CASE WHEN @SortDirection = 'ASC' THEN
					  CASE WHEN @SortBy = 'CreatedDateTime' THEN CONVERT(DATETIME,A.CreatedDateTime,121)
					       WHEN @SortBy = 'IsOldAudit' THEN A.IsOldAudit
					       WHEN @SortBy = 'CreatedByUserName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
					  END
				 END ASC,
				 CASE WHEN @SortDirection = 'DESC' THEN
					  CASE WHEN @SortBy = 'CreatedDateTime' THEN CONVERT(DATETIME,A.CreatedDateTime,121)
					       WHEN @SortBy = 'IsOldAudit' THEN A.IsOldAudit
					       WHEN @SortBy = 'CreatedByUserName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
					  END
				 END DESC
		OFFSET ((@PageNumber - 1) * @PageSize) ROWS
		FETCH NEXT @PageSize ROWS ONLY
END
END TRY
BEGIN CATCH
	
	EXEC [dbo].[USP_GetErrorInformation]

END CATCH
END
