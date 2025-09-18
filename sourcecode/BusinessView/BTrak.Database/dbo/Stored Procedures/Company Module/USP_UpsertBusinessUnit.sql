---------------------------------------------------------------------------------
---- Author       Geetha CH
---- Created      '2020-09-21 00:00:00.000'
---- Purpose      To save or update businessunits
---- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertBusinessUnit] @BusinessUnitName = 'Snovasys Groups',@OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_UpsertBusinessUnit]
(
	@BusinessUnitId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@BusinessUnitName NVARCHAR(250) = NULL,
	@ParentBusinessUnitId UNIQUEIDENTIFIER = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@EmployeeIdsXML XML = NULL
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@BusinessUnitName = '') SET @BusinessUnitName = NULL
		
		IF(@BusinessUnitId = '00000000-0000-0000-0000-000000000000') SET @BusinessUnitId = NULL
		
		IF(@ParentBusinessUnitId = '00000000-0000-0000-0000-000000000000') SET @ParentBusinessUnitId = NULL
		
		DECLARE @HavePermission NVARCHAR(500) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF(@HavePermission = '1')
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @NameCount INT = (SELECT COUNT(1) FROM BusinessUnit 
			                          WHERE BusinessUnitName = @BusinessUnitName
									  AND CompanyId = @CompanyId
									  AND InActiveDateTime IS NULL AND (@BusinessUnitId IS NULL OR Id <> @BusinessUnitId))
			
			DECLARE @ChildCount INT = (SELECT COUNT(1) FROM BusinessUnit WHERE ParentBusinessUnitId = @BusinessUnitId AND InActiveDateTime IS NULL)

			DECLARE @EmployeeCount INT = (SELECT COUNT(1) FROM EmployeeBusinessUnit EB WHERE BusinessUnitId = @ParentBusinessUnitId AND (EB.ActiveFrom IS NOT NULL AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE())))

			IF(@BusinessUnitName IS NULL)
			BEGIN
				
				RAISERROR(50011,11,1,'BusinessUnitName')

			END
			ELSE IF(@NameCount > 0)
			BEGIN
				
				RAISERROR(50001,16,1,'BusinessUnit')

			END
			ELSE IF(@EmployeeIdsXML IS NOT NULL AND ISNULL(@ChildCount,0) > 0)
			BEGIN
				
				RAISERROR('EmployeesAreAddedOnlyInLeafNodes',11,1)

			END
			ELSE IF(@EmployeeCount > 0 AND @ParentBusinessUnitId IS NOT NULL)
			BEGIN
				
				RAISERROR('ParentBusinessUnitHaveEmployees',11,1)

			END
			ELSE
			BEGIN
				
				DECLARE @CurrentDate DATETIME = GETDATE()

				DECLARE @IsLatest BIT = (CASE WHEN @BusinessUnitId IS NULL THEN 1
												  WHEN (SELECT [TimeStamp]
					                               FROM BusinessUnit WHERE Id = @BusinessUnitId) = @TimeStamp
					                         THEN 1 ELSE 0 END)
		
				IF(@IsLatest = 1)
				BEGIN

					IF(@BusinessUnitId IS NULL)
					BEGIN
						
						SET @BusinessUnitId = NEWID()

						INSERT INTO BusinessUnit(
						Id
						,BusinessUnitName
						,ParentBusinessUnitId
						,CreatedByUserId
						,CreatedDateTime
						,CompanyId
						)
						SELECT @BusinessUnitId
								,@BusinessUnitName
								,@ParentBusinessUnitId
								,@OperationsPerformedBy
								,@CurrentDate
								,@CompanyId

					   IF(@EmployeeIdsXML IS NOT NULL)
					   BEGIN
					   		
							INSERT INTO EmployeeBusinessUnit(Id,BusinessUnitId,EmployeeId,ActiveFrom,[CreatedDateTime],CreatedByUserId)
							SELECT NEWID(),@BusinessUnitId,X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER'),@CurrentDate,@CurrentDate,@OperationsPerformedBy
							FROM @EmployeeIdsXML.nodes('/GenericListOfGuid/*/guid') AS X(Y)

					   END

					END
					ELSE
					BEGIN
						
						UPDATE BusinessUnit SET BusinessUnitName = @BusinessUnitName
						                        ,ParentBusinessUnitId = @ParentBusinessUnitId
												,CompanyId = @CompanyId
												,UpdatedByUserId = @OperationsPerformedBy
												,UpdatedDateTime = GETDATE()
										WHERE Id = @BusinessUnitId
						
						SELECT X.Y.value('(text())[1]', 'UNIQUEIDENTIFIER') AS EmployeeId
						INTO #EmployeeList
						FROM @EmployeeIdsXML.nodes('/GenericListOfGuid/*/guid') AS X(Y)

						UPDATE EmployeeBusinessUnit 
						SET ActiveTo = @CurrentDate
						    ,UpdatedByUserId = @OperationsPerformedBy
							,UpdatedDateTime = @CurrentDate
						WHERE BusinessUnitId = @BusinessUnitId
						      AND EmployeeId NOT IN (SELECT EmployeeId FROM #EmployeeList)

						UPDATE EmployeeBusinessUnit
						SET ActiveTo = NULL
							,UpdatedByUserId = @OperationsPerformedBy
							,UpdatedDateTime = @CurrentDate
						WHERE BusinessUnitId = @BusinessUnitId
						      AND EmployeeId IN (SELECT EmployeeId FROM #EmployeeList)

						INSERT INTO EmployeeBusinessUnit(Id,BusinessUnitId,EmployeeId,ActiveFrom,[CreatedDateTime],CreatedByUserId)
						SELECT NEWID(),@BusinessUnitId,EmployeeId,@CurrentDate,@CurrentDate,@OperationsPerformedBy
						FROM #EmployeeList 
						WHERE EmployeeId NOT IN (SELECT EmployeeId FROM EmployeeBusinessUnit EB
						                         WHERE BusinessUnitId = @BusinessUnitId
												       AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE())
												 )

					END

					SELECT Id FROM BusinessUnit WHERE Id = @BusinessUnitId

				END
				ELSE
					RAISERROR (50008,11, 1)

			END

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
