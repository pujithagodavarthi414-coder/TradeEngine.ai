-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-22 00:00:00.000'
-- Purpose      To Get ProjectMembers By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetProjectMembers] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetProjectMembers]
(
   @ProjectId  UNIQUEIDENTIFIER = NULL,
   @ProjectMemberId  UNIQUEIDENTIFIER = NULL,
   @ProjectMemberIdsXML  XML = NULL,
   @UserId UNIQUEIDENTIFIER = NULL,
   @RoleId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @PageNo INT = 1,
   @PageSize INT = 10
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        
          
        DECLARE @HavePermission NVARCHAR(250) =   (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

		  CREATE TABLE #ProjectMenbers
          (
            Id UNIQUEIDENTIFIER
          ) 
         
         IF(@ProjectMemberIdsXML IS NOT NULL)
         BEGIN
                
                INSERT INTO #ProjectMenbers(Id)
                SELECT X.Y.value('(text())[1]', 'uniqueidentifier')
                FROM @ProjectMemberIdsXML.nodes('/GenericListOfGuid/ListItems/guid') X(Y)
         END

          IF(@ProjectMemberId = '00000000-0000-0000-0000-000000000000') SET @ProjectMemberId = NULL

          IF(@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
          
          IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL
          
          IF(@RoleId = '00000000-0000-0000-0000-000000000000') SET @RoleId = NULL
          
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
                  
          DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].Ufn_GetCompanyIdBasedOnUserId(@OperationsPerformedBy))
          
          SELECT UP.UserId,
                 UP.GoalId,
                 UP.ProjectId,             
                 P.ProjectName,
                 U.FirstName +' '+ISNULL(U.SurName,'') AS UserName,
                 U.ProfileImage,
               --  UP.[Timestamp], 
				 --UP.CreatedDateTime,    
                 RoleIds = STUFF(( SELECT  ',' + LOWER(Convert(nvarchar(50),UP1.EntityRoleId))[text()]
                                FROM [UserProject] UP1
                                WHERE (@ProjectId IS NULL OR UP1.ProjectId = @ProjectId) 
                                      AND (@UserId IS NULL OR UP1.UserId = @UserId) 
                                      AND (@RoleId IS NULL OR UP1.EntityRoleId = @RoleId)
                                      AND (UP1.UserId = UP.UserId)
                                      AND (@ProjectMemberId IS NULL OR UP1.Id = @ProjectMemberId)
                                      AND (UP1.InActiveDateTime IS NULL)
                                FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
                 RoleNames = STUFF(( SELECT  ',' + Convert(nvarchar(50),R.EntityRoleName)[text()]
                               FROM [UserProject] UP2
                               INNER JOIN [EntityRole] R ON R.Id = UP2.EntityRoleId AND R.InActiveDateTime IS NULL
                               WHERE (@ProjectId IS NULL OR UP2.ProjectId = @ProjectId) 
                                     AND (@UserId IS NULL OR UP2.UserId = @UserId)
                                     AND (@RoleId IS NULL OR UP2.EntityRoleId = @RoleId)
                                     AND (UP2.UserId = UP.UserId) 
                                     AND (@ProjectMemberId IS NULL OR UP2.Id = @ProjectMemberId)
                                     AND (UP2.InActiveDateTime IS NULL)
                               FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
          FROM [dbo].[UserProject] AS UP WITH (NOLOCK)
               INNER JOIN [dbo].[User] AS U WITH (NOLOCK) ON U.Id = UP.UserId 
               INNER JOIN [dbo].[Project] AS P WITH (NOLOCK) ON P.Id = UP.ProjectId
               LEFT JOIN #ProjectMenbers PMInner ON PMInner.Id = UP.Id
          WHERE ((@ProjectId IS NULL OR (UP.ProjectId = @ProjectId))
                AND (@ProjectMemberId IS NULL OR UP.Id = @ProjectMemberId)
                AND (@UserId IS NULL OR (UP.UserId = @UserId))
                AND (@RoleId IS NULL OR (UP.EntityRoleId = @RoleId))
                AND (P.CompanyId = @CompanyId))
                AND (@ProjectMemberIdsXML IS NULL OR PMInner.Id IS NOT NULL)
                AND U.IsActive = 1
                AND (@IsArchived IS NULL OR (@IsArchived = 1 AND UP.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND UP.InActiveDateTime IS NULL))
          GROUP BY UP.UserId,UP.GoalId,UP.ProjectId, P.ProjectName, U.FirstName, U.SurName,U.ProfileImage--, UP.CreatedDateTime
          ORDER BY U.FirstName +' '+ISNULL(U.SurName,'') ASC
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