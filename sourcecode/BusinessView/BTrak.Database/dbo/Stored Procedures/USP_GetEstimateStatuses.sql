----------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-06 00:00:00.000'
-- Purpose      To Get Estimate Statuses by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEstimateStatuses] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEstimateStatuses]
(
	@EstimateStatusId UNIQUEIDENTIFIER = NULL,
	@EstimateStatusName NVARCHAR(250) = NULL,
	@EstimateStatusColor NVARCHAR(250) = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @IsArchived BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

            IF(@SearchText = '') SET @SearchText = NULL

            SET @SearchText = '%'+ @SearchText +'%';       
		          
            IF(@EstimateStatusId = '00000000-0000-0000-0000-000000000000') SET @EstimateStatusId = NULL
           
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

			SELECT Id AS EstimateStatusId,
				   EstimateStatusName,
				   EstimateStatusColor,
				   CreatedDateTime,
				   [TimeStamp],
				   EstimateStatusColor,
				   TotalCount = COUNT(1) OVER()
			FROM [EstimateStatus] ES
			WHERE @SearchText IS NULL OR EstimateStatusName LIKE @SearchText
				  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND ES.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND ES.InactiveDateTime IS NULL))
				  AND ES.CompanyId = @CompanyId
			ORDER BY ES.EstimateStatusName

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