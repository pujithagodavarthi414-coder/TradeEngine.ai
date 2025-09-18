CREATE PROCEDURE [dbo].[USP_GetMasterAccounts]
(
	@MasterAccountId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF(@HavePermission = '1')
		BEGIN				
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT Id,
				   [Account],
				   [ClassNo],
				   [ClassNoF],
				   [Class],
				   [ClassF],
				   [Group],
				   [GroupF],
				   [SubGroup],
				   [SubGroupF],
				   [AccountNo],
				   [AccountNoF],
				   [Compte],
				   [TimeStamp]
				FROM [dbo].[MasterAccounts]
				WHERE CompanyId = @CompanyId
				AND InActiveDateTime IS NULL
				AND (@MasterAccountId IS NULL OR Id = @MasterAccountId)
				ORDER BY [Account] ASC
		END
		ELSE   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END