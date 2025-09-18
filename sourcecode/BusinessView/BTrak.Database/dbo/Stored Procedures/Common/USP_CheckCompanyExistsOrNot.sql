---------------------------------------------------------------------------
-- Author       Gududhuru Raghavendra
-- Created      '2020-01-22 00:00:00.000'
-- Purpose      To Get the Cron expression details
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC  [dbo].[USP_CheckCompanyExistsOrNot] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_CheckCompanyExistsOrNot]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
 @SiteAddress NVARCHAR(100)
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

   SELECT SiteAddress FROM Company
         WHERE SiteAddress = @SiteAddress

   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
