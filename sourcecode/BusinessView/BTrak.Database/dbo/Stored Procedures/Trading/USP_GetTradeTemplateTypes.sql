-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetTradeTemplateTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTradeTemplateTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL,	
	@TemplateTypeId UNIQUEIDENTIFIER = NULL,
	@TemplateTypeName NVARCHAR(250) = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  ='1'-- (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN	  
		   
		   IF(@TemplateTypeName = '') SET @TemplateTypeName = NULL

		   IF(@TemplateTypeName <> '' AND @TemplateTypeName IS NOT NULL)
		   BEGIN
				SET @TemplateTypeName = '%'+ @TemplateTypeName +'%'
		   END

           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT TCT.TemplateTypeName,
				  TCT.Id AS TemplateTypeId,
				  TCT.FormJson
           FROM [TradeTemplateType] AS TCT
           WHERE TCT.CompanyId = @CompanyId
		    AND (@TemplateTypeId IS NULL OR TCT.Id = @TemplateTypeId)
			AND (@TemplateTypeName IS NULL OR TCT.TemplateTypeName LIKE @TemplateTypeName)
				 AND(@IsArchived IS NULL OR (@IsArchived = 1 AND TCT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND TCT.InActiveDateTime IS NULL))
           ORDER BY TCT.TemplateTypeName

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


