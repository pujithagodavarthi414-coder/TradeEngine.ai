-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update EmployeeAccountDetails
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertEmployeeAccountDetails] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@ComponentName='Test',@IsDeduction = 0,@IsVariablePay = 0			  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeAccountDetails]
(
   @EmployeeAccountDetailsId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @PFNumber NVARCHAR(100) = NULL,
   @UANNumber NVARCHAR(100) = NULL,
   @ESINumber NVARCHAR(100) = NULL,
   @PANNumber NVARCHAR(100) = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	   IF(@PFNumber = '')
	   SET @PFNumber = NULL
	   IF(@UANNumber = '')
	   SET @UANNumber = NULL
	   IF(@ESINumber = '')
	   SET @ESINumber = NULL
	   IF(@PANNumber = '')
	   SET @PANNumber = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @EmployeeAccountDetailsIdCount INT = (SELECT COUNT(1) FROM EmployeeAccountDetails  WHERE Id = @EmployeeAccountDetailsId)

		DECLARE @EmployeePFNumberCount INT = (SELECT COUNT(1) FROM EmployeeAccountDetails EAD 
		                                                                JOIN Employee E ON E.Id = EAD.EmployeeId
																		JOIN [User] U ON U.Id = E.UserId
																		WHERE [PFNumber] = @PFNumber AND @PFNumber IS NOT NULL AND U.CompanyId = @CompanyId
																		AND (@EmployeeAccountDetailsId IS NULL OR @EmployeeAccountDetailsId <> EAD.Id))

        DECLARE @EmployeeUANNumberCount INT = (SELECT COUNT(1) FROM EmployeeAccountDetails EAD 
		                                                                JOIN Employee E ON E.Id = EAD.EmployeeId
																		JOIN [User] U ON U.Id = E.UserId
																		WHERE [UANNumber] = @UANNumber AND @UANNumber IS NOT NULL AND U.CompanyId = @CompanyId
																		AND (@EmployeeAccountDetailsId IS NULL OR @EmployeeAccountDetailsId <> EAD.Id))

        DECLARE @EmployeeESINumberCount INT = (SELECT COUNT(1) FROM EmployeeAccountDetails EAD 
		                                                                JOIN Employee E ON E.Id = EAD.EmployeeId
																		JOIN [User] U ON U.Id = E.UserId 
																		WHERE [ESINumber] = @ESINumber AND @ESINumber IS NOT NULL AND U.CompanyId = @CompanyId
																		AND (@EmployeeAccountDetailsId IS NULL OR @EmployeeAccountDetailsId <> EAD.Id))

        DECLARE @EmployeePANNumberCount INT = (SELECT COUNT(1) FROM EmployeeAccountDetails EAD 
		                                                                JOIN Employee E ON E.Id = EAD.EmployeeId
																		JOIN [User] U ON U.Id = E.UserId 
																		WHERE [PANNumber] = @PANNumber AND @PANNumber IS NOT NULL AND U.CompanyId = @CompanyId
																		AND (@EmployeeAccountDetailsId IS NULL OR @EmployeeAccountDetailsId <> EAD.Id))

	    IF(@EmployeeAccountDetailsIdCount = 0 AND @EmployeeAccountDetailsId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'EmployeeAccountDetails')

        END
		IF(@EmployeePANNumberCount > 0)
        BEGIN

            RAISERROR(50001,11,1,'EmployeePANNumber')

        END
	    IF(@EmployeePFNumberCount > 0)
        BEGIN

            RAISERROR(50001,11,1,'EmployeePFNumber')

        END
		IF(@EmployeeUANNumberCount > 0)
        BEGIN

            RAISERROR(50001,11,1,'EmployeeUANNumber')

        END
		IF(@EmployeeESINumberCount > 0)
        BEGIN

            RAISERROR(50001,11,1,'EmployeeESINumber')

        END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @EmployeeAccountDetailsId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [EmployeeAccountDetails] WHERE Id = @EmployeeAccountDetailsId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
							 DECLARE @OldPFNumber NVARCHAR(100) = NULL
                             DECLARE @OldUANNumber NVARCHAR(100) = NULL
                             DECLARE @OldESINumber NVARCHAR(100) = NULL
                             DECLARE @OldPANNumber NVARCHAR(100) = NULL
							 DECLARE @OldValue NVARCHAR(MAX) = NULL
					         DECLARE @NewValue NVARCHAR(MAX) = NULL
					         DECLARE @Inactive DATETIME = NULL

							 SELECT @OldPFNumber = [PFNumber],  
							        @OldUANNumber= [UANNumber],
							        @OldESINumber= [ESINumber],
							        @OldPANNumber= [PANNumber], 
									@Inactive =[InActiveDateTime]
									FROM EmployeeAccountDetails WHERE Id = @EmployeeAccountDetailsId

                            IF(@EmployeeAccountDetailsId IS NULL)
							BEGIN

							SET @EmployeeAccountDetailsId = NEWID()

							INSERT INTO [dbo].[EmployeeAccountDetails](
                                                              [Id],
															  [EmployeeId],
															  [PFNumber], 
															  [UANNumber],
															  [ESINumber],
															  [PANNumber], 
						                                      [InActiveDateTime],
						                                      [CreatedDateTime],
						                                      [CreatedByUserId]				
															  )
                                                       SELECT @EmployeeAccountDetailsId,
													          @EmployeeId,
															  @PFNumber, 
															  @UANNumber,
															  @ESINumber,
															  @PANNumber, 
						                                      CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,						 
						                                      @Currentdate,
						                                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [EmployeeAccountDetails]
							      SET [EmployeeId] = @EmployeeId,
								      [PFNumber] = @PFNumber, 
									  [UANNumber] = @UANNumber,
									  [ESINumber] = @ESINumber,
									  [PANNumber] = @PANNumber, 
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @EmployeeAccountDetailsId

							END
			                
							IF(ISNULL(@OldPFNumber,'') <> @PFNumber AND @PFNumber IS NOT NULL)
					        EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Account details',
					        @FieldName = 'Pf number',@OldValue = @OldPFNumber,@NewValue = @PFNumber

							IF(ISNULL(@OldUANNumber,'') <> @PFNumber AND @UANNumber IS NOT NULL)
					        EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Account details',
					        @FieldName = 'UAN number',@OldValue = @OldUANNumber,@NewValue = @UANNumber

							IF(ISNULL(@OldESINumber,'') <> @ESINumber AND @ESINumber IS NOT NULL)
					        EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Account details',
					        @FieldName = 'ESI number',@OldValue = @OldESINumber,@NewValue = @ESINumber

							IF(ISNULL(@OldPAnNumber,'') <> @PANNumber AND @PANNumber IS NOT NULL)
					        EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Account details',
					        @FieldName = 'PAN number',@OldValue = @OldPANNumber,@NewValue = @PANNumber

							SET @OldValue = IIF(@Inactive IS NOT NULL,'Archived','Unarchived')
					        SET @NewValue = IIF(ISNULL(@IsArchived,0) = 0,'UnArchived','Archived')
					        
					        IF(ISNULL(@OldValue,'') <> @NewValue AND @NewValue IS NOT NULL)
					        EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Education details',
					        @FieldName = 'Archive',@OldValue = @OldValue,@NewValue = @NewValue

			              SELECT Id FROM [dbo].[EmployeeAccountDetails] WHERE Id = @EmployeeAccountDetailsId
			                       
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
