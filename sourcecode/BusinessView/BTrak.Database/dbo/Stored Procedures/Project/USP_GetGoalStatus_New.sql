-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-14 00:00:00.000'
-- Purpose      To Get the Goal Status By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetGoalStatus_New]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetGoalStatus_New]
(
	@GoalStatusId UNIQUEIDENTIFIER = NULL,	
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@GoalStatusName NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL
)

AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

           DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		   IF(@HavePermission = 1)
		   BEGIN

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	         SELECT GS.[Id] AS GoalStatusId,
			        GS.GoalStatusName,
					--GS.CompanyId,
			        GS.CreatedDateTime,
			        GS.CreatedByUserId,
			        GS.UpdatedDateTime,
			        GS.UpdatedByUserId,
					GS.[TimeStamp],
					CASE WHEN GS.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
		            TotalCount = COUNT(1) OVER()
			 FROM [GoalStatus] GS WITH (NOLOCK)
			 WHERE(@GoalStatusId IS NULL OR GS.Id = @GoalStatusId)
			      AND (@GoalStatusName IS NULL OR GS.GoalStatusName = @GoalStatusName)
				  AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL)
				  OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))

			 ORDER BY GoalStatusName ASC 	

	END
	ELSE
	   
	   RAISERROR(@HavePermission,11,1)

	END TRY 
	BEGIN CATCH

		 THROW

   END CATCH

END
