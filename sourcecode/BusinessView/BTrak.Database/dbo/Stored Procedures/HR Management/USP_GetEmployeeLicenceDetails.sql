-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Employee Licence Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeLicenceDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeLicenceDetails]
(
  @EmployeeLicenceId UNIQUEIDENTIFIER = NULL,
  @EmployeeId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
  @SearchText NVARCHAR(250) = NULL,
  @PageNo INT = 1,
  @PageSize INT = 10,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection VARCHAR(50)=NULL,
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

           SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

		   IF(@SortBy IS NULL) SET @SortBy = 'FirstName'

           IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

           SELECT E.Id EmployeeId,
				  E.UserId,
                  EM.Id EmployeeLicenceDetailId,
                  U.FirstName,
                  U.SurName,
                  U.UserName Email,
                  EM.LicenceTypeId,
                  EM.LicenceNumber,
                  EM.ExpiryDate LicenceExpiryDate,
                  EM.IssuedDate LicenceIssuedDate,
                  LT.LicenceTypeName LicenceType,
                  EM.[TimeStamp],
                  U.FirstName + ' ' + U.SurName UserName,
                  CASE WHEN EM.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                  TotalCount = COUNT(1) OVER()
            FROM  [dbo].EmployeeLicence EM WITH (NOLOCK)
                  JOIN Employee E ON E.Id = EM.EmployeeId  AND E.InactiveDateTime IS NULL
                  LEFT JOIN [User] U ON U.Id = E.UserId  AND U.InactiveDateTime IS NULL
                  LEFT JOIN LicenceType LT ON LT.Id = EM.LicenceTypeId  AND LT.InactiveDateTime IS NULL
            WHERE  (@EmployeeLicenceId IS NULL OR EM.Id = @EmployeeLicenceId)
				  AND U.CompanyId = @CompanyId
				  AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
				  AND (@SearchText IS NULL 
				       OR (EM.LicenceNumber LIKE @SearchText) 
					   OR (LT.LicenceTypeName LIKE @SearchText))
				  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EM.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EM.InActiveDateTime IS NULL))

               ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'LicenceType') THEN LT.LicenceTypeName
                              WHEN(@SortBy = 'LicenceNumber') THEN  EM.LicenceNumber
                              WHEN(@SortBy = 'LicenceExpiryDate') THEN CAST(CONVERT(DATETIME,EM.ExpiryDate,121) AS sql_variant)
                              WHEN(@SortBy = 'LicenceIssuedDate') THEN CAST(CONVERT(DATETIME,EM.IssuedDate,121) AS sql_variant)
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                         CASE WHEN(@SortBy = 'LicenceType') THEN LT.LicenceTypeName
                              WHEN(@SortBy = 'LicenceNumber') THEN  EM.LicenceNumber
                              WHEN(@SortBy = 'LicenceExpiryDate') THEN CAST(CONVERT(DATETIME,EM.ExpiryDate,121) AS sql_variant)
                              WHEN(@SortBy = 'LicenceIssuedDate') THEN CAST(CONVERT(DATETIME,EM.IssuedDate,121) AS sql_variant)
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