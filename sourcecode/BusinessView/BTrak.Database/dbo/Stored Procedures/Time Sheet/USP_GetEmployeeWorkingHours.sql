CREATE PROCEDURE [dbo].[USP_GetEmployeeWorkingHours]
(
    @UserId UniqueIdentifier,
	@Year INT
)
AS
BEGIN

   DECLARE @StartDate DATETIME
   DECLARE @EndDate DATETIME
   DECLARE @CurrentDate DATE
   SELECT @CurrentDate = CONVERT(DATE,GETUTCDATE())
   SELECT @StartDate = DATEADD(YEAR,@Year-1900,0)
   SELECT @EndDate = DATEADD(yy, DATEDIFF(yy, 0, @StartDate) + 1, -1)

   SELECT U.Id,EmployeeId, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,'') FullName,TS.[Date], CAST(DATEDIFF(MINUTE,InTime,OutTime)/60 AS INT) WorkedHours 
   FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN Timing T WITH (NOLOCK) ON T.Id = E.TimingId LEFT JOIN UserActiveDetails UAD WITH (NOLOCK) ON UAD.UserId = U.Id JOIN TimeSheet TS ON TS.UserId = U.Id
   WHERE U.Id NOT IN (SELECT UserId FROM ExcludedUser)
           AND ((ActiveFrom >= @StartDate AND ActiveFrom <= @EndDate) OR @StartDate >=ActiveFrom)  AND (@StartDate <= ActiveTo OR ActiveTo IS NULL)
           AND @UserId = U.Id AND ([Date] >= @StartDate AND [Date] <= @EndDate) AND U.Id = @UserId ORDER BY [Date]
END