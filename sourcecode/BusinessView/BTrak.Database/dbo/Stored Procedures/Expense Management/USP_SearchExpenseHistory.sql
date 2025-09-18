CREATE PROCEDURE [dbo].[USP_SearchExpenseHistory]
(
  @ExpenseHistoryId UNIQUEIDENTIFIER = NULL,
  @ExpenseId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(250) = NULL,
  @NewValue NVARCHAR(250) = NULL,
  @FieldName NVARCHAR(100) = NULL,
  @Description NVARCHAR(800) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

       DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

       IF (@HavePermission = '1')
       BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
	       IF(@ExpenseHistoryId = '00000000-0000-0000-0000-000000000000') SET  @ExpenseHistoryId = NULL

	       IF(@ExpenseId = '00000000-0000-0000-0000-000000000000') SET  @ExpenseId = NULL
		   
	       IF(@OldValue = '') SET  @OldValue = NULL

	       IF(@NewValue = '') SET  @NewValue = NULL

	       IF(@FieldName = '') SET  @FieldName = NULL

	       SELECT EH.Id AS ExpenseHistoryId, 
		          E.ExpenseName,
		          EH.OldValue,
				  EH.NewValue,
				  EH.FieldName,
				  EH.[Description],
				  EH.CreatedByUserId,
				  EH.CreatedDateTime,
				  U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
				  U.ProfileImage,
		          TotalCount = COUNT(1) OVER()
		   FROM  [dbo].[ExpenseHistory] EH WITH (NOLOCK)
				 INNER JOIN [dbo].[Expense] E ON E.Id = EH.ExpenseId 
				 INNER JOIN [dbo].[User] U ON U.Id = EH.CreatedByUserId AND U.InactiveDateTime IS NULL
		   WHERE U.CompanyId = @CompanyId 
		         AND (@ExpenseHistoryId IS NULL OR EH.Id = @ExpenseHistoryId)
		         AND (@ExpenseId IS NULL OR EH.ExpenseId = @ExpenseId)
		         AND (@OldValue IS NULL OR EH.OldValue = @OldValue)
		         AND (@NewValue IS NULL OR EH.NewValue = @NewValue)
		         AND (@FieldName IS NULL OR EH.FieldName = @FieldName)
		         AND (@Description IS NULL OR EH.[Description] = @Description)
			ORDER BY EH.CreatedDateTime DESC
		END
		ELSE
           RAISERROR (@HavePermission,11, 1)
	 END TRY  
	 BEGIN CATCH 
		
		  THROW

	END CATCH

END
GO