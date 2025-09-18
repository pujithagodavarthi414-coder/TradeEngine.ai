----------------------------------------------------------------------------------
-- Author       Sri Susmitha Pothuri
-- Created      '2019-09-25 00:00:00.000'
-- Purpose      To Get All Client Projects by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetClientProjects] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971', @ClientId = '39B601A4-47EC-4EC2-A604-185E13A93D5D', @ClientProjectId = '264A3D51-120F-4616-8D2A-6B572059BB67'
----------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetClientProjects]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ClientProjectId UNIQUEIDENTIFIER = NULL,
	@ClientId UNIQUEIDENTIFIER = NULL,
	@IsArchived BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN      

           IF(@ClientProjectId = '00000000-0000-0000-0000-000000000000') SET @ClientProjectId = NULL
           
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))       
                               
           SELECT CP.Id AS ClientProjectId,
				  CP.ClientId,
				  CP.ProjectId,	
				  P.ProjectName,		
				  CP.CreatedDateTime,
                  CP.CreatedByUserId,
				  CP.UpdatedDateTime,
				  CP.UpdatedByUserId,
				  CP.InActiveDateTime,
                  CP.[TimeStamp],  
                  TotalCount = COUNT(1) OVER()
           FROM ClientProjects AS CP
		   LEFT JOIN Client C ON C.Id = CP.ClientId
		   LEFT JOIN Project P ON P.Id = CP.ProjectId
           WHERE CP.CompanyId = @CompanyId
                AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CP.InactiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CP.InactiveDateTime IS NULL))
                AND (@ClientProjectId IS NULL OR CP.Id = @ClientProjectId) 
				AND (@ClientId IS NULL OR CP.ClientId = @ClientId)     
           ORDER BY CP.ProjectId ASC
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
