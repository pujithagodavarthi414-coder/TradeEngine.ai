---------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To get the AccessisbleIpAdresses by applying differnt filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetAccessisbleIpAdresses]@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetAccessisbleIpAdresses]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@Name NVARCHAR(250) = NULL,
	@IpAddress NVARCHAR(250) = NULL,
	@AccessisbleIpAdressesId UNIQUEIDENTIFIER = NULL,	
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

		   SET @SearchText = '%'+ @SearchText +'%'
		   
		   IF(@AccessisbleIpAdressesId = '00000000-0000-0000-0000-000000000000') SET @AccessisbleIpAdressesId = NULL		  
		   
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT AIA.Id AS AccessisbleIpAdressesId,
		   	      AIA.CompanyId,
				  AIA.[Name] AS LocationName,
				  AIA.IpAddress,			
		   	      AIA.InActiveDateTime,
		   	      AIA.CreatedDateTime ,
		   	      AIA.CreatedByUserId,
		   	      AIA.[TimeStamp],	
		   	      TotalCount = COUNT(1) OVER()
           FROM AccessisbleIpAdresses AS AIA		        
           WHERE AIA.CompanyId = @CompanyId
		        AND (@SearchText   IS NULL OR (AIA.[Name] LIKE  @SearchText 
				                           OR AIA.IpAddress LIKE @SearchText)
				     )				
		   	    AND (@AccessisbleIpAdressesId IS NULL OR AIA.Id = @AccessisbleIpAdressesId)
				AND (@Name IS NULL OR AIA.[Name] = @Name)
				AND (@IpAddress IS NULL OR AIA.IpAddress = @IpAddress)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND AIA.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND AIA.InActiveDateTime IS NULL))
		   	    
           ORDER BY AIA.[Name] ASC

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