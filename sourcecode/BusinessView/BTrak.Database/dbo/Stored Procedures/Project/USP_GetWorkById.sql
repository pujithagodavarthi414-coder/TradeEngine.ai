-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-04 00:00:00.000'
-- Purpose      To Get the Work By Applying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetWorkById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WorkId=''

CREATE PROCEDURE [dbo].[USP_GetWorkById]
(
 @WorkId  UNIQUEIDENTIFIER = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

          SELECT W.[Id] AS WorkId,
                 W.[WorkJson],
                 W.[Date],
                 W.[UserId],
				 U.CompanyId,
				 U.FirstName,
				 U.SurName AS Email,
				 U.[Password],
				 --U.RoleId,
				 U.IsPasswordForceReset,
				 U.IsActive,
				 U.TimeZoneId,
				 U.IsAdmin,
				 U.IsActiveOnMobile,
				 U.ProfileImage,
				 U.RegisteredDateTime,
				 U.LastConnection,
				 U.CreatedDateTime,
				 U.CreatedByUserId,
				 U.UpdatedDateTime,
				 U.UpdatedByUserId
          FROM  [dbo].[Work]W WITH (NOLOCK) JOIN [User]U WITH (NOLOCK) ON W.UserId=U.Id       
                WHERE  U.CompanyId = @CompanyId AND W.Id = @WorkId
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