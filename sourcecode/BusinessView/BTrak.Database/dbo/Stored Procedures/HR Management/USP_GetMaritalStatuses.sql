----------------------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-06-07 00:00:00.000'
-- Purpose      To Get MaritalStatus
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetMaritalStatuses] @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971',@SearchText = 'Single'
----------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetMaritalStatuses]
(
 @MaritalStatusId UNIQUEIDENTIFIER = NULL,
 @SearchText NVARCHAR(250) = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
 @IsArchived BIT NULL
)
 AS
 BEGIN
	 SET NOCOUNT ON
	 BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
         
		 IF(@HavePermission = '1')
         BEGIN 

		 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@MaritalStatusId = '00000000-0000-0000-0000-000000000000') SET @MaritalStatusId = NULL

		 IF(@SearchText = '') SET @SearchText = NULL

		 SELECT  MS.Id As MaritalStatusId,
	             MS.MaritalStatus MaritalStatus,
				 MS.CreatedDateTime,
                 MS.CreatedByUserId,
                 MS.[TimeStamp],
				 CASE WHEN MS.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                 TotalCount = COUNT(1) OVER()
            FROM MaritalStatus MS             
	             WHERE MS.CompanyId = @CompanyId
				   AND (@MaritalStatusId IS NULL OR MS.Id = @MaritalStatusId)
				   AND (@SearchText IS NULL OR @SearchText LIKE '%'+ @SearchText +'%')
				   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND MS.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND MS.InActiveDateTime IS NULL))
		ORDER BY MaritalStatus ASC

		END
		ELSE

		  RAISERROR(@HavePermission,11,1)

	    END TRY
		BEGIN CATCH
		    
			THROW

	    END CATCH
END
GO
