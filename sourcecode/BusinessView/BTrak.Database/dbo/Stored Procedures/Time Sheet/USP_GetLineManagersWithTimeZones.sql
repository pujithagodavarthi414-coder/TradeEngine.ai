-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetLineManagersWithTimeZones] @OperationsPerformedBy = '63447806-B0BE-452C-8C38-F3EAD87322B3'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLineManagersWithTimeZones]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

         IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

         DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
         IF (@HavePermission = '1')
         BEGIN
 
            DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
          SELECT U.FirstName+' '+U.SurName UserName,
				 UR.UserId ,
				 U.ProfileImage,
				 U.IsActive,
                 E.Id AS EmployeeId,
				 TZ.TimeZoneName,
				 TZ.Id AS TimeZoneId,
                 (SELECT ChildId, ChildJoinedDate JoinedDate,ChildName [Name] from [dbo].[Ufn_GetEmployeeReportedMembersWithDate](UR.UserId, @CompanyId) WHERE ChildId <>  UR.UserId AND LVL = 1 FOR JSON PATH) AS ReportingMembers
		  FROM RoleFeature RF
				JOIN [UserRole] UR ON UR.RoleId = RF.RoleId AND featureId = '3845D5C9-E786-49E2-8262-5C2E251257EF'
				JOIN [User] U ON U.Id = UR.UserId AND U.CompanyId = @CompanyId
                LEFT JOIN Employee E ON E.UserId = U.Id
				LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
				WHERE U.FirstName+' '+U.SurName <> 'Snovasys Support' AND U.IsActive = 1
         GROUP BY U.FirstName,UR.UserId,U.SurName ,  U.ProfileImage, U.IsActive, E.Id,TZ.TimeZoneName,TZ.Id

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