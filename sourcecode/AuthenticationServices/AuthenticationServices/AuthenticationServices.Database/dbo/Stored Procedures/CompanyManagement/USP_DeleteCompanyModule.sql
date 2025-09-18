CREATE PROCEDURE [dbo].[USP_DeleteCompanyModule]
(
    @CompanyModuleId UNIQUEIDENTIFIER = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    DECLARE @ProcName NVARCHAR(250) = (SELECT OBJECT_NAME(@@PROCID))
        
	    DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,@ProcName))
			        
		IF (@HavePermission = '1')
		BEGIN

			DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
												FROM [CompanyModule] WHERE Id = @CompanyModuleId) = @TimeStamp
										  THEN 1 ELSE 0 END)
        
			IF(@IsLatest = 1)
			BEGIN

				DECLARE @CurrentDate DATETIME = GETDATE()

				--DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

				    UPDATE [CompanyModule]
				     SET   InActiveDateTime = @CurrentDate,
					       UpdatedDateTime  = @CurrentDate,
						   UpdatedByUserId  = @OperationsPerformedBy
						 WHERE Id = @CompanyModuleId 
				 
				SELECT Id FROM [dbo].[CompanyModule] WHERE Id = @CompanyModuleId

			END
			ELSE
				RAISERROR (50015,11, 1)

		END
		ELSE
			RAISERROR (@HavePermission,11, 1)

    END TRY
    BEGIN CATCH

        EXEC USP_GetErrorInformation

    END CATCH
END
GO
