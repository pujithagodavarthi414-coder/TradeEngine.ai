-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-04-20 00:00:00.000'
-- Purpose      To Get Marriage Anniversary Report
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_MarriageAnniversaryReport] @OperationsPerformedBy = 'CB900830-54EA-4C70-80E1-7F8A453F2BF5'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_MarriageAnniversaryReport]
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

			IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
			
			IF(@DateFrom IS NULL) SET @DateFrom = DATEADD(DAY,1,EOMONTH(GETDATE(),-1))
			
			IF(@DateTo IS NULL) SET @DateTo = EOMONTH(GETDATE())

			IF(@ColumnString IS NULL OR @ColumnString = '') SET @ColumnString = '[Employee Number],[Name],[Mobile No],Email,[Marriage Date]'

			DECLARE @SqlQuery NVARCHAR(MAX) = '('

			SET @SqlQuery = @SqlQuery + 'SELECT E.EmployeeNumber AS ''Employee Number''
			       ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
				   ,U.MobileNo AS ''Mobile No''
			       ,U.UserName AS Email
				   ,CONVERT(VARCHAR,E.MarriageDate,106) AS ''Marriage Date''
				   ,E.MarriageDate
			FROM Employee E
			     INNER JOIN [User] U ON U.Id = E.UserId
				            AND U.IsActive = 1 AND U.InActiveDateTime IS NULL 
							AND E.InActiveDateTime IS NULL
				 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                	    AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                            AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			WHERE U.CompanyId = @CompanyId
			      AND (DATEPART(MONTH,E.MarriageDate) > DATEPART(MONTH,@DateFrom) 
				       OR (DATEPART(MONTH,E.MarriageDate) = DATEPART(MONTH,@DateFrom) AND DATEPART(DAY,E.MarriageDate) >= DATEPART(DAY,@DateFrom)))
			      AND (DATEPART(MONTH,E.MarriageDate) < DATEPART(MONTH,@DateTo) 
				       OR (DATEPART(MONTH,E.MarriageDate) = DATEPART(MONTH,@DateTo) AND DATEPART(DAY,E.MarriageDate) <= DATEPART(DAY,@DateTo)))'
		
		SET @SqlQuery = @SqlQuery + ') InnerSql'

		DECLARE @FinalSql NVARCHAR(MAX) = 'SELECT ' + @ColumnString + '  FROM ' + @SqlQuery + ' ORDER BY DATEPART(MONTH,MarriageDate) ASC,DATEPART(DAY,MarriageDate) ASC'

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