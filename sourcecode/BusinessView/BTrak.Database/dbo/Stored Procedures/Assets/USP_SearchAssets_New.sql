-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-20 00:00:00.000'
-- Purpose      To Search Assets
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Search Assets
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_SearchAssets_New  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@GetAllDamaged=null,@ActiveAssignee = 0
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SearchAssets_New]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @PageSize INT = 10,
    @PageNumber INT = NULL,
    @GetByUser BIT = NULL,
    @GetAllDamaged BIT = NULL,
    @GetAllAssigned BIT = NULL,
    @SearchText NVARCHAR(100) = NULL,
    @AssignedToEmployeeId UNIQUEIDENTIFIER = NULL,
	@AssetId UNIQUEIDENTIFIER = NULL,
    @SupplierId UNIQUEIDENTIFIER = NULL,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection VARCHAR(50)=NULL,
    @SearchAssetCode NVARCHAR(100) = NULL,
    @ProductId UNIQUEIDENTIFIER = NULL,
    @DamagedByUserId UNIQUEIDENTIFIER = NULL,
    @ProductDetailsId UNIQUEIDENTIFIER = NULL,
    @IsEmpty BIT = NULL,
    @UserId UNIQUEIDENTIFIER = NULL,
    @BranchId UNIQUEIDENTIFIER = NULL,
    @EntityId UNIQUEIDENTIFIER = NULL,
	@SeatingId UNIQUEIDENTIFIER = NULL,
    @IsVendor BIT = NULL,
    @AllPurchasedAssets BIT = NULL,
	@ActiveAssignee BIT = NULL,
	@IsListOfAssetsPage BIT = NULL,
	@PurchasedDate DATE = NULL,
	@AssignedDate DATE = NULL,
	@AssetIds NVARCHAR(MAX) = NULL
    --@IsWriteOff BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
			   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			   IF (@HavePermission = '1')
			   BEGIN
			   	
		       IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
			   	
               IF(@Pagesize IS NULL) SET @Pagesize = (SELECT COUNT(1) FROM Asset)
                DECLARE @DateAssets DATETIME=NULL
		       
               IF(@Pagenumber IS NULL) SET @Pagenumber = 1
		       
               IF(@SearchText = '') SET @SearchText = NULL
		       
               IF(@AllPurchasedAssets=1)
               BEGIN
                SET @DateAssets = GETDATE()
                DECLARE @StartDate DATETIME = (SELECT  DATEADD(DAY, -7, CAST(@DateAssets AS DATE)))   
               END
		       
               IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
		       
               IF(@SortDirection IS NULL) SET @SortDirection = 'ASC'
               
               IF(@AssignedToEmployeeId = '00000000-0000-0000-0000-000000000000') SET @AssignedToEmployeeId = NULL
		       
			   DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE InactiveDateTime IS NULL AND UserId = @OperationsPerformedBy) 

			   IF(@AssetId = '00000000-0000-0000-0000-000000000000') SET @AssetId = NULL

               IF(@SupplierId = '00000000-0000-0000-0000-000000000000') SET @SupplierId = NULL
		       
               IF(@ProductId = '00000000-0000-0000-0000-000000000000') SET @ProductId = NULL
		       
               IF(@DamagedByUserId = '00000000-0000-0000-0000-000000000000') SET @DamagedByUserId = NULL
		       
               IF(@ProductDetailsId = '00000000-0000-0000-0000-000000000000') SET @ProductDetailsId = NULL
		       
               IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL;
		       
               IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL;

			   IF(@SeatingId = '00000000-0000-0000-0000-000000000000') SET @SeatingId = NULL;
		       
               IF(@GetAllAssigned = 0) SET @GetAllAssigned = NULL
               
               IF(@GetByUser = 0) SET @GetByUser = NULL
		       
               SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

               SET @SearchAssetCode = '%' + RTRIM(LTRIM(@SearchAssetCode)) + '%'
		       
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			   
			   IF(@ActiveAssignee IS NULL) SET @ActiveAssignee  = 1
		       
			   SET @AssignedDate = CONVERT(DATE,@AssignedDate)

               SELECT A.Id AS AssetId,
                      A.AssetNumber,
                      A.PurchasedDate,
                      A.ProductDetailsId,
                      A.ProductId,
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
                      AAU.FirstName +' '+ISNULL(AAU.SurName,'') AS AssignedToEmployeeName,
                      AAU.ProfileImage AS AssignedToEmployeeProfileImage,
                      AAU.Id AS AssignedToUserId,
                      AAE.AssignedDateFrom,
                      AAE.ApprovedByUserId,
                      AU.FirstName + ' ' +ISNULL(AU.SurName,'') AS ApprovedByEmployeeName,
                      AAU.ProfileImage AS ApprovedByEmployeeProfileImage,
					  CASE WHEN (AAE.AssignedToEmployeeId =  AAE.ApprovedByUserId ) THEN 1 ELSE 0 END IsSelfApproved,
                      PD.SupplierId,
                      S.SupplierName,
                      PD.ManufacturerCode,
                      PD.ProductCode,
                      A.DamagedByUserId,
                      DU.FirstName + ' ' + ISNULL(DU.SurName,'') DamagedByFullName,
                      DU.ProfileImage AS DamagedByProfileImage,
					  A.BranchId,
					  B.BranchName,
					  SA.Id SeatingId,
					  SA.SeatCode,
					  UM.MACAddress AS AssetUniqueNumber,
					  UM.Id AS AssetUniqueNumberId,
                      A.CreatedDateTime,
                      A.CreatedByUserId,
					  A.[TimeStamp],
                      TotalCount = COUNT(1) OVER()
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
                     AND (@DateAssets IS NULL OR (A.PurchasedDate <= @DateAssets AND A.PurchasedDate >= @StartDate))
					 AND (@AssetIds IS NULL OR A.Id IN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@AssetIds,',')))
                     AND (@UserId IS NULL OR AAE.AssignedToEmployeeId = @UserId)
                     AND (@BranchId IS NULL OR A.BranchId = @BranchId)
                     AND (@EntityId IS NULL OR A.BranchId IN (SELECT BranchId FROM EntityBranch WHERE InactiveDateTime IS NULL AND EntityId = @EntityId))
					 AND (@SeatingId IS NULL OR A.SeatingId = @SeatingId)
                     AND (@GetAllAssigned IS NULL OR (@GetAllAssigned = 1 AND A.IsEmpty = 0))
                     AND (@GetAllDamaged IS NULL OR A.IsWriteOff = @GetAllDamaged )
                     AND (@GetByUser IS NULL OR (@GetByUser = 1 AND (AAE.AssignedToEmployeeId = @OperationsPerformedBy)))
                     AND (@AssignedToEmployeeId IS NULL OR (AAE.AssignedToEmployeeId = @AssignedToEmployeeId))
					 AND (@AssetId IS NULL OR (A.Id = @AssetId))
                     AND (@SupplierId IS NULL OR (PD.SupplierId = @SupplierId))
                     AND (@ProductId IS NULL OR (P.Id = @ProductId))
                     AND (@ProductDetailsId IS NULL OR (A.ProductDetailsId = @ProductDetailsId))
                     AND (@DamagedByUserId IS NULL OR A.DamagedByUserId = @DamagedByUserId)
                     AND (@IsEmpty IS NULL OR (A.IsEmpty = @IsEmpty))
                     AND (@IsVendor IS NULL OR (A.IsVendor = @IsVendor))
                     AND (@SearchAssetCode IS NULL OR A.AssetNumber LIKE @SearchAssetCode)
					 AND (@PurchasedDate IS NULL OR A.PurchasedDate = @PurchasedDate) 
                    -- AND (@IsWriteOff IS NULL OR (A.IsWriteOff = @IsWriteOff))
					 AND (@AssignedDate IS NULL 
					      OR ((AAE.AssignedDateTo IS NULL AND (CONVERT(DATE,AAE.AssignedDateFrom) = @AssignedDate) ) 
						       OR (@AssignedDate BETWEEN CONVERT(DATE,AAE.AssignedDateFrom) AND CONVERT(DATE,AAE.AssignedDateTo))))
					 AND (@SearchText IS NULL OR (A.AssetNumber LIKE @SearchText) 
                                              OR (A.AssetName LIKE @SearchText) 
											  OR (@IsListOfAssetsPage = 1 AND 
												  (P.ProductName LIKE @SearchText 
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
												 )
                                              OR (@GetAllAssigned = 1 AND AAU.FirstName + ' ' + ISNULL(AAU.SurName,'') LIKE @SearchText)
											  OR ((@AllPurchasedAssets = 1 OR @IsListOfAssetsPage = 1) AND FORMAT(A.PurchasedDate, 'dd-MMM-yyyy hh:mm') LIKE @SearchText)
											  OR ((@GetAllDamaged = 1  OR @IsListOfAssetsPage = 1) AND FORMAT(A.DamagedDate, 'dd-MMM-yyyy hh:mm') LIKE @SearchText)
											  OR ((@GetAllAssigned = 1 OR @GetByUser = 1 OR @IsListOfAssetsPage = 1) AND FORMAT(AAE.AssignedDateFrom, 'dd-MMM-yyyy hh:mm') LIKE @SearchText)
													OR DU.FirstName + ' ' + ISNULL(DU.SurName,'') LIKE @SearchText 
											  )
               ORDER BY 
                           CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                                CASE WHEN(@SortBy = 'AssetNumber') THEN A.AssetNumber
                                     WHEN(@SortBy = 'AssetName') THEN  A.AssetName
                                     WHEN(@SortBy = 'PurchasedDate') THEN CAST(CONVERT(DATETIME,A.PurchasedDate,121) AS sql_variant)
                                     WHEN(@SortBy = 'AssignedToEmployeeName') THEN AAU.FirstName +' '+ISNULL(AAU.SurName,'')
									 WHEN(@SortBy = 'ApprovedByEmployeeName') THEN AU.FirstName +' '+ISNULL(AU.SurName,'')
                                     WHEN(@SortBy = 'AssignedDateFrom') THEN CAST(CONVERT(DATETIME,AAE.AssignedDateFrom,121) AS sql_variant)
                                     WHEN(@SortBy = 'DamagedByFullName') THEN ISNULL(DU.FirstName,'') + ' ' + ISNULL(DU.SurName,'')
                                     WHEN(@SortBy = 'DamagedDate') THEN CAST(CONVERT(DATETIME,A.DamagedDate,121) AS sql_variant)
                                     WHEN(@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME,A.CreatedDateTime,121) AS sql_variant)
                                 END
                             END ASC,
                            CASE WHEN @SortDirection = 'DESC' THEN
                                 CASE WHEN(@SortBy = 'AssetNumber') THEN A.AssetNumber
                                     WHEN(@SortBy = 'AssetName') THEN  A.AssetName
                                     WHEN(@SortBy = 'PurchasedDate') THEN CAST(CONVERT(DATETIME,A.PurchasedDate,121) AS sql_variant)
                                     WHEN(@SortBy = 'AssignedToEmployeeName') THEN AAU.FirstName +' '+ISNULL(AAU.SurName,'')
									 WHEN(@SortBy = 'ApprovedByEmployeeName') THEN AU.FirstName +' '+ISNULL(AU.SurName,'')
                                     WHEN(@SortBy = 'AssignedDateFrom') THEN CAST(CONVERT(DATETIME,AAE.AssignedDateFrom,121) AS sql_variant)
                                     WHEN(@SortBy = 'DamagedByFullName') THEN ISNULL(DU.FirstName,'') + ' ' + ISNULL(DU.SurName,'')
                                     WHEN(@SortBy = 'DamagedDate') THEN CAST(CONVERT(DATETIME,A.DamagedDate,121) AS sql_variant)
                                     WHEN(@SortBy = 'CreatedDateTime') THEN CAST(CONVERT(DATETIME,A.CreatedDateTime,121) AS sql_variant)
                                 END
                             END DESC
                       OFFSET ((@PageNumber - 1) * @PageSize) ROWS
               FETCH NEXT @PageSize ROWS ONLY
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