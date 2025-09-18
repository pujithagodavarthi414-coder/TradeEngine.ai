CREATE PROCEDURE [dbo].[USP_UpsertRosterPlan]
(
 @RequestId UNIQUEIDENTIFIER,
 @RosterPlans NVARCHAR(max),
 @StartDate DATETIME,
 @EndDate DATETIME,
 @BranchId UNIQUEIDENTIFIER,
 @IsApprove BIT,
 @IsSubmitted BIT,
 @IsTemplate BIT,
 @TimeStamp TIMESTAMP = NULL,
 @RostName NVARCHAR(250) = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @IsArchived BIT = NULL,
 @BreakMins DECIMAL = NULL,
 @Budget DECIMAL = null
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF(@RequestId = '00000000-0000-0000-0000-000000000000') SET @RequestId = NULL

			IF(@RequestId IS NULL)
			BEGIN

				RAISERROR(50011,16,1,'Request Id')

			END
			
			ELSE IF (@RosterPlans IS NULL)
			BEGIN
				
				RAISERROR(50011,16,1,'Plans')

			END
			ELSE
			BEGIN
			
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
				CREATE TABLE #Plans 
				(
					PlanId UNIQUEIDENTIFIER,
					SolutionId UNIQUEIDENTIFIER,
					PlanDate DATETIME,
					DepartmentId UNIQUEIDENTIFIER,
					DepartmentName NVARCHAR(250),
					ShiftId UNIQUEIDENTIFIER,
					ShiftName NVARCHAR(250),
					EmployeeId UNIQUEIDENTIFIER,
					EmployeeName NVARCHAR(250),
					TotalRate DECIMAL(14,2),
					CurrencyCode NVARCHAR(50),
					FromTime TIME,
					ToTime TIME,
					IsNew BIT
				)
				IF(@RosterPlans IS NOT NULL AND @RosterPlans != 'null')
				INSERT INTO #Plans
				SELECT *
				FROM OPENJSON(@RosterPlans)
				WITH (PlanId UNIQUEIDENTIFIER,
					SolutionId UNIQUEIDENTIFIER,
					PlanDate DATETIME,
					DepartmentId UNIQUEIDENTIFIER,
					DepartmentName NVARCHAR(250),
					ShiftId UNIQUEIDENTIFIER,
					ShiftName NVARCHAR(250),
					EmployeeId UNIQUEIDENTIFIER,
					EmployeeName NVARCHAR(250),
					TotalRate DECIMAL(14,2),
					CurrencyCode NVARCHAR(50),
					FromTime TIME,
					ToTime TIME,
					IsNew BIT)

				DECLARE @CurrentDate datetime = GETDATE();

				IF EXISTS(
					SELECT * FROM [dbo].[RosterRequest] AS RR 
					INNER JOIN RosterActualPlan RAP ON RAP.RequestId = RR.Id
					INNER JOIN #Plans p ON p.EmployeeId = rap.PlannedEmployeeId AND CONVERT(DATE, p.PlanDate) = CONVERT(DATE, rap.PlanDate)
					WHERE RR.CompanyId = @CompanyId 
						AND CONVERT(DATE, RAP.PlanDate) BETWEEN CONVERT(DATE, @StartDate) AND CONVERT(DATE, @EndDate)
						AND RR.InActiveDateTime IS NULL AND StatusId IN (SELECT Id fROM RosterPlanStatus WHERE StatusName NOT IN ('Draft'))
						AND (@RequestId IS NULL OR RR.ID<>@RequestId)
				 ) and (@IsApprove = 1 OR @IsSubmitted = 1)
				 BEGIN
					RAISERROR(50001,16,1,'RosterEmployee')
				 END

				DECLARE @StatusId UNIQUEIDENTIFIER
				IF(@IsApprove = 1)
					SELECT @StatusId = Id from RosterPlanStatus where StatusName = 'Approved'
				ELSE if(@IsSubmitted = 1)
					SELECT @StatusId = Id from RosterPlanStatus where StatusName = 'Submitted'
				ELSE 
				BEGIN
					IF EXISTS(SELECT * FROM RosterRequest WHERE id = @RequestId and StatusId = (SELECT Id FROM RosterPlanStatus WHERE StatusName = 'Submitted'))
						SELECT @StatusId = Id from RosterPlanStatus where StatusName = 'Submitted'
					ELSE
						SELECT @StatusId = Id from RosterPlanStatus where StatusName = 'Draft'
				END

				IF(@IsArchived IS NOT NULL)
				BEGIN
					UPDATE RosterRequest SET InActiveDateTime =  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END WHERE Id = @RequestId
				END
				ELSE
					BEGIN
				
					IF(NOT EXISTS (SELECT * FROM RosterRequest WHERE Id = @RequestId))
					BEGIN
				
						INSERT INTO RosterRequest(Id, RosterName, RequiredFromDate, RequiredToDate, 
							RequiredEmployee, RequiredBudget, IncludeHolidays, IncludeWeekends, TotalWorkingDays, TotalWorkingHours, 
							StatusId, RosterShiftDetails, RosterDepartmentDetails, RosterAdhocRequirement, CreatedByUserId, CreatedDateTime, 
							CompanyId, IsTemplate, RequiredBreakMins, BranchId )
						SELECT @RequestId, @RostName, @StartDate, @EndDate,
							COUNT(DISTINCT EmployeeId), @Budget, 1, 1, COUNT(DISTINCT PlanDate), AVG(IIF( CONVERT(DATETIME, ToTime) < CONVERT(DATETIME, FromTime), 
							DATEDIFF(MINUTE, CONVERT(DATETIME, FromTime), DATEADD(DAY,1, CONVERT(DATETIME, ToTime))) , 
							DATEDIFF(MINUTE, CONVERT(DATETIME, FromTime), CONVERT(DATETIME, ToTime))) / 60), 
						@StatusId, NULL, NULL, NULL, @OperationsPerformedBy,@CurrentDate, @CompanyId, @IsTemplate, @BreakMins, @BranchId FROM #Plans B
					END
				
					INSERT INTO RosterActualPlan( Id, RequestId, SolutionId, PlanDate,  CurrencyCode, DepartmentId, ShiftId, PlannedEmployeeId, PlannedFromTime, PlannedToTime, PlannedRate, PlanStatusId, CreatedByUserId, CreatedDateTime, CompanyId)
					SELECT PlanId, @RequestId, SolutionId, PlanDate, C.Id, DepartmentId, ShiftId, EmployeeId, FromTime, ToTime, TotalRate, @StatusId, @OperationsPerformedBy, @CurrentDate, @CompanyId FROM #Plans P
					LEFT JOIN Currency C ON C.CurrencyCode = P.CurrencyCode AND CompanyId = @CompanyId
					WHERE PlanId NOT IN (SELECT Id FROM RosterActualPlan) AND FromTime IS NOT NULL
				
					UPDATE R SET  R.PlanDate = P.PlanDate,
								  R.DepartmentId = P.DepartmentId,
								  R.ShiftId = P.ShiftId,
								  PlannedEmployeeId = P.EmployeeId,
								  PlannedFromTime = FromTime,
								  PlannedToTime = ToTime,
								  PlanStatusId = @StatusId,
								  PlannedRate = p.TotalRate,
								  R.UpdatedByUserId = @OperationsPerformedBy,
								  R.UpdatedDateTime = @CurrentDate,
								  R.ActualEmployeeId = CASE WHEN @IsApprove = 1 THEN P.EmployeeId  WHEN (@IsApprove = 0 OR @IsApprove IS NULL) THEN NULL END
					FROM RosterActualPlan R
					INNER JOIN #Plans P ON P.PlanId = R.Id
					LEFT JOIN Currency C ON C.CurrencyCode = P.CurrencyCode AND C.CompanyId = @CompanyId
					WHERE R.CompanyId = @CompanyId AND FromTime IS NOT NULL

					
					UPDATE R SET R.InActiveDateTime = GETUTCDATE()
					FROM RosterActualPlan R
					LEFT JOIN #Plans P ON P.PlanId = R.Id
					WHERE r.RequestId = @RequestId AND P.PlanId IS NULL

					INSERT INTO RosterRequestHistory (id, RequestId,RosterName,RequiredFromDate,RequiredToDate,RequiredEmployee,RequiredBudget,RequiredBreakMins,BranchId,IncludeHolidays,IncludeWeekends,TotalWorkingDays,TotalWorkingHours,RosterShiftDetails,RosterDepartmentDetails,RosterAdhocRequirement,StatusId,IsTemplate,CompanyId,InActiveDateTime,HistoryDateTime)
					SELECT NEWID(), Id,RosterName,RequiredFromDate,RequiredToDate,RequiredEmployee,RequiredBudget,RequiredBreakMins,BranchId,IncludeHolidays,IncludeWeekends,TotalWorkingDays,TotalWorkingHours,RosterShiftDetails,RosterDepartmentDetails,RosterAdhocRequirement,StatusId,IsTemplate,CompanyId,InActiveDateTime, GETUTCDATE() From RosterRequest WHERE Id = 'BCCE2B48-9EDA-4A68-B3CB-027FA686B8B6'

					INSERT INTO RosterActualPlanHistory(Id, RosterActualPlanId, RequestId,SolutionId,PlanDate,DepartmentId,ShiftId,CurrencyCode,PlannedEmployeeId,PlannedRate,PlannedFromTime,PlannedToTime,ActualEmployeeId,ActualRate,ActualFromTime,ActualToTime,PlanStatusId,CompanyId,InActiveDateTime,HistoryDateTime)
					SELECT NEWID(), R.Id, RequestId,R.SolutionId,R.PlanDate,R.DepartmentId,R.ShiftId,R.CurrencyCode,PlannedEmployeeId,PlannedRate,PlannedFromTime,PlannedToTime,ActualEmployeeId,ActualRate,ActualFromTime,ActualToTime,PlanStatusId,CompanyId,InActiveDateTime, GETUTCDATE() 
					FROM RosterActualPlan R
					LEFT JOIN #Plans P ON P.PlanId = R.Id
					WHERE r.RequestId = @RequestId AND P.PlanId IS NULL
					UNION
					SELECT NEWID(), R.Id, RequestId,R.SolutionId,R.PlanDate,R.DepartmentId,R.ShiftId,R.CurrencyCode,PlannedEmployeeId,PlannedRate,PlannedFromTime,PlannedToTime,ActualEmployeeId,ActualRate,ActualFromTime,ActualToTime,PlanStatusId,R.CompanyId,R.InActiveDateTime, GETUTCDATE() 
					FROM RosterActualPlan R
					INNER JOIN #Plans P ON P.PlanId = R.Id
					LEFT JOIN Currency C ON C.CurrencyCode = P.CurrencyCode AND C.CompanyId = @CompanyId
					WHERE R.CompanyId = @CompanyId

					DECLARE @MinDate DATETIME, @MaxDate DATETIME, @NoofEmployee int, @Rate float
					SELECT @NoofEmployee = count(distinct EmployeeId) FROM #Plans
					UPDATE RosterRequest SET StatusId = @StatusId,
											 IsTemplate = @IsTemplate,
											 RequiredFromDate = @StartDate,
											 RequiredToDate = @EndDate,
											 RequiredEmployee = @NoofEmployee,
											 RequiredBudget = @budget
					WHERE Id = @RequestId

				END

				SELECT Id FROM RosterRequest WHERE Id = @RequestId
			END
		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END