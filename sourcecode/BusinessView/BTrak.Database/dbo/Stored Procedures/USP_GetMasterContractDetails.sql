
CREATE PROCEDURE [dbo].[USP_GetMasterContractDetails]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ClientId UNIQUEIDENTIFIER = NULL,
    @SearchText NVARCHAR(250) = NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
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

		    SELECT   C.Id AS ContractId,C.[ContractName],C.[ClientId],C.[ContractUniqueName],C.[ProductId],C.[GradeId],C.[RateOrTon],C.[ContractQuantity],C.[UsedQuantity]
			 ,C.[RemaningQuantity],C.[TimeStamp],C.[CreatedDateTime],C.[CreatedByUserId],C.[UpdatedDateTime],C.[UpdatedDateTimeZone],C.[UpdatedByUserId],C.[ContractDocument]
			 ,C.[ContractDateFrom],C.[ContractDateTo],G.GradeName AS Grade,P.[Name] AS Product,CONCAT(U.FirstName ,' ',U.SurName) CounterParty
			FROM MasterContract AS C
			   JOIN Grade G On G.Id = C.GradeId
			   JOIN MasterProduct P On P.Id = C.ProductId
			   JOIN Client ON Client.Id = CLientId
			   JOIN [User] U ON U.Id = Client.UserId
           WHERE C.CompanyId = @CompanyId 

				
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