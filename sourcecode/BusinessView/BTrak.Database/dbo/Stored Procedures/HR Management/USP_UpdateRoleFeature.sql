--EXEC [dbo].[USP_UpdateRoleFeature] @OperationsPerformedBy = 'B97E319B-5A8D-4D23-9C2E-47C4CF715391' , @FeatureId = 'de865dbd-b6d6-43ad-a560-bd71f9da4266', @RoleId='C64E9A73-23BD-4617-ADA8-029E0588FFC7',@IsArchived=1
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

 