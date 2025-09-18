-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-07 00:00:00.000'
-- Purpose      To Get The status reportingconfigurations by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved  
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetStatusReportingConfigurations_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------- 
CREATE PROCEDURE [dbo].[USP_GetStatusReportingConfigurations_New]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @StatusReportingConfigurationId UNIQUEIDENTIFIER = NULL,
	@GenericFormId UNIQUEIDENTIFIER= NULL,
	@FormTypeId UNIQUEIDENTIFIER= NULL,
    @SearchText NVARCHAR(250) = NULL,
    @AssignedBy UNIQUEIDENTIFIER = NULL,
    @PageSize INT = 10,
    @PageNumber INT = 1,
    @IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
	     DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		 IF (@HavePermission = '1')
		 BEGIN
        
		 IF(@AssignedBy = '00000000-0000-0000-0000-000000000000') SET @AssignedBy = NULL

		 IF (@IsArchived IS NULL) SET @IsArchived = 0
         
		 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
        
		 SELECT  SRC.[Id] AS Id,
                 SRC.[ConfigurationName],
                 SRC.[GenericFormId],
                 GF.[FormTypeId],
                 GF.[FormName],
                 U.FirstName + ' ' + ISNULL(U.SurName,'') AS AssignedByUserName,
                 SRC.InActiveDateTime AS ArchivedDateTime,
                 SRC.[CreatedDateTime],
                 SRC.[TimeStamp],
                 CASE WHEN SRC.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,                 
                 SRC.[CreatedByUserId] AS AssignedBy,
                 EmployeeIds = STUFF(( SELECT  ',' + LOWER(Convert(nvarchar(50),SRCU.UserId))[text()]
                                       FROM StatusReportingConfiguration_New SRC1
                                       LEFT JOIN StatusReportingConfigurationUser SRCU ON SRCU.StatusReportingConfigurationId = SRC1.Id
                                       WHERE SRCU.InActiveDateTime IS NULL
                                       AND SRC.Id = SRC1.Id
                                       FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
                 AssignedToEmployees = STUFF(( SELECT  ',' + Convert(NVARCHAR(50),U.FirstName + ' '+ISNULL(U.SurName,''))[text()]
                                               FROM [StatusReportingConfiguration_New] SRC2
                                               LEFT JOIN StatusReportingConfigurationUser SRCU ON SRCU.StatusReportingConfigurationId = SRC2.Id
                                                JOIN [User] U ON SRCU.UserId = U.Id
                                               WHERE SRCU.InActiveDateTime IS NULL AND SRC.Id = SRC2.Id
											   ORDER BY U.FirstName
                                               FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,' '),
                 StatusReportingOptionIds = STUFF(( SELECT  ',' + LOWER(Convert(NVARCHAR(50),SRCO.StatusReportingOptionId))[text()]
                                                    FROM StatusReportingConfiguration_New SRC3
                                                     LEFT JOIN StatusReportingConfigurationOption SRCO ON SRCO.StatusReportingConfigurationId = SRC3.Id
                                                     WHERE SRCO.InActiveDateTime IS NULL
                                                           AND SRC.Id = SRC3.Id
                                                    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,' '),
                 ReportingDays = STUFF(( SELECT  ',' + Convert(nvarchar(50),SRO.[DisplayName])[text()]
                                         FROM [StatusReportingConfiguration_New] SRC4
                                         LEFT JOIN StatusReportingConfigurationOption SRCO ON SRCO.StatusReportingConfigurationId = SRC4.Id
                                          JOIN [StatusReportingOption_New] SRO ON SRCO.StatusReportingOptionId = SRO.Id
                                         WHERE SRCO.InActiveDateTime IS NULL
                                                AND SRC.Id = SRC4.Id
                                         FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,' '),
                TotalCount = COUNT(1) OVER()

           FROM [dbo].[StatusReportingConfiguration_New] SRC WITH (NOLOCK)
                JOIN [User] U WITH (NOLOCK) ON SRC.CreatedByUserId = U.Id
                JOIN [GenericForm] GF WITH (NOLOCK) ON GF.Id = SRC.GenericFormId AND GF.InActiveDateTime IS NULL
				INNER JOIN FormType FT ON FT.Id = GF.FormTypeId AND FT.CompanyId = @CompanyId
           WHERE (@StatusReportingConfigurationId IS NULL OR (SRC.Id = @StatusReportingConfigurationId))
		         AND (@GenericFormId IS NULL OR (SRC.GenericFormId = @GenericFormId))
				 AND (@FormTypeId IS NULL OR (GF.FormTypeId = @FormTypeId))
                 AND (SRC.CreatedByUserId = @OperationsPerformedBy)
                 AND (@AssignedBy IS NULL OR SRC.CreatedByUserId = @AssignedBy)
                 AND (@SearchText IS NULL OR SRC.ConfigurationName LIKE @SearchText)
                 AND (@IsArchived IS NULL OR (@IsArchived = 1 AND SRC.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND SRC.InActiveDateTime IS NULL))
           ORDER BY SRC.CreatedDateTime DESC
           OFFSET ((@PageNumber - 1) * @PageSize) ROWS
           FETCH NEXT @PageSize ROWS ONLY

		END
		ELSE
		  
		    RAISERROR(@HavePermission,11,1)

   END TRY

   BEGIN CATCH

         THROW

   END CATCH
END
GO