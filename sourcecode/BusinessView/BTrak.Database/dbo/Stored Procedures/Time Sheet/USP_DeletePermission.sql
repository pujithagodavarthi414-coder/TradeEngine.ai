-------------------------------------------------------------------------------
-- Author       Padmini B
-- Created      '2019-04-18 00:00:00.000'
-- Purpose      To Delete Permission
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-----------------------------------------------------------------------------------------------------------------------------------------------------------
--DECLARE @Temp TIMESTAMP = (SELECT [TimeStamp] FROM Permission WHERE OriginalId = 'FB43FA94-64F2-4882-B148-326E3480835B' AND AsAtInactiveDateTime IS NULL) 
--EXEC [dbo].[USP_DeletePermission] @PermissionId='FB43FA94-64F2-4882-B148-326E3480835B'
--,@TimeStamp = @Temp
--,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-----------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_DeletePermission]
(
   @PermissionId UNIQUEIDENTIFIER = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 	
	
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
       IF (@HavePermission = '1')
       BEGIN

           DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp] FROM Permission WHERE Id = @PermissionId ) = @TimeStamp
                                         THEN 1 ELSE 0 END) 

           IF(@IsLatest = 1)
           BEGIN

               DECLARE @CurrentDate DATETIME = GETDATE()
              
                 UPDATE [Permission]
				   SET [InActiveDateTime] = @CurrentDate,
				       [UpdatedDateTime] = @CurrentDate,
					   [UpdatedByUserId] = @OperationsPerformedBy
					   WHERE Id = @PermissionId

               SELECT Id FROM [dbo].Permission WHERE Id = @PermissionId
                
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