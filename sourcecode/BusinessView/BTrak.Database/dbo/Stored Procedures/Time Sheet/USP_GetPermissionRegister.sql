-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-06-25 00:00:00.000'
-- Purpose      To Get the Permission Details By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetPermissionRegister] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetPermissionRegister]
(
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@DateFrom DATETIME = NULL,
	@DateTo DATETIME = NULL,
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

		  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		  IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

		  IF (@HavePermission = '1')
          BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET  @EmployeeId = NULL
			
			IF(@DateFrom IS NULL) SET  @DateFrom = CONVERT(DATE,GETDATE())
			
			IF(@DateTo IS NULL) SET  @DateTo = CONVERT(DATE,GETDATE())

			IF(@SortDirection IS NULL ) SET @SortDirection = 'ASC'

			IF(@SortBy IS NULL) SET @SortBy = 'Employee Name'

			SET @SearchText = '%'+ @SearchText+'%'

			DECLARE @DateTable TABLE
			(
					[Date] DATETIME
			)

				INSERT INTO @DateTable([Date])
				SELECT @DateFrom
				
				INSERT INTO @DateTable([Date])
				SELECT TOP (DATEDIFF(DAY,@DateFrom,@DateTo)) AllDays = DATEADD(DAY, ROW_NUMBER() 
				       OVER (ORDER BY object_id), REPLACE(@DateFrom,'-',''))
				FROM [sys].[all_objects]

				SELECT *,TotalCount = COUNT(1) OVER() FROM (
					SELECT TS.[Date]
					       ,U.Id AS UserId
					       ,U.ProfileImage AS UserProfileImage
					       ,U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName
					       ,E.Id AS EmployeeId
						   ,P.[Date] AS DateOfPermission
						   ,ISNULL(P.Duration,(CAST(DATEADD(SECOND, DATEDIFF(SECOND, (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME)),  SWITCHOFFSET(TS.InTime, '+00:00')), 0) AS TIME))) AS Duration 
						   ,PR.ReasonName AS PermissionReason
						   ,CASE WHEN P.Id IS NULL THEN 'Permission Not Taken' ELSE 'Permission Taken' END AS Review
					FROM [dbo].[User] U WITH (NOLOCK)
					    --LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id AND UAD.ActiveFrom IS NOT NULL AND (UAD.ActiveTo IS NULL OR UAD.ActiveTo <= @DateTo) --Need to Check
					     INNER JOIN [dbo].[Employee] E WITH (NOLOCK) ON E.UserId = U.Id AND U.IsActive = 1 
													AND (U.CompanyId = @CompanyId) AND E.InActiveDateTime IS NULL
	                     INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                             AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	                             AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                                 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
						 INNER JOIN [dbo].[TimeSheet] TS WITH (NOLOCK) ON TS.UserId = U.Id
						 INNER JOIN [dbo].[EmployeeShift] ES WITH (NOLOCK) ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL  AND ES.ActiveFrom <= CONVERT(DATE,TS.[Date]) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,TS.[Date]))
						 INNER JOIN [dbo].[ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL 
						 INNER JOIN [dbo].[ShiftWeek] SW ON SW.ShiftTimingId = ST.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date]))						
						 LEFT JOIN  [dbo].[Permission] P WITH (NOLOCK) ON P.UserId = TS.UserId AND P.[Date] = TS.[Date] AND P.IsMorning = 1 AND (P.IsDeleted = 0 OR P.IsDeleted IS NULL) AND P.InActiveDateTime IS NULL
						 LEFT JOIN [dbo].[PermissionReason] PR WITH (NOLOCK) ON PR.Id = P.PermissionReasonId AND PR.InActiveDateTime IS NULL
						 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ST.Id AND SE.InActiveDateTime IS NULL AND SE.ExceptionDate = TS.[Date]
						 INNER JOIN @DateTable DT ON DT.[Date] = TS.[Date]
					WHERE (@EmployeeId IS NULL OR E.UserId = @EmployeeId)
					        AND SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME))) TInner
			WHERE (@SearchText IS NULL	
							OR (TInner.EmployeeId LIKE @SearchText)
							OR (TInner.Review LIKE @SearchText)
							OR (TInner.PermissionReason LIKE @SearchText)
						  )
				GROUP BY Tinner.[Date],Tinner.UserId,Tinner.UserProfileImage,Tinner.[EmployeeName],TInner.EmployeeId,TInner.[DateOfPermission],TInner.Duration,TInner.PermissionReason,TInner.Review
				ORDER BY 
			    CASE WHEN @SortDirection = 'ASC' THEN
			         CASE WHEN @SortBy = 'EmployeeName' THEN TInner.EmployeeName
			              WHEN @SortBy = 'DateOfPermission' THEN Cast(TInner.DateOfPermission as sql_variant)
			              WHEN @SortBy = 'Date' THEN Cast(TInner.[Date] as sql_variant)
			              WHEN @SortBy = 'Duration' THEN Cast(TInner.Duration as sql_variant) 
			              WHEN @SortBy = 'PermissionReason' THEN TInner.PermissionReason
						  WHEN @SortBy = 'Review' THEN TInner.Review
			    	 END 
			    END ASC,
			    CASE WHEN @SortDirection = 'DESC' THEN
			         CASE WHEN @SortBy = 'EmployeeName' THEN TInner.EmployeeName
			              WHEN @SortBy = 'DateOfPermission' THEN Cast(TInner.DateOfPermission as sql_variant)
			              WHEN @SortBy = 'Date' THEN Cast(TInner.[Date] as sql_variant)
			              WHEN @SortBy = 'Duration' THEN Cast(TInner.Duration as sql_variant) 
			              WHEN @SortBy = 'PermissionReason' THEN TInner.PermissionReason
						  WHEN @SortBy = 'Review' THEN TInner.Review
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