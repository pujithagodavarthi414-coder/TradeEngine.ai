CREATE PROCEDURE USP_InsertNotification
(
@Summary nvarchar(max),
@NotificationTypeName nvarchar(max)
)
as
begin
declare @NotificationId uniqueidentifier = NewId()
declare @TypeId uniqueidentifier
select @TypeId = (select top 1 Id from NotificationType where NotificationTypeName = @NotificationTypeName)
begin
insert into [Notification](Id, NotificationTypeId, Summary, NotificationJson, CreatedDateTime, CreatedByUserId) values(@NotificationId , @TypeId, @Summary, '{}', GETDATE(), '0B2921A9-E930-4013-9047-670B5352F308')
 
end
begin
insert into UserNotificationRead (Id, NotificationId, UserId, CreatedByUserId, CreatedDateTime) values(NEWID(), @NotificationId, '0B2921A9-E930-4013-9047-670B5352F308', '0B2921A9-E930-4013-9047-670B5352F308', GETDATE())
end
end