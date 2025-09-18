-------------------------------------------------------------------------------
-- Author       K Surya
-- Created      '2020-01-27 00:00:00.000'
-- Purpose      To Save or Update PayRollComponent
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetPayRollComponents] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetResignationStatus]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @StatusName NVARCHAR(500) = NULL,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@ResignationStatusId UNIQUEIDENTIFIER = NULL
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

		   IF(@ResignationStatusId = '00000000-0000-0000-0000-000000000000') SET @ResignationStatusId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT RS.Id AS ResignationStatusId,
				  RS.[StatusName],
		   	      RS.InActiveDateTime,
		   	      RS.CreatedDateTime ,
		   	      RS.CreatedByUserId,
		   	      RS.[TimeStamp],
				  (CASE WHEN RS.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM ResignationStatus AS RS		        
           WHERE (@StatusName IS NULL OR RS.[StatusName] = @StatusName)
		        AND (@SearchText IS NULL OR (RS.[StatusName] LIKE  @SearchText))
		   	    AND (@ResignationStatusId IS NULL OR RS.Id = @ResignationStatusId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND RS.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND RS.InActiveDateTime IS NULL))	   	    
           ORDER BY RS.[StatusName] ASC

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