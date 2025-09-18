-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCustomeHtmlAppDetails] @OperationsPerformedBy ='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetCustomeHtmlAppDetails]
(
  @CustomHtmlAppId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    
     SET NOCOUNT ON
     BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
         
         DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         IF(@HavePermission = '1')
         BEGIN
          
         
          IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
        
          
             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy)) 
             
                    select CustomHtmlAppName,
							[Description],
							HtmlCode,
							RoleId
					from CustomHtmlApp CHA 
						 JOIN  CustomHtmlAppRoleConfiguration CHARC ON CHA.Id = CHARC.CustomHtmlAppId 
							AND CHA.Id = @CustomHtmlAppId
                     WHERE  CHA.CompanyId = @CompanyId  
                        
                  ORDER BY CustomHtmlAppName ASC
          
          END
         ELSE
          
            RAISERROR(@HavePermission,11,1)
        END TRY
        BEGIN CATCH
         
         THROW
        END CATCH
END
GO
