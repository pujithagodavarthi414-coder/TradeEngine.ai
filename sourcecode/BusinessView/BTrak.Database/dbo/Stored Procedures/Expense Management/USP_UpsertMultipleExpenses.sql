--EXEC USP_UpsertMultipleExpenses @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ExpensesXmlModel=''
CREATE PROCEDURE [dbo].[USP_UpsertMultipleExpenses]
(
  @ExpensesXmlModel  XML,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
 SET NOCOUNT ON
 BEGIN TRY
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF(@HavePermission = '1')
            BEGIN
                DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                DECLARE @ExpenseDetails TABLE
                (
                    ExpenseId UNIQUEIDENTIFIER,
                    ExpenseName NVARCHAR(800),
                    Description NVARCHAR(800),
                    ExpenseCategoryId UNIQUEIDENTIFIER,
                    CurrencyId UNIQUEIDENTIFIER,
                    ExpenseStatusId UNIQUEIDENTIFIER,
                    BranchId UNIQUEIDENTIFIER,
                    ClaimReimbursement BIT,
                    ClaimedByUserId UNIQUEIDENTIFIER,
                    MerchantId UNIQUEIDENTIFIER,
                    ExpenseDate DATETIME,
                    Amount FLOAT,
                    Reason NVARCHAR(800),
                    IsApproved BIT,
					Id INT IDENTITY(1,1)
                )
                INSERT INTO @ExpenseDetails([ExpenseId],[ExpenseName],[Description],[ExpenseCategoryId],[CurrencyId],[ExpenseStatusId],[BranchId],
                                        [ClaimedByUserId],[ClaimReimbursement],[MerchantId],[ExpenseDate],[Amount],[Reason],[IsApproved])
                SELECT x.y.value('(ExpenseId/text())[1]', 'UNIQUEIDENTIFIER')
                       ,x.y.value('ExpenseName[1]', 'NVARCHAR(800)')
                       ,x.y.value('Description[1]', 'NVARCHAR(800)')
                       ,x.y.value('(ExpenseCategoryId/text())[1]', 'UNIQUEIDENTIFIER')
                       ,x.y.value('(CurrencyId/text())[1]', 'UNIQUEIDENTIFIER')
                       ,x.y.value('(ExpenseStatusId/text())[1]', 'UNIQUEIDENTIFIER')
                       ,x.y.value('(BranchId/text())[1]', 'UNIQUEIDENTIFIER')
                       ,x.y.value('(ClaimedByUserId/text())[1]', 'UNIQUEIDENTIFIER')
                       ,x.y.value('ClaimReimbursement[1]', 'BIT')
                       ,x.y.value('(MerchantId/text())[1]', 'UNIQUEIDENTIFIER')
                       ,x.y.value('ExpenseDate[1]', 'DATETIME')
                       ,x.y.value('Amount[1]', 'FLOAT')
                       ,x.y.value('Reason[1]', 'NVARCHAR(800)')
                       ,x.y.value('(IsApproved/text())[1]', 'BIT')
                  FROM @ExpensesXmlModel.nodes('/GenericListOfExpenseUpsertInputModel/*/ExpenseUpsertInputModel') AS x(y)
                --IF(EXISTS(SELECT T.ExpenseName FROM(SELECT ExpenseName,COUNT(1) Namecount FROM @ExpenseDetails GROUP BY ExpenseName)T WHERE T.Namecount > 1))
                --BEGIN
                
                -- RAISERROR ('OneOfTheExpenseInGivenExpenseGotDuplicated',11, 1)
                --END
                --IF(EXISTS(SELECT ExpenseName from Expense where ExpenseName IN (SELECT ExpenseName FROM @ExpenseDetails) AND CompanyId = @CompanyId))
                --BEGIN
                
                -- RAISERROR(50001,16, 2, 'Expense')
                --END
                
				--UPDATE @ExpenseDetails SET Id = T.Row_Numbers
				--FROM (SELECT ROW_NUMBER() OVER(ORDER BY [ExpenseId]) AS Row_Numbers,[ExpenseId]
				--FROM @ExpenseDetails) T

				DECLARE @MaxExpenseNumber INT = (SELECT COUNT(1) FROM Expense WHERE CompanyId = @CompanyId)
				
                IF(NOT EXISTS(SELECT 1 FROM @ExpenseDetails))
                    BEGIN
               
                    RAISERROR(50011,16, 2, 'ExpenseName')
            
                END
                ELSE 
                    BEGIN
                
                        DECLARE @PaymentStatusId UNIQUEIDENTIFIER = (SELECT TOP(1) Id FROM PaymentStatus WHERE [IsDefault] = 1 AND InActiveDateTime IS NULL )
                        DECLARE @Currentdate DATETIME = GETDATE()
                        INSERT INTO [dbo].[Expense](
                                 [Id],
                                 [ExpenseName],
                                 [PaymentStatusId],
                                 [ClaimedByUserId],
                                 [CurrencyId],
                                 [ExpenseStatusId],
                                 [ClaimReimbursement],
                                 --[MerchantId],
                                 [ExpenseDate],
                                 [Reason],
                                 [IsApproved],
                                 [CompanyId],
								 [BranchId],
                                 [CreatedByUserId],
                                 [CreatedDateTime],
								 [ExpenseNumber])
                          SELECT ED.ExpenseId,
                                 ED.ExpenseName,
                                 @PaymentStatusId,
								 CASE WHEN ED.ClaimedByUserId IS NULL THEN @OperationsPerformedBy ELSE ED.ClaimedByUserId END,
                                 ED.CurrencyId,
                                 CASE WHEN ED.IsApproved IS NULL THEN (SELECT Id FROM ExpenseStatus WHERE IsPending = 1) ELSE (CASE WHEN ED.IsApproved = 1 THEN (SELECT Id FROM ExpenseStatus WHERE IsApproved = 1) ELSE (SELECT Id FROM ExpenseStatus WHERE IsRejected = 1) END)END,
                                 ED.ClaimReimbursement,
                                 --ED.MerchantId,
                                 ED.ExpenseDate,
                                 ED.Reason,
                                 ED.IsApproved,
                                 @CompanyId,
								 ED.BranchId,
                                 @OperationsPerformedBy,
                                 @Currentdate,
								 Id + ISNULL(@MaxExpenseNumber,0)
                                 FROM @ExpenseDetails ED

                        INSERT INTO ExpenseHistory(
                                             Id,
                                             ExpenseId,
                                             NewValue,
                                             FieldName,
                                             [Description],
                                             CreatedByUserId,
                                             CreatedDateTime
                                            )
                                          SELECT  NEWID(),
                                                  ED.ExpenseId,
                                                  ED.ExpenseName,
                                                  'ExpenseAdded',
                                                  'ExpenseAdded',
                                                  @OperationsPerformedBy,
                                                  GETDATE() 
                                            FROM @ExpenseDetails ED
                        INSERT INTO [dbo].[ExpenseCategoryConfiguration](
                                 [Id],
                                 [ExpenseId],
                                 [Description],
                                 [ExpenseCategoryId],
                                 [Amount],
								 [MerchantId],
								 [ExpenseCategoryName],
                                 [CreatedByUserId],
                                 [CreatedDateTime])
                          SELECT NEWID(),
                                 ED.ExpenseId,
                                 ED.Description,
                                 ED.ExpenseCategoryId,
                                 ED.Amount, 
								 ED.MerchantId,
								 ED.ExpenseName,
                                 @OperationsPerformedBy,
                                 @Currentdate
                                 FROM @ExpenseDetails ED
                        
                        SELECT ExpenseId FROM @ExpenseDetails
                    END
            END
            ELSE
            BEGIN
                 RAISERROR (@HavePermission,10, 1)
            END
 END TRY
 BEGIN CATCH
         THROW
 END CATCH
END
GO