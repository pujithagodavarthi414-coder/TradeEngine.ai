CREATE PROCEDURE [dbo].[USP_GetPartsOfDays]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER
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
		
           SELECT PD.Id AS PartsOfDayId,
				  PD.[PartsOfDayName]
           FROM PartsOfDay AS PD		
		   WHERE PD.CompanyId = @CompanyId
           ORDER BY PD.[CreatedDateTime] ASC

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