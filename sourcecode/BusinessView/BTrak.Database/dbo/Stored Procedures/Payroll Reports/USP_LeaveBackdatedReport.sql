-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Leave Backdated Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_LeaveBackdatedReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_LeaveBackdatedReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@DateFrom DATETIME = NULL
	,@DateTo DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
	,@IsActiveEmployeesOnly BIT = 0
	,@ColumnString NVARCHAR(1500) = NULL
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
			
			IF(@DateFrom IS NULL) SET @DateFrom = DATEADD(DAY,1,EOMONTH(GETDATE(),-3))
			
			IF(@DateTo IS NULL) SET @DateTo = EOMONTH(GETDATE())

			IF(@ColumnString IS NULL OR @ColumnString = '') SET @ColumnString = '[Employee Number],[Name],[Leave Type],[From],[To],[Days],[Reason],[Applied Date],[Approved Date],[Aprrover]'

			DECLARE @LeaveApproveStatusId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveStatus WHERE CompanyId = @CompanyId AND IsApproved = 1)
			
			DECLARE @FirstHalfLeaveSessionId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsFirstHalf = 1)
			
			DECLARE @SecondHalfLeaveSessionId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE CompanyId = @CompanyId AND IsSecondHalf = 1)

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT E.EmployeeNumber AS ''Employee Number''
										       ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS ''Name''
											   ,LT.LeaveTypeName AS ''Leave Type''
											   ,CONVERT(NVARCHAR,LA.LeaveDateFrom,106) AS ''From''
											   ,CONVERT(NVARCHAR,LA.LeaveDateTo,106) AS ''To''
											   ,CASE WHEN LA.FromLeaveSessionId = @SecondHalfLeaveSessionId 
											              AND LA.ToLeaveSessionId = @FirstHalfLeaveSessionId 
											         THEN DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1 - 1
													 WHEN LA.FromLeaveSessionId = @SecondHalfLeaveSessionId
											         THEN DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1 - 0.5
													 WHEN LA.ToLeaveSessionId = @FirstHalfLeaveSessionId
											         THEN DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1 - 0.5
												 ELSE DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) + 1
												END AS ''Days''
											   ,LA.LeaveReason AS ''Reason''
											   ,CONVERT(NVARCHAR,LA.LeaveAppliedDate,106) AS ''Applied Date''
											   ,CONVERT(NVARCHAR,LA.UpdatedDateTime,106) AS ''Approved Date''
										       ,STUFF((SELECT '','' + U.FirstName + '' '' + ISNULL(U.SurName,'''')
											           FROM LeaveApplicationStatusSetHistory LASSH
																       INNER JOIN [User] U ON U.Id = LASSH.LeaveStuatusSetByUserId 
																  WHERE LASSH.LeaveStatusId = @LeaveApproveStatusId
																        AND LASSH.LeaveApplicationId = LA.Id
										                          ORDER BY U.FirstName
															FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''') AS ''Aprrover''
										FROM LeaveApplication LA
										     INNER JOIN [User] U ON U.Id = LA.UserId
														AND (LA.IsDeleted = 0 OR LA.IsDeleted IS NULL) AND LA.InActiveDateTime IS NULL
											INNER JOIN Employee E ON E.UserId = U.Id '
			
			IF(@IsActiveEmployeesOnly =1)
				SET  @SqlQuery = @SqlQuery + ' AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL '	
				
			SET  @SqlQuery = @SqlQuery + ' INNER JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId
													   AND LA.OverallLeaveStatusId = @LeaveApproveStatusId
											INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                                   AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	                               AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                                       AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
											LEFT JOIN LeaveSession FLS ON FLS.Id = LA.FromLeaveSessionId
											          AND FLS.InactiveDateTime IS NULL
											LEFT JOIN LeaveSession TLS ON TLS.Id = LA.ToLeaveSessionId
											          AND TLS.InactiveDateTime IS NULL
										WHERE U.CompanyId = @CompanyId
										      AND LA.LeaveDateFrom >= @DateFrom
											  AND LA.LeaveDateTo <= @DateTo
											  AND CONVERT(DATE,LA.LeaveAppliedDate) > LA.LeaveDateFrom'
		
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY [Name]'

		EXEC SP_EXECUTESQL @FinalSql,
		N'@CompanyId UNIQUEIDENTIFIER
		  ,@DateFrom DATETIME
		  ,@DateTo DATETIME
		  ,@LeaveApproveStatusId UNIQUEIDENTIFIER
		  ,@FirstHalfLeaveSessionId UNIQUEIDENTIFIER
		  ,@SecondHalfLeaveSessionId UNIQUEIDENTIFIER
		  ,@EntityId UNIQUEIDENTIFIER
		  ,@OperationsPerformedBy UNIQUEIDENTIFIER'
		  ,@CompanyId
		  ,@DateFrom
		  ,@DateTo
		  ,@LeaveApproveStatusId
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