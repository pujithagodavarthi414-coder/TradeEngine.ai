--EXEC  [dbo].[USP_IsHavingReporters] @OperationsPerformedBy='9DB68192-202F-42B0-8358-6800F6C0C900'
CREATE PROCEDURE [dbo].[USP_IsHavingReporters]
@OperationsPerformedBy UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
		DECLARE @IsTrue BIT
		DECLARE @Reporterscount INT = (select COUNT(1) from employeereportto ERT
		INNER  JOIN Employee E ON E.Id=ERT.ReportToEmployeeId
		INNER JOIN [User] U ON U.Id = E.UserId
		WHERE U.Id=@OperationsPerformedBy AND ERT.ActiveTo IS NULL AND ERT.InActiveDateTime IS NULL)
		SET @IsTrue = CASE WHEN @Reporterscount > 0 THEN 1 ELSE 0 END
		SELECT @IsTrue
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END