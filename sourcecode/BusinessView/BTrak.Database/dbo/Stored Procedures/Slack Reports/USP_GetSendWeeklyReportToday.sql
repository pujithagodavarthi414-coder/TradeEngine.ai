--EXEC [USP_GetSendWeeklyReportToday] @OperationsPerformedBy = 'DBF0F9E1-A3C5-4F44-A1E0-2501F5A01958'

CREATE PROCEDURE [dbo].[USP_GetSendWeeklyReportToday]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	
	 IF (@HavePermission = '1')
	 BEGIN
        DECLARE @Date NVARCHAR(300) = DATENAME(DW,GETUTCDATE())

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @Shift NVARCHAR(300) = (SELECT [ShiftName] FROM ShiftTiming WHERE Id = (SELECT ShiftTimingId FROM EmployeeShift ES JOIN Employee E ON E.Id = ES.EmployeeId WHERE UserId  = @OperationsPerformedBy))

		DECLARE @SendWeeklyReport BIT = 0

		IF(@Date = 'Saturday' AND @Shift = 'Without Weekend')
		BEGIN
			SET @SendWeeklyReport = 1
		END
		IF(@Date = 'Friday' AND @Shift = 'With Weekend')
		BEGIN
			SET @SendWeeklyReport = 1
		END

		SELECT @SendWeeklyReport SendWeeklyReport

    END
	END TRY
    BEGIN CATCH

        THROW

    END CATCH

END