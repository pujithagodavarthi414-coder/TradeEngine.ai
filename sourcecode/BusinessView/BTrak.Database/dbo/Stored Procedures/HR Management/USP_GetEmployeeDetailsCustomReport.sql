CREATE PROCEDURE [dbo].[USP_GetEmployeeDetailsCustomReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@DateFrom DATETIME = NULL,
	@Date DATETIME = NULL,
    @DateTo DATETIME = NULL,
	@IsActive BIT = NULL
	
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))


	IF(@DateFrom IS NULL)SET @DateFrom = @Date
	IF(@DateTo IS NULL)SET @DateTo = @Date

SELECT E.EmployeeNumber [Emp ID],CASE WHEN U.InActiveDateTime IS NULL THEN 'Active' ELSE 'InActive' END [Status],DD.DepartmentName [Division],
	G.Gender Sex,ISNULL(U.FirstName,'')+' '+ISNULL(U.SurName,'') [Name],D.DesignationName Designation,
  	B.BranchName [Location],STUFF((SELECT ',' + ISNULL(U1.FirstName,'')+' '+ISNULL(U1.SurName ,'')
                          FROM [User] U1 INNER JOIN Employee  E2 ON E2.UserId = U1.Id AND U1.InActiveDateTime IS NULL AND E2.InActiveDateTime IS NULL
						                 INNER JOIN EmployeeReportTo ER ON ER.ReportToEmployeeId= E2.Id AND ER.InActiveDateTime IS NULL
                          WHERE ER.EmployeeId = E.Id AND (CONVERT(DATE,ER.ActiveFrom) < GETDATE()) AND (ER.ActiveTo IS NULL OR (CONVERT(DATE,ER.ActiveTo) > GETDATE()))
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')	[Reporting Manager],
	FORMAT(U.RegisteredDateTime,'dd MMM yyyy') [Date of Join],FORMAT(E.DateofBirth,'dd MMM yyyy') [Date of Birth],MS.MaritalStatus [Marital status],CAST((DATEDIFF(MONTH,E.DateofBirth,GETDATE())*1.0)/12.0 AS decimal(10,1))	[Age],
	U.UserName [Official Email ID],ECD.OtherEmail [Personal Email ID],U.MobileNo [Contact Number],(SELECT top 1 EC.MobileNo FROM EmployeeEmergencyContact EC  WHERE IsEmergencyContact = 1 AND EC.InActiveDateTime IS NULL AND EC.EmployeeId= E.Id)	[Emergency Contact Number],	
	(SELECT TOP 1 ISNULL(EMC.FirstName,'')+' '+ISNULL(EMC.LastName,'') FROM EmployeeEmergencyContact EMC  
			WHERE RelationshipId IN (SELECT Id FROM RelationShip WHERE RelationShipName = 'Father' AND CompanyId = @CompanyId) AND EMC.EmployeeId= E.Id AND InActiveDateTime IS NULL)[Father's Name],
(select SUM(CAST((DATEDIFF(MONTH,we.FromDate,WE.ToDate)*1.0)/12.0 AS decimal(10,1))) from  EmployeeWorkExperience WE where WE.EmployeeId = E.Id AND WE.InActiveDateTime IS NULL) [Total Experience on DOJ]
  ,ECD.Address1	[Permanent Address 1],ECD.Address2	[Permanent Address 2],S.StateName [Permanent Address 3], C.CountryName [Permanent Address 4],EAD.PANNumber [PAN Card],
  EAD.PFNumber [PF Number],EAD.UANNumber [UAN Number],EAD.ESINumber [ESI Number],BB.BankName [Bank Name],BD.AccountNumber [Bank Account] ,
  FORMAT(ER.ResignationDate,'dd MMM yyyy') [Date of Resignation] ,DATEDIFF(DAY,ER.ResignationDate,DATEADD(MONTH,J.NoticePeriodInMonths,ER.ResignationDate)) [Notice Period (in days)],
  ER.CommentByEmployee [Reason For Exit],FORMAT(ER.LastDate,'dd MMM yyyy') [Date of Releiving]
         FROM [User] U INNER JOIN Employee E ON E.USERId  = U.Id 
                       LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
					   LEFT JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
					   LEFT JOIN EmployeeContactDetails ECD ON ECD.EmployeeId = E.Id AND ECD.InActiveDateTime IS NULL
					   LEFT JOIN EmployeeAccountDetails EAD ON EAD.EmployeeId = E.Id AND EAD.InActiveDateTime IS NULL
					   LEFT JOIN Job J ON J.EmployeeId = E.Id AND J.InActiveDateTime IS NULL
					   LEFT JOIN Designation D ON D.Id = J.DesignationId AND D.InActiveDateTime IS NULL
					   LEFT JOIN Department DD ON DD.Id = J.DepartmentId AND J.InActiveDateTime IS NULL
					   LEFT JOIN Gender G ON G.Id = E.GenderId AND G.InActiveDateTime IS NULL
					   LEFT JOIN MaritalStatus MS ON MS.Id = E.MaritalStatusId AND MS.InActiveDateTime IS NULL
					   LEFT JOIN Country C ON C.Id = ECD.CountryId AND C.InActiveDateTime IS NULL
					   LEFT JOIN  [State] S ON S.Id = ECD.StateId AND S.InActiveDateTime IS NULL
					   LEFT JOIN BankDetail BD ON BD.EmployeeId = E.Id AND BD.InActiveDateTime IS NULL AND BD.EffectiveFrom IS NOT NULL 
					   AND (BD.EffectiveTo IS NULL OR BD.EffectiveTo >= CAST(GETDATE() AS DATE)) AND CAST( BD.EffectiveFrom AS DATE) < CAST(GETDATE() AS DATE)
					   LEFT JOIN Bank BB ON BB.Id = BD.BankId
					   LEFT JOIN EmployeeResignation ER ON ER.EmployeeId = E.Id AND ER.InactiveDateTime IS NULL AND ER.RejectedDate IS NULL
					   WHERE U.CompanyId = @CompanyId
					        AND (@IsActive IS NULL OR (@IsActive = 1 AND U.InActiveDateTime IS NULL AND U.IsActive = 1) OR (@IsActive = 0 AND U.InActiveDateTime IS NOT NULL AND U.IsActive = 0))
					        AND CAST(U.RegisteredDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                            AND CAST(U.RegisteredDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
							AND U.UserName <> 'support@snovasys.com'

END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO