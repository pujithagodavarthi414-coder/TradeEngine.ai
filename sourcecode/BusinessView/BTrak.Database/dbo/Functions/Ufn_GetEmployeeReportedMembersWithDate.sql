CREATE Function [dbo].[Ufn_GetEmployeeReportedMembersWithDate]
(
  @TeamLeadId UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER
)
RETURNS @ret TABLE
(
   lvl INTEGER ,
   ParentId UNIQUEIDENTIFIER,
   ChildId UNIQUEIDENTIFIER INDEX IX_Child Clustered,
   ChildName NVARCHAR(200),
   ChildJoinedDate DATETIME
)

BEGIN
    IF(@TeamLeadId = '00000000-0000-0000-0000-000000000000') 
	SET @TeamLeadId = NULL

    DECLARE @GetParent UNIQUEIDENTIFIER
	DECLARE @ParentName NVARCHAR(200)
	DECLARE @ParentJoinedDate DATETIME

    SELECT @GetParent = E.Id FROM Employee E 
    JOIN [User] U ON U.Id = E.UserId 
    WHERE U.Id = @TeamLeadId
        AND E.InActiveDateTime IS NULL

	SELECT @ParentName = (U.FirstName+' '+U.SurName) FROM Employee E 
    JOIN [User] U ON U.Id = E.UserId 
    WHERE U.Id = @TeamLeadId
        AND E.InActiveDateTime IS NULL

	SELECT @ParentJoinedDate = J.JoinedDate FROM Employee E 
    JOIN [User] U ON U.Id = E.UserId 
	LEFT JOIN Job J ON J.EmployeeId = E.Id
    WHERE U.Id = @TeamLeadId
        AND E.InActiveDateTime IS NULL
     
     IF(@TeamLeadId IS NOT NULL)
     BEGIN
          INSERT INTO @ret VALUES(0,@GetParent,@GetParent,@ParentName,@ParentJoinedDate)
          DECLARE @lvl INTEGER
          SET @lvl = 1

          /* Removed Inactive members from reporting*/
          INSERT INTO @ret (lvl, ParentId, ChildId, ChildName, ChildJoinedDate) SELECT @lvl, @GetParent, P.EmployeeId, U.FirstName+' '+U.SurName UserName, J.JoinedDate 
		                                                                  FROM  EmployeeReportTo P
																			 JOIN Employee E ON E.Id = P.EmployeeId JOIN [User] U ON U.Id = E.UserId
                                                                             LEFT JOIN Job J ON J.EmployeeId = E.Id
																		  WHERE P.ReportToEmployeeId = @GetParent AND P.ActiveTo IS NULL 
																			AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		                                                                    AND P.InActiveDateTime IS NULL
          WHILE (@@ROWCOUNT > 0)
          BEGIN
          SET @lvl = @lvl + 1
          INSERT INTO @ret (lvl, ParentId, ChildId, ChildName, ChildJoinedDate)
          SELECT @lvl, P.ReportToEmployeeId, P.EmployeeId, U.FirstName+' '+U.SurName UserName, J.JoinedDate 
          FROM EmployeeReportTo P WITH(NOLOCK)
          JOIN @ret r ON r.lvl = @lvl - 1 and P.ReportToEmployeeId = r.ChildId AND P.InActiveDateTime IS NULL
          JOIN Employee E ON E.Id = P.EmployeeId JOIN [User] U ON U.Id = E.UserId
          LEFT JOIN Job J ON J.EmployeeId = E.Id
          WHERE U.CompanyId = @CompanyId
          AND P.ActiveTo IS NULL
          AND P.EmployeeId <> P.ReportToEmployeeId
          AND NOT EXISTS(SELECT ChildId FROM @ret WHERE ChildId = P.EmployeeId)
          AND U.InActiveDateTime IS NULL AND U.IsActive = 1
          GROUP BY lvl,P.ReportToEmployeeId,P.EmployeeId,U.FirstName, U.SurName, J.JoinedDate
          
        END
    END
    ELSE
    BEGIN
       
		INSERT INTO @ret (ParentId, ChildId, ChildName, ChildJoinedDate)
		SELECT   ER.ReportToEmployeeId, ER.EmployeeId, U.FirstName+' '+U.SurName UserName, J.JoinedDate 
		FROM EmployeeReportTo ER
		JOIN Employee E ON E.Id = ER.EmployeeId
		JOIN [User] U ON U.Id = E.UserId AND U.CompanyId = @CompanyId
		LEFT JOIN Job J ON J.EmployeeId = E.Id
		WHERE (CONVERT(DATE,ER.ActiveFrom) < GETDATE()) AND (ER.ActiveTo IS NULL OR (CONVERT(DATE,ER.ActiveTo) > GETDATE()))
      
		DECLARE @Temp TABLE(Parent UNIQUEIDENTIFIER)
                         
		INSERT INTO @Temp
		SELECT ParentId FROM @ret WHERE ParentId NOT IN (SELECT ChildId FROM @ret)
									GROUP BY ParentId
       
		INSERT INTO @ret (ParentId,ChildId)
		SELECT NULL,Parent FROM @Temp

    END
       UPDATE @ret SET ChildId = E.UserId 
	   FROM @ret 
	   JOIN [Employee] E ON ChildId = E.Id AND E.InActiveDateTime IS NULL
	   
RETURN     

                                                                                                                               
END
