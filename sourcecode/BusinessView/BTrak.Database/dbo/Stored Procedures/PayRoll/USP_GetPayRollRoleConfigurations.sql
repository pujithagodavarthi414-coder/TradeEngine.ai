-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2019-02-23 00:00:00.000'
-- Purpose      To Get the PayRollRoleConfigurations By Appliying PayRollTemplateId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetPayRollRoleConfigurations] @OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308' 
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayRollRoleConfigurations]
(
   @PayRollTemplateId UNIQUEIDENTIFIER = NULL, 
   @RoleId UNIQUEIDENTIFIER = NULL,
   @SearchText NVARCHAR(500) = NULL,
   @IsArchived BIT = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

     IF(@PayRollTemplateId = '00000000-0000-0000-0000-000000000000') SET @PayRollTemplateId = NULL
     
     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
     
          SELECT PRRC.Id AS PayRollRoleConfigurationId,
                 PRRC.PayRollTemplateId,
                 PRRC.RoleId,
				 PRRC.CreatedDateTime,
                 PRRC.CreatedByUserId,
                 R.RoleName,
				 PRT.PayrollName PayRollTemplateName,
				 PRRC.[TimeStamp],
                 TotalCount = Count(1) OVER()
          FROM  [dbo].[PayRollRoleConfiguration]PRRC WITH (NOLOCK)
                JOIN [dbo].[Role] R WITH (NOLOCK) ON R.Id = PRRC.RoleId AND R.InActiveDateTime IS NULL
				JOIN [dbo].[PayrollTemplate] PRT WITH (NOLOCK) ON PRT.Id = PRRC.PayrollTemplateId AND PRT.InActiveDateTime IS NULL
          WHERE (@PayRollTemplateId IS NULL OR PRRC.PayRollTemplateId = @PayRollTemplateId)
		  AND (@RoleId IS NULL OR PRRC.RoleId = @RoleId)
		  AND PRRC.CompanyId = @CompanyId
		  AND (@SearchText  IS NULL 
		       OR (R.RoleName LIKE  @SearchText ) 
		       OR (PRT.PayrollName LIKE  @SearchText))
		  AND (@IsArchived IS NULL
				OR (@IsArchived = 1 AND PRRC.InActiveDateTime IS NOT NULL)
				OR (@IsArchived = 0 AND PRRC.InActiveDateTime IS NULL))	   	
          ORDER BY R.RoleName ASC
     END TRY  
     BEGIN CATCH 
                                                             
         THROW

    END CATCH
END
GO