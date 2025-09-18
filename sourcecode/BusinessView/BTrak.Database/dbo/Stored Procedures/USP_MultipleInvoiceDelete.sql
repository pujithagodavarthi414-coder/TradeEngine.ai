----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-11-01 00:00:00.000'
-- Purpose      To delete multiple invoices by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC  [dbo].[USP_MultipleInvoiceDelete] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @InvoiceId = '<ListItems>
-- <ListRecords>
-- <ListItem>
-- <ListItemId>C4D28B9B-F2B0-4CA4-8CB3-6C8625275E97</ListItemId>
-- </ListItem>
-- <ListItem>
-- <ListItemId>AB86D145-984A-4645-AF64-5F9DD072663D</ListItemId>
-- </ListItem>
-- </ListRecords>
-- </ListItems>'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_MultipleInvoiceDelete]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@InvoiceId XML = NULL,
	@IsArchived BIT = 1
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)
        IF (@HavePermission = '1')
        BEGIN
           
		    IF(@InvoiceId IS NOT NULL)
			BEGIN

				CREATE TABLE #DeleteInvoice
				(
					Id UNIQUEIDENTIFIER 
				)

				INSERT INTO #DeleteInvoice
				SELECT x.value('ListItemId[1]','uniqueidentifier')							
				FROM @InvoiceId.nodes('/ListItems/ListRecords/ListItem') XmlData(x)

				IF (@IsArchived = 1)
				BEGIN
				
				UPDATE Invoice_New SET InActiveDateTime = GETDATE(),
								       CreatedDateTime = GETDATE(),
								       CreatedByUserId = @OperationsPerformedBy
				WHERE Id IN (SELECT Id FROM #DeleteInvoice) AND CompanyId = @CompanyId
				END
				ELSE
				BEGIN

				UPDATE Invoice_New SET InActiveDateTime = NULL,
								       CreatedDateTime = GETDATE(),
								       CreatedByUserId = @OperationsPerformedBy
				WHERE Id IN (SELECT Id FROM #DeleteInvoice) AND CompanyId = @CompanyId
				END 

				SELECT Id FROM #DeleteInvoice
            
			END		
			ELSE			
			BEGIN
			
				RAISERROR (50011,16, 1)

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
