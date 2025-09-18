--EXEC  [dbo].[USP_SearchLeaves_New] @OperationsPerformedBy ='0B2921A9-E930-4013-9047-670B5352F308'

CREATE PROCEDURE [dbo].[USP_SearchLeaves_New]
(
  @LeaveApplicationId UNIQUEIDENTIFIER = NULL,
  @UserId UNIQUEIDENTIFIER = NULL,
  @LeaveReason NVARCHAR(250) = NULL,
  @LeaveTypeId UNIQUEIDENTIFIER = NULL,
  @LeaveAppliedDate DATETIME = NULL,
  @LeaveDateFrom DATETIME = NULL,
  @LeaveDateTo DATETIME = NULL,
  @IsDeleted BIT = NULL,
  @OverallLeaveStatusId UNIQUEIDENTIFIER = NULL,
  @FromLeaveSessionId UNIQUEIDENTIFIER = NULL,
  @ToLeaveSessionId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @PageNumber INT = 1,
  @PageSize INT = 10,
  @SortBy NVARCHAR(100) = NULL,
  @SortDirection NVARCHAR(100) = NULL,
  @SearchText  NVARCHAR(100) = NULL,
  @IsArchived BIT = NULL,
  @Date DATE = NULL,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @EntityId UNIQUEIDENTIFIER = NULL,
  @RoleId UNIQUEIDENTIFIER = NULL,
  @IsWaitingForApproval BIT = NULL,
  @LeaveApplicationIdsXml XML = NULL

)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
    IF (@HavePermission = '1')
    BEGIN
		
		  IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
		  
		  IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
		  
		  IF(@LeaveAppliedDate = '') SET @LeaveAppliedDate = NULL
		  
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
          
		  DECLARE @IsAdmin BIT = (CASE WHEN EXISTS(SELECT Id FROM RoleFeature WHERE FeatureId = '31CC4268-9C82-4CEB-912B-B00D6D5CE89A' AND 
								  RoleId IN (SELECT RoleId FROM [UserRole] WHERE UserId = @OperationsPerformedBy AND InActiveDateTime IS NULL) AND InActiveDateTime IS NULL)
								  THEN 1 ELSE 0 END) --To check 'View company wide leaves' feature access
		  
		  SET @SearchText = '%'+ @SearchText+'%'

		  IF(@SortDirection IS NULL )
	      BEGIN
		  
	        	SET @SortDirection = 'DESC'
		  
	      END
	      
	      DECLARE @OrderByColumn NVARCHAR(250) 
		  
	      IF(@SortBy IS NULL)
	      BEGIN
		  
	       	    SET @SortBy = 'LeaveAppliedDate'
		  
	      END
	      ELSE
	      BEGIN
		  
	      	    SET @SortBy = @SortBy
		  
	      END
       	  
          CREATE TABLE #reportingemployees
          (
		      Id INT IDENTITY(1,1),
              [level] INTEGER,
              ParentId UNIQUEIDENTIFIER,
              ChildId UNIQUEIDENTIFIER
          )

		  CREATE TABLE #LeaveApplicationIds
          (
                Id UNIQUEIDENTIFIER
          )
		   IF(@LeaveApplicationIdsXml IS NOT NULL) 
          BEGIN
            
            SET @LeaveApplicationId = NULL
            INSERT INTO #LeaveApplicationIds(Id)
            SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
            FROM @LeaveApplicationIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
          END

		  DECLARE @ReportToCount INT = (SELECT COUNT(1) FROM [dbo].[Ufn_GetEmployeeReportToMembers](@OperationsPerformedBy)) --To get logged in user reporting chain 

		  IF(@IsAdmin = 0 OR @IsWaitingForApproval = 1) --To get only waiting for approved leaves and for reported members
		  BEGIN
          INSERT INTO #reportingemployees (
		                                   [level], 
										   ParentId, 
										   ChildId
										  ) 
								    SELECT lvl,
									       ParentId,
										   ChildId
										   FROM [dbo].[Ufn_GetEmployeeReportedMembers](@OperationsPerformedBy,@CompanyId)
										   WHERE (@ReportToCount > 1 AND (@IsWaitingForApproval IS NULL OR (@IsWaitingForApproval = 1 AND ChildId <> @OperationsPerformedBy)))
										      OR (@ReportToCount = 1)
		 END
		 ELSE --for leaves dashboard which retuns all employee Leaves data 
		 BEGIN
		 
		  INSERT INTO #reportingemployees (
										   ChildId
										  ) 
										 SELECT U.Id FROM [User] U
										   LEFT JOIN [dbo].[Employee]E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL AND U.IsActive = 1 AND U.InactiveDateTime IS NULL
	                                       LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                                                  AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
										 WHERE CompanyId = @CompanyId AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
												AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))

		 END
          
          SELECT LA.Id AS LeaveApplicationId,
			     LA.UserId,
			     LA.LeaveAppliedDate,
			     LA.LeaveReason,
			     LA.LeaveTypeId,
			     LT.LeaveTypeName,
			     LA.OverallLeaveStatusId,
			     LS.LeaveStatusName,
			     LA.LeaveDateFrom,
			     LA.LeaveDateTo,
				 Number.[Days],
			     LA.IsDeleted,
			     LA.FromLeaveSessionId,
			     LS1.LeaveSessionName AS FromLeaveSessionName,
			     LA.ToLeaveSessionId,
			     LS2.LeaveSessionName AS ToLeaveSessionName,
				 --
			     LA.CreatedByUserId,
			     LA.CreatedDateTime,
			     U.FirstName +' '+ U.SurName AS EmployeeName,
				 U.ProfileImage,
				 LA.BackUpUserId,
				 BU.FirstName + '' + ISNULL(BU.SurName,'') AS BackUpdUserName,
				 LA.[TimeStamp],
				 ISNULl(LS.IsRejected,0) AS IsRejected,
				 ISNULL(LS.IsApproved,0) AS IsApproved,
				 @IsAdmin AS IsAdmin,
				 LS.LeaveStatusColour,
				 CASE WHEN LA.LeaveDateFrom > GETDATE() AND LS.IsRejected = 1 THEN 1 ELSE 0 END IsToReApply,
				 CASE WHEN LS1.IsSecondHalf = 1 THEN DATEADD(HOUR,12,LA.LeaveDateFrom) ELSE DATEADD(MINUTE,1,LA.LeaveDateFrom) END AS [StartFrom],
				 CASE WHEN LS2.IsFirstHalf = 1 THEN  DATEADD(HOUR,12,LA.LeaveDateTo) ELSE DATEADD(MINUTE,24*60-1,LA.LeaveDateTo) END AS [EndTo],
				 LA.Id,
				 LT.LeaveTypeColor,
				 (SELECT CASE WHEN LS1.IsSecondHalf = 1 THEN  DATEADD(MINUTE,DATEDIFF(MINUTE,ISNULL(SE.StartTime,SW.StartTime),ISNULL(SE.EndTime,SW.EndTime))/2.0,DATEADD(MINUTE,DATEDIFF(MINUTE,0,ISNULL(SE.StartTime,SW.StartTime)),LA.LeaveDateFrom))
				          ELSE (DATEADD(MINUTE,DATEDIFF(MINUTE,0,ISNULL(SE.StartTime,SW.StartTime)),LA.LeaveDateFrom))
						  END 
				           FROM EmployeeShift ES
				           LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,LA.LeaveDateFrom) = SW.[DayOfWeek]
						   LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ES.ShiftTimingId AND CONVERT(DATE,LA.LeaveDateFrom) = SE.ExceptionDate
						   WHERE ((ES.ActiveFrom < LA.LeaveDateFrom AND ES.ActiveTo IS NULL) OR (ES.ActiveTo IS NOT NULL AND (LA.LeaveDateFrom BETWEEN ES.ActiveFrom AND ES.ActiveTo)))
						         AND ES.InActiveDateTime IS NULL AND ES.EmployeeId = E.Id
						   ) AS [Start],
				 (SELECT CASE WHEN LS2.IsFirstHalf = 1 THEN  DATEADD(MINUTE,DATEDIFF(MINUTE,ISNULL(SE.StartTime,SW.StartTime),ISNULL(SE.EndTime,SW.EndTime))/2.0,DATEADD(MINUTE,DATEDIFF(MINUTE,0,ISNULL(SE.StartTime,SW.StartTime)),LA.LeaveDateTo))
				          ELSE (DATEADD(MINUTE,DATEDIFF(MINUTE,0,ISNULL(SE.EndTime,SW.EndTime)),LA.LeaveDateTo))
						  END 
				           FROM EmployeeShift ES
				           LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,LA.LeaveDateTo) = SW.[DayOfWeek]
						   LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ES.ShiftTimingId AND CONVERT(DATE,LA.LeaveDateTo) = SE.ExceptionDate
						   WHERE ((ES.ActiveFrom < LA.LeaveDateTo AND ES.ActiveTo IS NULL) OR (ES.ActiveTo IS NOT NULL AND (LA.LeaveDateTo BETWEEN ES.ActiveFrom AND ES.ActiveTo)))
						         AND ES.InActiveDateTime IS NULL AND ES.EmployeeId = E.Id
						   ) AS [End],
				 TotalCount = COUNT(1) OVER()
        FROM #reportingemployees RET WITH(NOLOCK)
              INNER JOIN [User] U ON RET.ChildId = U.Id AND U.IsActive = 1
			  INNER JOIN Employee E ON E.UserId = U.Id 
	          INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                     AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                         AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			  INNER JOIN LeaveApplication LA ON LA.UserId= U.Id --AND LA.LeaveDateFrom BETWEEN @LeaveDateFrom AND @LeaveDateTo
			  LEFT JOIN #LeaveApplicationIds LAI ON LAI.Id = LA.Id
              INNER JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId AND (@UserId IS NULL OR LA.UserId = @UserId) AND LT.InActiveDateTime IS NULL
              INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId AND (@IsWaitingForApproval IS NULL OR (@IsWaitingForApproval = 1 AND LS.IsWaitingForApproval = 1))
              INNER JOIN LeaveSession LS1 ON LS1.Id = LA.FromLeaveSessionId
              INNER JOIN LeaveSession LS2 ON LS2.Id = LA.ToLeaveSessionId
			  INNER JOIN (SELECT Total.Id
			                    ,ISNULL(SUM(Total.Cnt),0) AS [Days]
								 FROM 
                                (SELECT T.[Id]
								       ,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                 ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                           ELSE 1 END END AS Cnt FROM
                                                                           (SELECT DATEADD(DAY,NUMBER,LeaveDateFrom) AS [Date],LA.Id
			                                                                FROM MASTER..SPT_VALUES MSPTV WITH(NOLOCK)
		                                                                    JOIN LeaveApplication LA ON MSPTV.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo)
			       	                                                         AND MSPTV.[Type] = 'P' 
																			 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND LA.InActiveDateTime IS NOT NULL) 
																			  OR (@IsArchived = 0 AND LA.InActiveDateTime IS NULL))
			       	                                                        JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId
			       	                                                         AND (@LeaveTypeId IS NULL OR LT.Id = @LeaveTypeId)
			       						                                     AND (@UserId IS NULL OR LA.UserId = @UserId)
			       						                                     AND LT.CompanyId = @CompanyId
				                                                            JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId) T
				               JOIN LeaveApplication LAP ON LAP.Id = T.Id
				               JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId
					           JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					           JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
				               JOIN [User] U ON U.Id = LAP.UserId AND U.IsActive = 1 AND U.CompanyId = @CompanyId
					           JOIN (SELECT UR.UserId
										   ,STUFF((SELECT ','+CAST(R.RoleName AS VARCHAR)
											FROM UserRole UR1 JOIN [Role] R ON R.Id = UR1.RoleId AND UR1.UserId = UR.UserId AND UR1.InactiveDateTime IS NULL
								            FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleNames
								            FROM UserRole UR 
								            JOIN [User] U ON UR.UserId = U.Id AND U.IsActive = 1 AND U.CompanyId = @CompanyId
											             AND (@RoleId IS NULL OR UR.RoleId = @RoleId)
											GROUP BY UR.UserId
											) R ON R.UserId = U.Id
							   JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = @CompanyId
							   LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
							   LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				               LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL
							   ) Total
							   GROUP BY Total.Id) Number ON Number.Id = LA.Id
			  LEFT JOIN [User] BU ON BU.Id = LA.BackUpUserId 
			  LEFT JOIN LeaveApplicationStatusSetHistory LSSH ON LSSH.LeaveApplicationId = LA.Id AND LSSH.InActiveDateTime IS NULL AND LSSH.CreatedByUserId = @OperationsPerformedBy AND LSSH.[Description] NOT IN ('Applied','Reapplied') AND LSSH.OldValue IS NULL AND LSSH.NewValue IS NULL
        WHERE (@LeaveAppliedDate IS NULL OR LA.LeaveAppliedDate = @LeaveAppliedDate)
			  AND (@LeaveApplicationIdsXml IS NULL OR LA.Id = LAI.Id)
			  AND (@IsWaitingForApproval IS NULL OR (@IsWaitingForApproval = 1 AND LSSH.Id IS NULL))
			  AND (@LeaveApplicationId IS NULL OR LA.Id = @LeaveApplicationId)
			  AND U.CompanyId = @CompanyId
			  AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
			  AND LA.InActiveDateTime IS NULL
              AND (@UserId IS NULL OR LA.UserId = @UserId)
              AND (@LeaveReason IS NULL OR LA.LeaveReason = @LeaveReason)
              AND (@LeaveDateFrom IS NULL OR CONVERT(DATE,LA.LeaveDateFrom) > = CONVERT(DATE,@LeaveDateFrom))
              AND (@LeaveDateTo IS NULL OR CONVERT(DATE,LA.LeaveDateTo) <= CONVERT(DATE,@LeaveDateTo))
              AND (@IsDeleted IS NULL OR LA.IsDeleted = @IsDeleted)
              AND (@OverallLeaveStatusId IS NULL OR LA.OverallLeaveStatusId = @OverallLeaveStatusId)
              AND (@FromLeaveSessionId IS NULL OR LA.FromLeaveSessionId = @FromLeaveSessionId)
              AND (@ToLeaveSessionId IS NULL OR LA.ToLeaveSessionId = @ToLeaveSessionId)
			  AND (@Date IS NULL OR @Date BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo)
			  AND (@IsArchived IS NULL OR (@IsArchived = 1 AND LA.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND LA.InActiveDateTime IS NULL))
		      AND (@SearchText IS NULL 
				  OR (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText)
				  OR (LeaveReason LIKE @SearchText)
				  OR (LeaveTypeName LIKE @SearchText)
				  OR (LS1.LeaveSessionName LIKE @SearchText)
				  OR (LS2.LeaveSessionName LIKE @SearchText)
				 )
         ORDER BY 
		        CASE WHEN @SortDirection = 'ASC' THEN
		             CASE WHEN @SortBy = 'FullName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
		                  WHEN @SortBy = 'LeaveTypeName' THEN LeaveTypeName
		                  WHEN @SortBy = 'FromLeaveSessionName' THEN LS1.LeaveSessionName
		                  WHEN @SortBy = 'ToLeaveSessionName' THEN LS2.LeaveSessionName 
		                  WHEN @SortBy = 'LeaveReason' THEN LA.LeaveReason 
		                  WHEN @SortBy = 'LeaveStatusName'  OR @SortBy = NULL THEN LS.LeaveStatusName
		                  WHEN @SortBy = 'LeaveDateFrom'  THEN CAST(LA.LeaveDateFrom AS SQL_VARIANT) 
						  WHEN @SortBy = 'LeaveDateTo' THEN CAST(LA.LeaveDateTo AS SQL_VARIANT) 
		                  WHEN @SortBy = 'Days' THEN CAST(Number.[Days] AS SQL_VARIANT) 
						  WHEN @SortBy = 'LeaveAppliedDate' THEN CAST(LeaveAppliedDate AS SQL_VARIANT)
		        	 END 
		        END ASC,
	            CASE WHEN @SortDirection = 'DESC' THEN
	                  CASE WHEN @SortBy = 'FullName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
		                  WHEN @SortBy = 'LeaveTypeName' THEN LeaveTypeName
		                  WHEN @SortBy = 'FromLeaveSessionName' THEN LS1.LeaveSessionName
		                  WHEN @SortBy = 'ToLeaveSessionName' THEN LS2.LeaveSessionName 
		                  WHEN @SortBy = 'LeaveReason' THEN LA.LeaveReason 
		                  WHEN @SortBy = 'LeaveStatusName'  THEN LS.LeaveStatusName 
		                  WHEN @SortBy = 'LeaveDateFrom' THEN CAST(LA.LeaveDateFrom AS SQL_VARIANT) 
						  WHEN @SortBy = 'LeaveDateTo' THEN CAST(LA.LeaveDateTo AS SQL_VARIANT) 
		                  WHEN @SortBy = 'Days' THEN CAST(Number.[Days] AS SQL_VARIANT) 
						  WHEN @SortBy = 'LeaveAppliedDate' THEN Cast(LeaveAppliedDate AS SQL_VARIANT)
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


