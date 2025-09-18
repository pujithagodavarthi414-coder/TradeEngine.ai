--EXEC [USP_GetCompanyOverViewLeaveReport] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@DateFrom = '2019-01-01'
CREATE PROCEDURE [dbo].[USP_GetCompanyOverViewLeaveReport]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @DateFrom DATE = NULL,
 @DateTo DATE = NULL,
 @BranchId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			IF (@DateFrom IS NULL) SET @DateFrom = DATEADD(DAY,1,EOMONTH(GETDATE(),-1))

			IF (@DateTo IS NULL OR @DateTo > GETDATE()) SET @DateTo = GETDATE()

            DECLARE @Holidays FLOAT = ((SELECT COUNT(1) FROM [Holiday] WHERE [Date] BETWEEN @DateFrom AND @DateTo AND CompanyId = @CompanyId) + (SELECT COUNT(1) FROM (SELECT DATEADD(DAY,NUMBER,@DateFrom) AS [Date] FROM MASTER..SPT_VALUES WHERE [Type] = 'P' AND NUMBER <= DATEDIFF(DAY,@DateFrom,@DateTo)) H WHERE DATEPART(WEEKDAY,H.[Date]) IN (1,7)))
			
			SELECT E.CompanyId
			      ,C.CompanyName
			      ,E.ECount AS EmployeeCount
			      ,DATEDIFF(DAY,@DateFrom,@DateTo) - @Holidays + 1 AS Workingdays
			      ,ISNULL(SUM(S.Cnt),0) AS Absence 
				  ,100 - (((DATEDIFF(DAY,@DateFrom,@DateTo) - @Holidays) - ISNULL(SUM(S.Cnt),0))/(DATEDIFF(DAY,@DateFrom,@DateTo) - @Holidays)) * 100.00 AS AbsencePercentage
				  FROM
				  (SELECT U.CompanyId
				         ,COUNT(1) AS ECount
						  FROM [User] U 
			              JOIN Employee E ON E.UserId = U.Id  AND U.CompanyId = @CompanyId
						  LEFT JOIN Job J ON J.EmployeeId = E.Id AND (J.ActiveTo IS NULL OR J.ActiveTo <= @DateTo) 
						                 AND  (@BranchId IS NULL OR J.BranchId = @BranchId)
				  GROUP BY U.CompanyId) E
                  JOIN Company C ON C.Id = E.CompanyId AND  C.InActiveDateTime IS NULL
				  LEFT JOIN (SELECT U.CompanyId,CASE WHEN (H.[Date] IS NOT NULL OR DATEPART(WEEKDAY,T.[Date]) IN (1,7)) AND (LT.IsIncludeHolidays = 0 OR LT.IsIncludeHolidays IS NULL) THEN 0 
			                               ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                          ELSE 1 END END AS Cnt 
						  FROM (SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date]
						              ,LA.Id 
			                           FROM MASTER..SPT_VALUES MSPT
				                               JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' 
				                                               AND (LA.LeaveDateFrom BETWEEN @DateFrom AND @DateTo OR LA.LeaveDateTo BETWEEN @DateFrom AND @DateTo)
					                           JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId AND LS.CompanyId = @CompanyId AND LS.IsApproved = 1) T
				                       JOIN LeaveApplication LAP ON LAP.Id = T.Id 
					                   JOIN [User] U ON U.Id = LAP.UserId
			                           JOIN Employee E ON E.UserId = U.Id AND U.CompanyId = @CompanyId
				                       JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = @CompanyId
				                       JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				                       JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId 
				                       LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId
					                   LEFT JOIN Job J ON J.EmployeeId = E.Id AND (J.ActiveTo IS NULL OR J.ActiveTo <= @DateTo) 
						                              AND (@BranchId IS NULL OR J.BranchId = @BranchId)
		           WHERE T.[Date] BETWEEN @DateFrom AND @DateTo) S  ON E.CompanyId = S.CompanyId
				  GROUP BY E.CompanyId,E.ECount,C.CompanyName



		END
		ELSE

			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
