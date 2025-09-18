-------------------------------------------------------------------------------
-- Author      Kalyani Pagadala
-- Created      '2020-12-18 00:00:00.000'
-- Purpose      To Save or Update the Intro
---------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertIntro] @OperationsPerformedBy = 'F68AFE7F-C994-41E6-9E71-9C7E893A4E3F',                         
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertIntro]
	(
    @IntroId  UNIQUEIDENTIFIER = NULL,
	@ModuleId UNIQUEIDENTIFIER = NULL,
	@EnableIntro BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
    
          BEGIN
               DECLARE @Currentdate DATETIME = GETDATE()
       
			IF (@IntroId IS NULL)        
            BEGIN

			SET @IntroId = NEWID()
			
			INSERT INTO [dbo].[Intro](
                         [Id],
                         [ModuleId],
                         [EnableIntro],
                         [CreatedDateTime],
                         [CreatedByUserId] 
                         )
                  SELECT @IntroId,
                         @ModuleId,
                         @EnableIntro,
                         @Currentdate,
                         @OperationsPerformedBy        
                            
			END
			ELSE
			BEGIN

					UPDATE [dbo].[Intro]
						SET
                         [ModuleId]		      =  		  @ModuleId,
                         [EnableIntro]		  =  		  @EnableIntro,
                         [UpdatedDateTime]	  =  		  @Currentdate,
                         [UpdatedByUserId]    =        	  @OperationsPerformedBy         
						WHERE Id = @IntroId
			END
                         SELECT Id FROM [dbo].[Intro] WHERE Id = @IntroId
            END
                                   
    
    END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO