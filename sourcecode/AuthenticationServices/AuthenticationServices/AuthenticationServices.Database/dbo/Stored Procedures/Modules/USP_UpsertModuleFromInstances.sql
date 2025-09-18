CREATE PROCEDURE [dbo].[USP_UpsertModuleFromInstances]
	@CompanyIds NVARCHAR(250) = NULL,
	@OperationPerformedBy UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
         DECLARE @HavePermission NVARCHAR(250)  = '1'
         IF(@HavePermission = '1')
         BEGIN
             DECLARE @CurrentDate DATETIME = GETDATE()
         END
         ELSE
			BEGIN
			   RAISERROR (50015,11, 1)
			END
      END TRY
    BEGIN CATCH
       THROW
    END CATCH
END

