CREATE PROCEDURE [dbo].[USP_GetRateTagRoleBranchConfigurations]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250) = '1'

		IF (@HavePermission = '1')
		BEGIN
		
		   DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE)

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   SELECT RTRBC.Id RateTagRoleBranchConfigurationId,
		          RTRBC.BranchId,
				  RTRBC.RoleId,
				  RTRBC.StartDate,
				  RTRBC.EndDate,
				  B.BranchName,
				  R.RoleName,
				  RTRBC.[Priority],
				  RTRBC.[TimeStamp],
				  TotalCount = COUNT(1) OVER()
           FROM [dbo].[RateTagRoleBranchConfiguration] AS RTRBC 
		   LEFT JOIN Branch B ON B.Id = RTRBC.BranchId
		   LEFT JOIN [Role] R ON R.Id = RTRBC.RoleId 
           WHERE (B.CompanyId = @CompanyId OR R.CompanyId = @CompanyId OR RTRBC.CompanyId = @CompanyId)
				 AND (@IsArchived IS NULL 
			        OR (@IsArchived = 1 AND RTRBC.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND RTRBC.InActiveDateTime IS NULL))
		  ORDER BY RTRBC.CreatedDateTime DESC
		END
		ELSE
		BEGIN
			RAISERROR (@HavePermission,11, 1)
		END

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END