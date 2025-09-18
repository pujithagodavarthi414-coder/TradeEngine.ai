
CREATE PROCEDURE [dbo].[USP_UpdatePayrollStatus]
(
@PayrollRunId uniqueidentifier,
@PayrollStatusId uniqueidentifier,
@UserId uniqueidentifier,
@WorkflowProcessInstanceId uniqueidentifier,
@StatusName nvarchar(max),
@Comments nvarchar(1000)
)
AS
BEGIN
IF(@StatusName IS NULL OR @StatusName = '')
BEGIN
DECLARE @Id uniqueidentifier;

SET @Id = (select top 1 Id from PayrollRunStatus where PayrollRunId = @PayrollRunId and PayrollStatusId = @PayrollStatusId order by CreatedDateTime desc)
IF(@Comments IS NULL)
BEGIN
SET @Comments = (select top 1 Comments from PayrollRunStatus where PayrollRunId = @PayrollRunId ORDER BY CreatedDateTime DESC)
END
IF(@Id IS NULL)
BEGIN
INSERT PayrollRunStatus(Id, PayrollRunId, PayrollStatusId, CreatedByUserId, CreatedDateTime, Comments, WorkflowProcessInstanceId) VALUES(NEWID(), @PayrollRunId, @PayrollStatusId, @UserId, GETDATE(),@Comments, @WorkflowProcessInstanceId)

UPDATE PayrollRunEmployee set PayrollStatusId = @PayrollStatusId where PayrollRunId = @PayrollRunId
END
ELSE
BEGIN

UPDATE PayrollRunStatus SET Comments = @Comments WHERE Id = @Id
END
END
ELSE
BEGIN
DECLARE @StatusId uniqueidentifier;
SET @StatusId = (select top 1 Id from PayrollStatus where PayrollStatusName = @StatusName)
INSERT PayrollRunStatus(Id, PayrollRunId, PayrollStatusId, CreatedByUserId, CreatedDateTime, Comments, WorkflowProcessInstanceId) VALUES(NEWID(), @PayrollRunId, @StatusId, @UserId, GETDATE(), @Comments, @WorkflowProcessInstanceId)
END
END