-------------------------------------------------------------------------------
-- Author      Kalyani Pagadala
-- Created      '2020-12-18 00:00:00.000'
-- Purpose      To Get the Intro details
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertIntro] @OperationsPerformedBy = 'F68AFE7F-C994-41E6-9E71-9C7E893A4E3F',                         
---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetIntro]
(
    @IntroId  UNIQUEIDENTIFIER = NULL,
	@ModuleId UNIQUEIDENTIFIER = NULL,
	@EnableIntro BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER 
)
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

          IF(@IntroId = '00000000-0000-0000-0000-000000000000') SET @IntroId = NULL


             IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL


             SELECT I.Id,
                    I.ModuleId,
                    I.EnableIntro
				    
            FROM Intro AS I 
			    INNER JOIN [User] AS U ON I.CreatedByUserId = U.Id 
			    WHERE I.UserId = @UserId
			  

   END TRY
   BEGIN CATCH
       
       EXEC [dbo].[USP_GetErrorInformation]

   END CATCH 
END
GO
