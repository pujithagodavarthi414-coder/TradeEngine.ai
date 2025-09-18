-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-02-19 00:00:00.000'
-- Purpose      To Save or Update LeaveEncashmentSettings
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertLeaveEncashmentSettings] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@ComponentName='Test',@IsDeduction = 0,@IsVariablePay = 0			  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertLeaveEncashmentSettings]
(
   @LeaveEncashmentSettingsId UNIQUEIDENTIFIER = NULL,
   @PayRollComponentId UNIQUEIDENTIFIER = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsCtcType BIT,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @Percentage DECIMAL(18,4) = NULL,
   @Amount DECIMAL(18,4) = NULL,
   @ActiveFrom DATETIME = NULL,
   @ActiveTo DATETIME = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @LeaveEncashmentSettingsIdCount INT = (SELECT COUNT(1) FROM LeaveEncashmentSettings  WHERE Id = @LeaveEncashmentSettingsId)

        IF(@BranchId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Branch')

		END
	    ELSE IF(@ActiveFrom IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'ActiveFrom')
        END

		DECLARE @LeaveEncashmentSettingsCount INT = 0

		IF(@ActiveTo IS NULL)
		BEGIN

			SET @LeaveEncashmentSettingsCount = (SELECT COUNT(1) FROM LeaveEncashmentSettings WHERE BranchId = @BranchId AND (Id <> @LeaveEncashmentSettingsId OR @LeaveEncashmentSettingsId IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)
																						OR (@ActiveFrom >= ActiveFrom AND (ActiveTo IS NULL OR @ActiveFrom <= ActiveTo ) AND @ActiveTo IS NULL)))
		END
		IF(@ActiveTo IS NOT NULL)
		BEGIN

			SET @LeaveEncashmentSettingsCount = (SELECT COUNT(1) FROM LeaveEncashmentSettings WHERE BranchId = @BranchId AND (Id <> @LeaveEncashmentSettingsId OR @LeaveEncashmentSettingsId IS NULL) AND
																						((@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom <= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo <= ActiveTo AND @ActiveTo >= ActiveFrom )))
																						OR (@ActiveFrom >= ActiveFrom AND @ActiveTo >= ActiveFrom AND (ActiveTo IS NULL OR (@ActiveTo >= ActiveTo AND @ActiveTo >= ActiveFrom AND @ActiveFrom <= ActiveTo)))))

		END

	    IF(@LeaveEncashmentSettingsIdCount = 0 AND @LeaveEncashmentSettingsId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'LeaveEncashmentSettings')

        END
		IF(@LeaveEncashmentSettingsCount > 0)
        BEGIN

            RAISERROR('LeaveEncashmentSettingsActiveFromOrActiveToDateMatchesWithOtherActiveFromOrActiveToDate',16, 1)

        END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @LeaveEncashmentSettingsId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [LeaveEncashmentSettings] WHERE Id = @LeaveEncashmentSettingsId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@LeaveEncashmentSettingsId IS NULL)
							BEGIN

							SET @LeaveEncashmentSettingsId = NEWID()

							INSERT INTO [dbo].[LeaveEncashmentSettings](
                                                              [Id],
						                                      [PayRollComponentId],
															  [BranchId],
															  [IsCtcType],
															  [Percentage],	
															  [Amount],
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId],
															  [ActiveFrom],
                                                              [ActiveTo]
															  )
                                                       SELECT @LeaveEncashmentSettingsId,
						                                      @PayRollComponentId,
															  @BranchId,
						                                      @IsCtcType,
															  @Percentage,
															  @Amount,
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy,
															  @ActiveFrom,
                                                              @ActiveTo
		                     
							END
							ELSE
							BEGIN

							  UPDATE [LeaveEncashmentSettings]
							      SET [PayRollComponentId] = @PayRollComponentId,
								      [BranchId] = @BranchId,
								      [IsCtcType] = @IsCtcType,
									  [Percentage] = @Percentage,
									  [Amount] = @Amount,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy,
									  [ActiveFrom] = @ActiveFrom,
                                      [ActiveTo]  = @ActiveTo
									  WHERE Id = @LeaveEncashmentSettingsId

							END
			                
			              SELECT Id FROM [dbo].[LeaveEncashmentSettings] WHERE Id = @LeaveEncashmentSettingsId
			                       
			           END
			           ELSE
			         
			           	RAISERROR (50008,11, 1)
			         
			         END
			         ELSE
			         BEGIN
			         
			         		RAISERROR (@HavePermission,11, 1)
			         		
			         END
           END
    END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO