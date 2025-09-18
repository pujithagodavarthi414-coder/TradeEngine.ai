--SELECT * FROM [Ufn_GetEmployeeReportedMembers] ('127133F1-4427-4149-9DD6-B02E0E036971','4AFEB444-E826-4F95-AC41-2175E36A0C16')

CREATE FUNCTION [dbo].[Ufn_GetEmployeeReportedMembers]
(
  @TeamLeadId UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER
)
RETURNS @ret TABLE
(
   lvl INTEGER ,
   ParentId UNIQUEIDENTIFIER,
   ChildId UNIQUEIDENTIFIER INDEX IX_Child Clustered
)

BEGIN
    IF(@TeamLeadId = '00000000-0000-0000-0000-000000000000') 
	SET @TeamLeadId = NULL

    DECLARE @GetParent UNIQUEIDENTIFIER

    SELECT @GetParent = E.Id FROM Employee E 
    JOIN [User] U ON U.Id = E.UserId 
    WHERE U.Id = @TeamLeadId
        AND E.InActiveDateTime IS NULL
     
     IF(@TeamLeadId IS NOT NULL)
     BEGIN
          INSERT INTO @ret VALUES(0,@GetParent,@GetParent)
          DECLARE @lvl INTEGER
          SET @lvl = 1

          /* Removed Inactive members from reporting*/
          INSERT INTO @ret (lvl, ParentId, ChildId) SELECT @lvl, @GetParent, EmployeeId 
		                                                                  FROM  EmployeeReportTo P
																			 JOIN Employee E ON E.Id = P.EmployeeId JOIN [User] U ON U.Id = E.UserId
																		  WHERE ReportToEmployeeId = @GetParent AND ActiveTo IS NULL 
																			AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		                                                                    AND P.InActiveDateTime IS NULL
          WHILE (@@ROWCOUNT > 0)
          BEGIN
          SET @lvl = @lvl + 1
          INSERT INTO @ret (lvl, ParentId, ChildId)
          SELECT @lvl, P.ReportToEmployeeId, P.EmployeeId
          FROM EmployeeReportTo P WITH(NOLOCK)
          JOIN @ret r ON r.lvl = @lvl - 1 and P.ReportToEmployeeId = r.ChildId AND P.InActiveDateTime IS NULL
          JOIN Employee E ON E.Id = P.EmployeeId JOIN [User] U ON U.Id = E.UserId
          WHERE U.CompanyId = @CompanyId
          AND P.ActiveTo IS NULL
          AND P.EmployeeId <> P.ReportToEmployeeId
          AND NOT EXISTS(SELECT ChildId FROM @ret WHERE ChildId = P.EmployeeId)
          AND U.InActiveDateTime IS NULL AND U.IsActive = 1
          GROUP BY lvl,P.ReportToEmployeeId,P.EmployeeId
          
        END
    END
    ELSE
    BEGIN
       
		INSERT INTO @ret (ParentId, ChildId)
		SELECT   ReportToEmployeeId, EmployeeId
		FROM EmployeeReportTo ER
		JOIN Employee E ON E.Id = ER.EmployeeId
		JOIN [User] U ON U.Id = E.UserId AND U.CompanyId = @CompanyId
		WHERE (CONVERT(DATE,ActiveFrom) < GETDATE()) AND (ActiveTo IS NULL OR (CONVERT(DATE,ActiveTo) > GETDATE()))
      
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