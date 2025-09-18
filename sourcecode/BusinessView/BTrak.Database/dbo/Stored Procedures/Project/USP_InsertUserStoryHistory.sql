-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-03-16 00:00:00.000'
-- Purpose      To Save UserStoryHistory
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC USP_InsertUserStoryHistory @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--                                @UserStoryId  = '06F47320-6E13-4C77-B067-E62B4F6B8B69',
--                                @OldValue  = '2019-03-04 00:00:00.000',
--                                @NewValue  = '2019-03-10 00:00:00.000',
--                                @FieldName  = 'DeadLine Date',
--                                @Description  = 'DeadLine Date is changed from 2019-03-04 00:00:00.000 to 2019-03-10 00:00:00.000'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_InsertUserStoryHistory]
(
  @UserStoryId UNIQUEIDENTIFIER = NULL,
  @TimeZoneId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(MAX) = NULL,
  @NewValue NVARCHAR(MAX) = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @Description NVARCHAR(max) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @UserStoryHistoryId UNIQUEIDENTIFIER = NEWID()

		DECLARE @Offset NVARCHAR(100) = (SELECT TimeZoneOffset FROM TimeZone WHERE Id = @TimeZoneId)
		
		INSERT INTO [dbo].[UserStoryHistory](
		            [Id],
		            [UserStoryId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
					CreatedDateTimeZoneId,
		            CreatedByUserId)
		     SELECT @UserStoryHistoryId,
		            @UserStoryId,
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