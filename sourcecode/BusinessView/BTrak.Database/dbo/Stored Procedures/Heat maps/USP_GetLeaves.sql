---------------------------------------------------------------------------
-- Author       Gududhuru Raghavendra
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Get Leaves Details From joining Date
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_GetLeaves] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetLeaves]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER,
	@IsSickLeave BIT = NULL,
	@day NVARCHAR(20) = null
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = 1;--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN	  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
		   IF(@UserId IS NULL)
		   BEGIN
				SET @UserId = @OperationsPerformedBy;
		   END
		   
		   IF(@day = '') SET @day = NULL

		   IF(@IsSickLeave IS NULL) SET @IsSickLeave = 0

		   DECLARE @DateFrom DATE = (SELECT ISNULL(J.JoinedDate,U.RegisteredDateTime)
										 FROM  Employee E
										 INNER JOIN [User] U ON U.Id = E.UserId AND U.Id = @UserId
										 LEFT JOIN [Job] J ON J.EmployeeId = E.Id
										 WHERE J.InActiveDateTime IS NULL);
		  
		   IF(DATEDIFF(YEAR,@DateFrom,GETDATE()) > 5) SET @DateFrom = DATEADD(YEAR,-5,GETDATE())

		   SELECT T.[Date]
		         ,CASE WHEN @IsSickLeave = 1 OR @day IS NOT NULL THEN ISNULL(Le.Cnt,0)
				       WHEN LE.[Date] IS NOT NULL THEN Le.Cnt
					   WHEN TS.[Date] IS NOT NULL THEN 2
					   WHEN H.[Date] IS NOT NULL THEN 3
					ELSE 0 END AS LeavesCount 
		   FROM (SELECT DATEADD(DAY,NUMBER,@DateFrom) AS [Date] FROM Master..SPT_VALUES where [type] =  'P' AND number <= DATEDIFF(DAY,@DateFrom,GETDATE())) T
           LEFT JOIN(SELECT T.[date],CASE WHEN (H.[Date] = T.[Date]) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) 
															OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                ELSE 1 END END AS Cnt FROM
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM MASTER..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL
				                           AND (LA.UserId = @UserId) AND (LA.LeaveDateFrom BETWEEN @DateFrom AND GETDATE() OR LA.LeaveDateTo BETWEEN @DateFrom AND GETDATE())) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id AND (@day IS NULL OR  DATENAME(WEEKDAY,T.[date]) = @day)
				    JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsApproved = 1 AND LS.CompanyId = @CompanyId
					JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId
					JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeavetypeId AND (@IsSickLeave = 0 OR MLT.isSickleave = @IsSickLeave)
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					--LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.WeekOffDays IS NULL AND H.CompanyId = @CompanyId
		    WHERE T.[Date] BETWEEN @DateFrom AND GETDATE()) Le ON Le.[Date] = T.[Date]
			LEFT JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = @UserId AND TS.InActiveDateTime IS NULL AND TS.[date] = T.[Date]
			LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.CompanyId = @CompanyId  
			ORDER BY T.[Date] DESC

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
