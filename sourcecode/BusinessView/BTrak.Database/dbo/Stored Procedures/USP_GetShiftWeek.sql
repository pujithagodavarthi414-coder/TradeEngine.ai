-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetShiftWeek] @OperationsPerformedBy = '78BD62C6-D377-43B3-9B05-383C14DB9330',@ShiftWeekId='4D828A7C-2207-4279-9FA1-02027A9D2BEE'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetShiftWeek]
(
     @ShiftWeekId UNIQUEIDENTIFIER = NULL,    
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
 
            IF(@ShiftWeekId = '00000000-0000-0000-0000-000000000000') SET @ShiftWeekId = NULL
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
            SELECT S.Id AS ShiftWeekId,
					  S.[DayOfWeek],
                      S.CreatedDateTime,
                      S.CreatedByUserId,
					  S.StartTime,
					  S.EndTime,
					  S.DeadLine,
					  S.AllowedBreakTime,
                      S.[TimeStamp],
					  S.ShiftTimingId,
					  S.IsPaidBreak,
					  SRT.CompanyId,	
					  CASE WHEN S.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                      TotalCount = COUNT(1) OVER()
            FROM ShiftWeek S 
			JOIN ShiftTiming ST ON ST.Id = S.ShiftTimingId
			JOIN StatusReportingOption_New SRT ON SRT.OptionName = S.[DayOfWeek]               
            WHERE (@ShiftWeekId IS NULL OR (@ShiftWeekId = S.Id))
				 AND SRT.CompanyId = @CompanyId  
				 AND ST.CompanyId = @CompanyId
			     AND (@SearchText IS NULL OR (S.[DayOfWeek] LIKE @SearchText))
				 AND (@ShiftTimingId IS NULL OR S.ShiftTimingId = @ShiftTimingId)
				 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) 
				                          OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))
			ORDER BY SRT.SortOrder
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