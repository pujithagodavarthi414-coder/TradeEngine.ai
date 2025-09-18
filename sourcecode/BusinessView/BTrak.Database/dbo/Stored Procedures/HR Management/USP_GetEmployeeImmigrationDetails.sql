-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Contact Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEmployeeImmigrationDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'


CREATE PROCEDURE [dbo].[USP_GetEmployeeImmigrationDetails]
(
   @EmployeeImmigration UNIQUEIDENTIFIER = NULL,
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

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF(@SortBy IS NULL) SET @SortBy = 'Document'

            IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'
	      
		    IF(@SearchText = '') SET @SearchText = NULL

			  SET @SearchText = '%'+  RTRIM(LTRIM(@SearchText)) +'%'

		   SELECT E.Id EmployeeId,
					 EI.Id EmployeeImmigrationId,
					 E.UserId,
			         U.FirstName,
					 U.SurName,
					 U.UserName Email,
					 EI.Document,
					 EI.DocumentNumber,
					 EI.IssuedDate,
					 EI.ExpiryDate,
					 EI.EligibleStatus,
					 EI.EligibleReviewDate,
					 EI.Comments,
					 EI.ActiveFrom,
					 EI.ActiveTo,
					 EI.CountryId,
					 C.CountryName,
					 EI.[TimeStamp],
					 U.FirstName + ' ' + U.SurName UserName,
					 CASE WHEN EI.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					 TotalCount = COUNT(1) OVER()

			  FROM  [dbo].EmployeeImmigration AS EI WITH (NOLOCK) 
					INNER JOIN Employee E WITH (NOLOCK) ON E.Id = EI.EmployeeId AND E.InactiveDateTime IS NULL
			        INNER JOIN [User] U WITH (NOLOCK) ON U.Id = E.UserId AND U.InactiveDateTime IS NULL
					INNER JOIN [Country] C ON C.Id = EI.CountryId AND C.InactiveDateTime IS NULL
			  WHERE (@EmployeeImmigration IS NULL OR EI.Id = @EmployeeImmigration)
					AND U.CompanyId = @CompanyId
			       AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
			       AND (@SearchText IS NULL 
				        OR (EI.Document LIKE @SearchText)
					    OR (EI.DocumentNumber LIKE @SearchText)
						OR (C.CountryName LIKE @SearchText))
				  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EI.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EI.InActiveDateTime IS NULL))
			  ORDER BY  
			          CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'Document')   THEN  EI.Document
							  WHEN(@SortBy = 'CountryName')   THEN  C.CountryName
                              WHEN(@SortBy = 'DocumentNumber')     THEN EI.DocumentNumber
                              WHEN(@SortBy = 'IssuedDate') THEN CAST(CONVERT(DATETIME,EI.IssuedDate,121) AS sql_variant)
                              WHEN(@SortBy = 'ExpiryDate') THEN CAST(CONVERT(DATETIME,EI.ExpiryDate,121) AS sql_variant)
                          END
                      END ASC,
                      CASE WHEN @SortDirection = 'DESC' THEN
                          CASE WHEN(@SortBy = 'Document')   THEN  EI.Document
							   WHEN(@SortBy = 'CountryName')   THEN  C.CountryName
                               WHEN(@SortBy = 'DocumentNumber')     THEN EI.DocumentNumber
                               WHEN(@SortBy = 'IssuedDate') THEN CAST(CONVERT(DATETIME,EI.IssuedDate,121) AS sql_variant)
                               WHEN(@SortBy = 'ExpiryDate') THEN CAST(CONVERT(DATETIME,EI.ExpiryDate,121) AS sql_variant)
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
