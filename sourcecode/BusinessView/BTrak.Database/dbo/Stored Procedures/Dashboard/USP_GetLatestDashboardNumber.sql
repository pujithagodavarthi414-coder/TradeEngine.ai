CREATE PROCEDURE [dbo].[USP_GetLatestDashboardNumber]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN

 SET NOCOUNT ON

	 BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        SELECT ISNULL(MAX(PD.DashboardId),0) AS LatestDashboardId
	    FROM [ProcessDashboard] PD WITH (NOLOCK)
			 --INNER JOIN [Goal] G WITH (NOLOCK) ON G.Id = PD.GoalId
			 INNER JOIN [User] U WITH (NOLOCK) ON U.Id = PD.CreatedByUserId
	    WHERE U.CompanyId = @CompanyId
		GROUP BY U.CompanyId

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
