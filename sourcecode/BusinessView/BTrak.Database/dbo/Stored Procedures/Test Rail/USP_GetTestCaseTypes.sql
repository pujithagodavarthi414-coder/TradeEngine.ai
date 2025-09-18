-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the TestCaseTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modified       Ranadheer Rana Velaga
-- Created      '2019-05-27 00:00:00.000'
-- Purpose      To Get the TestCaseTypes By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTestCaseTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@IsArchived = 0
CREATE PROCEDURE [dbo].[USP_GetTestCaseTypes]
(
	@TestCaseTypeId UNIQUEIDENTIFIER = NULL,
	@TypeName NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@IsDefault BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
       SET NOCOUNT ON
       BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                    
        IF (@HavePermission = '1')
        BEGIN
			  
			  	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			  
			  IF(@IsArchived IS NULL) SET @IsArchived = 0
			  
			  IF (@TestCaseTypeId = '00000000-0000-0000-0000-000000000000') SET @TestCaseTypeId = NULL
			  
			  IF (@TypeName = '') SET @TypeName = NULL

			  SELECT TCT.Id AS Id,
			         TCT.[TypeName] AS [Value],
					 TCT.[TypeName] AS [Testcasetype],
					 (CASE WHEN TCT.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived,
					 TCT.CompanyId,
					 TCT.CreatedDatetime,
					 TCT.CreatedByUserId,
					 TCT.[TimeStamp],
					 TCT.IsDefault,
					 TotalCount = COUNT(1) OVER()
			  FROM  [dbo].[TestCaseType] TCT WITH (NOLOCK)
			  WHERE CompanyId = @CompanyId 
					AND (@TestCaseTypeId IS NULL OR TCT.Id = @TestCaseTypeId) 
				    AND (@TypeName IS NULL OR TCT.TypeName = @TypeName) 
				    AND (@IsArchived IS NULL OR (@IsArchived = 1 AND TCT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND TCT.InActiveDateTime IS NULL)) 
				    AND (@IsDefault IS NULL OR TCT.IsDefault = @IsDefault) 
			  ORDER BY TypeName ASC 	

			  END
			  ELSE
			       
				   RAISERROR(@HavePermission,11,1)

	          END TRY  
	          BEGIN CATCH 
		
		          THROW

           	  END CATCH
END
GO