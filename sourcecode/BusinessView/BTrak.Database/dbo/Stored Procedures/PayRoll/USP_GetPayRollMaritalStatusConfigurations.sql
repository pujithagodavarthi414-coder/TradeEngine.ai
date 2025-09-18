-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2019-02-23 00:00:00.000'
-- Purpose      To Get the PayRollMaritalStatusConfigurations By Appliying PayRollTemplateId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetPayRollMaritalStatusConfigurations_New] @OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308' ,@UserId = '0b2921a9-e930-4013-9047-670b5352f308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayRollMaritalStatusConfigurations]
(
   @PayRollTemplateId UNIQUEIDENTIFIER = NULL, 
   @MaritalStatusId UNIQUEIDENTIFIER = NULL,
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
     
          SELECT PRMC.Id AS PayRollMaritalStatusConfigurationId,
                 PRMC.PayRollTemplateId,
                 PRMC.MaritalStatusId,
                 PRMC.CreatedDateTime,
                 PRMC.CreatedByUserId,
				 PRMC.[TimeStamp],
                 MS.MaritalStatus MaritalStatusName,
				 PRT.PayRollName PayRollTemplateName,
                 TotalCount = Count(1) OVER()
          FROM  [dbo].[PayRollMaritalStatusConfiguration] PRMC WITH (NOLOCK)
                JOIN [dbo].[MaritalStatus] MS WITH (NOLOCK) ON MS.Id = PRMC.MaritalStatusId AND MS.InActiveDateTime IS NULL
				JOIN [dbo].[PayrollTemplate] PRT WITH (NOLOCK) ON PRT.Id = PRMC.PayrollTemplateId AND PRT.InActiveDateTime IS NULL
          WHERE (@PayRollTemplateId IS NULL OR PRMC.PayRollTemplateId = @PayRollTemplateId)
		  AND (@MaritalStatusId IS NULL OR PRMC.MaritalStatusId = @MaritalStatusId)
		  AND PRMC.CompanyId = @CompanyId
		  AND (@SearchText  IS NULL 
		       OR (MS.MaritalStatus LIKE  @SearchText) 
		       OR (PRT.PayrollName LIKE  @SearchText))
		 AND (@IsArchived IS NULL
				OR (@IsArchived = 1 AND PRMC.InActiveDateTime IS NOT NULL)
				OR (@IsArchived = 0 AND PRMC.InActiveDateTime IS NULL))
          ORDER BY PRT.PayRollName ASC
     END TRY  
     BEGIN CATCH 
                                                             
         THROW

    END CATCH
END
GO