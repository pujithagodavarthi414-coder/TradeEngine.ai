CREATE PROCEDURE [dbo].[USP_GetEmployeePresence]
(
   @BranchId UNIQUEIDENTIFIER,
   @WorkingStatus VARCHAR(100),
   @TeamLeadId UNIQUEIDENTIFIER,
   @CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    DECLARE @Users TABLE
    (
       UserId UNIQUEIDENTIFIER,
       FullName VARCHAR(900),
       [Status] VARCHAR(100)
    )
    IF(@BranchId = '00000000-0000-0000-0000-000000000000')
    BEGIN
    SET @BranchId = NULL
    END
    
    IF(@WorkingStatus = 'All')
    BEGIN
    SET @WorkingStatus = NULL
    END
    
    IF(@TeamLeadId = '00000000-0000-0000-0000-000000000000')
    BEGIN
    SET @TeamLeadId = NULL
    END
    IF (@CompanyId = '00000000-0000-0000-0000-000000000000')
    BEGIN
    SET @CompanyId = NULL
    END
    
    INSERT INTO @Users(UserId,FullName)
    SELECT U.Id,ISNULL(U.FirstName,'') +' ' + ISNULL(U.SurName,'')
    FROM [User] U WITH (NOLOCK) JOIN Employee E ON E.UserId = U.Id LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND ActiveTo IS NULL
    WHERE IsActive = 1
          AND (@BranchId IS NULL OR @BranchId = EB.BranchId)
          AND (U.CompanyId = @CompanyId)
    
    UPDATE @Users SET [Status] = 'Inside'
    FROM TimeSheet TS JOIN @Users U ON U.UserId = TS.UserId AND TS.[Date] = CONVERT(DATE,GETUTCDATE()) 
    UPDATE @Users SET [Status] = CASE WHEN CONVERT(DATE,GETUTCDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo THEN 'Outside' ELSE [Status] END
    FROM LeaveApplication LA JOIN @Users U ON U.UserId = LA.UserId
    
    UPDATE @Users SET [Status] = CASE WHEN BreakIn <= GETUTCDATE() AND BreakOut IS NULL THEN 'Outside' ELSE [Status] END
    FROM @Users U JOIN UserBreak UBT ON U.UserId = UBT.UserId AND UBT.[Date] = CONVERT(DATE,GETUTCDATE())
    
    UPDATE @Users SET [Status] = CASE WHEN 
    (LunchBreakStartTime IS NOT NULL AND LunchBreakEndTime IS NULL) OR OutTime IS NOT NULL OR Intime IS NULL 
    THEN 'Outside' ELSE [Status] END
    FROM @Users U LEFT JOIN TimeSheet TS ON U.UserId = TS.UserId AND TS.[Date] = CONVERT(DATE,GETUTCDATE())
    
    SELECT * FROM @Users WHERE (@WorkingStatus IS NULL OR @WorkingStatus = [Status])
END