-------------------------------------------------------------------------------
-- Author       Padmini B
-- Created      '2019-04-17 00:00:00.000'
-- Purpose      To Delete Goal
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--DECLARE @Temp TIMESTAMP = (SELECT TimeStamp FROM Goal WHERE Id = 'FF4047B8-39B1-42D2-8910-4E60ED38AAC7')
--EXEC [dbo].[USP_DeleteGoal] @GoalId='FF4047B8-39B1-42D2-8910-4E60ED38AAC7'
--,@TimeStamp = @Temp
--,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE  PROCEDURE [dbo].[USP_DeleteGoal]
(
   @GoalId UNIQUEIDENTIFIER = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @IsArchived BIT = NULL,
   @TimeZone NVARCHAR(250) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

       DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))

	   DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

       IF (@HavePermission = '1')
       BEGIN
           DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
                                               FROM [Goal] WHERE Id = @GoalId) = @TimeStamp
                                         THEN 1 ELSE 0 END)

           IF(@IsLatest = 1)
           BEGIN
               
			   IF (@IsArchived IS NULL) SET @IsArchived = 0
			   
			   DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
			   SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone
			
               DECLARE @Currentdate DATETIMEOFFSET =  ISNULL(dbo.Ufn_GetCurrentTime(@Offset),SYSDATETIMEOFFSET())

			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			   DECLARE @OldValue NVARCHAR(50) = CASE WHEN @IsArchived = 1 THEN 'unarchived' ELSE 'archived' END

			   DECLARE @NewValue NVARCHAR(50) = CASE WHEN @IsArchived = 1 THEN 'archived' ELSE 'unarchived' END
			   
			   DECLARE @PreviousGoalStatusId UNIQUEIDENTIFIER = (SELECT GoalStatusId FROM Goal WHERE Id = @GoalId)

			   DECLARE @GoalStatusId UNIQUEIDENTIFIER = (SELECT Id FROM GoalStatus WHERE IsArchived = 1 AND InActiveDateTime IS NULL) -- AND CompanyId = @CompanyId)

			   UPDATE [Goal]
			   SET InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @CurrentDate ELSE NULL END,
			       InActiveDateTimeZoneId = CASE WHEN @IsArchived = 1 THEN @TimeZoneId ELSE NULL END,
			       GoalStatusId = CASE WHEN @IsArchived = 1 THEN  @GoalStatusId ELSE [OldGoalStatusId] END
			    ,[OldGoalStatusId] =  CASE WHEN @IsArchived = 1 THEN  @PreviousGoalStatusId ELSE NULL END
			   WHERE Id = @GoalId 

			    IF(ISNULL(@IsArchived,0) = 0)
				UPDATE [Goal] SET GoalStatusColor = (SELECT [dbo].[Ufn_GoalColour] (@GoalId)) WHERE Id = @GoalId --Handled in Background Process

				 INSERT INTO [dbo].[GoalHistory](
		                                         [Id],
		                                         [GoalId],
		                                         [OldValue],
					                             [NewValue],
					                             [FieldName],
					                             [Description],
		                                         CreatedDateTime,
												 CreatedDateTimeZoneId,
		                                         CreatedByUserId
												)
		                                  SELECT NEWID(),
		                                         @GoalId,
		                                         @OldValue,
					                             @NewValue,
					                             'GoalArchive',
					                             'GoalArchive',
		                                         SYSDATETIMEOFFSET(),
												 @TimeZoneId,
		                                         @OperationsPerformedBy

               SELECT Id FROM [dbo].[Goal] WHERE Id = @GoalId
              
           END

           ELSE

               RAISERROR (50015,11, 1)
       END

       ELSE

           RAISERROR (@HavePermission,11, 1)

   END TRY
   BEGIN CATCH

       THROW

   END CATCH
END
GO