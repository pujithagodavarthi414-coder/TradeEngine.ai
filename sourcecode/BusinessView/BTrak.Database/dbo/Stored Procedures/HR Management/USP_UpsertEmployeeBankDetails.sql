-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-25 00:00:00.000'
-- Purpose      To Save or update the employee bank details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --  EXEC [dbo].[USP_UpsertEmployeeBankDetails] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971' ,@EmployeeId = 'B1286B23-1362-4C47-BC94-0549099E9393',
 --  @AccountNumber = '1448D1B9',@AccountName = 'Test', 
 --  @BuildingSocietyRollNumber = 'BA123', 
 --  @BankName  = 'ABC',
 --  @BranchName = 'TED',
 --  @DateFrom = '2019-05-16',@IsArchived = 0
 -------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertEmployeeBankDetails]
(
   @EmployeeBankId UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @IFSCCode NVARCHAR(800) = NULL, 
   @AccountNumber NVARCHAR(800) = NULL, 
   @AccountName NVARCHAR(800) = NULL, 
   @BuildingSocietyRollNumber NVARCHAR(800) = NULL, 
   @BankId UNIQUEIDENTIFIER = NULL,
   @BranchName NVARCHAR(800) = NULL,
   @DateFrom DATETIME = NULL,
   @DateTo DATETIME = NULL,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL

		IF(@AccountNumber = '') SET @AccountNumber = NULL

		IF(@AccountName = '') SET @AccountName = NULL

		IF(@BuildingSocietyRollNumber = '') SET @BuildingSocietyRollNumber = NULL

		IF(@BranchName = '') SET @BranchName = NULL

		IF(@DateFrom = '') SET @DateFrom = NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @IsNewColumn BIT = 0
		IF(@EmployeeBankId IS NULL)SET @IsNewColumn = 1

        IF(@EmployeeId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Employee')

		END
		ELSE IF(@AccountNumber IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'AccountNumber')

		END
		ELSE IF(@AccountName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'AccountName')

		END
		--ELSE IF(@BuildingSocietyRollNumber IS NULL)
		--BEGIN
		   
		--    RAISERROR(50011,16, 2, 'BuildingSocietyRollNumber')

		--END
		ELSE IF(@BankId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Bank')

		END
		ELSE IF(@BranchName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'BranchName')

		END
		
		ELSE IF(@DateFrom IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'DateFrom')

		END
		ELSE 
		BEGIN

		DECLARE @UserId UNIQUEIDENTIFIER = (Select UserId from Employee where Id = @EmployeeId  AND InActiveDateTime IS NULL)

		DECLARE @FeatureId UNIQUEIDENTIFIER = 'A701FB6F-F1E3-42B0-9B4D-9B9F7C248F1E'

		DECLARE @HavePermissionToEdit INT = (SELECT COUNT(1) FROM [RoleFeature] WHERE InActiveDateTime IS NULL AND RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL)

		DECLARE @EmployeeBankCountWithDates INT = 0

		SET @EmployeeBankCountWithDates = (SELECT COUNT(1) FROM BankDetail WHERE EmployeeId = @EmployeeId AND (Id <> @EmployeeBankId OR @EmployeeBankId IS NULL) AND EffectiveTo IS NULL)

		IF(@DateTo IS NULL AND ISNULL(@EmployeeBankCountWithDates,0) = 0)
		BEGIN

			SET @EmployeeBankCountWithDates = (SELECT COUNT(1) FROM BankDetail WHERE EmployeeId = @EmployeeId AND (Id <> @EmployeeBankId OR @EmployeeBankId IS NULL) 
			                                   AND (@DateFrom BETWEEN EffectiveFrom AND EffectiveTo)
											  )
			
		END
		ELSE IF(@DateTo IS NOT NULL AND ISNULL(@EmployeeBankCountWithDates,0) = 0)
		BEGIN
			
			SET @EmployeeBankCountWithDates = (SELECT COUNT(1) FROM BankDetail WHERE EmployeeId = @EmployeeId AND (Id <> @EmployeeBankId OR @EmployeeBankId IS NULL) 
			                                   AND ((@DateFrom BETWEEN EffectiveFrom AND EffectiveTo)
											        OR (@DateTo BETWEEN EffectiveFrom AND EffectiveTo)
											       )
											  )

		END
		--IF(@DateTo IS NULL)
		--BEGIN

		--	SET @EmployeeBankCountWithDates = (SELECT COUNT(1) FROM BankDetail WHERE EmployeeId = @EmployeeId AND AccountNumber = @AccountNumber AND BankId = @BankId AND BranchName = @BranchName AND (Id <> @EmployeeBankId OR @EmployeeBankId IS NULL) AND
		--																				((@DateFrom <= EffectiveFrom AND (EffectiveTo IS NULL OR @DateFrom <= EffectiveTo ) AND @DateTo IS NULL)
		--																				OR (@DateFrom >= EffectiveFrom AND (EffectiveTo IS NULL OR @DateFrom <= EffectiveTo ) AND @DateTo IS NULL)))
		--END
		--IF(@DateTo IS NOT NULL)
		--BEGIN

		--	SET @EmployeeBankCountWithDates = (SELECT COUNT(1) FROM BankDetail WHERE EmployeeId = @EmployeeId AND AccountNumber = @AccountNumber AND BankId = @BankId AND BranchName = @BranchName AND (Id <> @EmployeeBankId OR @EmployeeBankId IS NULL) AND
		--																				((@DateFrom <= EffectiveFrom AND @DateTo >= EffectiveFrom AND (EffectiveTo IS NULL OR (@DateTo <= EffectiveTo AND @DateTo >= EffectiveFrom )))
		--																				OR (@DateFrom <= EffectiveFrom AND @DateTo >= EffectiveFrom AND (EffectiveTo IS NULL OR (@DateTo >= EffectiveTo AND @DateTo >= EffectiveFrom )))
		--																				OR (@DateFrom >= EffectiveFrom AND @DateTo >= EffectiveFrom AND (EffectiveTo IS NULL OR (@DateTo <= EffectiveTo AND @DateTo >= EffectiveFrom )))
		--																				OR (@DateFrom >= EffectiveFrom AND @DateTo >= EffectiveFrom AND (EffectiveTo IS NULL OR (@DateTo >= EffectiveTo AND @DateTo >= EffectiveFrom AND @DateFrom <= EffectiveTo)))))

		--END

		IF(@UserId <> @OperationsPerformedBy AND @HavePermissionToEdit = 0)
		BEGIN
		    RAISERROR('YouDoNotHaveAccessToEditAnotherEmployeeBankDetails',11,1)
		END
		ELSE IF(ISNULL(@EmployeeBankCountWithDates,0) > 0)
		BEGIN
			RAISERROR('EmployeeBankDetailsIsAlreadyExistedForThisDate',16, 1)
		END
		ELSE
		BEGIN

			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
			IF (@HavePermission = '1')
			BEGIN
				
					DECLARE @Currentdate DATETIME = GETDATE()

					DECLARE @OldIFSCCode NVARCHAR(800) = NULL
					DECLARE @OldAccountNumber NVARCHAR(800) = NULL
					DECLARE @OldAccountName NVARCHAR(800) = NULL
					DECLARE @OldBuildingSocietyRollNumber NVARCHAR(800) = NULL
					DECLARE @OldBankName  NVARCHAR(800) = NULL
					DECLARE @OldBranchName NVARCHAR(800) = NULL
					DECLARE @OldDateFrom DATETIME = NULL
					DECLARE @OldEffectiveFrom DATETIME = NULL
					DECLARE @OldIsArchived BIT = NULL
					DECLARE @OldValue NVARCHAR(MAX) = NULL
					DECLARE @NewValue NVARCHAR(MAX) = NULL
					DECLARE @Inactive DATETIME = NULL

					SELECT  @OldIFSCCode                 = [IFSCCode],
							@OldAccountName              = AccountName,
							@OldAccountNumber            = AccountNumber,
							@OldBranchName               = BranchName,
							@OldBankName                 = B.BankName,
							@OldBuildingSocietyRollNumber= BuildingSocietyRollNumber,
							@OldEffectiveFrom            = EffectiveFrom,
							@OldDateFrom                 = DateFrom,
							@Inactive                    = BD.InActiveDateTime
							FROM BankDetail BD
							LEFT JOIN Bank B ON B.Id = BD.BankId
							WHERE BD.Id = @EmployeeBankId

					IF(@EmployeeBankId IS NULL)
					BEGIN

					SET @EmployeeBankId = NEWID()
					
			        INSERT INTO [dbo].BankDetail(
			                    [Id],
			                    [EmployeeId],
								[IFSCCode],
								AccountName,
								AccountNumber,
								BuildingSocietyRollNumber,
								EffectiveFrom,
								DateFrom,
								
								EffectiveTo,
								BranchName,
								BankId,
								[InActiveDateTime],
			                    [CreatedDateTime],
			                    [CreatedByUserId]
								)
			             SELECT @EmployeeBankId,
			                    @EmployeeId,
								@IFSCCode,
								@AccountName,
								@AccountNumber,
								@BuildingSocietyRollNumber,
								ISNULL(@DateFrom,@Currentdate),
								ISNULL(@DateFrom,@Currentdate),
								
								@DateTo,
								@BranchName,
								@BankId,
			                    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
			                    @Currentdate,
			                    @OperationsPerformedBy
					END
					ELSE
					BEGIN

					       UPDATE [BankDetail]
							      SET [EmployeeId] = @EmployeeId,
								      [IFSCCode] = @IFSCCode,
									  [AccountName] = @AccountName,
									  [AccountNumber] = @AccountNumber,
									  [BuildingSocietyRollNumber] = @BuildingSocietyRollNumber,
									  [EffectiveFrom] = ISNULL(@DateFrom,@Currentdate),
								      [DateFrom] = ISNULL(@DateFrom,@Currentdate),
									 
									  EffectiveTo = @DateTo,
									  [BranchName] = @BranchName,
									  [BankId] = @BankId,
									  InactiveDateTime = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
									  UpdatedDateTime = @Currentdate,
									  UpdatedByUserId = @OperationsPerformedBy
									  WHERE Id = @EmployeeBankId
					END
			        
					  --@OldIFSCCode                 
					  --@OldAccountName              
					  --@OldAccountNumber            
					  --@OldBranchName               
					  --@OldBankName                 
					  --@OldBuildingSocietyRollNumber

					   DECLARE @BankName NVARCHAR(250) = (SELECT BankName FROM Bank WHERE Id = @BankId)
						
						DECLARE @RecordTitle NVARCHAR(MAX) = (SELECT AccountName FROM BankDetail WHERE Id = @EmployeeBankId)
					    
						IF(ISNULL(@OldAccountName,'') <> @AccountName AND @AccountName IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Bank details',
					    @FieldName = 'Account name',@OldValue = @OldAccountName,@NewValue = @AccountName,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldAccountNumber,'') <> @AccountNumber AND @AccountNumber IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Bank details',
					    @FieldName = 'Account number',@OldValue = @OldAccountNumber,@NewValue = @AccountNumber,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldIFSCCode,'') <> @IFSCCode AND @IFSCCode IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Bank details',
					    @FieldName = 'Ifsc code',@OldValue = @OldIFSCCode,@NewValue = @IFSCCode,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldBranchName,'')  <> @BranchName AND @BranchName IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Bank details',
					    @FieldName = 'Branch name',@OldValue = @OldBranchName ,@NewValue = @BranchName,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldBankName,'')  <> @BankName AND @BankName IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Bank details',
					    @FieldName = 'Bank name',@OldValue = @OldBankName ,@NewValue = @BankName,@RecordTitle = @RecordTitle

						IF(ISNULL(@OldBuildingSocietyRollNumber,'')  <> @BuildingSocietyRollNumber AND @BankName IS NOT NULL)
					    EXEC [dbo].[USP_UpsertEmployeeDetailsHistory] @OperationsPerformedBy = @OperationsPerformedBy,@EmployeeId = @EmployeeId,@Category = 'Bank details',
					    @FieldName = 'Bank name',@OldValue = @OldBuildingSocietyRollNumber ,@NewValue = @BankName,@RecordTitle = @RecordTitle

			        SELECT Id FROM [dbo].BankDetail WHERE Id = @EmployeeBankId

					END	
					ELSE

			  		RAISERROR (50008,11, 1)
				
			END	
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO