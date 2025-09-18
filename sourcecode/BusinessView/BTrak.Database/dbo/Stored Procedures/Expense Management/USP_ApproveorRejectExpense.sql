CREATE PROCEDURE [dbo].[USP_ApproveorRejectExpense]
(
 @ExpenseId UNIQUEIDENTIFIER = NULL,
 @IsApproved BIT = NULL,
 @ExpenseStatusId UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @IsArchived BIT = NULL,
 @IsPaid BIT = NULL,
 @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
			BEGIN
				DECLARE @IsLatest BIT = (CASE WHEN @ExpenseId  IS NULL
					 	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
					                                                            FROM [Expense] WHERE Id = @ExpenseId ) = @TimeStamp
					 													THEN 1 ELSE 0 END END)
					IF(@IsLatest = 1)
						BEGIN
							IF (@ExpenseId IS NULL)
								BEGIN

									RAISERROR(50011,11,1,'Expense')

								END
							ELSE
								BEGIN

									DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
									
									DECLARE @Currentdate DATETIME = GETDATE()

									IF(@IsArchived IS NULL)
										BEGIN
											IF(@IsPaid = 1)
												BEGIN
													SET @ExpenseStatusId = (SELECT Id FROM ExpenseStatus WHERE IsPaid = 1)
												END
											ELSE
												BEGIN
													SET @ExpenseStatusId = (CASE WHEN @IsApproved IS NULL THEN (SELECT Id FROM ExpenseStatus WHERE IsPending = 1) ELSE (CASE WHEN @IsApproved = 1 THEN (SELECT Id FROM ExpenseStatus WHERE IsApproved = 1) ELSE (SELECT Id FROM ExpenseStatus WHERE IsRejected = 1) END)END)
												END
										END

									INSERT INTO [dbo].[ExpenseHistory](
																[Id],
																[ExpenseId],
																[OldValue],
																[NewValue],
																[FieldName],
																[Description],
																CreatedDateTime,
																CreatedByUserId)
														 SELECT NEWID(),
														        @ExpenseId,
														        (SELECT [Name] FROM ExpenseStatus WHERE Id = E.ExpenseStatusId),
														        (SELECT [Name] FROM ExpenseStatus WHERE Id = @ExpenseStatusId),
																'ExpenseStatus',
																'ExpenseStatusChanged',
														        SYSDATETIMEOFFSET(),
														        @OperationsPerformedBy
																FROM Expense E
																WHERE E.Id = @ExpenseId AND E.InactiveDateTime IS NULL 

									UPDATE [dbo].[Expense]
											SET [ExpenseStatusId]	 =  @ExpenseStatusId,
												[IsApproved]		 =  @IsApproved,
											    [UpdatedByUserId]	 =	@OperationsPerformedBy,
												[UpdatedDateTime]    =  @Currentdate,
												[PaidStatusSetByUserId] =CASE WHEN @IsPaid = 1 THEN @OperationsPerformedBy ELSE NULL END,
												InActiveDateTime	 =	CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
											FROM Expense E WHERE E.Id = @ExpenseId AND E.CompanyId = @CompanyId

									SELECT @ExpenseId AS ExpenseId
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
GO