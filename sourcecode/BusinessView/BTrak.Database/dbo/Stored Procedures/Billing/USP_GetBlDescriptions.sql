CREATE PROCEDURE [dbo].[USP_GetBlDescriptions]
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

								SELECT  (SELECT DD.[Description],
													DD.ReferenceTypeId,
													DD.Id,
													DD.OrderNumber
                                                   FROM DocumentsDescription DD
                                             WHERE DD.ReferenceTypeId = PSB.Id AND DD.InActiveDateTime IS NULL AND DD.ReferenceId='1912F3AC-5BAA-4EDC-894D-10103F96AF58'
											 GROUP BY DD.Id,DD.[Description],DD.ReferenceId,DD.ReferenceTypeId,DD.OrderNumber
                                             ORDER BY DD.OrderNumber ASC
                                             FOR XML PATH('InitialDocumentsDescription'), ROOT('InitialDocumentsDescription'), TYPE) AS InitialDocumentsDescriptionXml
											 ,(SELECT DD.[Description],
													DD.ReferenceTypeId,
													DD.Id,
													DD.OrderNumber
                                                   FROM DocumentsDescription DD
                                             WHERE DD.ReferenceTypeId = PSB.Id AND DD.InActiveDateTime IS NULL AND DD.ReferenceId='8A3E9EDC-A5F1-42D5-896E-AF1FFAF04A02'
											 GROUP BY DD.Id,DD.[Description],DD.ReferenceId,DD.ReferenceTypeId,DD.OrderNumber
                                             ORDER BY DD.OrderNumber Asc
                                             FOR XML PATH('InitialDocumentsDescription'), ROOT('FinalDocumentsDescription'), TYPE) AS FinalDocumentsDescriptionXml
			 FROM [PurchaseShipmentBLs] PSB
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