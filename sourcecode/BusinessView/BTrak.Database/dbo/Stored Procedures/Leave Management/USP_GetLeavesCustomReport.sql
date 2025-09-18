CREATE PROCEDURE [dbo].[USP_GetLeavesCustomReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@DateTo DATETIME = NULL,
	@DateFrom  DATETIME = NULL,
	@Date  DATETIME = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	DECLARE @Temp TABLE
	(
	[Date] datetime,
	UserId UNIQUEIDENTIFIER,
	Counts INT
	)

	IF(@DateFrom IS NULL)SET @DateFrom = @Date
	IF(@DateTo IS NULL)SET @DateTo = @Date

	DECLARE  @StatusId UNIQUEIDENTIFIER =  (SELECT Id FROM LeaveStatus WHERE ISApproved = 1 AND CompanyId = @CompanyId )
	
INSERT INTO @Temp([Date],UserId,Counts)
SELECT t.[Date],U.Id,SUM(t.[Count]) FROM [User] U CROSS APPLY [dbo].[Ufn_GetLeaveDatesOfAnUser](U.Id,NULL,NULL,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date),
		  CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date),
		  @StatusId)T 
		  GROUP BY t.[Date],U.Id

SELECT EmployeeNumber [Employeee ID],ISNULL(U.FirstName,'')+' '+ISNULL(U.SurName,'') [Employee Name],
  STUFF(
         (SELECT ', ' + convert(varchar(max), FORMAT(cast(T.[Date] as date),'dd MMM yyyy') )
          FROM @Temp T WHERE U.Id = T.UserId     
          FOR XML PATH (''))
          , 1, 1, '')  AS date, 
		  (SELECT SUM(LeavesTaken) FROM [dbo].[Ufn_GetLeavesReportOfAnUser](U.Id,NULL,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date),
		  CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)) T ) [Total Leaves Taken]
 FROM [User]U INNER JOIN Employee E ON E.UserId =  U.Id AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
              AND U.CompanyId = @CompanyId

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END