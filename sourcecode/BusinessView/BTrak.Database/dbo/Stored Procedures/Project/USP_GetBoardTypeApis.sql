-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-11 00:00:00.000'
-- Purpose      To Get the BoardTypeApis By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetBoardTypeApis] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBoardTypeApis]
(
  @BoardTypeApiId UNIQUEIDENTIFIER = NULL,
  @ApiName NVARCHAR(200) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
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
          
			  IF (@BoardTypeApiId = '00000000-0000-0000-0000-000000000000') SET @BoardTypeApiId = NULL

			  IF(@IsArchived = '') SET  @IsArchived = NULL

			  IF(@ApiName = '') SET  @ApiName = NULL
			  
			  SELECT BA.Id AS BoardTypeApiId,
			         BA.ApiName,
			         BA.ApiUrl,
					 BA.CreatedByUserId,
					 BA.CreatedDateTime,
					 BA.UpdatedByUserId,
					 BA.UpdatedDateTime,
					 BA.[TimeStamp],	
					 CASE WHEN BA.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
		   			 TotalCount = COUNT(1) OVER()
			  FROM [dbo].[BoardTypeApi] BA WITH (NOLOCK)
			  WHERE (@ApiName IS NULL OR BA.ApiName LIKE '%'+ @ApiName + '%')
					AND (@BoardTypeApiId IS NULL OR BA.Id = @BoardTypeApiId)
					AND (@IsArchived IS NULL OR (BA.InActiveDateTime IS NULL AND @IsArchived = 0) 
					OR (BA.InActiveDateTime IS NOT NULL AND @IsArchived = 1))

			  ORDER BY ApiName ASC
		END

		ELSE
	    
			RAISERROR(@HavePermission,11,1)

	 END TRY  
	 BEGIN CATCH 
		
		  THROW

	END CATCH

END