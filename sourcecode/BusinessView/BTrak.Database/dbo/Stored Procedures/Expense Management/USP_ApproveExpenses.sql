CREATE PROCEDURE [dbo].[USP_ApproveExpenses]
(
  @ExpenseId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS 
BEGIN    
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		
		DECLARE @HavePermission NVARCHAR(250)  =  (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		   IF (@HavePermission = '1')
			BEGIN
			
			   DECLARE @Currentdate DATETIME = GETDATE()
			   
			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				 
			   DECLARE @ExpenseStatusId  UNIQUEIDENTIFIER = (SELECT Id FROM ExpenseStatus WHERE IsApproved = 1)
			  
					  CREATE TABLE #Temp
					  (
					   ExpenseId UNIQUEIDENTIFIER
					  )
					  INSERT INTO #Temp
					  SELECT E.Id FROM  [dbo].[Expense] E INNER JOIN ExpenseStatus ES ON ES.Id = e.ExpenseStatusId AND E.InActiveDateTime IS NULL
					                      WHERE ES.IsPending = 1 AND CompanyId = @CompanyId

					UPDATE [dbo].[Expense]
					SET ExpenseStatusId = @ExpenseStatusId,
					UpdatedByUserId = @OperationsPerformedBy,
					UpdatedDateTime = @Currentdate
					FROM #Temp T WHERE T.ExpenseId = Id AND CompanyId = @CompanyId
					
				    DECLARE  @FieldName  NVARCHAR(250) = 'ExpenseStatus'	
		            DECLARE  @HistoryDescription NVARCHAR(250) = 'ExpenseStatusChanged'	
				    DECLARE @NewValue NVARCHAR(250) = (SELECT [Name] FROM ExpenseStatus WHERE IsApproved= 1) 
				    DECLARE @OldValue NVARCHAR(250) = (SELECT [Name] FROM ExpenseStatus WHERE IsPending = 1)

					INSERT INTO ExpenseHistory(
								Id,
								ExpenseId,
								OldValue,
								NewValue,
								FieldName,
								[Description],
								CreatedByUserId,
								CreatedDateTime
								)
						SELECT  NEWID(),
							    ExpenseId,
								@OldValue,
								@NewValue,
							    @FieldName,
								@HistoryDescription,
								@OperationsPerformedBy,
								GETDATE()	
								FROM #Temp
            
			SELECT @ExpenseStatusId
					
			END
		ELSE
		BEGIN
		
		   RAISERROR (@HavePermission,11, 1)
		
		END
	END TRY  
	BEGIN CATCH 
		
		  EXEC USP_GetErrorInformation

	END CATCH

END
GO