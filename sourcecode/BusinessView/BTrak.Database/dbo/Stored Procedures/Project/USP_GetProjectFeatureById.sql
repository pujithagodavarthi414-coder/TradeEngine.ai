-------------------------------------------------------------------------------
-- Author       Pujitha Godavarthi
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Get the ProjectFeatures By Applying FeatureId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetProjectFeatureById] @OperationsPerformedBy='E5F10A36-8045-4E72-982A-0586C51350AE',@FeatureId='4B9C840E-AE3F-4A61-AFAD-01410C6A650E'

CREATE PROCEDURE [dbo].[USP_GetProjectFeatureById]
(
  @FeatureId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy  UNIQUEIDENTIFIER 
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
	  
	  DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	  IF (@HavePermission = '1')
	  BEGIN
	  
	  IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL;
	
	   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

	     SELECT PF.Id as ProjectFeatureId,
		        PF.ProjectFeatureName,
				PF.ProjectId,
				PF.IsDelete,
				PF.CreatedByUserId,
				PF.UpdatedByUserId,
				PF.CreatedDateTime,
				PF.UpdatedDateTime,
			    PFR.UserId as ProjectFeatureResponsiblePersonId,
				P.ProjectName,
				U.FirstName +' '+ISNULL(U.SurName,'') as ProjectFeatureResponsiblePersonName
         FROM [dbo].[ProjectFeature]PF WITH (NOLOCK)
         LEFT JOIN [dbo].[ProjectFeatureResponsiblePerson]PFR WITH (NOLOCK) ON PF.Id = PFR.ProjectFeatureId
	     LEFT JOIN [dbo].[User]U WITH (NOLOCK) ON U.Id = PFR.UserId
	     INNER JOIN [dbo].[Project]P WITH (NOLOCK) ON P.Id = PF.ProjectId
	     WHERE PF.Id = @FeatureId
	        AND P.CompanyId = @CompanyId

	   END
       ELSE
	   BEGIN

           RAISERROR (@HavePermission,11, 1)
	
	  END
	END TRY  
	BEGIN CATCH 
		
		SELECT ERROR_NUMBER() AS ErrorNumber,
			   ERROR_SEVERITY() AS ErrorSeverity, 
			   ERROR_STATE() AS ErrorState,  
			   ERROR_PROCEDURE() AS ErrorProcedure,  
			   ERROR_LINE() AS ErrorLine,  
			   ERROR_MESSAGE() AS ErrorMessage

	END CATCH

END