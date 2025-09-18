-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-07 00:00:00.000'
-- Purpose      To Get The StatusReporting ConfigurationsForms by Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetStatusReportingConfigurationForms_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'

CREATE PROCEDURE [dbo].[USP_GetStatusReportingConfigurationForms_New]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
	 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
     IF(@HavePermission = '1')
     BEGIN

        DECLARE @CurrentDate DATETIME =  CAST(GETDATE() AS DATE)
        DECLARE @CurrentDay NVARCHAR(30) = (SELECT DATENAME(WEEKDAY,@CurrentDate))
        DECLARE @LastDate DATETIME = (SELECT DATEADD(D, -1, DATEADD(M, DATEDIFF(M, 0, GETDATE()) + 1, 0)))
        DECLARE @LastDay NVARCHAR(30) = (SELECT DATENAME(WEEKDAY,@LastDate))  
        DECLARE @LastDateOfMonth DATETIME = CASE WHEN (@LastDay = 'Sunday') THEN (SELECT DATEADD(DAY,-2,@LastDate))
                                                  WHEN (@LastDay = 'Saturday') THEN (SELECT DATEADD(DAY,-1,@LastDate))
                                                  ELSE @LastDate END
   

DECLARE @GenericFormIds TABLE
(
	GenericFormId UNIQUEIDENTIFIER,
	StatusReportingConfigurationOptionId UNIQUEIDENTIFIER,
	FormJson NVARCHAR(MAX),
	ReportingDays NVARCHAR(250),
	StatusReportingConfigurationId UNIQUEIDENTIFIER,
	FormName NVARCHAR(800)
)

INSERT INTO @GenericFormIds
SELECT SRCN.GenericFormId,
       SRCO.Id,
	   FormJson,
	   [DisplayName],
	   SRCO.StatusReportingConfigurationId,
	   FormName
FROM StatusReportingConfigurationOption SRCO WITH (NOLOCK)
INNER JOIN StatusReportingConfiguration_New SRCN ON SRCN.Id = SRCO.StatusReportingConfigurationId AND SRCN.InActiveDateTime IS NULL
INNER JOIN StatusReportingOption_New SRO ON SRO.Id = SRCO.StatusReportingOptionId
INNER JOIN GenericForm GF ON GF.Id = SRCN.GenericFormId
INNER JOIN FormType FT ON FT.Id = GF.FormTypeId AND FT.CompanyId = @CompanyId
INNER JOIN (SELECT StatusReportingOptionId,
                   GenericFormId,
				   MIN(SRCO1.CreatedDateTime) CreatedDateTime
			FROM StatusReportingOption_New SRO 
			     INNER JOIN StatusReportingConfigurationOption SRCO1 ON SRO.Id = SRCO1.StatusReportingOptionId AND SRCO1.InActiveDateTime IS NULL
				 INNER JOIN StatusReportingConfiguration_New SRCN ON SRCN.Id = SRCO1.StatusReportingConfigurationId  AND SRCN.InActiveDateTime IS NULL
				 INNER JOIN StatusReportingConfigurationUser SRCU ON SRCU.StatusReportingConfigurationId = SRCN.Id AND SRCU.InActiveDateTime IS NULL
			WHERE SRCU.UserId = @OperationsPerformedBy
			      AND SRO.OptionName = 'Everyworkingday'
				  AND SRO.InActiveDateTime IS NULL
			GROUP BY StatusReportingOptionId,GenericFormId) TInner ON TInner.StatusReportingOptionId = SRCO.StatusReportingOptionId 
			             AND TInner.CreatedDateTime = SRCO.CreatedDateTime AND TInner.GenericFormId = SRCN.GenericFormId

INSERT INTO @GenericFormIds
SELECT SRCN.GenericFormId,
       SRCO.Id,
	   FormJson,
	   [DisplayName],
	   SRCO.StatusReportingConfigurationId,
	   FormName
