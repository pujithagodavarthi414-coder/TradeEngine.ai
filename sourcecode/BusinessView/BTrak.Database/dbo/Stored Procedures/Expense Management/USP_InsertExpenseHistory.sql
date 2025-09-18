CREATE PROCEDURE [dbo].[USP_InsertExpenseHistory]
(
  @ExpenseId UNIQUEIDENTIFIER = NULL,
  @OldValue NVARCHAR(MAX) = NULL,
  @NewValue NVARCHAR(MAX) = NULL,
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
		IF(@HavePermission = '1')			 
		BEGIN
	
		DECLARE @UserStoryHistoryId UNIQUEIDENTIFIER = NEWID()
		
		INSERT INTO [dbo].[ExpenseHistory](
		            [Id],
		            [ExpenseId],
		            [OldValue],
					[NewValue],
					[FieldName],
					[Description],
		            CreatedDateTime,
		            CreatedByUserId)
		     SELECT @UserStoryHistoryId,
		            @ExpenseId,
		            @OldValue,
					@NewValue,
					@FieldName,
					@Description,
		            SYSDATETIMEOFFSET(),
		            @OperationsPerformedBy

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