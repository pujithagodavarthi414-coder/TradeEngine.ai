-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-08 00:00:00.000'
-- Purpose      To Get the Nationalities by applying different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetNationalities] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetNationalities]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@NationalityId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL	
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@NationalityId = '00000000-0000-0000-0000-000000000000') SET @NationalityId = NULL
		   
           SELECT N.Id AS NationalityId,
		   	      N.NationalityName ,
				  N.InActiveDateTime,
		   	      N.CreatedDateTime ,
		   	      N.CreatedByUserId,
		   	      N.[TimeStamp],
		   	      TotalCount = COUNT(*) OVER()
           FROM Nationality N 		        
           WHERE N.CompanyId = @CompanyId
		         AND (@SearchText IS NULL OR (N.NationalityName LIKE @SearchText))
			     AND (@NationalityId IS NULL OR N.Id = @NationalityId)
				 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND N.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND N.InActiveDateTime IS NULL))
           ORDER BY N.NationalityName ASC

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
