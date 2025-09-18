CREATE PROCEDURE [dbo].[USP_GetAllEmployees]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @UserId UNIQUEIDENTIFIER = NULL,
   @EmailSearchText NVARCHAR(250) = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER ,
   @DepartmentId UNIQUEIDENTIFIER = NULL,
   @LineManagerId UNIQUEIDENTIFIER = NULL,
   @EmploymentStatusId UNIQUEIDENTIFIER = NULL,
   @DesignationId UNIQUEIDENTIFIER = NULL,
   @ShiftTimingId UNIQUEIDENTIFIER = NULL,
   @SearchText NVARCHAR(250) = NULL,
   @IsTerminated BIT = NULL,
   @IsActive BIT = NULL,
   @SortDirection NVARCHAR(100) = NULL,
   @SortBy NVARCHAR(100) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @IsArchived BIT = NULL,
   @IsReportTo BIT = NULL,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @PayRollTemplateId UNIQUEIDENTIFIER = NULL
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

              IF(@IsReportTo IS NULL) SET @IsReportTo = 0

              SET @SearchText = '%'+ RTRIM(LTRIM(@SearchText)) +'%'

              SET @EmailSearchText = '%'+ RTRIM(LTRIM(@EmailSearchText))+'%'

              DECLARE @CanViewAllEmployees BIT = (CASE WHEN EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) 
		                                                        AND FeatureId IN(SELECT TOP 1 Id FROM Feature WHERE FeatureName = 'view all employees') AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)          
		      DROP TABLE IF EXISTS #Employees   
              CREATE TABLE #Employees(EmployeeId UNIQUEIDENTIFIER)

		      IF(@CanViewAllEmployees = 1)
		      BEGIN
			      INSERT INTO #Employees(EmployeeId)
			      SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy)
		      END
              ELSE
		      BEGIN
		          INSERT INTO #Employees(EmployeeId)
			      SELECT EmployeeId FROM [dbo].[Ufn_GetEmployeeBranchReportedMembers](@OperationsPerformedBy, @CompanyId)
		      END

			 IF(@SortBy IS NULL)
			 BEGIN

 SET @SortBy = 'UserName'

 END

 IF(@SortDirection IS NULL)
 BEGIN

 SET @SortDirection = 'ASC'

 END
 

           SELECT E.Id EmployeeId,
                     E.UserId,
                     U.FirstName,
                     U.SurName,
                     U.FirstName + ' ' + ISNULL(U.SurName,'') UserName,
                     U.UserName Email,
                     E.MaritalStatusId,
                     MS.MaritalStatus,
                     E.MarriageDate,
                     E.IPNumber,
                     E.NationalityId,
                     N.NationalityName Nationality,
                     E.GenderId,
                     G.Gender,
                     E.DateofBirth,
                     E.Smoker,
                     E.MilitaryService,
                     E.NickName,
                     E.TaxCode,
                     E.MacAddress,
