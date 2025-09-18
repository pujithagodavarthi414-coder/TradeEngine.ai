-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Get the Users By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_SuppliersDropDown]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' ,@SearchText = 'E Technologies'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SuppliersDropDown] 
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @SearchText NVARCHAR(250) = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
    
        IF(@SearchText = '') SET @SearchText = NULL

        SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       
        SELECT S.Id AS SupplierId, 
               S.SupplierName
        FROM Supplier AS S 
        WHERE S.InactiveDateTime IS NULL
              AND (@SearchText IS NULL 
			      OR (S.SupplierName LIKE @SearchText))         
              AND (S.CompanyId = @CompanyId) 
        ORDER BY SupplierName
                   
   END TRY
   BEGIN CATCH
       
       THROW
   END CATCH 
END
GO