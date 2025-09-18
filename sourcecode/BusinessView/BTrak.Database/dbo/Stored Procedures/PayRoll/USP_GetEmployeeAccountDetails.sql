-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-20 00:00:00.000'
-- Purpose      To Save or Update EmployeeAccountDetails
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetEmployeeAccountDetails] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeAccountDetails]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsArchived BIT= NULL,
	@EmployeeAccountDetailsId UNIQUEIDENTIFIER = NULL,
	@EmployeeId  UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
	    BEGIN
		   
		   IF(@EmployeeAccountDetailsId = '00000000-0000-0000-0000-000000000000') SET @EmployeeAccountDetailsId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT EAD.Id AS EmployeeAccountDetailsId,
		   	      EAD.[PANNumber],
				  EAD.[PFNumber],
		   	      EAD.[UANNumber],
				  EAD.[ESINumber],			
		   	      EAD.InActiveDateTime,
		   	      EAD.CreatedDateTime ,
		   	      EAD.CreatedByUserId,
		   	      EAD.[TimeStamp],
				  (CASE WHEN EAD.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM EmployeeAccountDetails AS EAD
		   INNER JOIN [Employee] E ON E.Id = EAD.EmployeeId
		   INNER JOIN [User] U ON U.Id =  E.UserId	
           WHERE U.CompanyId = @CompanyId
		   	    AND (@EmployeeAccountDetailsId IS NULL OR EAD.Id = @EmployeeAccountDetailsId)
				AND (@EmployeeId IS NULL OR EAD.EmployeeId = @EmployeeId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND EAD.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND EAD.InActiveDateTime IS NULL))	   	    

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

