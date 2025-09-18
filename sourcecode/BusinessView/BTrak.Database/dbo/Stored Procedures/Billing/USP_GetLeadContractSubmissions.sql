CREATE PROCEDURE [dbo].[USP_GetLeadContractSubmissions]
(
     @OperationsPerformedBy UNIQUEIDENTIFIER,
	 @IsArchived BIT = NULL,
	 @Id UNIQUEIDENTIFIER = NULL,
     @PageNo INT = 1,
     @PageSize INT = 10,
     @SortDirection NVARCHAR(100) = NULL,
     @SortBy NVARCHAR(100) = NULL,
     @SearchText NVARCHAR(250)  = NULL
)
 AS
 BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
 
         DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

         IF (@HavePermission = '1')
         BEGIN
         
           IF(@SearchText = '') SET @SearchText = NULL
           SET @SearchText = '%'+ @SearchText +'%';              
           IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
                   
           IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
 
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
              SELECT  LCS.Id,
              LCS.[UniqueLeadId],
              SPU.Id AS SalesPersonId,
              LCS.[LeadDate],
              SPU.FirstName+' '+SPU.SurName AS SalesPersonName,
              LCS.RateGst,
              P.Id AS ProductId,
              P.[Name] AS ProductName,
              G.Id AS GradeId,
              G.GradeName,
              PT.Id AS PaymentTypeId,
              PT.[PaymentTermName],
              PD.Id AS PortId,
              PD.[Name] AS PortName,
              LCS.[QuantityInMT],
              LCS.[VehicleNumberOfTransporter],
              LCS.[MobileNumberOfTruckDriver],
              LCS.[Drums],
              LCS.[BLNumber],
              LCS.[CustomPoint],
              LS.Id AS StatusId,
              LS.[Name] AS StatusName,
              LS.[Color] AS StatusColor,
              LCS.[ShipmentMonth],
              C.Id AS CountryOriginId,
              C.CountryName,
              MC.ContractNumber,
              MC.ContractDateFrom,
              MC.ContractDateTo,
              MC.ContractQuantity,
              MC.RemaningQuantity,
              MC.RateOrTon,
              CU.FirstName+' '+CU.SurName AS BuyerName,
              CU.UserName AS BuyerEmail,
              CU.MobileNo,
              CO.CountryCode,
              LCS.[TimeStamp],
              LCS.IsClosed,
			  LCS.ClientId AS BuyerId,
              --CASE WHEN (SG.Id IS NULL)OR(SG.Id IS NOT NULL AND SG.InActiveDateTime IS NULL)AND(SG.IsScoAccepted!=1) THEN 0 ELSE 1 END AS IsScoAccepted,
              CASE WHEN (SG.Id IS NOT NULL AND SG.InActiveDateTime IS NULL)AND(SG.IsScoAccepted!=1) THEN 0 ELSE 1 END AS IsSCOActive,
              SG.IsScoAccepted,
              LCS.PortId,
              CASE WHEN CC.KycFormData IS NULL THEN 0 ELSE 1 END KycCompleted,
              CC.[AvailableCreditLimit],
              CC.GstNumber AS GstNumber,
			  CASE WHEN LCS.InactiveDateTime IS NOT NULL THEN 1 ELSE 0 END IsArchived,
              LCS.ContractId,
                ISNULL(CC.AddressLine1,'')+', '+ISNULL(CC.AddressLine2,'')+ ', '+ISNULL(CC.BusinessNumber,'') AS ShipToAddress,
                LI.PaidAmount AS PaidInvoiceAmount,
                LI.InvoiceNumber,
                LCS.QuantityInMT*LCS.RateGST AS TotalInvoiceAmount,
                LCS.TermsOfDelivery,
              LCS.DeliveryNote,
              LCS.InvoiceNumber AS PerformaInvoiceNumber,
              LCS.SuppliersRef,
              LCS.WeighingSlipDate,
              LCS.FinalQuantityInMT,
              LCS.FinalVehicleNumberOfTransporter,
              LCS.FinalMobileNumberOfTruckDriver,
              LCS.FinalPortId,
              LCS.FinalDrums,
              LCS.FinalBLNumber,
              LCS.WeighingSlipNumber,
              LCS.WeighingSlipPhoto,
              LCS.UploadedOther,
              LCS.WhUpdatedUserId,
              LCS.WhUpdatedDateTime,
              FPD.[Name] AS FinalPortName,
              SG.PerformaPdf,
              SG.ScoPdf,
              LCS.ExceptionApprovalRequired,
              TotalCount = COUNT(1) OVER()
            FROM LeadContactSubmissions LCS
            INNER JOIN Client CC ON CC.Id = LCS.ClientId
            INNER JOIN [User] CU ON CU.Id = CC.UserId
            LEFT JOIN MasterContract MC ON MC.Id = LCS.ContractId
            INNER JOIN [User] SPU ON SPU.Id = LCS.SalesPersonId AND SPU.InActiveDateTime IS NULL
            INNER JOIN MasterProduct P ON P.Id=LCS.ProductId
            INNER JOIN [BillingGrade] G ON G.Id=LCS.GradeId
            LEFT JOIN [PortDetails] PD ON PD.Id = LCS.PortId
            LEFT JOIN [PortDetails] FPD ON FPD.Id = LCS.FinalPortId
            LEFT JOIN [PaymentTerms] PT ON PT.Id = LCS.PaymentTypeId
            INNER JOIN LeadStages LS ON LS.Id = LCS.StatusId AND LS.InactiveDateTime IS NULL
            LEFT JOIN Country C ON C.Id = LCS.CountryOriginId AND C.InActiveDateTime IS NULL
            INNER JOIN [ClientAddress] CA ON CA.ClientId = LCS.ClientId
            LEFT JOIN Country CO ON CO.Id = CA.CountryId 
            LEFT JOIN SCOGenerations SG ON SG.LeadSubmissionId=LCS.Id AND SG.InActiveDateTime IS NULL
            LEFT JOIN LeadInvoices LI ON LI.LeadId=LCS.Id
			WHERE LCS.CompanyId = @CompanyId
            AND (@IsArchived IS NULL OR (@IsArchived = 1 AND LCS.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND LCS.InactiveDateTime IS NULL))
            AND (@Id IS NULL OR (@Id = LCS.Id))
            AND ((@SearchText IS NULL OR (LCS.uniqueLeadId LIKE  @SearchText)) OR
			    (@SearchText IS NULL OR (LCS.[LeadDate] LIKE @SearchText)) OR
				(@SearchText IS NULL OR (MC.contractNumber LIKE @SearchText)) OR
				(@SearchText IS NULL OR (MC.contractQuantity LIKE @SearchText)) OR
				(@SearchText IS NULL OR (CU.FirstName+' '+CU.SurName LIKE @SearchText)) OR
				(@SearchText IS NULL OR (P.[Name] LIKE @SearchText)) OR
				(@SearchText IS NULL OR (G.gradeName LIKE @SearchText)) OR
				(@SearchText IS NULL OR (LCS.quantityInMT LIKE @SearchText)) OR
			       (@SearchText IS NULL OR (MC.rateOrTon*MC.contractQuantity LIKE  @SearchText)))

		   ORDER BY
                          CASE WHEN( @SortDirection= 'ASC' OR @SortDirection IS NULL ) THEN
                               CASE 
                                    WHEN @SortBy = 'UniqueLeadId' THEN LCS.UniqueLeadId
                                    WHEN @SortBy = 'LeadDate' THEN CAST(LCS.[LeadDate] AS SQL_VARIANT)
                                    WHEN @SortBy = 'contractNumber' THEN MC.contractNumber
                                    WHEN @SortBy = 'contractQuantity' THEN  MC.contractQuantity
                                    WHEN @SortBy = 'buyerName' THEN  CU.FirstName+' '+CU.SurName
                                    WHEN @SortBy = 'productName' THEN P.[Name]
									WHEN @SortBy = 'gradeName' THEN G.gradeName
									WHEN @SortBy = 'quantityInMT' THEN  LCS.quantityInMT
                                    WHEN @SortBy = 'rateOrTon' THEN  MC.rateOrTon*MC.contractQuantity
                                    WHEN @SortBy = 'CreatedDateTime' THEN CAST(LCS.CreatedDateTime AS SQL_VARIANT)
                                    WHEN @SortBy = 'statusName' THEN LS.[Name]
                                END
                            END ASC,
                            CASE WHEN @SortDirection = 'DESC' THEN
                                 CASE 
                                    WHEN @SortBy = 'UniqueLeadId' THEN LCS.UniqueLeadId
                                    WHEN @SortBy = 'LeadDate' THEN CAST(LCS.[LeadDate] AS SQL_VARIANT)
                                    WHEN @SortBy = 'contractNumber' THEN MC.contractNumber
                                    WHEN @SortBy = 'contractQuantity' THEN  MC.contractQuantity
                                    WHEN @SortBy = 'buyerName' THEN  CU.FirstName+' '+CU.SurName
                                    WHEN @SortBy = 'productName' THEN P.[Name]
									WHEN @SortBy = 'gradeName' THEN G.gradeName
									WHEN @SortBy = 'quantityInMT' THEN  LCS.quantityInMT
                                    WHEN @SortBy = 'rateOrTon' THEN  MC.rateOrTon*MC.contractQuantity
                                    WHEN @SortBy = 'CreatedDateTime' THEN CAST(LCS.CreatedDateTime AS SQL_VARIANT)
                                    WHEN @SortBy = 'statusName' THEN LS.[Name]
                                   END
                             END DESC
			  
	  OFFSET ((@PageNo - 1) * @PageSize) ROWS

        FETCH NEXT @PageSize ROWS ONLY
 
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
