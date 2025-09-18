--EXEC [USP_GetMonthlyLeavesReport] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetMonthlyLeavesReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER = NULL,
	@LeaveTypeId UNIQUEIDENTIFIER = NULL,
	@BranchId UNIQUEIDENTIFIER = NULL,
	@RoleId UNIQUEIDENTIFIER = NULL,
	@Year INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN

			IF (@Year IS NULL) SET @Year = DATEPART(YEAR,GETDATE())

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			SELECT T.[Year],DATENAME(MONTH,DATEADD(MONTH,T.[Month]-1,0)) AS [Month],SUM(T.[Days]) AS NumberOfLeaves
			FROM
		   (SELECT DATEPART(YEAR,N.[Date]) AS [Year],DATEPART(MONTH,N.[Date]) AS [Month],SUM(N.Cnt) AS [Days] 
			FROM
			(SELECT T.[Date],CASE WHEN (H.[Date] IS NOT NULL OR DATEPART(WEEKDAY,T.[Date]) IN (1,7)) AND (LT.IsIncludeHolidays = 0 OR LT.IsIncludeHolidays IS NULL) THEN 0 
			                               ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                      ELSE 1 END END AS Cnt
				   FROM
                   (SELECT DATEADD(DAY,NUMBER,LeaveDateFrom) AS [Date],LA.Id
			               FROM MASTER..SPT_VALUES MSPTV
		                   JOIN LeaveApplication LA ON MSPTV.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo)
			       	        AND MSPTV.[Type] = 'P'
			       	       JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId 
			       	                        AND (@LeaveTypeId IS NULL OR LT.Id = @LeaveTypeId)
			       						    AND (@UserId IS NULL OR LA.UserId = @UserId)
			       						    AND LT.CompanyId = @CompanyId
				           JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId AND LS.IsApproved = 1
						   JOIN [User] U ON U.Id = LA.UserId  AND U.IsActive = 1 AND U.CompanyId = @CompanyId --AND (@RoleId IS NULL OR U.RoleId = @RoleId)
					       JOIN Employee E ON E.UserId = LA.UserId  AND E.InActiveDateTime IS NULL
						   LEFT JOIN Job J ON J.EmployeeId = E.Id  AND J.ActiveTo IS NULL AND (@BranchId IS NULL OR J.BranchId = @BranchId)) T
				     JOIN LeaveApplication LAP ON LAP.Id = T.Id  
					 JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId  AND LT.CompanyId = @CompanyId
					 JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
					 JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					 LEFT JOIN [Holiday] H ON H.[Date] = T.[Date] AND H.CompanyId = @CompanyId AND H.InActiveDateTime IS NULL
					 ) N
		   GROUP BY DATEPART(YEAR,N.[Date]),DATEPART(MONTH,N.[Date])
			) T
			 WHERE T.[Year] = @Year
			 GROUP BY T.[Year],T.[Month]
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END