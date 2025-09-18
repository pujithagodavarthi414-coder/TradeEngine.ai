CREATE PROCEDURE [dbo].[USP_UpsertBlDescription]
(
	@PurchaseExecutionId UNIQUEIDENTIFIER,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@InitialDescriptionsXml XML = NULL,
	@FinalDescriptionsXml XML = NULL,
    @ShipmentBLId UNIQUEIDENTIFIER=NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
			
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
			
			IF (@ShipmentBLId =  '00000000-0000-0000-0000-000000000000') SET @ShipmentBLId = NULL
		
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

						DECLARE @CurrentDate DATETIME = GETDATE()
						IF(@InitialDescriptionsXml IS NOT NULL)
						BEGIN
								CREATE TABLE #InitialDescription        
                                    (						           
                                        Id UNIQUEIDENTIFIER, 
                                        [Description] NVARCHAR(max),
                                        OrderNumber INT,
										DescriptionId UNIQUEIDENTIFIER
                                    )
									INSERT INTO #InitialDescription(Id,[Description],OrderNumber,DescriptionId)
                                    SELECT NEWID(),
                                            [Table].[Column].value('Description[1]', 'nvarchar(Max)'),
                                            [Table].[Column].value('OrderNumber[1]', 'INT'),
                                            IIF([Table].[Column].value('Id[1]', 'nvarchar(2000)')='',NULL,[Table].[Column].value('Id[1]', 'UNIQUEIDENTIFIER'))
                                    FROM @InitialDescriptionsXml.nodes('/ArrayOfInitialDocumentsDescription/InitialDocumentsDescription') AS [Table]([Column])
									UPDATE [DocumentsDescription] 
									         SET UpdatedDateTime   = @Currentdate,
									             UpdatedByUserId   = @OperationsPerformedBy,
									             InActiveDateTime  = @Currentdate
									        WHERE ReferenceId = '1912F3AC-5BAA-4EDC-894D-10103F96AF58' AND Id NOT IN (SELECT DescriptionId FROM #InitialDescription) AND InactiveDateTime IS NULL AND ReferenceTypeId=@ShipmentBLId
									          UPDATE [DocumentsDescription] 
										 SET [ReferenceId]      = '1912F3AC-5BAA-4EDC-894D-10103F96AF58',
										     [ReferenceTypeId]   = @ShipmentBLId,
											 [Description]  = D.[Description],
											 OrderNumber  = D.OrderNumber,
											 UpdatedDateTime = @Currentdate,
											 UpdatedByUserId = @OperationsPerformedBy
											FROM #InitialDescription D
											WHERE [DocumentsDescription].Id  = D.DescriptionId

											INSERT INTO [DocumentsDescription](
                                                        [Id],
                                                        [Description],
                                                        [ReferenceId],
                                                        [ReferenceTypeId],
                                                        OrderNumber,
                                                        CreatedDateTime,
                                                        CreatedByUserId
                                                        )
                                                 SELECT D.Id,
                                                        D.[Description], 
                                                        '1912F3AC-5BAA-4EDC-894D-10103F96AF58',
                                                        @ShipmentBLId,
                                                        D.OrderNumber,
                                                        @Currentdate,
                                                        @OperationsPerformedBy
                                                   FROM #InitialDescription D WHERE D.DescriptionId IS  NULL 
									END
									ELSE
									BEGIN
									UPDATE [DocumentsDescription] 
									         SET UpdatedDateTime   = @Currentdate,
									             UpdatedByUserId   = @OperationsPerformedBy,
									             InActiveDateTime  = @Currentdate
									        WHERE ReferenceId = '1912F3AC-5BAA-4EDC-894D-10103F96AF58' AND InactiveDateTime IS NULL AND ReferenceTypeId=@ShipmentBLId      
									END

									IF(@FinalDescriptionsXml IS NOT NULL)
									BEGIN

									CREATE TABLE #FinalDescription        
                                    (						           
                                        Id UNIQUEIDENTIFIER, 
                                        [Description] NVARCHAR(max),
                                        OrderNumber INT,
										DescriptionId UNIQUEIDENTIFIER
                                    )
                                    
									INSERT INTO #FinalDescription(Id,[Description],OrderNumber,DescriptionId)
                                    SELECT NEWID(),
                                            [Table].[Column].value('Description[1]', 'nvarchar(Max)'),
											[Table].[Column].value('OrderNumber[1]', 'INT'),
                                            IIF([Table].[Column].value('Id[1]', 'nvarchar(2000)')='',NULL,[Table].[Column].value('Id[1]', 'UNIQUEIDENTIFIER'))
                                    FROM @FinalDescriptionsXml.nodes('/ArrayOfInitialDocumentsDescription/InitialDocumentsDescription') AS [Table]([Column])

									UPDATE [DocumentsDescription] 
									         SET UpdatedDateTime   = @Currentdate,
									             UpdatedByUserId   = @OperationsPerformedBy,
									             InActiveDateTime  = @Currentdate
									        WHERE ReferenceId = '8A3E9EDC-A5F1-42D5-896E-AF1FFAF04A02' AND Id NOT IN (SELECT DescriptionId FROM #FinalDescription) AND InactiveDateTime IS NULL AND ReferenceTypeId=@ShipmentBLId
									    
										UPDATE [DocumentsDescription] 
										 SET [ReferenceId]      = '8A3E9EDC-A5F1-42D5-896E-AF1FFAF04A02',
										     [ReferenceTypeId]            = @ShipmentBLId,
											 [Description]  = D.[Description],
											 OrderNumber  = D.OrderNumber,
											 UpdatedDateTime = @Currentdate,
											 UpdatedByUserId = @OperationsPerformedBy
											FROM #FinalDescription D
											WHERE [DocumentsDescription].Id  = D.DescriptionId
  
											INSERT INTO [DocumentsDescription](
                                                        [Id],
                                                        [Description],
                                                        [ReferenceId],
                                                        [ReferenceTypeId],
                                                        OrderNumber,
                                                        CreatedDateTime,
                                                        CreatedByUserId
                                                        )
                                                 SELECT D.Id ,
                                                        D.[Description], 
                                                        '8A3E9EDC-A5F1-42D5-896E-AF1FFAF04A02',
                                                        @ShipmentBLId,
                                                        D.OrderNumber,
                                                        @Currentdate,
                                                        @OperationsPerformedBy
                                                   FROM #FinalDescription D WHERE D.DescriptionId IS  NULL 
END

									ELSE
									BEGIN
									UPDATE [DocumentsDescription] 
									         SET UpdatedDateTime   = @Currentdate,
									             UpdatedByUserId   = @OperationsPerformedBy,
									             InActiveDateTime  = @Currentdate
									         WHERE ReferenceId = '8A3E9EDC-A5F1-42D5-896E-AF1FFAF04A02' AND InactiveDateTime IS NULL AND ReferenceTypeId=@ShipmentBLId
									END
											DECLARE @StatusId UNIQUEIDENTIFIER = NULL
											DECLARE @TotalCount INT = NULL
											DECLARE @TotalBLsCount INT = NULL
											DECLARE @InitialCount INT = NULL
											DECLARE @FinalCount INT = NULL
											DECLARE @DocumentsSentCount INT = NULL
											DECLARE @DraftsCount INT = NULL
											DECLARE @ConfoCount INT = NULL
											DECLARE @PaymentsCount INT = NULL
											SET @PurchaseExecutionId=(SELECT PurchaseExecutionId FROM PurchaseShipmentBLs WHERE Id=@ShipmentBLId)
											SELECT @TotalCount=COUNT(PSB.Id),
													@InitialCount=COUNT(IIF(DD.ReferenceId='1912F3AC-5BAA-4EDC-894D-10103F96AF58',1,NULL)),
													@FinalCount=COUNT(IIF(DD.ReferenceId='8A3E9EDC-A5F1-42D5-896E-AF1FFAF04A02',1,NULL))
											FROM PurchaseShipmentBLs PSB
											LEFT JOIN DocumentsDescription DD ON DD.ReferenceTypeId = PSB.Id 
											WHERE PSB.PurchaseExecutionId=@PurchaseExecutionId AND DD.InactiveDateTime IS NULL
											GROUP BY PSB.Id

											SELECT @TotalBLsCount=COUNT(PSB.Id),
													@PaymentsCount=COUNT(IIF(PSB.ConfoIsPaymentDone=1,1,NULL)),
													@DocumentsSentCount=COUNT(IIF(PSB.IsDocumentsSent=1,1,NULL)),
													@DraftsCount=COUNT(IIF(PSB.DraftBLNumber IS NOT NULL AND PSB.DraftBLNumber != '',1,NULL)),
													@ConfoCount=COUNT(IIF(PSB.ConfoBLNumber IS NOT NULL AND PSB.ConfoBLNumber != '',1,NULL))
											FROM PurchaseShipmentBLs PSB
											WHERE PSB.PurchaseExecutionId=@PurchaseExecutionId
											GROUP BY PSB.Id
											IF(@TotalBLsCount=@PaymentsCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Payment Done' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalBLsCount=@ConfoCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Final BOE' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalBLsCount=@DraftsCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Initial BOE' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalBLsCount=@DocumentsSentCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Details sent to CHA' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalCount=@FinalCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Final Doc' AND CompanyId = @CompanyId)
											END
											ELSE IF(@TotalCount=@InitialCount)
											BEGIN
												SET @StatusId=(SELECT Id FROM PurchaseExecutionStatus WHERE [Name]='Initial Doc' AND CompanyId = @CompanyId)
											END
											IF(@StatusId IS NOT NULL)
											BEGIN
												UPDATE [PurchaseShipmentExecutions] SET StatusId = @StatusId WHERE Id=@PurchaseExecutionId
											END
								
		END
		ELSE
			   
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO