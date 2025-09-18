CREATE PROCEDURE [dbo].[USP_GetSolorLog]
	@SolarId UNIQUEIDENTIFIER = NULL,
	@SearchText NVARCHAR(MAX) = NULL,
    @IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   DECLARE @HavePermission NVARCHAR(250)  = '1'

       IF(@SolarId = '00000000-0000-0000-0000-000000000000') SET @SolarId = NULL

        IF (@HavePermission = '1')
        BEGIN
		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
            IF(@SearchText = '') SET @SearchText = NULL
			 SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'
			   SELECT
                        SLF.Id AS SolarId,
                        SLF.IsConfirm AS Confirm,
                        SiteId,
                        SolarLogValue,
                        SelectedDate AS [Date],
                        SLF.[TimeStamp],
						ST.[Name] AS SiteName,
					    TotalCount = COUNT(1) OVER()
					FROM [dbo].[SolarLogForm] SLF
                    LEFT JOIN [site] ST ON ST.Id = SLF.SiteId
					WHERE SLF.InActiveDateTime IS NULL
                     AND( SLF.CompanyId = @CompanyId)
					 AND (@SearchText IS NULL
                     OR (SolarLogValue LIKE @SearchText)
                     OR (REPLACE(CONVERT(NVARCHAR,SelectedDate,106),' ','-')) LIKE @SearchText
                    )
		 ORDER BY ST.[Name] ASC
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