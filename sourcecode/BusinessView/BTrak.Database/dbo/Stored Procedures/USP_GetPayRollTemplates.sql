-------------------------------------------------------------------------------
-- Author       K Aswani
-- Created      '2020-01-23 00:00:00.000'
-- Purpose      To Save or Update PayRollTemplate
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetPayRollTemplates] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',@IsArchived = 0
--------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetPayRollTemplates]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsRepeatInfinitly BIT = NULL,
	@IslastWorkingDay BIT = NULL,
	@InfinitlyRunDate DATETIME = NULL,
	@SearchText NVARCHAR(500) = NULL,
	@FrequencyId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL,
	@PayRollTemplateId UNIQUEIDENTIFIER = NULL,
	@PayRollTemplateName NVARCHAR(500) = NULL
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText  = '') SET @SearchText  = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@PayRollTemplateId = '00000000-0000-0000-0000-000000000000') SET @PayRollTemplateId = NULL	
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
       	   
           SELECT PRC.Id AS PayRollTemplateId,
		   	      PRC.CompanyId,
				  PRC.[PayRollName],
				  PRC.[PayRollShortName],
		   	      PRC.[IsRepeatInfinitly],
				  PRC.[IslastWorkingDay],			
		   	      PRC.InActiveDateTime,
		   	      PRC.CreatedDateTime ,
		   	      PRC.CreatedByUserId,
				  PRC.InfinitlyRunDate,
				  PRC.FrequencyId,
				  PRC.[CurrencyId],
		   	      PRC.[TimeStamp],
				  PF.PayFrequencyName,
				  C.CurrencyName,
				  (CASE WHEN PRC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,	
		   	      TotalCount = COUNT(1) OVER()
           FROM PayRollTemplate AS PRC		
		        LEFT JOIN PayFrequency PF ON PF.Id = PRC.FrequencyId
			    INNER JOIN SYS_Currency C ON C.Id = PRC.CurrencyId
           WHERE PRC.CompanyId = @CompanyId
		        AND (@PayRollTemplateName IS NULL OR PRC.[PayrollName] = @PayRollTemplateName)
		        AND (@SearchText IS NULL 
				     OR (PRC.[PayRollName] LIKE  @SearchText)
				     OR (PRC.[PayRollShortName] LIKE  @SearchText)
					 OR (PF.[PayFrequencyName] LIKE  @SearchText)
					 OR (C.CurrencyName LIKE @SearchText))
		   	    AND (@PayRollTemplateId IS NULL OR PRC.Id = @PayRollTemplateId)
				AND (@FrequencyId IS NULL OR PRC.FrequencyId = @FrequencyId)
			    AND (@IsRepeatInfinitly IS NULL OR PRC.IsRepeatInfinitly = @IsRepeatInfinitly)
				AND (@IslastWorkingDay IS NULL OR PRC.IslastWorkingDay = @IslastWorkingDay)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND PRC.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND PRC.InActiveDateTime IS NULL))	   	    
           ORDER BY PRC.[PayRollName] ASC

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
