-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-22 00:00:00.000'
-- Purpose      To Search Suppliers By SupplierId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search Suppliers By SupplierId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_GetSupplierById @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@SupplierId = '13A22ECA-BAF5-45D2-999C-40D6B28EA2A0'

CREATE PROCEDURE [dbo].[USP_GetSupplierById]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@SupplierId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
     BEGIN TRY

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
			   S.CreatedDateTime AS CreatedDate,
			   S.CreatedByUserId,
			   CASE WHEN S.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
        FROM Supplier AS S WITH (NOLOCK)
        WHERE (@SupplierId IS NULL OR S.Id = @SupplierId)
		      AND S.CompanyId = @CompanyId 
			  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))
    END
    ELSE
	 RAISERROR(@HavePermission,11,1)
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END
GO