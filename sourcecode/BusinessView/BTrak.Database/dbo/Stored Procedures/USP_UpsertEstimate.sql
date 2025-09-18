----------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-06 00:00:00.000'
-- Purpose      To Add Estimate by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--	EXEC [dbo].[USP_UpsertEstimate] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @ClientId = 'DCBAA667-B31D-4451-AF6C-5ADEF701CA0B', @EstimateNumber = 003,
--	@EstimateTasks = '<GenericListOfEstimateTasksInputModel>
--	<ListItems>
--	<EstimateTasksInputModel>
--	<InputCommandGuid>1535BCEC-CA51-470A-BAE9-25FCD3E99289</InputCommandGuid>
--	<InputCommandTypeGuid>91379295-01AC-40BE-84E3-96CD499ABCDE</InputCommandTypeGuid>
--	<TaskName>fhjmnb</TaskName>
--	<Rate>200</Rate>
--	<Hours>6</Hours>
--	<IsArchived>false</IsArchived>
--	</EstimateTasksInputModel>

--	<EstimateTasksInputModel>
--	<InputCommandGuid>EB5286A2-77CF-43C8-9AF1-47D2E0FD8A92</InputCommandGuid>
--	<InputCommandTypeGuid>309088B4-78C5-4E13-BDD3-D86CA0D82F5F</InputCommandTypeGuid>
--	<TaskName>gdjcvbh</TaskName>
--	<Rate>250</Rate>
--	<Hours>5</Hours>
--	<IsArchived>false</IsArchived>
--	</EstimateTasksInputModel>
--	</ListItems>
--	</GenericListOfEstimateTasksInputModel>',

--	@EstimateItems = '<GenericListOfEstimateItemsInputModel>
--	<ListItems>
--	<EstimateItemsInputModel>
--	<InputCommandGuid>5d1c6ff0-7246-450d-95a5-65eae97cf9c4</InputCommandGuid>
--	<InputCommandTypeGuid>67319c43-3433-437b-95fd-c0801aaa3ea3</InputCommandTypeGuid>
--	<ItemName>Laptop</ItemName>
--	<ItemDescription>8GB ram 2TB HDD</ItemDescription>
--	<Price>250</Price>
--	<Quantity>2</Quantity>
--	<IsArchived>false</IsArchived>
--	</EstimateItemsInputModel>

