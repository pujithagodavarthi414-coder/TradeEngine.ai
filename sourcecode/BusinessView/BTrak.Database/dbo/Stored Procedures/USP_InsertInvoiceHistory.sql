-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      2020-03-02
-- Purpose      To Insert Invoice History
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_InsertInvoiceHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_InsertInvoiceHistory]
(
  @InvoiceId UNIQUEIDENTIFIER = NULL,
  @ClientId UNIQUEIDENTIFIER = NULL,
  @CurrencyId UNIQUEIDENTIFIER = NULL,
  @InvoiceNumber NVARCHAR(50) = NULL,
  @InvoiceImageUrl NVARCHAR(MAX) = NULL,
  @CC NVARCHAR(150) = NULL,
  @BCC NVARCHAR(150) = NULL,
  @Title NVARCHAR(150) = NULL,
  @PO NVARCHAR(50)= NULL,
  @IsRecurring BIT = NULL,
  @IssueDate datetime = NULL,
  @DueDate datetime = NULL,
  @Discount FLOAT = NULL,
  @Notes NVARCHAR(800) = NULL,
  @Terms NVARCHAR(800) = NULL,
  @InvoiceItems XML = NULL,
  @InvoiceTasks XML = NULL,
  @InvoiceGoals XML = NULL,
  @InvoiceProjects XML = NULL,
  @InvoiceTax XML = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsInvoiceFields BIT
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

			DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			IF(@HavePermission = '1')			 
			BEGIN

	        DECLARE @OldInvoiceTitle NVARCHAR(150) = NULL

	        DECLARE @OldClientName NVARCHAR(250) = NULL

			DECLARE @OldClientId UNIQUEIDENTIFIER = (SELECT ClientId FROM [Invoice_New] WHERE Id = @InvoiceId)
	        
			DECLARE @NewClientName NVARCHAR(250) = NULL
			
			IF(@OldClientId <> @ClientId)
			BEGIN

				SET @NewClientName = (SELECT CONCAT(U.FirstName, ' ',U.SurName) FROM [Client] C LEFT JOIN [User] U ON U.Id = C.UserId 
															WHERE C.Id = @ClientId)

			END

			DECLARE @OldInvoiceNumber NVARCHAR(50) = NULL
			
			DECLARE @OldPONumber NVARCHAR(50) = NULL
			
			DECLARE @OldIssueDate DATETIME = NULL

			DECLARE @OldCurrencyCode NVARCHAR(50) = NULL
			
			DECLARE @OldCurrencyId UNIQUEIDENTIFIER = (SELECT CurrencyId FROM [Invoice_New] WHERE Id = @InvoiceId)
			
			DECLARE @NewCurrencyCode NVARCHAR(50) = NULL
			
			IF(@OldCurrencyId <> @CurrencyId)
			BEGIN

				SET @NewCurrencyCode = (SELECT CurrencyCode FROM [Currency] CU WHERE CU.Id = @CurrencyId)

			END

			DECLARE @OldDueDate NVARCHAR(100) = NULL

            DECLARE @NewDueDate NVARCHAR(100) = NULL

            IF(@DueDate IS NOT NULL)
            BEGIN
                
                SET @NewDueDate = CONVERT(NVARCHAR,@DueDate,107)

            END

			DECLARE @OldInvoiceTasksXml XML = NULL
			
			DECLARE @OldInvoiceItemsXml XML = NULL

			DECLARE @OldTerms NVARCHAR(800) = NULL
			
			DECLARE @OldNotes NVARCHAR(800) = NULL
			
			DECLARE @OldDiscount FLOAT = NULL

		    SELECT @OldInvoiceTitle = INV.Title,
				   @OldClientName = CONCAT(U.FirstName, ' ',U.SurName),
				   @OldInvoiceNumber = INV.InvoiceNumber,
				   @OldPONumber = INV.PO,
				   @OldIssueDate = INV.IssueDate,
				   @OldCurrencyCode = CU.CurrencyCode,
				   @OldDueDate = CONVERT(NVARCHAR,INV.DueDate,107),
				   @OldTerms = INV.Terms,
				   @OldNotes = INV.Notes,
				   @OldDiscount = INV.Discount
			FROM [Invoice_New] INV 
					LEFT JOIN [Client] C ON C.Id = INV.ClientId 
					LEFT JOIN [User] U ON U.Id = C.UserId 
					LEFT JOIN [Currency] CU ON CU.Id = INV.CurrencyId 
					WHERE INV.Id = @InvoiceId

			DECLARE @OldValue NVARCHAR(1000)

		    DECLARE @NewValue NVARCHAR(1000)

			DECLARE @Description NVARCHAR(200)

			DECLARE @CurrentDate DATETIME = GETDATE()

			DECLARE @InvoiceHistoryId UNIQUEIDENTIFIER
		    
			IF(@IsInvoiceFields = 1)
			BEGIN

			IF((@OldClientId IS NULL AND @ClientId IS NOT NULL) OR (@OldClientId <> @ClientId))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = @OldClientName

		        SET @NewValue = @NewClientName

		        SET @Description = 'InvoiceClient'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END
			
			IF((@OldInvoiceTitle IS NULL AND @Title IS NOT NULL) OR (@OldInvoiceTitle <> @Title) OR (@OldInvoiceTitle IS NOT NULL AND @Title IS NULL))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = @OldInvoiceTitle

		        SET @NewValue = @Title

		        SET @Description = 'InvoiceTitle'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldInvoiceNumber IS NULL AND @InvoiceNumber IS NOT NULL) OR (@OldInvoiceNumber <> @InvoiceNumber))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = @OldInvoiceNumber

		        SET @NewValue = @InvoiceNumber

		        SET @Description = 'InvoiceNumber'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END
			
			IF((@OldPONumber IS NULL AND @PO IS NOT NULL) OR (@OldPONumber <> @PO) OR (@OldPONumber IS NOT NULL AND @PO IS NULL))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = @OldPONumber

		        SET @NewValue = @PO

		        SET @Description = 'InvoicePONumber'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldIssueDate IS NULL AND @IssueDate IS NOT NULL) OR (@OldIssueDate <> @IssueDate))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = CONVERT(NVARCHAR,@OldIssueDate,107)

		        SET @NewValue = CONVERT(NVARCHAR,@IssueDate,107)

		        SET @Description = 'InvoiceIssueDate'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldCurrencyId IS NULL AND @CurrencyId IS NOT NULL) OR (@OldCurrencyId <> @CurrencyId))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = @OldCurrencyCode

		        SET @NewValue = @NewCurrencyCode

		        SET @Description = 'InvoiceCurrency'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldDueDate <> @NewDueDate) OR (@OldDueDate IS NULL AND @NewDueDate IS NOT NULL) OR (@OldDueDate IS NOT NULL AND @NewDueDate IS NULL))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = @OldDueDate

		        SET @NewValue = @NewDueDate

		        SET @Description = 'InvoiceDueDate'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldTerms IS NULL AND @Terms IS NOT NULL) OR (@OldTerms <> @Terms) OR (@OldTerms IS NOT NULL AND @Terms IS NULL))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = @OldTerms

		        SET @NewValue = @Terms

		        SET @Description = 'InvoiceTerms'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldNotes IS NULL AND @Notes IS NOT NULL) OR (@OldNotes <> @Notes) OR (@OldNotes IS NOT NULL AND @Notes IS NULL))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = @OldNotes

		        SET @NewValue = @Notes

		        SET @Description = 'InvoiceNotes'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldDiscount IS NULL AND @Discount IS NOT NULL) OR (@OldDiscount <> @Discount) OR (@OldDiscount IS NOT NULL AND @Discount IS NULL))
		    BEGIN

				SET @InvoiceHistoryId = NEWID()
		       
		        SET @OldValue = @OldDiscount

		        SET @NewValue = @Discount

		        SET @Description = 'InvoiceDiscount'
		        
		        INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @InvoiceHistoryId, @InvoiceId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			END

			IF(@InvoiceTasks IS NOT NULL AND @IsInvoiceFields = 0)
			BEGIN

				CREATE TABLE #InvoiceTaskDependency
				(
				  Id UNIQUEIDENTIFIER,
				  TaskName NVARCHAR(150),
				  TaskDescription NVARCHAR(800),
				  Rate FLOAT,
				  [Hours] FLOAT,
				  IsNew BIT DEFAULT 0
				)

				INSERT INTO #InvoiceTaskDependency (Id, TaskName, TaskDescription, Rate, [Hours], IsNew)
								SELECT 
								x.value('(InvoiceTaskId/text())[1]','UNIQUEIDENTIFIER') AS Id,
								x.value('TaskName[1]','NVARCHAR(150)') AS TaskName,
								x.value('TaskDescription[1]','NVARCHAR(800)') AS TaskDescription,							
								x.value('Rate[1]','FLOAT') AS Rate,
								x.value('Hours[1]','FLOAT') AS [Hours],
								x.value('IsNew[1]','BIT') AS IsNew
								FROM @InvoiceTasks.nodes('/GenericListOfInvoiceTasksInputModel/InvoiceTasksInputModel') XmlData(x)

				--UPDATE #InvoiceTaskDependency SET Id = NEWID() WHERE Id IS NULL

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, NULL, NULL, ITD.TaskName, 'InvoiceTaskAdded', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceTaskDependency ITD WHERE ITD.IsNew = 1

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, ITD.Id, ITN.TaskName, ITD.TaskName, 'InvoiceTaskName', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceTaskDependency ITD INNER JOIN InvoiceTask_New ITN ON ITN.Id = ITD.Id WHERE ITD.TaskName <> ITN.TaskName AND ITD.IsNew = 0

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, ITD.Id, ITN.TaskDescription, ITD.TaskDescription, 'InvoiceTaskDescription', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceTaskDependency ITD INNER JOIN InvoiceTask_New ITN ON ITN.Id = ITD.Id WHERE ITD.TaskDescription <> ITN.TaskDescription AND ITD.IsNew = 0

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, ITD.Id, ITN.Rate, ITD.Rate, 'InvoiceTaskRate', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceTaskDependency ITD INNER JOIN InvoiceTask_New ITN ON ITN.Id = ITD.Id WHERE ITD.Rate <> ITN.Rate AND ITD.IsNew = 0

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, ITD.Id, ITN.[Hours], ITD.[Hours], 'InvoiceTaskHours', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceTaskDependency ITD INNER JOIN InvoiceTask_New ITN ON ITN.Id = ITD.Id WHERE ITD.[Hours] <> ITN.[Hours] AND ITD.IsNew = 0

			END

			IF(@InvoiceItems IS NOT NULL AND @IsInvoiceFields = 0)
			BEGIN

				CREATE TABLE #InvoiceItemDependency
				(
				  Id UNIQUEIDENTIFIER,
				  ItemName NVARCHAR(150),
				  ItemDescription NVARCHAR(800),								
				  Price FLOAT,
				  Quantity FLOAT,
				  IsNew BIT DEFAULT 0
				)

				INSERT INTO #InvoiceItemDependency(Id, ItemName, ItemDescription, Price, Quantity, IsNew)
					SELECT 
					x.value('(InvoiceItemId/text())[1]','UNIQUEIDENTIFIER') AS Id,
					x.value('ItemName[1]','NVARCHAR(150)') AS ItemName,
					x.value('ItemDescription[1]','NVARCHAR(800)') AS ItemDescription,							
					x.value('Price[1]','FLOAT') AS Price,
					x.value('Quantity[1]','FLOAT') AS Quantity,
					x.value('IsNew[1]','BIT') AS IsNew
					FROM @InvoiceItems.nodes('/GenericListOfInvoiceItemsInputModel/InvoiceItemsInputModel') XmlData(x)

				--UPDATE #InvoiceTaskDependency SET Id = NEWID() WHERE Id IS NULL

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, NULL, NULL, IID.ItemName, 'InvoiceItemAdded', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceItemDependency IID WHERE IID.IsNew = 1
				
				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, IIN.Id, IIN.ItemName, IID.ItemName, 'InvoiceItemName', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceItemDependency IID INNER JOIN InvoiceItem_New IIN ON IIN.Id = IID.Id WHERE IID.ItemName <> IIN.ItemName AND IID.IsNew = 0

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, IIN.Id, IIN.ItemDescription, IID.ItemDescription, 'InvoiceItemDescription', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceItemDependency IID INNER JOIN InvoiceItem_New IIN ON IIN.Id = IID.Id WHERE IID.ItemDescription <> IIN.ItemDescription AND IID.IsNew = 0

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, IIN.Id, IIN.Price, IID.Price, 'InvoiceItemPrice', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceItemDependency IID INNER JOIN InvoiceItem_New IIN ON IIN.Id = IID.Id WHERE IID.Price <> IIN.Price AND IID.IsNew = 0

				INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @InvoiceId, IIN.Id, IIN.Quantity, IID.Quantity, 'InvoiceItemQuantity', @CurrentDate, @OperationsPerformedBy
					FROM #InvoiceItemDependency IID INNER JOIN InvoiceItem_New IIN ON IIN.Id = IID.Id WHERE IID.Quantity <> IIN.Quantity AND IID.IsNew = 0

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