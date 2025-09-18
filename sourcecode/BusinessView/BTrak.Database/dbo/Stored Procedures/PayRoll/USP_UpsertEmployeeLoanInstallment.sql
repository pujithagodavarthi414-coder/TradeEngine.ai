CREATE PROCEDURE [dbo].[USP_UpsertEmployeeLoanInstallment]
(
   @Id UNIQUEIDENTIFIER = NULL,
   @EmployeeId UNIQUEIDENTIFIER = NULL,
   @EmployeeLoanId UNIQUEIDENTIFIER = NULL,
   @PrincipalAmount DECIMAL(18, 4) = NULL,
   @InstallmentAmount DECIMAL(18, 4) = NULL,
   @InstallmentDate DATETIME = NULL,
   @PaidAmount DECIMAL(18, 4) = NULL,
   @InstalmentDate DATETIME = NULL,
   @IsTobePaid BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    
	BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
			
			DECLARE @IsLatest BIT = (CASE WHEN @Id  IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                           FROM [EmployeeLoanInstallment] WHERE Id = @Id) = @TimeStamp
			         									THEN 1 ELSE 0 END END)

			IF(@IsLatest = 1)
			BEGIN
				
				IF(@Id IS NULL)
				BEGIN
					
					SET @PrincipalAmount = (SELECT LoanAmount FROM EmployeeLoan WHERE Id = @EmployeeLoanId)

					SET @Id =  NEWID()

					INSERT INTO [dbo].[EmployeeLoanInstallment](
																[Id],
																[EmployeeLoanId],
																[PrincipalAmount],
																[InstallmentAmount],
																[IsTobePaid],
																[CreatedDateTime],
																[CreatedByUserId],
																[IsArchived]
															   )
														SELECT @Id,
															   @EmployeeLoanId,
															   @PrincipalAmount,
															   @InstallmentAmount,
															   NULL,
															   GETDATE(),
															   @OperationsPerformedBy,
															   0

						SELECT @Id
				END
				ELSE
				BEGIN

					UPDATE [dbo].[EmployeeLoanInstallment] 
							SET [EmployeeLoanId] = @EmployeeLoanId,
								[PrincipalAmount] = @PrincipalAmount,
								[InstallmentAmount] = @InstallmentAmount,
								[InstalmentDate] = @InstallmentDate, 
								[IsTobePaid] = @IsTobePaid,
								[UpdatedDateTime] = GETDATE(),
								[UpdatedByUserId] = @OperationsPerformedBy,
								[InactiveDateTime] = NULL
							WHERE Id = @Id

					IF(@IsArchived = 1)
					BEGIN
						
						UPDATE [dbo].[EmployeeLoanInstallment] 
								SET InActiveDateTime = GETDATE() 
								WHERE Id = @Id

					END

					SELECT @Id
				END

			END
			ELSE
			BEGIN
				RAISERROR (50008,11, 1)
			END

		END
		ELSE
		BEGIN

			RAISERROR (@HavePermission,11, 1)

		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END