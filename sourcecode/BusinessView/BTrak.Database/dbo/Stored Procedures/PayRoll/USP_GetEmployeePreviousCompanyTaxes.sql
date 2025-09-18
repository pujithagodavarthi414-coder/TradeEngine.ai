-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update EmployeePreviousCompanyTax
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeePreviousCompanyTaxes]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT= NULL,
	@EmployeePreviousCompanyTaxId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   
		   IF(@EmployeePreviousCompanyTaxId = '00000000-0000-0000-0000-000000000000') SET @EmployeePreviousCompanyTaxId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT EPCT.Id AS EmployeePreviousCompanyTaxId,
		          EPCT.[EmployeeId],
				  U.[FirstName] + ''+ISNULL(U.SurName,'') EmployeeName,	
				  EPCT.TaxAmount,
		   	      EPCT.InActiveDateTime,
		   	      EPCT.CreatedDateTime ,
		   	      EPCT.CreatedByUserId,
		   	      EPCT.[TimeStamp],
				  (CASE WHEN EPCT.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM EmployeePreviousCompanyTax AS EPCT
		   INNER JOIN Employee E ON E.Id = EPCT.EmployeeId
		   INNER JOIN [User] U ON U.Id = E.UserId
           WHERE U.[CompanyId] = @CompanyId
		   	    AND (@EmployeePreviousCompanyTaxId IS NULL OR EPCT.Id = @EmployeePreviousCompanyTaxId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND EPCT.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND EPCT.InActiveDateTime IS NULL))	   	    

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
