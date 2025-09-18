-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-03-20 00:00:00.000'
-- Purpose      To Save or Update the Companylogo
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[[USP_UpsertCompanyLogo]]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ModuleId='5D48C02F-D270-43E6-81AD-11E3F630DB00',@IsActive=1,@CompanyModuleId='71F7294B-E9AC-4FEB-A193-D6B761AEF399'

CREATE PROCEDURE [dbo].[USP_UpsertCompanyLogo]
(
    @LogoData NVARCHAR(max) = NULL,
    @LogoType NVARCHAR(250), 
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	        
            IF (@HavePermission = '1')
            BEGIN

		     DECLARE @CurrentDate DATETIME = GETDATE()
	            
             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

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
