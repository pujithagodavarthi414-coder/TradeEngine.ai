--EXEC [dbo].[Ufn_GetCompliance] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@Variant=10

CREATE FUNCTION [dbo].[Ufn_GetCompliance]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @Variant FLOAT = NULL,
  @Text NVARCHAR(250) = NULL
)

RETURNS @Compliance TABLE
(
   Id UNIQUEIDENTIFIER,
	Responsible NVARCHAR(250),
	[Compliance %] DECIMAL(10,3),
	[Non Compliant Members] NVARCHAR(4000)
)
BEGIN
                
				 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
             
              IF(@Variant IS NULL OR @Variant = 0)
              SET @Variant = 10
              
			  DECLARE @DateFrom DATETIME,@DateTo DATETIME  
			  DECLARE @SelectedDate datetime

			  IF(@Text = 'LastMonth')
			  SELECT @DateFrom = StartDate,@DateTo = EndDate FROM Ufn_GetDatesWithText('LastMonth') 
			  

			  IF(@Text = 'LastWorkingDay' OR @Text IS NULL)
			  BEGIN

			  SET @SelectedDate  = (SELECT dbo.Ufn_GetRequiredPreviousDateExcludingNonWorkingDays (1))
              
			  SET @DateFrom = @SelectedDate
			  SET @DateTo = @SelectedDate

			  END

			  

			  DECLARE @CompliantHours NUMERIC(10,3) = (SELECT CAST(REPLACE([Value], 'h', '') AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like '%SpentTime%' AND [CompanyId] = @CompanyId)
             
			  DECLARE @LeadwithMembers TABLE
              (
                 RowNumber INT IDENTITY(1,1),
                 EmploeyeeId UNIQUEIDENTIFIER,
                 EmployeeUserId UNIQUEIDENTIFIER, 
                 LeadUserId UNIQUEIDENTIFIER,
                 LeadId UNIQUEIDENTIFIER,
                 SpentTime FLOAT,
                 CompliantSpentTime FLOAT,
                 LogTime FLOAT,
                 SpentTimeVariance FLOAT,
                 ExpectedLogTime FLOAT,
                 IsCompliant BIT
              )
              INSERT INTO @LeadwithMembers(EmploeyeeId,LeadId)
              (SELECT ER.EmployeeId,ER.ReportToEmployeeId FROM EmployeeReportTo ER INNER JOIN [Employee]E ON E.Id = er.EmployeeId
			                                                                       INNER JOIN [User]U ON U.Id = E.UserId AND CompanyId = @CompanyId
														WHERE ER.InActiveDateTime IS NULL)
             INSERT INTO @LeadwithMembers(EmploeyeeId,LeadId)
             SELECT ER.ReportToEmployeeId,ER.ReportToEmployeeId
             FROM EmployeeReportTo ER INNER JOIN [Employee]E ON E.Id = er.EmployeeId
			                          INNER JOIN [User]U ON U.Id = E.Id AND CompanyId = @CompanyId WHERE ER.InActiveDateTime IS NULL --ER.ReportToEmployeeId NOT IN (SELECT EmploeyeeId FROM @LeadwithMembers) AND 
             GROUP BY ER.ReportToEmployeeId
                     
             
             UPDATE @LeadwithMembers SET EmployeeUserId = E.UserId,LeadUserId = EL.UserId
             FROM @LeadwithMembers L
             JOIN Employee E ON E.Id = L.EmploeyeeId AND E.InActiveDateTime IS NULL
             JOIN Employee EL ON EL.Id = L.LeadId AND EL.InActiveDateTime IS NULL
          
                 DECLARE @Count INT  = (SELECT COUNT(1) FROM @LeadwithMembers)
    
                DECLARE @UserId UNIQUEIDENTIFIER
                   
                   WHILE(@Count > 0)
                   BEGIN
                      
                      SET @UserId = (SELECT EmployeeUserId FROM @LeadwithMembers E WHERE RowNumber = @Count)
                      
                       DECLARE @SpentTime FLOAT  = (SELECT ((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET( TS.InTime ,'+00:00'), (CASE WHEN @SelectedDate = CAST(GETDATE() AS Date)
                                                             AND TS.InTime IS NOT NULL AND TS.OutTime IS NULL THEN GETUTCDATE() ELSE SWITCHOFFSET(TS.OutTime ,'+00:00') END)),0) -
                                                             ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime ,'+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime ,'+00:00')),0)))
                                                    FROM TimeSheet TS
                                                    WHERE ([Date] >= @DateFrom AND [Date] <= @DateTo) AND  UserId = @UserId
                                                    GROUP BY TS.UserId,TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,TS.InTime,TS.OutTime)
                                      
                   
                         DECLARE @BreakTime FLOAT = (SELECT SUM(DATEDIFF(MINUTE, SWITCHOFFSET(UB.BreakIn ,'+00:00'), SWITCHOFFSET(UB.BreakOut ,'+00:00'))) BreakTime
                                                     FROM UserBreak UB
                                                     WHERE ([Date] >= @DateFrom AND [Date] <= @DateTo)  AND UB.UserId = @UserId
                                                     GROUP BY UB.UserId,UB.[Date])
                   
                         SET @SpentTime = (ISNULL(@SpentTime,0) - ISNULL(@BreakTime,0))/60
                         UPDATE @LeadwithMembers SET SpentTime = @SpentTime WHERE RowNumber = @Count
                   
                        UPDATE @LeadwithMembers SET CompliantSpentTime = CASE WHEN @SpentTime >= @CompliantHours THEN @CompliantHours ELSE @SpentTime END  WHERE RowNumber = @Count
                   
                         DECLARE @LogTime FLOAT = (SELECT SUM(SpentTimeInMin/60.0) SpentTime
                                                   FROM UserStory US
                                                   JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND @UserId = UST.CreatedByUserId
                                                   WHERE (CONVERT(DATE,UST.CreatedDateTime) >= @DateFrom AND CONVERT(DATE,UST.CreatedDateTime) <= @DateFrom )  AND UST.CreatedByUserId = @UserId AND US.InActiveDateTime IS NULL
                                                   GROUP BY CONVERT(DATE,UST.CreatedDateTime))
                   
                        UPDATE @LeadwithMembers SET LogTime = ISNULL(@LogTime,0) WHERE RowNumber = @Count
                        UPDATE @LeadwithMembers SET SpentTimeVariance = CompliantSpentTime*(1.0/@Variant) WHERE RowNumber = @Count
                        UPDATE @LeadwithMembers SET ExpectedLogTime = (CASE WHEN @UserId IN (SELECT UserId FROM ExpectedLoggingHours 
                        WHERE CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE()) AND CONVERT(Date,FromDate) <= CONVERT(Date,GETUTCDATE()) ) THEN (SELECT [Hours] FROM ExpectedLoggingHours 
                        WHERE UserId = @UserId) ELSE (CompliantSpentTime - ISNULL(SpentTimeVariance ,0)) END) WHERE RowNumber = @Count
                   
                        UPDATE @LeadwithMembers SET IsCompliant = CASE WHEN LogTime >= ExpectedLogTime THEN 1 ELSE 0 END WHERE RowNumber = @Count
                        SET @Count = @Count -1
                 
                    END

					INSERT INTO @Compliance(Id,Responsible,[Compliance %],[Non Compliant Members])
                    SELECT U.Id,(U.FirstName + ' ' + ISNULL(U.SurName,'')) AS [Responsible]
                    ,CAST(((SELECT count(1)*1.0 FROM @LeadwithMembers WHERE IsCompliant = 1 AND LeadUserId = LM.LeadUserId)
                    /(SELECT count(1)*1.0 FROM @LeadwithMembers WHERE LeadUserId = LM.LeadUserId))*100 AS DECIMAL(10,2)) [Compliance %],
                    (SELECT STUFF(( SELECT  ',' + Convert(nvarchar(max),(UO.FirstName + ' ' + ISNULL(UO.SurName,'') + ' ('+ CAST(LogTime AS VARCHAR(100)) + '/' + CAST(CAST(SpentTime AS numeric(10,2)) AS VARCHAR(100)) +')'))[text()]
                               FROM @LeadwithMembers LM1
                               JOIN [User] UO ON UO.Id = LM1.EmployeeUserId AND UO.InactiveDateTime IS NULL
                               WHERE IsCompliant = 0 AND LM1.LeadUserId = LM.LeadUserId
                               GROUP BY UO.FirstName,UO.SurName, LM1.LogTime, LM1.SpentTime 
                               FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')) [Non Compliant Members]
                    FROM @LeadwithMembers LM
                    JOIN [User] U ON U.Id = LM.LeadUserId AND U.InActiveDateTime IS NULL
                    GROUP BY LM.LeadUserId,U.FirstName + ' ' + ISNULL(U.SurName,''),U.Id ORDER BY [Compliance %] ASC

RETURN
END
GO