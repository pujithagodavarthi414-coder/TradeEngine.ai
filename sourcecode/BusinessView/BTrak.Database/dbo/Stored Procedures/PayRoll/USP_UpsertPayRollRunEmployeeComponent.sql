-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update PayRollRunEmployeeComponent
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayRollRunEmployeeComponent]
(
   @PayRollRunEmployeeComponentId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @PayRollRunId UNIQUEIDENTIFIER = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @Comments NVARCHAR(800),
   @ActualComponentAmount [decimal](18,4) = NULL,
   @ComponentId UNIQUEIDENTIFIER = NULL,
   @IsDeduction BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@PayRollRunEmployeeComponentId = '00000000-0000-0000-0000-000000000000')
		BEGIN
		SET @PayRollRunEmployeeComponentId = NULL;
		END

		IF(@IsDeduction IS NULL) SET @IsDeduction = 0

		DECLARE @ComponentName NVARCHAR(250)

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF(@ComponentId IS NOT NULL)
		BEGIN

		SET @ComponentName = (SELECT ComponentName FROM payrollComponent WHERE Id = @ComponentId AND @CompanyId = CompanyId)

		END

		DECLARE @PayRollRunEmployeeComponentIdCount INT = (SELECT COUNT(1) FROM PayRollRunEmployeeComponent WHERE Id = @PayRollRunEmployeeComponentId)

		DECLARE @PayRollComponentCount INT = (SELECT COUNT(1) FROM PayRollRunEmployeeComponent WHERE [ComponentId] = @ComponentId AND [EmployeeId] = @EmployeeId AND 
																		[PayRollRunId] = @PayRollRunId AND (@PayRollRunEmployeeComponentId IS NULL 
																		OR @PayRollRunEmployeeComponentId <> Id))
		
       
	    IF(@PayRollRunEmployeeComponentIdCount = 0 AND @PayRollRunEmployeeComponentId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'PayRollRunEmployeeComponent')

        END
		IF (@PayRollComponentCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'PayRollRunEmployeeComponent')

		END
        ELSE        
		BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = 1
			         
			            IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@PayRollRunEmployeeComponentId IS NULL)
							BEGIN

							SET @PayRollRunEmployeeComponentId = NEWID()

							INSERT INTO [dbo].[PayRollRunEmployeeComponent](
							                  [Id],
											  [ComponentId],
							                  [EmployeeId],
							                  [PayRollRunId],
											  [ActualComponentAmount],
							                  [CreatedDateTime],
							                  [CreatedByUserId],
											  [Comments],
											  [IsDeduction],
											  [ComponentName])
                                       SELECT @PayRollRunEmployeeComponentId,
									          @ComponentId,  
										      @EmployeeId,
											  @PayRollRunId,
											  CASE WHEN @IsDeduction = 1 THEN -1 * @ActualComponentAmount ELSE @ActualComponentAmount END,
						                      @Currentdate,
						                      @OperationsPerformedBy,
                                              @Comments,
											  @IsDeduction,
											  @ComponentName
		                     
							END
							ELSE
							BEGIN

							  UPDATE [PayRollRunEmployeeComponent]           
							     SET [Comments] = @Comments,
									 [ActualComponentAmount] = CASE WHEN IsDeduction = 1 THEN -1 * @ActualComponentAmount ELSE @ActualComponentAmount END,
									 [UpdatedDateTime] = @Currentdate,
									 [UpdatedByUserId] = @OperationsPerformedBy
									 WHERE Id = @PayRollRunEmployeeComponentId 
							END
			                
							UPDATE PayrollRunEmployee SET ActualPaidAmount = (ISNULL((SELECT SUM(ActualComponentAmount) FROM [PayRollRunEmployeeComponent] P INNER JOIN PayrollComponent PC ON PC.Id = P.ComponentId WHERE PC.EmployerContributionPercentage IS NULL AND P.IsDeduction = 0 AND PayrollRunId = @PayRollRunId AND EmployeeId = @EmployeeId),0) - ISNULL(ABS((SELECT SUM(ActualComponentAmount) FROM [PayRollRunEmployeeComponent] WHERE IsDeduction = 1 AND PayrollRunId = @PayRollRunId AND EmployeeId = @EmployeeId)),0)),
							                              ActualEarningsToDate = (ISNULL((SELECT SUM(ActualComponentAmount) FROM [PayRollRunEmployeeComponent] P WHERE P.IsDeduction = 0 AND PayrollRunId = @PayRollRunId AND EmployeeId = @EmployeeId),0)),
														  ActualDeductionsToDate = (ISNULL((SELECT SUM(ActualComponentAmount) FROM [PayRollRunEmployeeComponent] P WHERE P.IsDeduction = 1 AND PayrollRunId = @PayRollRunId AND EmployeeId = @EmployeeId),0)),
														  ActualEarning = (ISNULL((SELECT SUM(ActualComponentAmount) FROM [PayRollRunEmployeeComponent] P WHERE P.IsDeduction = 0 AND PayrollRunId = @PayRollRunId AND EmployeeId = @EmployeeId),0)),
														  ActualDeduction = (ISNULL((SELECT SUM(ActualComponentAmount) FROM [PayRollRunEmployeeComponent] P WHERE P.IsDeduction = 1 AND PayrollRunId = @PayRollRunId AND EmployeeId = @EmployeeId),0))
							WHERE PayrollRunId = @PayRollRunId AND EmployeeId = @EmployeeId

							SELECT Id FROM [dbo].[PayRollRunEmployeeComponent] WHERE Id = @PayRollRunEmployeeComponentId
			                       
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