-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-19 00:00:00.000'
-- Purpose      To Save OR Update CanteenCredit for user
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertCanteenCredit] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@CanteenCreditToUserIdsXml,@Amount,@IsOffered
CREATE PROCEDURE [dbo].[USP_UpsertCanteenCredit]
(
  @CanteenCreditId  UNIQUEIDENTIFIER = NULL,
  @CanteenCreditToUserIdsXml XML,
  @Amount BIT = DECIMAL,
  @IsOffered  BIT = 0,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @IsArchived BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		DECLARE @CanteenCreditIdCount INT = (SELECT COUNT(1) FROM UserCanteenCredit WHERE Id = @CanteenCreditId)
		IF(@CanteenCreditIdCount = 0 AND @CanteenCreditId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'UserCanteenCredit')
		END
		ELSE
		BEGIN
		    DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			IF(@HavePermission = '1')
			BEGIN
				DECLARE @Currentdate DATETIME = GETDATE()
				
				IF(@CanteenCreditId IS NULL)
				BEGIN
		
				SET @CanteenCreditId = NEWID()
				INSERT INTO [dbo].[UserCanteenCredit](
				             [Id],
							 [Amount],
			                 [IsOffered],
							 [CreditedByUserId],
							 [CreditedToUserId],
			                 [CreatedDateTime],
			                 [CreatedByUserId],
							 [InActiveDateTime]
							 )
				      SELECT @CanteenCreditId,
							 @Amount,
							 @IsOffered,
							 @OperationsPerformedBy,
							 x.y.value('(text())[1]', 'uniqueidentifier'),
							 @Currentdate,
							 @OperationsPerformedBy,
							 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
							 FROM @CanteenCreditToUserIdsXml.nodes('/GenericListOfGuid/ListItems/guid') AS x(y)

				END
				ELSE
				BEGIN

						UPDATE [dbo].[UserCanteenCredit]
						SET  [Amount]				  =     @Amount,
			                 [IsOffered]			  =     @IsOffered,
							 [CreditedByUserId]		  =     @OperationsPerformedBy,
							 [CreditedToUserId]		  =     x.y.value('(text())[1]', 'uniqueidentifier'),
			                 [UpdatedDateTime]		  =     @Currentdate,
			                 [UpdatedByUserId]		  =     @OperationsPerformedBy,
							 [InActiveDateTime]		  =     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						WHERE Id = @CanteenCreditId

				END
					SELECT Id FROM [dbo].UserCanteenCredit where Id = @CanteenCreditId
			END
		END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
GO