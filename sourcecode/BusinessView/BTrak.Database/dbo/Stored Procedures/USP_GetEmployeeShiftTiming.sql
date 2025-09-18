-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetEmployeeShiftTiming] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@EmployeeId= '3B362452-FFC5-4E98-A908-484947777DD4'
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeShiftTiming]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
	@EmployeeId UNIQUEIDENTIFIER ,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT= NULL,
	@ShiFtTimingId UNIQUEIDENTIFIER =  NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL

		   IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT ST.Id  ShiftTimingId,
				  ES.Id EmployeeShiftId,
				  ST.BranchId,
				  ST.ShiftName,
				  ES.EmployeeId,
				  ES.ActiveFrom,
				  ES.ActiveTo,
		   	      ES.CreatedDateTime ,
		   	      ES.CreatedByUserId,
		   	      ES.[TimeStamp],	
		   	      TotalCount = COUNT(*) OVER()
           FROM EmployeeShift AS ES	INNER JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId 
		   WHERE ES.EmployeeId = @EmployeeId AND ES.InActiveDateTime IS NULL AND ST.CompanyId = @CompanyId     
           ORDER BY ES.ActiveFrom DESC

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
