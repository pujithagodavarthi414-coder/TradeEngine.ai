---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To get the PaymentMethods by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetReferenceTypes] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetReferenceTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@ReferenceTypeId UNIQUEIDENTIFIER = NULL,	
	@SearchText    NVARCHAR(250) = NULL,
	@IsArchived BIT= NULL	
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText   = '') SET @SearchText   = NULL
		   
		   IF(@ReferenceTypeId = '00000000-0000-0000-0000-000000000000') SET @ReferenceTypeId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT RT.Id AS ReferenceTypeId,
		   	      RT.CompanyId,
				  IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
				  RT.ReferenceTypeName,			
		   	      RT.InActiveDateTime,
		   	      RT.CreatedDateTime ,
		   	      RT.CreatedByUserId,
		   	      RT.[TimeStamp],	
		   	      TotalCount = COUNT(*) OVER()
           FROM V_ReferenceType AS RT		        
           WHERE RT.CompanyId = @CompanyId
		        AND (@SearchText   IS NULL OR (RT.ReferenceTypeName LIKE  '%'+ @SearchText +'%'  ))				
		   	    AND (@ReferenceTypeId IS NULL OR RT.Id = @ReferenceTypeId)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND RT.InActiveDateTime IS NOT NULL) 
				OR (@IsArchived = 0 AND RT.InActiveDateTime IS NULL))
		   	    
           ORDER BY RT.ReferenceTypeName ASC

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