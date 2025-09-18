-------------------------------------------------------------------------------
-- Author      Surya
-- Created      '2020-04-29 14:36:50.810'
-- Purpose      To Check Custom app addor edit permission
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  USP_GetCustomAppAddOrEditIsRequired @OperationsPerformedBy = '664FEF4F-4BD4-47BD-AC44-0C2D493C8A29',@CompanyGuid='9E94B1E5-6DE3-4B08-B5A6-952EBBFDD418'
-------------------------------------------------------------------------------
CREATE PROC USP_GetCustomAppAddOrEditIsRequired
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
  	@CompanyGuid UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		IF (@HavePermission = '1')
	    BEGIN
		DECLARE @Value INT = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyGuid AND [Key] = 'IsAddOrEditCustomApps')
			DECLARE @IsAccess BIT = (CASE WHEN @Value = 1 THEN 1 ELSE 0 END)			
			SELECT @IsAccess

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
