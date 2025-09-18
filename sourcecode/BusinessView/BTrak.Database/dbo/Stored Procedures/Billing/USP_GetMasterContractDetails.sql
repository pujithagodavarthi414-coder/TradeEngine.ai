CREATE PROCEDURE [dbo].[USP_GetMasterContractDetails]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ClientId UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @PageNo INT = 1,
    @PageSize INT = 10,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection NVARCHAR(50) = NULL,
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
           IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
                   
           IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
           
           IF(@IsArchived IS NULL) SET @IsArchived = 0
           IF(@ClientId = '00000000-0000-0000-0000-000000000000') SET @ClientId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       

		    SELECT   C.Id AS ContractId,
					 C.[ContractName],
					 C.[ClientId] AS BuyerId,
					 C.ClientId,
					 C.[ContractUniqueName],
					 C.[ProductId],
					 C.[GradeId],
					 C.[RateOrTon],
					 C.[ContractQuantity],
					 C.[UsedQuantity],
					 C.[RemaningQuantity],
					 C.[TimeStamp],
					 C.[CreatedDateTime],
					 C.[CreatedByUserId],
					 C.[UpdatedDateTime],
					 C.[UpdatedDateTimeZone],
					 C.[UpdatedByUserId],
					 C.[ContractDocument],
					 C.[ContractDateFrom],
					 C.[ContractDateTo],
					 G.GradeName AS Grade,
					 P.[Name] AS Product,
					CONCAT(U.FirstName ,' ',U.SurName) CounterParty,
					C.ContractNumber,
			 C.Id AS ContractId,
			 CC.AvailableCreditLimit,
             ISNULL(CC.AddressLine1,'')+', '+ISNULL(CC.AddressLine2,'')+ ', '+ISNULL(CC.BusinessNumber,'') AS ShipToAddress,
			  CC.GstNumber AS GstNumber,
			 CASE WHEN CC.KycFormData IS NULL THEN 0 ELSE 1 END KYCCompleted,
			 Receipts = STUFF(( SELECT  ',' + Convert(nvarchar(1000),UF.FilePath)[text()]
						                                      FROM [UploadFile] UF
						                                      INNER JOIN MasterContract MC1 ON UF.ReferenceId = MC1.Id
						                                      WHERE MC1.Id = C.Id AND UF.InActiveDateTime IS NULL
						                                      AND MC1.CompanyId = @CompanyId
																FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
			 TotalCount = COUNT(1) OVER()
			 FROM MasterContract AS C
			   LEFT JOIN BillingGrade G On G.Id = C.GradeId
			   LEFT JOIN MasterProduct P On P.Id = C.ProductId
			   LEFT JOIN Client CC ON CC.Id = C.CLientId
			   LEFT JOIN [User] U ON U.Id = CC.UserId
			   LEFT JOIN [ClientAddress] CA ON CA.ClientId = C.CLientId
           WHERE C.CompanyId = @CompanyId AND CC.InactiveDateTime IS NULL  
		   AND P.InactiveDateTime IS NULL AND G.InactiveDateTime IS NULL 
		   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InactiveDateTime IS NULL))
		   AND ((@SearchText IS NULL OR (U.SurName LIKE  @SearchText)) OR
			    (@SearchText IS NULL OR (C.[ContractName] LIKE  @SearchText)) OR 
			    (@SearchText IS NULL OR (G.GradeName LIKE @SearchText)) OR
				(@SearchText IS NULL OR (P.[Name] LIKE @SearchText)) OR
				(@SearchText IS NULL OR (C.UsedQuantity LIKE @SearchText)) OR
				(@SearchText IS NULL OR (C.RemaningQuantity LIKE @SearchText)) OR
				(@SearchText IS NULL OR (C.ContractQuantity LIKE @SearchText)) OR
				(@SearchText IS NULL OR (C.ContractDateFrom LIKE @SearchText)) OR
				(@SearchText IS NULL OR (C.ContractDateTo LIKE @SearchText)) OR
			       (@SearchText IS NULL OR (C.ContractNumber LIKE  @SearchText)))

		   ORDER BY
                          CASE WHEN( @SortDirection= 'ASC' OR @SortDirection IS NULL ) THEN
                               CASE 
                                    WHEN @SortBy = 'contractNumber' THEN C.ContractNumber
                                    WHEN @SortBy = 'counterParty' THEN CONCAT(U.FirstName ,' ',U.SurName)
                                    WHEN @SortBy = 'product' THEN P.[Name]
                                    WHEN @SortBy = 'grade' THEN  G.GradeName
                                    WHEN @SortBy = 'rateOrTon' THEN  C.[RateOrTon]
                                    WHEN @SortBy = 'contractQuantity' THEN C.ContractQuantity
									WHEN @SortBy = 'usedQuantity' THEN C.usedQuantity
									WHEN @SortBy = 'remaningQuantity' THEN  C.remaningQuantity
                                    WHEN @SortBy = 'contractDateFrom' THEN  CAST(C.contractDateFrom AS SQL_VARIANT)
                                    WHEN @SortBy = 'contractDateTo' THEN  CAST(C.contractDateTo AS SQL_VARIANT)
									WHEN @SortBy = 'CreatedDateTime' THEN CAST(C.CreatedDateTime AS SQL_VARIANT)
                                END
                            END ASC,
                            CASE WHEN @SortDirection = 'DESC' THEN
                                 CASE  WHEN @SortBy = 'contractNumber' THEN C.ContractNumber
                                    WHEN @SortBy = 'counterParty' THEN CONCAT(U.FirstName ,' ',U.SurName)
                                    WHEN @SortBy = 'product' THEN P.[Name]
                                    WHEN @SortBy = 'grade' THEN  G.GradeName
                                    WHEN @SortBy = 'rateOrTon' THEN  C.[RateOrTon]
                                    WHEN @SortBy = 'contractQuantity' THEN C.ContractQuantity
									WHEN @SortBy = 'usedQuantity' THEN C.usedQuantity
									WHEN @SortBy = 'remaningQuantity' THEN  C.remaningQuantity
                                    WHEN @SortBy = 'contractDateFrom' THEN  CAST(C.contractDateFrom AS SQL_VARIANT)
                                    WHEN @SortBy = 'contractDateTo' THEN  CAST(C.contractDateTo AS SQL_VARIANT)
									WHEN @SortBy = 'CreatedDateTime' THEN CAST(C.CreatedDateTime AS SQL_VARIANT)
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