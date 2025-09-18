CREATE PROCEDURE [dbo].[USP_GetAllAbsenceUsers](
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
         											WHERE F.Id = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5' AND U.Id = @OperationsPerformedBy)
         
         SELECT LAP.UserId,
			    CONCAT(U.FirstName,' ',U.SurName) AS FullName,
                U.ProfileImage,
				LT.LeaveTypeName

		 FROM LeaveApplication LAP
		 JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId 
		       AND LT.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy AND InActiveDateTime IS NULL) 
			   AND LT.InActiveDateTime IS NULL
		 JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
		 JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
		 JOIN [User] U ON U.Id = LAP.UserId AND U.InActiveDateTime IS NULL
		 JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
		 JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND (LS.IsApproved = 1 AND LS.IsApproved  IS NOT NULL)
		 LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((@CurrentDate  BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (@CurrentDate  >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
		 LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,@CurrentDate) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
		 LEFT JOIN Holiday H ON H.[Date] = @CurrentDate  AND H.InActiveDateTime IS NULL AND H.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy AND InActiveDateTime IS NULL) AND H.WeekOffDays IS NULL
		
		 WHERE LAP.InActiveDateTime IS NULL
			   AND U.Id <> @OperationsPerformedBy
			   AND U.CompanyId = @CompanyId
			    AND (LAP.IsDeleted = 0 OR LAP.IsDeleted IS NULL) AND LAP.InActiveDateTime IS NULL
              AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
		       AND CAST(LAP.LeaveDateFrom AS DATE) <= @CurrentDate AND CAST(LAP.LeaveDateTo AS DATE) >= @CurrentDate
		       AND (@CanViewAllEmployees > 0 OR LAP.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId) WHERE ChildId <>  @OperationsPerformedBy))	 				
	           ORDER BY CONCAT(U.FirstName,' ',U.SurName)

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
