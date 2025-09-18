-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-02-23 00:00:00.000'
-- Purpose      To save or update the Leaves
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertLeaves] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserId='127133F1-4427-4149-9DD6-B02E0E036971',
 --@LeaveReason='sick',@LeaveTypeId= 'F2785350-EF29-42E4-A7D5-7AC4FF086AD6',@LeaveDateFrom='2019-05-05',@LeaveDatetO='2019-05-06',@FromLeaveSessionId = '3C6F106A-160F-4644-86B8-6214123ACA0E'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertLeaves]
(
   @LeaveApplicationId UNIQUEIDENTIFIER = NULL,
   @UserId UNIQUEIDENTIFIER = NULL,
   @LeaveReason NVARCHAR(250) = NULL,
   @LeaveTypeId UNIQUEIDENTIFIER = NULL,
   @LeaveDateFrom DATETIME = NULL,
   @LeaveDateTo DATETIME = NULL,
   @FromLeaveSessionId UNIQUEIDENTIFIER = NULL,
   @ToLeaveSessionId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	  DECLARE @Currentdate DATETIME = GETDATE()

	  IF (@HavePermission = '1')
	  BEGIN

      IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

      IF (@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
      
      IF (@LeaveTypeId = '00000000-0000-0000-0000-000000000000') SET @LeaveTypeId = NULL

	  DECLARE @ShiftDateFrom DATETIME = '2018-01-01 00:00:00.000'

	  IF (@UserId IS NULL) SET @UserId = @OperationsPerformedBy

	  --IF((SELECT COUNT(1) FROM Employee E JOIN EmployeeShift ES ON E.UserId = @UserId AND E.Id = ES.EmployeeId AND ((ES.ActiveTo IS NULL AND ES.ActiveFrom <= @LeaveDateFrom) OR (ES.ActiveTo IS NOT NULL AND ES.ActiveFrom <= @LeaveDateFrom AND ES.ActiveTo >= @LeaveDateTo))) = 0)
	  --BEGIN

		 --  DECLARE @EmployeeId UNIQUEIDENTIFIER
		 --  DECLARE @ShiftTimingId UNIQUEIDENTIFIER

		 --  SELECT @EmployeeId = Id FROM Employee WHERE UserId = @UserId

		 --  SELECT @ShiftTimingId = (SELECT TOP 1 Id FROM ShiftTiming WHERE InActiveDateTime IS NULL AND BranchId = (SELECT BranchId FROM EmployeeBranch EB WHERE EmployeeId = @EmployeeId AND ((EB.ActiveTo IS NULL AND EB.ActiveFrom <= @LeaveDateFrom) OR (EB.ActiveTo IS NOT NULL AND EB.ActiveFrom <= @LeaveDateFrom AND EB.ActiveTo >= @LeaveDateTo))))
		   
		 --  IF(@ShiftTimingId IS NOT NULL)
		 --  BEGIN

			--INSERT INTO EmployeeShift(Id,ShiftTimingId,EmployeeId,ActiveFrom,CreatedByUserId,CreatedDateTime)
			--SELECT NEWID(),@ShiftTimingId,@EmployeeId,@ShiftDateFrom,@OperationsPerformedBy,@Currentdate

		 --  END

		 --  IF((SELECT COUNT(1) FROM Employee E JOIN EmployeeShift ES ON E.UserId = @UserId AND E.Id = ES.EmployeeId AND ((ES.ActiveTo IS NULL AND ES.ActiveFrom <= @LeaveDateFrom) OR (ES.ActiveTo IS NOT NULL AND ES.ActiveFrom <= @LeaveDateFrom AND ES.ActiveTo >= @LeaveDateTo))) = 0)
		 --  BEGIN

		 --   SELECT @ShiftTimingId = (SELECT TOP 1 Id FROM ShiftTiming WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL)
			
			-- IF(@ShiftTimingId IS NOT NULL)
		 --    BEGIN

			--	INSERT INTO EmployeeShift(Id,ShiftTimingId,EmployeeId,ActiveFrom,CreatedByUserId,CreatedDateTime)
			--	SELECT NEWID(),@ShiftTimingId,@EmployeeId,@ShiftDateFrom,@OperationsPerformedBy,@Currentdate

			--END

		 --  END

	  --END

	  DECLARE @UserName NVARCHAR(250) = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @UserId)

	  DECLARE @FirstHalfId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE IsFirstHalf = 1 AND CompanyId = @CompanyId)

	  --DECLARE @IsEditable BIT = (CASE WHEN ((SELECT OverallLeaveStatusId FROM LeaveApplication WHERE Id = @LeaveApplicationId) = (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId))
	  --                                   OR (SELECT LeaveDateFrom FROM LeaveApplication 
			--						  WHERE Id = @LeaveApplicationId) > CONVERT(DATE,GETDATE()) THEN 0 ELSE 1 END)

	  DECLARE @SecondHalfId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE IsSecondHalf = 1 AND CompanyId = @CompanyId)
      
	  DECLARE @FullDay UNIQUEIDENTIFIER = (SELECT Id FROM LeaveSession WHERE IsFullDay = 1 AND CompanyId = @CompanyId)

	  DECLARE @IntimatedDatefromOk BIT = (SELECT CASE WHEN ISNULL(NumberOfDaysToBeIntimated,0) > DATEDIFF(DAY,GETDATE(),@LeaveDateFrom)  THEN 1 ELSE 0 END
	                                             FROM LeaveFrequency WHERE @LeaveDateFrom BETWEEN DateFrom AND DateTo AND LeaveTypeId = @LeaveTypeId  AND InActiveDateTime IS NULL)

	  DECLARE @IntimatedDateToOk BIT = (SELECT CASE WHEN ISNULL(NumberOfDaysToBeIntimated,0) > DATEDIFF(DAY,GETDATE(),@LeaveDateFrom)  THEN 1 ELSE 0 END 
	                                           FROM LeaveFrequency WHERE @LeaveDateTo BETWEEN DateFrom AND DateTo AND LeaveTypeId = @LeaveTypeId AND InActiveDateTime IS NULL)

	  DECLARE @BranchId UNIQUEIDENTIFIER = (SELECT EB.BranchId FROM EmployeeBranch EB
	  JOIN Employee E ON E.Id = EB.EmployeeId AND E.UserId = @UserId WHERE ActiveFrom IS NOT NULL AND (ActiveTo IS NULL OR ActiveTo >= GETDATE()))

      DECLARE @GenderId UNIQUEIDENTIFIER = (SELECT GenderId FROM Employee WHERE UserId = @UserId)
	  DECLARE @MaritalStatusId UNIQUEIDENTIFIER = (SELECT MaritalStatusId FROM Employee WHERE UserId = @UserId)

	  
      DECLARE @LeaveapplicabilityCount INT = (SELECT COUNT(1) 
      FROM LeaveType AS LT
		   JOIN RoleLeaveType RLT ON RLT.LeaveTypeId = LT.Id AND RLT.InactiveDateTime IS NULL
		   JOIN BranchLeaveType BLT ON BLT.LeaveTypeId = LT.Id AND BLT.InactiveDateTime IS NULL
		   JOIN GenderLeaveType GLT ON GLT.LeaveTypeId = LT.Id AND GLT.InactiveDateTime IS NULL
		   JOIN MariatalStatusLeaveType MLT ON MLT.LeaveTypeId = LT.Id AND MLT.InactiveDateTime IS NULL
		   WHERE LT.Id = @LeaveTypeId AND LT.InActiveDateTime IS NULL
		     AND (RoleId IN (SELECT RoleId FROM UserRole WHERE UserId = @UserId AND InactiveDateTime IS NULL) OR RLT.IsAccessAll = 1)
		     AND (BranchId = @BranchId OR BLT.IsAccessAll = 1)
			 AND (GenderId = @GenderId OR GLT.IsAccessAll = 1)
			 AND (MariatalStatusId = @MaritalStatusId OR MLT.IsAccessAll = 1))
			 
											    
	  IF (@FromLeaveSessionId IS NULL) 
	  BEGIN

		RAISERROR(50011,11,1,'FromLeaveSession')

	  END
	  ELSE IF(NOT EXISTS(SELECT 1 FROM Employee E JOIN EmployeeShift ES ON E.UserId = @UserId AND E.Id = ES.EmployeeId AND ((ES.ActiveTo IS NULL AND ES.ActiveFrom <= @LeaveDateFrom) OR (ES.ActiveTo IS NOT NULL AND ES.ActiveFrom <= @LeaveDateFrom AND ES.ActiveTo >= @LeaveDateTo))))
	  BEGIN

		   RAISERROR('ShiftDoesNotExist',11,1)

	  END
	  ELSE IF(@LeaveTypeId IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'LeaveType')

      END
      ELSE IF(@LeaveDateFrom IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'LeaveDateFrom')

      END
      ELSE IF(@LeaveDateTo IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'LeaveDateTo')

      END
	  ELSE IF ((SELECT Id FROM LeaveFrequency WHERE @LeaveDateFrom BETWEEN DateFrom AND DateTo AND LeaveTypeId = @LeaveTypeId AND InActiveDateTime IS NULL) IS NULL AND ISNULL(@IsArchived,0) = 0)
	  BEGIN

		RAISERROR('ThereIsNoLeaveFrequencyForDateFrom',11,1)

	  END
	  ELSE IF ((SELECT Id FROM LeaveFrequency WHERE @LeaveDateTo BETWEEN DateFrom AND DateTo AND LeaveTypeId = @LeaveTypeId AND InActiveDateTime IS NULL) IS NULL AND ISNULL(@IsArchived,0) = 0)
	  BEGIN

		RAISERROR('ThereIsNoLeaveFrequencyForDateTo',11,1)

	  END
	  ELSE IF (@LeaveDateFrom = @LeaveDateTo AND ((@FromLeaveSessionId = @SecondHalfId AND @ToLeaveSessionId = @FirstHalfId)))
	  BEGIN

		RAISERROR('NotAValidLeaveSession',11,1)

	  END
	  ELSE IF(NOT EXISTS(SELECT Id FROM [User] WHERE Id = @UserId AND IsActive = 1 AND InActiveDateTime IS NULL))
	  BEGIN

		RAISERROR('NotAnEmployee',11,1)

	  END
	  ELSE IF (@IntimatedDatefromOk = 1 AND @IntimatedDateToOk = 1 AND (@IsArchived = 0 OR @IsArchived IS NULL))
	  BEGIN

		RAISERROR('MinimumNumberOfIntimatedDaysCrossed',16,1)

	  END
	  ELSE IF((select Count(1) from GenderLeaveType WHERE LeaveTypeId = @LeaveTypeId AND IsAccessAll IS NULL AND InactiveDateTime IS NULL) > 0 
	  AND @GenderId IS NULL AND @LeaveapplicabilityCount = 0)
      BEGIN

	  DECLARE @GenderNames NVARCHAR(500) = (STUFF((SELECT '_' + Gender
			                     FROM Gender G 
								 JOIN GenderLeaveType GLT ON GLT.GenderId = G.Id AND GLT.InactiveDateTime IS NULL
				                 WHERE (GLT.LeaveTypeId = @LeaveTypeId)
					               	   AND G.InactiveDateTime IS NULL
                                       AND G.CompanyId = @CompanyId 
								       GROUP BY Gender
				                  ORDER BY Gender
			               FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))

            SET @GenderNames = CONCAT(@GenderNames,'_GenderLeaveType')

	        RAISERROR(@GenderNames,11,1)
      END
      ELSE IF((select Count(1) from MariatalStatusLeaveType WHERE LeaveTypeId = @LeaveTypeId AND IsAccessAll IS NULL AND InactiveDateTime IS NULL) > 0 AND @MaritalStatusId IS NULL AND @LeaveapplicabilityCount = 0)
      BEGIN

	     DECLARE @MaritalStatusNames NVARCHAR(500) = (STUFF((SELECT '_' + MaritalStatus 
			                     FROM MaritalStatus MS 
								 JOIN MariatalStatusLeaveType MSL ON MSL.MariatalStatusId = MS.Id AND MSL.InactiveDateTime IS NULL
				                 WHERE (MSL.LeaveTypeId = @LeaveTypeId)
					               	   AND MS.InactiveDateTime IS NULL
                                       AND MS.CompanyId = @CompanyId
									    GROUP BY MaritalStatus
				                  ORDER BY MaritalStatus
			               FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))

		  SET @MaritalStatusNames = CONCAT(@MaritalStatusNames,'_MariatalStatusLeaveType')

	      RAISERROR(@MaritalStatusNames,11,1)

      END
	  ELSE
	  BEGIN

	  DECLARE @StartFrequency DATE = (SELECT DateFrom FROM LeaveFrequency WHERE LeaveTypeId = @LeaveTypeId AND InactiveDateTime IS NULL AND (@LeaveDateFrom BETWEEN DateFrom AND DateTo))
		
	  DECLARE @EndFrequency DATE = (SELECT DateTo FROM LeaveFrequency WHERE LeaveTypeId = @LeaveTypeId AND InactiveDateTime IS NULL AND (@LeaveDateFrom BETWEEN DateFrom AND DateTo))

	  DECLARE @RestrictionTypeId UNIQUEIDENTIFIER = (SELECT RestrictionTypeId FROM LeaveFrequency LF WHERE @LeaveDateFrom BETWEEN DateFrom AND DateTo AND InActiveDateTime IS NULL AND LeaveTypeId = @LeaveTypeId)

	  DECLARE @MaxLeavesCountForALeaveType FLOAT = 0

	  DECLARE @JoinedDate DATETIME,@FromMonth INT,@ToMonth INT,@DateFrom DATETIME,@DateTo DATETIME

	  SELECT @DateFrom = DateFrom,@DateTo = DateTo FROM [dbo].[Ufn_GetFinancialYearDatesForleaves] (@UserId,DATEPART(YEAR,@LeaveDateFrom))

	     IF(@DateFrom != @DateTo)
		 BEGIN

			SET @MaxLeavesCountForALeaveType = (SELECT SUM(EffectiveBalance) FROM [dbo].[Ufn_GetLeavesReportOfAnUser](@UserId,@LeaveTypeId,@DateFrom,@DateTo) WHERE ((@StartFrequency BETWEEN DateFrom AND DateTo) OR (@EndFrequency BETWEEN DateFrom AND DateTo)))
			
		 END 

	  DECLARE @YtdLeaves FLOAT,@LeavesTakenYTD FLOAT,@IsToCheckYTD BIT = 0

	  IF(EXISTS(SELECT Id FROM LeaveFrequency WHERE LeaveTypeId = @LeaveTypeId AND IsPaid = 1 AND ((@LeaveDateFrom BETWEEN DateFrom AND DateTo) OR (@LeaveDateTo BETWEEN DateFrom AND DateTo))))
	  BEGIN

		SET @YtdLeaves = ISNULL((SELECT [dbo].[Ufn_GetEmployeeYTDLeaves](@UserId,DATEPART(YEAR,@LeaveDateFrom),@LeaveTypeId)),0)

		SET @LeavesTakenYTD = ISNULL((SELECT SUM(LeavesTaken) FROM [dbo].[Ufn_GetLeavesReportOfAnUser](@UserId,@LeaveTypeId,@DateFrom,@DateTo)),0)

		SET @IsToCheckYTD = 1

	  END
	  

	  DECLARE @LeavesTakenForThisLeaveType FLOAT = (SELECT Cnt FROM [dbo].[Ufn_GetLeavesCountWithStatusOfAUser](@UserId,@StartFrequency,@EndFrequency,@LeaveApplicationId,@LeaveTypeId,(SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId)))
	  
	  SET @LeavesTakenForThisLeaveType = @LeavesTakenForThisLeaveType + (SELECT Cnt FROM [dbo].[Ufn_GetLeavesCountWithStatusOfAUser](@UserId,@StartFrequency,@EndFrequency,@LeaveApplicationId,@LeaveTypeId,(SELECT Id FROM LeaveStatus WHERE IsWaitingForApproval = 1 AND CompanyId = @CompanyId)))

	  DECLARE @LeaveTypeCount INT = (SELECT COUNT(1) FROM [dbo].[Ufn_GetEligibleLeaveTypes](@UserId) P WHERE P.LeaveTypeId = @LeaveTypeId)

	  DECLARE @LeaveCount INT = (SELECT COUNT(1) FROM LeaveApplication 
                                                WHERE UserId = @UserId AND ((LeaveDateFrom BETWEEN @LeaveDateFrom AND @LeaveDateTo) OR 
                                                      (LeaveDateTo BETWEEN @LeaveDateFrom AND @LeaveDateTo)) AND (@LeaveApplicationId IS NULL OR Id <> @LeaveApplicationId) AND InActiveDateTime IS NULL)

      DECLARE @LeaveSession UNIQUEIDENTIFIER = (SELECT FromLeaveSessionId FROM LeaveApplication 
                                                WHERE UserId = @UserId AND ((@LeaveDateFrom BETWEEN LeaveDateFrom AND LeaveDateTo) OR 
                                                      (@LeaveDateTo BETWEEN LeaveDateFrom AND LeaveDateTo)) AND (@LeaveApplicationId IS NULL OR Id <> @LeaveApplicationId) AND InactiveDateTime IS NULL
                                                     )

      DECLARE @IsAlreadyExist BIT = CASE WHEN @LeaveCount > 0 THEN 1
										 WHEN @LeaveSession IS NULL THEN 0
                                         WHEN @LeaveSession = (SELECT Id FROM LeaveSession WHERE IsFullDay = 1  AND CompanyId = @CompanyId) THEN 1
                                         WHEN @LeaveSession = @FirstHalfId THEN CASE WHEN @FromLeaveSessionId = @SecondHalfId THEN 0 ELSE 1 END
                                         WHEN @LeaveSession = @SecondHalfId THEN CASE WHEN @FromLeaveSessionId = @FirstHalfId THEN 0 ELSE 1 END
                                    END

      DECLARE @NumberOfDays FLOAT = (SELECT ISNULL(SUM(Total.Cnt),0) AS Cnt FROM 
		                             (SELECT CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                                          ELSE CASE WHEN (T.[Date] = @LeaveDateFrom AND FLS.IsSecondHalf = 1) OR (T.[Date] = @LeaveDateTo AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                                          ELSE 1 END END AS Cnt FROM
			                          (SELECT DATEADD(DAY,NUMBER,@LeaveDateFrom) AS [Date]
			                                  FROM MASTER..SPT_VALUES MSPT
			                          	    WHERE [type]='p' AND number <= DATEDIFF(DAY,@LeaveDateFrom,@LeaveDateTo)) T
			                          	    JOIN LeaveType LT ON LT.Id = @LeaveTypeId AND LT.CompanyId = @CompanyId AND LT.InActiveDateTime IS NULL
			                          	    JOIN LeaveSession FLS ON FLS.Id = @FromLeaveSessionId
			                          	    JOIN LeaveSession TLS ON TLS.Id = @ToLeaveSessionId
			                          		JOIN Employee E ON E.UserId = @UserId AND E.InActiveDateTime IS NULL
			                          		LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
			                          		LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
			                          	    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL
		                              WHERE T.[Date] BETWEEN @LeaveDateFrom AND @LeaveDateTo)Total)

	  IF (@RestrictionTypeId IS NOT NULL)
	  BEGIN
	    
		DECLARE @LeaveRestriction DATE = (CASE  WHEN (SELECT RT.IsWeekly FROM RestrictionType RT WHERE RT.Id = @RestrictionTypeId) = 1 THEN DATEADD(DAY,-7,@LeaveDateFrom)
		                                        WHEN (SELECT RT.IsMonthly FROM RestrictionType RT WHERE RT.Id = @RestrictionTypeId) = 1 THEN DATEADD(DAY,-31,@LeaveDateFrom)
		                                        WHEN (SELECT RT.IsQuarterly FROM RestrictionType RT WHERE RT.Id = @RestrictionTypeId) = 1 THEN DATEADD(DAY,-91,@LeaveDateFrom)
		                                        WHEN (SELECT RT.IsHalfYearly FROM RestrictionType RT WHERE RT.Id = @RestrictionTypeId) = 1 THEN DATEADD(DAY,-183,@LeaveDateFrom)
		                                        WHEN (SELECT RT.IsYearly FROM RestrictionType RT WHERE RT.Id = @RestrictionTypeId) = 1 THEN DATEADD(DAY,-366,@LeaveDateFrom)
										  END)
		                                           
		
	   DECLARE @LeavesInRestrictionPeriod FLOAT = (SELECT Cnt FROM [dbo].[Ufn_GetLeavesCountWithStatusOfAUser](@UserId,@LeaveRestriction,@LeaveDateFrom,@LeaveApplicationId,@LeaveTypeId,(SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId)))

	   DECLARE @Restict BIT = (CASE WHEN ((SELECT RT.LeavesCount FROM RestrictionType RT WHERE RT.Id = @RestrictionTypeId AND CompanyId = @CompanyId) < @LeavesInRestrictionPeriod + @NumberOfDays)
	   THEN 1 ELSE 0 END)
	  END 
	  IF (@LeaveTypeCount = 0 AND ISNULL(@IsArchived,0) = 0)
	  BEGIN

		   RAISERROR('ThisLeaveTypeIsNotApplicable',11,1)

	  END
	  ELSE IF (ISNULL(@IsArchived,0) = 0 AND (@MaxLeavesCountForALeaveType IS NOT NULL AND (@MaxLeavesCountForALeaveType < @NumberOfDays)))
	  BEGIN

		IF (@MaxLeavesCountForALeaveType = 0)
			
			RAISERROR('ThereAreNoLeavesInYourAppliedLeavePeriod',11,1)

		ELSE IF(@LeavesTakenForThisLeaveType = 0 OR @LeavesTakenForThisLeaveType IS NULL)

            RAISERROR('MaxLeavesCrossed',11,1)

        ELSE
			
			RAISERROR('MaxLeavesTakenForThisLeaveType',11,1)

	  END
      ELSE IF (@IsAlreadyExist = 1 AND ISNULL(@IsArchived,0) = 0)
      BEGIN

           RAISERROR('LeaveAlreadyExist',16,1)

      END
	  ELSE IF (@Restict = 1 AND (@IsArchived IS NULL OR @IsArchived = 0))
      BEGIN

           RAISERROR('RestrictionCrossed',16,1)

      END
	  --ELSE IF(@IsToCheckYTD = 1 AND @YtdLeaves < (@NumberOfDays) AND (@IsArchived IS NULL OR @IsArchived = 0))
	  --BEGIN

		 -- RAISERROR('RestrictionCrossed',16,1)

	  --END
      ELSE 
      BEGIN

        DECLARE @IsLatest BIT = (CASE WHEN @LeaveApplicationId IS NULL 
                                           THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                       FROM LeaveApplication WHERE Id = @LeaveApplicationId) = @TimeStamp
                                                                THEN 1 ELSE 0 END END)
            
                IF(@IsLatest = 1)
                BEGIN

					DECLARE @Temp TABLE(
			    	                    IsReApplied BIT
			                           )
                    
					DECLARE @ReportToCount INT = (SELECT COUNT(1) FROM [dbo].[Ufn_GetEmployeeReportToMembers](@UserId))
					
					DECLARE @NewLeaveId UNIQUEIDENTIFIER = NEWID()

					IF (@LeaveApplicationId IS NULL)
					BEGIN
                     INSERT INTO [dbo].[LeaveApplication](
                                 [Id],
                                 [UserId],
                                 [LeaveAppliedDate],
                                 [LeaveReason],
                                 [LeaveTypeId],
                                 [LeaveDateFrom],
                                 [LeaveDateTo],
                                 [CreatedDateTime],
                                 [CreatedByUserId],
                                 [OverallLeaveStatusId],
                                 [FromLeaveSessionId],
                                 [ToLeaveSessionId],
                                 [InActiveDateTime])
                          SELECT @NewLeaveId,
                                 @UserId,
                                 @Currentdate,
                                 @LeaveReason,
                                 @LeaveTypeId,
                                 @LeaveDateFrom,
                                 CASE WHEN @LeaveDateTo IS NULL THEN @LeaveDateFrom ELSE @LeaveDateTo END,
                                 @Currentdate,
                                 @OperationsPerformedBy,
								 (SELECT Id FROM LeaveStatus WHERE IsWaitingForApproval = 1 AND CompanyId = @CompanyId),
                                 @FromLeaveSessionId,
                                 CASE WHEN @ToLeaveSessionId IS NULL THEN @FromLeaveSessionId ELSE @ToLeaveSessionId END,
                                 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
                       
					   INSERT INTO [LeaveApplicationStatusSetHistory](
											               [Id]
											              ,[LeaveApplicationId]
											              ,[LeaveStatusId]
											              ,[LeaveStuatusSetByUserId]
											              ,[CreatedDateTime]
											              ,[CreatedByUserId]
														  ,[Reason]
														  ,[Description]
				                                          )
									                SELECT NEWID()
									                      ,@NewLeaveId
									                      ,(SELECT Id FROM LeaveStatus WHERE IsWaitingForApproval = 1 AND CompanyId = @CompanyId)
									                      ,ISNULL(@UserId,@OperationsPerformedBy)
									                      ,GETDATE()
									                      ,@OperationsPerformedBy
														  ,@LeaveReason
														  ,'Applied'

                    --UPDATE LeaveApplication SET AsAtInactiveDateTime = @CurrentDate WHERE Id = @LeaveApplicationId AND Id <> @NewLeaveId
                    END
					ELSE
					BEGIN
						    UPDATE LeaveApplicationStatusSetHistory SET InActiveDateTime = GETDATE() WHERE LeaveApplicationId = @LeaveApplicationId
							
							INSERT INTO @Temp
							EXEC [dbo].[USP_InsertLeaveApplicationAuditHistory] @OperationsPerformedBy = @OperationsPerformedBy,@LeaveApplicationId = @LeaveApplicationId,@FromDate = @LeaveDateFrom,
																	    @ToDate = @LeaveDateTo,@Reason = @LeaveReason,@FromLeaveSession = @FromLeaveSessionId,
																		@ToLeaveSession = @ToLeaveSessionId,@LeaveStatusId = NULL

							UPDATE LeaveApplication SET [LeaveReason]			  =  @LeaveReason
                                                        ,[LeaveTypeId]			  =  @LeaveTypeId
														,[OverallLeaveStatusId]   = (SELECT Id FROM LeaveStatus WHERE IsWaitingForApproval = 1 AND CompanyId = @CompanyId)
                                                        ,[LeaveDateFrom]		  =  @LeaveDateFrom
                                                        ,[LeaveDateTo]			  =  @LeaveDateTo
                                                        ,[UpdatedDateTime]		  =  @Currentdate
                                                        ,[UpdatedByUserId]		  =  @OperationsPerformedBy
                                                        ,[FromLeaveSessionId]	  =  @FromLeaveSessionId
                                                        ,[ToLeaveSessionId]		  =  @ToLeaveSessionId
                                                        ,[InActiveDateTime]       =  CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
														WHERE Id = @LeaveApplicationId

					END
					IF(@IsArchived IS NULL OR @IsArchived = 0)
					BEGIN
							
							DECLARE @ToSendMail BIT = (CASE WHEN EXISTS(SELECT IsReApplied FROM @Temp) THEN 0 ELSE 1 END)

					IF (@ReportToCount > 1 AND @ToSendMail = 1)
					BEGIN

						SELECT @UserId AS AppliedUserId
						      ,@UserName AS AppliedUserName
							  ,CASE WHEN @FromLeaveSessionId = @SecondHalfId THEN  DATEADD(HOUR,12,@LeaveDateFrom) ELSE @LeaveDateFrom END AS LeaveDateFrom
							  ,CASE WHEN @ToLeaveSessionId = @FirstHalfId THEN DATEADD(HOUR,12,@LeaveDateTo) ELSE  DATEADD(MINUTE,24*60-1,@LeaveDateTo) END AS LeaveDateTo
							  ,@NumberOfDays AS NumberOfDays
							  ,ISNULL(@LeaveApplicationId,@NewLeaveId) AS LeaveApplicationId 
							  ,T.FullName AS ReportToUserName
							  ,T.UserId AS ReportToUserId
							  ,T.UserName AS ReportToUserMail
							  FROM
							  (SELECT RT.UserId
									 ,U.SurName + ' ' + U.FirstName AS [FullName]
									 ,U.UserName 
									 FROM (SELECT * FROM [dbo].[Ufn_GetEmployeeReportToMembers](@UserId)) RT
									 JOIN [User] U ON U.Id = RT.UserId AND U.InActiveDateTime IS NULL AND RT.UserLevel > 0
                              GROUP BY RT.UserId,U.SurName + ' ' + U.FirstName,U.UserName) T

					END
					ELSE
					BEGIN
						SELECT @UserId AS AppliedUserId
						      ,@UserName AS AppliedUserName
							  ,@LeaveDateFrom AS LeaveDateFrom
							  ,@LeaveDateTo AS LeaveDateTo
							  ,@NumberOfDays AS NumberOfDays
							  ,ISNULL(@LeaveApplicationId,@NewLeaveId) AS LeaveApplicationId 
                  END 
				  END
				  ELSE

					SELECT ISNULL(@LeaveApplicationId,@NewLeaveId)

				  END
                ELSE
                    RAISERROR (50008,11, 1)
                
          END
      END
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