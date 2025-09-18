CREATE PROCEDURE [dbo].[USP_SearchAssets]
(
   @Id UNIQUEIDENTIFIER = NULL,
   @AssetId nvarchar(50) = NULL,
   @ProductName  nvarchar(250) = NULL,
   @ManufacturerCode nvarchar(100) = NULL,
   @ApprovedDate datetime = NULL,
   @AssignedTo UNIQUEIDENTIFIER = NULL,
   @ApprovedBy UNIQUEIDENTIFIER = NULL,
   @PurchasedDate datetime = NULL,
   @AssignedDateTime datetime = NULL,
   @IsWriteOff bit = NULL,
   @IsVendor bit= NULL,
   @SupplierId UNIQUEIDENTIFIER = NULL,
   @ProductId UNIQUEIDENTIFIER = NULL,
   @CompanyId UNIQUEIDENTIFIER,
   @PageSize INT = 100,
   @skip INT = 0,
   @SearchAssetName NVARCHAR(250)= NULL,
   @SearchAssignee NVARCHAR(250)= NULL,
   @SearchProductName NVARCHAR(250)= NULL,
   @SearchSuuplier NVARCHAR(250)= NULL,
   @OrderByColumnName NVARCHAR(250)= NULL,
   @OrderByDirectionAsc BIT = 1,
   @IsEmpty BIT = NULL
)
AS
BEGIN

	DECLARE @SearchSqlScript NVARCHAR(MAX)  
	DECLARE @lFirstRec  INT,
			@lLastRec   INT
	
	DECLARE @OrderByDirection NVARCHAR(250) 
	IF(@OrderByDirectionAsc = 1 OR @OrderByDirectionAsc IS NULL)
	BEGIN
		SET @OrderByDirection = 'Desc'
	END
	ELSE
	BEGIN
		SET @OrderByDirection = 'Asc'
	END

	DECLARE @OrderByColumn NVARCHAR(250) 
	IF(@OrderByColumnName IS NULL)
	BEGIN
		SET @OrderByColumn = 'ApprovedDateTime'
	END
	ELSE
	BEGIN
		SET @OrderByColumn = @OrderByColumnName
	END

	SET @lFirstRec  = @skip
	SET @lLastRec   = @skip + @pageSize
	SET @SearchAssetName = LOWER(@SearchAssetName)
	SET @SearchAssignee = LOWER(@SearchAssignee)
	SET @SearchProductName = LOWER(@SearchProductName)
	SET @SearchSuuplier = LOWER(@SearchSuuplier)

	SET @SearchSqlScript = N'WITH CTE_Results AS (SELECT A.Id Id,A.AssetNumber,A.AssetName,AE.AssignedToEmployeeId
	                                                     ,UAT.FirstName AssignedToFirstName
	                                                     ,UAT.SurName AssignedToSurName,
													AE.ApprovedByUserId,UAB.FirstName AssignedByFirstName,A.PurchasedDate,AE.AssignedDateFrom,
													UAB.SurName AssignedBySurName, AE.CreatedDateTime ApprovedDateTime,A.Cost Cost,M.[CurrencyName] CurrencyDetails,A.IsVendor,A.IsEmpty,A.IsWriteOff,
													A.DamagedDate,A.DamagedReason,P.ProductName,
													PD.ManufacturerCode,PD.ProductCode,S.Id SupplierId,S.SupplierName,
													P.CompanyId,P.Id ProductId,M.Id CurrencyId FROM Asset A
													JOIN AssetAssignedToEmployee AE ON AE.AssetId = A.Id AND AssignedDateTo IS NULL
													JOIN [User] UAT ON UAT.Id = AE.AssignedToEmployeeId
													JOIN [User] UAB ON UAB.Id = AE.ApprovedByUserId
													JOIN Product P ON P.Id = A.ProductId
													LEFT JOIN ProductDetails PD ON  P.Id = PD.ProductId
													JOIN Currency M ON M.Id = A.CurrencyId
													LEFT JOIN Supplier S ON PD.SupplierId = S.Id
													WHERE (P.CompanyId = @CompanyId)'
												 
	IF(@Id IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (A.Id = @Id)'
	IF(@AssetId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (A.AssetNumber = @AssetId)' 
	IF(@SupplierId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (SupplierId = @SupplierId)' 
	IF(@ProductId IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (P.Id = @ProductId)' 
	IF(@ProductName IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (P.ProductName LIKE ''%''+ @ProductName +''%'')' 
	IF(@ManufacturerCode IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (PD.ManufacturerCode LIKE ''%''+ @ManufacturerCode +''%'')' 
	IF(@ApprovedDate IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (CONVERT(DATE,AE.CreatedDateTime) = CONVERT(DATE,@ApprovedDate))' 
	IF(@AssignedTo IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (AE.AssignedToEmployeeId = @AssignedTo)'
	IF(@ApprovedBy IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (AE.ApprovedByUserId = @ApprovedBy)'
	IF(@PurchasedDate IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (CONVERT(DATE,A.PurchasedDate) = CONVERT(DATE,@PurchasedDate))' 
	IF(@AssignedDateTime IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (CONVERT(DATE,AE.AssignedDateFrom) = CONVERT(DATE,@AssignedDateTime))'
	IF(@IsWriteOff IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (A.IsWriteOff = @IsWriteOff)' 
	IF(@IsVendor IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (A.IsVendor = @IsVendor)' 
	IF(@IsEmpty IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (A.IsEmpty = @IsEmpty)' 
	IF(@SearchAssetName IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (A.AssetName LIKE ''%''+ @SearchAssetName +''%'')' 
	IF(@SearchAssignee IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (UAT.FirstName LIKE ''%''+ @SearchAssignee +''%'')' 
	IF(@SearchProductName IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (P.ProductName LIKE ''%''+ @SearchProductName +''%'')' 
	IF(@SearchSuuplier IS NOT NULL) SET @SearchSqlScript = @SearchSqlScript + N' AND (S.SupplierName LIKE ''%''+ @SearchSuuplier +''%'')' 
	  
	SET @SearchSqlScript = @SearchSqlScript + N' ) '
	
	SET @SearchSqlScript = @SearchSqlScript +  N' SELECT Id,AssetNumber,AssetName,AssignedToEmployeeId,AssignedToFirstName,AssignedToSurName,
													ApprovedByUserId,AssignedByFirstName,PurchasedDate,AssignedDateFrom,
													AssignedBySurName, ApprovedDateTime,Cost,CurrencyDetails,IsVendor,IsEmpty,IsWriteOff,
													DamagedDate,DamagedReason,ProductName,ManufacturerCode,ProductCode,SupplierId,SupplierName,CompanyId,ProductId,CurrencyId FROM CTE_Results AS CPC
				CROSS JOIN (SELECT Count(1) AS Count FROM CTE_Results) AS CountTable
				ORDER BY ' +  @OrderByColumn + ' ' + @OrderByDirection + ' 
				OFFSET @skip ROWS'
	IF (@pageSize <> -1) SET @SearchSqlScript = @SearchSqlScript + N' FETCH NEXT @pageSize ROWS ONLY'
	
	PRINT @SearchSqlScript

	exec sp_executesql @SearchSqlScript, 
		N'@Id UNIQUEIDENTIFIER = NULL,
		  @AssetId nvarchar(50) = NULL,
		  @ProductName  nvarchar(250) = NULL,
		  @ManufacturerCode nvarchar(100) = NULL,
		  @ApprovedDate datetime = NULL,
		  @AssignedTo UNIQUEIDENTIFIER = NULL,
		  @ApprovedBy UNIQUEIDENTIFIER = NULL,
		  @PurchasedDate datetime = NULL,
		  @AssignedDateTime datetime = NULL,
		  @IsWriteOff bit =NULL,
		  @IsVendor bit=NULL,
		  @SupplierId UNIQUEIDENTIFIER = NULL,
		  @ProductId UNIQUEIDENTIFIER = NULL,
		  @CompanyId UNIQUEIDENTIFIER = NULL,
		  @PageSize INT = 100,
		  @skip INT = 0,
		  @SearchAssetName NVARCHAR(250)= NULL,
		  @SearchAssignee NVARCHAR(250)= NULL,
		  @SearchProductName NVARCHAR(250)= NULL,
		  @SearchSuuplier NVARCHAR(250)= NULL,
		  @OrderByColumnName NVARCHAR(250)= NULL,
		  @OrderByDirectionAsc BIT = 1,
		  @IsEmpty BIT = NULL', @Id,@AssetId,@ProductName,@ManufacturerCode,@ApprovedDate,@AssignedTo
		                       ,@ApprovedBy,@PurchasedDate,@AssignedDateTime,@IsWriteOff,@IsVendor,@SupplierId,@ProductId,@CompanyId,@PageSize,@skip,
								@SearchAssetName,@SearchAssignee,@SearchProductName,@SearchSuuplier,@OrderByColumnName,@OrderByDirectionAsc,@IsEmpty
END


--exec [USP_SearchAssets] @CompanyId = '29BA7038-B0A6-48A1-B448-10ADA7AF3C71'