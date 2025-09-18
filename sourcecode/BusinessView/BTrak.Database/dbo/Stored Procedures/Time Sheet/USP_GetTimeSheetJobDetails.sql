-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTimeSheetJobDetails] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsIncludedPastData=1
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTimeSheetJobDetails]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @IsForProbation BIT = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         IF(@IsForProbation = NULL) SET @IsForProbation = 0

         DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
            --IF(@TimeSheetSubmissionId = '00000000-0000-0000-0000-000000000000') SET @TimeSheetSubmissionId = NULL
            
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
            SELECT 
				   JobId
            FROM TimeSheetJobDetails
            WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL 
			 AND ((@IsForProbation IS NULL) OR(@IsForProbation = 0 AND (IsForProbation = 0 OR IsForProbation IS NULL)) OR(@IsForProbation = 1 AND IsForProbation = 1))

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