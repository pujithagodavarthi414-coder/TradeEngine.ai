CREATE PROCEDURE [dbo].[USP_UpdateTestSuiteProject]
	@TestSuiteId UNIQUEIDENTIFIER = NULL,
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN

    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
      IF(@HavePermission = '1')
       BEGIN
	      DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		  DECLARE @Currentdate DATETIME = GETDATE()

		  EXEC [USP_InsertTestRailAuditHistory] @TestSuiteId = @TestSuiteId,
															  @TestSuiteProjectId = @ProjectId,
									                          @OperationsPerformedBy = @OperationsPerformedBy
								UPDATE  [dbo].[TestSuite]
						                   SET [Id]  = @TestSuiteId,
										       [ProjectId] = @ProjectId,
										       [UpdatedDateTime]  = @Currentdate, 
				                               [UpdatedByUserId]  = @OperationsPerformedBy
									       WHERE Id = @TestSuiteId AND InActiveDateTime IS NULL

		  EXEC [dbo].[USP_InsertTestRailAuditHistory] @TestRunProjectId = @ProjectId,
																	@TestRunTestSuiteId = @TestSuiteId,
																	@OperationsPerformedBy = @OperationsPerformedBy

					CREATE TABLE #TestRunTemp 
					(
					    Id UNIQUEIDENTIFIER,
						TestRunName NVARCHAR(500)
					)
					INSERT INTO #TestRunTemp(Id,TestRunName)
					SELECT Id, [Name] FROM [dbo].[TestRun] WHERE TestSuiteId = @TestSuiteId AND InActiveDateTime IS NULL

					DECLARE @#TestRunIdsCount INT = (SELECT COUNT (1) FROM #TestRunTemp)

								UPDATE  [dbo].[TestRun]
						                   SET [TestSuiteId]  = @TestSuiteId,
										       [ProjectId] = @ProjectId,
										       [UpdatedDateTime]  = @Currentdate, 
				                               [UpdatedByUserId]  = @OperationsPerformedBy
									       WHERE TestSuiteId = @TestSuiteId AND InActiveDateTime IS NULL

						WHILE(@#TestRunIdsCount > = 1)
					     BEGIN
					      EXEC [dbo].[USP_InsertTestRailAuditHistory]@TestRailReportProjectId = @ProjectId, 
																	@OperationsPerformedBy = @OperationsPerformedBy
                               SET @#TestRunIdsCount = @#TestRunIdsCount -1
					      END
						        UPDATE [dbo].[TestRailReport]
								  SET [ProjectId] = @ProjectId,
								      [TestRunId] = TT.Id
								  FROM [#TestRunTemp] TT
							         WHERE TestRunId = TT.Id AND InActiveDateTime IS NULL


				     SELECT Id FROM [dbo].[TestSuite] WHERE Id = @TestSuiteId
	   END
	   ELSE
        BEGIN
         RAISERROR (@HavePermission,10, 1)
         END
	END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO