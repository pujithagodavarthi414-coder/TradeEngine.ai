-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-24 00:00:00.000'
-- Purpose      To Get The FormTypes By Applyind Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetFormTypes_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetFormTypes_New]
(
   @FormTypeId  UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
   @SearchText  NVARCHAR(250) = NULL,
   @IsArchived BIT = NULL,
   @FormTypeName NVARCHAR(250)=NULL
)
AS
BEGIN

	SET NOCOUNT ON
		BEGIN TRY
	    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  DECLARE @HavePermission NVARCHAR(250)  = IIF(@OperationsPerformedBy IS NULL, 1, (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID)))))

      IF (@HavePermission = '1')
      BEGIN
      
	      DECLARE @CompanyId UNIQUEIDENTIFIER = IIF(@OperationsPerformedBy IS NULL, NULL,(SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)))
	       
		   SET @SearchText = '%'+ @SearchText+'%'

		   IF(@IsArchived IS NULL) SET @IsArchived =0
	       
	            SELECT FT.Id AS Id,
	  	    		   FT.CompanyId,
	  	    		   FT.FormTypeName,
					   FT.Id AS FormTypeId,
					   CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					   FT.InActiveDateTime,
	  	    		   FT.CreatedDateTime, 
	  	    		   FT.CreatedByUserId,
	  	    		   FT.UpdatedDateTime,
	  	    		   FT.UpdatedByUserId,
					   FT.[TimeStamp],
	  	    		   TotalCount = COUNT(1) OVER()
	  	        FROM  [FormType] FT WITH (NOLOCK)
	  	        WHERE (@CompanyId IS NULL OR FT.CompanyId = @CompanyId)
	  	             AND (@FormTypeId IS NULL OR FT.Id = @FormTypeId)  
	  	    		 AND (@FormTypeName IS NULL OR FT.FormTypeName = @FormTypeName) 
					 AND ((@IsArchived = 0 AND InActiveDateTime IS NULL)
				          OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
					 AND (@SearchText IS NULL OR (FT.FormTypeName LIKE @SearchText))
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
