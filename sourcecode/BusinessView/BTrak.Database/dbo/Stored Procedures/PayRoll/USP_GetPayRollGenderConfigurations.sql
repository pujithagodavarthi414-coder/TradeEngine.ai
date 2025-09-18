-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2019-02-23 00:00:00.000'
-- Purpose      To Get the PayRollGenderConfigurations By Appliying PayRollTemplateId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetPayRollGenderConfigurations] @OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308' ,@IsArchived = 0  
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayRollGenderConfigurations]
(
   @PayRollTemplateId UNIQUEIDENTIFIER = NULL, 
   @GenderId UNIQUEIDENTIFIER = NULL,
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
     
          SELECT PRGC.Id AS PayRollGenderConfigurationId,
                 PRGC.PayRollTemplateId,
                 PRGC.GenderId,
                 PRGC.CreatedDateTime,
                 PRGC.CreatedByUserId,
				 PRGC.[TimeStamp],
                 G.Gender GenderName,
				 PRT.PayRollName PayRollTemplateName,
                 TotalCount = Count(1) OVER()
          FROM  [dbo].[PayRollGenderConfiguration] PRGC WITH (NOLOCK)
                JOIN [dbo].[Gender] G WITH (NOLOCK) ON G.Id = PRGC.GenderId AND G.InActiveDateTime IS NULL
				JOIN [dbo].[PayrollTemplate] PRT WITH (NOLOCK) ON PRT.Id = PRGC.PayrollTemplateId AND PRT.InActiveDateTime IS NULL
          WHERE (@PayRollTemplateId IS NULL OR PRGC.PayRollTemplateId = @PayRollTemplateId)
		  AND (@GenderId IS NULL OR PRGC.GenderId = @GenderId)
		  AND PRGC.CompanyId = @CompanyId
		  AND (@SearchText  IS NULL 
		       OR (G.Gender LIKE  @SearchText ) 
		       OR (PRT.PayrollName LIKE  @SearchText))
		  AND (@IsArchived IS NULL
				OR (@IsArchived = 1 AND PRGC.InActiveDateTime IS NOT NULL)
				OR (@IsArchived = 0 AND PRGC.InActiveDateTime IS NULL))
          ORDER BY PRT.PayRollName ASC
     END TRY  
     BEGIN CATCH 
                                                             
         THROW

    END CATCH
END
GO