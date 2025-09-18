-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetShiftException] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@ShiftTimingId='19077c23-c740-4f33-b19a-246dbc5477c6'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetShiftException]
(
     @ShiftExceptionsId UNIQUEIDENTIFIER = NULL,    
     @SearchText NVARCHAR(250) = NULL,
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @ShiftTimingId UNIQUEIDENTIFIER = NULL,
	 @IsArchived BIT = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
            IF(@SearchText = '') SET @SearchText = NULL
            
            SET @SearchText = '%'+ @SearchText +'%'
 
            IF(@ShiftExceptionsId = '00000000-0000-0000-0000-000000000000') SET @ShiftExceptionsId = NULL
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
            SELECT S.Id AS ShiftExceptionId,
					  S.ExceptionDate,
					  S.StartTime,
					  S.EndTime,
					  S.DeadLine,
					  S.AllowedBreakTime,
					  S.CreatedDateTime,
                      S.CreatedByUserId,
                      S.[TimeStamp],
					  S.ShiftTimingId,	
					  CASE WHEN S.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                      TotalCount = COUNT(1) OVER()
            FROM ShiftException S 
			JOIN ShiftTiming ST ON ST.Id = S.ShiftTimingId
            WHERE  S.InActiveDateTime IS NULL
			     AND ST.CompanyId = @CompanyId
			     AND (@ShiftExceptionsId IS NULL OR (@ShiftExceptionsId = S.Id))
			     AND (@SearchText IS NULL OR (S.ExceptionDate LIKE @SearchText))
				 AND (@ShiftTimingId IS NULL OR S.ShiftTimingId = @ShiftTimingId)
				 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) 
				                          OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))
			ORDER BY S.ExceptionDate ASC
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