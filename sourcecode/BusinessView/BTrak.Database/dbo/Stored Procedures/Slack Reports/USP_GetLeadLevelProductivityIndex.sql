-------------------------------------------------------------------------------
-- Author       Padmini B
-- Created      '2019-06-03 00:00:00.000'
-- Purpose      To Get Lead Level Productivity Index
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------
--EXEC [dbo].[USP_GetLeadLevelProductivityIndex] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetLeadLevelProductivityIndex]
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
        FROM EmployeeReportTo ER 
		WHERE InActiveDateTime IS NULL 

        INSERT INTO @LeadwithMembers(EmploeyeeId,LeadId)
        SELECT ER.ReportToEmployeeId,ER.ReportToEmployeeId
        FROM EmployeeReportTo ER WHERE --ER.ReportToEmployeeId NOT IN (SELECT EmploeyeeId FROM @LeadwithMembers) AND 
		InActiveDateTime IS NULL
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
		  WeekToDateTarget FLOAT,
          MonthToDateProductivity FLOAT,
		  MonthToDateTarget FLOAT
      )
      INSERT INTO @ProductiveHoursForUser(UserId,UserName,MonthToDateProductivity)
      SELECT UserId,UserName,SUM(ProductivityIndex) FROM [Ufn_ProductivityIndexofAnIndividual](@MonthDateFrom,@MonthDateTo,NULL,@CompanyId) GROUP BY UserId,UserName
      
	  UPDATE @ProductiveHoursForUser SET WeekToDateProductivity = ProductivityIndex
	  FROM @ProductiveHoursForUser PU
	  JOIN (SELECT SUM(ProductivityIndex) ProductivityIndex,UserId FROM [Ufn_ProductivityIndexofAnIndividual](@WeekDateFrom,@WeekDateTo,NULL,@CompanyId) GROUP BY UserId) 
	  PNInner ON PNInner.UserId = PU.UserId

	  UPDATE @ProductiveHoursForUser SET WeekToDateTarget = [Hours to be spent] * 5,MonthToDateTarget =  [Hours to be spent] * 30
	  FROM @ProductiveHoursForUser PU
	  JOIN (SELECT DATEDIFF(HOUR,StartTime,EndTime)-1 AS [Hours to be spent] ,U.Id UserId FROM EmployeeShift ES 
				JOIN ShiftWeek ST ON ES.ShiftTimingId = St.ShiftTimingId 
				JOIN Employee E ON E.Id = ES.EmployeeId 
				JOIN [User] U ON U.Id = E.UserId AND U.CompanyId = @CompanyId
				GROUP BY U.Id,StartTime,EndTime) 
	  PNInner ON PNInner.UserId = PU.UserId
      
      DECLARE @LeadsLevelProductivity TABLE
      (
          UserId UNIQUEIDENTIFIER,
          UserName VARCHAR(250),
          WeekToDateProductivity FLOAT,
		  WeekToDateTarget FLOAT,
          MonthToDateProductivity FLOAT,
		  MonthToDateTarget FLOAT
      )
      INSERT INTO @LeadsLevelProductivity(UserName,UserId)
      SELECT U.FirstName + ' ' + U.SurName,E.UserId FROM EmployeeReportTo P 
      JOIN Employee E ON E.Id = P.ReportToEmployeeId AND E.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL
      JOIN [User] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId = @CompanyId
      
	  UPDATE @LeadsLevelProductivity SET WeekToDateProductivity = ISNULL((LInner.WeekToDateProductivity),0)/(CASE WHEN CountofUser = 0 THEN 1 ELSE CountofUser END)
      FROm @LeadsLevelProductivity LLP 
      JOIN( SELECT SUM(WeekToDateProductivity) WeekToDateProductivity,LeadUserId,Count(EmployeeId) CountofUser FROM EmployeeReportTo ER
            JOIN @LeadwithMembers LM ON LM.EmploeyeeId = ER.EmployeeId AND ER.InActiveDateTime IS NULL
            LEFT JOIN @ProductiveHoursForUser PU ON PU.UserId = LM.EmployeeUserId
            GROUP BY LeadUserId)LInner ON LInner.LeadUserId = LLP.UserId
      
      UPDATE @LeadsLevelProductivity SET MonthToDateProductivity = ISNULL((LInner.MonthToDateProductivity),0)/(CASE WHEN CountofUser = 0 THEN 1 ELSE CountofUser END)
      FROM @LeadsLevelProductivity LLP 
      JOIN( SELECT SUM(MonthToDateProductivity) MonthToDateProductivity,LeadUserId,Count(EmployeeId) CountofUser FROM EmployeeReportTo ER
            JOIN @LeadwithMembers LM ON LM.EmploeyeeId = ER.EmployeeId AND ER.InActiveDateTime IS NULL
            LEFT JOIN @ProductiveHoursForUser PU ON PU.UserId = LM.EmployeeUserId
            GROUP BY LeadUserId
      )LInner ON LInner.LeadUserId = LLP.UserId

	  UPDATE @LeadsLevelProductivity SET WeekToDateTarget = ISNULL((LInner.WeekToDateTarget),0)/(CASE WHEN CountofUser = 0 THEN 1 ELSE CountofUser END),
	  MonthToDateTarget = ISNULL((LInner.MonthToDateTarget),0)/(CASE WHEN CountofUser = 0 THEN 1 ELSE CountofUser END)
      FROM @LeadsLevelProductivity LLP 
      JOIN(SELECT SUM(WeekToDateTarget) WeekToDateTarget,SUM(MonthToDateTarget) MonthToDateTarget,LeadUserId,Count(EmployeeId) CountofUser FROM EmployeeReportTo ER
            JOIN @LeadwithMembers LM ON LM.EmploeyeeId = ER.EmployeeId AND ER.InActiveDateTime IS NULL
            LEFT JOIN @ProductiveHoursForUser PU ON PU.UserId = LM.EmployeeUserId
            GROUP BY LeadUserId)LInner ON LInner.LeadUserId = LLP.UserId

     SELECT UserName AS [Employee name],CAST(WeekToDateProductivity AS DECIMAL(10,2)) AS [Week to date productivity],
	 CAST(WeekToDateTarget AS DECIMAL(10,2)) AS [Week to date target],
	 CAST(MonthToDateProductivity AS DECIMAL(10,2)) AS [Month to date productivity],
	 CAST(MonthToDateTarget AS DECIMAL(10,2)) AS [Month to date target]
	 FROM @LeadsLevelProductivity 
	 GROUP BY UserName,WeekToDateProductivity,WeekToDateTarget,MonthToDateTarget,MonthToDateProductivity ORDER BY MonthToDateProductivity DESC
END
END