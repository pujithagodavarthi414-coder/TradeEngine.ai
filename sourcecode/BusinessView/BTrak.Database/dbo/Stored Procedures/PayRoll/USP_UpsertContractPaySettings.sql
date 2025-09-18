-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update ContractPaySettings
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertContractPaySettings]
(
   @ContractPaySettingsId UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @ContractPayTypeId UNIQUEIDENTIFIER = NULL,
   @IsToBePaid BIT,
   @ActiveFrom DATETIME  = NULL,
   @ActiveTo DATETIME  = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@BranchId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Branch')

		END
		ELSE IF(@ContractPayTypeId IS NULL)
		BEGIN

		  RAISERROR(50011,16, 2, 'ContractPayType')

		END
		ELSE IF(@ActiveFrom IS NULL)
		BEGIN

		  RAISERROR(50011,16, 2, 'ActiveFrom')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @ContractPaySettingsIdCount INT = (SELECT COUNT(1) FROM ContractPaySettings  WHERE Id = @ContractPaySettingsId)

	    DECLARE @ContractPaySettingsCount INT = 0

		IF(@ActiveTo IS NULL)
		BEGIN

			SET @ContractPaySettingsCount = (SELECT COUNT(1) FROM ContractPaySettings WHERE BranchId = @BranchId AND ContractPayTypeId = @ContractPayTypeId AND (Id <> @ContractPaySettingsId OR @ContractPaySettingsId IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																						OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
		END
		IF(@ActiveTo IS NOT NULL)
		BEGIN

			SET @ContractPaySettingsCount = (SELECT COUNT(1) FROM ContractPaySettings WHERE BranchId = @BranchId AND ContractPayTypeId = @ContractPayTypeId AND (Id <> @ContractPaySettingsId OR @ContractPaySettingsId IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))

		END

	    IF(@ContractPaySettingsIdCount = 0 AND @ContractPaySettingsId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'ContractPaySettings')

        END
		IF (@ContractPaySettingsCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'ContractPaySettings')

		END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @ContractPaySettingsId IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT TDS.[TimeStamp] 
			                                                                    FROM [ContractPaySettings] TDS JOIN Branch B ON B.Id = TDS.BranchId WHERE TDS.Id = @ContractPaySettingsId  AND B.CompanyId = @CompanyId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@ContractPaySettingsId IS NULL)
							BEGIN

							SET @ContractPaySettingsId = NEWID()

							INSERT INTO [dbo].[ContractPaySettings](
                                                              [Id],
						                                      [BranchId],
															  [ContractPayTypeId],
															  [IsToBePaid],	
															  [ActiveFrom],
															  [ActiveTo],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId]				
															  )
                                                       SELECT @ContractPaySettingsId,
						                                      @BranchId,
															  @ContractPayTypeId,
															  @IsToBePaid, 
															  @ActiveFrom,
															  @ActiveTo,
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [ContractPaySettings]
							      SET BranchId = @BranchId,
								      [ContractPayTypeId] = @ContractPayTypeId,
									  [IsToBePaid] = @IsToBePaid,
									  [ActiveFrom] = @ActiveFrom,
									  [ActiveTo] = @ActiveTo,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @ContractPaySettingsId

							END
			                
			              SELECT Id FROM [dbo].[ContractPaySettings] WHERE Id = @ContractPaySettingsId
			                       
			           END
			           ELSE
			         
			           	RAISERROR (50008,11, 1)
			         
			         END
			         ELSE
			         BEGIN
			         
			         		RAISERROR (@HavePermission,11, 1)
			         		
			         END
           END
		END
		
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO