CREATE PROCEDURE [dbo].[USP_GetProductivityIndexOfIndividual]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
     @DateFrom DATETIME = NULL,
     @DateTo DATETIME = NULL
)
AS
BEGIN
    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	
	IF (@HavePermission = '1')
	BEGIN
	IF(@DateFrom = '') SET @DateFrom = NULL

	IF(@DateTo = '') SET @DateTo = NULL

	IF(@DateFrom IS NULL AND @DateTo IS NULL)
    BEGIN
        
        DECLARE @WeekDateFrom DATETIME = (SELECT dbo.Ufn_GetRequiredPreviousDateExcludingNonWorkingDays (5))
        DECLARE @MonthDateFrom DATETIME = (SELECT dbo.Ufn_GetRequiredPreviousDateExcludingNonWorkingDays (30))
        DECLARE @WeekDateTo DATETIME = (SELECT GETDATE())
        DECLARE @MonthDateTo DATETIME = (SELECT GETDATE())
    END
	ELSE
	BEGIN
		SET @WeekDateFrom = @DateFrom
		SET @WeekDateTo = @DateTo
		SET @MonthDateFrom = @DateFrom
		SET @MonthDateTo = @DateTo
	END
   
    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        DECLARE @LeadwithMembers TABLE
        (
            EmploeyeeId UNIQUEIDENTIFIER,
            EmployeeUserId UNIQUEIDENTIFIER,
            LeadUserId UNIQUEIDENTIFIER,
            LeadId UNIQUEIDENTIFIER,
            UserProductivityIndex INT,
            LeadProductivityIndex INT,
            LeadLevelIndex INT
        )
        INSERT INTO @LeadwithMembers(EmploeyeeId,LeadId)
        SELECT ER.EmployeeId,ER.ReportToEmployeeId
        FROM EmployeeReportTo ER WHERE InActiveDateTime IS NULL 

        INSERT INTO @LeadwithMembers(EmploeyeeId,LeadId)
        SELECT ER.ReportToEmployeeId,ER.ReportToEmployeeId
        FROM EmployeeReportTo ER WHERE InActiveDateTime IS NULL
		GROUP BY ER.ReportToEmployeeId

        UPDATE @LeadwithMembers SET EmployeeUserId = E.UserId,LeadUserId = EL.UserId
        FROM @LeadwithMembers L 
        LEFT JOIN Employee E ON E.Id = L.EmploeyeeId AND E.InActiveDateTime IS NULL 
        LEFT JOIN Employee EL ON EL.Id = L.LeadId AND EL.InActiveDateTime IS NULL
      DECLARE @ProductiveHoursForUser TABLE
      (
          UserName VARCHAR(250),
          UserId UNIQUEIDENTIFIER,
          WeekToDateProductivity FLOAT,
          MonthToDateProductivity FLOAT
      )
      INSERT INTO @ProductiveHoursForUser(UserId,UserName,MonthToDateProductivity)
      SELECT UserId,UserName,SUM(ProductivityIndex) FROM [Ufn_ProductivityIndexofAnIndividual](@MonthDateFrom,@MonthDateTo,NULL,@CompanyId) GROUP BY UserId,UserName
      
	  UPDATE @ProductiveHoursForUser SET WeekToDateProductivity = ProductivityIndex
	  FROM @ProductiveHoursForUser PU
	  JOIN (SELECT SUM(ProductivityIndex) ProductivityIndex,UserId FROM [Ufn_ProductivityIndexofAnIndividual](@WeekDateFrom,@WeekDateTo,NULL,@CompanyId) GROUP BY UserId) 
	  PNInner ON PNInner.UserId = PU.UserId

	  SELECT UserName AS [Employee name]
			,CAST(WeekToDateProductivity AS DECIMAL(10,2)) AS [Week to date productivity]
			,CAST(MonthToDateProductivity AS DECIMAL(10,2)) AS [Month to date productivity] 
			FROM @ProductiveHoursForUser GROUP BY UserName,WeekToDateProductivity,MonthToDateProductivity ORDER BY MonthToDateProductivity DESC

END
END