-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-01-22 00:00:00.000'
-- Purpose      To Save or Update the ProjectMemberes
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
--------------------------------------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertProjectMember] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProjectId='53C96173-0651-48BD-88A9-7FC79E836CCE',
--@GoalId='FF4047B8-39B1-42D2-8910-4E60ED38AAC7',
-- @UserIds='<GenericListOfGuid><ListItems><guid>0B2921A9-E930-4013-9047-670B5352F308</guid></ListItems></GenericListOfGuid>',
-- @RoleIds='<GenericListOfGuid><ListItems><guid>06451806-2529-43EC-91C7-A295856C02DA</guid><guid>62303C79-6C6F-4F5A-B0C8-585822F44747</guid></ListItems></GenericListOfGuid>'
-------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertProjectMember]
(
    @ProjectMemberId UNIQUEIDENTIFIER = NULL,
    @ProjectId  UNIQUEIDENTIFIER = NULL,
    @GoalId  UNIQUEIDENTIFIER = NULL,
    @UserIds XML = NULL,
    @TimeZone NVARCHAR(250) = NULL,
    @RoleIds XML,
    @IsArchived BIT = NULL,
    @OperationsPerformedBy  UNIQUEIDENTIFIER ,
    @TimeStamp TimeStamp = NULL
)
AS
BEGIN    
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
        IF (@HavePermission = '1')
        BEGIN
        
		 DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
		 SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
		 
         DECLARE @Currentdate DATETIMEOFFSET =  ISNULL(dbo.Ufn_GetCurrentTime(@Offset),SYSDATETIMEOFFSET())

        IF (@ProjectId IS NULL)
        BEGIN
            RAISERROR(50011,16,1,'Project')
        END
        ELSE
        BEGIN
            
            DECLARE @ProjectMembersTable TABLE
            (
                UserProjectId UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
                UserId UNIQUEIDENTIFIER,
                RoleId UNIQUEIDENTIFIER
            )
        
            INSERT INTO @ProjectMembersTable(UserId,RoleId)
            SELECT x.y.value('(text())[1]', 'varchar(100)'),x1.y1.value('(text())[1]', 'varchar(100)')
            FROM @UserIds.nodes('/GenericListOfGuid/*/guid') AS x(y),
                 @RoleIds.nodes('/GenericListOfGuid/*/guid') AS x1(y1)
             DECLARE @MemberUserIdsCount INT = (SELECT COUNT (1) FROM @ProjectMembersTable)
             --DECLARE @ProjectMemberCount INT = (SELECT COUNT(1) 
                --                              FROM UserProject PM JOIN @ProjectMembersTable PMT ON @ProjectId = PM.ProjectId 
                --                              AND PMT.UserId = PM.UserId AND PMT.RoleId = PM.EntityRoleId 
                --                              WHERE PM.ProjectId = @ProjectId 
                --                                    AND PM.UserId = PMT.UserId
                --                                    AND PM.EntityRoleId = PMT.RoleId
                --                                    AND PM.InActiveDateTime IS NULL)
              
              IF(@MemberUserIdsCount = 0)
              BEGIN
                    RAISERROR(50011,16,1,'ProjectMemberData')
              END
              ELSE
              BEGIN

					EXEC [USP_InsertProjectAuditHistory] @ProjectId = @ProjectId,
                                                         @ProjectMemberUserIds = @UserIds,
                                                         @ProjectMemberRoleIds = @RoleIds,
                                                         @OperationsPerformedBy = @OperationsPerformedBy,@TimeZoneId = @TimeZoneId

                    UPDATE UserProject SET InActiveDateTime = @Currentdate 
                                           ,UpdatedDateTime = @Currentdate
                                           ,UpdatedByUserId = @OperationsPerformedBy
										   ,UpdatedDateTimeZoneId = @TimeZoneId
                    WHERE UserId IN (SELECT UserId FROM @ProjectMembersTable)
                          AND ProjectId = @ProjectId
                    INSERT INTO UserProject(
                             [Id],
                             [UserId],
                             [ProjectId],
                             [GoalId],
                             [EntityRoleId],                    
                             [CreatedDateTime],
							 [CreatedDateTimeZoneId],
                             [CreatedByUserId])
                      SELECT UserProjectId,
                             UserId,     
                             @ProjectId,
                             @GoalId,
                             RoleId,
                             @Currentdate,
							 @TimeZoneId,
                             @OperationsPerformedBy
                      FROM @ProjectMembersTable
                END
                    SELECT UserProjectId FROM @ProjectMembersTable
              END
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