--SELECT * FROM [Ufn_GetEmployeeBranchReportedMembers] ('127133F1-4427-4149-9DD6-B02E0E036971','4AFEB444-E826-4F95-AC41-2175E36A0C16')

CREATE FUNCTION [dbo].[Ufn_GetEmployeeBranchReportedMembers]
(
  @TeamLeadId UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER
)
RETURNS @ret TABLE
(
   lvl INTEGER ,
   ParentEmployeeId UNIQUEIDENTIFIER,
   EmployeeId UNIQUEIDENTIFIER INDEX IX_EmployeeId Clustered,
   UserId UNIQUEIDENTIFIER
)

BEGIN
    IF(@TeamLeadId = '00000000-0000-0000-0000-000000000000') 
	SET @TeamLeadId = NULL

    DECLARE @ParentEmployeeId UNIQUEIDENTIFIER

    SELECT @ParentEmployeeId = E.Id FROM Employee E 
    JOIN [User] U ON U.Id = E.UserId 
    WHERE U.Id = @TeamLeadId
        AND E.InActiveDateTime IS NULL
	
     -- SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL, @TeamLeadId)  

     IF(@TeamLeadId IS NOT NULL)
     BEGIN
          INSERT INTO @ret(lvl, ParentEmployeeId, EmployeeId) VALUES(0,@ParentEmployeeId,@ParentEmployeeId)
          DECLARE @lvl INTEGER
          SET @lvl = 1
          INSERT INTO @ret (lvl, ParentEmployeeId, EmployeeId) SELECT @lvl, @ParentEmployeeId, EmployeeId 
		                                                                  FROM  EmployeeReportTo 
																		  WHERE ReportToEmployeeId = @ParentEmployeeId AND ActiveTo IS NULL 
		                                                                    AND InActiveDateTime IS NULL
                                                                            AND EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL, @TeamLeadId))
          WHILE (@@ROWCOUNT > 0)
          BEGIN
              SET @lvl = @lvl + 1
              INSERT INTO @ret (lvl, ParentEmployeeId, EmployeeId)
              SELECT @lvl, P.ReportToEmployeeId, P.EmployeeId
              FROM EmployeeReportTo P WITH(NOLOCK)
              JOIN @ret r ON r.lvl = @lvl - 1 and P.ReportToEmployeeId = r.EmployeeId AND P.InActiveDateTime IS NULL
              JOIN Employee E ON E.Id = P.EmployeeId JOIN [User] U ON U.Id = E.UserId
              WHERE U.CompanyId = @CompanyId
              AND P.ActiveTo IS NULL
              AND P.EmployeeId <> P.ReportToEmployeeId
              AND NOT EXISTS(SELECT EmployeeId FROM @ret WHERE EmployeeId = P.EmployeeId)
              AND U.InActiveDateTime IS NULL AND U.IsActive = 1
              AND P.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL, @TeamLeadId))
              GROUP BY lvl,P.ReportToEmployeeId,P.EmployeeId          
          END
    END
    ELSE
    BEGIN
       
		INSERT INTO @ret (ParentEmployeeId, EmployeeId)
		SELECT ReportToEmployeeId, EmployeeId
		FROM EmployeeReportTo ER
		JOIN Employee E ON E.Id = ER.EmployeeId
		JOIN [User] U ON U.Id = E.UserId AND U.CompanyId = @CompanyId
		WHERE (CONVERT(DATE,ActiveFrom) < GETDATE()) AND (ActiveTo IS NULL OR (CONVERT(DATE,ActiveTo) > GETDATE()))
      
		DECLARE @Temp TABLE(Parent UNIQUEIDENTIFIER)
                         
		INSERT INTO @Temp
		SELECT ParentEmployeeId FROM @ret WHERE ParentEmployeeId NOT IN (SELECT EmployeeId FROM @ret)
									      GROUP BY ParentEmployeeId
       
		INSERT INTO @ret (ParentEmployeeId, EmployeeId)
		SELECT NULL, Parent FROM @Temp

    END

       UPDATE @ret SET UserId = E.UserId 
	   FROM @ret 
	   JOIN [Employee] E ON EmployeeId = E.Id AND E.InActiveDateTime IS NULL
	
RETURN                                                                                                                                    
END