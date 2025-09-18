-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-10-03 00:00:00.000'
-- Purpose      To Search the project
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetProjectsDropDown] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetProjectsDropDown]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER
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

	    SELECT P.Id AS ProjectId,
		       P.ProjectName
        FROM [dbo].[Project] P 
	    WHERE P.InactiveDateTime IS NULL
			  AND (P.CompanyId = @CompanyId)
		ORDER BY  P.ProjectName ASC

     END
	 ELSE
	 RAISERROR(@HavePermission,11,1)
	
	END TRY  
	BEGIN CATCH 
		
		 THROW

	END CATCH

END
GO