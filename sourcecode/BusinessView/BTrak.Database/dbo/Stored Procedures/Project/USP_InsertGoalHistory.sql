-------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-09-16 00:00:00.000'
-- Purpose      To Save USP_InsertGoalHistory
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC USP_InsertGoalHistory @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--                                @UserStoryId  = '06F47320-6E13-4C77-B067-E62B4F6B8B69',
--                                @OldValue  = 'Goal1',
--                                @NewValue  = 'Goal2',
--                                @FieldName  = 'GoalName',
--                                @Description  = 'GoalNameChanged'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_InsertGoalHistory]
(
  @GoalId UNIQUEIDENTIFIER = NULL,
  @TimeZoneId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(250) = NULL,
  @NewValue NVARCHAR(250) = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @Description NVARCHAR(800) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @GoalHistoryId UNIQUEIDENTIFIER = NEWID()

		 DECLARE @Offset NVARCHAR(100) = NULL
			
			     SELECT @Offset = TimeZoneOffset FROM TimeZone WHERE Id = @TimeZoneId
		
		INSERT INTO [dbo].[GoalHistory](
		            [Id],
		            [GoalId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
					CreatedDateTimeZoneId,
		            CreatedByUserId)
		     SELECT @GoalHistoryId,
		            @GoalId,
		            @OldValue,
					@NewValue,
					@FieldName,
					@Description,
		            ISNULL(dbo.Ufn_GetCurrentTime(@Offset),SYSDATETIMEOFFSET()),
					@TimeZoneId,
		            @OperationsPerformedBy

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO