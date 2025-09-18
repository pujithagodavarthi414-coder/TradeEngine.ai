-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Get the Users By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetUsers]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserId = '0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
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
  @UserIdsXML XML = NULL,
  @IsEmployeeOverviewDetails BIT = NULL,
  @EntityId UNIQUEIDENTIFIER = NULL,
  @BranchId UNIQUEIDENTIFIER = NULL,
  @IsActive BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
         BEGIN

          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 

		  DECLARE @CompanyLanguage NVARCHAR(250) = (SELECT [Language] FROM Company WHERE Id = @CompanyId)
          
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

          CREATE TABLE #Users
          (
          UserId UNIQUEIDENTIFIER
          )
          
          IF(@UserIdsXML IS NOT NULL)
          BEGIN

          INSERT INTO #Users
          SELECT [Table].[Column].value('(text())[1]', 'NVARCHAR(500)') UserId FROM @UserIdsXML.nodes('/ArrayOfGuid/guid') AS [Table]([Column])

          END


          IF(@UserId IS NOT NULL)
          BEGIN

          SET @ProductivityIndex = (SELECT SUM(EstimatedTime) FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),@UserId,@CompanyId)
                                    GROUP BY UserId)
          
          SELECT @DateFrom = DateFrom,@DateTo = DateTo FROM [dbo].[Ufn_GetFinancialYearDatesForleaves] (@UserId,NULL)
          
		  IF(@UserId IS NOT NULL)
		  BEGIN

            SET @LeavesApplicable = ISNULL((SELECT [dbo].[Ufn_GetEmployeeYTDLeaves](@UserId,DATEPART(YEAR,GETDATE()),NULL)),0)

		  END
		   
          IF(@DateFrom = @DateTo)
          BEGIN

             SET @DateFrom = (SELECT DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()),0))

		     SET @DateTo = (SELECT DATEADD(DAY,-1,DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE()) + 1,0)))

          END
            
			SET @LeavesTaken = (SELECT ISNULL(SUM(Total.Cnt),0) AS LeavesTaken
									   FROM 
									   (SELECT * FROM [dbo].[Ufn_GetLeavesCountWithStatusOfAUser](@UserId,@DateFrom,@DateTo,NULL,NULL,(SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId))) Total)
                                       
		  END
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
						   ,TimeZoneName
						   ,DesktopId
						   ,DesktopName
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

                           ,TrackEmployee
                           ,ActivityTrackerUserId
					       ,ActivityTrackerAppUrlTypeId
					       ,ScreenShotFrequency
					       ,Multiplier
					       ,IsTrack
					       ,IsScreenshot
					       ,IsKeyboardTracking
					       ,IsMouseTracking
					       ,ATUTimeStamp
                           ,UserAuthenticationId
			        	   ,RoleIds
			        	   ,RoleName
			        	   ,EmployeeId
			        	   ,EmployeeNumber
			        	   ,IsDemoDataCleared
			        	   ,[Timestamp]
			        	   ,IsArchived
			        	   ,IsToShowDeleteIcon
			        	   ,ProductivityIndex
			        	   ,TotalCount = Count(1)OVER()
			        	   ,ApprovedLeaves
			        	   ,LeavesRemaining
						   ,[Language]
						   ,CompanyLanguage
                           ,US.IsTracking AS [Status],
							(CASE WHEN (SELECT @Time FROM TimeSheet AS TT WHERE @Time >= TT.LunchBreakStartTime AND (TT.LunchBreakEndTime IS NULL OR @Time <= TT.LunchBreakEndTime) 
									AND TT.UserId = T.UserId AND TT.Date = @Date) = @Time OR
									(SELECT @Time FROM UserBreak AS U WHERE ((@Time BETWEEN U.BreakIn AND U.BreakOut) OR (@Time>=U.BreakIn AND U.BreakOut IS NULL)) AND  U.UserId = T.UserId
									   						  AND U.Date = @Date) = @Time
									THEN 1
									ELSE 0 
									END) AS IsBreak,
							(CASE WHEN (SELECT @Time FROM TimeSheet AS TT WHERE @Time >= TT.InTime AND TT.OutTime IS NULL AND TT.Date = CONVERT(date, @Date) AND TT.UserId = T.UserId) = @Time
								THEN 1
								ELSE 0
								END) AS IsOnline,
							ISNULL(L.IsApproved, 0) AS IsLeave,
                            ModuleIds = STUFF((SELECT  ',' + CONVERT(NVARCHAR(50),ModuleId)[text()]
                                               FROM Intro
								               WHERE UserId = T.UserId
                                                     AND [EnableIntro] IS NOT NULL AND [EnableIntro] = 1
                                                     AND [InActiveDateTime] IS NULL
                                FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
			                ModuleNames = STUFF((SELECT  ',' + M.ModuleName
                                                 FROM Intro I
                                                 INNER JOIN Module M ON M.Id = I.ModuleId
								                 WHERE I.UserId = T.UserId
                                                     AND I.[EnableIntro] IS NOT NULL AND I.[EnableIntro] = 1
                                                     AND I.[InActiveDateTime] IS NULL
                                FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
			        FROM (
			        SELECT U.Id AS Id,
                        U.Id AS UserId,
                        U.CompanyId,
                        U.FirstName,
                        U.SurName,
                        U.UserName AS Email,
                        U.Password,
                        U.IsPasswordForceReset,
                        U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
                        U.IsActive,
                        U.IsExternal,
                        U.TimeZoneId,
						TZ.TimeZoneName,
						U.DesktopId,
						ATD.DesktopName,
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

                        E.TrackEmployee,
                        ATU.Id AS ActivityTrackerUserId,
					    ATU.ActivityTrackerAppUrlTypeId,
					    ATU.ScreenShotFrequency,
					    ATU.Multiplier,
					    ATU.IsTrack,
					    ATU.IsScreenshot,
					    ATU.IsKeyboardTracking,
					    ATU.IsMouseTracking,
					    ATU.TimeStamp AS ATUTimeStamp,
                        UserAuthenticationId,
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
                        E.Id EmployeeId,
			        	E.EmployeeNumber,
                        C.IsDemoDataCleared,
                        U.[Timestamp],
                        CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                        CASE WHEN C.IsDemoDataCleared = 1 THEN 0
                        ELSE CASE WHEN @CompanyId = (SELECT [dbo].Ufn_GetCompanyIdBasedOnUserId(U.UpdatedByUserId)) THEN 0 ELSE 1 END END AS IsToShowDeleteIcon,
                        ISNULL(@ProductivityIndex,0)  AS ProductivityIndex,
			        	  ISNULL(@LeavesTaken,0) AS ApprovedLeaves,
			        	  ISNULL(@LeavesApplicable,0) AS LeavesRemaining
                 FROM  [dbo].[User] U WITH (NOLOCK)
                 JOIN [dbo].[Company] C ON C.Id = U.CompanyId AND C.InactiveDateTime IS NULL
                 LEFT JOIN [dbo].[Employee]E ON E.UserId = U.Id --AND E.InActiveDateTime IS NULL
	             LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				 LEFT JOIN [TimeZone] TZ ON TZ.id = U.TimeZoneId AND TZ.InActiveDateTime IS NULL
				 LEFT JOIN [ActivityTrackerDesktop] ATD ON ATD.Id = U.DesktopId
                 LEFT JOIN ActivityTrackerUserConfiguration AS ATU ON ATU.UserId = U.Id
                 WHERE (@UserId IS NULL OR U.Id = @UserId)
                       AND (@RoleId IS NULL OR @RoleId IN (SELECT RoleId FROM Ufn_GetRoleIdsBasedOnUserId(U.Id)))        
                       AND (@EmployeeNameText IS NULL OR ((U.FirstName + ' ' + ISNULL(U.SurName,'')) LIKE ('%' + @EmployeeNameText + '%')))   
                       AND (@UserIdsXML IS NULL OR U.Id IN (SELECT UserId FROM #Users))
                       AND (U.CompanyId = @CompanyId)
					   AND (U.Id NOT IN (SELECT UR.UserId FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                           AND R.IsHidden = 1 AND R.CompanyId = @CompanyId)  OR (@IsSupport = 1 AND @UserId IS NOT NULL))
                       AND ((@IsUsersPage = 1 
                             AND (@IsActive IS NULL OR (@IsSupport = 1 AND @UserId IS NOT NULL)
                                  OR (@IsActive= 1 AND U.IsActive = 1) 
                                  OR (@IsActive = 0 AND U.IsActive = 0)))
                            OR (@IsActive IS NULL OR (@IsActive= 1 AND (U.IsActive = 1 AND (@IsUsersPage = 0 OR @IsUsersPage IS NULL))))
							OR (@IsActive IS NULL OR (@IsActive= 0 AND (U.IsActive = 0 AND (@IsUsersPage = 0 OR @IsUsersPage IS NULL)))))
						AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
						AND (@BranchId IS NULL OR EB.BranchId = @BranchId)
						AND ((@IsActive = 0 OR @IsActive IS NULL) OR @IsEmployeeOverviewDetails = 1 
                              OR EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy)))
			        
                    UNION

                        SELECT U.Id AS Id,
                        U.Id AS UserId,
                        U.CompanyId,
                        U.FirstName,
                        U.SurName,
                        U.UserName AS Email,
                        U.[Password],
                        U.IsPasswordForceReset,
                        U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
                        U.IsActive,
                        U.IsExternal,
                        U.TimeZoneId,
						TZ.TimeZoneName,
						U.DesktopId,
						ATD.DesktopName,
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

                        E.TrackEmployee,
                        ATU.Id AS ActivityTrackerUserId,
					    ATU.ActivityTrackerAppUrlTypeId,
					    ATU.ScreenShotFrequency,
					    ATU.Multiplier,
					    ATU.IsTrack,
					    ATU.IsScreenshot,
					    ATU.IsKeyboardTracking,
					    ATU.IsMouseTracking,
					    ATU.TimeStamp AS ATUTimeStamp,
                        UserAuthenticationId,
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
                        E.Id EmployeeId,
			        	E.EmployeeNumber,
                        C.IsDemoDataCleared,
                        U.[Timestamp],
                        CASE WHEN U.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                        CASE WHEN C.IsDemoDataCleared = 1 THEN 0
                        ELSE CASE WHEN @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](U.UpdatedByUserId)) THEN 0 ELSE 1 END END AS IsToShowDeleteIcon,
                        ISNULL(@ProductivityIndex,0)  AS ProductivityIndex,
			        	  ISNULL(@LeavesTaken,0) AS ApprovedLeaves,
			        	  ISNULL(@LeavesApplicable,0) AS LeavesRemaining
                 FROM  [dbo].[User] U WITH (NOLOCK)
                 JOIN [dbo].[Company] C ON C.Id = U.CompanyId AND C.InactiveDateTime IS NULL
                 LEFT JOIN [dbo].[Employee]E ON E.UserId = U.Id --AND E.InActiveDateTime IS NULL
				 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				 LEFT JOIN [TimeZone] TZ ON TZ.id = U.TimeZoneId AND TZ.InActiveDateTime IS NULL
				 LEFT JOIN [ActivityTrackerDesktop] ATD ON ATD.Id = U.DesktopId
                 LEFT JOIN ActivityTrackerUserConfiguration AS ATU ON ATU.UserId = U.Id
	             WHERE (@UserId IS NULL OR U.Id = @UserId)
                       AND (@RoleId IS NULL OR @RoleId IN (SELECT RoleId FROM Ufn_GetRoleIdsBasedOnUserId(U.Id)))        
                        AND (@UserIdsXML IS NULL OR U.Id IN (SELECT UserId FROM #Users))
                       AND (@EmployeeNameText IS NULL OR ((U.FirstName + ' ' + ISNULL(U.SurName,'')) LIKE ('%' + @EmployeeNameText + '%')))
                       AND (U.CompanyId = @CompanyId)
					    AND (U.Id NOT IN (SELECT UR.UserId FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                           AND R.IsHidden = 1 AND R.CompanyId = @CompanyId) OR (@IsSupport = 1 AND @UserId IS NOT NULL))
					   AND (E.Id IS NULL  OR @EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                       AND ((@IsUsersPage = 1 
                             AND (@IsActive IS NULL OR (@IsSupport = 1 AND @UserId IS NOT NULL) 
                                  OR (@IsActive= 1 AND U.IsActive = 1) 
                                  OR (@IsActive = 0 AND U.IsActive = 0)))
                            OR (@IsActive IS NULL OR (@IsActive= 1 AND (U.IsActive = 1 AND (@IsUsersPage = 0 OR @IsUsersPage IS NULL))))
							OR (@IsActive IS NULL OR (@IsActive= 0 AND (U.IsActive = 0 AND (@IsUsersPage = 0 OR @IsUsersPage IS NULL)))))
						) T 
                        LEFT JOIN (SELECT UserId, LS.IsApproved
								   FROM LeaveApplication LA
								   	INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
								   WHERE CONVERT(DATE,GETDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo
								   	 --AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL
								   	 AND LS.CompanyId = @CompanyId) AS L ON L.UserId  = T.UserId
                        LEFT JOIN (SELECT * FROM dbo.Ufn_GetUsersTrackingStatus(@CompanyId)) AS US ON US.UserId = T.UserId

			        	 WHERE (@SearchText IS NULL
                           OR (Email LIKE @SearchText)
                           OR (FullName LIKE @SearchText)
                           OR (RoleName LIKE @SearchText)
                           OR (MobileNo LIKE @SearchText)
                           OR ('YES' LIKE @SearchText AND IsActive = 1)
                           OR ('NO' LIKE @SearchText AND (IsActive = 0 OR IsActive IS NULL))
                          )
                 ORDER BY       
                    CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                               CASE WHEN(@SortBy IS NULL OR @SortBy = 'FullName') THEN FullName
                                    WHEN(@SortBy = 'Email') THEN  Email
                                    WHEN(@SortBy = 'desktopName') THEN  DesktopName
                                    WHEN(@SortBy = 'MobileNo') THEN MobileNo
                                    WHEN(@SortBy = 'RoleName') THEN RoleName
                                    WHEN(@SortBy = 'IsActive') THEN CAST(IsActive AS NVARCHAR)
                                    WHEN(@SortBy = 'IsAdmin') THEN CAST(IsAdmin AS NVARCHAR)
                                END
                            END ASC,
                            CASE WHEN @SortDirection = 'DESC' THEN
                               CASE WHEN(@SortBy IS NULL OR @SortBy = 'FullName') THEN FullName
                                    WHEN(@SortBy = 'Email') THEN  Email
                                    WHEN(@SortBy = 'desktopName') THEN  DesktopName
                                    WHEN(@SortBy = 'MobileNo') THEN MobileNo
                                    WHEN(@SortBy = 'RoleName') THEN RoleName
                                    WHEN(@SortBy = 'IsActive') THEN CAST(IsActive AS NVARCHAR)
                                    WHEN(@SortBy = 'IsAdmin') THEN CAST(IsAdmin AS NVARCHAR)
                                END
                            END DESC
                OFFSET ((@PageNo - 1) * @PageSize) ROWS
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