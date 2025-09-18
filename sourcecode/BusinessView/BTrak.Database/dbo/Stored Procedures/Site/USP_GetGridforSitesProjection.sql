CREATE PROCEDURE [dbo].[USP_GetGridforSitesProjection]
    @IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	   DECLARE @HavePermission NVARCHAR(250)  = '1'

        IF (@HavePermission = '1')
        BEGIN
		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
			
			   SELECT GS.Id AS GridForSiteProjectionId,
                        S.Id AS SiteId,
                        G.Id AS GridId,
                        S.[Name] AS SiteName,
                        G.[Name] AS GridName,
                        GS.[TimeStamp],
                        GS.StartDate,
                        GS.EndDate,
					  TotalCount = COUNT(1) OVER()
					FROM [dbo].[GridForSitesProjection] GS
					INNER JOIN [Site] S ON S.Id=GS.SiteId
					INNER JOIN GRD G ON G.Id=GS.GridId
					WHERE GS.InActiveDateTime IS NULL
                     AND(GS.CompanyId=@CompanyId or @OperationsPerformedBy= '00000000-0000-0000-0000-000000000000')
		 ORDER BY GS.CreatedDateTime DESC
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