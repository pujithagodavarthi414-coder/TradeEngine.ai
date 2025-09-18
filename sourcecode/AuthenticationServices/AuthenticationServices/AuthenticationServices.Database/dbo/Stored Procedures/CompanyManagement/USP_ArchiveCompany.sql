CREATE PROCEDURE [dbo].[USP_ArchiveCompany]
(
    @CompanyId UNIQUEIDENTIFIER,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
	
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    DECLARE @ProcName NVARCHAR(250) = (SELECT OBJECT_NAME(@@PROCID))

        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,@ProcName))

        IF(@HavePermission = '1')
        BEGIN
            
            DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
												FROM [Company] WHERE Id = @CompanyId) = @TimeStamp
										  THEN 1 ELSE 0 END)

            IF(@IsLatest = 1)
			BEGIN
                
                DECLARE @CurrentDate DATETIME = GETDATE()

                UPDATE [dbo].[Company]
                SET InActiveDateTime = @CurrentDate,
                    UpdatedDateTime = @CurrentDate,
                    UpdatedByUserId = @OperationsPerformedBy
                WHERE Id = @CompanyId

                SELECT Id FROM [dbo].[Company] WHERE Id = @CompanyId
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