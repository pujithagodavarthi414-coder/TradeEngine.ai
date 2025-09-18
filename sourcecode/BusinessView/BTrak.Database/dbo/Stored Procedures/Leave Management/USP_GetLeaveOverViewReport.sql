--EXEC USP_GetLeaveOverviewReport @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@UserId = '0B2921A9-E930-4013-9047-670B5352F308'
CREATE PROCEDURE [dbo].[USP_GetLeaveOverviewReport]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @UserId UNIQUEIDENTIFIER = NULL,
 @BranchId UNIQUEIDENTIFIER = NULL,
 @DateFrom DATE = NULL,
 @DateTo DATE = NULL,
 @LeaveApplicationId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @Date DATETIME = ISNULL((SELECT LeaveDateTo FROM LeaveApplication WHERE Id = @LeaveApplicationId),GETDATE())

			SELECT @DateFrom = DateFrom,@DateTo = DateTo FROM [dbo].[Ufn_GetFinancialYearDatesForleaves] (@UserId,DATEPART(YEAR,@Date))

			IF (@UserId IS NULL) SET @UserId = @OperationsPerformedBy

			CREATE TABLE #LeaveStatusCount (
			                                UserId UNIQUEIDENTIFIER,
											LeaveStatusId UNIQUEIDENTIFIER,
											Cnt FLOAT
										   )
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @ApproveModel NVARCHAR(MAX) = NULL
			IF(@LeaveApplicationId IS NOT NULL)
			BEGIN

			DECLARE @ReportToCount INT = (SELECT COUNT(1) FROM [dbo].[Ufn_GetEmployeeReportToMembers](@UserId))

			SET @ApproveModel = (
				SELECT *,totalCount = COUNT(1) OVER() FROM(
				SELECT T.UserId AS userId
				      ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS userName
					  ,ISNULL(U.ProfileImage,'') AS profileImage
					  ,LST.[CreatedDateTime] AS statusSetDate
				      ,(CASE WHEN LST.Id IS NULL THEN (SELECT LeaveStatusName FROM LeaveStatus WHERE IsWaitingForApproval = 1 AND CompanyId = @CompanyId)
					        ELSE LS.LeaveStatusName END) AS [status]
					   FROM
				(SELECT UserId FROM (SELECT UserId FROM [dbo].[Ufn_GetEmployeeReportToMembers](@UserId) WHERE (@ReportToCount = 1 OR (@ReportToCount > 1 AND UserLevel > 0)) GROUP BY UserId)T) T
				JOIN [User] U ON U.Id = T.UserId
				LEFT JOIN LeaveApplicationStatusSetHistory LST ON LST.CreatedByUserId = T.UserId AND LST.LeaveApplicationId = @LeaveApplicationId 
				                                              AND LST.OldValue IS NULL AND LST.NewValue IS NULL AND LSt.InActiveDateTime IS NULL
															  AND LST.[Description] NOT LIKE '%Applied%' 
				LEFT JOIN LeaveStatus LS ON LS.Id = LST.LeaveStatusId 
				) J
				ORDER BY J.statusSetDate DESC
				FOR JSON path)
			END

			DECLARE @TotalLeaves FLOAT = (SELECT SUM(LeaveCount) FROM [dbo].[Ufn_GetLeavesReportOfAnUser](@UserId,NULL,@DateFrom,@DateTo))
			
			SELECT U.Id AS UserId
			      ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS UserName
				  ,B.[BranchName]
				  ,R.RoleNames AS RoleName
			      ,ISNULL(LC.Approved,0) AS Approved
				  ,ISNULL(LC.Rejected,0) AS Rejected
				  ,ISNULL(LC.WaitingForApproval,0) AS WaitingForApproval 
				  ,ISNULL(@TotalLeaves,0) AS TotalNoOfLeaves
				  ,ISNULL(@TotalLeaves,0) - ISNULL(LC.Approved,0) AS Balance
				  ,@ApproveModel AS [ApprovalChain]
			       FROM [User] U 
				   JOIN [Employee] E ON E.UserId = U.Id AND U.IsActive = 1 AND (@UserId IS NULL OR E.UserId = @UserId)
				   JOIN (SELECT UR.UserId
							   ,STUFF((SELECT ','+CAST(R.RoleName AS VARCHAR)
								FROM UserRole UR1 JOIN [Role] R ON R.Id = UR1.RoleId AND UR1.UserId = UR.UserId
								FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleNames
								FROM UserRole UR
								JOIN [User] U ON UR.UserId = U.Id AND U.IsActive = 1 AND U.CompanyId = @CompanyId) R ON R.UserId = U.Id
				   LEFT JOIN [EmployeeBranch] J ON J.EmployeeId = E.Id AND J.ActiveTo IS NULL
				   LEFT JOIN [Branch] B ON B.Id = J.BranchId AND B.CompanyId = @CompanyId
				   LEFT JOIN (SELECT * FROM (SELECT UserId,LeaveStatus,Cnt FROM [dbo].[Ufn_GetLeavesCountWithStatusOfAUser](@UserId,@DateFrom,@DateTo,NULL,NULL,NULL)) T 
							  PIVOT(
							      SUM(Cnt)
							      FOR LeaveStatus IN (
							          [Approved],[Rejected],[WaitingForApproval])
							  ) AS LevesCount) LC ON LC.UserId = U.Id

		END
		ELSE

			RAISERROR(@HavePermission,11,1)
			
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END