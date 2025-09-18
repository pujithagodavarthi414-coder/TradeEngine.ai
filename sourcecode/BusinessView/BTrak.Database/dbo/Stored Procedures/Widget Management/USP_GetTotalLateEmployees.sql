CREATE PROCEDURE [dbo].[USP_GetTotalLateEmployees]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @Date DATETIME = NULL
)
AS
BEGIN 
SET NOCOUNT ON

BEGIN TRY
	DECLARE @HavePermission NVARCHAR(250)  = 1 --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	IF(@HavePermission= '1')
		BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER = (select CompanyId from [User] where Id= @OperationsPerformedBy)

		IF(@Date IS NULL) SET @Date = GETDATE()

		SET @Date = CONVERT(DATE,@Date)

			DECLARE @CanAccessAllEmployee INT = (SELECT COUNT(1) FROM Feature AS F
								JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
								JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
								JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
								WHERE F.Id = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5' AND U.Id = @OperationsPerformedBy)

						select COUNT(DISTINCT U.Id) AS LatesCount from TimeSheet TS
						            INNER JOIN [User] U ON U.id = TS.UserId AND U.CompanyId = @CompanyId
									INNER JOIN Employee E ON E.UserId = TS.UserId
									INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id
									 AND (ES.ActiveFrom IS NOT NULL AND ES.ActiveFrom <= @Date
											AND (ES.ActiveTo IS NULL OR ES.ActiveTo <= @Date))
						            LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
									LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,TS.[Date])
									LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = TS.[Date]
									WHERE SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
									       AND TS.[Date] = @Date
										   AND U.InActiveDateTime IS NULL
										   AND U.Id <> @OperationsPerformedBy
										   AND (@CanAccessAllEmployee > 0 OR U.Id IN (SELECT ChildId AS Child 
				                          FROM Ufn_GetEmployeeReportedMembers(@OperationsPerformedBy,@CompanyId)
				                          GROUP BY ChildId
				                          ))
		
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