-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-07-22 00:00:00.000'
-- Purpose      To create a channel based on report to
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [USP_UpsertEmployeeReportToChannel] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@ReportToEmployeeId = '3B362452-FFC5-4E98-A908-484947777DD4'
----------------------------------------------------------------------------------------------------------
Create PROCEDURE [dbo].[USP_UpsertEmployeeReportToChannel]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
 @ReportToEmployeeId UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    
        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        DECLARE @UserId UNIQUEIDENTIFIER = (SELECT UserId FROM Employee WHERE Id = @ReportToEmployeeId)
​
        IF (@HavePermission = '1')
        BEGIN
​
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
​
        DECLARE @ChildCount INT = (SELECT COUNT(1) FROM [dbo].[Ufn_GetEmployeeReportedMembers](@UserId,@CompanyId))
​
        DECLARE @ChannelId UNIQUEIDENTIFIER = (SELECT Id FROM Channel WHERE Id = @UserId)
​
        IF (@ChildCount > 1)
        BEGIN
​
        DECLARE @User TABLE(
                            MemberId UNIQUEIDENTIFIER,
                            IsExist BIT
                           )
​
           INSERT INTO @User(MemberId)           
           --For Childs of level 1
           SELECT U.Id FROM [User] U JOIN Employee E ON E.UserId = U.Id JOIN EmployeeReportTo ERT ON ERT.EmployeeId = E.Id AND ERT.InActiveDateTime IS NULL AND ERT.ReportToEmployeeId = @ReportToEmployeeId
           
           UNION ALL
           --For parents of level 1
           SELECT U.Id FROM [User] U JOIN Employee E ON E.UserId = U.Id JOIN EmployeeReportTo ERT ON ERT.ReportToEmployeeId = E.Id AND ERT.InActiveDateTime IS NULL AND ERT.EmployeeId = @ReportToEmployeeId
           ​
           UNION ALL
           SELECT @UserId
          DECLARE @CurrentDate DATETIME = GETDATE()
​
          DECLARE @NewChannelId UNIQUEIDENTIFIER = NEWID()
​
​
          IF (@ChannelId IS NULL)
          BEGIN
​
          INSERT INTO Channel (
                               Id,
                               CompanyId,
                               ChannelName,
                               IsDeleted,
                               CreatedDateTime,
                               CreatedByUserId
                              )
                      SELECT  @UserId,
                              @CompanyId,
                              CONCAT('Team','-',CAST((SELECT FirstName FROM [User] WHERE Id = @UserId) AS nvarchar)),
                              0,
                              @CurrentDate,
                              @OperationsPerformedBy
          END
        
        UPDATE Channel SET InActiveDateTime = NULL WHERE Id = @UserId
        UPDATE @User SET IsExist = 1 FROM @User U JOIN ChannelMember CM ON CM.MemberUserId = U.MemberId AND CM.ChannelId = @UserId
        ​
        UPDATE ChannelMember SET InActiveDateTime = @CurrentDate,UpdatedDateTime = @CurrentDate,UpdatedByUserId = @OperationsPerformedBy WHERE ChannelId = @UserId AND MemberUserId NOT IN (SELECT MemberId FROM @User)
        
        UPDATE ChannelMember SET InActiveDateTime = NULL,UpdatedDateTime = @CurrentDate,UpdatedByUserId = @OperationsPerformedBy WHERE ChannelId = @UserId AND MemberUserId IN (SELECT MemberId FROM @User) AND InActiveDateTime IS NOT NULL
        ​
        INSERT INTO ChannelMember(
                                  Id,
                                  ChannelId,
                                  MemberUserId,
                                  ActiveFrom,
                                  CreatedDateTime,
                                  CreatedByUserId
                                 )
                           SELECT NEWID(),
                                  @UserId,
                                  U.MemberId,
                                  @CurrentDate,
                                  @CurrentDate,
                                  @OperationsPerformedBy
                                  FROM @User U WHERE IsExist IS NULL
​
        SELECT Id FROM Channel WHERE Id = @UserId
        
        END
        ELSE
        BEGIN
        
            UPDATE ChannelMember SET InActiveDateTime = GETDATE() WHERE ChannelId = @ChannelId AND MemberUserId <> @UserId
            
            UPDATE Channel SET InActiveDateTime = @CurrentDate WHERE Id = @ChannelId
            ​
            SELECT @UserId
        
        END
        END
        ELSE
​
            RAISERROR(@HavePermission,11,1)
END TRY
BEGIN CATCH
    
    THROW
​
END CATCH
END
GO