ESH.Id AS EmployeeShiftId,
E.TrackEmployee,
                     EB.BranchId,
                     B.BranchName,
                     U.ProfileImage,
                     E.FormJson AS FormData,
                     --U.RoleId,
                     STUFF((SELECT ',' + RoleName
     FROM UserRole UR
      INNER JOIN [Role] R ON R.Id = UR.RoleId
             AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
 WHERE UR.UserId = U.Id
                          ORDER BY RoleName
FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
STUFF((SELECT ',' + LOWER(UR.RoleId)
     FROM UserRole UR
      INNER JOIN [Role] R ON R.Id = UR.RoleId
             AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
 WHERE UR.UserId = U.Id
                          ORDER BY RoleName
FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleId,
                     U.IsActive,
                     U.TimeZoneId,
                     TZ.TimeZoneName,
                     U.MobileNo,
                     U.IsActiveOnMobile,
                     U.RegisteredDateTime,
                     U.LastConnection,
                     E.[TimeStamp],
                     E.EmployeeNumber,
                     E.CreatedDateTime,
                     E.CreatedByUserId,
                     J.DepartmentId,
                     D.DepartmentName,
                     J.EmploymentStatusId,
                     ES.EmploymentStatusName,
                     DD.DesignationName,
                     DD.Id DesignationId,
                     J.JobCategoryId,
                     JC.JobCategoryType,
                     J.JoinedDate DateOfJoining,  
ATU.Id AS ActivityTrackerUserId,
ATU.ActivityTrackerAppUrlTypeId,
ATU.ScreenShotFrequency,
ATU.Multiplier,
ATU.IsTrack,
ATU.IsScreenshot,
ATU.IsKeyboardTracking,
ATU.IsMouseTracking,
ATU.TimeStamp AS ATUTimeStamp,
                     CASE WHEN E.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
ISNULL(ST.[ShiftName],ST1.[ShiftName]) [Shift],
ISNULL(ESH.ShiftTimingId,ES1.ShiftTimingId) AS ShiftTimingId,
ISNULL(ESH.ActiveFrom,ES1.ActiveFrom) AS ActiveFrom,
ISNULL(ESH.ActiveTo,ES1.ActiveTo) AS ActiveTo,
U.CurrencyId,
                     STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),EE.EntityId))
                          FROM EmployeeEntity EE
                          WHERE EE.EmployeeId = E.Id AND EE.InactiveDateTime IS NULL
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS PermittedBranchIds,
STUFF((SELECT ',' + Entity.EntityName
                          FROM EmployeeEntity EE
      INNER JOIN Entity Entity ON Entity.Id = EE.EntityId
                          WHERE EE.EmployeeId = E.Id AND EE.InactiveDateTime IS NULL
 GROUP BY Entity.EntityName
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS PermittedBranchNames,
                     STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),EB.BusinessUnitId))
                          FROM BusinessUnitEmployeeConfiguration EB
                          WHERE EB.EmployeeId = E.Id 
                                AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE())
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS BusinessUnitIds,
STUFF((SELECT ',' + BU.BusinessUnitName
                          FROM BusinessUnitEmployeeConfiguration EB
                               INNER JOIN BusinessUnit BU ON BU.Id = EB.BusinessUnitId
                          WHERE EB.EmployeeId = E.Id 
                                AND EB.ActiveFrom <= GETDATE() AND (EB.ActiveTo IS NULL OR EB.ActiveTo >= GETDATE())
 GROUP BY BU.BusinessUnitName
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS BusinessUnitNames,
                     TotalCount = COUNT(1) OVER()
              FROM  [dbo].[Employee] AS E WITH (NOLOCK)
               INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
                               AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)
                          AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                    AND (@IsReportTo = 1 OR 
                    (@IsReportTo = 0 
                     --AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                     AND EB.EmployeeId IN (SELECT EmployeeId FROM #Employees)
                     ))
                    AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                    INNER JOIN [User] U ON U.Id = E.UserId
AND (@IsActive IS NULL
                                  OR (@IsActive= 1 AND U.IsActive = 1)
                                  OR (@IsActive = 0 AND U.IsActive = 0))
 AND (E.UserId = @UserId OR @UserId IS NULL)
                    LEFT JOIN [dbo].[Job] J ON J.EmployeeId = E.Id
                    LEFT JOIN [Designation] DD ON DD.Id = J.DesignationId
                    LEFT JOIN [dbo].[Department] D ON D.Id = J.DepartmentId
                    LEFT JOIN [dbo].[EmploymentStatus] ES ON ES.Id = J.EmploymentStatusId
                    LEFT JOIN [dbo].[JobCategory] JC ON JC.Id = J.JobCategoryId
                    LEFT JOIN [MaritalStatus] MS ON MS.Id = E.MaritalStatusId
                    LEFT JOIN [Nationality] N ON N.Id = E.NationalityId
                    LEFT JOIN [Gender] G ON G.Id = E.GenderId
                    LEFT JOIN [Branch] B ON B.Id = EB.BranchId AND B.InactiveDateTime IS NULL --AND B.RegionId IS NOT NULL
LEFT JOIN [EmployeeShift] ESH ON ESH.EmployeeId = E.Id AND ESH.InActiveDateTime IS NULL AND
((CONVERT(DATE,ESH.ActiveFrom) <= CONVERT(DATE,GETDATE())
AND ((ESH.ActiveTo IS NULL OR CONVERT(DATE,ESH.ActiveTo) >= CONVERT(DATE,GETDATE())) OR CONVERT(DATE,ESH.ActiveFrom) >= CONVERT(DATE,GETDATE()))))
LEFT JOIN [ShiftTiming] ST ON ST.Id = ESH.ShiftTimingId AND ST.InactiveDateTime IS NULL
                    --LEFT JOIN [Role] R ON R.Id = U.RoleId AND R.InActiveDateTime IS NULL
                    LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId AND TZ.InActiveDateTime IS NULL
                    LEFT JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL AND @LinemanagerId IS NOT NULL
LEFT JOIN (SELECT EmployeeId,MIN(ActiveFrom) AS ShiftActiveFrom FROM EmployeeShift WHERE ActiveFrom >= GETDATE() AND InActiveDateTime IS NULL GROUP BY EmployeeId) T ON T.EmployeeId = E.Id
LEFT JOIN EmployeeShift ES1 ON ES1.EmployeeId = T.EmployeeId AND ES1.ActiveFrom = T.ShiftActiveFrom
LEFT JOIN ShiftTiming ST1 ON ST1.Id = ES1.ShiftTimingId AND ST1.InactiveDateTime IS NULL
LEFT JOIN ActivityTrackerUserConfiguration AS ATU ON ATU.UserId = U.Id
               WHERE U.CompanyId = @CompanyId
                     AND (@SearchText IS NULL
                        OR  (U.FirstName + ' ' + ISNULL(U.SurName,'') LIKE @SearchText))
                        AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
AND (@ShiftTimingId IS NULL OR ST.Id = @ShiftTimingId)
                        AND (J.DepartmentId = @DepartmentId OR @DepartmentId IS NULL)
                        AND (J.DesignationId = @DesignationId OR @DesignationId IS NULL)
AND (@PayRollTemplateId IS NULL OR @PayRollTemplateId IN
         (SELECT EPC.PayrollTemplateId FROM EmployeeSalary ESR
                 LEFT JOIN EmployeepayrollConfiguration EPC ON EPC.SalaryId = ESR.Id
             WHERE ESR.InActiveDateTime IS NULL
 AND ESR.EmployeeId = E.Id
             AND ((CONVERT(DATE,ESR.ActiveFrom) <= CONVERT(DATE,GETDATE())
             AND (ESR.ActiveTo IS NULL OR CONVERT(DATE,ESR.ActiveTo) >= CONVERT(DATE,GETDATE()))
             OR CONVERT(DATE,ESR.ActiveFrom) >= CONVERT(DATE,GETDATE()))
             OR CONVERT(DATE,ESR.ActiveFrom) > CONVERT(DATE,GETDATE()))
             GROUP BY ESR.EmployeeId,EPC.PayrollTemplateId))
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
WHEN @SortBy = 'UserName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
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
 WHEN @SortBy = 'UserName' THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
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