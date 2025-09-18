-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2019-02-23 00:00:00.000'
-- Purpose      To Get the PayRollBranchConfigurations By Appliying PayRollTemplateId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetPayRollBranchConfigurations] @OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308',@IsArchived = 0
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayRollBranchConfigurations]
(
   @PayRollTemplateId UNIQUEIDENTIFIER = NULL, 
   @BranchId UNIQUEIDENTIFIER = NULL,
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
     
          SELECT PRBC.Id AS PayRollBranchConfigurationId,
                 PRBC.PayRollTemplateId,
                 PRBC.BranchId,
                 PRBC.CreatedDateTime,
                 PRBC.CreatedByUserId,
                 B.BranchName,
				 PRT.PayRollName PayRollTemplateName,
				 PRBC.[TimeStamp],
                 TotalCount = Count(1) OVER()
          FROM  [dbo].[PayRollBranchConfiguration] PRBC WITH (NOLOCK)
                JOIN [dbo].[Branch] B WITH (NOLOCK) ON B.Id = PRBC.BranchId AND B.InActiveDateTime IS NULL
				JOIN [dbo].[PayrollTemplate] PRT WITH (NOLOCK) ON PRT.Id = PRBC.PayrollTemplateId AND PRT.InActiveDateTime IS NULL
          WHERE (@PayRollTemplateId IS NULL OR PRBC.PayRollTemplateId = @PayRollTemplateId)
		  AND (@BranchId IS NULL OR PRBC.BranchId = @BranchId)
		  AND PRBC.CompanyId = @CompanyId
		  AND (@SearchText  IS NULL 
		       OR (B.BranchName LIKE  @SearchText ) 
		       OR (PRT.PayrollName LIKE  @SearchText))
		  AND (@IsArchived IS NULL
				OR (@IsArchived = 1 AND PRBC.InActiveDateTime IS NOT NULL)
				OR (@IsArchived = 0 AND PRBC.InActiveDateTime IS NULL))
          ORDER BY PRT.PayRollName ASC
     END TRY  
     BEGIN CATCH 
                                                             
         THROW

    END CATCH
END
GO