--	<EstimateItemsInputModel>
--	<InputCommandGuid>b616d2f7-ce96-4bef-a8d8-dc8bd87e3700</InputCommandGuid>
--	<InputCommandTypeGuid>67319c43-3433-437b-95fd-c0801aaa3ea3</InputCommandTypeGuid>
--	<ItemName>RAM</ItemName>
--	<ItemDescription>8GB</ItemDescription>
--	<Price>20</Price>
--	<Quantity>2</Quantity>
--	<IsArchived>false</IsArchived>
--	</EstimateItemsInputModel>
--	</ListItems>
--	</GenericListOfEstimateItemsInputModel>',
----------------------------------------------------------------------------------			
CREATE PROCEDURE [dbo].[USP_UpsertEstimate]
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
	@Discount float = NULL,
	@TotalEstimateAmount float = NULL,
	@EstimateDiscountAmount float = NULL,
	@SubTotalEstimateAmount float = NULL,
	@Notes NVARCHAR(800) = NULL,
	@Terms NVARCHAR(800) = NULL,
	@EstimateItems XML = NULL,
	@EstimateTasks XML = NULL,
	@EstimateGoals XML = NULL,
	@EstimateProjects XML = NULL,
	@EstimateTax XML = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER		
)
AS
BEGIN

	 SET NOCOUNT ON
       BEGIN TRY
          
            DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF(@HavePermission = '1')			 
            BEGIN

			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@ClientId = '00000000-0000-0000-0000-000000000000') SET @ClientId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			DECLARE @EstimateStatusId UNIQUEIDENTIFIER = (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Draft' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

			IF (@EstimateId IS NOT NULL) SET @EstimateStatusId = (SELECT [EstimateStatusId] FROM [Estimate] WHERE Id = @EstimateId AND CompanyId = @CompanyId)

			IF (@EstimateId IS NOT NULL AND @SubTotalEstimateAmount IS NOT NULL AND @SubTotalEstimateAmount > 0 AND @TotalEstimateAmount IS NOT NULL AND @TotalEstimateAmount = 0) SET @EstimateStatusId = (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Paid' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

			IF (@EstimateNumber = '') SET @EstimateNumber = NULL
			
			IF (@Title = '') SET @Title = NULL
			
			IF (@PO = '') SET @PO = NULL

			IF (@IssueDate = '') SET @IssueDate = NULL

			IF (@DueDate = '') SET @DueDate = NULL

			IF (@Notes = '') SET @Notes = NULL

			IF (@Terms = '') SET @Terms = NULL
		    
		    DECLARE @EstimateIdCount INT = (SELECT COUNT(1) FROM Estimate WHERE Id = @EstimateId AND CompanyId = @CompanyId)
		    
		    DECLARE @EstimateTitleCount INT = (SELECT COUNT(1) FROM Estimate WHERE Title = @Title AND Title IS NOT NULL AND (@EstimateId IS NULL OR Id <> @EstimateId) AND CompanyId = @CompanyId)
		    
			DECLARE @EstimateNumberCount INT = (SELECT COUNT(1) FROM Estimate WHERE EstimateNumber = @EstimateNumber AND EstimateNumber IS NOT NULL AND (@EstimateId IS NULL OR Id <> @EstimateId) AND CompanyId = @CompanyId)
		    
			DECLARE @PONumberCount INT = (SELECT COUNT(1) FROM Estimate WHERE PO = @PO AND PO IS NOT NULL AND (@EstimateId IS NULL OR Id <> @EstimateId) AND CompanyId = @CompanyId)
		    
			IF(@EstimateIdCount = 0 AND @EstimateId IS NOT NULL)
		    BEGIN
		    
		    	RAISERROR(50002,16, 1,'EstimateId')
		    
		    END		    
		    ELSE IF(@EstimateTitleCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'EstimateTitle',@Title)
		    
		    END
			ELSE IF(@EstimateNumberCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'EstimateNumber',@EstimateNumber)
		    
		    END
			ELSE IF(@PONumberCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'PONumber',@PO)
		    
		    END
			ELSE IF(@EstimateNumber IS NULL)
		    BEGIN
		    
		    	RAISERROR(50011,16,1,'EstimateNumber')
		    
		    END
			ELSE IF(@ClientId IS NULL)
		    BEGIN
		    
		    	RAISERROR(50011,16,1,'ClientId')
		    
		    END
		    ELSE
		    BEGIN
		        
				DECLARE @IsLatest BIT = (CASE WHEN @EstimateId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM Estimate WHERE Id = @EstimateId) = @TimeStamp THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE	@IsNewHistory BIT = 0

					DECLARE @Currentdate DATETIME = GETDATE()
			        
			        DECLARE @NewEstimateId UNIQUEIDENTIFIER = NEWID()

					IF(@EstimateId IS NULL)
					 BEGIN

					 SET @IssueDate = @Currentdate

					 SET @IsNewHistory = 1

					 SET @EstimateId = NEWID()

					INSERT INTO [dbo].[Estimate](
								[Id],
								[ClientId],
								[CurrencyId],
								[EstimateStatusId],
								[EstimateNumber],
								[EstimateImageUrl],
								[CC],
								[BCC],
								[Title],
								[PO],
								[IsRecurring],
								[IssueDate],
								[DueDate],
								[Discount],
								[TotalAmount],
								[DiscountAmount],
								[SubTotalAmount],
								[Notes],
								[Terms],
								[CompanyId],
								[CreatedDateTime],
                                [CreatedByUserId],      
                                [InActiveDateTime]
								)
						 SELECT @EstimateId,
								@ClientId,
								@CurrencyId,
								@EstimateStatusId,
								@EstimateNumber,
								@EstimateImageUrl,
								@CC,
								@BCC,
								@Title,
								@PO,
								@IsRecurring,
								@IssueDate,
								@DueDate,
								@Discount,
								@TotalEstimateAmount,
								@EstimateDiscountAmount,
								@SubTotalEstimateAmount,
								@Notes,
								@Terms,
								@CompanyId,
								@Currentdate,
								@OperationsPerformedBy,																																	
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				     SELECT NEWID(), @EstimateId, NULL, @EstimateNumber, 'EstimateAdded', @Currentdate, @OperationsPerformedBy

					END
					
					ELSE
					BEGIN

					SET @IsNewHistory = 0

					IF(@IssueDate IS NULL)
					BEGIN
						
						SET @IssueDate = (SELECT IssueDate FROM [Estimate] WHERE Id = @EstimateId AND InActiveDateTime IS NULL)

					END

					EXEC [dbo].[USP_InsertEstimateHistory] @EstimateId = @EstimateId, @ClientId = @ClientId, @CurrencyId = @CurrencyId, @EstimateNumber = @EstimateNumber,
							@Title = @Title, @PO = @PO, @IssueDate = @IssueDate, @DueDate = @DueDate, @Discount = @Discount, @Notes = @Notes,
							@Terms = @Terms, @OperationsPerformedBy= @OperationsPerformedBy, @IsEstimateFields = 1
					
					UPDATE [Estimate]
					   SET [ClientId] = @ClientId,
						   [CurrencyId] = @CurrencyId,
						   [EstimateStatusId] = @EstimateStatusId,
						   [EstimateNumber] = @EstimateNumber,
						   [EstimateImageUrl] = @EstimateImageUrl,
						   [CC] = @CC,
						   [BCC] = @BCC,
						   [Title] = @Title,
						   [PO] = @PO,
						   [IsRecurring] = @IsRecurring,
						   [IssueDate] = @IssueDate,
						   [DueDate] = @DueDate,
						   [Discount] = @Discount,
						   [TotalAmount] = @TotalEstimateAmount,
						   [DiscountAmount] = @EstimateDiscountAmount,
						   [SubTotalAmount] = @SubTotalEstimateAmount,
						   [Notes] = @Notes,
						   [Terms] = @Terms,
						   [CompanyId] = @CompanyId,
						   [UpdatedDateTime] = @Currentdate,
						   [UpdatedByUserId] = @OperationsPerformedBy,   
						   [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						   WHERE Id = @EstimateId
					  END

					SELECT Id FROM [dbo].[Estimate] WHERE Id = @EstimateId

					IF(@EstimateTasks IS NOT NULL)
					BEGIN

						CREATE TABLE #Tasks(
							Id UNIQUEIDENTIFIER,
							TaskName NVARCHAR(150),
							TaskDescription NVARCHAR(800),								
							Rate FLOAT,
							[Hours] FLOAT,
							[Order] INT,
							IsArchived BIT,
							IsNew BIT DEFAULT 0 
							)
						
							INSERT INTO #Tasks (Id, TaskName, TaskDescription, Rate, [Hours], [Order], IsArchived)
							SELECT 
							x.value('(EstimateTaskId/text())[1]','UNIQUEIDENTIFIER') AS Id,
							x.value('TaskName[1]','NVARCHAR(150)') AS TaskName,
							x.value('TaskDescription[1]','NVARCHAR(800)') AS TaskDescription,							
							x.value('Rate[1]','FLOAT') AS Rate,
							x.value('Hours[1]','FLOAT') AS [Hours],
							x.value('Order[1]','INT') AS [Order],
							x.value('IsArchived[1]','BIT')
							FROM @EstimateTasks.nodes('/GenericListOfEstimateTasksInputModel/ListItems/EstimateTasksInputModel') XmlData(x)

							UPDATE #Tasks SET Id = NEWID(),IsNew = 1 WHERE Id IS NULL

							--History

							IF(@IsNewHistory = 0)
							BEGIN

								SET @EstimateTasks = (SELECT Id AS EstimateTaskId
								   ,TaskName AS TaskName
								   ,TaskDescription AS TaskDescription
								   ,Rate
								   ,[Hours]
								   ,IsNew
								FROM #Tasks
								FOR XML PATH('EstimateTasksInputModel'),ROOT('GenericListOfEstimateTasksInputModel'))

								EXEC [dbo].[USP_InsertEstimateHistory] @EstimateId = @EstimateId, @EstimateTasks = @EstimateTasks, @OperationsPerformedBy= @OperationsPerformedBy, @IsEstimateFields = 0

							END

							INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @EstimateId, Id, NULL, TaskName, 'EstimateTaskRemoved', @CurrentDate, @OperationsPerformedBy
								FROM EstimateTask WHERE EstimateId = @EstimateId AND Id NOT IN (SELECT Id FROM #Tasks WHERE IsNew = 0)

							UPDATE [EstimateTask] SET InactiveDateTime = @Currentdate,
														 UpdatedByUserId = @OperationsPerformedBy,
														 UpdatedDateTime = @Currentdate
									WHERE EstimateId = @EstimateId AND Id NOT IN (SELECT Id FROM #Tasks WHERE IsNew = 0)

							UPDATE [EstimateTask] SET TaskName = T.TaskName,
											  TaskDescription = T.TaskDescription,
											  Rate = T.Rate,
											  [Hours] = T.[Hours],
											  [Order] = T.[Order],
											  UpdatedByUserId = @OperationsPerformedBy,
											  UpdatedDateTime = @Currentdate
							FROM EstimateTask ET 
							INNER JOIN #Tasks T ON T.Id = ET.Id

						INSERT INTO [dbo].[EstimateTask](
									[Id],
									[EstimateId],
									[TaskName],
									[TaskDescription],									
									[Rate],
									[Hours],
									[Order],
									[CreatedByUserId],
									[CreatedDateTime],
									[InActiveDateTime]
									)
						SELECT	T.Id,
								@EstimateId,
								T.TaskName,
								T.TaskDescription,								
								T.Rate,
								T.[Hours],
								T.[Order],
								@OperationsPerformedBy,
								@Currentdate,
								CASE WHEN T.IsArchived = 1 THEN @Currentdate ELSE NULL END
						FROM #Tasks T 
						WHERE T.IsNew = 1
						
					END
					IF(@EstimateItems IS NOT NULL)
					BEGIN

						CREATE TABLE #Items(
							Id UNIQUEIDENTIFIER,
							ItemName NVARCHAR(150),
							ItemDescription NVARCHAR(800),								
							Price FLOAT,
							Quantity FLOAT,
							[Order] INT,
							IsArchived BIT,				
							IsNew BIT DEFAULT 0 
							)

							INSERT INTO #ITEMS(Id, ItemName, ItemDescription, Price, Quantity, [Order], IsArchived )
							SELECT 
							x.value('(EstimateItemId/text())[1]','UNIQUEIDENTIFIER') AS Id,
							x.value('ItemName[1]','NVARCHAR(150)') AS ItemName,
							x.value('ItemDescription[1]','NVARCHAR(800)') AS ItemDescription,							
							x.value('Price[1]','FLOAT') AS Price,
							x.value('Quantity[1]','FLOAT') AS Quantity,
							x.value('Order[1]','INT') AS [Order],
							x.value('IsArchived[1]','BIT')
							FROM @EstimateItems.nodes('/GenericListOfEstimateItemsInputModel/ListItems/EstimateItemsInputModel') XmlData(x)

							UPDATE #Items SET Id = NEWID(),IsNew = 1 WHERE Id IS NULL

							--History
							IF(@IsNewHistory = 0)
							BEGIN

								SET @EstimateItems = (SELECT Id AS EstimateItemId
						       ,ItemName AS ItemName
							   ,ItemDescription AS ItemDescription
							   ,Price
							   ,Quantity
							   ,IsNew
							FROM #Items
							FOR XML PATH('EstimateItemsInputModel'),ROOT('GenericListOfEstimateItemsInputModel'))

								EXEC [dbo].[USP_InsertEstimateHistory] @EstimateId = @EstimateId, @EstimateItems = @EstimateItems, @OperationsPerformedBy= @OperationsPerformedBy, @IsEstimateFields = 0

							END

							INSERT INTO [dbo].[EstimateHistory]([Id], [EstimateId], [EstimateItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @EstimateId, Id, NULL, ItemName, 'EstimateItemRemoved', @CurrentDate, @OperationsPerformedBy
								FROM EstimateItem WHERE EstimateId = @EstimateId AND Id NOT IN (SELECT Id FROM #ITEMS WHERE IsNew = 0)

							UPDATE [EstimateItem] SET InactiveDateTime = @Currentdate,
														 UpdatedByUserId = @OperationsPerformedBy,
														 UpdatedDateTime = @Currentdate
									WHERE EstimateId = @EstimateId AND Id NOT IN (SELECT Id FROM #ITEMS WHERE IsNew = 0)

							UPDATE [EstimateItem] SET ItemName = I.ItemName,
											  ItemDescription = I.ItemDescription,
											  Price = I.Price,
											  Quantity = I.Quantity,
											  [Order] = I.[Order],
											  UpdatedByUserId = @OperationsPerformedBy,
											  UpdatedDateTime = @Currentdate
							FROM [EstimateItem] EI
								INNER JOIN #Items I ON I.Id = EI.Id


						INSERT INTO [dbo].[EstimateItem](
									[Id],
									[EstimateId],
									[ItemName],
									[ItemDescription],									
									[Price],
									[Quantity],
									[Order],
									[CreatedByUserId],
									[CreatedDateTime],
									[InActiveDateTime]
									)
						SELECT	I.Id,
								@EstimateId,
								I.ItemName,
								I.ItemDescription,								
								I.Price,
								I.Quantity,
								I.[Order],
								@OperationsPerformedBy,
								@Currentdate,
								CASE WHEN I.IsArchived = 1 THEN @Currentdate ELSE NULL END

						FROM #ITEMS I
						WHERE I.IsNew = 1
						
					END
				END	
				ELSE

			  		RAISERROR (50008,11, 1)
					
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