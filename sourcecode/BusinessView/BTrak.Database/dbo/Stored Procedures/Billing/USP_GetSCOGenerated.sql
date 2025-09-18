CREATE PROCEDURE [dbo].[USP_GetSCOGenerated]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @IsArchived BIT = NULL,
	 @IsScoAccepted BIT = NULL,
	 @Id UNIQUEIDENTIFIER = NULL,
	 @LeadSubmissionId UNIQUEIDENTIFIER = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  ='1'

         IF (@HavePermission = '1')
         BEGIN
 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
              SELECT  S.Id,
              S.LeadSubmissionId,
              S.[CreditsAllocated],
              S.[ClientId],
              S.[Comments],
              S.[IsScoAccepted],
              S.[TimeStamp],
              MC.ContractNumber,
              CLS.UniqueLeadId,
              S.[UniqueScoId],
              S.[CreatedDateTime] AS ScoDate,
              SPU.FirstName+' '+SPU.SurName AS SalesPersonName,
              BU.FirstName+' '+BU.SurName AS BuyerName,
              P.Id AS ProductId,
              P.[Name] AS ProductName,
              G.Id AS GradeId,
              G.GradeName,
              CLS.VehicleNumberOfTransporter,
              CLS.MobileNumberOfTruckDriver,
              CLS.QuantityInMT,
              CLS.Drums,
              CLS.BLNumber,
              CLS.RateGst,
              PT.Id AS PaymentTypeId,
              PT.[PaymentTermName],
              PD.Id AS PortId,
              PD.[Name] AS PortName,
			  CASE WHEN S.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
			  S.CreatedDateTime,
			  BU.UserName AS Email,
              S.CompanyId,
              BU.Id AS UserId,
              CLS.TermsOfDelivery,
              CN.CountryName AS CountryOfOrigin,
              CLS.ShipmentMonth,
              CLS.CustomPoint,
              G.GstCode,
              CLS.DeliveryNote,
              CLS.InvoiceNumber,
              CLS.SuppliersRef,
              C.[AddressLine1],
			  C.[AddressLine2],
			  C.PanNumber,
			  C.BusinessEmail,
			  C.BusinessNumber,
			  C.EximCode,
              S.[Timestamp],
              ISNULL(C.AddressLine1,'')+', '+ISNULL(C.AddressLine2,'')+ ', '+ISNULL(C.BusinessNumber,'') AS ShipToAddress,
		      C.GstNumber,
              TotalCount = COUNT(1) OVER()
            FROM SCOGenerations S
				 INNER JOIN LeadContactSubmissions CLS ON CLS.Id = S.LeadSubmissionId AND S.InActiveDatetime IS NULL
                 INNER JOIN [User] SPU ON SPU.Id = CLS.SalesPersonId AND SPU.InActiveDateTime IS NULL
                 INNER JOIN Client C ON C.Id = CLS.ClientId
                 INNER JOIN [User] BU ON BU.Id = C.UserId AND BU.InActiveDateTime IS NULL
                 LEFT JOIN MasterContract MC ON MC.Id = CLS.ContractId
                 LEFT JOIN [MasterProduct] P ON P.Id=CLS.ProductId
                 LEFT JOIN [PortDetails] PD ON PD.Id = CLS.PortId
                 LEFT JOIN [PaymentTerms] PT ON PT.Id = CLS.PaymentTypeId
                 INNER JOIN [BillingGrade] G ON G.Id=CLS.GradeId
                 LEFT JOIN [Country] CN ON CN.Id = CLS.CountryOriginId
			WHERE S.CompanyId = @CompanyId
            AND (@IsArchived IS NULL OR (@IsArchived = 1 AND S.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND S.InactiveDateTime IS NULL))
            --AND (@IsScoAccepted IS NULL OR (@IsScoAccepted = 1 AND S.IsScoAccepted IS NOT NULL) OR (@IsScoAccepted = 0 AND S.IsScoAccepted IS NULL))
            AND (@Id IS NULL OR (@Id = S.Id))
            AND (@LeadSubmissionId IS NULL OR (S.LeadSubmissionId = @LeadSubmissionId))
            ORDER BY S.CreatedDatetime DESC
 
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