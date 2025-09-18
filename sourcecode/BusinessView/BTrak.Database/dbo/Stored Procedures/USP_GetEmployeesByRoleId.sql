CREATE PROCEDURE [dbo].[USP_GetEmployeesByRoleId]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@RoleIdsXml XML = NULL
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
             
			  
			  CREATE TABLE #RoleIds
			  (
					Id UNIQUEIDENTIFIER
			  )
				IF(@RoleIdsXml IS NOT NULL) 
          BEGIN
            INSERT INTO #RoleIds(Id)
            SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
            FROM @RoleIdsXml.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
          END
           SELECT E.Id EmployeeId,
                     E.UserId,
                     U.FirstName,
					 U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
                     U.SurName,
                     U.UserName Email,
                     B.BranchName,
                     U.ProfileImage,
                     E.EmployeeNumber,
					 UR.RoleId,
                     R.RoleName
					
              FROM  [dbo].[Employee] AS E WITH (NOLOCK)
	                INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id 
	                           AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                    INNER JOIN [User] U ON U.Id = E.UserId 
					INNER JOIN [UserRole] UR ON UR.UserId = U.Id
                    INNER JOIN [Role] R ON R.Id = UR.RoleId  AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                    INNER JOIN #RoleIds RInner ON RInner.Id = R.Id
					--INNER JOIN (SELECT UR.UserId  FROM  [UserRole] UR INNER JOIN [Role] R ON R.Id = UR.RoleId  AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
					--INNER JOIN #RoleIds RInner ON RInner.Id = R.Id  GROUP BY UserId)R ON  R.UserId = U.Id
                    LEFT JOIN [Branch] B ON B.Id = EB.BranchId AND B.InactiveDateTime IS NULL
					LEFT JOIN [EmployeeShift] ESH ON ESH.EmployeeId = E.Id AND ESH.InActiveDateTime IS NULL 
					          AND ((CONVERT(DATE,ESH.ActiveFrom) <= CONVERT(DATE,GETDATE()) 
							  AND (ESH.ActiveTo IS NULL OR CONVERT(DATE,ESH.ActiveTo) >= CONVERT(DATE,GETDATE())) 
							       OR CONVERT(DATE,ESH.ActiveFrom) >= CONVERT(DATE,GETDATE())) 
								   OR CONVERT(DATE,ESH.ActiveFrom) > CONVERT(DATE,GETDATE()))
                    LEFT JOIN [ShiftTiming] ST ON ST.Id = ESH.ShiftTimingId AND ST.InactiveDateTime IS NULL
                    LEFT JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL
					LEFT JOIN (SELECT EmployeeId,MIN(ActiveFrom) AS ShiftActiveFrom FROM EmployeeShift WHERE ActiveFrom >= GETDATE() AND InActiveDateTime IS NULL GROUP BY EmployeeId) T ON T.EmployeeId = E.Id
					LEFT JOIN EmployeeShift ES1 ON ES1.EmployeeId = T.EmployeeId AND ES1.ActiveFrom = T.ShiftActiveFrom
					LEFT JOIN ShiftTiming ST1 ON ST1.Id = ES1.ShiftTimingId AND ST.InactiveDateTime IS NULL
					LEFT JOIN ActivityTrackerUserConfiguration AS ATU ON ATU.UserId = U.Id
               WHERE U.CompanyId = @CompanyId 
			         AND (U.IsActive = 1 AND U.InActiveDateTime IS NULL)
					 --AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
             
             
        END
        ELSE

            RAISERROR(@HavePermission,16,1)

     END TRY  
     BEGIN CATCH 
        
           THROW
    END CATCH
END
