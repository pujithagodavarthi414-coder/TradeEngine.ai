CREATE PROCEDURE [dbo].[USP_GetAllRFQStatus]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@RFQStatusId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@RFQStatusId = '00000000-0000-0000-0000-000000000000') SET @RFQStatusId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT CS.Id AS RFQStatusId,
		   	      CS.StatusName AS StatusName,
		   	      CS.RFQStatusName AS RFQStatusName,
		   	      CS.StatusColor AS RFQStatusColor,
		   	      CS.InActiveDateTime,
		   	      CS.CreatedDateTime,
		   	      CS.CreatedByUserId,
		   	      CS.[TimeStamp],
				  CASE WHEN CS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   	      TotalCount = COUNT(1) OVER()
           FROM [RFQStatus] AS CS
           WHERE CS.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (CS.StatusName LIKE @SearchText))
		   	   AND (@RFQStatusId IS NULL OR CS.Id = @RFQStatusId)
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CS.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CS.InActiveDateTime IS NULL))
           ORDER BY CS.StatusName ASC

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