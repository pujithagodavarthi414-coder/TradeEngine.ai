-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update EmployeeTaxAllowance
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertEmployeeTaxAllowanceDetails] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@InvestedAmount='2000'			  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeTaxAllowanceDetails]
(
   @EmployeeTaxAllowanceId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @TaxAllowanceId  UNIQUEIDENTIFIER = NULL,
   @InvestedAmount DECIMAL(18,4) = NULL,
   @ApprovedDateTime DATETIME = NULL,
   @IsAutoApproved BIT = NULL,
   @IsOnlyEmployee BIT = NULL,
   @ApprovedByEmployeeId UNIQUEIDENTIFIER = NULL,
   @Comments NVARCHAR(250) = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @IsArchived BIT,
   @IsFilesExist BIT,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsRelatedToHRA BIT = NULL,
   @OwnerPanNumber NVARCHAR(100) = NULL,
   @IsApproved BIT,
   @RelatedToMetroCity BIT
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    DECLARE @FilesCount INT = 0

	    IF(@EmployeeTaxAllowanceId IS NOT NULL AND @IsFilesExist = 0)
	    SET @FilesCount = (SELECT COUNT(1) FROM UploadFile WHERE ReferenceId = @EmployeeTaxAllowanceId AND InActiveDateTime IS NULL)

	    IF(@EmployeeId IS NULL)
		BEGIN

		   RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@TaxAllowanceId IS NULL)
	    BEGIN

		   RAISERROR(50011,16, 2, 'TaxAllowance')

		END
		ELSE IF(@EmployeeTaxAllowanceId IS NULL AND @IsFilesExist = 0)
	    BEGIN

		   RAISERROR(50011,16, 2, 'Documents')

		END
		ELSE IF(@EmployeeTaxAllowanceId IS NOT NULL AND @FilesCount = 0 AND @IsFilesExist = 0)
	    BEGIN

		   RAISERROR(50011,16, 2, 'Documents')

		END
		ELSE
		BEGIN

		IF(@IsAutoApproved = 1 OR @IsApproved = 1)
        BEGIN

           SET @ApprovedDateTime = GETDATE()
		   SET @ApprovedByEmployeeId = (SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy)

        END


		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @EmployeeTaxAllowanceIdCount INT = (SELECT COUNT(1) FROM EmployeeTaxAllowances  WHERE Id = @EmployeeTaxAllowanceId)
       
	    IF(@EmployeeTaxAllowanceIdCount = 0 AND @EmployeeTaxAllowanceId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'EmployeeTaxAllowance')

        END
        ELSE        
		  BEGIN
       
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			         IF (@HavePermission = '1')
			         BEGIN
			         	
			         	DECLARE @IsLatest BIT = (CASE WHEN @EmployeeTaxAllowanceId  IS NULL 
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [EmployeeTaxAllowances] WHERE Id = @EmployeeTaxAllowanceId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			         
			             IF(@IsLatest = 1)
			         	BEGIN
			         
			                 DECLARE @Currentdate DATETIME = GETDATE()
			                 
                            IF(@EmployeeTaxAllowanceId IS NULL)
							BEGIN

							SET @EmployeeTaxAllowanceId = NEWID()

							INSERT INTO [dbo].[EmployeeTaxAllowances](
							                  [Id],
							                  [EmployeeId],
							                  [TaxAllowanceId],
							                  [InvestedAmount],
							                  [ApprovedDateTime],
											  [ApprovedByEmployeeId],
							                  [IsAutoApproved], 
							                  [IsOnlyEmployee],
											  [IsRelatedToHRA],
											  [IsApproved],
											  [Comments],
											  [RelatedToMetroCity],
											  [OwnerPanNumber],
							                  [InactiveDateTime],
							                  [CreatedDateTime],
							                  [CreatedByUserId])
                                       SELECT @EmployeeTaxAllowanceId,
										      @EmployeeId,
										      @TaxAllowanceId,
										      @InvestedAmount,
										      CASE WHEN (@IsAutoApproved = 1 OR @IsApproved = 1) THEN @Currentdate ELSE NULL END,
											  CASE WHEN (@IsAutoApproved = 1 OR @IsApproved = 1) THEN @ApprovedByEmployeeId ELSE NULL END,
										      @IsAutoApproved, 
										      @IsOnlyEmployee,
											  @IsRelatedToHRA,
											  @IsApproved,
											  @Comments,
											  @RelatedToMetroCity,
											  @OwnerPanNumber,
						                      CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,						 
						                      @Currentdate,
						                      @OperationsPerformedBy		
		                     
							END
							ELSE
							BEGIN

							  UPDATE [EmployeeTaxAllowances]           
							     SET [EmployeeId] = @EmployeeId,
									 [TaxAllowanceId] = @TaxAllowanceId,
									 [InvestedAmount] = @InvestedAmount,
									 [ApprovedDateTime] = CASE WHEN (@IsAutoApproved = 1 OR @IsApproved = 1) THEN @Currentdate ELSE NULL END,
									 [ApprovedByEmployeeId] = CASE WHEN (@IsAutoApproved = 1 OR @IsApproved = 1) THEN @ApprovedByEmployeeId ELSE NULL END,
									 [IsAutoApproved] = @IsAutoApproved, 
									 [IsOnlyEmployee] = @IsOnlyEmployee,
									 [IsRelatedToHRA] = @IsRelatedToHRA,
									 [IsApproved] = @IsApproved,
									 [Comments] = @Comments,
									 [RelatedToMetroCity] = @RelatedToMetroCity,
									 [OwnerPanNumber] = @OwnerPanNumber,
									 [InactiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									 [UpdatedDateTime] = @Currentdate,
									 [UpdatedByUserId] = @OperationsPerformedBy
									 WHERE Id = @EmployeeTaxAllowanceId
							END
			                
			              SELECT Id FROM [dbo].[EmployeeTaxAllowances] WHERE Id = @EmployeeTaxAllowanceId
			                       
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