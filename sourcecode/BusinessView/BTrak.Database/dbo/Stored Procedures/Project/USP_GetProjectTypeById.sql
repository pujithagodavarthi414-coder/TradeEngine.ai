-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-17 00:00:00.000'
-- Purpose      To Get the ProjectType  By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetProjectTypes] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProjectTypeId='9BD58F66-FDA3-4A97-AA4B-E40ACEC2F606'

CREATE PROCEDURE [dbo].[USP_GetProjectTypeById]
(
  @ProjectTypeId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

     SET NOCOUNT ON

     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	      SELECT PT.Id AS ProjectTypeId,
		         PT.ProjectTypeName,
				 CASE WHEN PT.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived,
				 PT.InActiveDateTime AS ArchivedDateTime,
		         PT.CompanyId,
		         PT.CreatedByUserId,
				 PT.CreatedDateTime,
				 PT.UpdatedByUserId,
				 PT.UpdatedDateTime
		  FROM  [dbo].[ProjectType] PT WITH (NOLOCK)
		  WHERE PT.Id = @ProjectTypeId 
		       AND PT.CompanyId = @CompanyId

	 END TRY  
	 BEGIN CATCH 
		
		SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH

END
GO
