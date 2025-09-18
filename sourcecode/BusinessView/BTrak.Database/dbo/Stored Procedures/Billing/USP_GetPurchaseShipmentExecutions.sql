CREATE PROCEDURE [dbo].[USP_GetPurchaseShipmentExecutions]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @PurchaseShipmentId UNIQUEIDENTIFIER = NULL,
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
           IF(@PurchaseShipmentId = '00000000-0000-0000-0000-000000000000') SET @PurchaseShipmentId = NULL
           DECLARE @BLQuantity DECIMAL(18,2) = (SELECT SUM(BLQuantity) FROM PurchaseShipmentBLs WHERE PurchaseExecutionId=@PurchaseShipmentId AND InactiveDateTime IS NULL)
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
		    SELECT   PSE.Id AS PurchaseShipmentId
					,PSE.[ContractId]		
					,PSE.[ShipmentNumber]	
					,PSE.[ShipmentQuantity]
					,@BLQuantity AS BLQuantity
					,PSE.VesselId		
					,PSE.PortLoadId		
					,PSE.[PortDischargeId]	
					,PSE.[WorkEmployeeId]	
					,PSE.[ETADate]			
					,PSE.[FillDueDate]
					,PSE.[VoyageNumber]
					,PDL.Id AS PortLoadId
					,PDD.Id AS PortDischargeId
					,PDD.[Name] AS PortDischargeName
					,PDL.[Name] AS PortLoadName
					,G.GradeName AS Grade
					,P.[Name] AS Product
					,CONCAT(U.FirstName ,' ',U.SurName) CounterParty
					,PC.TotalQuantity
					,PC.Price
					,PC.[StartDate] AS ContractDateFrom
					,PC.EndDate AS ContractDateTo
					,PSE.StatusId
					,PES.[Name] AS StatusName
					,PES.[Color]
					,(SELECT COUNT(1)  FROM PurchaseShipmentBLs WHERE PurchaseExecutionId=PSE.Id AND InactiveDateTime IS NULL) AS BlsCount
					,PSE.[TimeStamp]
					,V.[VesselName]
					,PSE.WorkEmployeeId
					,PC.ContractNumber
			 ,TotalCount = COUNT(1) OVER()
			 FROM [PurchaseShipmentExecutions] AS PSE
			 INNER JOIN PurchaseContracts AS PC ON PC.Id=PSE.ContractId
			 INNER JOIN PurchaseExecutionStatus AS PES ON PES.Id=PSE.StatusId
			 INNER JOIN PortDetails AS PDL ON PDL.Id=PSE.PortLoadId
			 INNER JOIN PortDetails AS PDD ON PDD.Id=PSE.PortDischargeId
			 LEFT JOIN Vessel AS V ON V.Id = PSE.VesselId
			   LEFT JOIN BillingGrade G On G.Id = PC.GradeId
			   LEFT JOIN MasterProduct P On P.Id = PC.ProductId
			   LEFT JOIN Client CC ON CC.Id = PC.CLientId
			   LEFT JOIN [User] U ON U.Id = CC.UserId
           WHERE PSE.CompanyId = @CompanyId AND CC.InactiveDateTime IS NULL
		   AND (@PurchaseShipmentId IS NULL OR PSE.Id = @PurchaseShipmentId)
		   AND PSE.InactiveDateTime IS NULL AND G.InactiveDateTime IS NULL 
		   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND PSE.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND PSE.InactiveDateTime IS NULL))
		   AND ((@SearchText IS NULL OR (PC.ContractNumber LIKE  @SearchText)) OR
				(@SearchText IS NULL OR (PSE.[ShipmentNumber] LIKE @SearchText)) OR
				(@SearchText IS NULL OR (PSE.shipmentQuantity LIKE @SearchText)) OR
				(@SearchText IS NULL OR (P.[Name] LIKE @SearchText)) OR
			    (@SearchText IS NULL OR (G.GradeName LIKE @SearchText)) OR
			    (@SearchText IS NULL OR (V.[VesselName] LIKE @SearchText)) OR
			    (@SearchText IS NULL OR (PSE.VoyageNumber LIKE @SearchText)) OR
				(@SearchText IS NULL OR (PSE.ETADate LIKE  @SearchText)))
		   ORDER BY
                          CASE WHEN( @SortDirection= 'ASC' OR @SortDirection IS NULL ) THEN
                               CASE 
                                    WHEN @SortBy = 'contractNumber' THEN PC.ContractNumber
                                    WHEN @SortBy = 'shipmentNumber' THEN PSE.[ShipmentNumber]
                                    WHEN @SortBy = 'shipmentQuantity' THEN PSE.shipmentQuantity
                                    WHEN @SortBy = 'product' THEN  P.[Name]
                                    WHEN @SortBy = 'grade' THEN  G.GradeName
                                    WHEN @SortBy = 'vesselName' THEN V.[VesselName]
									WHEN @SortBy = 'voyageNumber' THEN PSE.VoyageNumber
									WHEN @SortBy = 'etaDate' THEN CAST(PSE.ETADate AS SQL_VARIANT)
									WHEN @SortBy = 'CreatedDateTime' THEN CAST(PSE.CreatedDateTime AS SQL_VARIANT)
									WHEN @SortBy = 'statusName' THEN PES.[Name]
                                END
                            END ASC,
                            CASE WHEN @SortDirection = 'DESC' THEN
                                 CASE 
                                    WHEN @SortBy = 'contractNumber' THEN PC.ContractNumber
                                    WHEN @SortBy = 'shipmentNumber' THEN PSE.[ShipmentNumber]
                                    WHEN @SortBy = 'shipmentQuantity' THEN PSE.shipmentQuantity
                                    WHEN @SortBy = 'product' THEN  P.[Name]
                                    WHEN @SortBy = 'grade' THEN  G.GradeName
                                    WHEN @SortBy = 'vesselName' THEN V.[VesselName]
									WHEN @SortBy = 'voyageNumber' THEN PSE.VoyageNumber
									WHEN @SortBy = 'etaDate' THEN CAST(PSE.ETADate AS SQL_VARIANT)
									WHEN @SortBy = 'CreatedDateTime' THEN CAST(PSE.CreatedDateTime AS SQL_VARIANT)
									WHEN @SortBy = 'statusName' THEN PES.[Name]
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