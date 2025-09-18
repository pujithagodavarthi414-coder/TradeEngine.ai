-------------------------------------------------------------------------------
-- Author       Padmini B
-- Created      '2019-09-11 00:00:00.000'
-- Purpose      To Get the task status
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetTaskStatus] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetTaskStatus]
(  
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON

    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        SELECT TS.Id AS TaskStatusId,
               TS.TaskStatusName,
               TotalCount = COUNT(1) OVER()
        FROM [dbo].[TaskStatus] TS

    END TRY  
    BEGIN CATCH 
        
        THROW

    END CATCH

END