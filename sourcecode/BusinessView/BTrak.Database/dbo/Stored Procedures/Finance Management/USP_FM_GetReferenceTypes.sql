---------------------------------------------------------------------------------------------------------
--EXEC USP_FM_GetReferenceTypes @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',
--@FeatureId = 'FC361D23-F317-4704-B86F-0D6E7287EEE9'
---------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_FM_GetReferenceTypes]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,		
  @FeatureId UNIQUEIDENTIFIER
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	       
		   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		   
           DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		   IF (@HavePermission = '1')
		   BEGIN

		       DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			   SELECT Id AS ReferenceTypeId,
			          [ReferenceTypeName]
		       FROM  [dbo].[ReferenceType] WITH (NOLOCK)
		       WHERE InactiveDateTime IS NULL
		     ORDER BY ReferenceTypeName

		  END
		  ELSE
			RAISERROR (@HavePermission,11, 1)
		   
	 END TRY  
	 BEGIN CATCH 
		
		  EXEC [dbo].[USP_GetErrorInformation]

	END CATCH

END
GO
