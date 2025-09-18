-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get The Get BoardTypeUis By Applying different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetBoardTypeUis]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetBoardTypeUis]
(
  @BoardTypeUiId UNIQUEIDENTIFIER = NULL,
  @BoardTypeUiName NVARCHAR(250) = NULL,
  @BoardTypeUiView NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
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

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      IF(@BoardTypeUiId = '00000000-0000-0000-0000-000000000000') SET  @BoardTypeUiId = NULL

	      IF(@BoardTypeUiName = '') SET  @BoardTypeUiName = NULL

	      IF(@BoardTypeUiView = '') SET  @BoardTypeUiView = NULL

	      SELECT BTU.Id AS BoardTypeUiId,
		         BTU.BoardTypeUiName,
				 BTU.BoardTypeUiView,
				 BTU.CreatedByUserId,
				 BTU.CreatedDateTime,
				 BTU.UpdatedByUserId,
				 BTU.UpdatedDateTime,
				 BTU.[TimeStamp],
				 CASE WHEN BTU.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
		         TotalCount = COUNT(1) OVER()

		  FROM  [dbo].[BoardTypeUi]  BTU WITH (NOLOCK)
		  WHERE (@BoardTypeUiId IS NULL OR BTU.Id = @BoardTypeUiId)
		        AND (@BoardTypeUiName IS NULL OR BTU.BoardTypeUiName = @BoardTypeUiName)
		        AND (@BoardTypeUiView IS NULL OR BTU.BoardTypeUiView = @BoardTypeUiView)
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND BTU.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND BTU.InActiveDateTime IS NULL))

	      ORDER BY BoardTypeUiName ASC 
		  
	 END
	 ELSE
	 
	   RAISERROR(@HavePermission,11,1)	
		      
	 END TRY  
	 BEGIN CATCH 
		
	       THROW

	END CATCH

END
GO