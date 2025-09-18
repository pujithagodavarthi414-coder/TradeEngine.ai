 -------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-14 00:00:00.000'
-- Purpose      To Get Reporting Methods
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetReportingMethods] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetReportingMethods]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @ReportingMethodType NVARCHAR(50) = NULL,
     @ReportingMethodId UNIQUEIDENTIFIER = NULL,    
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
 
            IF(@ReportingMethodId = '00000000-0000-0000-0000-000000000000') SET @ReportingMethodId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
            SELECT  RM.Id AS ReportingMethodId,
                    RM.ReportingMethodType AS ReportingMethodName,
                    RM.CreatedDateTime,
                    RM.CreatedByUserId,
                    RM.[TimeStamp],
					CASE WHEN RM.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END ISArchived,
                    TotalCount = COUNT(1) OVER()
            FROM ReportingMethod RM              
            WHERE RM.CompanyId = @CompanyId 
                AND (@SearchText IS NULL OR (RM.ReportingMethodType LIKE '%' + @SearchText + '%'))
				AND (@ReportingMethodId IS NULL OR RM.Id = @ReportingMethodId)
				AND (@ReportingMethodType IS NULL OR RM.ReportingMethodType = @ReportingMethodType)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND RM.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND RM.InactiveDateTime IS NULL))
            ORDER BY RM.ReportingMethodType ASC
 
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