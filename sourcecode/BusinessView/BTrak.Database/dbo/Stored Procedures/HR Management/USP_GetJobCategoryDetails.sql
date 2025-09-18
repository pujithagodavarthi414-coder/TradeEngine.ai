 -------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-07-06 00:00:00.000'
-- Purpose      To Get Job Category Details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetJobCategoryDetails] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetJobCategoryDetails]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @JobCategoryId UNIQUEIDENTIFIER = NULL,
	 @JobCategory NVARCHAR(50) = NULL,    
     @SearchText NVARCHAR(250) = NULL,
	 @IsArchived BIT = NULL
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
            
            SET @SearchText = '%'+ @SearchText +'%'
 
            IF(@JobCategoryId = '00000000-0000-0000-0000-000000000000') SET @JobCategoryId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            SELECT    EL.Id AS JobCategoryId,
                      EL.JobCategoryType JobCategoryName,
                      EL.CreatedDateTime,
                      EL.CreatedByUserId,
                      EL.[TimeStamp],
					
					  CASE WHEN EL.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
                      TotalCount = COUNT(1) OVER()
            FROM JobCategory EL WHERE EL.CompanyId = @CompanyId
                AND (@SearchText IS NULL OR (EL.JobCategoryType LIKE '%' + @SearchText + '%'))
				AND (@JobCategoryId IS NULL OR EL.Id = @JobCategoryId)
				AND (@JobCategory IS NULL OR EL.JobCategoryType = @JobCategory)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND EL.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND EL.InactiveDateTime IS NULL))
            ORDER BY EL.JobCategoryType ASC
 
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