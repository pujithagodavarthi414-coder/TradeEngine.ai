	-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-22 00:00:00.000'
-- Purpose      To Get Employee details By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployees] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetAllEmployeeDetails]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @UserId UNIQUEIDENTIFIER = NULL,
   @EmailSearchText NVARCHAR(250) = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @DepartmentId UNIQUEIDENTIFIER = NULL,
   @LineManagerId UNIQUEIDENTIFIER = NULL,
   @EmploymentStatusId UNIQUEIDENTIFIER = NULL,
   @DesignationId UNIQUEIDENTIFIER = NULL,
   @ShiftTimingId UNIQUEIDENTIFIER = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @IsTerminated BIT = NULL,
   @SortDirection NVARCHAR(100) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @IsArchived BIT = NULL,
   @IsReportTo BIT = NULL,
   @EntityId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        
        DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN

              IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

              DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
              
              IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
              
              IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

              IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

              IF(@SearchText = '') SET @SearchText = NULL

              IF(@EmailSearchText = '') SET @EmailSearchText = NULL

              IF(@IsReportTo IS NULL) SET @IsReportTo = 0

              SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

              SET @EmailSearchText = '%'+ RTRIM(LTRIM(@EmailSearchText))+'%'

           SELECT E.Id EmployeeId,
                     E.UserId,
                     U.FirstName,
                     U.SurName,
                     U.UserName Email,
                     B.BranchName,
                     U.ProfileImage,
                     U.RegisteredDateTime,
                     U.LastConnection,
                     E.EmployeeNumber,
                     E.CreatedDateTime,
                     E.CreatedByUserId,
                     D.DepartmentName,
                     ES.EmploymentStatusName,
                     DD.DesignationName,
                     JC.JobCategoryType,
                     J.JoinedDate DateOfJoining,   
					 ISNULL(ST.[ShiftName],ST1.[ShiftName]) [Shift],
					 ISNULL(ESH.ShiftTimingId,ES1.ShiftTimingId) AS ShiftTimingId,
					 ISNULL(ESH.ActiveFrom,ES1.ActiveFrom) AS ActiveFrom,
					 ISNULL(ESH.ActiveTo,ES1.ActiveTo) AS ActiveTo,
                     TotalCount = COUNT(1) OVER()
              FROM  [dbo].[Employee] AS E WITH (NOLOCK)
			  INNER JOIN [User] U ON U.Id = E.UserId 
					      AND U.IsActive = 1 AND U.InActiveDateTime IS NULL 
						  AND (E.UserId = @UserId OR @UserId IS NULL)
	                INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
                               AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
	                           AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
	               		       AND (@IsReportTo = 1 OR (@IsReportTo = 0 AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))))
                               AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                    LEFT JOIN [dbo].[Job] J ON J.EmployeeId = E.Id
                    LEFT JOIN [Designation] DD ON DD.Id = J.DesignationId
                    LEFT JOIN [dbo].[Department] D ON D.Id = J.DepartmentId
                    LEFT JOIN [dbo].[EmploymentStatus] ES ON ES.Id = J.EmploymentStatusId
                    LEFT JOIN [dbo].[JobCategory] JC ON JC.Id = J.JobCategoryId
                    LEFT JOIN [Branch] B ON B.Id = EB.BranchId AND B.InactiveDateTime IS NULL
					LEFT JOIN [EmployeeShift] ESH ON ESH.EmployeeId = E.Id AND ESH.InActiveDateTime IS NULL AND ((CONVERT(DATE,ESH.ActiveFrom) <= CONVERT(DATE,GETDATE()) AND (ESH.ActiveTo IS NULL OR CONVERT(DATE,ESH.ActiveTo) >= CONVERT(DATE,GETDATE())) OR CONVERT(DATE,ESH.ActiveFrom) >= CONVERT(DATE,GETDATE())) OR
																						                         CONVERT(DATE,ESH.ActiveFrom) > CONVERT(DATE,GETDATE()))
                    LEFT JOIN [ShiftTiming] ST ON ST.Id = ESH.ShiftTimingId AND ST.InactiveDateTime IS NULL
                    LEFT JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL AND @LinemanagerId IS NOT NULL 
					LEFT JOIN (SELECT EmployeeId,MIN(ActiveFrom) AS ShiftActiveFrom FROM EmployeeShift WHERE ActiveFrom >= GETDATE() AND InActiveDateTime IS NULL GROUP BY EmployeeId) T ON T.EmployeeId = E.Id
					LEFT JOIN EmployeeShift ES1 ON ES1.EmployeeId = T.EmployeeId AND ES1.ActiveFrom = T.ShiftActiveFrom
					LEFT JOIN ShiftTiming ST1 ON ST1.Id = ES1.ShiftTimingId AND ST.InactiveDateTime IS NULL
               WHERE U.CompanyId = @CompanyId
                     AND (@SearchText IS NULL 
                        OR  (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText))
                        AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
						AND (@ShiftTimingId IS NULL OR ST.Id = @ShiftTimingId)
                        AND (J.DepartmentId = @DepartmentId OR @DepartmentId IS NULL)
                        AND (J.DesignationId = @DesignationId OR @DesignationId IS NULL)
                        AND (J.EmploymentStatusId = @EmploymentStatusId OR @EmploymentStatusId IS NULL)
                        AND (U.UserName LIKE @EmailSearchText OR @EmailSearchText IS NULL)
                        AND (@IsArchived IS NULL 
						     OR (@IsArchived = 1 AND E.InActiveDateTime IS NOT NULL) 
						     OR (@IsArchived = 0 AND E.InActiveDateTime IS NULL))
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