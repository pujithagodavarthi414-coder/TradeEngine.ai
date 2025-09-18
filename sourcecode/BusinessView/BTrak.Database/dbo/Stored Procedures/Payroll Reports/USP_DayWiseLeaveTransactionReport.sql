-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Day Wise Leave Transaction Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_DayWiseLeaveTransactionReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_DayWiseLeaveTransactionReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@ColumnString NVARCHAR(1500) = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@Date DATETIME = NULL
	,@IsActiveEmployeesOnly BIT = 0
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

			IF(@IsActiveEmployeesOnly IS NULL) SET @IsActiveEmployeesOnly = 0

			IF(@Date IS NULL) SET @Date = CONVERT(DATE,GETDATE())

			IF(@ColumnString IS NULL OR @ColumnString = '') SET @ColumnString = '[Employee Number],[Name],[Leave Type],[From],[To],[Days],[Reason],[Applied Date],[Leave Status]'

			DECLARE @FirstHalfLeaveSessionId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsFirstHalf = 1)
			
			DECLARE @SecondHalfLeaveSessionId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsSecondHalf = 1)

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT E.EmployeeNumber AS ''Employee Number''
										       ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS ''Name''
											   ,LT.LeaveTypeName AS ''Leave Type''
											   ,CONVERT(NVARCHAR,LA.LeaveDateFrom,106) AS ''From''
											   ,CONVERT(NVARCHAR,LA.LeaveDateTo,106) AS ''To''
											   ,CASE WHEN LA.FromLeaveSessionId = @SecondHalfLeaveSessionId AND LA.ToLeaveSessionId = @FirstHalfLeaveSessionId 
											         THEN DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1 - 1
													 WHEN LA.FromLeaveSessionId = @SecondHalfLeaveSessionId
											         THEN DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1 - 0.5
													 WHEN LA.ToLeaveSessionId = @FirstHalfLeaveSessionId
											         THEN DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1 - 0.5
												 ELSE DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1
												END AS ''Days''
											   ,LA.LeaveReason AS ''Reason''
											   ,CONVERT(NVARCHAR,LA.LeaveAppliedDate,106) AS ''Applied Date''
											   ,LS.LeaveStatusName AS ''Leave Status''
										FROM LeaveApplication LA
										     INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
										     INNER JOIN [User] U ON U.Id = LA.UserId
														AND (LA.IsDeleted = 0 OR LA.IsDeleted IS NULL) AND LA.InActiveDateTime IS NULL
											INNER JOIN Employee E ON E.UserId = U.Id '
					
			 IF(@IsActiveEmployeesOnly =1)
				SET  @SqlQuery = @SqlQuery + ' AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL '
					
		     SET  @SqlQuery = @SqlQuery + ' INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                                   AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	                               AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                                       AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
											INNER JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId
										WHERE U.CompanyId = @CompanyId
										      AND LA.LeaveDateFrom <= @Date
											  AND LA.LeaveDateTo >= @Date'
		
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY [Name]'

		EXEC SP_EXECUTESQL @FinalSql,
		N'@CompanyId UNIQUEIDENTIFIER
		  ,@Date DATETIME
		  ,@FirstHalfLeaveSessionId UNIQUEIDENTIFIER
		  ,@SecondHalfLeaveSessionId UNIQUEIDENTIFIER
		  ,@EntityId UNIQUEIDENTIFIER
		  ,@OperationsPerformedBy UNIQUEIDENTIFIER'
		  ,@CompanyId
		  ,@Date
		  ,@FirstHalfLeaveSessionId
		  ,@SecondHalfLeaveSessionId
		  ,@EntityId
		  ,@OperationsPerformedBy

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
GO