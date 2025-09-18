----------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-03-02 00:00:00.000'
-- Purpose      To Add Invoice by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
--	EXEC [dbo].[USP_UpsertInvoice] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971', @ClientId = 'DCBAA667-B31D-4451-AF6C-5ADEF701CA0B', @InvoiceNumber = 003,
--	@InvoiceTasks = '<GenericListOfInvoiceTasksInputModel>
--	<ListItems>
--	<InvoiceTasksInputModel>
--	<InputCommandGuid>1535BCEC-CA51-470A-BAE9-25FCD3E99289</InputCommandGuid>
--	<InputCommandTypeGuid>91379295-01AC-40BE-84E3-96CD499ABCDE</InputCommandTypeGuid>
--	<TaskName>fhjmnb</TaskName>
--	<Rate>200</Rate>
--	<Hours>6</Hours>
--	<IsArchived>false</IsArchived>
--	</InvoiceTasksInputModel>

--	<InvoiceTasksInputModel>
--	<InputCommandGuid>EB5286A2-77CF-43C8-9AF1-47D2E0FD8A92</InputCommandGuid>
--	<InputCommandTypeGuid>309088B4-78C5-4E13-BDD3-D86CA0D82F5F</InputCommandTypeGuid>
--	<TaskName>gdjcvbh</TaskName>
--	<Rate>250</Rate>
--	<Hours>5</Hours>
--	<IsArchived>false</IsArchived>
--	</InvoiceTasksInputModel>
--	</ListItems>
--	</GenericListOfInvoiceTasksInputModel>',

--	@InvoiceItems = '<GenericListOfInvoiceItemsInputModel>
--	<ListItems>
--	<InvoiceItemsInputModel>
--	<InputCommandGuid>5d1c6ff0-7246-450d-95a5-65eae97cf9c4</InputCommandGuid>
--	<InputCommandTypeGuid>67319c43-3433-437b-95fd-c0801aaa3ea3</InputCommandTypeGuid>
--	<ItemName>Laptop</ItemName>
--	<ItemDescription>8GB ram 2TB HDD</ItemDescription>
--	<Price>250</Price>
--	<Quantity>2</Quantity>
--	<IsArchived>false</IsArchived>
--	</InvoiceItemsInputModel>

--	<InvoiceItemsInputModel>
--	<InputCommandGuid>b616d2f7-ce96-4bef-a8d8-dc8bd87e3700</InputCommandGuid>
--	<InputCommandTypeGuid>67319c43-3433-437b-95fd-c0801aaa3ea3</InputCommandTypeGuid>
--	<ItemName>RAM</ItemName>
--	<ItemDescription>8GB</ItemDescription>
--	<Price>20</Price>
--	<Quantity>2</Quantity>
--	<IsArchived>false</IsArchived>
--	</InvoiceItemsInputModel>
--	</ListItems>
--	</GenericListOfInvoiceItemsInputModel>',

--	@InvoiceGoals = '<GenericListOfInvoiceGoalInputModel>
--	<ListItems>
--	<InvoiceGoalInputModel>
--	<InputCommandGuid>8346626F-7CC4-4780-A554-914791734877</InputCommandGuid>
--	<InputCommandTypeGuid>4A490802-AEC6-4ED4-AD0D-C34D1D367DB5</InputCommandTypeGuid>
--	<GoalId>FF4047B8-39B1-42D2-8910-4E60ED38AAC7</GoalId>
--	<IsArchived>false</IsArchived>
--	</InvoiceGoalInputModel>

--	<InvoiceGoalInputModel>
--	<InputCommandGuid>11F1BCC9-B30B-477E-BE18-545B00B2F281</InputCommandGuid>
--	<InputCommandTypeGuid>CD8A68E3-E0AA-4757-BF86-BF127ABB89D1</InputCommandTypeGuid>
--	<GoalId>FF4047B8-39B1-42D2-8910-4E60ED38AAC7</GoalId>
--	<IsArchived>false</IsArchived>
--	</InvoiceGoalInputModel>
--	</ListItems>
--	</GenericListOfInvoiceGoalInputModel>',

--	@InvoiceProjects = '<GenericListOfInvoiceProjectsInputModel>
--	<ListItems>
--	<InvoiceProjectsInputModel>
--	<InputCommandGuid>8346626F-7CC4-4780-A554-914791734877</InputCommandGuid>
--	<InputCommandTypeGuid>4A490802-AEC6-4ED4-AD0D-C34D1D367DB5</InputCommandTypeGuid>
--	<ProjectId>53C96173-0651-48BD-88A9-7FC79E836CCE</ProjectId>
--	<IsArchived>false</IsArchived>
--	</InvoiceProjectsInputModel>

