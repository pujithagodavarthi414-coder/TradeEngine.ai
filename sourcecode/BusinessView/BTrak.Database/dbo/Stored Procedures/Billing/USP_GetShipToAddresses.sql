CREATE PROCEDURE [dbo].[USP_GetShipToAddresses]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@AddressId UNIQUEIDENTIFIER = NULL,	
	@ClientId UNIQUEIDENTIFIER = NULL,	
    @SearchText NVARCHAR(250) = NULL,
    @PageNo INT = 1,
    @PageSize INT = 10,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50) = NULL,
	@IsArchived BIT= NULL,
	@IsShiptoAddress BIT= NULL,
	@IsVerified BIT= NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL
           SET @SearchText = '%'+ @SearchText +'%';              
           IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
                   
           IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
           
           IF(@IsArchived IS NULL) SET @IsArchived = 0
		   
		   IF(@AddressId = '00000000-0000-0000-0000-000000000000') SET @AddressId = NULL		
		   IF(@ClientId = '00000000-0000-0000-0000-000000000000') SET @ClientId = NULL		
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT STA.Id AS AddressId,
		   	      STA.CompanyId,
				  STA.AddressName,	
				  STA.[Description],
				  STA.[Comments],
				  STA.IsShiptoAddress,
				  STA.IsVerified,
		   	      STA.[TimeStamp],
				  (CASE WHEN STA.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
			 Receipts = STUFF(( SELECT  ',' + Convert(nvarchar(1000),UF.FilePath)[text()]
						                                      FROM [UploadFile] UF
															  INNER JOIN [DocumentsDescription] DD ON DD.Id = UF.ReferenceId
						                                      WHERE UF.InActiveDateTime IS NULL AND DD.ReferenceTypeId = STA.Id
																FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
		   	      TotalCount = COUNT(*) OVER()
           FROM [ShipToAddress] AS STA		        
           WHERE STA.CompanyId = @CompanyId			
		   	    AND (@AddressId IS NULL OR STA.Id = @AddressId)
		   	    AND (@ClientId IS NULL OR STA.ClientId = @ClientId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND STA.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND STA.InActiveDateTime IS NULL))
				AND (@IsShiptoAddress IS NULL OR (@IsShiptoAddress = 1 AND STA.IsShiptoAddress=1) OR (@IsShiptoAddress = 0 AND STA.IsShiptoAddress=0))
				AND (@IsVerified IS NULL OR (@IsVerified = 1 AND STA.IsVerified=1 AND STA.IsShiptoAddress=1)
						OR (@IsVerified = 0 AND STA.IsVerified=0 AND STA.IsShiptoAddress=1))
				AND ((@SearchText IS NULL OR (STA.AddressName LIKE  @SearchText)) OR
			    (@SearchText IS NULL OR (STA.[Description] LIKE  @SearchText)))

		   ORDER BY
                          CASE WHEN( @SortDirection= 'ASC' OR @SortDirection IS NULL ) THEN
                               CASE 
                                    WHEN @SortBy = 'addressName' THEN STA.AddressName
                                    WHEN @SortBy = 'description' THEN STA.[Description]
									WHEN @SortBy = 'CreatedDateTime' THEN CAST(STA.CreatedDateTime AS SQL_VARIANT)
                                END
                            END ASC,
                            CASE WHEN @SortDirection = 'DESC' THEN
                                 CASE 
                                    WHEN @SortBy = 'addressName' THEN STA.AddressName
                                    WHEN @SortBy = 'description' THEN STA.[Description]
									WHEN @SortBy = 'CreatedDateTime' THEN CAST(STA.CreatedDateTime AS SQL_VARIANT)
                                   END
                             END DESC
		   
		   OFFSET ((@PageNo - 1) * @PageSize) ROWS

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