CREATE PROCEDURE [dbo].[USP_GetDocumentStorageSettings]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @Key NVARCHAR(500) = NULL,
	@Value NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@CompanySettingsId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
	    BEGIN

		   IF(@CompanySettingsId = '00000000-0000-0000-0000-000000000000') SET @CompanySettingsId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   DECLARE @CurrentSize BIGINT = (SELECT SUM(CAST(FileSize AS BIGINT)) FROM [UploadFile] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL GROUP BY CompanyId)

           SELECT C.Id AS CompanySettingsId,
		   	      C.CompanyId,
				  C.[Key],
		   	      C.[Value],
				  @CurrentSize AS SizeUsed,
				  CAST([Value] AS BIGINT) AS SizeAllocated,
				  3 * CAST([Value] AS BIGINT) AS ExtendedSize,
				  (CASE WHEN (@CurrentSize >= CAST([Value] AS BIGINT)) THEN 1 ELSE 0 END) AS IsSizeLimitExceeded,
				  (CASE WHEN (@CurrentSize >= 3 * CAST([Value] AS BIGINT)) THEN 1 ELSE 0 END) AS IsToRestrictUpload,
				  C.[Description],			
		   	      C.InActiveDateTime,
		   	      C.CreatedDateTime ,
		   	      C.CreatedByUserId,
		   	      C.[TimeStamp],
				  (CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived
           FROM CompanySettings AS C		        
           WHERE C.CompanyId = @CompanyId
				AND C.[Key] = 'DocumentsSizeLimit'
				AND (@Value IS NULL OR C.[Value] = @Value)
		   	    AND (@CompanySettingsId IS NULL OR C.Id = @CompanySettingsId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))	   	    
				AND (C.IsVisible <> 0 OR C.IsVisible IS NULL)

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