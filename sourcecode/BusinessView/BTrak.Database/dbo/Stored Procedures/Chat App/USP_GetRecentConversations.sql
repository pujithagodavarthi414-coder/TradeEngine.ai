--EXEC [dbo].[USP_GetRecentConversations] '4024A4D6-AE63-413A-A4E1-126F0E66245D'

CREATE PROCEDURE [dbo].[USP_GetRecentConversations]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
)	
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	 IF (@HavePermission = '1')
     BEGIN

	 IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	 DECLARE @CompanyId UNIQUEIDENTIFIER
		SELECT @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @FeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                     FROM CompanyModule CM 
                                                          INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
                                                          INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = 'A3B9B81A-109B-445D-9AEA-6B8A2B71C884' --Can have full access to company
                                                                     AND CM.CompanyId = @CompanyId
													 GROUP BY FeatureId)

				DECLARE @RecentConv TABLE
				(
					Recivers UNIQUEIDENTIFIER,
					LatestDateTime DATETIME
				)

				INSERT INTO @RecentConv
				SELECT ReceiverId, RecentMessageDateTime from RecentConversations WHERE SenderId=@OperationsPerformedBy
				INSERT INTO @RecentConv
				SELECT SenderId, RecentMessageDateTime from RecentConversations WHERE ReceiverId=@OperationsPerformedBy 
							AND SenderId NOT IN (Select Recivers from @RecentConv)
				DECLARE @HaveAdvancedPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)
              
              IF(@HaveAdvancedPermission = 1)
              BEGIN

			SELECT C.Recivers AS ReceiverId
				  ,U.FirstName AS FirstName
				  ,U.SurName AS SurName
				  ,U.[UserName] AS Email
				  ,U.[Password] AS Password
				  ,U.FirstName+' '+U.SurName AS FullName
				  ,U.IsActive AS IsActive
				  ,U.TimeZoneId AS TimeZone
				  ,U.MobileNo AS MobileNumber
				  ,U.IsAdmin AS IsAdmin
				  ,U.IsActiveOnMobile AS IsAciveOnMobile
				  ,U.RegisteredDateTime AS RegisteredDateTime
				  ,U.LastConnection AS LastConnection
				  ,U.CreatedDateTime AS CreatedDateTime
				  ,U.CreatedByUserId AS CreatedByUserId
				  ,U.UpdatedDateTime AS UpdatedDateTime
				  ,U.UpdatedByUserId AS UpdatedByUserId
				  ,U.ProfileImage AS [Profile]
				  ,U.IsExternal
				  ,C.LatestDateTime AS RecentMessageDateTime
				  ,D.DesignationName AS DesignationName
				  ,ED.DepartmentName
				  ,IIF(MSE.IsMuted IS NULL,0,MSE.IsMuted) AS IsMuted
				  ,IIF(MSE.IsStarred IS NULL,0,MSE.IsStarred) AS IsStarred
				  ,IIF(MSE.IsLeave IS NULL,0,MSE.IsLeave) AS IsLeave
				  ,CASE WHEN LAInner.UserId IS NOT NULL THEN 1 ELSE 0 END AS IsOnLeave
				  ,CASE WHEN C1.Id IS NOT NULL THEN 1 ELSE 0 END AS IsClient
                  ,C1.CompanyName AS ClientCompanyName
				  ,UAS.StatusId AS StatusId
			FROM  [dbo].[User] U
			INNER JOIN @RecentConv C ON C.Recivers=U.Id
                     LEFT JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
                     LEFT JOIN [UserActiveStatus] UAS ON UAS.UserId = U.Id
				     LEFT JOIN [Job] EJ ON EJ.EmployeeId = E.Id  AND EJ.InActiveDateTime IS NULL
					 LEFT JOIN [Designation] D ON D.Id = EJ.DesignationId AND D.InactiveDateTime IS NULL
					 LEFT JOIN [Department] ED ON ED.Id = EJ.DepartmentId AND ED.InActiveDateTime IS NULL
					 LEFT JOIN [Client] C1 ON C1.UserId = U.Id AND C1.InactiveDateTime IS NULL
                     LEFT JOIN MutedOrStarredContacts MSE ON (MSE.UserId=U.Id) and MSE.CreatedByUserId = @OperationsPerformedBy
					 LEFT JOIN (SELECT UserId
                               FROM LeaveApplication LA
                                    INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
                               WHERE CONVERT(DATE,GETDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo
                                     AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL
                                     AND LS.CompanyId = @CompanyId) LAInner ON LAInner.UserId = U.Id
         WHERE (U.CompanyId = @CompanyId) 
		        AND U.InActiveDateTime IS NULL 
				AND U.IsActive = 1
				GROUP BY C.Recivers,U.FirstName,U.SurName,U.UserName,U.[Password],U.IsActive,U.TimeZoneId,U.MobileNo,U.IsAdmin,
				U.IsActiveOnMobile,U.RegisteredDateTime,U.LastConnection,U.CreatedDateTime,U.CreatedByUserId,U.UpdatedDateTime,
				U.UpdatedByUserId,U.ProfileImage,C.LatestDateTime,D.DesignationName,MSE.IsMuted,MSE.IsStarred,MSE.IsLeave,LAInner.UserId
				,UAS.StatusId,C1.Id,C1.CompanyName,ED.DepartmentName,U.IsExternal
				Order By LatestDateTime Desc
		END
		ELSE
		BEGIN

		SELECT C.Recivers AS ReceiverId
				  ,U.FirstName AS FirstName
				  ,U.SurName AS SurName
				  ,U.[UserName] AS Email
				  ,U.[Password] AS Password
				  ,U.FirstName+' '+U.SurName AS FullName
				  ,U.IsActive AS IsActive
				  ,U.TimeZoneId AS TimeZone
				  ,U.MobileNo AS MobileNumber
				  ,U.IsAdmin AS IsAdmin
				  ,U.IsActiveOnMobile AS IsAciveOnMobile
				  ,U.RegisteredDateTime AS RegisteredDateTime
				  ,U.LastConnection AS LastConnection
				  ,U.CreatedDateTime AS CreatedDateTime
				  ,U.CreatedByUserId AS CreatedByUserId
				  ,U.UpdatedDateTime AS UpdatedDateTime
				  ,U.UpdatedByUserId AS UpdatedByUserId
				  ,U.ProfileImage AS [Profile]
				  ,U.IsExternal
				  ,C.LatestDateTime AS RecentMessageDateTime
				  ,D.DesignationName AS DesignationName
				  ,ED.DepartmentName 
				  ,IIF(MSE.IsMuted IS NULL,0,MSE.IsMuted) AS IsMuted
				  ,IIF(MSE.IsStarred IS NULL,0,MSE.IsStarred) AS IsStarred
				  ,IIF(MSE.IsLeave IS NULL,0,MSE.IsLeave) AS IsLeave
				  ,CASE WHEN LAInner.UserId IS NOT NULL THEN 1 ELSE 0 END AS IsOnLeave
				  ,CASE WHEN C1.Id IS NOT NULL THEN 1 ELSE 0 END AS IsClient
                  ,C1.CompanyName AS ClientCompanyName
				  ,UAS.StatusId AS StatusId
			FROM  [dbo].[User] U
			INNER JOIN @RecentConv C ON C.Recivers=U.Id
			INNER JOIN (SELECT UserId AS MemberUserId 
                          FROM [dbo].[Ufn_GetAccessibleMembersForSlack](@CompanyId,@OperationsPerformedBy,@FeatureId)) AMS ON AMS.MemberUserId = C.Recivers
                     LEFT JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
					 LEFT JOIN [Client] C1 ON C1.UserId = U.Id And C1.InactiveDateTime IS NULL
                     LEFT JOIN [UserActiveStatus] UAS ON UAS.UserId = U.Id
				     LEFT JOIN [Job] EJ ON EJ.EmployeeId = E.Id  AND EJ.InActiveDateTime IS NULL
					 LEFT JOIN [Designation] D ON D.Id = EJ.DesignationId AND D.InactiveDateTime IS NULL
					 LEFT JOIN [Department] ED ON ED.Id = EJ.DepartmentId AND ED.InactiveDateTime IS NULL
                     LEFT JOIN MutedOrStarredContacts MSE ON (MSE.UserId=U.Id) and MSE.CreatedByUserId = @OperationsPerformedBy
					 LEFT JOIN (SELECT UserId
                               FROM LeaveApplication LA
                                    INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
                               WHERE CONVERT(DATE,GETDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo
                                     AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL
                                     AND LS.CompanyId = @CompanyId) LAInner ON LAInner.UserId = U.Id
         WHERE (U.CompanyId = @CompanyId) 
		        AND U.InActiveDateTime IS NULL 
				AND U.IsActive = 1
				AND (MSE.IsLeave IS NULL OR MSE.IsLeave = 0)
				GROUP BY C.Recivers,U.FirstName,U.SurName,U.UserName,U.[Password],U.IsActive,U.TimeZoneId,U.MobileNo,U.IsAdmin,
				U.IsActiveOnMobile,U.RegisteredDateTime,U.LastConnection,U.CreatedDateTime,U.CreatedByUserId,U.UpdatedDateTime,
				U.UpdatedByUserId,U.ProfileImage,C.LatestDateTime,D.DesignationName,MSE.IsMuted,MSE.IsStarred,MSE.IsLeave,LAInner.UserId
				,UAS.StatusId,C1.Id,C1.CompanyName,ED.DepartmentName,U.IsExternal
				Order By LatestDateTime Desc

		END
	 END

	END TRY  
	BEGIN CATCH 
		
		    THROW

	END CATCH
END