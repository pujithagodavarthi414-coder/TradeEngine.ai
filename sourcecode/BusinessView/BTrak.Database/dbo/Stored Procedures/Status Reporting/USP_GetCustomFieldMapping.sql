---------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2019-12-13 00:00:00.000'
-- Purpose      To Get Custom Field Mappings
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetGenericFormKeys] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCustomFieldMapping]
(
	@MappingId UNIQUEIDENTIFIER = NULL,		
	@CustomApplicationId UNIQUEIDENTIFIER = NULL,		
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@MappingName NVARCHAR(500) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT  CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)  
		  
		   IF(@MappingId = '00000000-0000-0000-0000-000000000000') SET @MappingId = NULL	

		   IF(@CustomApplicationId = '00000000-0000-0000-0000-000000000000') SET @CustomApplicationId = NULL	
		   
		   IF(@MappingName = '') SET @MappingName = NULL
		   
		   IF(@MappingName IS NOT NULL) SET @MappingName = '%' + @MappingName + '%'
       	   
           SELECT CFM.Id AS MappingId
		          ,CFM.MappingName
				  ,CFM.CustomApplicationId
				  ,CFM.MappingJson
				  ,CFM.CreatedByUserId
				  ,CFM.CreatedDateTime
				  ,CFM.[TimeStamp]
		   FROM CustomFieldsMapping CFM
           WHERE CFM.CompanyId = @CompanyId
				AND (@MappingId IS NULL OR CFM.Id = @MappingId)
				AND (@CustomApplicationId IS NULL OR CFM.CustomApplicationId = @CustomApplicationId)
		        AND (@MappingName IS NULL OR CFM.MappingName LIKE @MappingName)
           ORDER BY CFM.MappingName ASC

	END
   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
