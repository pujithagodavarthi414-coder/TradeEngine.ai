---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-27 00:00:00.000'
-- Purpose      To get the PaymentMethods by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetPermissionReasons] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived=0

CREATE PROCEDURE [dbo].[USP_GetPermissionReasons]
(
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @PermissionReasonId UNIQUEIDENTIFIER = NULL,	
   @SearchText NVARCHAR(800) = NULL,
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

		     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			 IF (@IsArchived IS NULL) SET @IsArchived = 0
   	         
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		     
	         IF(@SearchText = '') SET @SearchText = NULL
		     
	          SELECT PR.Id AS Id,
                     PR.[ReasonName] AS PermissionReason,
			  	     PR.[CompanyId],
			  	     IsArchived = CASE WHEN InActiveDateTime IS NULL THEN 0 ELSE 1 END,
                     PR.[CreatedDateTime],
                     PR.[CreatedByUserId],
			  	     PR.[InActiveDateTime],
					 PR.[TimeStamp],
			  	     TotalCount = COUNT(1) OVER()
	 	      FROM [dbo].[PermissionReason]PR WITH (NOLOCK)
	 	      WHERE PR.CompanyId = @CompanyId
			      AND (@PermissionReasonId IS NULL OR PR.Id = @PermissionReasonId) 
			      AND (@SearchText IS NULL OR (PR.ReasonName LIKE '%'+ @SearchText+'%'))
				  AND ((@IsArchived = 1 AND InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND InActiveDateTime IS NULL))
	 	      ORDER BY ReasonName ASC 

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
