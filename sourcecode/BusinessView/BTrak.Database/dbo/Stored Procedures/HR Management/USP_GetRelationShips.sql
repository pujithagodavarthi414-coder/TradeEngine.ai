-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-05-30 00:00:00.000'
-- Purpose      To Get Relation Ship
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetRelationShips] @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE USP_GetRelationShips
(
 @RelationShipId UNIQUEIDENTIFIER = NULL,
 @RelationShipName NVARCHAR(250) =  NULL,
 @OriginalId UNIQUEIDENTIFIER =  NULL,
 @SearchText NVARCHAR(250) = NULL,
 @IsArchived  BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
 AS
 BEGIN
     
	 SET NOCOUNT ON
	 BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
		 IF(@HavePermission = '1')
         BEGIN 


		 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		 
		 IF(@RelationShipId = '00000000-0000-0000-0000-000000000000') SET @RelationShipId = NULL

		 IF(@RelationShipName = '00000000-0000-0000-0000-000000000000') SET @RelationShipName = NULL

		 IF(@OriginalId = '00000000-0000-0000-0000-000000000000') SET @OriginalId = NULL

		 IF(@SearchText = '') SET @SearchText = NULL

		 SELECT  RS.Id As RelationShipId,
	             RS.RelationShipName,
	             RS.CreatedDateTime,
	             RS.CreatedByUserId,
                 RS.CompanyId, 
	             RS.InActiveDateTime,
	             RS.[TimeStamp],
				 CASE WHEN RS.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END As IsArchived,
				 TotalCount = COUNT (*)OVER()
				 FROM RelationShip As RS 
	             WHERE RS.CompanyId = @CompanyId
				   AND (@RelationShipId IS NULL OR Id = @RelationShipId)
				   AND (@RelationShipName IS NULL OR RelationShipName = @RelationShipName)
				   AND (@SearchText IS NULL OR RelationShipName LIKE '%'+@SearchText+'%')
				   AND (@IsArchived IS NULL OR(RS.InActiveDateTime IS NULL AND @IsArchived = 0) OR (RS.InActiveDateTime IS NOT NULL AND @IsArchived = 1))

		ORDER BY RelationShipName ASC

		END
		ELSE

		  RAISERROR(@HavePermission,11,1)

	    END TRY
		BEGIN CATCH
		    
			THROW

	    END CATCH

END
GO