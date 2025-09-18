CREATE PROCEDURE [dbo].[USP_GetPurchaseShipmentExecutionBLById]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @PurchaseShipmentBLId UNIQUEIDENTIFIER
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       

									SELECT  PSB.Id AS ShipmentBLId,
											PSB.PurchaseExecutionId as PurchaseShipmentId,
											PSB.Id AS ShipmentBLId
							    			 ,PSB.[CompanyId]
											 ,PSB.BLNumber
											 ,PSB.BLDate
											 ,PSB.BLQuantity
											 ,PSB.ConsignerId
											 ,PSB.ConsigneeId
											 ,PSB.NotifyParty
											 ,PSB.PackingDetails
											 ,PSB.IsDocumentsSent
											 ,PSB.SentDate
											 ,PSB.DraftEntryDate
											 ,PSB.DraftBLNumber
											 ,PSB.DraftBLDescription
											 ,PSB.DraftBasicCustomsDuty
											 ,PSB.DraftSWC
											 ,PSB.DraftIGST
											 ,PSB.DraftEduCess
											 ,PSB.DraftOthers
											 ,PSB.ConfoEntryDate
											 ,PSB.ConfoBLNumber
											 ,PSB.ConfoBLDescription
											 ,PSB.ConfoBasicCustomsDuty
											 ,PSB.ConfoSWC
											 ,PSB.ConfoIGST
											 ,PSB.ConfoEduCess
											 ,PSB.ConfoOthers
											 ,PSB.IsConfirmedBill
											 ,PSB.ConfirmationDate
											 ,PSB.ConfoIsPaymentDone
											 ,PSB.ConfoPaymentDate
											 ,CE.Name AS Consignee
											 ,CR.Name AS Consigner
											 ,PSE.ShipmentNumber
											 ,PSE.VoyageNumber
											 ,V.VesselName
											 ,P.[Name] AS Product
											 ,G.[GradeName] AS Grade
											 ,PSE.ETADate
											 ,PDL.[Name] AS LoadName
											 ,PDD.[Name] AS DischargeName
											 ,C.Price
											 ,PSB.[TimeStamp]
											 ,PSB.ChaId
			 ,TotalCount = COUNT(1) OVER()
			 FROM [PurchaseShipmentBLs] PSB
				INNER JOIN PurchaseShipmentExecutions AS PSE ON PSE.Id=PSB.PurchaseExecutionId
				INNER JOIN PortDetails AS PDL ON PDL.Id=PSE.PortLoadId
				INNER JOIN PortDetails AS PDD ON PDD.Id=PSE.PortDischargeId
				INNER JOIN [PurchaseContracts] AS C ON C.Id=PSE.ContractId
				LEFT JOIN Consignee AS CE ON CE.Id=PSB.ConsigneeId
				LEFT JOIN Consigner AS CR ON CR.Id=PSB.ConsignerId
			    LEFT JOIN BillingGrade G On G.Id = C.GradeId
			    LEFT JOIN MasterProduct P On P.Id = C.ProductId
				LEFT JOIN Vessel V ON V.Id = PSE.VesselId
	           WHERE PSB.CompanyId = @CompanyId AND PSB.Id=@PurchaseShipmentBLId

		   ORDER BY PSB.CreatedDateTime DESC
				
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