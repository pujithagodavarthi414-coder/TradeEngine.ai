 -------------------------------------------------------------------------------
-- Author       Madhuri Gummalla
-- Created      '2019-07-05 00:00:00.000'
-- Purpose      To Get ShiftTimings
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetShiftTimings] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetShiftTimings]
(
     @ShiftTimingId UNIQUEIDENTIFIER = NULL,    
     @EmployeeId UNIQUEIDENTIFIER = NULL,    
     @SearchText NVARCHAR(250) = NULL,
	 @IsArchived BIT = NULL,
     @OperationsPerformedBy UNIQUEIDENTIFIER
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
 
            IF(@ShiftTimingId = '00000000-0000-0000-0000-000000000000') SET @ShiftTimingId = NULL

			DECLARE @BranchId UNIQUEIDENTIFIER = (SELECT EB.BranchId FROM EmployeeBranch EB WHERE EB.EmployeeId = @EmployeeId AND EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom < GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE()))    
			
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
            SELECT S.Id AS ShiftTimingId,
					  S.[ShiftName] [Shift],
					  S.BranchId,
					  S.IsDefault,
                      S.CreatedDateTime,
                      S.CreatedByUserId,
                      S.[TimeStamp],
					  T.TimeZoneName,
					  CASE WHEN S.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                      TotalCount = COUNT(1) OVER()
            FROM ShiftTiming S 
				 LEFT JOIN [Branch] B ON S.BranchId = B.Id
				 LEFT JOIN TimeZone T ON B.TimeZoneId = T.Id
            WHERE S.CompanyId = @CompanyId
			     AND (@SearchText IS NULL OR (S.[ShiftName] LIKE @SearchText))
				 AND (@EmployeeId IS NULL OR (S.BranchId = @BranchId))
				 AND (@ShiftTimingId IS NULL OR S.Id = @ShiftTimingId)
				 AND ((@IsArchived IS NULL AND S.InActiveDateTime IS NULL) OR (@IsArchived = 1 AND S.InActiveDateTime IS NOT NULL) 
				                          OR (@IsArchived = 0 AND S.InActiveDateTime IS NULL))
            ORDER BY S.[ShiftName] ASC
 
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
 Go