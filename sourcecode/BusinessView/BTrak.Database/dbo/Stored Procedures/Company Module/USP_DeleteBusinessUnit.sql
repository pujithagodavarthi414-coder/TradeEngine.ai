CREATE PROCEDURE [dbo].[USP_DeleteBusinessUnit]
(
	@BusinessUnitId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@BusinessUnitId = '00000000-0000-0000-0000-000000000000') SET @BusinessUnitId = NULL
		
		DECLARE @HavePermission NVARCHAR(500) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF(@HavePermission = '1')
		BEGIN
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			DECLARE @IsLatest BIT = (CASE WHEN @BusinessUnitId IS NULL THEN 1
												  WHEN (SELECT [TimeStamp]
					                               FROM BusinessUnit WHERE Id = @BusinessUnitId) = @TimeStamp
					                         THEN 1 ELSE 0 END)
		
			IF(@IsLatest = 1)
			BEGIN
				
				DECLARE @CurrentDate DATETIME = GETDATE()

				SELECT * INTO #BusinessUnits
				FROM [dbo].[Ufn_GetAllChildBusinessUnits](@BusinessUnitId,@CompanyId)
				
				IF(EXISTS(SELECT Id FROM BusinessUnitEmployeeConfiguration BE INNER JOIN #BusinessUnits BU ON BU.BusinessUnitId = BE.BusinessUnitId AND BE.ActiveFrom <= GETDATE() AND (BE.ActiveTo IS NULL OR BE.ActiveTo >= GETDATE())))
				BEGIN
				
					RAISERROR('ThisBusinessUnitOrItsChildsAreUsedInEmployeesPleaseDeleteTheDependenciesAndTryAgain',11,1)
				
				END
				ELSE
				BEGIN

					UPDATE EmployeeBusinessUnit SET ActiveTo = @CurrentDate
					FROM EmployeeBusinessUnit E INNER JOIN #BusinessUnits BU ON BU.BusinessUnitId = E.BusinessUnitId

					UPDATE BusinessUnit SET InActiveDateTime = @CurrentDate
					FROM BusinessUnit B 
					     INNER JOIN #BusinessUnits BU ON BU.BusinessUnitId = B.Id 
						            AND B.InActiveDateTime IS NULL
					
					SELECT Id FROM BusinessUnit WHERE Id = @BusinessUnitId

				END

			END
			ELSE
				RAISERROR (50008,11, 1)

		END
		ELSE
		BEGIN
			
			RAISERROR(@HavePermission,11,1)

		END

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH

END
GO