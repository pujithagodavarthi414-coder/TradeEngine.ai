-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Get theConsideredHours By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetConsideredHours] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ConsideredHoursId='3FC74B83-0BDD-4E2F-914B-FA9443CD3C24'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetConsideredHoursById]
(
    @ConsideredHoursId  UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON

     BEGIN TRY

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

         SELECT CH.[Id] AS ConsiderHourId,
                 CH.[ConsiderHourName],
                 CH.InActiveDateTime AS [ArchivedDateTime],
                 CH.[CompanyId],
                 CH.[CreatedDatetime],
                 CH.[CreatedByUserId],
				 U.FirstName +' '+ISNULL(U.SurName,'') AS FullName
        FROM  [dbo].[ConsiderHours]CH WITH (NOLOCK)
		  INNER JOIN [dbo].[User]U ON U.Id = CH.CreatedByUserId
        WHERE CH.[Id] = @ConsideredHoursId
		      AND CH.CompanyId = @CompanyId

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