-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-16 00:00:00.000'
-- Purpose      To Get Leaves Report By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
------------------------------------------------------------------------------- 
--EXEC [dbo].[USP_GetLeavesReport_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@Year='2020',@PageSize=100
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLeavesReport_New]
(
    @Year INT,
    @BranchId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@PageNumber INT = 1,
    @PageSize INT = 10,
    @SearchText VARCHAR(500) = NULL,
    @SortBy NVARCHAR(250) = NULL,
    @EntityId UNIQUEIDENTIFIER = NULL,
    @SortDirection NVARCHAR(50) = NULL 
)
AS
BEGIN
SET NOCOUNT ON 
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

          DECLARE @DateFrom DATETIME

          DECLARE @DateTo DATETIME

          DECLARE @CurrentDate DATETIME
		  
		  IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
     IF (@HavePermission = '1')
     BEGIN

	      IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')
          BEGIN

          SET @OperationsPerformedBy = NULL

          END

		  IF(@BranchId = '00000000-0000-0000-0000-000000000000')
          BEGIN
	      
          SET @BranchId = NULL
	      
          END
	      
	      IF (@OperationsPerformedBy IS NOT NULL)
          BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          END
          
          SELECT @DateFrom = CAST(@Year AS VARCHAR(4)) + '-' + '01' + '-' + '01', @DateTo = CAST(@Year AS VARCHAR(4)) + '-' + '12' + '-' + '31'
          
          SELECT @CurrentDate = GETUTCDATE()
          
          IF(@CurrentDate > @DateTo)
		  BEGIN

              SELECT @CurrentDate = @DateTo

		  END
          ELSE
		  BEGIN

              SELECT @CurrentDate = @CurrentDate

          END

	      
	      IF(@SortDirection IS NULL)
	      BEGIN
	      
	       	  SET @SortDirection = 'ASC'
	      
	      END
	      
	      DECLARE @OrderByColumn NVARCHAR(250) 
	      
	      IF(@SortBy IS NULL)
	      BEGIN
	      
	      	   SET @SortBy = 'EmployeeName'
	      
	      END
	      ELSE
	      BEGIN
	      
	      	   SET @SortBy = @SortBy
	      
	      END
		  
		  SET @SearchText = '%'+ @SearchText +'%'
		  
		  CREATE TABLE #FinancialDates(
										UserId UNIQUEIDENTIFIER,
										DateFrom DATE,
										DateTo DATE
		                              )
			
		  INSERT INTO #FinancialDates(UserId)
		  SELECT Id FROM [User] WHERE CompanyId = @CompanyId AND IsActive = 1

		  UPDATE #FinancialDates SET DateFrom = (SELECT DateFrom FROM [dbo].[Ufn_GetFinancialYearDatesForleaves](UserId,@Year))
		                           ,DateTo = (SELECT DateTo FROM [dbo].[Ufn_GetFinancialYearDatesForleaves](UserId,@Year))

		  CREATE TABLE #Leaves(
								UserId UNIQUEIDENTIFIER,
								IsPaid BIT,
								[Count] FLOAT,
								MasterLeaveTypeId UNIQUEIDENTIFIER
		                      )
		 INSERT INTO #Leaves
		 SELECT LAP.UserId,ISNULl(LF.IsPaid,0),CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                ELSE 1 END END AS Cnt,LT.MasterLeaveTypeId FROM
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM MASTER..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id AND T.[Date] BETWEEN @DateFrom AND @DateTo
					JOIN #FinancialDates FYD ON FYD.UserId = LAP.UserId AND T.[Date] BETWEEN FYD.DateFrom AND FYD.DateTo
					JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsApproved = 1
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.InActiveDateTime IS NULL
					JOIN LeaveFrequency LF ON LF.LeaveTypeId = LT.Id AND T.[Date] BETWEEN LF.DateFrom AND LF.DateTo AND LF.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL AND H.[Date] BETWEEN @DateFrom AND @DateTo

          
		  SELECT UserId
		         ,EmployeeName
				 ,EmployeeProfileImage
				 ,EmployeeId
				 ,DateOfJoining
				 ,BranchName
				 ,TotalLeaves
				 ,EligibleLeaves
				 ,ROUND(EligibleLeavesYTD,1) EligibleLeavesYTD
				 ,LeavesTaken
				 ,OnsiteLeaves
				 ,WorkFromHomeLeaves
				 ,UnplannedLeaves
				 ,UnpaidLeaves
				 ,PaidLeaves
				 ,TotalCount
		  FROM
		  (
			  SELECT E.UserId, 
			         FirstName + ' ' + ISNULL(SurName,'') EmployeeName, 
			         ProfileImage EmployeeProfileImage, 
			         EmployeeNumber EmployeeId, 
					 CONVERT(DATE,J.[JoinedDate]) DateOfJoining,
			         B.BranchName AS BranchName,
					 [dbo].[Ufn_GetAllApplicableLeavesOfAnEmployee](U.Id,@Year,1) AS EligibleLeaves,
					 [dbo].[Ufn_GetAllApplicableLeavesOfAnEmployee](U.Id,@Year,NULL) AS TotalLeaves,
			         [dbo].[Ufn_GetEmployeeYTDLeaves](U.Id,@Year,NULL) EligibleLeavesYTD, 
			         ISNULL(LAInner.LeavesTaken,0) LeavesTaken, 
			         ISNULL(LAOnsiteInner.OnsiteLeaves,0) AS OnsiteLeaves,
			         ISNULL(LAWorkfromhomeInner.WorkFromHomeLeaves,0) AS WorkFromHomeLeaves,
			         ISNULL(LAUnplannedInner.UnplannedLeaves,0) AS UnplannedLeaves,
			         ISNULL(Unpaid.UnpaidLeaves,0) UnpaidLeaves,
					 ISNULL(Paid.PaidLeaves,0) PaidLeaves,
					 TotalCount = COUNT(1) OVER()
			  FROM [User] U WITH (NOLOCK)
			       INNER JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id AND U.CompanyId = @CompanyId
				         AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	               INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
			                  AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
	                          AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                          AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                              AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
				   INNER JOIN Branch B ON B.Id = EB.BranchId
			       JOIN Job J ON J.EmployeeId = E.Id AND ((J.[JoinedDate] >= @DateFrom AND J.[JoinedDate] <= @CurrentDate) OR @DateFrom >= J.[JoinedDate])
			            AND (@DateFrom <= J.InActiveDateTime OR J.InActiveDateTime IS NULL)
			       LEFT JOIN EmployeeLeaveAllowance ELA WITH (NOLOCK) ON ELA.EmployeeId = E.Id AND E.InActiveDateTime IS NULL 
			       LEFT JOIN (SELECT UserId,ISNULL(SUM([Count]),0) AS LeavesTaken
				              FROM #Leaves 
							  GROUP BY UserId
			                  ) LAInner ON LAInner.UserId = E.UserId
			       LEFT JOIN (SELECT UserId,ISNULL(SUM([Count]),0) AS OnsiteLeaves
				              FROM #Leaves L 
							  JOIN MasterLeaveType MLT ON MLT.IsOnSite = 1 AND L.MasterLeaveTypeId = MLT.Id
			                  GROUP BY UserId) LAOnsiteInner ON LAOnsiteInner.UserId = E.UserId
			       LEFT JOIN (SELECT UserId,ISNULL(SUM([Count]),0) AS WorkFromHomeLeaves
				              FROM #Leaves L 
							  JOIN MasterLeaveType MLT ON MLT.IsWorkFromHome = 1 AND L.MasterLeaveTypeId = MLT.Id
			                  GROUP BY UserId) LAWorkfromhomeInner ON LAWorkfromhomeInner.UserId = E.UserId
			       LEFT JOIN (SELECT UserId,ISNULL(SUM([Count]),0) AS UnplannedLeaves
				              FROM #Leaves L 
							  JOIN MasterLeaveType MLT ON (MLT.IsWithoutIntimation = 1 OR MLT.IsSickLeave = 1) AND L.MasterLeaveTypeId = MLT.Id
			                  GROUP BY UserId) LAUnplannedInner ON LAUnplannedInner.UserId = E.UserId
				  LEFT JOIN (SELECT UserId,ISNULL(SUM([Count]),0) AS UnPaidLeaves FROM #Leaves WHERE IsPaid = 0 GROUP BY UserId) UnPaid ON UnPaid.UserId = E.UserId
				  LEFT JOIN (SELECT UserId,ISNULL(SUM([Count]),0) AS PaidLeaves FROM #Leaves WHERE IsPaid = 1 GROUP BY UserId) Paid ON Paid.UserId = E.UserId
			) T 
			WHERE (@SearchText IS NULL 
		            OR BranchName LIKE @SearchText
		            OR EmployeeId LIKE @SearchText
		            OR DateOfJoining LIKE @SearchText
		            OR EligibleLeaves LIKE @SearchText
					OR EmployeeName LIKE @SearchText
		            OR LeavesTaken LIKE @SearchText
					OR WorkFromHomeLeaves LIKE @SearchText
					OR UnplannedLeaves LIKE @SearchText
					OR EligibleLeavesYTD LIKE @SearchText)
		 ORDER BY EmployeeName,
		   CASE WHEN @SortDirection = 'ASC' THEN
		        CASE WHEN @SortBy = 'EmployeeName' THEN EmployeeName
		             WHEN @SortBy = 'EmployeeId' THEN CAST(EmployeeId AS SQL_VARIANT) 
		             WHEN @SortBy = 'DateOfJoining' THEN CAST(DateOfJoining AS SQL_VARIANT) 
		             WHEN @SortBy = 'BranchName' THEN BranchName
				     WHEN @SortBy = 'EligibleLeaves' THEN  CAST(EligibleLeaves AS SQL_VARIANT)  
					 WHEN @SortBy = 'EligibleLeavesYTD' THEN CAST(EligibleLeavesYTD AS SQL_VARIANT)
					 WHEN @SortBy = 'LeavesTaken' THEN CAST(LeavesTaken AS SQL_VARIANT)
					 WHEN @SortBy = 'TotalLeaves' THEN CAST(TotalLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'OnsiteLeaves' THEN CAST(OnsiteLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'WorkFromHomeLeaves' THEN CAST(WorkFromHomeLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'UnplannedLeaves' THEN CAST(UnplannedLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'UnpaidLeaves' THEN CAST(UnpaidLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'PaidLeaves' THEN CAST(PaidLeaves AS SQL_VARIANT)
		        END 
		   END ASC,
	       CASE WHEN @SortDirection = 'DESC' THEN
	             CASE WHEN @SortBy = 'EmployeeName' THEN EmployeeName
		             WHEN @SortBy = 'EmployeeId' THEN CAST(EmployeeId AS SQL_VARIANT) 
		             WHEN @SortBy = 'DateOfJoining' THEN CAST(DateOfJoining AS SQL_VARIANT) 
		             WHEN @SortBy = 'BranchName' THEN BranchName
				     WHEN @SortBy = 'EligibleLeaves' THEN  CAST(EligibleLeaves AS SQL_VARIANT)  
					 WHEN @SortBy = 'TotalLeaves' THEN CAST(TotalLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'EligibleLeavesYTD' THEN CAST(EligibleLeavesYTD AS SQL_VARIANT)
					 WHEN @SortBy = 'LeavesTaken' THEN CAST(LeavesTaken AS SQL_VARIANT)
					 WHEN @SortBy = 'OnsiteLeaves' THEN CAST(OnsiteLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'WorkFromHomeLeaves' THEN CAST(WorkFromHomeLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'UnplannedLeaves' THEN CAST(UnplannedLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'UnpaidLeaves' THEN CAST(UnpaidLeaves AS SQL_VARIANT)
					 WHEN @SortBy = 'PaidLeaves' THEN CAST(PaidLeaves AS SQL_VARIANT)
		        END 
	 	   END DESC
		 OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
		       
         FETCH NEXT @PageSize ROWS ONLY
		 
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