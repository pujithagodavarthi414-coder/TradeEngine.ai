-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-19 00:00:00.000'
-- Purpose      Validate weather User In companylocation or not
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_ValidateUserLocation] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @Latitude=15.5120,@Longitude=80.0389
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ValidateUserLocation]
(
    @Latitude  FLOAT = NULL,
    @Longitude FLOAT = NULL,    
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN 
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
      IF (@HavePermission = '1')
      BEGIN
	  
	     IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	     
	     IF(@Longitude IS NULL)
	     BEGIN
	        
	        RAISERROR(50011,16, 2, 'Longitude')
	     
	     END
	     ELSE IF(@Latitude IS NULL)
	     BEGIN
	        
	        RAISERROR(50011,16, 2, 'Latitude')
	     
	     END
	     ELSE 
	     BEGIN
	     
                    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                    
	     		 IF((SELECT COUNT(1)                       
                        FROM [CompanyLocation]CL WITH(NOLOCK)  
                        WHERE CL.CompanyId = @CompanyId
                             AND (CONVERT(DECIMAL(10,3),CL.Longitude)) = (CONVERT(DECIMAL(10,3),@Longitude))
                             AND (CONVERT(DECIMAL(10,3),CL.Latitude)) = (CONVERT(DECIMAL(10,3),@Latitude))) = 1)
                    SELECT 1 AS IsValid
                    ELSE
                    SELECT 0 AS IsValid
                          
            END
      END
	  ELSE
               RAISERROR (@HavePermission,11, 1)

  END TRY
    BEGIN CATCH
        
          THROW

    END CATCH
END
GO
