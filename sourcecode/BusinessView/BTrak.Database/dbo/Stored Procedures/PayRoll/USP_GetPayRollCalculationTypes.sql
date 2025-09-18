-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetPayRollCalculationTypes] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayRollCalculationTypes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		
           SELECT PRCT.Id AS PayRollCalculationTypeId,
				  PRCT.[PayRollCalculationTypeName]
           FROM PayRollCalculationType AS PRCT		
		   WHERE PayRollCalculationTypeName <> 'Leave encashment'
           ORDER BY PRCT.[PayRollCalculationTypeName] ASC

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
