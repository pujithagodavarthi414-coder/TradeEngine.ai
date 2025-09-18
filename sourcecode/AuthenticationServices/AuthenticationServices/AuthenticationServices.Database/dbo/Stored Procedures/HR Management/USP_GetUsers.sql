CREATE PROCEDURE [dbo].[USP_GetUsers]
(
  @UserId UNIQUEIDENTIFIER = NULL,
  @UserName NVARCHAR(250) = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER,
  @RoleId UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(250) = NULL,
  @EmployeeNameText NVARCHAR(250) = NULL, -- To filter based on employee fullname
  @IsUsersPage BIT = NULL,
  @PageNo INT = 1,
  @SortDirection NVARCHAR(250) = NULL,
  @SortBy NVARCHAR(250) = NULL,
  @PageSize INT = 10,
  @IsEmployeeOverviewDetails BIT = NULL,
  @EntityId UNIQUEIDENTIFIER = NULL,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @IsActive BIT = NULL,
  @CompanyId UNIQUEIDENTIFIER,
  @RoleIds NVARCHAR(max)=null
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
        BEGIN

            DECLARE @CompanyLanguage NVARCHAR(250) = (SELECT [Language] FROM Company WHERE Id = @CompanyId)
			IF @RoleIds = '' set @RoleIds = NULL
            IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

            IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL

            IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

            IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
          
            IF(@RoleId = '00000000-0000-0000-0000-000000000000') SET @RoleId = NULL

            IF(@SearchText = '') SET @SearchText = NULL

            IF(@EmployeeNameText = '') SET @EmployeeNameText = NULL
          
            IF(@IsEmployeeOverviewDetails IS NULL) SET @IsEmployeeOverviewDetails = 0

		    IF(@UserId IS NOT NULL AND @IsUsersPage IS NULL) SET @IsUsersPage = 0

		    IF(@UserId IS NOT NULL AND @IsUsersPage = 0)
		    BEGIN
		        SET @IsActive = 1
		    END

		    IF(@UserId IS NOT NULL AND @IsActive IS NULL) SET @IsUsersPage = NULL

            DECLARE @ProductivityIndex FLOAT = 0

		    DECLARE @LeavesTaken FLOAT = 0

		    DECLARE @LeavesApplicable FLOAT = 0

            DECLARE @JoinedDate DATETIME,@FromMonth INT,@ToMonth INT

            DECLARE @DateFrom DATETIME,@DateTo DATETIME

			DECLARE @Temp TABLE
				(Id UNIQUEIDENTIFIER)

					INSERT INTO @Temp(Id)
					SELECT Id FROM dbo.UfnSplit(@RoleIds)


            DECLARE @Time DATETIME = GETUTCDATE()

			DECLARE @Date DATE = GETUTCDATE()

		  	DECLARE @IsSupport BIT = (CASE WHEN (SELECT UserName FROM [User] WHERE Id = @OperationsPerformedBy) = 'Support@snovasys.com' THEN 1 ELSE 0 END)

            SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'



                    SELECT Id
                           ,T.UserId
			               ,CompanyId
			        	   ,FirstName
			        	   ,SurName
			        	   ,Email
			        	   ,[Password]
			        	   ,IsPasswordForceReset
			        	   ,FullName
			        	   ,IsActive
                           ,IsExternal
			        	   ,TimeZoneId
						   ,DesktopId
			        	   ,MobileNo
			        	   ,IsAdmin
			        	   ,IsActiveOnMobile
			        	   ,ProfileImage
			        	   ,RegisteredDateTime
			        	   ,LastConnection
			        	   ,CreatedDateTime
			        	   ,CreatedByUserId
			        	   ,UpdatedDateTime
			        	   ,UpdatedByUserId

                           ,RoleIds
			        	   ,RoleName

                           ,IsDemoDataCleared
			        	   ,[Timestamp]
			        	   ,TotalCount = Count(1)OVER()
			        	   ,[Language]
						   
                            TimeZoneTitle,
                            TimeZoneName,
				            TimeZoneOffset,
				            TimeZone,
				            TimeZoneAbbreviation,
				            CountryCode,
				            CountryName,
                            OffsetMinutes
						    ,CompanyLanguage
            FROM 
            (
            SELECT U.Id AS Id,
                        U.Id AS UserId,
                        UC.CompanyId,
                        U.FirstName,
                        U.SurName,
                        U.UserName AS Email,
                        U.[Password],
                        U.IsPasswordForceReset,
                        U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
                        U.IsActive,
                        U.IsExternal,
                        U.TimeZoneId,
						U.DesktopId,
                        U.MobileNo,
                        U.IsAdmin,
                        U.IsActiveOnMobile,
                        U.ProfileImage,
                        U.RegisteredDateTime,
                        U.LastConnection,
                        U.CreatedDateTime,
                        U.CreatedByUserId,
                        U.UpdatedDateTime,
                        U.UpdatedByUserId,
						U.[Language],
                        TZ.TimeZoneName + ' (' + TZ.TimeZone + ')' AS TimeZoneTitle,
                        TZ.TimeZoneName,
				        TZ.TimeZoneOffset,
				        TZ.TimeZone,
				        TZ.TimeZoneAbbreviation,
				        TZ.CountryCode,
				        TZ.CountryName,
                        TZ.OffsetMinutes,
                        @CompanyLanguage AS CompanyLanguage,

                        STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),UR.RoleId))
                                FROM UserRole UR
                                     INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                                AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                                WHERE UR.UserId = U.Id
                                ORDER BY RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleIds,
                        STUFF((SELECT ', ' + RoleName 
                                FROM UserRole UR
                                     INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                                AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                                WHERE UR.UserId = U.Id
                                ORDER BY RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,

                        C.IsDemoDataCleared,
                        U.[Timestamp]
            FROM [User] AS U WITH (NOLOCK)
            INNER JOIN UserCompany AS UC ON UC.UserId =  U.Id

            JOIN [dbo].[Company] C ON C.Id = UC.CompanyId AND C.InactiveDateTime IS NULL
            LEFT JOIN [dbo].[TimeZone] TZ WITH (NOLOCK) ON TZ.Id = U.TimeZoneId
            WHERE (@UserId IS NULL OR U.Id = @UserId)
			      AND (@RoleIds IS NULL OR U.Id IN (SELECT UserId FROM UserRole UR INNER JOIN @Temp T ON T.Id = UR.RoleId AND UR.InactiveDateTime IS NULL))
                  AND (@RoleId IS NULL OR @RoleId IN (SELECT RoleId FROM Ufn_GetRoleIdsBasedOnUserId(UC.UserId, UC.CompanyId)))
                  AND (@EmployeeNameText IS NULL OR ((U.FirstName + ' ' + ISNULL(U.SurName,'')) LIKE ('%' + @EmployeeNameText + '%')))        
                  AND (UC.CompanyId = @CompanyId)
                  AND (U.Id NOT IN (SELECT UR.UserId FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                           AND R.IsHidden = 1 AND R.CompanyId = @CompanyId)  OR (@IsSupport = 1 AND @UserId IS NOT NULL))
                  AND ((@IsUsersPage = 1 
                             AND (@IsActive IS NULL OR (@IsSupport = 1 AND @UserId IS NOT NULL)
                                  OR (@IsActive= 1 AND U.IsActive = 1) 
                                  OR (@IsActive = 0 AND U.IsActive = 0)))
                            OR (@IsActive IS NULL OR (@IsActive= 1 AND (U.IsActive = 1 AND (@IsUsersPage = 0 OR @IsUsersPage IS NULL))))
							OR (@IsActive IS NULL OR (@IsActive= 0 AND (U.IsActive = 0 AND (@IsUsersPage = 0 OR @IsUsersPage IS NULL)))))


            UNION

            SELECT U.Id AS Id,
                        U.Id AS UserId,
                        UC.CompanyId,
                        U.FirstName,
                        U.SurName,
                        U.UserName AS Email,
                        U.[Password],
                        U.IsPasswordForceReset,
                        U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
                        U.IsActive,
                        U.IsExternal,
                        U.TimeZoneId,
						U.DesktopId,
                        U.MobileNo,
                        U.IsAdmin,
                        U.IsActiveOnMobile,
                        U.ProfileImage,
                        U.RegisteredDateTime,
                        U.LastConnection,
                        U.CreatedDateTime,
                        U.CreatedByUserId,
                        U.UpdatedDateTime,
                        U.UpdatedByUserId,
						U.[Language],
                        TZ.TimeZoneName + ' (' + TZ.TimeZone + ')' AS TimeZoneTitle,
                        TZ.TimeZoneName,
				        TZ.TimeZoneOffset,
				        TZ.TimeZone,
				        TZ.TimeZoneAbbreviation,
				        TZ.CountryCode,
				        TZ.CountryName,
                        TZ.OffsetMinutes,
                        @CompanyLanguage AS CompanyLanguage,
                        STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),UR.RoleId))
                                FROM UserRole UR
                                     INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                                AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                                WHERE UR.UserId = U.Id
                                ORDER BY RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleIds,
                        STUFF((SELECT ', ' + RoleName 
                                FROM UserRole UR
                                     INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                                AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                                WHERE UR.UserId = U.Id
                                ORDER BY RoleName
                          FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,

                        C.IsDemoDataCleared,
                        U.[Timestamp]
            FROM [dbo].[User] U WITH (NOLOCK)
            INNER JOIN UserCompany AS UC ON UC.UserId =  U.Id
            JOIN [dbo].[Company] C ON C.Id = UC.CompanyId AND C.InactiveDateTime IS NULL
            LEFT JOIN [dbo].[TimeZone] TZ WITH (NOLOCK) ON TZ.Id = U.TimeZoneId
            WHERE (@UserId IS NULL OR U.Id = @UserId)
                  AND (@RoleId IS NULL OR @RoleId IN (SELECT RoleId FROM Ufn_GetRoleIdsBasedOnUserId(UC.UserId, UC.CompanyId)))
				  AND (@RoleIds IS NULL OR U.Id IN (SELECT UserId FROM UserRole UR INNER JOIN @Temp T ON T.Id = UR.RoleId AND UR.InactiveDateTime IS NULL))
                  AND (@EmployeeNameText IS NULL OR ((U.FirstName + ' ' + ISNULL(U.SurName,'')) LIKE ('%' + @EmployeeNameText + '%')))        
                  AND (UC.CompanyId = @CompanyId)
                  AND (U.Id NOT IN (SELECT UR.UserId FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                           AND R.IsHidden = 1 AND R.CompanyId = @CompanyId)  OR (@IsSupport = 1 AND @UserId IS NOT NULL))
                  AND ((@IsUsersPage = 1 
                             AND (@IsActive IS NULL OR (@IsSupport = 1 AND @UserId IS NOT NULL)
                                  OR (@IsActive= 1 AND U.IsActive = 1) 
                                  OR (@IsActive = 0 AND U.IsActive = 0)))
                            OR (@IsActive IS NULL OR (@IsActive= 1 AND (U.IsActive = 1 AND (@IsUsersPage = 0 OR @IsUsersPage IS NULL))))
							OR (@IsActive IS NULL OR (@IsActive= 0 AND (U.IsActive = 0 AND (@IsUsersPage = 0 OR @IsUsersPage IS NULL)))))
            )T

            WHERE (@SearchText IS NULL
                           OR (Email LIKE @SearchText)
                           OR (FullName LIKE @SearchText)
                           OR (MobileNo LIKE @SearchText)
                           OR ('YES' LIKE @SearchText AND IsActive = 1)
                           OR ('NO' LIKE @SearchText AND (IsActive = 0 OR IsActive IS NULL)))

        END

    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END