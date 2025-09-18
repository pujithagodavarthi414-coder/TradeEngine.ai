-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-04-30 00:00:00.000'
-- Purpose      To Milstones and SubMilestones upto n levels
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetMilestonesAndSubMilestones] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@FeatureId = '64d7b42f-1b71-49bb-9c58-d9d5cc10760d'

CREATE PROCEDURE [dbo].[USP_GetMilestonesAndSubMilestones]
(
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@FeatureId UNIQUEIDENTIFIER = NULL,
	@operationsPerformedBy UNIQUEIDENTIFIER
)
AS 
SET NOCOUNT ON
BEGIN
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
		IF (@HavePermission = '1')
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT MInner.Id AS Id,
			       MInner.Tittle AS [Value]
			FROM Milestone M WITH (NOLOCK)
			     CROSS APPLY [dbo].[Ufn_GetMultiSubMilstones](M.Id) MInner
				 INNER JOIN Project P WITH (NOLOCK) ON P.Id = M.ProjectId 
			WHERE M.ParentMilestoneId IS NULL 
			      AND (@ProjectId IS NULL OR P.Id = @ProjectId)
				  AND M.InActiveDateTime IS NULL
				  AND P.CompanyId = @CompanyId
			ORDER BY MInner.[Path]	
			OPTION (MAXRECURSION 0)

		END
		ELSE
			RAISERROR (@HavePermission,11, 1)

	END TRY
	BEGIN CATCH
		
		EXEC USP_GetErrorInformation

	END CATCH
END
GO