-------------------------------------------------------------------------------
-- Author       Padmini
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Save Timesheet History
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC USP_UpsertTimeSheetHistory NULL,
--								  @TimesheetId = '4829CC3A-0DD3-4F99-9A7C-014AD4239BF5'
--                                @OldValue  = '2019-03-04 00:00:00.000',
--                                @NewValue  = '2019-03-10 00:00:00.000',
--                                @FieldName  = 'In Time',
--                                @Description  = 'UserName intime is 9:20 and lunch break : 13:40 and lunch end : 15:10 and finish time : 18:20',
--								  @OperationsPerformedBy='F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertTimeSheetHistory]
(
    @TimesheetHistoryId UNIQUEIDENTIFIER = NULL,
    @TimeSheetId UNIQUEIDENTIFIER = NULL,
    @OldValue  NVARCHAR(250) = NULL,
    @NewValue  NVARCHAR(250) = NULL,
    @FieldName  NVARCHAR(50) = NULL,
    @Description  NVARCHAR(800) = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

       DECLARE @Currentdate DATETIME = GETDATE()

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        SELECT @TimesheetHistoryId = NEWID()
            INSERT INTO [dbo].[TimeSheetHistory](
                        [Id],
                         [TimeSheetId],
                         [OldValue],
                         [NewValue],
                         [FieldName],
                         [Description],                        
                         [CreatedDateTime],
                         [CreatedByUserId])
                 SELECT @TimesheetHistoryId,
                         @TimeSheetId,
                         @OldValue,
                         @NewValue,
                         @FieldName,
                         @Description,
                         @Currentdate,
                         @OperationsPerformedBy

       SELECT Id FROM [dbo].[TimeSheetHistory] where Id = @TimesheetHistoryId

   END TRY
   BEGIN CATCH

       THROW

   END CATCH
END