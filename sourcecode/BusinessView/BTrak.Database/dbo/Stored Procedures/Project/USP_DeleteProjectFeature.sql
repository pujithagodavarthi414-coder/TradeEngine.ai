-------------------------------------------------------------------------------
-- Author       Padmini B
-- Created      '2019-04-18 00:00:00.000'
-- Purpose      To Delete Project Feature
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--DECLARE @Temp TIMESTAMP = (SELECT TimeStamp FROM ProjectFeature WHERE Id = '2B895CD3-1301-4934-A606-9AFE554F81B4')
--EXEC [dbo].[USP_DeleteProjectFeature] @ProjectFeatureId='2B895CD3-1301-4934-A606-9AFE554F81B4'
--,@TimeStamp = @Temp
--,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_DeleteProjectFeature]
(
   @ProjectFeatureId UNIQUEIDENTIFIER = NULL,
   @TimeStamp TIMESTAMP = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
	   DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId
                                               FROM ProjectFeature WHERE [InActiveDateTime] IS NULL AND Id = @ProjectFeatureId)

       DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

       IF (@HavePermission = '1')
       BEGIN
           DECLARE @IsLatest BIT = (CASE WHEN (SELECT [TimeStamp]
                                               FROM ProjectFeature WHERE [InActiveDateTime] IS NULL AND Id = @ProjectFeatureId) = @TimeStamp
                                         THEN 1 ELSE 0 END)

           IF(@IsLatest = 1)
           BEGIN
               
			   DECLARE @CurrentDate DATETIME = GETDATE()
               
			   DECLARE @NewProjectFeatureId UNIQUEIDENTIFIER = NEWID()
              
			   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
			
			   UPDATE ProjectFeature SET InactiveDateTime = @CurrentDate WHERE Id = @ProjectFeatureId

               SELECT Id FROM [dbo].ProjectFeature WHERE Id = @NewProjectFeatureId
                
           END
           ELSE
               RAISERROR (50015,11, 1)
       END
       ELSE
           RAISERROR (@HavePermission,11, 1)

   END TRY
   BEGIN CATCH

       THROW

   END CATCH
END
GO