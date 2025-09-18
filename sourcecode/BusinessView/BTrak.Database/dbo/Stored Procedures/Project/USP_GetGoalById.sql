-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-23 00:00:00.000'
-- Purpose      To Get Goal By Applying GoalId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetGoalById]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@GoalId='05BB6D88-AFD2-4C3F-AE30-075F561FFF2B'

CREATE PROCEDURE [dbo].[USP_GetGoalById]
(
	@GoalId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

 SET NOCOUNT ON

	 BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        SELECT G.Id AS GoalId,
		       G.ProjectId,
			   G.BoardTypeId,
			   G.BoardTypeApiId,
		       --G.ArchivedDateTime,
			   G.GoalBudget,
			   G.GoalName,
			   G.GoalStatusId,
			   G.GoalShortName,
			   G.GoalStatusColor,
			   --G.IsArchived,
			   G.IsLocked,
			   G.IsProductiveBoard,
			   G.IsToBeTracked,
			   G.OnboardProcessDate,
			   --G.IsParked,
			   G.IsApproved,
			   G.ParkedDateTime,
			   G.[Version],
			   G.GoalResponsibleUserId,
			   G.ConfigurationId,
			   G.ConsiderEstimatedHoursId
	    FROM [Goal] G WITH (NOLOCK)
			 INNER JOIN [Project] P WITH (NOLOCK) ON P.Id = G.ProjectId
	    WHERE G.Id = @GoalId
		      AND P.CompanyId = @CompanyId

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