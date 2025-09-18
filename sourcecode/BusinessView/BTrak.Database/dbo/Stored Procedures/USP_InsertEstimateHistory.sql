-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      2020-03-06
-- Purpose      To Insert Estimate History
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_InsertEstimateHistory] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_InsertEstimateHistory]
(
  @EstimateId UNIQUEIDENTIFIER = NULL,
  @ClientId UNIQUEIDENTIFIER = NULL,
  @CurrencyId UNIQUEIDENTIFIER = NULL,
  @EstimateNumber NVARCHAR(50) = NULL,
  @EstimateImageUrl NVARCHAR(MAX) = NULL,
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
  @EstimateItems XML = NULL,
  @EstimateTasks XML = NULL,
  @EstimateGoals XML = NULL,
  @EstimateProjects XML = NULL,
  @EstimateTax XML = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @IsArchived BIT = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsEstimateFields BIT
) 
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	        DECLARE @OldEstimateTitle NVARCHAR(150) = NULL

	        DECLARE @OldClientName NVARCHAR(250) = NULL

			DECLARE @OldClientId UNIQUEIDENTIFIER = (SELECT ClientId FROM [Estimate] WHERE Id = @EstimateId)
	        
			DECLARE @NewClientName NVARCHAR(250) = NULL
			
			IF(@OldClientId <> @ClientId)
			BEGIN

				SET @NewClientName = (SELECT CONCAT(U.FirstName, ' ',U.SurName) FROM [Client] C LEFT JOIN [User] U ON U.Id = C.UserId 
															WHERE C.Id = @ClientId)

			END

			DECLARE @OldEstimateNumber NVARCHAR(50) = NULL
			
			DECLARE @OldPONumber NVARCHAR(50) = NULL
			
			DECLARE @OldIssueDate DATETIME = NULL

			DECLARE @OldCurrencyCode NVARCHAR(50) = NULL
			
			DECLARE @OldCurrencyId UNIQUEIDENTIFIER = (SELECT CurrencyId FROM [Estimate] WHERE Id = @EstimateId)
			
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

			DECLARE @OldEstimateTasksXml XML = NULL
			
			DECLARE @OldEstimateItemsXml XML = NULL

			DECLARE @OldTerms NVARCHAR(800) = NULL
			
			DECLARE @OldNotes NVARCHAR(800) = NULL
			
			DECLARE @OldDiscount FLOAT = NULL

		    SELECT @OldEstimateTitle = E.Title,
				   @OldClientName = CONCAT(U.FirstName, ' ',U.SurName),
				   @OldEstimateNumber = E.EstimateNumber,
				   @OldPONumber = E.PO,
				   @OldIssueDate = E.IssueDate,
				   @OldCurrencyCode = CU.CurrencyCode,
				   @OldDueDate = CONVERT(NVARCHAR,E.DueDate,107),
				   @OldTerms = E.Terms,
				   @OldNotes = E.Notes,
				   @OldDiscount = E.Discount
			FROM [Estimate] E 
					LEFT JOIN [Client] C ON C.Id = E.ClientId
					LEFT JOIN [User] U ON U.Id = @ClientId
					LEFT JOIN [Currency] CU ON CU.Id = E.CurrencyId
					WHERE E.Id = @EstimateId

			DECLARE @OldValue NVARCHAR(1000)

		    DECLARE @NewValue NVARCHAR(1000)

			DECLARE @Description NVARCHAR(200)

			DECLARE @CurrentDate DATETIME = GETDATE()

			DECLARE @EstimateHistoryId UNIQUEIDENTIFIER
		    
			IF(@IsEstimateFields = 1)
			BEGIN

			IF((@OldClientId IS NULL AND @ClientId IS NOT NULL) OR (@OldClientId <> @ClientId))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = @OldClientName

		        SET @NewValue = @NewClientName

		        SET @Description = 'EstimateClient'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END
			
			IF((@OldEstimateTitle IS NULL AND @Title IS NOT NULL) OR (@OldEstimateTitle <> @Title) OR (@OldEstimateTitle IS NOT NULL AND @Title IS NULL))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = @OldEstimateTitle

		        SET @NewValue = @Title

		        SET @Description = 'EstimateTitle'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldEstimateNumber IS NULL AND @EstimateNumber IS NOT NULL) OR (@OldEstimateNumber <> @EstimateNumber))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = @OldEstimateNumber

		        SET @NewValue = @EstimateNumber

		        SET @Description = 'EstimateNumber'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END
			
			IF((@OldPONumber IS NULL AND @PO IS NOT NULL) OR (@OldPONumber <> @PO) OR (@OldPONumber IS NOT NULL AND @PO IS NULL))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = @OldPONumber

		        SET @NewValue = @PO

		        SET @Description = 'EstimatePONumber'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldIssueDate IS NULL AND @IssueDate IS NOT NULL) OR (@OldIssueDate <> @IssueDate))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = CONVERT(NVARCHAR,@OldIssueDate,107)

		        SET @NewValue = CONVERT(NVARCHAR,@IssueDate,107)

		        SET @Description = 'EstimateIssueDate'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldCurrencyId IS NULL AND @CurrencyId IS NOT NULL) OR (@OldCurrencyId <> @CurrencyId))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = @OldCurrencyCode

		        SET @NewValue = @NewCurrencyCode

		        SET @Description = 'EstimateCurrency'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldDueDate <> @NewDueDate) OR (@OldDueDate IS NULL AND @NewDueDate IS NOT NULL) OR (@OldDueDate IS NOT NULL AND @NewDueDate IS NULL))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = @OldDueDate

		        SET @NewValue = @NewDueDate

		        SET @Description = 'EstimateDueDate'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldTerms IS NULL AND @Terms IS NOT NULL) OR (@OldTerms <> @Terms) OR (@OldTerms IS NOT NULL AND @Terms IS NULL))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = @OldTerms

		        SET @NewValue = @Terms

		        SET @Description = 'EstimateTerms'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldNotes IS NULL AND @Notes IS NOT NULL) OR (@OldNotes <> @Notes) OR (@OldNotes IS NOT NULL AND @Notes IS NULL))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = @OldNotes

		        SET @NewValue = @Notes

		        SET @Description = 'EstimateNotes'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			IF((@OldDiscount IS NULL AND @Discount IS NOT NULL) OR (@OldDiscount <> @Discount) OR (@OldDiscount IS NOT NULL AND @Discount IS NULL))
		    BEGIN

				SET @EstimateHistoryId = NEWID()
		       
		        SET @OldValue = @OldDiscount

		        SET @NewValue = @Discount

		        SET @Description = 'EstimateDiscount'
		        
		        INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT @EstimateHistoryId, @EstimateId, @OldValue, @NewValue, @Description, @CurrentDate, @OperationsPerformedBy
		    END

			END

			IF(@EstimateTasks IS NOT NULL AND @IsEstimateFields = 0)
			BEGIN

				CREATE TABLE #EstimateTaskDependency
				(
				  Id UNIQUEIDENTIFIER,
				  TaskName NVARCHAR(150),
				  TaskDescription NVARCHAR(800),
				  Rate FLOAT,
				  [Hours] FLOAT,
				  IsNew BIT DEFAULT 0
				)

				INSERT INTO #EstimateTaskDependency (Id, TaskName, TaskDescription, Rate, [Hours], IsNew)
								SELECT 
								x.value('(EstimateTaskId/text())[1]','UNIQUEIDENTIFIER') AS Id,
								x.value('TaskName[1]','NVARCHAR(150)') AS TaskName,
								x.value('TaskDescription[1]','NVARCHAR(800)') AS TaskDescription,							
								x.value('Rate[1]','FLOAT') AS Rate,
								x.value('Hours[1]','FLOAT') AS [Hours],
								x.value('IsNew[1]','BIT') AS IsNew
								FROM @EstimateTasks.nodes('/GenericListOfEstimateTasksInputModel/EstimateTasksInputModel') XmlData(x)

				--UPDATE #EstimateTaskDependency SET Id = NEWID() WHERE Id IS NULL

				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, NULL, NULL, ETD.TaskName, 'EstimateTaskAdded', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateTaskDependency ETD WHERE ETD.IsNew = 1

				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, ETD.Id, ET.TaskName, ETD.TaskName, 'EstimateTaskName', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateTaskDependency ETD INNER JOIN EstimateTask ET ON ET.Id = ETD.Id WHERE ETD.TaskName <> ET.TaskName AND ETD.IsNew = 0

				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, ETD.Id, ET.TaskDescription, ETD.TaskDescription, 'EstimateTaskDescription', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateTaskDependency ETD INNER JOIN EstimateTask ET ON ET.Id = ETD.Id WHERE ETD.TaskDescription <> ET.TaskDescription AND ETD.IsNew = 0

				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, ETD.Id, ET.Rate, ETD.Rate, 'EstimateTaskRate', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateTaskDependency ETD INNER JOIN EstimateTask ET ON ET.Id = ETD.Id WHERE ETD.Rate <> ET.Rate AND ETD.IsNew = 0

				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, ETD.Id, ET.[Hours], ETD.[Hours], 'EstimateTaskHours', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateTaskDependency ETD INNER JOIN EstimateTask ET ON ET.Id = ETD.Id WHERE ETD.[Hours] <> ET.[Hours] AND ETD.IsNew = 0

			END

			IF(@EstimateItems IS NOT NULL AND @IsEstimateFields = 0)
			BEGIN

				CREATE TABLE #EstimateItemDependency
				(
				  Id UNIQUEIDENTIFIER,
				  ItemName NVARCHAR(150),
				  ItemDescription NVARCHAR(800),								
				  Price FLOAT,
				  Quantity FLOAT,
				  IsNew BIT DEFAULT 0
				)

				INSERT INTO #EstimateItemDependency(Id, ItemName, ItemDescription, Price, Quantity, IsNew)
					SELECT 
					x.value('(EstimateItemId/text())[1]','UNIQUEIDENTIFIER') AS Id,
					x.value('ItemName[1]','NVARCHAR(150)') AS ItemName,
					x.value('ItemDescription[1]','NVARCHAR(800)') AS ItemDescription,							
					x.value('Price[1]','FLOAT') AS Price,
					x.value('Quantity[1]','FLOAT') AS Quantity,
					x.value('IsNew[1]','BIT') AS IsNew
					FROM @EstimateItems.nodes('/GenericListOfEstimateItemsInputModel/EstimateItemsInputModel') XmlData(x)

				--UPDATE #EstimateTaskDependency SET Id = NEWID() WHERE Id IS NULL

				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, NULL, NULL, EID.ItemName, 'EstimateItemAdded', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateItemDependency EID WHERE EID.IsNew = 1
				
				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, EI.Id, EI.ItemName, EID.ItemName, 'EstimateItemName', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateItemDependency EID INNER JOIN EstimateItem EI ON EI.Id = EID.Id WHERE EID.ItemName <> EI.ItemName AND EID.IsNew = 0

				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, EI.Id, EI.ItemDescription, EID.ItemDescription, 'EstimateItemDescription', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateItemDependency EID INNER JOIN EstimateItem EI ON EI.Id = EID.Id WHERE EID.ItemDescription <> EI.ItemDescription AND EID.IsNew = 0

				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, EI.Id, EI.Price, EID.Price, 'EstimateItemPrice', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateItemDependency EID INNER JOIN EstimateItem EI ON EI.Id = EID.Id WHERE EID.Price <> EI.Price AND EID.IsNew = 0

				INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @EstimateId, EI.Id, EI.Quantity, EID.Quantity, 'EstimateItemQuantity', @CurrentDate, @OperationsPerformedBy
					FROM #EstimateItemDependency EID INNER JOIN EstimateItem EI ON EI.Id = EID.Id WHERE EID.Quantity <> EI.Quantity AND EID.IsNew = 0

			END


	END TRY
	BEGIN CATCH

	    	THROW

	END CATCH

END
GO