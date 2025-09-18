CREATE PROCEDURE [dbo].[USP_GetPurchaseShipmentExecutionBLs]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @PurchaseShipmentId UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
           IF(@SearchText = '') SET @SearchText = NULL
           SET @SearchText = '%'+ @SearchText +'%';              
           
           IF(@IsArchived IS NULL) SET @IsArchived = 0
           IF(@PurchaseShipmentId = '00000000-0000-0000-0000-000000000000') SET @PurchaseShipmentId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       

									SELECT  
											PSB.PurchaseExecutionId as PurchaseShipmentId
											,PSB.Id AS ShipmentBLId
							    			 ,PSB.[CompanyId]
											 ,PSB.BLNumber
											 ,PSB.BLDate
											 ,PSB.BLQuantity
											 ,PSB.ChaId
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
											  ,Receipts = STUFF(( SELECT  ',' + Convert(nvarchar(1000),UF.FilePath)[text()]
						                                      FROM [UploadFile] UF
															  JOIN DocumentsDescription DD On DD.Id = Uf.ReferenceId 
						                                      WHERE DD.ReferenceTypeId = PSB.Id AND UF.InActiveDateTime IS NULL
																FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
											 	 ,PSB.[TimeStamp]
											,FooterMailAddress = (SELECT [Value] FROM CompanySettings WHERE CompanyId = @CompanyId AND [KEY] = 'MailFooterAddress')
									,TotalCount = COUNT(1) OVER()
								FROM [PurchaseShipmentBLs] PSB
			 LEFT JOIN Consignee CE ON CE.Id = PSB.ConsigneeId
			 LEFT JOIN Consigner CR ON CR.Id = PSB.ConsignerId
           WHERE PSB.CompanyId = @CompanyId AND PSB.PurchaseExecutionId=@PurchaseShipmentId
		   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND PSB.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND PSB.InactiveDateTime IS NULL))
		   AND ((@SearchText IS NULL OR (CE.Name LIKE  @SearchText)) OR
			       (@SearchText IS NULL OR (CR.Name LIKE  @SearchText)) OR 
			       (@SearchText IS NULL OR (PSB.BLNumber LIKE @SearchText)) OR
				   (@SearchText IS NULL OR (PSB.NotifyParty LIKE @SearchText)) OR
				   (@SearchText IS NULL OR ((CONCAT(FORMAT(BLDate,'dd'),'-', CAST(DATENAME(month, BLDate) AS CHAR(3)),'-',FORMAT(BLDate,'yyyy')))  LIKE @SearchText)) OR
				   (@SearchText IS NULL OR (PSB.BLQuantity LIKE @SearchText)) OR
			       (@SearchText IS NULL OR (PSB.PackingDetails LIKE  @SearchText)))
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