-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar Vuyyuru
-- Created      '2018-02-07 00:00:00.000'
-- Purpose      To Get status reports by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertStatusReportingSeenStatus]
(
 @StatusReportId UNIQUEIDENTIFIER = NULL,
 @SeenStatus BIT,
 @OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON

    BEGIN TRY

	 DECLARE @HavePermission NVARCHAR(250) = (SELECt [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	  IF (@HavePermission = '1')
	  BEGIN

        DECLARE @Id UNIQUEIDENTIFIER, @Currentdate DATETIME

        SELECT @Id = Id FROM [dbo].[StatusReportSeenHistory] WHERE StatusReportId = @StatusReportId AND CreatedByUserId = @OperationsPerformedBy
        SELECT @Currentdate = GETDATE()
        
        IF (@Id IS NOT NULL)
        BEGIN

              UPDATE [dbo].[StatusReportSeenHistory]
              SET Seen = @SeenStatus,
				  UpdatedDateTime = @Currentdate
              WHERE Id = @Id

        END
        ELSE
        BEGIN
			 
             INSERT INTO [dbo].[StatusReportSeenHistory](
                         [Id],
                         StatusReportId,
                         Seen,
                         [CreatedDateTime],
                         [CreatedByUserId])
                  SELECT NEWID(),
                         @StatusReportId,
                         @SeenStatus,
                         @Currentdate,
                         @OperationsPerformedBy

        END
        
        SELECT Id FROM [dbo].[StatusReportSeenHistory] WHERE StatusReportId = @StatusReportId AND CreatedByUserId = @OperationsPerformedBy

	END
    END TRY
    BEGIN CATCH
      THROW	  
    END CATCH

END
GO

