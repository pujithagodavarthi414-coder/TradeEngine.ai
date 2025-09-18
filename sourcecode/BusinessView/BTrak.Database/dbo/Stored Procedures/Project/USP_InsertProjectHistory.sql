
-- EXEC USP_InsertProjectHistory @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--                                @ProjectId  = '06F47320-6E13-4C77-B067-E62B4F6B8B69',
--                                @OldValue  = 'Project1',
--                                @NewValue  = 'Project2',
--                                @FieldName  = 'ProjectName',
--                                @Description  = 'ProjectNameChanged'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_InsertProjectHistory]
(
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(250) = NULL,
  @NewValue NVARCHAR(250) = NULL,
  @TimeZoneId UNIQUEIDENTIFIER = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @Description NVARCHAR(800) = NULL,
  @ReferenceId UNIQUEIDENTIFIER = NULL, 
  @OperationsPerformedBy UNIQUEIDENTIFIER
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @ProjectHistoryId UNIQUEIDENTIFIER = NEWID()
		DECLARE @Offset NVARCHAR(250)

		 SELECT  @Offset = TimeZoneOffset FROM TimeZone WHERE Id = @TimeZoneId
				                  
         DECLARE @Currentdate DATETIMEOFFSET =  ISNULL(dbo.Ufn_GetCurrentTime(@Offset),SYSDATETIMEOFFSET())
          
		INSERT INTO [dbo].[ProjectHistory](
		            [Id],
		            [ProjectId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
					ReferenceId,
		            CreatedDateTime,
					CreatedDateTimeZoneId,
		            CreatedByUserId)
		     SELECT @ProjectHistoryId,
		            @ProjectId,
		            @OldValue,
					@NewValue,
					@FieldName,
					@Description,
					@ReferenceId,
		            SYSDATETIMEOFFSET(),
					@TimeZoneId,
		            @OperationsPerformedBy

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO