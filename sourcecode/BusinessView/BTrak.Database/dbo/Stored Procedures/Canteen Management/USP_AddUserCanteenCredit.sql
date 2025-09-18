-------------------------------------------------------------------------------
-- Author       Padmini
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Save Timesheet History
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- declare @UserIdGuids xml = N'<?xml version="1.0" encoding="utf-16"?>
-- <GenericListOfNullableOfGuid xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
-- <ListItems>
-- <guid>127133F1-4427-4149-9DD6-B02E0E036971</guid>
-- <guid>127133F1-4427-4149-9DD6-B02E0E036972</guid>
-- </ListItems>
-- </GenericListOfNullableOfGuid>'
-- EXEC USP_AddUserCanteenCredit @Currency = 'DF549957-74CC-4622-A094-05F64973F092',
-- 							  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@UserIdGuids = @UserIdGuids,
-- 							  @Amount = 100
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_AddUserCanteenCredit]
(
  @UserIdGuids XML = NULL,
  @Amount Decimal = NULL,
  @Currency UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL
)
AS
BEGIN
 SET NOCOUNT ON
 BEGIN TRY
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

        IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		DECLARE @UserIdsCount INT = (SELECT COUNT(1) FROM @UserIdGuids.nodes('/GenericListOfNullableOfGuid/*/guid') AS x(y))

	    IF(@UserIdGuids IS NULL OR @UserIdsCount = 0)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Credited user')

		END
		ELSE IF(@Amount IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Amount')

		END
		ELSE 
		BEGIN

		    DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF(@HavePermission = '1')
			BEGIN

			     DECLARE @Currentdate DATETIME = GETDATE()

                 INSERT INTO [dbo].[UserCanteenCredit](
                       [Id],
                       [CreditedToUserId],
                       [CreditedByUserId],
                       [Amount],
                       [CreatedDateTime],
                       [CreatedByUserId],
                       [CurrencyId],
					   [InActiveDateTime])
                SELECT NEWID(),
                       x.y.value('(text())[1]', 'varchar(100)'),
                       @OperationsPerformedBy,
                       @Amount,
                       @Currentdate,
                       @OperationsPerformedBy,
                       @Currency,
					   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
               FROM @UserIdGuids.nodes('/GenericListOfNullableOfGuid/*/guid') AS x(y)
	
	             SELECT CASE WHEN (SELECT Count(Id) FROM [UserCanteenCredit] WHERE CreditedToUserId IN (SELECT x.y.value('(text())[1]', 'varchar(100)') FROM @UserIdGuids.nodes('/GenericListOfNullableOfGuid/*/guid') AS x(y))) > 0 THEN 1 ELSE 0 END
			END
			ELSE
			BEGIN

			     RAISERROR (@HavePermission,11, 1)

			END
		END
 END TRY
 BEGIN CATCH

        THROW

 END CATCH
END