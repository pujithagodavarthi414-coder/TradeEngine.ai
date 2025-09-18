-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-09 00:00:00.000'
-- Purpose      To Get the Required Productivity and Existing productivity By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEveryDayTargetStatusReport] @OperationsPerformedBy='D8F3C3DF-09F2-4447-91C7-56A9BFE9A428'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEveryDayTargetStatusReport]
(
   @EntityId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
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
		  
          DECLARE @ApplicableUsersCount INT
           
		  CREATE TABLE #ApplicableUsers
		  (
				UserId UNIQUEIDENTIFIER
		  )

		    INSERT INTO #ApplicableUsers
			SELECT U.Id
			FROM [User] U WITH (NOLOCK)
				 INNER JOIN [Employee] E ON E.UserId = U.Id 
	             INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                        AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                            AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			     INNER JOIN UserRole UR ON UR.UserId = U.Id AND UR.[InactiveDateTime] IS NULL 
		         INNER JOIN [Role] R ON R.Id = UR.RoleId
		                  AND U.InActiveDateTime IS NULL
			              AND U.IsActive = 1 AND U.CompanyId = @CompanyId AND R.IsDeveloper = 1 AND R.InactiveDateTime IS NULL
			GROUP BY U.Id

		  SELECT @ApplicableUsersCount = COUNT(1) FROM #ApplicableUsers

          DECLARE @PresentDate DATETIME = CONVERT(DATE, GETDATE())

          DECLARE @Start_Date DATETIME = DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)

          --DECLARE @End_Date DATETIME = EOMONTH(@PresentDate)
	      
          DECLARE @NoOfHolidaysToDate INT,@NoOfWeekendsToDate INT

          DECLARE @TotalDaysToDate INT = DATEDIFF(DAY,@Start_Date,@PresentDate)
	      
          SELECT @NoOfHolidaysToDate = COUNT(1) FROM Holiday WHERE [Date] >= @Start_Date AND [Date] <= @PresentDate
		                                                       AND InActiveDateTime IS NULL AND CompanyId = @CompanyId;
	
	      WITH Date_Result(DateofWeek) AS (
          SELECT @Start_Date  fecha
          UNION ALL
          SELECT DATEADD(day, 1, dateofweek) Dateofweek
          FROM Date_Result
          WHERE DateofWeek < @PresentDate)
          SELECT @NoOfWeekendsToDate = COUNT(Dateofweek) FROM Date_result WHERE DATEPART(dw,Dateofweek)in (1,7)
          OPTION (MaxRecursion 0)

          DECLARE @RequiredProductivity DECIMAL(8,2) = (@TotalDaysToDate - @NoOfHolidaysToDate - @NoOfWeekendsToDate) * @ApplicableUsersCount * 8

          DECLARE @ExistingProductivity DECIMAL(8,2) = (SELECT SUM(EstimatedTime) 
		                                                FROM [dbo].[Ufn_ProductivityIndexBasedOnuserId](@Start_Date,@PresentDate,null,@CompanyId) PID
														INNER JOIN #ApplicableUsers AU ON AU.UserId = PID.UserId)
          SELECT ISNULL(@ExistingProductivity,0) ExistingProductivity,@RequiredProductivity RequiredProductivity

	  END
	 -- ELSE
  --    BEGIN
              
		--RAISERROR (@HavePermission,11, 1)
                    
  --   END 
	END TRY 
	BEGIN CATCH 
		
		  EXEC USP_GetErrorInformation

	END CATCH

END
GO