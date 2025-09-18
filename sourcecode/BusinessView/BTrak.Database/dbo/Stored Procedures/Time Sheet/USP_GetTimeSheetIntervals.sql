CREATE PROCEDURE [dbo].[USP_GetTimeSheetIntervals]
(
     @TimeSheetIntervalId UNIQUEIDENTIFIER = NULL,    
     @OperationsPerformedBy UNIQUEIDENTIFIER
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
            IF(@TimeSheetIntervalId = '00000000-0000-0000-0000-000000000000') SET @TimeSheetIntervalId = NULL
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
            SELECT T.Id TimeSheetIntervalId,
				   T.TimeSheetIntervalFrequency AS TimeSheetFrequencyId,
				   TSST.[Name],
				   T.[TimeStamp]
            FROM [TimeSheetInterval] T 
				 JOIN TimeSheetSubmissionType TSST ON T.TimeSheetIntervalFrequency = TSST.Id             
            WHERE T.CompanyId = @CompanyId
				AND ( @TimeSheetIntervalId IS NULL OR @TimeSheetIntervalId = T.Id)
			--ORDER BY ActiveFrom DESC
 
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
