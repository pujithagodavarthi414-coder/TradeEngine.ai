CREATE PROCEDURE [dbo].[USP_GetSite]
	@SiteId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(MAX) = NULL,
    @IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   DECLARE @HavePermission NVARCHAR(250)  = '1'

       IF(@SiteId = '00000000-0000-0000-0000-000000000000') SET @SiteId = NULL

        IF (@HavePermission = '1')
        BEGIN
		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
			DECLARE @TVAValue DECIMAL(18, 2) = (SELECT TOP(1)TVAValue FROM [dbo].[TVA] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)
            IF(@SearchText = '') SET @SearchText = NULL
			 SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
			   SELECT Id,
               Id AS SiteId,
                        [Name],
                        [Address],
                        Email,
                        [TimeStamp],
                        [Addressee],
                        AutoCTariff,
						[RoofRentalAddress],
						[Date],
						[ParcellNo],
						[M2],
						[Chf],
						[Term],
						[Muncipallity],
						[Canton],
                        @TVAValue AS TVAValue,
						StartingYear,
						ProductionFirstYear,
						AutoCExpected,
						AnnualReduction,
						RepriceExpected,
					  TotalCount = COUNT(1) OVER()
					FROM [dbo].[Site]
					WHERE InActiveDateTime IS NULL
					 AND (@SiteId IS NULL OR Id = @SiteId)
                     AND( CompanyId=@CompanyId or @OperationsPerformedBy= '00000000-0000-0000-0000-000000000000')
					 AND (@SearchText IS NULL
                     OR ([Name] LIKE @SearchText)
					 OR ([Address] LIKE @SearchText)
					 OR ([Addressee] LIKE @SearchText)
                     OR ([Email] LIKE @SearchText)
                     OR (REPLACE(CONVERT(NVARCHAR,CreatedDateTime,106),' ','-')) LIKE @SearchText
                    )
		 ORDER BY Name ASC
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