-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2018-02-07 00:00:00.000'
-- Purpose      to Save or update the status reports
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertStatusReport] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @StatusReportingConfigurationOptionId = 'A36252AD-2532-47CC-ABCE-0AF57A2D6930',@Description = 'Test Form 2'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_UpsertStatusReport]
(
	@StatusReportingConfigurationOptionId UNIQUEIDENTIFIER = NULL,
	@FilePath NVARCHAR(250) = NULL,
	@FileName NVARCHAR(250) = NULL,
	@FormDataJson NVARCHAR(MAX) = NULL,
	@Description NVARCHAR(MAX) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL,
	@SubmittedDateTime DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
     IF (@HavePermission = '1')
     BEGIN
	  IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	  IF (@StatusReportingConfigurationOptionId = '00000000-0000-0000-0000-000000000000') SET @StatusReportingConfigurationOptionId = NULL

	  IF (@Description = '') SET @Description = NULL

	  IF(@StatusReportingConfigurationOptionId IS NULL)
	  BEGIN
		   
		   RAISERROR(50011,16, 2, 'StatusReportingConfigurationOption')

	  END
	  ELSE 
	  BEGIN

          DECLARE @Currentdate DATETIME = GETDATE()
		  
		  DECLARE @ReportId UNIQUEIDENTIFIER = NEWID()

		  DECLARE @FormJson [nvarchar](MAX) = (
										SELECT GF.FormJson from [StatusReportingConfigurationOption] SRCO
										JOIN [StatusReportingConfiguration_New] SRCN ON SRCN.Id = SRCO.[StatusReportingConfigurationId] AND SRCN.InActiveDateTime IS NULL
										JOIN [GenericForm] GF ON GF.Id = SRCN.GenericFormId AND GF.InActiveDateTime IS NULL
										WHERE SRCO.Id = @StatusReportingConfigurationOptionId AND SRCO.InActiveDateTime IS NULL)

             INSERT INTO [dbo].[StatusReporting_New](
                         [Id],
                         [StatusReportingConfigurationOptionId],
		  				 [Description],
		  				 [FormDataJson],
						 [FormJson],
		  				 [FileName],
		  				 [FilePath],
						 [SubmittedDateTime],
		  				 [CreatedDateTime],
		  				 [CreatedByUserId],
		  				 [InActiveDateTime]
						 )
                  SELECT @ReportId,
		  				 @StatusReportingConfigurationOptionId,
		  				 @Description,
		  				 @FormDataJson,
						 @FormJson,
		  				 @FileName,
		  				 @FilePath,
						 @SubmittedDateTime,
		  				 @Currentdate,
		  				 @OperationsPerformedBy,
		  				 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
		  
		  SELECT Id FROM [dbo].[StatusReporting_New] where Id = @ReportId

      END
	END
    END TRY
    BEGIN CATCH

         THROW

    END CATCH
END
GO