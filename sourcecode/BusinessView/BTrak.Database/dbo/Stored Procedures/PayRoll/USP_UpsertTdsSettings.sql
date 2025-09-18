-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update TdsSettings
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertTdsSettings] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@BranchId='0B2921A9-E930-4013-9047-670B5352F306',@IsTdsRequired = 0	  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertTdsSettings]
(
   @TdsSettingsId UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL ,
   @IsTdsRequired BIT,
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
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @TdsSettingsIdCount INT = (SELECT COUNT(1) FROM TdsSettings  WHERE Id = @TdsSettingsId)

		DECLARE @TdsSettingsCount INT = (SELECT COUNT(1) FROM TdsSettings TDS JOIN Branch B ON B.Id = TDS.BranchId  WHERE TDS.BranchId = @BranchId AND B.CompanyId = @CompanyId 
																		AND (@TdsSettingsId IS NULL OR @TdsSettingsId <> TDS.Id))
       
	    IF(@TdsSettingsIdCount = 0 AND @TdsSettingsId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'TdsSettings')

        END
		IF (@TdsSettingsCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'TdsSettings')

		END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @TdsSettingsId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT TDS.[TimeStamp] 
			                                                                    FROM [TdsSettings] TDS JOIN Branch B ON B.Id = TDS.BranchId WHERE TDS.Id = @TdsSettingsId  AND B.CompanyId = @CompanyId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@TdsSettingsId IS NULL)
							BEGIN

							SET @TdsSettingsId = NEWID()

							INSERT INTO [dbo].[TdsSettings](
                                                              [Id],
						                                      [BranchId],
															  [IsTdsRequired],	
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId]				
															  )
                                                       SELECT @TdsSettingsId,
						                                      @BranchId,
															  @IsTdsRequired, 
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [TdsSettings]
							      SET BranchId = @BranchId,
									  [IsTdsRequired] = @IsTdsRequired,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @TdsSettingsId

							END
			                
			              SELECT Id FROM [dbo].[TdsSettings] WHERE Id = @TdsSettingsId
			                       
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