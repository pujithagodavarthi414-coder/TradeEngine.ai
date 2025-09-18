---------------------------------------------------------------------------
-- Author       Gududhuru Raghavendra
-- Created      '2020-02-01 00:00:00.000'
-- Purpose      To Get All Users Assets
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Sai Praneeth M
-- Created      '2020-03-05 00:00:00.000'
-- Purpose      To Search Assets
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_GetAllUsersAssets  @OperationsPerformedBy = '7B3E7DD5-A05D-46F6-BD0D-FEBBA0E17190',@AssignedToEmployeeId='7B3E7DD5-A05D-46F6-BD0D-FEBBA0E17190',
--@SearchText='1',@AssetName=1
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetAllUsersAssets]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @SearchText NVARCHAR(100) = NULL,
    @AssignedToEmployeeId UNIQUEIDENTIFIER = NULL,
	@AssetId UNIQUEIDENTIFIER = NULL,
    @SupplierId UNIQUEIDENTIFIER = NULL,
    @AssetName BIT = NULL,
    @SearchAssetCode NVARCHAR(100) = NULL,
    @AssetNumber NVARCHAR(50) = NULL,
    @ProductId UNIQUEIDENTIFIER = NULL,
    @DamagedByUserId UNIQUEIDENTIFIER = NULL,
    @ProductDetailsId UNIQUEIDENTIFIER = NULL,
    @IsEmpty BIT = NULL,
    @UserId UNIQUEIDENTIFIER = NULL,
    @BranchId UNIQUEIDENTIFIER = NULL,
	@SeatingId UNIQUEIDENTIFIER = NULL,
    @IsVendor BIT = NULL,
	@ActiveAssignee BIT = NULL,
	@PurchasedDate DATE = NULL,
	@AssignedDate DATE = NULL
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
		
			IF(@AssignedToEmployeeId = '00000000-0000-0000-0000-000000000000') SET @AssignedToEmployeeId = NULL
		
			IF(@AssetId = '00000000-0000-0000-0000-000000000000') SET @AssetId = NULL
		
			IF(@SupplierId = '00000000-0000-0000-0000-000000000000') SET @SupplierId = NULL
		
			IF(@ProductId = '00000000-0000-0000-0000-000000000000') SET @ProductId = NULL
		
			IF(@DamagedByUserId = '00000000-0000-0000-0000-000000000000') SET @DamagedByUserId = NULL
		
			IF(@ProductDetailsId = '00000000-0000-0000-0000-000000000000') SET @ProductDetailsId = NULL
		
			IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL;
		
			IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL;
		
			IF(@SeatingId = '00000000-0000-0000-0000-000000000000') SET @SeatingId = NULL;
		
			IF(@AssetNumber = '') SET @AssetNumber = NULL
		
			IF(@AssetName = '') SET @AssetName = NULL
		
			IF(@AssetName=1 AND @SearchText IS NULL) SET @AssetName = 0
		    
			IF(@ActiveAssignee IS NULL) SET @ActiveAssignee  = 1
			
            SET @SearchAssetCode = '%' + RTRIM(LTRIM(@SearchAssetCode)) + '%'
		       
			SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
		
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE InactiveDateTime IS NULL AND UserId = @OperationsPerformedBy) 
	 
		    SELECT * FROM (
			SELECT U.FirstName + ' ' +ISNULL(U.SurName,'') AS UserName,
				   ((STUFF((SELECT ','+ A.AssetName + ' ' + '(' + A.AssetNumber + ')'
							FROM [Asset] AS A
                            LEFT JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
                            INNER JOIN Product P ON P.Id = PD.ProductId AND P.InactiveDateTime IS NULL AND PD.InactiveDateTime IS NULL
                            INNER JOIN Currency C ON C.Id = A.CurrencyId AND C.InactiveDateTime IS NULL 
                            INNER JOIN AssetAssignedToEmployee AAE ON AAE.AssetId = A.Id AND AAE.AssignedDateTo IS NULL
                                       AND (@UserId IS NOT NULL OR @AssetId IS NOT NULL
                                            OR A.BranchId IN (SELECT BranchId FROM EmployeeEntityBranch WHERE InactiveDateTime IS NULL AND EmployeeId = @EmployeeId))
                            INNER JOIN [User] AAU ON AAE.AssignedToEmployeeId = AAU.Id 
					                   AND ((AAU.InactiveDateTime IS NULL AND @ActiveAssignee = 1) 
						      					      OR (AAU.InactiveDateTime IS NOT NULL AND @ActiveAssignee = 0))
                            INNER JOIN Supplier S ON S.Id = PD.SupplierId AND  S.InactiveDateTime IS NULL 
                            INNER JOIN [User] AU ON AAE.ApprovedByUserId = AU.Id
                            INNER JOIN Employee AS E ON E.UserId = AAU.Id
					        LEFT JOIN SeatingArrangement AS SA ON SA.Id = A.SeatingId AND SA.InactiveDateTime IS NULL 
					        LEFT JOIN Branch AS B ON B.Id = A.BranchId AND B.InactiveDateTime IS NULL 
                            LEFT JOIN [User] DU ON A.DamagedByUserId = DU.Id AND DU.InactiveDateTime IS NULL 
					        LEFT JOIN [UserMAC] UM ON A.Id = UM.AssetId
						    WHERE P.CompanyId = @CompanyId
								 AND AAE.AssignedToEmployeeId = U.Id
								 --AND AU.Id = U.Id
								 AND (@UserId IS NULL OR AAE.AssignedToEmployeeId = @UserId)
								 AND (@BranchId IS NULL OR A.BranchId = @BranchId)
								 AND (@SeatingId IS NULL OR A.SeatingId = @SeatingId)
								 AND (@AssignedToEmployeeId IS NULL OR (AAE.AssignedToEmployeeId = @AssignedToEmployeeId))
								 AND (@AssetId IS NULL OR (A.Id = @AssetId))
								 AND (@SupplierId IS NULL OR (PD.SupplierId = @SupplierId))
								 AND (@ProductId IS NULL OR (P.Id = @ProductId))
								 AND (@ProductDetailsId IS NULL OR (A.ProductDetailsId = @ProductDetailsId))
								 AND (@AssetNumber IS NULL OR A.AssetNumber = RTRIM(LTRIM(@AssetNumber)))
								 AND (@DamagedByUserId IS NULL OR A.DamagedByUserId = @DamagedByUserId)
								 AND (@IsEmpty IS NULL OR (A.IsEmpty = @IsEmpty))
								 AND (@SearchAssetCode IS NULL OR A.AssetNumber LIKE @SearchAssetCode)
								 AND (@IsVendor IS NULL OR (A.IsVendor = @IsVendor))
								 AND ((@AssetName = 0 OR @AssetName IS NULL) OR A.AssetNumber LIKE @SearchText)
								 AND (@PurchasedDate IS NULL OR A.PurchasedDate = @PurchasedDate) 
								 AND (@AssignedDate IS NULL OR (@AssignedDate BETWEEN AAE.AssignedDateFrom AND AAE.AssignedDateTo))
								 AND (@SearchText IS NULL 
										OR (A.AssetNumber LIKE @SearchText) 
                                        OR (A.AssetName LIKE @SearchText) 
								        OR (P.ProductName LIKE @SearchText 
								      		OR PD.ManufacturerCode LIKE @SearchText 
								      		OR PD.ProductCode LIKE @SearchText 
								      		OR S.SupplierName LIKE @SearchText 
								      		OR A.Cost LIKE @SearchText 
								      		OR B.BranchName LIKE @SearchText 
								      		OR SA.SeatCode LIKE @SearchText 
								      		OR UM.MACAddress LIKE @SearchText
								      		OR AAU.FirstName +' '+ISNULL(AAU.SurName,'') LIKE @SearchText 
								      		OR AU.FirstName + ' ' +ISNULL(AU.SurName,'') LIKE @SearchText 
								      		OR DU.FirstName + ' ' + ISNULL(DU.SurName,'') LIKE @SearchText 
											)
								       OR (FORMAT(A.PurchasedDate, 'dd-MMM-yyyy hh:mm') LIKE @SearchText)
								       OR (FORMAT(A.DamagedDate, 'dd-MMM-yyyy hh:mm') LIKE @SearchText)
								       OR (FORMAT(AAE.AssignedDateFrom, 'dd-MMM-yyyy hh:mm') LIKE @SearchText)
								       OR DU.FirstName + ' ' + ISNULL(DU.SurName,'') LIKE @SearchText 
									)
									GROUP BY A.AssetName,A.AssetNumber
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))) AS Assets
			FROM [User] U
			WHERE U.CompanyId = @CompanyId AND (@AssignedToEmployeeId IS NULL OR U.Id = @AssignedToEmployeeId)
					--AND (@SearchText IS NULL OR (U.FirstName +' '+ISNULL(U.SurName,'') LIKE @SearchText))
					) T
			WHERE T.Assets IS NOT NULL
            ORDER BY T.UserName ASC
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