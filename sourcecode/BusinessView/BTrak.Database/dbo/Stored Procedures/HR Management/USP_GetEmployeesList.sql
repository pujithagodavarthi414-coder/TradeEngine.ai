-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-08-31 00:00:00.000'
-- Purpose      To Get Employees
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_GetEmployeesList] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@SortBy='Designation',@PageSize=1001
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeesList]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @UserId UNIQUEIDENTIFIER = NULL,
   @EmailSearchText NVARCHAR(250) = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER ,
   @DepartmentId UNIQUEIDENTIFIER = NULL,
   @LineManagerId UNIQUEIDENTIFIER = NULL,
   @EmploymentStatusId UNIQUEIDENTIFIER = NULL,
   @DesignationId UNIQUEIDENTIFIER = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @IsActive BIT = NULL,
   @SortDirection NVARCHAR(100) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

              IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

              DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
              
              IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
              
              IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

              IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

              IF(@SearchText = '') SET @SearchText = NULL

              IF(@EmailSearchText = '') SET @EmailSearchText = NULL

              SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

              SET @EmailSearchText = '%'+ RTRIM(LTRIM(@EmailSearchText))+'%'

           SELECT E.Id EmployeeId,
                     E.UserId,
                     U.FirstName,
                     U.SurName,
                     U.UserName Email,
                     B.BranchName,
                     U.ProfileImage,
                     E.EmployeeNumber,
                     D.DepartmentName,
                     ES.EmploymentStatusName,
                     DD.DesignationName,
                     JC.JobCategoryType,
                     J.JoinedDate DateOfJoining,   
					 ISNULL(ST.[ShiftName],ST1.[ShiftName]) [Shift],
					 ATU.Id AS ActivityTrackerUserId,
					 ATU.ActivityTrackerAppUrlTypeId,
					 ATU.ScreenShotFrequency,
					 ATU.Multiplier,
					 ATU.TimeStamp AS ATUTimeStamp,
                     TotalCount = COUNT(1) OVER()
              FROM  [dbo].[Employee] AS E WITH (NOLOCK)
	                INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
                               AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
	                           AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                               AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                    INNER JOIN [User] U ON U.Id = E.UserId 
                    LEFT JOIN [dbo].[Job] J ON J.EmployeeId = E.Id
                    LEFT JOIN [Designation] DD ON DD.Id = J.DesignationId
                    LEFT JOIN [dbo].[Department] D ON D.Id = J.DepartmentId
                    LEFT JOIN [dbo].[EmploymentStatus] ES ON ES.Id = J.EmploymentStatusId
                    LEFT JOIN [dbo].[JobCategory] JC ON JC.Id = J.JobCategoryId
                    LEFT JOIN [Branch] B ON B.Id = EB.BranchId AND B.InactiveDateTime IS NULL
					LEFT JOIN [EmployeeShift] ESH ON ESH.EmployeeId = E.Id AND ESH.InActiveDateTime IS NULL 
					          AND ((CONVERT(DATE,ESH.ActiveFrom) <= CONVERT(DATE,GETDATE()) 
							  AND (ESH.ActiveTo IS NULL OR CONVERT(DATE,ESH.ActiveTo) >= CONVERT(DATE,GETDATE())) 
							       OR CONVERT(DATE,ESH.ActiveFrom) >= CONVERT(DATE,GETDATE())) 
								   OR CONVERT(DATE,ESH.ActiveFrom) > CONVERT(DATE,GETDATE()))
                    LEFT JOIN [ShiftTiming] ST ON ST.Id = ESH.ShiftTimingId AND ST.InactiveDateTime IS NULL
                    --LEFT JOIN [Role] R ON R.Id = U.RoleId AND R.InActiveDateTime IS NULL
                    LEFT JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL AND @LinemanagerId IS NOT NULL 
					LEFT JOIN (SELECT EmployeeId,MIN(ActiveFrom) AS ShiftActiveFrom FROM EmployeeShift WHERE ActiveFrom >= GETDATE() AND InActiveDateTime IS NULL GROUP BY EmployeeId) T ON T.EmployeeId = E.Id
					LEFT JOIN EmployeeShift ES1 ON ES1.EmployeeId = T.EmployeeId AND ES1.ActiveFrom = T.ShiftActiveFrom
					LEFT JOIN ShiftTiming ST1 ON ST1.Id = ES1.ShiftTimingId AND ST.InactiveDateTime IS NULL
					LEFT JOIN ActivityTrackerUserConfiguration AS ATU ON ATU.UserId = U.Id
               WHERE U.CompanyId = @CompanyId
					 AND (E.UserId = @UserId OR @UserId IS NULL)
			         AND (@IsActive IS NULL 
                                        OR (@IsActive= 1 AND (U.IsActive = 1 AND U.InActiveDateTime IS NULL)) 
                                        OR (@IsActive = 0 AND U.IsActive = 0 AND U.InActiveDateTime IS NOT NULL))
                     AND (@SearchText IS NULL 
                        OR  (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText))
                        AND (J.DepartmentId = @DepartmentId OR @DepartmentId IS NULL)
                        AND (J.DesignationId = @DesignationId OR @DesignationId IS NULL)
                        AND (J.EmploymentStatusId = @EmploymentStatusId OR @EmploymentStatusId IS NULL)
                        AND (U.UserName LIKE @EmailSearchText OR @EmailSearchText IS NULL)
                        AND (@LineManagerId IS NULL OR ER.ReportToEmployeeId = @LineManagerId)
              ORDER BY 
                          CASE WHEN( @SortDirection= 'ASC' OR @SortDirection IS NULL ) THEN
                               CASE WHEN (@SortBy IS NULL OR @SortBy = 'FirstName') THEN U.FirstName
                                    WHEN @SortBy = 'SurName' THEN U.SurName
                                    WHEN @SortBy = 'Email' THEN U.UserName
                                    WHEN @SortBy = 'DesignationName' THEN DD.DesignationName
                                    WHEN @SortBy = 'EmploymentStatusName' THEN  ES.EmploymentStatusName 
                                    WHEN @SortBy = 'JobCategoryType' THEN  JC.JobCategoryType 
                                    WHEN @SortBy = 'DepartmentName' THEN D.DepartmentName
									WHEN @SortBy = 'Branch' THEN B.BranchName
									WHEN @SortBy = 'Shift' THEN  ST.[ShiftName]
                                    WHEN @SortBy = 'DateOfJoining' THEN  CAST(J.JoinedDate AS SQL_VARIANT)
									WHEN @SortBy = 'EmployeeNumber' THEN E.EmployeeNumber
									WHEN @SortBy = 'BranchName' THEN B.BranchName
                                END
                            END ASC,
                            CASE WHEN @SortDirection = 'DESC' THEN
                                 CASE WHEN  (@SortBy IS NULL OR @SortBy = 'FirstName') THEN U.FirstName
                                      WHEN @SortBy = 'SurName' THEN U.SurName
                                      WHEN @SortBy = 'Email' THEN U.UserName
                                      WHEN @SortBy = 'DesignationName' THEN DD.DesignationName
                                      WHEN @SortBy = 'EmploymentStatusName' THEN  ES.EmploymentStatusName 
                                      WHEN @SortBy = 'JobCategoryType' THEN  JC.JobCategoryType
                                      WHEN @SortBy = 'DepartmentName' THEN D.DepartmentName 
									  WHEN @SortBy = 'Branch' THEN B.BranchName
									  WHEN @SortBy = 'Shift' THEN  ST.[ShiftName]
                                      WHEN @SortBy = 'DateOfJoining' THEN  CAST(J.JoinedDate AS SQL_VARIANT)
									  WHEN @SortBy = 'EmployeeNumber' THEN E.EmployeeNumber
									  WHEN @SortBy = 'BranchName' THEN B.BranchName
                                   END
                             END DESC
              
               OFFSET ((@PageNo - 1) * @PageSize) ROWS

          FETCH NEXT @PageSize ROWS ONLY
             
        END
        ELSE

            RAISERROR(@HavePermission,16,1)

     END TRY  
     BEGIN CATCH 
        
           THROW
    END CATCH
END
GO