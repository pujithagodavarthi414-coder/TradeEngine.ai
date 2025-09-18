CREATE PROCEDURE [dbo].[USP_UpsertCompanyLogo]
(
    @LogoData NVARCHAR(max) = NULL,
    @LogoType NVARCHAR(250), 
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		   DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	        
            IF (@HavePermission = '1')
            BEGIN

		     DECLARE @CurrentDate DATETIME = GETDATE()

		 	IF(@LogoType='mainlogo')
				BEGIN

					UPDATE [CompanySettings] SET CompanyId = @CompanyId, [Value] = @LogoData,UpdatedDateTime = @CurrentDate,UpdatedByUserId = @OperationsPerformedBy 
					WHERE [Key] = 'CompanyRegisatrationLogo' and CompanyId = @CompanyId
					
					 
					UPDATE [CompanySettings] SET CompanyId = @CompanyId, [Value] = @LogoData,UpdatedDateTime = @CurrentDate,UpdatedByUserId = @OperationsPerformedBy 
					WHERE [Key] = 'CompanySigninLogo' and CompanyId = @CompanyId 

				END

			IF(@LogoType = 'paysliplogo')
				BEGIN

					UPDATE [CompanySettings] SET CompanyId = @CompanyId, [Value] = @LogoData,UpdatedDateTime = @CurrentDate,UpdatedByUserId = @OperationsPerformedBy 
					WHERE [Key] = 'CompanyPayslipLogo' and CompanyId = @CompanyId

				END
                   
			BEGIN
			
				DECLARE @CompanyLogo NVARCHAR(MAX) = (SELECT [Value] FROM [dbo].[CompanySettings] WHERE [Key] = @LogoType and CompanyId = @CompanyId)

				IF(@CompanyLogo IS NULL)
					BEGIN
					INSERT INTO [CompanySettings](
								[Id],
								[CompanyId],
								[Description],
								[Key],
								[Value],
								[CreatedByUserId],
								[CreatedDateTime])
						  SELECT NEWID(),
                                 @CompanyId,
                                 @LogoType,
								 @LogoType,
                                 @LogoData,
                                 @OperationsPerformedBy,
								 @Currentdate

			        END
				ELSE
					BEGIN
						UPDATE [CompanySettings]
						    SET CompanyId       = @CompanyId,
								[Value] = @LogoData,
								UpdatedDateTime = @CurrentDate,
								UpdatedByUserId = @OperationsPerformedBy
								WHERE [Key] = @LogoType and CompanyId = @CompanyId 
					END

				SELECT [Value] FROM [dbo].[CompanySettings] WHERE [Key] = @LogoType and CompanyId = @CompanyId 
				END
	        END
	        ELSE
	        BEGIN
	        
	            RAISERROR (@HavePermission,11, 1)
	        
	        END
    END TRY
    BEGIN CATCH

        EXEC USP_GetErrorInformation

    END CATCH
END
