CREATE PROCEDURE [dbo].[USP_GetTdsSettings]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@TdsSettingsId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText  = '') SET @SearchText  = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@TdsSettingsId = '00000000-0000-0000-0000-000000000000') SET @TdsSettingsId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT TDS.Id AS TdsSettingsId,
		   	      TDS.BranchId,
				  TDS.IsTdsRequired,
		   	      TDS.InActiveDateTime,
		   	      TDS.CreatedDateTime ,
		   	      TDS.CreatedByUserId,
		   	      TDS.[TimeStamp],
				  B.BranchName,
				  (CASE WHEN TDS.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM TdsSettings AS TDS	
		        INNER JOIN Branch B ON B.Id = TDS.BranchId	        
           WHERE B.CompanyId = @CompanyId
		        AND (@SearchText IS NULL OR B.[BranchName] LIKE  @SearchText)
		   	    AND (@TdsSettingsId IS NULL OR TDS.Id = @TdsSettingsId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND TDS.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND TDS.InActiveDateTime IS NULL))	
           ORDER BY TDS.CreatedDateTime DESC

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