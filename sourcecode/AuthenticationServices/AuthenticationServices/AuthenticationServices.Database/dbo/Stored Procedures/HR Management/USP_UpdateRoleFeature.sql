CREATE PROCEDURE [dbo].[USP_UpdateRoleFeature]
(
  @RoleId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @FeatureId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250) ='1' -- (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN
		              
		   IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL                                  

		   DECLARE @CurrentDate DATETIME= GETDATE()  

				 UPDATE  [dbo].[RoleFeature]
                                SET [InActiveDateTime] = @CurrentDate
					    	WHERE RoleId = @RoleId AND FeatureId = @FeatureId AND InActiveDateTime IS NULL 
							
				SELECT Id FROM RoleFeature WHERE RoleId = @RoleId AND FeatureId = @FeatureId AND InActiveDateTime = @CurrentDate     
            
         END
    END TRY  
    BEGIN CATCH 
        
         THROW
    END CATCH
END
