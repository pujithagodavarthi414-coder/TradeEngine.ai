-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Created      '2019-06-04 00:00:00.000'
-- Purpose      To get payment type by applying different filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetPaymentType]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
----------------------------------------------------------------------------------------------

CREATE PROCEDURE USP_GetPaymentTypes
(
 @PaymentTypeId UNIQUEIDENTIFIER = NULL,
 @PaymentTypeName NVARCHAR(800) = NULL,
 @Searchtext NVARCHAR(800) = NULL,
 @IsArchived BIT = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
   
     SET NOCOUNT ON 
	  
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000')  SET @OperationsPerformedBy = NULL

	 IF (@PaymentTypeId ='00000000-0000-0000-0000-000000000000') SET @PaymentTypeId = NULL

	 IF (@PaymentTypeName = '' ) SET @PaymentTypeName = NULL

	 IF (@Searchtext = '') SET @Searchtext = NULL
       
     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	                 IF(@HavePermission = '1')
	                 BEGIN
	                 
	                  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	                 
	                           SELECT PT.Id AS PaymentTypeId,
	                                  Pt.PaymentTypeName,
	                 	        	  CASE WHEN PT.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived,
									  PT.CreatedByUserId,
									  PT.CreatedDateTime,
	                 	        	  PT.[TimeStamp],
	                 	        	  TotalCount = COUNT(1)  OVER()
	                 	        FROM PaymentType PT 		
	                 	        WHERE  (PT.CompanyId = @CompanyId)
	                 				 AND (@PaymentTypeId IS NULL OR PT.Id = @PaymentTypeId)
	                 	        	 AND (@PaymentTypeName IS NULL OR PT.PaymentTypeName = @PaymentTypeName)
	                 	        	 AND (@Searchtext IS NULL OR PT.PaymentTypeName LIKE '%'+@Searchtext+'%')
	                 	        	 AND (@IsArchived IS NULL OR (@IsArchived = 0 AND PT.InActiveDateTime IS NULL) 
	                 				 OR  (@IsArchived  = 1 AND PT.InActiveDateTime IS NOT NULL))
	                 
	                 	ORDER BY PT.PaymentTypeName
		 END
	  ELSE
	  BEGIN
	  
	       RAISERROR (@HavePermission,16, 1)
	  
	  END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO