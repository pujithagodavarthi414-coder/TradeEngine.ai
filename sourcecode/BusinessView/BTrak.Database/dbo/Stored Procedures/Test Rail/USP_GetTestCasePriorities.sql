-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-04-05 00:00:00.000'
-- Purpose      To Get the TestCasePriorities By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetTestCasePriorities] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = 'a31b0c81-28c4-4920-9f7e-0fd5b52f058f'

CREATE PROCEDURE [dbo].[USP_GetTestCasePriorities]
(
	@TestCasePriorityId UNIQUEIDENTIFIER = NULL,
	@PriorityType NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@IsDefault BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	     IF(@HavePermission = '1')
	     BEGIN
			IF (@TestCasePriorityId = '00000000-0000-0000-0000-000000000000') SET @TestCasePriorityId = NULL
			  
			IF (@PriorityType = '') SET @PriorityType = NULL

			  SELECT TP.Id,
			         TP.[PriorityType] AS [Value],
				     (CASE WHEN TP.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived,
					 TP.CompanyId,
					 TP.CreatedDatetime,
					 TP.CreatedByUserId,
					 TP.IsDefault,
					 TP.[TimeStamp],
					 TotalCount = COUNT(1) OVER()
			  FROM  [dbo].[TestCasePriority] TP WITH (NOLOCK)
			  WHERE CompanyId = @CompanyId 
			        AND (@TestCasePriorityId IS NULL OR TP.Id = @TestCasePriorityId) 
				    AND (@PriorityType IS NULL OR TP.PriorityType = @PriorityType) 
				    AND (@IsArchived IS NULL OR (@IsArchived = 1 AND TP.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND TP.InActiveDateTime IS NULL)) 
				    AND (@IsDefault IS NULL OR TP.IsDefault = @IsDefault)
			  ORDER BY PriorityType ASC 	
 
      END
	  ELSE
	  BEGIN
	  
	       RAISERROR (@HavePermission,16, 1)
	  
	  END
	 END TRY  
	 BEGIN CATCH 
		
		   EXEC USP_GetErrorInformation

	 END CATCH
END
GO
