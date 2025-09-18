CREATE PROCEDURE [dbo].[USP_GetEmployeeSalaryCertificate]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@EmployeeId UNIQUEIDENTIFIER
)
AS
BEGIN

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	DECLARE @JoiningDate DATE, @Payslips NVARCHAR(MAX), @EmployeeName NVARCHAR(MAX), @Hikes NVARCHAR(MAX), @Designations NVARCHAR(MAX), @Roles NVARCHAR(MAX),
	        @Bonus NVARCHAR(MAX), @CurrencyCode NVARCHAR(50), @Branches NVARCHAR(MAX), @SalaryBreakDown NVARCHAR(MAX)

	SELECT @CurrencyCode = CurrencyCode
	FROM EmployeepayrollConfiguration EPC 
	     INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId
		 INNER JOIN SYS_Currency SC ON SC.Id = PT.CurrencyId
	WHERE EPC.EmployeeId = @EmployeeId
	      AND ActiveFrom = (SELECT MAX(ActiveFrom)
							FROM EmployeepayrollConfiguration EPC 
							     INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId
							WHERE EPC.EmployeeId = @EmployeeId AND ActiveFrom <= CAST(GETDATE() AS DATE))

	SELECT @JoiningDate = MAX(JoinedDate) FROM Job WHERE InActiveDateTime IS NULL AND EmployeeId = @EmployeeId

	SELECT @Payslips = 
	(SELECT DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) PayrollMonth,PR.PayrollStartDate, PR.PayrollEndDate, 
	        dbo.Ufn_GetCurrency(SC.CurrencyCode,CAST(PRE.ActualPaidAmount AS NUMERIC(20,0)),1) NetAmount
	FROM PayrollRunEmployee PRE
		 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
		 INNER JOIN PayrollTemplate PT ON PT.Id = PRE.PayrollTemplateId
		 INNER JOIN SYS_Currency SC ON SC.Id = PT.CurrencyId
		 INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
				     FROM PayrollRunEmployee PRE 
				          INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
		                  INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
					WHERE PR.InactiveDateTime IS NULL
					      AND DATEADD(month, DATEDIFF(MONTH, 0, PR.PayrollEndDate), 0) BETWEEN DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH,-24,GETDATE())), 0) AND DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
				    GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
				   AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
	WHERE PRE.EmployeeId = @EmployeeId AND PRE.IsInResignation = 0
	ORDER BY PR.PayrollStartDate
	FOR JSON AUTO)

	SELECT @Hikes = 
	(SELECT dbo.Ufn_GetCurrency(SC.CurrencyCode,Amount,1) CTC, dbo.Ufn_GetCurrency(SC.CurrencyCode,ISNULL(NetPayAmount,0),1) VariablePay, ES.ActiveFrom, ISNULL(ES.ActiveTo,'') ActiveTo
	 FROM EmployeeSalary ES
	      INNER JOIN EmployeepayrollConfiguration EPC ON EPC.SalaryId = ES.Id
	      INNER JOIN PayrollTemplate PT ON PT.Id = EPC.PayrollTemplateId
		  INNER JOIN SYS_Currency SC ON SC.Id = PT.CurrencyId
	 WHERE ES.EmployeeId = @EmployeeId AND ES.InActiveDateTime IS NULL
	 FOR JSON AUTO)

	 SELECT @Designations = 
	(SELECT D.DesignationName
	 FROM Job ED
	      INNER JOIN Designation D ON D.Id = ED.DesignationId
	 WHERE EmployeeId = @EmployeeId AND ED.InActiveDateTime IS NULL
	 FOR JSON AUTO)

	 SELECT @Roles = 
	(SELECT R.RoleName
	 FROM UserRole UR
	      INNER JOIN Employee E ON E.UserId = UR.UserId
	      INNER JOIN [Role] R ON R.Id = UR.RoleId
	 WHERE E.Id = @EmployeeId AND UR.InActiveDateTime IS NULL
	 FOR JSON AUTO)

	 SELECT @Bonus = 
	(SELECT DATENAME(MONTH,PR.PayrollEndDate) + ' ' + DATENAME(YEAR,PR.PayrollEndDate) PayrollMonth, dbo.Ufn_GetCurrency(SC.CurrencyCode,CAST(PEC.ActualComponentAmount AS NUMERIC(20,0)),1) Bonus
	FROM PayrollRunEmployeeComponent PEC
		 INNER JOIN PayrollRun PR ON PR.Id = PEC.PayrollRunId
		 INNER JOIN PayrollRunEmployee PRE ON PRE.EmployeeId = PEC.EmployeeId AND PRE.PayrollRunId = PEC.PayrollRunId
		 INNER JOIN (SELECT PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate, MAX(PRE.CreatedDateTime) CreatedDateTime
				     FROM PayrollRunEmployee PRE 
					      INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
						  INNER JOIN PayrollRunStatus PRS ON PRS.PayrollRunId = PR.Id
		                  INNER JOIN PayrollStatus PS ON PS.Id = PRS.PayrollStatusId AND PS.PayrollStatusName = 'Paid'
					 WHERE PR.InactiveDateTime IS NULL
				     GROUP BY PRE.EmployeeId, PR.PayrollStartDate, PR.PayrollEndDate) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
				   AND PREInner.PayrollStartDate = PR.PayrollStartDate AND PREInner.PayrollEndDate = PR.PayrollEndDate
		 INNER JOIN PayrollTemplate PT ON PT.Id = PRE.PayrollTemplateId
		 INNER JOIN SYS_Currency SC ON SC.Id = PT.CurrencyId
	WHERE PEC.EmployeeId = @EmployeeId AND PRE.IsInResignation = 0 AND PEC.ComponentName = 'Bonus'
	FOR JSON AUTO)

	SELECT @Branches = 
	(SELECT * FROM (
		SELECT B.BranchName, EB.ActiveFrom, ISNULL(EB.ActiveTo,'') ActiveTo
		FROM EmployeeBranch EB
		     INNER JOIN Branch B ON B.Id = EB.BranchId
		WHERE EmployeeId = @EmployeeId ) T
	 FOR JSON AUTO)

	 DECLARE @BranchId UNIQUEIDENTIFIER = (SELECT TOP 1 BranchId FROM EmployeeBranch WHERE EmployeeId = @EmployeeId ORDER BY ActiveFrom DESC)

	SELECT TOP 1 U.FirstName + ' ' + ISNULL(U.SurName,'') HRManagerName, U.MobileNo HRManagerMobileNo, U.UserName HRManagerEmail
	INTO #HrManagerDetails
	FROM [User] U INNER JOIN UserRole UR ON UR.UserId = U.Id INNER JOIN [Role] R ON R.Id = UR.RoleId
	     INNER JOIN Employee E ON E.UserId = U.Id
		 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.BranchId = @BranchId
	WHERE U.CompanyId = (SELECT CompanyId FROM Employee E INNER JOIN [User] U ON U.Id = E.UserId WHERE E.Id = @EmployeeId)
	      AND R.RoleName = 'HR Manager'
		  AND R.InActiveDateTime IS NULL
	ORDER BY UR.CreatedDateTime DESC

	DECLARE @PayrollRunId UNIQUEIDENTIFIER
	
	SELECT @SalaryBreakDown = 
	(SELECT * FROM (
		SELECT PR.Id PayrollRunId, PR.PayrollStartDate, PR.PayrollEndDate, PREC.ComponentName, PREC.IsDeduction, ISNULL(PTC.[Order],50) NewOrder,
		       dbo.Ufn_GetCurrency(@CurrencyCode,ABS(ActualComponentAmount),1) ActualComponentAmount, dbo.Ufn_GetCurrency(@CurrencyCode,ABS(ActualPaidAmount),1) ActualNetPayAmount
		FROM PayrollRunEmployee PRE
			 INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId
			 INNER JOIN PayrollRunEmployeeComponent PREC ON PREC.EmployeeId = PRE.EmployeeId AND PREC.PayRollRunId = PRE.PayRollRunId
			 INNER JOIN (SELECT PRE.EmployeeId, MAX(PRE.CreatedDateTime) CreatedDateTime
			             FROM PayrollRunEmployee PRE
						      INNER JOIN PayrollRun PR ON PR.Id = PRE.PayrollRunId 
			 			      INNER JOIN PayRollRunStatus PRRS ON PRRS.PayRollRunId = PRE.PayRollRunId
			 	              INNER JOIN PayRollStatus PRS ON PRS.Id = PRRS.PayRollStatusId
			 	         WHERE PRE.EmployeeId = @EmployeeId AND PRS.PayRollStatusName = 'Paid' AND PR.InactiveDateTime IS NULL
			             GROUP BY PRE.EmployeeId) PREInner ON PREInner.EmployeeId = PRE.EmployeeId AND PREInner.CreatedDateTime = PRE.CreatedDateTime 
			LEFT JOIN PayrolltemplateConfiguration PTC ON PTC.PayrolltemplateId = PRE.PayrolltemplateId AND PTC.PayrollComponentId = PREC.ComponentId AND PTC.InActiveDateTime IS NULL) T
			
	ORDER BY NewOrder,IsDeduction,ComponentName
	FOR JSON AUTO)

	--CREATE TABLE #PayrollDetails
	--(
	--    Id INT,
	--	IId INT,
	--    PayrollRunEmployeeId UNIQUEIDENTIFIER,
	--	EmployeeId UNIQUEIDENTIFIER,
	--    EmployeeName NVARCHAR(500),
	--    EmployeeNumber NVARCHAR(500),
	--	DateOfJoining DATETIME,
	--	Designation NVARCHAR(500),
	--	Department NVARCHAR(500),
	--	Location NVARCHAR(500),
	--    DaysInMonth INT,
	--	EffectiveWorkingDays FLOAT,
	--	BankName NVARCHAR(500),
	--	BankAccountNumber NVARCHAR(500),
	--	PfNumber NVARCHAR(500),
	--	Uan NVARCHAR(500),
	--	EsiNumber NVARCHAR(500),
	--	PanNumber NVARCHAR(500),
	--	Lop FLOAT,
	--	PayRollRunEmployeeComponentId UNIQUEIDENTIFIER,
	--	PayRollRunId UNIQUEIDENTIFIER,
	--	ComponentId UNIQUEIDENTIFIER,
	--    ComponentName NVARCHAR(500),
	--	ActualComponentAmount FLOAT,
	--	OriginalActualComponentAmount FLOAT,
	--	ModifiedOriginalActualComponentAmount NVARCHAR(500),		   
	--	[TimeStamp] TIMESTAMP,
	--	Comments NVARCHAR(500),
	--	IsNotEditable BIT,
	--	IsComponentUpdated BIT,
	--	ComponentAmount FLOAT,
	--    Actual NVARCHAR(500),
	--	[Full] NVARCHAR(500),
	--	IsDeduction BIT,
	--	ActualNetPayAmount NVARCHAR(500),
	--	NetPayAmount NVARCHAR(500),
	--	TotalDeductionsToDate NVARCHAR(500),
	--	ActualDeductionsToDate NVARCHAR(500),
	--	TotalEarningsToDate NVARCHAR(500),
	--	ActualEarningsToDate NVARCHAR(500),
	--	CompanyName NVARCHAR(500),
	--	HeadOfficeAddress NVARCHAR(500),
	--	CompanyBranches NVARCHAR(500),
	--	CompanySiteAddress NVARCHAR(500),
	--	CompanyEmail NVARCHAR(500),
	--	PayrollStatusId UNIQUEIDENTIFIER,
	--	PayrollMonth NVARCHAR(500),
	--	CurrencyName NVARCHAR(500),
	--	CurrencyCode NVARCHAR(500),
	--	Symbol NVARCHAR(500),
	--	PayrollStartDate DATETIME,
	--	PayrollEndDate DATETIME,
	--	ActualNetPayAmountInWords NVARCHAR(500),
	--	[Order] INT,
	--	NewOrder INT
	--)

	--INSERT INTO #PayrollDetails
	--EXEC [dbo].[USP_GetPaySlipOfAnEmployee] @OperationsPerformedBy,@EmployeeId,@PayrollRunId

	SELECT @EmployeeId EmployeeId, 
	       U.FirstName + ' ' + ISNULL(U.SurName,'') + ' ' EmployeeName,
		   C.CompanyName,
		   C.SiteAddress + '.snovasys.io' CompanySiteAddress,
		   C.WorkEmail CompanyEmail,
		   C.PhoneNumber CompanyPhoneNumber,
		   (SELECT TOP(1) dbo.Ufn_GetCurrency(@CurrencyCode,Amount - ISNULL(NetPayAmount,0),1) FROM EmployeeSalary WHERE EmployeeId = @EmployeeId ORDER BY ActiveFrom, CreatedDateTime) AS StartingSalary,
		   @JoiningDate JoiningDate, 
		   @Payslips Payslips, 
		   @Hikes SalaryHikes, 
		   @Designations Designations, 
		   @Roles Roles, 
		   @Bonus Bonuses,
	       @Branches Branches,
		   @SalaryBreakDown SalaryBreakDownRecords,
		   JSON_VALUE(BInner.HeadOfficeAddress,'$.Street') + ', ' + JSON_VALUE(BInner.HeadOfficeAddress,'$.City') 
		   + ', ' + JSON_VALUE(BInner.HeadOfficeAddress,'$.State') + ' - ' + JSON_VALUE(BInner.HeadOfficeAddress,'$.PostalCode') HeadOfficeAddress,
		   HMD.*
	FROM Employee E 
	     INNER JOIN [User] U ON U.Id = E.UserId
		 INNER JOIN Company C ON C.Id = U.CompanyId
		 LEFT JOIN (SELECT TOP 1 CompanyId, [Address] HeadOfficeAddress FROM Branch WHERE IsHeadOffice = 1 AND InActiveDateTime IS NULL AND CompanyId = @CompanyId ORDER BY CreatedDateTime DESC) BInner 
		             ON BInner.CompanyId = C.Id
		 LEFT JOIN #HrManagerDetails HMD ON  1 = 1
	WHERE E.Id = @EmployeeId

	--SELECT @EmployeeId EmployeeId, @EmployeeName EmployeeName, @JoiningDate JoiningDate, @Payslips Payslips, @Hikes Hikes, @Designations Designations, @Roles Roles, @Bonus Bonus,
	--       @Branches Branches

END
GO


--EXEC [USP_GetEmployeeSalaryCertificate] 'F93C12E1-BEE7-4968-B984-C5129488AAA8','C4F319F8-B584-4CF5-B3AA-3215246511A2'