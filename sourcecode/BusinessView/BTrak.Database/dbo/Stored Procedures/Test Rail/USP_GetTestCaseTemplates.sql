-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the TestCaseTemplates By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetTestCaseTemplates] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = 'a31b0c81-28c4-4920-9f7e-0fd5b52f058f'

CREATE PROCEDURE [dbo].[USP_GetTestCaseTemplates]
(
	@TestCaseTemplateId UNIQUEIDENTIFIER = NULL,
	@TemplateType NVARCHAR(250) = NULL,
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

			  IF (@TestCaseTemplateId = '00000000-0000-0000-0000-000000000000') SET @TestCaseTemplateId = NULL
			  
			  IF (@TemplateType = '') SET @TemplateType = NULL

			  SELECT TCT.Id AS Id,
			         TCT.TemplateType AS [Value],
					 (CASE WHEN TCT.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived,
					 TCT.CompanyId,
					 TCT.CreatedDatetime,
					 TCT.CreatedByUserId,
					 TCT.[TimeStamp],
					 TotalCount = COUNT(1) OVER()
			  FROM  [dbo].[TestCaseTemplate] TCT WITH (NOLOCK)
			  WHERE CompanyId = @CompanyId 
					AND (@TestCaseTemplateId IS NULL OR TCT.Id = @TestCaseTemplateId) 
				    AND (@TemplateType IS NULL OR TCT.TemplateType = @TemplateType) 
				    AND (@IsArchived IS NULL OR (@IsArchived = 1 AND TCT.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND TCT.InActiveDateTime IS NULL)) 
				    AND (@IsDefault IS NULL OR TCT.IsDefault = @IsDefault)
				ORDER BY TemplateType ASC 	

        END
		ELSE
        RAISERROR (@HavePermission,11, 1)    
	 END TRY  
	 BEGIN CATCH 
		
		   EXEC USP_GetErrorInformation

	 END CATCH
END
GO
