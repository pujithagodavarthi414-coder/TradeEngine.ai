CREATE PROCEDURE [dbo].[USP_GetSCOGenerationById]
(
	 @LeadSubmissionId UNIQUEIDENTIFIER = NULL,
	 @ScoId UNIQUEIDENTIFIER = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  ='1'

         IF (@HavePermission = '1')
         BEGIN
            
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
              C.GstNumber AS GstNumber,
              ISNULL(C.AddressLine1,'')+', '+ISNULL(C.AddressLine2,'')+ ', '+ISNULL(C.BusinessNumber,'') AS ShipToAddress,
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
              C.CompanyName,
              TotalCount = COUNT(1) OVER()
            FROM SCOGenerations S
				 Left JOIN LeadContactSubmissions CLS ON CLS.Id = S.LeadSubmissionId --AND S.InActiveDatetime IS NULL
                 LEFT JOIN [User] SPU ON SPU.Id = CLS.SalesPersonId AND SPU.InActiveDateTime IS NULL
                 LEFT JOIN Client C ON C.Id = CLS.ClientId
                 LEFT JOIN [User] BU ON BU.Id = C.UserId AND BU.InActiveDateTime IS NULL
                 LEFT JOIN MasterContract MC ON MC.Id = CLS.ContractId
                 LEFT JOIN [MasterProduct] P ON P.Id=CLS.ProductId
                 LEFT JOIN [PortDetails] PD ON PD.Id = CLS.PortId
                 LEFT JOIN [PaymentTerms] PT ON PT.Id = CLS.PaymentTypeId
                 LEFT JOIN [BillingGrade] G ON G.Id=CLS.GradeId
                 LEFT JOIN [Country] CN ON CN.Id = CLS.CountryOriginId
			WHERE S.CompanyId = CLS.CompanyId
            AND (@LeadSubmissionId IS NULL OR (S.LeadSubmissionId = @LeadSubmissionId))
			AND (@ScoId IS NULL OR (S.Id = @ScoId))
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