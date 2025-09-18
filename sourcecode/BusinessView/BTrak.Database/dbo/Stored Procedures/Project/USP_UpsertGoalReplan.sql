-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-10 00:00:00.000'
-- Purpose      To Save or Update GoalReplan
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertGoalReplan] @GoalId = 'ff4047b8-39b1-42d2-8910-4e60ed38aac7',@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@GoalReplanTypeId='e548cd87-6401-4eeb-8527-6f90f81247fb'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertGoalReplan]
(
  @GoalReplanId   UNIQUEIDENTIFIER = NULL,
  @GoalId   UNIQUEIDENTIFIER = NULL,
  @GoalReplanTypeId   UNIQUEIDENTIFIER = NULL,
  @Reason  NVARCHAR(100) = NULL,
  @IsArchived  BIT = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetProjectIdByGoalId](@GoalId))

		DECLARE @TimeZoneId UNIQUEIDENTIFIER = NULL,@Offset NVARCHAR(100) = NULL
			
		SELECT @TimeZoneId = Id,@Offset = TimeZoneOffset FROM TimeZone WHERE TimeZone = @TimeZone

        DECLARE @Currentdate DATETIMEOFFSET =  ISNULL(dbo.Ufn_GetCurrentTime(@Offset),SYSDATETIMEOFFSET())

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
        BEGIN

				--DECLARE @Currentdate DATETIME = SYSDATETIMEOFFSET()

				DECLARE @IsLatest BIT = (CASE WHEN @GoalReplanId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                           FROM [GoalReplan] WHERE Id = @GoalReplanId ) = @TimeStamp
																THEN 1 ELSE 0 END END)

				IF(@IsLatest = 1)
				BEGIN

				    DECLARE @GoalReplanCount INT

			        SELECT @GoalReplanCount = COUNT(1) FROM GoalReplan WHERE GoalId = @GoalId

					IF(@GoalReplanId IS NOT NULL)
				    BEGIN
				    
				    UPDATE [GoalReplan] 
				    SET GoalId = @GoalId,
					[GoalReplanTypeId] = @GoalReplanTypeId,
				    [Reason] = @Reason,
				    [UpdatedDateTime] = @Currentdate,
					[UpdatedDateTimeZone] =  @TimeZoneId,
				    [UpdatedByUserId] = @OperationsPerformedBy,
				    InactiveDateTime = CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END,
					[GoalReplanCount] = [GoalReplanCount]
				    WHERE Id = @GoalReplanId
				    
				    END
				    ELSE
				    BEGIN
				    
				        SET @GoalReplanId = NEWID()
				    
				    	INSERT INTO [GoalReplan](Id,
				    							 GoalId,
												 [GoalReplanTypeId],
				    							 [Reason],
				    							 CreatedByUserId,
				    						     CreatedDateTime,
												 CreatedDateTimeZone,
				    							 InactiveDateTime,
												 [GoalReplanCount])
				    				      SELECT @GoalReplanId,
				    						     @GoalId,
												 @GoalReplanTypeId,
				    						     @Reason,
				    						     @OperationsPerformedBy,
				    						     GETDATE(),
												 @TimeZoneId,
				    						     CASE WHEN @IsArchived = 1 THEN GETDATE() ELSE NULL END
												  ,ISNULL(@GoalReplanCount,0) + 1
				    END

					SELECT Id FROM [dbo].[GoalReplan] where Id = @GoalReplanId

				END

				ELSE

			  		RAISERROR (50008,11, 1)

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
