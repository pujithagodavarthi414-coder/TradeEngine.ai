-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update PayRollRunEmployeeComponentYTD
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertPayRollRunEmployeeComponentYTD]
(
   @PayRollRunEmployeeComponentYTDId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @PayRollRunId UNIQUEIDENTIFIER = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @Comments NVARCHAR(800),
   @OriginalComponentAmount [decimal](18,4) = NULL,
   @ComponentId UNIQUEIDENTIFIER = NULL,
   @IsDeduction BIT = NULL,
   @ComponentAmount [decimal](18,4) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@PayRollRunEmployeeComponentYTDId = '00000000-0000-0000-0000-000000000000')
		BEGIN
		SET @PayRollRunEmployeeComponentYTDId = NULL;
		END

		IF(@IsDeduction IS NULL) SET @IsDeduction = 0

		DECLARE @ComponentName NVARCHAR(250)

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF(@ComponentId IS NOT NULL)
		BEGIN

		SET @ComponentName = (SELECT ComponentName FROM payrollComponent WHERE Id = @ComponentId AND @CompanyId = CompanyId)

		END

		
		SET @PayRollRunEmployeeComponentYTDId = (SELECT Id FROM [PayRollRunEmployeeComponentYTD] WHERE 
		ComponentId = @ComponentId AND EmployeeId = @EmployeeId AND PayRollRunId = @PayRollRunId)

		DECLARE @PayRollRunEmployeeComponentYTDIdCount INT = (SELECT COUNT(1) FROM PayRollRunEmployeeComponentYTD WHERE Id = @PayRollRunEmployeeComponentYTDId)

		DECLARE @PayRollComponentCount INT = (SELECT COUNT(1) FROM PayRollRunEmployeeComponentYTD WHERE [ComponentId] = @ComponentId AND [EmployeeId] = @EmployeeId AND 
																		[PayRollRunId] = @PayRollRunId AND (@PayRollRunEmployeeComponentYTDId 
																		IS NULL OR @PayRollRunEmployeeComponentYTDId <> Id))
	    IF(@PayRollRunEmployeeComponentYTDIdCount = 0 AND @PayRollRunEmployeeComponentYTDId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'PayRollRunEmployeeComponentYTD')

        END
		IF (@PayRollComponentCount > 0)
		BEGIN

			RAISERROR(50001,11,1,'PayRollRunEmployeeComponentYTD')

		END
        ELSE        
		BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = 1
			         
			            IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@PayRollRunEmployeeComponentYTDId IS NULL)
							BEGIN

							SET @PayRollRunEmployeeComponentYTDId = NEWID()

							INSERT INTO [dbo].[PayRollRunEmployeeComponentYTD](
							                  [Id],
											  [ComponentId],
							                  [EmployeeId],
							                  [PayRollRunId],
											  [OriginalComponentAmount],
							                  [CreatedDateTime],
							                  [CreatedByUserId],
											  [Comments],
											  [IsDeduction],
											  [ComponentName],
											  [ComponentAmount])
                                       SELECT @PayRollRunEmployeeComponentYTDId,
									          @ComponentId,  
										      @EmployeeId,
											  @PayRollRunId,
											  CASE WHEN @IsDeduction = 1 THEN -1 * @OriginalComponentAmount ELSE @OriginalComponentAmount END,
						                      @Currentdate,
						                      @OperationsPerformedBy,
                                              @Comments,
											  @IsDeduction,
											  @ComponentName,
											  @ComponentAmount
		                     
							END
							ELSE
							BEGIN

							  UPDATE [PayRollRunEmployeeComponentYTD]           
							     SET [Comments] = @Comments,
									 [ComponentAmount] = CASE WHEN @IsDeduction = 1 THEN -1 * @ComponentAmount ELSE @ComponentAmount END,
									 [UpdatedDateTime] = @Currentdate,
									 [UpdatedByUserId] = @OperationsPerformedBy
									 WHERE Id = @PayRollRunEmployeeComponentYTDId 
							END
			                

							SELECT Id FROM [dbo].[PayRollRunEmployeeComponentYTD] WHERE Id = @PayRollRunEmployeeComponentYTDId
			                       
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