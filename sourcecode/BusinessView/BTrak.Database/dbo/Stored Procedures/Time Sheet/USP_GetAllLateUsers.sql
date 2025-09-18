CREATE PROCEDURE [dbo].[USP_GetAllLateUsers](
@OperationsPerformedBy UNIQUEIDENTIFIER,
@Date DATETIME = NULL
)
AS
BEGIN
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
  BEGIN TRY
	IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)
   
	IF (@HavePermission = '1')
	BEGIN

	     IF @Date IS NULL SET @Date = GETUTCDATE()
         DECLARE @CurrentDate DATE = (SELECT CONVERT(DATE,@Date))
         DECLARE @CanViewAllEmployees INT = (SELECT COUNT(1) FROM Feature AS F
         											JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
         											JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
         											JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
         											WHERE FeatureName = 'View activity reports for all employee' AND U.Id = @OperationsPerformedBy)
         
         SELECT TS.UserId, 
                CONCAT(U.FirstName,' ',U.SurName) AS FullName,
         	    U.ProfileImage,
         	    SWITCHOFFSET(TS.InTime, '+00:00') AS InTime
         
         FROM  TimeSheet TS
         INNER JOIN [User] U ON U.id = TS.UserId AND U.CompanyId = @CompanyId
         INNER JOIN Employee E ON E.UserId = TS.UserId
         INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id
        AND (ES.ActiveFrom IS NOT NULL AND ES.ActiveFrom <= @Date
											AND (ES.ActiveTo IS NULL OR ES.ActiveTo <= @Date))
         LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
         LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,TS.[Date])
         LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = TS.[Date]
         
         WHERE SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
		 AND U.Id <> @OperationsPerformedBy
         AND U.InActiveDateTime IS NULL AND TS.[Date] = @CurrentDate 
         AND (@CanViewAllEmployees > 0 OR U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) 
         WHERE ChildId <> @OperationsPerformedBy))
         ORDER BY 
         --DATEDIFF(MINUTE,ISNULL(SE.DeadLine,SW.DeadLine),TS.InTime) DESC,
         CONCAT(U.FirstName,' ',U.SurName)

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
GO
