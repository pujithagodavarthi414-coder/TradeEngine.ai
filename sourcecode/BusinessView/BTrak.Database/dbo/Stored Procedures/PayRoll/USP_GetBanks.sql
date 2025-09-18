-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetBanks] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetBanks]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT = NULL,
	@EmployeeId UNIQUEIDENTIFIER = NULL,
	@BranchId UNIQUEIDENTIFIER = NULL,
	@IsApp BIT = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		DECLARE @EmployeeBranchId UNIQUEIDENTIFIER

		DECLARE @RegionId UNIQUEIDENTIFIER

		DECLARE @CountryId UNIQUEIDENTIFIER

		IF(@EmployeeId IS NOT NULL)
		BEGIN
		SET @EmployeeBranchId = (SELECT BranchId FROM EmployeeBranch EB WHERE EB.EmployeeId = @EmployeeId
	                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE()))
		SET @CountryId = (SELECT CountryId FROM Branch WHERE Id = @EmployeeBranchId)

		END
		ELSE IF(@BranchId IS NOT NULL)
		BEGIN
		SET @CountryId = (SELECT CountryId FROM Branch WHERE Id = @BranchId)
		END

		IF (@HavePermission = '1')
	    BEGIN
		
           SELECT B.Id AS BankId,
				  B.[BankName],
				  B.[CountryId],
				  C.[CountryName],
				  B.[TimeStamp],	
		   	      TotalCount = COUNT(1) OVER()
           FROM Bank AS B	
		   LEFT JOIN Country C ON C.Id = B.CountryId
		   WHERE (@IsApp = 1 OR @CountryId IS NULL 
		          OR C.Id = @CountryId
				  )
		         AND C.CompanyId = @CompanyId
		         AND (@IsArchived IS NULL 
				      OR(@IsArchived = 0 AND B.InActiveDateTime IS NULL) 
					  OR(@IsArchived = 1 AND B.InActiveDateTime IS NOT NULL))
		   	    
           ORDER BY B.[BankName] ASC

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
