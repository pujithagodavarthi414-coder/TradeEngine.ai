CREATE FUNCTION [dbo].[Ufn_GetEmployeeReportToMembers]
(
    @UserId UNIQUEIDENTIFIER
)
RETURNS @returntable TABLE
(
    UserId UNIQUEIDENTIFIER,
    UserLevel INT
)
AS
BEGIN
    WITH ReportTo AS (SELECT  0 Lvl,@UserId AS UserId
                       UNION ALL
                       SELECT RT.Lvl+1,U.Id AS UserId
                              FROM ReportTo RT
                              JOIN Employee  E ON RT.UserId = E.UserId AND E.InActiveDateTime IS NULL
                              JOIN EmployeeReportTo ERP ON ERP.EmployeeId = E.Id AND ERP.InActiveDateTime IS NULL
                              JOIN Employee E1 ON E1.Id = ERP.ReportToEmployeeId AND E1.InActiveDateTime IS NULL
                              JOIN [User] U ON U.Id = E1.UserId AND U.InActiveDateTime IS NULL
                              WHERE RT.UserId IS NOT NULL
                      )
    INSERT INTO @returntable (UserId,UserLevel)
    SELECT UserId,Lvl FROM ReportTo
    RETURN
END