FROM StatusReportingConfigurationOption SRCO
INNER JOIN StatusReportingConfiguration_New SRCN ON SRCN.Id = SRCO.StatusReportingConfigurationId AND SRCN.InActiveDateTime IS NULL
INNER JOIN StatusReportingOption_New SRO ON SRO.Id = SRCO.StatusReportingOptionId
INNER JOIN GenericForm GF ON GF.Id = SRCN.GenericFormId
INNER JOIN FormType FT ON FT.Id = GF.FormTypeId AND FT.CompanyId = @CompanyId
INNER JOIN (SELECT StatusReportingOptionId,
                   GenericFormId,
				   MIN(SRCO1.CreatedDateTime) CreatedDateTime
			FROM StatusReportingOption_New SRO 
			     INNER JOIN StatusReportingConfigurationOption SRCO1 ON SRO.Id = SRCO1.StatusReportingOptionId AND SRCO1.InActiveDateTime IS NULL
				 INNER JOIN StatusReportingConfiguration_New SRCN ON SRCN.Id = SRCO1.StatusReportingConfigurationId AND SRCN.InActiveDateTime IS NULL
				 INNER JOIN StatusReportingConfigurationUser SRCU ON SRCU.StatusReportingConfigurationId = SRCN.Id AND SRCU.InActiveDateTime IS NULL
			WHERE SRCU.UserId = @OperationsPerformedBy
			      AND (SRO.OptionName = 'Lastworkingdayofthemonth' AND CONVERT(DATE,GETDATE()) = @LastDateOfMonth)
				  AND SRO.InActiveDateTime is NULL
			GROUP BY StatusReportingOptionId,GenericFormId) TInner ON TInner.StatusReportingOptionId = SRCO.StatusReportingOptionId 
			             AND TInner.CreatedDateTime = SRCO.CreatedDateTime AND TInner.GenericFormId = SRCN.GenericFormId
WHERE SRCN.GenericFormId NOT IN (SELECT GenericFormId FROM @GenericFormIds)


INSERT INTO @GenericFormIds
SELECT SRCN.GenericFormId,
       SRCO.Id,
	   FormJson,
	   [DisplayName],
	   SRCO.StatusReportingConfigurationId,
	   FormName
FROM StatusReportingConfigurationOption SRCO
INNER JOIN StatusReportingConfiguration_New SRCN ON SRCN.Id = SRCO.StatusReportingConfigurationId AND SRCN.InActiveDateTime IS NULL
INNER JOIN StatusReportingOption_New SRO ON SRO.Id = SRCO.StatusReportingOptionId
INNER JOIN GenericForm GF ON GF.Id = SRCN.GenericFormId
INNER JOIN FormType FT ON FT.Id = GF.FormTypeId AND FT.CompanyId = @CompanyId
INNER JOIN (SELECT StatusReportingOptionId,GenericFormId,MIN(SRCO1.CreatedDateTime) CreatedDateTime
			FROM StatusReportingOption_New SRO 
			     INNER JOIN StatusReportingConfigurationOption SRCO1 ON SRO.Id = SRCO1.StatusReportingOptionId AND SRCO1.InActiveDateTime IS NULL
				 INNER JOIN StatusReportingConfiguration_New SRCN ON SRCN.Id = SRCO1.StatusReportingConfigurationId AND SRCN.InActiveDateTime IS NULL
				 INNER JOIN StatusReportingConfigurationUser SRCU ON SRCU.StatusReportingConfigurationId = SRCN.Id AND SRCU.InActiveDateTime IS NULL
			WHERE SRCU.UserId = @OperationsPerformedBy
			      AND SRO.OptionName = @CurrentDay
				  AND SRO.InActiveDateTime is NULL
			GROUP BY StatusReportingOptionId,GenericFormId) TInner ON TInner.StatusReportingOptionId = SRCO.StatusReportingOptionId 
			             AND TInner.CreatedDateTime = SRCO.CreatedDateTime AND TInner.GenericFormId = SRCN.GenericFormId
WHERE SRCN.GenericFormId NOT IN (SELECT GenericFormId FROM @GenericFormIds)

SELECT GF.*, CASE WHEN SRNInner.StatusReportingConfigurationId IS NULL THEN 0 ELSE 1 END IsSubmitted
FROM @GenericFormIds GF
     LEFT JOIN (SELECT SRCN.Id StatusReportingConfigurationId,SRN.CreatedByUserId
                FROM StatusReporting_New SRN 
                     INNER JOIN StatusReportingConfigurationOption SRCO ON SRN.StatusReportingConfigurationOptionId = SRCO.Id
   	                 INNER JOIN StatusReportingConfiguration_New SRCN ON SRCN.Id = SRCO.StatusReportingConfigurationId
                WHERE CONVERT(DATE,SubmittedDateTime) = CONVERT(DATE,GETDATE())					  
                GROUP BY SRCN.Id,SRN.CreatedByUserId) SRNInner ON SRNInner.StatusReportingConfigurationId = GF.StatusReportingConfigurationId AND SRNInner.CreatedByUserId = @OperationsPerformedBy
	INNER JOIN GenericForm GF1 ON GF1.Id = GF.GenericFormId AND GF1.InActiveDateTime is NULL  
	INNER JOIN FormType FT ON FT.Id = GF1.FormTypeId AND FT.CompanyId = @CompanyId
    INNER JOIN StatusReportingConfiguration_New SRC ON SRC.Id = GF.StatusReportingConfigurationId --AND SRC.InActiveDateTime is NULL
                             
   END
   END TRY
    BEGIN CATCH
        
		THROW

     END CATCH
END
GO