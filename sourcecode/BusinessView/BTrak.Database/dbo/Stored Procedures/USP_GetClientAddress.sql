----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-09-24 00:00:00.000'
-- Purpose      To Get All Client Addresses by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetClientAddress] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ClientId = '20F8D23C-B910-4E38-9C9C-CA0268F07836', @ClientAddressId = '9FCDB440-C29A-4122-8291-73DD68E42B75'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClientAddress]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ClientAddressId UNIQUEIDENTIFIER = NULL,
	@ClientId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN      

           IF(@ClientAddressId = '00000000-0000-0000-0000-000000000000') SET @ClientAddressId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT CA.Id AS ClientAddressId,
				  CA.ClientId,
				  CA.CountryId,
				  CA.Zipcode,
				  CA.Street,
				  CA.City,
				  CA.State,
				  CO.CountryName,				
				  CA.CreatedDateTime,
                  CA.CreatedByUserId,
				  CA.UpdatedDateTime,
				  CA.UpdatedByUserId,
				  CA.InActiveDateTime,
                  CA.[TimeStamp],  
                  TotalCount = COUNT(1) OVER()
           FROM ClientAddress AS CA
		   LEFT JOIN Client C ON C.Id = CA.ClientId 
		   LEFT JOIN Country CO ON CO.Id = CA.CountryId 
           WHERE CA.CompanyId = @CompanyId
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CA.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CA.InactiveDateTime IS NULL))
                AND (@ClientAddressId IS NULL OR CA.Id = @ClientAddressId)    
				AND (@ClientId IS NULL OR C.Id = @ClientId)   
           ORDER BY CA.State ASC
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
