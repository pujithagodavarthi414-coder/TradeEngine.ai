-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-22 00:00:00.000'
-- Purpose      To Search Suppliers
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search Suppliers
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_SearchSuppliers @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971' 
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchSuppliers] 
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SupplierId UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(250) = NULL, 
    @Pagesize INT = NULL,
    @Pagenumber INT = NULL,
    @SupplierCompanyName NVARCHAR(250) = NULL,
    @ContactPerson NVARCHAR(250) = NULL,
    @VendorIntroducedBy NVARCHAR(250) = NULL,
    @IsArchived BIT = NULL,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection VARCHAR(50)= NULL,
    @StartedWorkingFrom DATETIME = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
    
        IF (@HavePermission = '1')
        BEGIN

        IF(@SearchText = '') SET @SearchText = NULL

        IF(@Pagesize IS NULL) SET @Pagesize = (SELECT COUNT(1) FROM Supplier)

        IF(@Pagesize = 0) SET @Pagesize =10

        IF(@Pagenumber IS NULL) SET @Pagenumber = 1

        IF(@SupplierCompanyName = '') SET @SupplierCompanyName = NULL

        IF(@ContactPerson = '') SET @ContactPerson = NULL

        IF(@VendorIntroducedBy = '') SET @VendorIntroducedBy = NULL

        IF(@StartedWorkingFrom = '') SET @StartedWorkingFrom = NULL
		       
        IF(@SortBy IS NULL) SET @SortBy = 'SupplierName'

        IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'

        SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       
        SELECT S.Id AS SupplierId, 
               S.CompanyId,
               S.SupplierName,
               S.CompanyName AS SupplierCompanyName,
               S.ContactPerson,
               S.ContactPosition,
               S.CompanyPhoneNumber,
               S.ContactPhoneNumber,
               S.VendorIntroducedBy,
               S.StartedWorkingFrom,
               S.CreatedDateTime AS CreatedDate,
               S.CreatedByUserId,
               CASE WHEN S.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
			   S.[TimeStamp],
               TotalCount = COUNT(1) OVER()
        FROM Supplier AS S 
        WHERE (@SupplierId IS NULL OR S.Id = @SupplierId)
              AND (@SearchText IS NULL OR (S.SupplierName LIKE @SearchText)  
			       OR (S.ContactPerson LIKE @SearchText)  
				   OR (S.VendorIntroducedBy LIKE @SearchText)  
			       OR (S.CompanyName LIKE @SearchText)  
				   OR (S.ContactPosition LIKE @SearchText) 
				   OR (S.CompanyPhoneNumber LIKE @SearchText) 
				   OR (S.ContactPhoneNumber LIKE @SearchText)
                   OR (REPLACE(CONVERT(NVARCHAR(100), S.StartedWorkingFrom, 106), ' ', '-') LIKE @SearchText)
				   OR (SUBSTRING(CONVERT(VARCHAR, S.CreatedDateTime, 106),1,2) + '-'
                                                  + SUBSTRING(CONVERT(VARCHAR, S.CreatedDateTime, 106),4,3) + '-'
                                                  + CONVERT(VARCHAR,DATEPART(YEAR,S.CreatedDateTime)) 
                                                  + ' '+CAST(DATEPART(HOUR, S.CreatedDateTime) AS VARCHAR) + ':' + CAST(DATEPART(MINUTE, S.CreatedDateTime) AS VARCHAR)) LIKE @SearchText)         
              AND (@SupplierCompanyName IS NULL OR (S.CompanyName LIKE '%'+ LOWER(@SupplierCompanyName)+'%'))
              AND (@ContactPerson IS NULL OR (S.ContactPerson LIKE '%'+ LOWER(@ContactPerson)+'%'))
              AND (@VendorIntroducedBy IS NULL OR (S.VendorIntroducedBy LIKE '%'+ LOWER(@VendorIntroducedBy)+'%'))
              AND (@StartedWorkingFrom IS NULL OR S.StartedWorkingFrom = @StartedWorkingFrom)
              AND (S.CompanyId = @CompanyId) 
			  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))
        ORDER BY 
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                         CASE WHEN(@SortBy = 'SupplierName') THEN S.SupplierName
                              WHEN(@SortBy = 'CreatedDate') THEN  CAST(CONVERT(DATETIME,S.CreatedDateTime,121) AS sql_variant)
                              WHEN @SortBy = 'SupplierCompanyName' THEN S.CompanyName
                              WHEN @SortBy = 'ContactPerson' THEN S.ContactPerson
                              WHEN @SortBy = 'ContactPosition' THEN S.ContactPosition
                              WHEN @SortBy = 'CompanyPhoneNumber' THEN S.CompanyPhoneNumber
                              WHEN @SortBy = 'ContactPhoneNumber' THEN S.ContactPhoneNumber
                              WHEN @SortBy = 'VendorIntroducedBy' THEN S.VendorIntroducedBy
                              WHEN @SortBy = 'StartedWorkingFrom' THEN CAST(S.StartedWorkingFrom AS sql_variant)
                          END
                      END ASC,
                     CASE WHEN @SortDirection = 'DESC' THEN
                          CASE WHEN(@SortBy = 'SupplierName') THEN S.SupplierName
                              WHEN(@SortBy = 'CreatedDate') THEN  CAST(CONVERT(DATETIME,S.CreatedDateTime,121) AS sql_variant)
                              WHEN @SortBy = 'SupplierCompanyName' THEN S.CompanyName
                              WHEN @SortBy = 'ContactPerson' THEN S.ContactPerson
                              WHEN @SortBy = 'ContactPosition' THEN S.ContactPosition
                              WHEN @SortBy = 'CompanyPhoneNumber' THEN S.CompanyPhoneNumber
                              WHEN @SortBy = 'ContactPhoneNumber' THEN S.ContactPhoneNumber
                              WHEN @SortBy = 'VendorIntroducedBy' THEN S.VendorIntroducedBy
                              WHEN @SortBy = 'StartedWorkingFrom' THEN CAST(S.StartedWorkingFrom AS sql_variant)
                          END
                      END DESC
                OFFSET ((@PageNumber - 1) * @PageSize) ROWS
        FETCH NEXT @Pagesize ROWS ONLY
        END
        ELSE
        BEGIN
        
                RAISERROR (@HavePermission,11, 1)
                
        END
   END TRY
   BEGIN CATCH
       
       THROW
   END CATCH 
END
GO