-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-01-07 00:00:00.000'
-- Purpose      To Get The project By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetProjectById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProjectId='A483A084-7232-4101-9579-4662243D184A'

CREATE PROCEDURE [dbo].[USP_GetProjectById]
(
	@ProjectId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)

AS
BEGIN

 SET NOCOUNT ON

	 BEGIN TRY

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

         SELECT P.Id AS ProjectId,
		        P.ProjectName,
			    P.ProjectResponsiblePersonId,
			    P.InactiveDateTime ArchivedDateTime,
			    P.ProjectStatusColor,
			    REPLACE(CONVERT(NVARCHAR,P.CreatedDateTime, 106), ' ', '-')AS CreatedDateTime,
			    P.CreatedByUserId,
			    P.UpdatedByUserId,
			    P.UpdatedDateTime,
			    U.FirstName +' '+ISNULL(U.SurName,'') AS FullName,
		        U.CompanyId,
                U.FirstName,
                U.SurName,
                U.UserName AS Email,
                U.[Password],
                U.IsPasswordForceReset,
                U.IsActive,
                U.TimeZoneId,
                U.MobileNo,
                U.IsAdmin,
                U.IsActiveOnMobile,
                U.ProfileImage,
                U.RegisteredDateTime,
                U.LastConnection,
			    PT.ProjectTypeName,
				PT.Id AS ProjectTypeId,
			    TotalCount = COUNT(1) OVER()
        FROM [dbo].[Project] P WITH (NOLOCK)
		     LEFT JOIN [dbo].[User] U ON P.ProjectResponsiblePersonId = U.Id
		     LEFT JOIN [dbo].[ProjectType] PT ON P.ProjectTypeId = PT.Id
	    WHERE P.[Id] = @ProjectId
			  AND (P.CompanyId = @CompanyId)

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
GO