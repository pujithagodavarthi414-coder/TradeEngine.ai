-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Yesr Wise Leave Summary Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_YearWiseLeaveSummaryReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_YearWiseLeaveSummaryReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@Year DATETIME = NULL
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
			
			IF(@ColumnString IS NULL OR @ColumnString = '') 
			
			SET @ColumnString = '[Employee Name],[Employee Number],[Date Of Joining],[Opening Leave Balance],[Granted],[Availed],[Closing Leave Balance]'

			IF(@Year IS NULL) SET @Year = GETDATE()

			DECLARE @YearValue INT = DATEPART(YEAR,@Year)

			DECLARE @StartDate DATETIME,@EndDate DATETIME

			SELECT @StartDate = DATEFROMPARTS(@YearValue,1,1),@EndDate = DATEFROMPARTS(@YearValue,12,31) 

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT T.*
			                                    --,CASE WHEN ([Granted] - [Availed]) < 0 THEN 0 ELSE ([Granted] - [Availed]) END AS [Closing Leave Balance]
			                                    ,0 AS [Closing Leave Balance]
			                             FROM
										 (
			                             SELECT U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Employee Name]
										        ,E.EmployeeNumber AS [Employee Number]
												,CONVERT(VARCHAR,J.JoinedDate,106) AS [Date Of Joining]
												,0 AS [Opening Leave Balance]
			                                    ,ISNULL(EL.LeavesTaken,0) AS [Availed]
			                                    ,ISNULL([dbo].[Ufn_GetAllApplicableLeavesOfAnEmployeeForPayRoll](U.Id,@StartDate,@EndDate,0),0) AS [Granted]
										        FROM [dbo].[Ufn_GetLeavesOfAnEmployeeBasedOnPeriod](@OperationsPerformedby,NULL,@StartDate,@EndDate) EL
										        INNER JOIN Employee E On E.Id = EL.EmployeeId
										        INNER JOIN [User] U ON U.Id = E.UserId
										        INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                                       AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                                                       AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))'
			
			IF(@EntityId IS NOT NULL) SET @SqlQuery = @SqlQuery + ' AND (EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL)) '
			
			IF(@IsActiveEmployeesOnly =1)
				SET  @SqlQuery = @SqlQuery + ' AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InActiveDateTime IS NULL '

			SET @SqlQuery = @SqlQuery + ' LEFT JOIN Job J ON J.EmployeeId = E.Id
							                               AND J.InActiveDateTime IS NULL
												WHERE U.CompanyId = @CompanyId ) T'
										        
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY [Employee Name]'

		PRINT @FinalSql

		EXEC SP_EXECUTESQL @FinalSql,
		N'@CompanyId UNIQUEIDENTIFIER
		  ,@Year DATETIME
		  ,@EntityId UNIQUEIDENTIFIER
		  ,@OperationsPerformedBy UNIQUEIDENTIFIER
		  ,@YearValue INT
		  ,@StartDate DATETIME
		  ,@EndDate DATETIME'
		  ,@CompanyId
		  ,@Year
		  ,@EntityId
		  ,@OperationsPerformedBy
		  ,@YearValue
		  ,@StartDate
		  ,@EndDate

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