--EXEC  [dbo].[USP_GetAllSuppliers] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetAllSuppliers]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SupplierId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(250) = NULL,
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
			   --CONVERT(nvarchar(30), S.StartedWorkingFrom, 106) AS StartedWorkingOn,
			   S.CreatedDateTime AS CreatedDate,
			   --CONVERT(nvarchar(30), S.CreatedDateTime, 106) AS CreatedOn,
			   S.CreatedByUserId,
			   CASE WHEN S.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
        FROM Supplier AS S WITH(NOLOCK)  
        WHERE (@SupplierId IS NULL OR S.Id = @SupplierId)
			  AND (@SearchText IS NULL OR (S.SupplierName LIKE '%'+ LOWER(@SearchText)+'%'))
			  AND S.CompanyId = @CompanyId 
			  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))
        ORDER BY S.SupplierName ASC 
        
   END
	ELSE
	 RAISERROR(@HavePermission,11,1)
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END
GO
