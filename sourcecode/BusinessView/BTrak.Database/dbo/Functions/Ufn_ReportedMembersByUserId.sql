--SELECT * FROM dbo.Ufn_ReportedMembersByUserId('0B2921A9-E930-4013-9047-670B5352F308','4AFEB444-E826-4F95-AC41-2175E36A0C16')

CREATE FUNCTION Ufn_ReportedMembersByUserId
(
	@TeamLeadId UNIQUEIDENTIFIER,
    @CompanyId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS 
RETURN

   WITH Tree AS
	(
		SELECT EmployeeId,ReportToEmployeeId
		       ,CONVERT( VARCHAR(4096), '>' + CONVERT( VARCHAR(50), ReportToEmployeeId ) + '>' ) AS PATH, 0 AS LOOP
		FROM EmployeeReportTo P
		WHERE P.ReportToEmployeeId = (SELECT E.Id 
		                              FROM Employee E 
		                              WHERE E.UserId = @TeamLeadId AND E.InActiveDateTime IS NULL)
			  AND P.ActiveFrom IS NOT NULL AND P.ActiveFrom <= GETDATE() AND (P.ActiveTo IS NULL OR (P.ActiveTo >= GETDATE()))
		UNION ALL
		SELECT P1.EmployeeId,P1.ReportToEmployeeId
		        ,CONVERT( VARCHAR(4096), PATH + CONVERT( VARCHAR(50), P1.ReportToEmployeeId ) + '>' ),
                 CASE WHEN CHARINDEX( '>' + CONVERT( VARCHAR(50), P1.ReportToEmployeeId ) + '>', PATH ) = 0 THEN 0 ELSE 1 END
		FROM EmployeeReportTo P1
			  INNER JOIN Employee E ON E.Id = P1.EmployeeId 
			  INNER JOIN Tree Parent ON Parent.EmployeeId = P1.ReportToEmployeeId AND Parent.EmployeeId <> P1.EmployeeId
			             AND P1.InActiveDateTime IS NULL
						 AND P1.ActiveFrom IS NOT NULL AND P1.ActiveFrom <= GETDATE() AND (P1.ActiveTo IS NULL OR (P1.ActiveTo >= GETDATE()))
			WHERE P1.ReportToEmployeeId = Parent.EmployeeId
			      AND Parent.LOOP = 0
	)

	SELECT E.UserId AS ChildId,Tree.ReportToEmployeeId
	FROM Tree
	     INNER JOIN [Employee] E ON E.Id = EmployeeId 
		 INNER JOIN [User] U ON U.Id = E.UserId
			        AND E.InActiveDateTime IS NULL
			        AND U.InActiveDateTime IS NULL
	--INNER JOIN [UserActiveDetails] UAD ON UAD.UserId = U.Id AND UAD.ActiveFrom IS NOT NULL AND UAD.ActiveFrom <= GETDATE() AND (UAD.ActiveTo IS NULL OR UAD.ActiveTo >= GETDATE())
	WHERE U.CompanyId = @CompanyId
	GROUP BY E.UserId,Tree.ReportToEmployeeId
	UNION ALL 
	SELECT @TeamLeadId,@TeamLeadId
GO