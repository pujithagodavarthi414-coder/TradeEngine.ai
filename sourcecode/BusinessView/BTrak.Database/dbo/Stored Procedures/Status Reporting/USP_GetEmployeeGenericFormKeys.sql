CREATE PROCEDURE [dbo].[USP_GetEmployeeGenericFormKeys]
(
	@GenericFormKeyId UNIQUEIDENTIFIER = NULL,		
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@GenericFormId UNIQUEIDENTIFIER = NULL,
	@Key NVARCHAR(150) = NULL,
	@IsArchived BIT= NULL	
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		  
		   IF(@GenericFormKeyId = '00000000-0000-0000-0000-000000000000') SET @GenericFormKeyId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT GFK.Id AS GenericFormKeyId
		          ,GFK.CustomFieldsId
				  ,GFK.[Key]
				  ,GFK.IsDefault
				  ,GFK.CreatedByUserId
				  ,GFK.CreatedDateTime
				  ,GFK.Label
				  ,CASE WHEN GFK.InActiveDateTime IS NULL THEN 0 ELSE 1 END AS IsArchived
		   FROM [EmployeeFormKeys] GFK
           WHERE GFK.InActiveDateTime IS NULL --TODO
				AND (@GenericFormKeyId IS NULL OR GFK.Id = @GenericFormKeyId)
		        AND (@GenericFormId IS NULL OR GFK.CustomFieldsId = @GenericFormId)
		        AND (@Key IS NULL OR GFK.CustomFieldsId = @Key)
				AND (@IsArchived IS NULL 
				    OR (@IsArchived = 1 AND GFK.InActiveDateTime IS NOT NULL) 
					OR (@IsArchived = 0 AND GFK.InActiveDateTime IS NULL))
           ORDER BY GFK.[Key] ASC

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
