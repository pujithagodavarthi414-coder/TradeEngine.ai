--EXEC [dbo].[USP_UpdateEntityRoleFeature] @OperationsPerformedBy = 'b97e319b-5a8d-4d23-9c2e-47c4cf715391' , @EntityFeatureId = 'CB732217-C68E-45E7-8D47-9C809A974D64', @EntityRoleId='78a4bfc6-707d-487c-85a8-65dccb1df8aa'
CREATE PROCEDURE [dbo].[USP_UpdateEntityRoleFeature]
(
  @EntityRoleId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @EntityFeatureId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
		              
		   IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL                                  

		   DECLARE @CurrentDate DATETIME= GETDATE()  

				 UPDATE  [dbo].[EntityRoleFeature]
                                SET [InActiveDateTime] = @CurrentDate
					    	WHERE EntityRoleId = @EntityRoleId AND EntityFeatureId = @EntityFeatureId AND InActiveDateTime IS NULL 
							
				SELECT Id FROM EntityRoleFeature WHERE EntityRoleId = @EntityRoleId AND EntityFeatureId = @EntityFeatureId AND InActiveDateTime = @CurrentDate     
            
         END
    END TRY  
    BEGIN CATCH 
        
         THROW
    END CATCH
END

 