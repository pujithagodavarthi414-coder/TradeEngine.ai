CREATE PROCEDURE [dbo].[Marker197]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
    
     UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Expenses To Be Approved] FROM Expense E INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId 
                             AND E.InActiveDateTime IS NULL AND ES.InActiveDateTime IS NULL
							 WHERE IsPending = 1 
							 AND E.CompanyId = ''@CompanyId''
							  AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(E.ExpenseDate AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
                                   AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(E.ExpenseDate AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
                                                      ' WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Expenses To Be Approved'


END
GO