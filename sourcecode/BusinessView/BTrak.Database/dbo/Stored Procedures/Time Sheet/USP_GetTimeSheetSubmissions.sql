-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTimeSheetSubmissions] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsIncludedPastData=1
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTimeSheetSubmissions]
(
     @TimeSheetSubmissionId UNIQUEIDENTIFIER = NULL,    
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @IsIncludedPastData BIT= NULL
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
 
            IF(@TimeSheetSubmissionId = '00000000-0000-0000-0000-000000000000') SET @TimeSheetSubmissionId = NULL
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
            SELECT T.Id TimeSheetSubmissionId,
				   T.TimeSheetFrequency AS TimeSheetFrequencyId,
				   TSST.[Name],
				   T.ActiveFrom,
				   T.ActiveTo,
				   T.[TimeStamp]
            FROM TimeSheetSubmission T 
				 JOIN TimeSheetSubmissionType TSST ON T.TimeSheetFrequency = TSST.Id             
            WHERE T.CompanyId = @CompanyId
				AND ( @TimeSheetSubmissionId IS NULL OR @TimeSheetSubmissionId = T.Id)
				AND ( @IsIncludedPastData = 1 OR  ActiveTo IS NULL)
			ORDER BY ActiveFrom DESC
 
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