--	<InvoiceProjectsInputModel>
--	<InputCommandGuid>11F1BCC9-B30B-477E-BE18-545B00B2F281</InputCommandGuid>
--	<InputCommandTypeGuid>CD8A68E3-E0AA-4757-BF86-BF127ABB89D1</InputCommandTypeGuid>
--	<ProjectId>064A975E-6FC9-4CC2-A489-28FDA36BFC40</ProjectId>
--	<IsArchived>false</IsArchived>
--	</InvoiceProjectsInputModel>
--	</ListItems>
--	</GenericListOfInvoiceProjectsInputModel>',

--	@InvoiceTax = '<GenericListOfInvoiceTaxInputModel>
--	<ListItems>
--	<InvoiceTaxInputModel>
--	<InputCommandGuid>5d1c6ff0-7246-450d-95a5-65eae97cf9c4</InputCommandGuid>
--	<InputCommandTypeGuid>67319c43-3433-437b-95fd-c0801aaa3ea3</InputCommandTypeGuid>
--	<Tax>55</Tax>
--	<IsArchived>false</IsArchived>
--	</InvoiceTaxInputModel>

--	<InvoiceTaxInputModel>
--	<InputCommandGuid>b616d2f7-ce96-4bef-a8d8-dc8bd87e3700</InputCommandGuid>
--	<InputCommandTypeGuid>67319c43-3433-437b-95fd-c0801aaa3ea3</InputCommandTypeGuid>
--	<Tax>50</Tax>
--	<IsArchived>false</IsArchived>
--	</InvoiceTaxInputModel>
--	</ListItems>
--	</GenericListOfInvoiceTaxInputModel>'
----------------------------------------------------------------------------------			
CREATE PROCEDURE [dbo].[USP_UpsertInvoice]
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
	@Discount float = NULL,
	@TotalInvoiceAmount float = NULL,
	@InvoiceDiscountAmount float = NULL,
	@SubTotalInvoiceAmount float = NULL,
	@AmountPaid float = NULL,
	@DueAmount float = NULL,
	@Notes NVARCHAR(800) = NULL,
	@Terms NVARCHAR(800) = NULL,
	@InvoiceItems XML = NULL,
	@InvoiceTasks XML = NULL,
	@InvoiceGoals XML = NULL,
	@InvoiceProjects XML = NULL,
	@InvoiceTax XML = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@IsArchived BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER		
)
AS
BEGIN

	 SET NOCOUNT ON
       BEGIN TRY
          
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            IF(@HavePermission = '1')			 
            BEGIN

			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			IF (@ClientId = '00000000-0000-0000-0000-000000000000') SET @ClientId = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			DECLARE @InvoiceStatusId UNIQUEIDENTIFIER = (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Draft' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

			IF (@InvoiceId IS NOT NULL) SET @InvoiceStatusId = (SELECT [InvoiceStatusId] FROM [Invoice_New] WHERE Id = @InvoiceId AND CompanyId = @CompanyId)
			
			IF (@InvoiceId IS NOT NULL AND @SubTotalInvoiceAmount IS NOT NULL AND @SubTotalInvoiceAmount > 0 AND @TotalInvoiceAmount IS NOT NULL AND @TotalInvoiceAmount = 0) SET @InvoiceStatusId = (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Paid' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

			IF (@InvoiceId IS NOT NULL AND @AmountPaid IS NOT NULL AND @AmountPaid > 0 AND @TotalInvoiceAmount IS NOT NULL AND @TotalInvoiceAmount > 0 AND @AmountPaid < @TotalInvoiceAmount) SET @InvoiceStatusId = (SELECT Id FROM [InvoiceStatus] WHERE InvoiceStatusName = 'Partial' AND InActiveDateTime IS NULL AND CompanyId = @CompanyId)

			IF (@InvoiceNumber = '') SET @InvoiceNumber = NULL
			
			IF (@Title = '') SET @Title = NULL
			
			IF (@PO = '') SET @PO = NULL

			IF (@IssueDate = '') SET @IssueDate = NULL

			IF (@DueDate = '') SET @DueDate = NULL

			IF (@Notes = '') SET @Notes = NULL

			IF (@Terms = '') SET @Terms = NULL
		    
		    DECLARE @InvoiceIdCount INT = (SELECT COUNT(1) FROM Invoice_New WHERE Id = @InvoiceId AND CompanyId = @CompanyId)
		    
		    DECLARE @InvoiceTitleCount INT = (SELECT COUNT(1) FROM Invoice_New WHERE Title = @Title AND Title IS NOT NULL AND (@InvoiceId IS NULL OR Id <> @InvoiceId) AND CompanyId = @CompanyId)
		    
			DECLARE @InvoiceNumberCount INT = (SELECT COUNT(1) FROM Invoice_New WHERE InvoiceNumber = @InvoiceNumber AND InvoiceNumber IS NOT NULL AND (@InvoiceId IS NULL OR Id <> @InvoiceId) AND CompanyId = @CompanyId)
		    
			DECLARE @PONumberCount INT = (SELECT COUNT(1) FROM Invoice_New WHERE PO = @PO AND PO IS NOT NULL AND (@InvoiceId IS NULL OR Id <> @InvoiceId) AND CompanyId = @CompanyId)
		    
			IF(@InvoiceIdCount = 0 AND @InvoiceId IS NOT NULL)
		    BEGIN
		    
		    	RAISERROR(50002,16, 1,'InvoiceId')
		    
		    END		    
		    ELSE IF(@InvoiceTitleCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'InvoiceTitle',@Title)
		    
		    END
			ELSE IF(@InvoiceNumberCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'InvoiceNumber',@InvoiceNumber)
		    
		    END
			ELSE IF(@PONumberCount > 0)
		    BEGIN
		    
		    	RAISERROR(50001,16,1,'PONumber',@PO)
		    
		    END
			ELSE IF(@InvoiceNumber IS NULL)
		    BEGIN
		    
		    	RAISERROR(50011,16,1,'InvoiceNumber')
		    
		    END
			ELSE IF(@ClientId IS NULL)
		    BEGIN
		    
		    	RAISERROR(50011,16,1,'ClientId')
		    
		    END
		    ELSE
		    BEGIN
		        
				DECLARE @IsLatest BIT = (CASE WHEN @InvoiceId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM Invoice_New WHERE Id = @InvoiceId) = @TimeStamp THEN 1 ELSE 0 END END)
			
			    IF(@IsLatest = 1)
				BEGIN

					DECLARE	@IsNewHistory BIT = 0

					DECLARE @Currentdate DATETIME = GETDATE()
			        
			        DECLARE @NewInvoiceId UNIQUEIDENTIFIER = NEWID()

					IF(@InvoiceId IS NULL)
					 BEGIN

					 SET @IssueDate = @Currentdate

					 SET @IsNewHistory = 1

					 SET @InvoiceId = NEWID()

					INSERT INTO [dbo].[Invoice_New](
								[Id],
								[ClientId],
								[CurrencyId],
								[InvoiceStatusId],
								[InvoiceNumber],
								[InvoiceImageUrl],
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
						 SELECT @InvoiceId,
								@ClientId,
								@CurrencyId,
								@InvoiceStatusId,
								@InvoiceNumber,
								@InvoiceImageUrl,
								@CC,
								@BCC,
								@Title,
								@PO,
								@IsRecurring,
								@IssueDate,
								@DueDate,
								@Discount,
								@TotalInvoiceAmount,
								@InvoiceDiscountAmount,
								@SubTotalInvoiceAmount,
								@Notes,
								@Terms,
								@CompanyId,
								@Currentdate,
								@OperationsPerformedBy,																																	
								CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				     SELECT NEWID(), @InvoiceId, NULL, @InvoiceNumber, 'InvoiceAdded', @Currentdate, @OperationsPerformedBy

					END
					
					ELSE
					BEGIN

					SET @IsNewHistory = 0

					IF(@IssueDate IS NULL)
					BEGIN
						
						SET @IssueDate = (SELECT IssueDate FROM [Invoice_New] WHERE Id = @InvoiceId AND InActiveDateTime IS NULL)

					END

					EXEC [dbo].[USP_InsertInvoiceHistory] @InvoiceId = @InvoiceId, @ClientId = @ClientId, @CurrencyId = @CurrencyId, @InvoiceNumber = @InvoiceNumber,
							@Title = @Title, @PO = @PO, @IssueDate = @IssueDate, @DueDate = @DueDate, @Discount = @Discount, @Notes = @Notes,
							@Terms = @Terms, @OperationsPerformedBy= @OperationsPerformedBy, @IsInvoiceFields = 1
					
					UPDATE [Invoice_New]
					   SET [ClientId] = @ClientId,
						   [CurrencyId] = @CurrencyId,
						   [InvoiceStatusId] = @InvoiceStatusId,
						   [InvoiceNumber] = @InvoiceNumber,
						   [InvoiceImageUrl] = @InvoiceImageUrl,
						   [CC] = @CC,
						   [BCC] = @BCC,
						   [Title] = @Title,
						   [PO] = @PO,
						   [IsRecurring] = @IsRecurring,
						   [IssueDate] = @IssueDate,
						   [DueDate] = @DueDate,
						   [Discount] = @Discount,
						   [TotalAmount] = @TotalInvoiceAmount,
						   [DiscountAmount] = @InvoiceDiscountAmount,
						   [SubTotalAmount] = @SubTotalInvoiceAmount,
						   [Notes] = @Notes,
						   [Terms] = @Terms,
						   [CompanyId] = @CompanyId,
						   [UpdatedDateTime] = @Currentdate,
						   [UpdatedByUserId] = @OperationsPerformedBy,   
						   [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
						   WHERE Id = @InvoiceId
					  END

					SELECT Id FROM [dbo].[Invoice_New] WHERE Id = @InvoiceId

					IF(@InvoiceTasks IS NOT NULL)
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
							x.value('(InvoiceTaskId/text())[1]','UNIQUEIDENTIFIER') AS Id,
							x.value('TaskName[1]','NVARCHAR(150)') AS TaskName,
							x.value('TaskDescription[1]','NVARCHAR(800)') AS TaskDescription,							
							x.value('Rate[1]','FLOAT') AS Rate,
							x.value('Hours[1]','FLOAT') AS [Hours],
							x.value('Order[1]','INT') AS [Order],
							x.value('IsArchived[1]','BIT')
							FROM @InvoiceTasks.nodes('/GenericListOfInvoiceTasksInputModel/ListItems/InvoiceTasksInputModel') XmlData(x)

							UPDATE #Tasks SET Id = NEWID(),IsNew = 1 WHERE Id IS NULL

							--History

							IF(@IsNewHistory = 0)
							BEGIN

								SET @InvoiceTasks = (SELECT Id AS InvoiceTaskId
								   ,TaskName AS TaskName
								   ,TaskDescription AS TaskDescription
								   ,Rate
								   ,[Hours]
								   ,IsNew
								FROM #Tasks
								FOR XML PATH('InvoiceTasksInputModel'),ROOT('GenericListOfInvoiceTasksInputModel'))

								EXEC [dbo].[USP_InsertInvoiceHistory] @InvoiceId = @InvoiceId, @InvoiceTasks = @InvoiceTasks, @OperationsPerformedBy= @OperationsPerformedBy, @IsInvoiceFields = 0

							END

							INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceTaskId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @InvoiceId, Id, NULL, TaskName, 'InvoiceTaskRemoved', @CurrentDate, @OperationsPerformedBy
								FROM InvoiceTask_New WHERE InvoiceId = @InvoiceId AND Id NOT IN (SELECT Id FROM #Tasks WHERE IsNew = 0)

							UPDATE [InvoiceTask_New] SET InactiveDateTime = @Currentdate,
														 UpdatedByUserId = @OperationsPerformedBy,
														 UpdatedDateTime = @Currentdate
									WHERE InvoiceId = @InvoiceId AND Id NOT IN (SELECT Id FROM #Tasks WHERE IsNew = 0)

							UPDATE [InvoiceTask_New] SET TaskName = T.TaskName,
											  TaskDescription = T.TaskDescription,
											  Rate = T.Rate,
											  [Hours] = T.[Hours],
											  [Order] = T.[Order],
											  UpdatedByUserId = @OperationsPerformedBy,
											  UpdatedDateTime = @Currentdate
							FROM InvoiceTask_New IT 
							INNER JOIN #Tasks T ON T.Id = IT.Id

						INSERT INTO [dbo].[InvoiceTask_New](
									[Id],
									[InvoiceId],
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
								@InvoiceId,
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
					IF(@InvoiceItems IS NOT NULL)
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
							x.value('(InvoiceItemId/text())[1]','UNIQUEIDENTIFIER') AS Id,
							x.value('ItemName[1]','NVARCHAR(150)') AS ItemName,
							x.value('ItemDescription[1]','NVARCHAR(800)') AS ItemDescription,							
							x.value('Price[1]','FLOAT') AS Price,
							x.value('Quantity[1]','FLOAT') AS Quantity,
							x.value('Order[1]','INT') AS [Order],
							x.value('IsArchived[1]','BIT')
							FROM @InvoiceItems.nodes('/GenericListOfInvoiceItemsInputModel/ListItems/InvoiceItemsInputModel') XmlData(x)

							UPDATE #Items SET Id = NEWID(),IsNew = 1 WHERE Id IS NULL

							--History
							IF(@IsNewHistory = 0)
							BEGIN

								SET @InvoiceItems = (SELECT Id AS InvoiceItemId
						       ,ItemName AS ItemName
							   ,ItemDescription AS ItemDescription
							   ,Price
							   ,Quantity
							   ,IsNew
							FROM #Items
							FOR XML PATH('InvoiceItemsInputModel'),ROOT('GenericListOfInvoiceItemsInputModel'))

								EXEC [dbo].[USP_InsertInvoiceHistory] @InvoiceId = @InvoiceId, @InvoiceItems = @InvoiceItems, @OperationsPerformedBy= @OperationsPerformedBy, @IsInvoiceFields = 0

							END

							INSERT INTO [dbo].[InvoiceHistory]([Id], [InvoiceId], [InvoiceItemId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @InvoiceId, Id, NULL, ItemName, 'InvoiceItemRemoved', @CurrentDate, @OperationsPerformedBy
								FROM InvoiceItem_New WHERE InvoiceId = @InvoiceId AND Id NOT IN (SELECT Id FROM #Items WHERE IsNew = 0)

							UPDATE [InvoiceItem_New] SET InactiveDateTime = @Currentdate,
														 UpdatedByUserId = @OperationsPerformedBy,
														 UpdatedDateTime = @Currentdate
									WHERE InvoiceId = @InvoiceId AND Id NOT IN (SELECT Id FROM #ITEMS WHERE IsNew = 0)

							UPDATE [InvoiceItem_New] SET ItemName = I.ItemName,
											  ItemDescription = I.ItemDescription,
											  Price = I.Price,
											  Quantity = I.Quantity,
											  [Order] = I.[Order],
											  UpdatedByUserId = @OperationsPerformedBy,
											  UpdatedDateTime = @Currentdate
							FROM [InvoiceItem_New] IIN
								INNER JOIN #Items I ON I.Id = IIN.Id


						INSERT INTO [dbo].[InvoiceItem_New](
									[Id],
									[InvoiceId],
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
								@InvoiceId,
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
					IF(@InvoiceGoals IS NOT NULL)
					BEGIN

						CREATE TABLE #Goals(
							Id UNIQUEIDENTIFIER,
							GoalId UNIQUEIDENTIFIER,
							IsArchived BIT,
							UpdatedDateTime DATETIME,
							UpdatedByUserId UNIQUEIDENTIFIER
							)
														
							INSERT INTO #Goals(Id, GoalId, IsArchived )
							SELECT NEWID(),
							x.value('GoalId[1]','UNIQUEIDENTIFIER') AS GoalId,
							x.value('IsArchived[1]','BIT') 
							FROM @InvoiceGoals.nodes('/GenericListOfInvoiceGoalInputModel/ListItems/InvoiceGoalInputModel') XmlData(x)

							UPDATE #Goals SET UpdatedDateTime = IG.UpdatedDateTime,
											  UpdatedByUserId = IG.UpdatedByUserId

							FROM InvoiceGoals IG 
							INNER JOIN #Goals G ON G.Id = IG.Id				

						INSERT INTO [dbo].[InvoiceGoals](
									Id,
									InvoiceId,
									GoalId,									
									CreatedByUserId,
									CreatedDateTime,
									InactiveDateTime
									)

						SELECT	G.Id,
								@InvoiceId,
								G.GoalId,								
								@OperationsPerformedBy,
								@Currentdate,
								CASE WHEN G.IsArchived = 1 THEN @Currentdate ELSE NULL END

						FROM #Goals G LEFT JOIN [InvoiceGoals] IG ON IG.Id = G.Id

						UPDATE [InvoiceGoals]
						   SET InvoiceId = @InvoiceId, 
							   GoalId = G.GoalId,				
							   UpdatedByUserId = @OperationsPerformedBy,
							   UpdatedDateTime = @Currentdate,
							   InactiveDateTime = CASE WHEN G.IsArchived = 1 THEN @Currentdate ELSE NULL END

						FROM #Goals G
						INNER JOIN [InvoiceGoals] IG ON IG.Id = G.Id AND IG.Id <> G.Id 

						END
						IF(@InvoiceProjects IS NOT NULL)
						BEGIN

							CREATE TABLE #Projects(
								Id UNIQUEIDENTIFIER,
								ProjectId UNIQUEIDENTIFIER,
								IsArchived BIT,
								UpdatedDateTime DATETIME,
								UpdatedByUserId UNIQUEIDENTIFIER
								)
														
								INSERT INTO #Projects(Id, ProjectId, IsArchived )
								SELECT NEWID(),
								x.value('ProjectId[1]','UNIQUEIDENTIFIER') AS ProjectId,
								x.value('IsArchived[1]','BIT') 
								FROM @InvoiceProjects.nodes('/GenericListOfInvoiceProjectsInputModel/ListItems/InvoiceProjectsInputModel') XmlData(x)

								UPDATE #Projects SET UpdatedDateTime = IP.UpdatedDateTime,
													 UpdatedByUserId = IP.UpdatedByUserId

								FROM InvoiceProjects IP 
								INNER JOIN #Projects P ON P.Id = IP.Id
						
							INSERT INTO [dbo].[InvoiceProjects](
										Id,
										InvoiceId,
										ProjectId,									
										CreatedByUserId,
										CreatedDateTime,
										InActiveDateTime
										)	

							SELECT	P.Id,
									@InvoiceId,
									P.ProjectId,								
									@OperationsPerformedBy,
									@Currentdate,
									CASE WHEN P.IsArchived = 1 THEN @Currentdate ELSE NULL END

							FROM #Projects P LEFT JOIN [InvoiceProjects] IP ON IP.Id = P.Id
							
							UPDATE [InvoiceProjects]
							   SET InvoiceId = @InvoiceId,
								   ProjectId = P.ProjectId,			
								   UpdatedByUserId = @OperationsPerformedBy,
								   UpdatedDateTime = @Currentdate,
								   InActiveDateTime = CASE WHEN P.IsArchived = 1 THEN @Currentdate ELSE NULL END
						
							FROM #Projects P
							INNER JOIN [InvoiceProjects] IP ON IP.Id = P.Id AND IP.Id <> P.Id

						END
						IF(@InvoiceTax IS NOT NULL)
						BEGIN

							CREATE TABLE #Tax(
								Id UNIQUEIDENTIFIER,
								Tax NUMERIC(10,5),
								IsArchived BIT,
								UpdatedDateTime DATETIME,
								UpdatedByUserId UNIQUEIDENTIFIER
								)
														
								INSERT INTO #Tax(Id, Tax, IsArchived )
								SELECT NEWID(),
								x.value('Tax[1]','NUMERIC') AS Tax,
								x.value('IsArchived[1]','BIT') 
								FROM @InvoiceTax.nodes('/GenericListOfInvoiceTaxInputModel/ListItems/InvoiceTaxInputModel') XmlData(x)

								UPDATE #Tax SET UpdatedDateTime = IX.UpdatedDateTime,
												UpdatedByUserId = IX.UpdatedByUserId
								FROM InvoiceTax IX
								INNER JOIN #Tax X ON X.Id = IX.Id
						
							INSERT INTO [dbo].[InvoiceTax](
										Id,
										InvoiceId,
										Tax,									
										CreatedByUserId,
										CreatedDateTime,
										InActiveDateTime
										)	

							SELECT	X.Id,
									@InvoiceId,
									X.Tax,								
									@OperationsPerformedBy,
									@Currentdate,
									CASE WHEN X.IsArchived = 1 THEN @Currentdate ELSE NULL END

							FROM #Tax X LEFT JOIN [InvoiceTax] IX ON IX.Id = X.Id
							
							UPDATE [InvoiceTax]
							   SET InvoiceId = @InvoiceId,
								   Tax = X.Tax,				
								   UpdatedByUserId = @OperationsPerformedBy,
								   UpdatedDateTime = @Currentdate,
								   InActiveDateTime = CASE WHEN X.IsArchived = 1 THEN @Currentdate ELSE NULL END
	
							FROM #Tax X
							INNER JOIN [InvoiceTax] IX ON IX.Id = X.Id AND IX.Id <> X.Id

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

