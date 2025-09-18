-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Joining Anniversary Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_JoiningAnniversaryReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_JoiningAnniversaryReport]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@DateFrom DATETIME = NULL
	,@DateTo DATETIME = NULL
	,@EntityId UNIQUEIDENTIFIER = NULL
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

			IF(@DateFrom IS NULL) SET @DateFrom = DATEADD(DAY,1,EOMONTH(GETDATE(),-1))
			
			IF(@DateTo IS NULL) SET @DateTo = EOMONTH(GETDATE())

			IF(@ColumnString IS NULL OR @ColumnString = '') SET @ColumnString = '[Employee Number],[Name],[Mobile No],Email,[Joining Date],[Experience]'
			
			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT E.EmployeeNumber AS ''Employee Number''
			       ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
				   ,U.MobileNo AS ''Mobile No''
			       ,U.UserName AS Email
				   ,CONVERT(VARCHAR,J.JoinedDate,106) AS ''Joining Date''
				   ,CONVERT(VARCHAR,(DATEDIFF(MONTH,J.JoinedDate,GETDATE())) / 12) + ''Y ''
				    + CONVERT(VARCHAR,(DATEDIFF(MONTH,J.JoinedDate,GETDATE()))%12) + ''M'' AS ''Experience''
				   ,J.JoinedDate
			FROM Employee E
			     INNER JOIN [User] U ON U.Id = E.UserId
				            AND U.IsActive = 1 AND U.InActiveDateTime IS NULL 
							AND E.InActiveDateTime IS NULL
				 INNER JOIN Job J ON J.EmployeeId = E.Id
							AND J.InActiveDateTime IS NULL
				 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                            AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			WHERE U.CompanyId = @CompanyId
			      AND (DATEPART(MONTH,J.JoinedDate) > DATEPART(MONTH,@DateFrom) 
				       OR (DATEPART(MONTH,J.JoinedDate) = DATEPART(MONTH,@DateFrom) AND DATEPART(DAY,J.JoinedDate) >= DATEPART(DAY,@DateFrom)))
			      AND (DATEPART(MONTH,J.JoinedDate) < DATEPART(MONTH,@DateTo) 
				       OR (DATEPART(MONTH,J.JoinedDate) = DATEPART(MONTH,@DateTo) AND DATEPART(DAY,J.JoinedDate) <= DATEPART(DAY,@DateTo)))'
		
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY DATEPART(MONTH,[JoinedDate]),DATEPART(DAY,[JoinedDate])'

		EXEC SP_EXECUTESQL @FinalSql,
		N'@CompanyId UNIQUEIDENTIFIER
		  ,@DateFrom DATETIME
		  ,@DateTo DATETIME
		  ,@EntityId UNIQUEIDENTIFIER
		  ,@OperationsPerformedBy UNIQUEIDENTIFIER'
		  ,@CompanyId
		  ,@DateFrom
		  ,@DateTo
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