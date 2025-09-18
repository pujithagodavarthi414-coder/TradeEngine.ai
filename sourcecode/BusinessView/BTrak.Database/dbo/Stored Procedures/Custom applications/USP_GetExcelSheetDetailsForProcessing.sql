CREATE PROCEDURE [dbo].[USP_GetExcelSheetDetailsForProcessing]
(
	@OperationsPerformedby UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT CAD.[CompanyId]
	       ,[ExcelSheetName]
		   ,[CustomApplicationId]
		   ,[FormId]
		   ,[ExcelSheetErrorFolder]
		   ,[ExcelSheetProcessedFolder]
		   ,[ExcelPath]
		   ,CreatedUserId
		   ,CONCAT(U.FirstName,' ',U.SurName) AS CreatedUserName
		   ,CAD.AuthToken
	FROM CustomApplicationRecordsExcelDetails CAD
	     LEFT JOIN [User] U ON U.Id = CAD.CreatedUserId AND U.InActiveDateTime IS NULL
	WHERE [IsUploaded] = 0

END
GO;