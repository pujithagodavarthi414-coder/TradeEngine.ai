--EXEC USP_GetAllEmployeeRateTagConfigurations '',''
CREATE PROCEDURE [dbo].[USP_GetAllEmployeeRateTagConfigurations]
(
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = '1'

		IF (@HavePermission = '1')
		BEGIN
		
		   DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE)

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @IsPermanent BIT = (SELECT ES.ISPermanent FROM Job J 
		                                         JOIN EmploymentStatus ES ON ES.Id = J.EmploymentStatusId AND ES.InActiveDateTime IS NULL
												 WHERE J.EmployeeId = @EmployeeId
												 AND ES.CompanyId = @CompanyId
												 AND J.InActiveDateTime IS NULL)
       	   
		   SELECT * FROM (
           SELECT RTC.RateTagEmployeeId,
				  RTC.RateTagStartDate StartDate,
				  RTC.RateTagEndDate EndDate,
				  0 AS IsInHerited,
				  NULL AS RateTagRoleBranchConfigurationId,
				  U.FirstName + ' ' + ISNULL(U.SurName,'') EmployeeName,
				  RTC.RoleId,
				  RTC.BranchId,
				  R.RoleName, 
				  B.BranchName, 
				  RTC.[GroupPriority] [Priority]
           FROM [dbo].[EmployeeRateTag] AS RTC 
		   INNER JOIN Employee E ON E.Id = RTC.RateTagEmployeeId
		   INNER JOIN [USER] U ON U.Id = E.UserId and U.InActiveDateTime IS NULL AND U.IsActive = 1
		   LEFT JOIN SYS_Currency C ON C.Id = RTC.RateTagCurrencyId 
		   LEFT JOIN Branch B ON B.Id = RTC.BranchId
		   LEFT JOIN UserRole UR ON UR.RoleId = RTC.RoleId AND UR.InActiveDateTime IS NULL 
		   LEFT JOIN [Role] R ON R.Id = UR.RoleId
           WHERE U.CompanyId = @CompanyId AND CONVERT(DATE, RTC.RateTagEndDate) >= CONVERT(DATE, GETDATE())
				AND (@EmployeeId IS NULL OR RTC.RateTagEmployeeId = @EmployeeId)				
				AND RTC.InActiveDateTime IS NULL

			UNION

			SELECT NULL RateTagEmployeeId,				 
				  RTRBC.StartDate,
				  RTRBC.EndDate,				
				  1 AS IsInHerited,
				  RTRBC.Id AS RateTagRoleBranchConfigurationId,
				  NULL EmployeeName,
				  RTRBC.RoleId,
				  RTRBC.BranchId,
				  NULL RoleName, 
				  B.BranchName, 
				  RTRBC.[Priority]
           FROM [dbo].RateTagRoleBranchConfiguration AS RTRBC 
		   INNER JOIN EmployeeBranch EB ON EB.BranchId = RTRBC.BranchId
		              AND ((ActiveTo IS NOT NULL AND @CurrentDate BETWEEN ActiveFrom AND ActiveTo)
	  						OR (ActiveTo IS NULL AND @CurrentDate >= CONVERT(DATE, ActiveFrom))
							OR (ActiveTo IS NOT NULL AND @CurrentDate <= CONVERT(DATE, ActiveTo))
	  			          )
		   INNER JOIN Employee E ON E.Id = EB.EmployeeId
		   INNER JOIN Branch B ON B.Id = EB.BranchId
           WHERE RTRBC.CompanyId = @CompanyId 
		        AND @IsPermanent = 0
		        AND CONVERT(DATE, RTRBC.EndDate) >= CONVERT(DATE, GETDATE()) AND RTRBC.BranchId IS NOT NULL AND RTRBC.RoleId IS NULL
				AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)				
				AND RTRBC.InActiveDateTime IS NULL
				AND ((RTRBC.StartDate NOT IN (SELECT RateTagStartDate FROM EmployeeRateTag WHERE RateTagEmployeeId = @EmployeeId AND InActiveDateTime IS NULL)) 
		               OR (RTRBC.EndDate NOT IN (SELECT RateTagEndDate FROM EmployeeRateTag WHERE RateTagEmployeeId = @EmployeeId AND InActiveDateTime IS NULL)))
		   
		   UNION

		SELECT NULL RateTagEmployeeId,	
				  RTRBC.StartDate,
				  RTRBC.EndDate,				 
				  1 AS IsInHerited,
				  RTRBC.Id AS RateTagRoleBranchConfigurationId,
				  NULL EmployeeName,
				  RTRBC.RoleId,
				  RTRBC.BranchId,
				  R.RoleName, 
				  NULL BranchName, 
				  RTRBC.[Priority]
           FROM [dbo].RateTagRoleBranchConfiguration AS RTRBC 
		   INNER JOIN UserRole UR ON UR.RoleId = RTRBC.RoleId AND UR.InActiveDateTime IS NULL 
		   INNER JOIN [USER] U ON U.Id = UR.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		   INNER JOIN Employee E ON E.UserId = U.Id
		   INNER JOIN [Role] R ON R.Id = UR.RoleId
           WHERE RTRBC.CompanyId = @CompanyId AND @IsPermanent = 0 
		        AND CONVERT(DATE, RTRBC.EndDate) >= CONVERT(DATE, GETDATE()) AND RTRBC.RoleId IS NOT NULL AND RTRBC.BranchId IS NULL
				AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)				
				AND RTRBC.InActiveDateTime IS NULL
				AND ((RTRBC.StartDate NOT IN (SELECT RateTagStartDate FROM EmployeeRateTag WHERE RateTagEmployeeId = @EmployeeId AND InActiveDateTime IS NULL)) 
		               OR (RTRBC.EndDate NOT IN (SELECT RateTagEndDate FROM EmployeeRateTag WHERE RateTagEmployeeId = @EmployeeId AND InActiveDateTime IS NULL)))

			UNION

            SELECT NULL RateTagEmployeeId,	
				  RTRBC.StartDate,
				  RTRBC.EndDate,						 
				  1 AS IsInHerited,
				  RTRBC.Id AS RateTagRoleBranchConfigurationId,
				  NULL EmployeeName,
				  RTRBC.RoleId,
				  RTRBC.BranchId,
				  R.RoleName, 
				  B.BranchName, 
				  RTRBC.[Priority]
            FROM [dbo].RateTagRoleBranchConfiguration AS RTRBC 
		    INNER JOIN EmployeeBranch EB ON EB.BranchId = RTRBC.BranchId
		                    AND ((ActiveTo IS NOT NULL AND @CurrentDate BETWEEN ActiveFrom AND ActiveTo)
	  		 				OR (ActiveTo IS NULL AND @CurrentDate >= CONVERT(DATE, ActiveFrom))
			 				OR (ActiveTo IS NOT NULL AND @CurrentDate <= CONVERT(DATE, ActiveTo))
	  		 	          )
		    INNER JOIN Employee E ON E.Id = EB.EmployeeId
		    INNER JOIN [USER] U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
		    INNER JOIN UserRole UR ON UR.RoleId = RTRBC.RoleId AND UR.UserId = U.Id  AND UR.InActiveDateTime IS NULL 
			INNER JOIN [Role] R ON R.Id = UR.RoleId
			 INNER JOIN Branch B ON B.Id = EB.BranchId
            WHERE RTRBC.CompanyId = @CompanyId AND @IsPermanent = 0 
		        AND CONVERT(DATE, RTRBC.EndDate) >= CONVERT(DATE, GETDATE()) AND RTRBC.BranchId IS NOT NULL AND RTRBC.RoleId IS NOT NULL
				AND (@EmployeeId IS NULL OR E.Id = @EmployeeId)				
				AND RTRBC.InActiveDateTime IS NULL
				AND ((RTRBC.StartDate NOT IN (SELECT RateTagStartDate FROM EmployeeRateTag WHERE RateTagEmployeeId = @EmployeeId AND InActiveDateTime IS NULL)) 
		               OR (RTRBC.EndDate NOT IN (SELECT RateTagEndDate FROM EmployeeRateTag WHERE RateTagEmployeeId = @EmployeeId AND InActiveDateTime IS NULL)))
				
			  UNION 	 
				
			 SELECT NULL RateTagEmployeeId,				 
				    RTRBC.StartDate,
				    RTRBC.EndDate,				
				    1 AS IsInHerited,
				    RTRBC.Id AS RateTagRoleBranchConfigurationId,
					NULL EmployeeName,
				    RTRBC.RoleId,
				    RTRBC.BranchId,
					NULL RoleName, 
				    NULL BranchName, 
				    RTRBC.[Priority]
           FROM [dbo].RateTagRoleBranchConfiguration AS RTRBC 
           WHERE RTRBC.CompanyId = @CompanyId 
		        AND @IsPermanent = 0 
		        AND CONVERT(DATE, RTRBC.EndDate) >= CONVERT(DATE, GETDATE()) AND RTRBC.BranchId IS NULL AND RTRBC.RoleId IS NULL
				AND RTRBC.InActiveDateTime IS NULL
				AND ((RTRBC.StartDate NOT IN (SELECT RateTagStartDate FROM EmployeeRateTag WHERE RateTagEmployeeId = @EmployeeId AND InActiveDateTime IS NULL)) 
		               OR (RTRBC.EndDate NOT IN (SELECT RateTagEndDate FROM EmployeeRateTag WHERE RateTagEmployeeId = @EmployeeId AND InActiveDateTime IS NULL)))
			) T
			GROUP BY  StartDate,
				      EndDate,
					  RateTagEmployeeId,
				      IsInHerited,
				      RateTagRoleBranchConfigurationId,
				      EmployeeName,
				      RoleId,
				      BranchId,
				      RoleName, 
				      BranchName, 
				      [Priority]
			ORDER BY RateTagEmployeeId,StartDate,EndDate		

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