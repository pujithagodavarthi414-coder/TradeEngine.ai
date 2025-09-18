-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-07-23 00:00:00.000'
-- Purpose      To create a channel for an userstory select newid()
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
--------------------------------------------------------------------------------------------------------------
--Exec USP_UpsertUserStoryChannel @UserStoryId = 'DC09D6A8-7D4A-4A03-9E17-BCA1595A1DF5',@OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308'
--------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE USP_UpsertUserStoryChannel
(
 @UserStoryId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @ProjectId UNIQUEIDENTIFIER = NULL,
 @GoalId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	IF (@ProjectId IS NULL) SET @ProjectId = (SELECT P.Id FROM UserStory US 
	                                                              JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL
	                                                              JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL
															      JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
	                                                               JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId 
																   AND US.Id = @UserStoryId 
																   AND TS.[Order] NOT IN (4,6)
																   --AND ((USS.IsQAApproved <> 1 OR USS.IsQAApproved IS NULL) 
																   --AND (USS.IsSignedOff  <> 1 OR USS.IsBlocked IS NULL))
																   --AND (USS.IsVerified <> 1 OR USS.IsVerified IS NULL)
																   --AND (USS.IsCompleted <> 1 OR USS.IsCompleted IS NULL)
															       AND US.InActiveDateTime IS NULL)

	DECLARE @CurrentDate DATETIME = GETDATE()

	DECLARE @ChannelId UNIQUEIDENTIFIER = (SELECT Id FROM Channel WHERE Id = @UserStoryId)
	
	IF (@ChannelId IS NULL)
	BEGIN
	 INSERT INTO Channel (
	  	 				  Id,
						  CompanyId,
	  	 				  ChannelName,
	  	 				  IsDeleted,
	  	 				  CreatedDateTime,
	  	 				  CreatedByUserId,
						  ProjectId
	  	 				 ) 
	  	 		 SELECT   @UserStoryId,
				          @CompanyId,
	  	 		          US.UserStoryUniqueName,
	  	 				  0,
	  	 				  @CurrentDate,
	  	 				  @OperationsPerformedBy,
						  @ProjectId
	  	 				  FROM UserStory US WHERE US.Id = @UserStoryId AND InActiveDateTime IS NULL
	END
	ELSE
	BEGIN

		UPDATE Channel SET CompanyId = @CompanyId,
	  	 				   ChannelName = US.UserStoryUniqueName,
	  	 				   IsDeleted = CASE WHEN @ProjectId IS NULL THEN 1 ELSE 0 END,
						   InActiveDateTime = CASE WHEN @ProjectId IS NULL THEN @CurrentDate ELSE NULL END,
	  	 				   UpdatedDateTime = @CurrentDate,
	  	 				   UpdatedByUserId = @OperationsPerformedBy,
						   ProjectId = CASE WHEN @ProjectId IS NOT NULL THEN @ProjectId ELSE US.ProjectId END
						   FROM UserStory US JOIN Channel C ON C.Id = US.Id WHERE US.Id = @UserStoryId AND US.InActiveDateTime IS NULL



	END

	DECLARE @ChannelMember TABLE(
								  Id UNIQUEIDENTIFIER,
								  ChannelId UNIQUEIDENTIFIER,
								  MemberId UNIQUEIDENTIFIER,
								  IsExist BIT
								 )

	INSERT INTO @ChannelMember (ChannelId,MemberId)
	SELECT @UserStoryId,P.UserId FROM UserProject P WHERE P.ProjectId = @ProjectId AND InActiveDateTime IS NULL

	

	UPDATE @ChannelMember SET IsExist = 1 FROM @ChannelMember TMC JOIN ChannelMember CM ON TMC.ChannelId = CM.ChannelId AND TMC.MemberId = CM.MemberUserId

	UPDATE ChannelMember SET InActiveDateTime = @CurrentDate WHERE ChannelId = @UserStoryId AND MemberUserId NOT IN (SELECT MemberId FROM @ChannelMember) AND InActiveDateTime IS NULL
	
	UPDATE ChannelMember SET InActiveDateTime = NULL WHERE ChannelId = @UserStoryId AND MemberUserId IN (SELECT MemberId FROM @ChannelMember) AND InActiveDateTime IS NOT NULL

		INSERT INTO ChannelMember(
		                          Id,
								  ChannelId,
								  MemberUserId,
								  ActiveFrom,
								  CreatedDateTime,
								  CreatedByUserId
								 )
						   SELECT NEWID(),
						          U.ChannelId,
								  U.MemberId,
								  @CurrentDate,
								  @CurrentDate,
								  @OperationsPerformedBy
								  FROM @ChannelMember U WHERE IsExist IS NULL
		 
		 IF (@ProjectId IS NULL)
		 BEGIN

			UPDATE ChannelMember SET InActiveDateTime = @CurrentDate,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = @CurrentDate WHERE ChannelId = @UserStoryId

		 END

		 SELECT Id AS ChannelId FROM Channel WHERE Id = @UserStoryId

END TRY
BEGIN CATCH
	
	THROW

END CATCH
END