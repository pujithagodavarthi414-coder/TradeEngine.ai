-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Get Employee Personal details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
--------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeePersonalDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeePersonalDetails]
(
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy  UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10,
   @IsArchived BIT = NULL,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @IsReporting BIT = NULL,
   @IsPermission BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	      
		  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

		   IF(@SearchText = '') SET @SearchText = NULL
           
		   IF(@PageNo IS NULL) SET @PageNo = 0

		   IF(@PageSize IS NULL) SET @PageSize = 25000

		   IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

		   SET @SearchText = '%'+ @SearchText+'%'

		   IF(@IsReporting = 0 OR @IsReporting IS NULL)
			BEGIN
		   SELECT E.Id EmployeeId,
					 E.UserId,
			         U.FirstName,
					 U.SurName,
					 U.UserName Email,
					 E.MaritalStatusId,
					 E.EmployeeNumber,
					 J.JoinedDate,
					 ES.EmploymentStatusName AS EmploymentType,
					 D.DesignationName AS Designation,
					 MS.MaritalStatus,
					 E.MarriageDate,
					 E.NationalityId,
					 N.NationalityName Nationality,
					 E.GenderId,
					 G.Gender,
					 E.DateofBirth,
					 E.Smoker,
					 E.MilitaryService,
					 E.NickName,
					 E.TaxCode,
			         EB.BranchId,
					 B.BranchName,
					 U.ProfileImage,
					 STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),UR.RoleId))
                          FROM UserRole UR
                               INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                          AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                          WHERE UR.UserId = U.Id
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleId,
                  STUFF((SELECT ',' + RoleName 
					      FROM UserRole UR
						       INNER JOIN [Role] R ON R.Id = UR.RoleId 
							              AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
						  WHERE UR.UserId = U.Id
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
					 U.IsActive,
					 U.TimeZoneId,
					 U.CurrencyId,
					 TZ.TimeZoneName,
					 C.CurrencyName,
					 U.MobileNo,
					 U.IsActiveOnMobile,
					 U.RegisteredDateTime,
					 U.LastConnection,
					 U.[TimeStamp],
					 U.FirstName + ' ' + U.SurName UserName,
					 E.IPNumber,
					 E.MACAddress,
					 CASE WHEN E.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					 STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),EE.EntityId))
                          FROM EmployeeEntity EE 
                          WHERE EE.EmployeeId = E.Id AND EE.InactiveDateTime IS NULL
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS PermittedBranchIds,
					STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),E.EntityName))
                          FROM EmployeeEntity EE 
						       INNER JOIN Entity E On E.Id = EE.EntityId
                          WHERE EE.EmployeeId = E.Id AND EE.InactiveDateTime IS NULL
						  GROUP BY E.EntityName
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS PermittedBranchNames,
					J.DepartmentId,
					 TotalCount = COUNT(1) OVER()
			  FROM  [dbo].[Employee] AS E WITH (NOLOCK)
			        INNER JOIN [User] U ON U.Id = E.UserId --AND U.InactiveDateTime IS NULL
	                INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                           AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                               AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
					LEFT JOIN [Job] J ON J.EmployeeId = E.Id 
					LEFT JOIN EmploymentStatus ES ON ES.Id = J.EmploymentStatusId  AND ES.InactiveDateTime IS NULL
					LEFT JOIN [MaritalStatus] MS ON MS.Id = E.MaritalStatusId  AND MS.InactiveDateTime IS NULL
					LEFT JOIN [EmployeeDesignation] ED ON ED.EmployeeId = E.Id  AND ED.ActiveTo IS NULL
					LEFT JOIN Designation D ON D.Id = ED.DesignationId AND D.InactiveDateTime IS NULL
					LEFT JOIN [Nationality] N ON N.Id = E.NationalityId  AND N.InactiveDateTime IS NULL
					LEFT JOIN [Gender] G ON G.Id = E.GenderId  AND G.InactiveDateTime IS NULL
					LEFT JOIN [Branch] B ON B.Id = EB.BranchId  AND B.InactiveDateTime IS NULL
					--LEFT JOIN [Role] R ON R.Id = U.RoleId  AND R.InactiveDateTime IS NULL
					LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId  AND TZ.InactiveDateTime IS NULL
					LEFT JOIN Currency C ON C.Id = U.CurrencyId AND C.InactiveDateTime IS NULL
			  WHERE  (@EmployeeId IS NULL OR E.Id = @EmployeeId)
					AND U.CompanyId = @CompanyId
					AND (@IsArchived IS NULL OR (@IsArchived = 0 AND U.IsActive = 1 AND U.InactivedateTime IS NULL)
						 OR (@IsArchived = 1 AND U.IsActive = 0 AND U.InactivedateTime IS NOT NULL)
					)
			       AND (@SearchText IS NULL 
				        OR (E.NickName LIKE @SearchText)
					    OR (U.FirstName LIKE @SearchText)
						OR (U.SurName LIKE @SearchText)
						OR (U.UserName LIKE @SearchText))
			  ORDER BY U.FirstName + ' ' +ISNULL(U.SurName,'') ASC

			  OFFSET ((@PageNo - 1) * @PageSize) ROWS

		   FETCH NEXT @PageSize ROWS ONLY
		END

		IF(@IsReporting = 1)
			BEGIN
				IF(@IsPermission = 0)
				BEGIN
				SELECT E.Id EmployeeId,
							 E.UserId,
					         U.FirstName,
							 U.SurName,
							 U.UserName Email,
							 E.MaritalStatusId,
							 E.EmployeeNumber,
							 J.JoinedDate,
							 ES.EmploymentStatusName AS EmploymentType,
							 D.DesignationName AS Designation,
							 MS.MaritalStatus,
							 E.MarriageDate,
							 E.NationalityId,
							 N.NationalityName Nationality,
							 E.GenderId,
							 G.Gender,
							 E.DateofBirth,
							 E.Smoker,
							 E.MilitaryService,
							 E.NickName,
							 E.TaxCode,
					         EB.BranchId,
							 B.BranchName,
							 U.ProfileImage,
							 STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),UR.RoleId))
				               FROM UserRole UR
				                    INNER JOIN [Role] R ON R.Id = UR.RoleId 
				                               AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
				               WHERE UR.UserId = U.Id
				         FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleId,
				       STUFF((SELECT ',' + RoleName 
							      FROM UserRole UR
								       INNER JOIN [Role] R ON R.Id = UR.RoleId 
									              AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
								  WHERE UR.UserId = U.Id
							FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
							 U.IsActive,
							 U.TimeZoneId,
							 U.CurrencyId,
							 TZ.TimeZoneName,
							 C.CurrencyName,
							 U.MobileNo,
							 U.IsActiveOnMobile,
							 U.RegisteredDateTime,
							 U.LastConnection,
							 U.[TimeStamp],
							 U.FirstName + ' ' + U.SurName UserName,
							 E.IPNumber,
							 E.MACAddress,
							 CASE WHEN E.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
							 STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),EE.EntityId))
				               FROM EmployeeEntity EE 
				               WHERE EE.EmployeeId = E.Id AND EE.InactiveDateTime IS NULL
				         FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS PermittedBranchIds,
							STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),E.EntityName))
				               FROM EmployeeEntity EE 
								       INNER JOIN Entity E On E.Id = EE.EntityId
				               WHERE EE.EmployeeId = E.Id AND EE.InactiveDateTime IS NULL
								  GROUP BY E.EntityName
				         FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS PermittedBranchNames,
							J.DepartmentId,
							 TotalCount = COUNT(1) OVER()
					  FROM  [dbo].[Employee] AS E WITH (NOLOCK)
							INNER JOIN (SELECT ChildId AS Child 
									FROM Ufn_GetEmployeeReportedMembers(@OperationsPerformedBy,@CompanyId)
									GROUP BY ChildId) T ON T.Child = E.UserId 
					        INNER JOIN [User] U ON U.Id = E.UserId --AND U.InactiveDateTime IS NULL
							INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
				                    AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				                    AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							LEFT JOIN [Job] J ON J.EmployeeId = E.Id 
							LEFT JOIN EmploymentStatus ES ON ES.Id = J.EmploymentStatusId  AND ES.InactiveDateTime IS NULL
							LEFT JOIN [MaritalStatus] MS ON MS.Id = E.MaritalStatusId  AND MS.InactiveDateTime IS NULL
							LEFT JOIN [EmployeeDesignation] ED ON ED.EmployeeId = E.Id  AND ED.ActiveTo IS NULL
							LEFT JOIN Designation D ON D.Id = ED.DesignationId AND D.InactiveDateTime IS NULL
							LEFT JOIN [Nationality] N ON N.Id = E.NationalityId  AND N.InactiveDateTime IS NULL
							LEFT JOIN [Gender] G ON G.Id = E.GenderId  AND G.InactiveDateTime IS NULL
							LEFT JOIN [Branch] B ON B.Id = EB.BranchId  AND B.InactiveDateTime IS NULL
							--LEFT JOIN [Role] R ON R.Id = U.RoleId  AND R.InactiveDateTime IS NULL
							LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId  AND TZ.InactiveDateTime IS NULL
							LEFT JOIN Currency C ON C.Id = U.CurrencyId AND C.InactiveDateTime IS NULL
					  WHERE  (@EmployeeId IS NULL OR E.Id = @EmployeeId)
							AND U.CompanyId = @CompanyId
							AND (@IsArchived IS NULL OR (@IsArchived = 0 AND U.IsActive = 1 AND U.InactivedateTime IS NULL)
							 OR (@IsArchived = 1 AND U.IsActive = 0 AND U.InactivedateTime IS NOT NULL)
							)
					       AND (@SearchText IS NULL 
						        OR (E.NickName LIKE @SearchText)
							    OR (U.FirstName LIKE @SearchText)
								OR (U.SurName LIKE @SearchText)
								OR (U.UserName LIKE @SearchText))
					  ORDER BY U.FirstName + ' ' +ISNULL(U.SurName,'') ASC

					  OFFSET ((@PageNo - 1) * @PageSize) ROWS

		   FETCH NEXT @PageSize ROWS ONLY
		   END
		   IF(@IsPermission = 1)
		   BEGIN
		   SELECT E.Id EmployeeId,
							 E.UserId,
					         U.FirstName,
							 U.SurName,
							 U.UserName Email,
							 E.MaritalStatusId,
							 E.EmployeeNumber,
							 J.JoinedDate,
							 ES.EmploymentStatusName AS EmploymentType,
							 D.DesignationName AS Designation,
							 MS.MaritalStatus,
							 E.MarriageDate,
							 E.NationalityId,
							 N.NationalityName Nationality,
							 E.GenderId,
							 G.Gender,
							 E.DateofBirth,
							 E.Smoker,
							 E.MilitaryService,
							 E.NickName,
							 E.TaxCode,
					         EB.BranchId,
							 B.BranchName,
							 U.ProfileImage,
							 STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),UR.RoleId))
				               FROM UserRole UR
				                    INNER JOIN [Role] R ON R.Id = UR.RoleId 
				                               AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
				               WHERE UR.UserId = U.Id
				         FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleId,
				       STUFF((SELECT ',' + RoleName 
							      FROM UserRole UR
								       INNER JOIN [Role] R ON R.Id = UR.RoleId 
									              AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
								  WHERE UR.UserId = U.Id
							FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
							 U.IsActive,
							 U.TimeZoneId,
							 U.CurrencyId,
							 TZ.TimeZoneName,
							 C.CurrencyName,
							 U.MobileNo,
							 U.IsActiveOnMobile,
							 U.RegisteredDateTime,
							 U.LastConnection,
							 U.[TimeStamp],
							 U.FirstName + ' ' + U.SurName UserName,
							 E.IPNumber,
							 E.MACAddress,
							 CASE WHEN E.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
							 STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),EE.EntityId))
				               FROM EmployeeEntity EE 
				               WHERE EE.EmployeeId = E.Id AND EE.InactiveDateTime IS NULL
				         FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS PermittedBranchIds,
							STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),E.EntityName))
				               FROM EmployeeEntity EE 
								       INNER JOIN Entity E On E.Id = EE.EntityId
				               WHERE EE.EmployeeId = E.Id AND EE.InactiveDateTime IS NULL
								  GROUP BY E.EntityName
				         FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS PermittedBranchNames,
							J.DepartmentId,
							 TotalCount = COUNT(1) OVER()
					  FROM  [dbo].[Employee] AS E WITH (NOLOCK)
							--INNER JOIN (SELECT ChildId AS Child 
							--		FROM Ufn_GetEmployeeReportedMembers(@OperationsPerformedBy,@CompanyId)
							--		GROUP BY ChildId) T ON T.Child = E.UserId 
					        INNER JOIN [User] U ON U.Id = E.UserId --AND U.InactiveDateTime IS NULL
							INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
				                    AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				                    AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
							LEFT JOIN [Job] J ON J.EmployeeId = E.Id 
							LEFT JOIN EmploymentStatus ES ON ES.Id = J.EmploymentStatusId  AND ES.InactiveDateTime IS NULL
							LEFT JOIN [MaritalStatus] MS ON MS.Id = E.MaritalStatusId  AND MS.InactiveDateTime IS NULL
							LEFT JOIN [EmployeeDesignation] ED ON ED.EmployeeId = E.Id  AND ED.ActiveTo IS NULL
							LEFT JOIN Designation D ON D.Id = ED.DesignationId AND D.InactiveDateTime IS NULL
							LEFT JOIN [Nationality] N ON N.Id = E.NationalityId  AND N.InactiveDateTime IS NULL
							LEFT JOIN [Gender] G ON G.Id = E.GenderId  AND G.InactiveDateTime IS NULL
							LEFT JOIN [Branch] B ON B.Id = EB.BranchId  AND B.InactiveDateTime IS NULL
							--LEFT JOIN [Role] R ON R.Id = U.RoleId  AND R.InactiveDateTime IS NULL
							LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId  AND TZ.InactiveDateTime IS NULL
							LEFT JOIN Currency C ON C.Id = U.CurrencyId AND C.InactiveDateTime IS NULL
					  WHERE  (@EmployeeId IS NULL OR E.Id = @EmployeeId)
							AND U.CompanyId = @CompanyId
							AND (@IsArchived IS NULL OR (@IsArchived = 0 AND U.IsActive = 1 AND U.InactivedateTime IS NULL)
							 OR (@IsArchived = 1 AND U.IsActive = 0 AND U.InactivedateTime IS NOT NULL)
							)
					       AND (@SearchText IS NULL 
						        OR (E.NickName LIKE @SearchText)
							    OR (U.FirstName LIKE @SearchText)
								OR (U.SurName LIKE @SearchText)
								OR (U.UserName LIKE @SearchText))
						   AND (EB.EmployeeId IN (SELECT EmployeeId
						   FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy)))
					  ORDER BY U.FirstName + ' ' +ISNULL(U.SurName,'') ASC

					  OFFSET ((@PageNo - 1) * @PageSize) ROWS
		   END
		END
		 END
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END