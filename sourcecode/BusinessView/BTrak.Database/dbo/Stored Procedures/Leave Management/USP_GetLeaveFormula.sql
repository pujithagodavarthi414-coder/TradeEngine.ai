
--EXEC [USP_GetLeaveFormula] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetLeaveFormula]
(
  @LeaveFormulaId UNIQUEIDENTIFIER = NULL,
  @Formula NVARCHAR(800) = NULL,
  @NoOfdays FLOAT = NULL,
  @NoOfLeaves FLOAT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN

		IF (@NoOfLeaves IS NULL) SET @NoOfLeaves = 0

			SELECT Id AS LeaveFormulaId,
				   CompanyId,
				   Formula,
				   NoOfLeaves,
				   NoOfdays,
				   CreatedDateTime,
				   PayroleId,
				   [TimeStamp],
				   CASE WHEN InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
				   TotalCount = COUNT(1) OVER()
			       FROM LeaveFormula
				   WHERE CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				     AND (@LeaveFormulaId IS NULL OR @LeaveFormulaId = Id)
					 AND (@NoOfLeaves = 0 OR NoOfLeaves = @NoOfLeaves)
					 AND (@IsArchived IS NULL OR (@IsArchived = 0 AND InActiveDateTime IS NULL) OR (@IsArchived = 1 AND InActiveDateTime IS NOT NULL))
		END
		ELSE
			
			RAISERROR(@HavePermission,11,1)
   END TRY
   BEGIN CATCH

	THROW

   END CATCH
END
GO