-------------------------------------------------------------------------------
--EXEC [USP_GetChannelUsers] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@IsActive = 1,@ChannelId = 'B86F1525-D899-434A-9274-48C52060136E'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetChannelUsers]
(
  @IsActive BIT = NULL,
  @ChannelId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
           DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
          IF (@HavePermission = '1')
          BEGIN
             IF (@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL
             IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
			IF(@ProjectId Is null)
			Begin
			    SELECT CM.Id ChannelMemberId,
                    CM.ChannelId,
                    CM.[TimeStamp],
                    U.Id UserId,
                    U.CompanyId,
                    U.SurName,
                    U.FirstName,
                    U.UserName, 
                    STUFF((SELECT ',' + RoleName 
                          FROM UserRole UR
                               INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                          AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                          WHERE UR.UserId = U.Id
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
                    D.DesignationName,
                    U.MobileNo,
                    U.IsAdmin,
                    U.ProfileImage,
                    U.RegisteredDateTime,
                    U.LastConnection,
                    U.CreatedByUserId,
                    C.ChannelName,
					US.UserStoryName AS UserStoryName,
					ISNULL(CM.IsReadOnly,0) AS IsReadOnly
             FROM  [ChannelMember] CM 
                   INNER JOIN [User] U ON CM.MemberUserId = U.Id AND U.InactiveDateTime IS NULL 
				   LEFT JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
				   LEFT JOIN [Job] ED ON ED.EmployeeId = E.Id AND ED.InActiveDateTime IS NULL
				   LEFT JOIN [Designation] D ON D.Id = ED.DesignationId AND D.InactiveDateTime IS NULL
				   INNER JOIN [Channel] C ON C.Id=CM.ChannelId AND C.InactiveDateTime IS NULL 
				   LEFT JOIN UserStory US ON (US.Id=C.Id) 
									  AND US.InActiveDateTime IS NULL
             WHERE CM.ChannelId = @ChannelId AND @ChannelId Is NOT NULL
			       AND CM.ActiveTo IS NULL
                   AND (@IsActive IS NULL OR (@IsActive = 1 AND CM.InActiveDateTime IS NULL) OR (@IsActive = 0 AND CM.InActiveDateTime IS NOT NULL) )
                   AND (U.IsActive IS NULL OR U.IsActive = 1)
                   AND U.CompanyId = @CompanyId
			End
             SELECT CM.Id ChannelMemberId,
                    CM.ChannelId,
                    CM.[TimeStamp],
                    U.Id UserId,
                    U.CompanyId,
                    U.SurName,
                    U.FirstName,
                    U.UserName, 
                    STUFF((SELECT ',' + RoleName 
                          FROM UserRole UR
                               INNER JOIN [Role] R ON R.Id = UR.RoleId 
                                          AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                          WHERE UR.UserId = U.Id
                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
                    D.DesignationName,
                    U.MobileNo,
                    U.IsAdmin,
                    U.ProfileImage,
                    U.RegisteredDateTime,
                    U.LastConnection,
                    U.CreatedByUserId,
                    C.ChannelName,
					US.UserStoryName AS UserStoryName,
					ISNULL(CM.IsReadOnly,0) AS IsReadOnly
             FROM  [ChannelMember] CM 
                   INNER JOIN [User] U ON CM.MemberUserId = U.Id AND U.InactiveDateTime IS NULL 
				   LEFT JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
				   LEFT JOIN [Job] ED ON ED.EmployeeId = E.Id AND ED.InActiveDateTime IS NULL
				   LEFT JOIN [Designation] D ON D.Id = ED.DesignationId AND D.InactiveDateTime IS NULL
				   INNER JOIN [Channel] C ON C.Id=CM.ChannelId AND C.InactiveDateTime IS NULL 
				   LEFT JOIN UserStory US ON (US.Id=C.Id) 
									  AND US.InActiveDateTime IS NULL
             WHERE CM.ActiveTo IS NULL
                   AND (@IsActive IS NULL OR (@IsActive = 1 AND CM.InActiveDateTime IS NULL) OR (@IsActive = 0 AND CM.InActiveDateTime IS NOT NULL) )
                   AND (U.IsActive IS NULL OR U.IsActive = 1)
                   AND U.CompanyId = @CompanyId
				   AND C.ProjectId= @ProjectId
				   AND C.Id NOT IN (SELECT Id FROM UserStory)
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
