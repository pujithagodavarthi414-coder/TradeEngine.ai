CREATE PROCEDURE [dbo].[USP_GetTotalAbsentEmployees] (
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @Date DATETIME = NULL
)
AS
BEGIN
SET NOCOUNT ON
BEGIN TRY
	DECLARE @HavePermission NVARCHAR(250)  = 1 --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	IF(@HavePermission= '1')
		BEGIN
        IF @Date IS NULL SET @Date = GETDATE()
		DECLARE @CompanyId UNIQUEIDENTIFIER = (select CompanyId from [User] where Id= @OperationsPerformedBy)

SELECT COUNT([Days]) TotalCount
FROM (SELECT CASE WHEN LA.FromLeaveSessionId = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsSecondHalf = 1)
                        AND LA.ToLeaveSessionId = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsFirstHalf = 1) 
                    THEN DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1 - 1
              WHEN LA.FromLeaveSessionId = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsSecondHalf = 1)
                    THEN DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1 - 0.5
              WHEN LA.ToLeaveSessionId = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsFirstHalf = 1)
                    THEN DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1 - 0.5
             ELSE DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1
            END AS 'Days'
          FROM LeaveApplication LA
               INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
               AND IsApproved = 1 
                  AND IsApproved IS NOT NULL 
               --AND InActiveDateTime IS NULL
               INNER JOIN [User] U ON U.Id = LA.UserId
              AND (LA.IsDeleted = 0 OR LA.IsDeleted IS NULL) AND LA.InActiveDateTime IS NULL
              AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
           --INNER JOIN Employee E ON E.UserId = U.Id  
           INNER JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId
          WHERE U.CompanyId = @CompanyId
                AND LA.LeaveDateFrom <= @Date
             AND LA.LeaveDateTo >= @Date
             AND ((SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
                      AND UR.InactiveDateTime IS NULL
                      AND RF.InactiveDateTime IS NULL
                       WHERE UR.UserId = @OperationsPerformedBy AND RF.FeatureId = 'AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5') > 0
                      OR
                 U.Id IN (SELECT ChildId FROM dbo.Ufn_GetEmployeeReportedMembers(@OperationsPerformedBy,@CompanyId)))
         ) InnerSql 
         END
    ELSE
    BEGIN
	RAISERROR (@HavePermission,11, 1)
	END
    END TRY 
    BEGIN CATCH
    THROW
    END CATCH
END