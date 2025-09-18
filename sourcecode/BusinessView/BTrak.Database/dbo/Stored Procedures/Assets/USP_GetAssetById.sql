-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-20 00:00:00.000'
-- Purpose      To Get Assets By AssetId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Get Assets By AssetId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_GetAssetById @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@AssetId = '3FA2254B-A680-4EB3-8CBF-1F8BF4AC1136'

CREATE PROCEDURE [dbo].[USP_GetAssetById]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@AssetId UNIQUEIDENTIFIER = NULL
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

        SELECT A.Id AS AssetId,
			   A.AssetNumber,
			   A.PurchasedDate,
			   A.ProductDetailsId,
			   P.ProductName,
			   A.AssetName,
			   A.Cost,
			   A.CurrencyId,
			   C.CurrencyName AS CurrencyType,
			   C.Symbol AS CurrencySymbol,
			   A.IsWriteOff,
			   A.DamagedDate,
			   A.DamagedReason,
			   A.IsEmpty,
			   A.IsVendor,
			   AAE.AssignedToEmployeeId,
			   AAU.FirstName +' '+ ISNULL(AAU.SurName,'') AS AssignedToEmployeeName,
			   AAE.AssignedDateFrom,
			   AAE.ApprovedByUserId,
			   AU.FirstName + ' ' + ISNULL(AU.SurName,'') AS ApprovedByEmployeeName,
			   PD.SupplierId,
			   S.SupplierName,
			   PD.ManufacturerCode,
			   PD.ProductCode,
			   A.DamagedByUserId,
			   DU.FirstName + ' ' + ISNULL(DU.SurName,'') DamagedByFullName,
			   DU.ProfileImage AS DamagedByProfileImage,
			   A.SeatingId,
			   SA.SeatCode,
			   SA.BranchId,
			   B.BranchName,
			   A.CreatedDateTime,
			   A.CreatedByUserId
			   --IIF(AAE.UpdatedDateTime IS NULL,AAE.CreatedDateTime,AAE.UpdatedDateTime) AS ApprovedDateTime

        FROM [Asset] AS A
		       INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId
		       INNER JOIN Product P ON P.Id = PD.ProductId
		       INNER JOIN Currency C ON C.Id = A.CurrencyId AND C.InActiveDateTime IS NULL
		       INNER JOIN AssetAssignedToEmployee AAE ON AAE.AssetId = A.Id
		       INNER JOIN [USER] AAU ON AAE.AssignedToEmployeeId = AAU.Id
		       INNER JOIN Supplier S ON S.Id = PD.SupplierId
		       INNER JOIN [User] AU ON AAE.ApprovedByUserId = AU.Id
			   LEFT JOIN [User] DU ON A.DamagedByUserId = DU.Id
			   LEFT JOIN [SeatingArrangement] SA ON SA.Id = A.SeatingId
			   LEFT JOIN [Branch] B ON B.Id = SA.BranchId
        WHERE (@AssetId IS NULL OR A.Id = @AssetId)
			  AND P.CompanyId = @CompanyId
    
	    END
	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END
    END TRY
    BEGIN CATCH
        
         EXEC [dbo].[USP_GetErrorInformation]

    END CATCH
END
GO