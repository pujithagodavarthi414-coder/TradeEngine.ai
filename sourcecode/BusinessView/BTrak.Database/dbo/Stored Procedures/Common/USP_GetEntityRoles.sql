
-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-25 00:00:00.000'
-- Purpose      To Get the Entity Roles by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetEntityRoles]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetEntityRoles]
(
    @EntityRoleId         UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EntityRoleName        NVARCHAR(200) =NULL,
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived             BIT =NULL
)
AS
BEGIN
  SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
          IF (@HavePermission = '1')
          BEGIN
	       IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText  = '%'+ @SearchText +'%'


	     IF(@IsArchived IS NULL)SET @IsArchived = 0

	      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          SELECT ER.Id AS EntityRoleId,
                 ER.EntityRoleName,
				 IsArchived = CASE WHEN ER.InActiveDateTime IS NULL THEN 0 ELSE 1 END,
				 ER.CompanyId,
                 ER.CreatedDateTime,
                 ER.CreatedByUserId,
				 ER.InActiveDateTime,
				 ER.[TimeStamp],
				 TotalCount = COUNT(1) OVER()
          FROM  [dbo].[EntityRole] ER WITH (NOLOCK) 
          WHERE (ER.CompanyId = @CompanyId) 
				 AND (@EntityRoleId IS NULL OR ER.Id = @EntityRoleId)
				 AND (@EntityRoleName IS NULL OR ER.EntityRoleName = @EntityRoleName)
				 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL) 
				                          OR (@IsArchived = 0 AND InActiveDateTime IS NULL))
		         AND (@SearchText IS NULL OR (ER.EntityRoleName LIKE @SearchText))
			                           
		 ORDER BY ER.EntityRoleName

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
