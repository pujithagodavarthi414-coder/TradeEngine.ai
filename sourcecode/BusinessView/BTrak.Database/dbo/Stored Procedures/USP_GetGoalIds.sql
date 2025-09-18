CREATE procedure USP_GetGoalIds
(
@GoalName nvarchar(200),
@UserStoryType nvarchar(250),
@UserStoryStatus nvarchar(250)
)
AS
begin
declare @GoalId uniqueidentifier
declare @TypeId uniqueidentifier
declare @UserStatusId uniqueidentifier

select @GoalId = (select top 1 Id from Goal where GoalName = @GoalName),
@TypeId = (Select top 1  Id from UserStoryType where UserStoryTypeName = @UserStoryType),
@UserStatusId = (select top 1  Id from UserStoryStatus where [Status] = @UserStoryStatus)

select @GoalId as GoalId, @TypeId as TypeId, @UserStatusId as UserStatusId
end