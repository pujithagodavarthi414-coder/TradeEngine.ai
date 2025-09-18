
--EXEC [USP_GetLeaveStatusSetHistory] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308'
CREATE PROCEDURE [dbo].[USP_GetLeaveStatusSetHistory]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @LeaveApplicationId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF(@HavePermission = '1')
		BEGIN
			DECLARE @LeaveAppliedUserId UNIQUEIDENTIFIER = (SELECT UserId FROM LeaveApplication WHERE Id = @LeaveApplicationId)

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ReportToCount INT = (SELECT COUNT(1) FROM [dbo].[Ufn_GetEmployeeReportToMembers](ISNULL(@LeaveAppliedUserId,@OperationsPerformedBy)))

			DECLARE @FirstHalfId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsFirstHalf = 1)
			DECLARE @SecondHalfId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsSecondHalf = 1)

			DECLARE @Temp TABLE(
								Id UNIQUEIDENTIFIER,
								CreatedDateTime DATETIME,
								EndDateTime DATETIME,
								FromDateFormat NVARCHAR(60),
								ToDateFormat NVARCHAR(60),
								LeaveAppliedUser NVARCHAR(250),
								LeaveStatusName NVARCHAR(250),
								[Description] NVARCHAR(250),
								Reason NVARCHAR(250),
								LeaveStatusColour NVARCHAR(250),
								ProfileImage NVARCHAR(250)
							   )

			IF (@LeaveApplicationId IS NULL)
			BEGIN
				
				INSERT INTO @Temp(Id,
								CreatedDateTime,
								EndDateTime,
								LeaveAppliedUser,
								LeaveStatusName,
								[Description],
								Reason,
								LeaveStatusColour,
								ProfileImage)
				SELECT LA.Id
				      ,(SELECT CASE WHEN LA.FromLeaveSessionId = @SecondHalfId THEN  ISNULL(DATEADD(MINUTE,DATEDIFF(MINUTE,ISNULL(SE.StartTime,SW.StartTime),ISNULL(SE.EndTime,SW.EndTime))/2,DATEADD(MINUTE,DATEDIFF(MINUTE,0,ISNULL(SE.StartTime,SW.StartTime)),LA.LeaveDateFrom)),DATEADD(HOUR,12,LA.LeaveDateFrom)) 
				          ELSE ISNULL((DATEADD(MINUTE,DATEDIFF(MINUTE,0,ISNULL(SE.StartTime,SW.StartTime)),LA.LeaveDateFrom)),DATEADD(MINUTE,1,LA.LeaveDateFrom))
						  END 
				           FROM EmployeeShift ES
				           LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,LA.LeaveDateFrom) = SW.[DayOfWeek]
						   LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ES.ShiftTimingId AND CONVERT(DATE,LA.LeaveDateFrom) = SE.ExceptionDate
						   WHERE ((ES.ActiveFrom < LA.LeaveDateFrom AND ES.ActiveTo IS NULL) OR (ES.ActiveTo IS NOT NULL AND (LA.LeaveDateFrom BETWEEN ES.ActiveFrom AND ES.ActiveTo)))
						         AND ES.InActiveDateTime IS NULL AND ES.EmployeeId = E.Id
						   ) AS [Start]
				     ,(SELECT CASE WHEN LA.ToLeaveSessionId = @FirstHalfId THEN  ISNULL(DATEADD(MINUTE,DATEDIFF(MINUTE,ISNULL(SE.StartTime,SW.StartTime),ISNULL(SE.EndTime,SW.EndTime))/2,DATEADD(MINUTE,DATEDIFF(MINUTE,0,ISNULL(SE.StartTime,SW.StartTime)),LA.LeaveDateTo)),DATEADD(HOUR,12,LA.LeaveDateTo)) 
				          ELSE ISNULL((DATEADD(MINUTE,DATEDIFF(MINUTE,0,ISNULL(SE.EndTime,SW.EndTime)),LA.LeaveDateTo)),DATEADD(MINUTE,24*60-1,LA.LeaveDateTo))
						  END 
				           FROM EmployeeShift ES
				           LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,LA.LeaveDateTo) = SW.[DayOfWeek]
						   LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ES.ShiftTimingId AND CONVERT(DATE,LA.LeaveDateTo) = SE.ExceptionDate
						   WHERE ((ES.ActiveFrom < LA.LeaveDateTo AND ES.ActiveTo IS NULL) OR (ES.ActiveTo IS NOT NULL AND (LA.LeaveDateTo BETWEEN ES.ActiveFrom AND ES.ActiveTo)))
						         AND ES.InActiveDateTime IS NULL AND ES.EmployeeId = E.Id
						   ) AS [End]
					  ,U.FirstName + ' ' + ISNULL(U.SurName,'')
					  ,LS.LeaveStatusName
					  ,'LeaveFrom'
					  ,NULL
					  ,LS.LeaveStatusColour
					  ,U.ProfileImage
					   FROM LeaveApplication LA 
					   JOIN [User] U ON LA.UserId = U.Id AND LA.UserId = @OperationsPerformedBy
					   JOIN Employee E ON E.UserId = U.Id
					   JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId AND LA.InActiveDateTime IS NULL
				
				UPDATE @Temp SET FromDateFormat = CONVERT(nvarchar,CreatedDateTime,25),ToDateFormat = CONVERT(nvarchar,EndDateTime,25)
				
				INSERT INTO @Temp
				SELECT H.Id,
					   DATEADD(MINUTE,1,H.[Date]),
					   DATEADD(MINUTE,24*60-1,H.[Date]),
					   CONVERT(VARCHAR,CONVERT(DATE,[Date])),
					   NULL,
					   NULL,
					   NULL,
					   'Holiday',
					   Reason,
					   NULL,
					   NULL
					   FROM [Holiday] H
					   JOIN [User] U ON U.CompanyId = H.CompanyId AND H.InActiveDateTime IS NULL AND U.Id = @OperationsPerformedBy AND H.WeekOffDays IS NULL
			   INSERT INTO @Temp
			   SELECT T.Id,
					 DATEADD(MINUTE,1,T.[Date]),
					 DATEADD(MINUTE,24*60-1,[Date]),
					 CONVERT(VARCHAR,CONVERT(DATE,[Date])),
					 NULL,
					 NULL,
					 NULL,
					 'WeekOff',
					 'WeekOff',
					 NULL,
					 NULL
					  FROM (SELECT CONVERT(DATETIME,CONVERT(DATE,DATEADD(DAY,number,ISNULL(ES.ActiveFrom,U.RegisteredDateTime)))) AS [date],SW.Id
							  FROM [User] U
						      JOIN Employee E ON E.UserId = U.Id AND U.Id = @OperationsPerformedBy
							  LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id
							  LEFT JOIN MASTER..SPT_VALUES ON [type] = 'p' AND number < = DATEDIFF(DAY,ISNULL(ES.ActiveFrom,U.RegisteredDateTime),ISNULL(ES.ActiveTo,DATEADD(DAY,-1,DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) + 1,0))))
							  LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,DATEADD(DAY,number,ES.ActiveFrom)) = SW.[DayOfWeek]) T WHERE T.Id IS NULL
			
			END
			
			SELECT LSH.[Id] AS LeaveHistoryId
			      ,[LeaveApplicationId]
				  ,[LeaveStatusId]
				  ,CASE WHEN LA.FromLeaveSessionId = @SecondHalfId THEN DATEADD(HOUR,12,LA.LeaveDateFrom) ELSE LA.LeaveDateFrom END AS LeaveDateFrom
				  ,CASE WHEN LA.ToLeaveSessionId = @FirstHalfId THEN  DATEADD(HOUR,12,LA.LeaveDateTo) ELSE DATEADD(MINUTE,24*60-1,LA.LeaveDateTo) END AS LeaveDateTo
				  ,CASE WHEN LA.FromLeaveSessionId = @SecondHalfId THEN CONVERT(VARCHAR,LA.LeaveDateFrom,7) + ' Afternoon' ELSE CONVERT(VARCHAR,LA.LeaveDateFrom,7) END AS LeaveDateFromFormat
				  ,CASE WHEN LA.ToLeaveSessionId = @FirstHalfId THEN  CONVERT(VARCHAR,LA.LeaveDateTo,7) + ' Afternoon' ELSE CONVERT(VARCHAR,LA.LeaveDateTo,7) END AS LeaveDateToFormat
				  ,[LeaveStuatusSetByUserId]
				  ,LSH.[CreatedDateTime]
				  ,LSH.[CreatedDateTime] AS EndDateTime
				  ,LSH.[CreatedByUserId]
				  ,CONVERT(NVARCHAR,CONVERT(DATE,LSH.[CreatedDateTime])) AS CreatedDate
				  ,LSH.[Reason]
				  ,LSH.[Description]
				  ,LSH.OldValue
				  ,LSH.NewValue
				  ,LS.LeaveStatusName
				  ,U1.FirstName + ' ' + ISNULL(U1.SurName,'') AS StatusSetUser
				  ,U1.ProfileImage
				  ,U2.FirstName + ' ' + ISNULL(U2.SurName,'') AS LeaveAppliedUser
				  ,ApproveList = (STUFF((SELECT ','+CAST(U.FirstName+' '+ISNULL(U.SurName,'') AS VARCHAR)
																	FROM [User] U
																	JOIN (SELECT UserId FROM [Ufn_GetEmployeeReportToMembers](LA.UserId) WHERE (@ReportToCount = 1 OR (@ReportToCount > 1 AND UserLevel > 0))
																	GROUP BY [UserId]) T ON T.UserId = U.Id
																	FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
				  ,CASE WHEN LA.UserId = LA.CreatedByUserId THEN 0 ELSE 1 END AS OnBehalf
				  ,NULL AS LeaveStatusColour
				   FROM LeaveApplicationStatusSetHistory LSH
				   JOIN LeaveApplication LA ON LA.Id = LSH.LeaveApplicationId AND LA.InActiveDateTime IS NULL
				   JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
				   JOIN [User] U1 ON U1.Id = LSH.CreatedByUserId
				   JOIN [User] U2 ON U2.Id = LA.UserId
				   WHERE ((@LeaveApplicationId IS NULL AND LA.UserId = @OperationsPerformedBy) OR (LA.Id = @LeaveApplicationId))
				   UNION ALL
				   SELECT T.Id,
						  T.Id AS LeaveApplicationId,
						  NULL,
						  NULL,
						  NULL,
						  T.FromDateFormat AS LeaveDateFromFormat,
						  T.ToDateFormat AS LeaveDateToFormat,
						  NULL,
						  T.CreatedDateTime,
						  T.EndDateTime,
						  NULL,
						  NULL,
						  T.Reason,
						  T.[Description],
						  NULL,
						  NULL,
						  T.LeaveStatusName,
						  T.LeaveAppliedUser AS StatusSetUser,
						  T.ProfileImage,
						  NULL,
						  NULL,
						  NULL,
						  T.LeaveStatusColour
						  FROM @Temp T


				   ORDER BY CreatedDateTime DESC

		END
		ELSE

			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END