-------------------------------------------------------------------------------
-- Author       Padmini
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Get the Timesheet History Details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_SearchTimeSheetHistory] @OperationsPerformedBy='F6AE7214-2B1B-46FD-A775-9FF356CD6E0F'

CREATE PROCEDURE [dbo].[USP_SearchTimeSheetHistory]
(
   @Pagesize INT = 10,
   @Pagenumber INT = 1,
   @Description Varchar(250) = NULL,
   @OldValue Varchar(250) = NULL,
   @NewValue Varchar(250) = NULL,
   @FiledName Varchar(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        SELECT * FROM [TimeSheetHistory] Where ([Description] LIKE '%'+@Description+'%' OR @Description IS NULL)
											   AND(OldValue LIKE '%'+ @OldValue + '%' OR @OldValue IS NULL)
											   AND(NewValue LIKE '%'+ @NewValue + '%' OR @NewValue IS NULL)
											   AND([FieldName] LIKE '%'+ @FiledName + '%' OR @FiledName IS NULL)
											   AND CreatedByUserId = @OperationsPerformedBy
 END TRY
 BEGIN CATCH
 SELECT ERROR_NUMBER() AS ErrorNumber,
             ERROR_SEVERITY() AS ErrorSeverity,
             ERROR_STATE() AS ErrorState,
             ERROR_PROCEDURE() AS ErrorProcedure,
             ERROR_LINE() AS ErrorLine,
             ERROR_MESSAGE() AS ErrorMessage
END CATCH
END