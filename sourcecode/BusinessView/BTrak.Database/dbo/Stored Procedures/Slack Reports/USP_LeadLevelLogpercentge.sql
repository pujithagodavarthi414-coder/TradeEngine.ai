--EXEC [dbo].[USP_LeadLevelLogpercentge]
CREATE PROCEDURE [dbo].[USP_LeadLevelLogpercentge]
AS
BEGIN
    
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        DECLARE @Date DATETIME = (SELECT dbo.Ufn_GetRequiredPreviousDateExcludingNonWorkingDays (1))
        
        CREATE TABLE #LeadwithMembers 
        (
           RowNumber INT IDENTITY(1,1),
           EmploeyeeId UNIQUEIDENTIFIER,
           EmployeeUserId UNIQUEIDENTIFIER, 
           LeadUserId UNIQUEIDENTIFIER,
           LeadId UNIQUEIDENTIFIER,
           PlannedWork FLOAT,
           UnPlannedWork FLOAT
        )
        
        INSERT INTO #LeadwithMembers(EmploeyeeId,LeadId)
        (SELECT ER.EmployeeId,ER.ReportToEmployeeId FROM EmployeeReportTo ER WHERE ER.InActiveDateTime IS NULL)
        
        INSERT INTO #LeadwithMembers(EmploeyeeId,LeadId)
        SELECT ER.ReportToEmployeeId,ER.ReportToEmployeeId
        FROM EmployeeReportTo ER WHERE --ER.ReportToEmployeeId NOT IN (SELECT EmploeyeeId FROM #LeadwithMembers) AND 
        ER.InActiveDateTime IS NULL
        GROUP BY ER.ReportToEmployeeId
                             
        UPDATE #LeadwithMembers 
        SET EmployeeUserId = E.UserId,LeadUserId = EL.UserId
        FROM #LeadwithMembers L
        JOIN Employee E ON E.Id = L.EmploeyeeId AND E.InActiveDateTime IS NULL
        JOIN Employee EL ON EL.Id = L.LeadId AND EL.InActiveDateTime IS NULL
        
        UPDATE #LeadwithMembers 
        SET PlannedWork = ISNULL(Temp.PlannedLogTime * 1.00 / 60.0,0)
            ,UnPlannedWork = ISNULL(Temp.UnPlannedLogTime * 1.00 / 60.0,0)
        FROM
        (SELECT UST.CreatedByUserId
                          ,SUM(CASE WHEN BT.IsBugBoard = 1 OR G.IsToBeTracked = 1 OR BTS.IsBugBoard = 1 THEN UST.SpentTimeInMin ELSE 0 END) PlannedLogTime
                          ,SUM(CASE WHEN (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR BTS.IsBugBoard = 1) AND (G.IsToBeTracked = 0 OR G.IsToBeTracked IS NULL) 
										   THEN UST.SpentTimeInMin ELSE 0 END) UnPlannedLogTime
         FROM UserStory US 
		      INNER JOIN Project P ON P.Id = US.ProjectId
              LEFT JOIN Goal G ON G.Id = US.GoalId
                       --AND US.InActiveDateTime IS NULL 
                         AND G.InActiveDateTime IS NULL
			  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
              LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
			  LEFT JOIN BoardType BTS ON BTS.Id = S.BoardTypeId AND BTS.InActiveDateTime IS NULL
                         
              INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
                                   -- AND US.OwnerUserId = UST.CreatedByUserId 
                    WHERE CONVERT(DATE,UST.DateTo) = @Date 
         GROUP BY UST.CreatedByUserId 
       ) Temp RIGHT JOIN #LeadwithMembers LM ON LM.EmployeeUserId = Temp.CreatedByUserId
       SELECT [Responsible],PlannedLogPercentage FROM
       (
            SELECT (U.FirstName + ' ' + ISNULL(U.SurName,'')) AS [Responsible]
                   ,CASE WHEN SUM(LM.PlannedWork + LM.UnPlannedWork) = 0 THEN 0 
                            ELSE CAST((SUM(LM.PlannedWork) * 1.0 /SUM(LM.PlannedWork + LM.UnPlannedWork)) *100 AS DECIMAL(10,2)) 
                       END AS PlannedLogPercentage
            FROM #LeadwithMembers LM
            JOIN [User] U ON U.Id = LM.LeadUserId AND U.InActiveDateTime IS NULL AND CompanyId = '4AFEB444-E826-4F95-AC41-2175E36A0C16'
            GROUP BY LM.LeadUserId,U.FirstName + ' ' + ISNULL(U.SurName,'')
       ) T
       ORDER BY PlannedLogPercentage
    END TRY
    BEGIN CATCH
    
        THROW
    
    END CATCH
END
GO