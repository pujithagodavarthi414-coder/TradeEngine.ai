-------------------------------------------------------------------------------
-- Author      Aswani k
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update Language
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertLanguage] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@LanguageName = 'Test'                                  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertLanguage]
(
   @LanguageId UNIQUEIDENTIFIER = NULL,
   @LanguageName NVARCHAR(50) = NULL,  
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
     
        IF(@LanguageName = '') SET @LanguageName = NULL
        IF(@IsArchived = 1 AND @LanguageId IS NOT NULL)
        BEGIN
            
              DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
              
              IF(EXISTS(SELECT Id FROM [EmployeeLanguage] WHERE LanguageId = @LanguageId))
              BEGIN
              
              SET @IsEligibleToArchive = 'ThisLanguageUsedInEmployeeLanguageDeleteTheDependenciesAndTryAgain'
              
              END
              
              IF(@IsEligibleToArchive <> '1')
              BEGIN
              
                  RAISERROR (@isEligibleToArchive,11, 1)
              
              END
        END
        IF(@LanguageName IS NULL)
        BEGIN
           
            RAISERROR(50011,16, 2, 'LanguageName')
        END
        ELSE 
        BEGIN
         
             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
             DECLARE @LanguageIdCount INT = (SELECT COUNT(1) FROM Language  WHERE Id = @LanguageId)
        
             DECLARE @LanguageNameCount INT = (SELECT COUNT(1) FROM Language WHERE LanguageName = @LanguageName AND CompanyId = @CompanyId  AND (@LanguageId IS NULL OR Id <> @LanguageId))       
       
        IF(@LanguageIdCount = 0 AND @LanguageId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'Language')
        END
        ELSE IF(@LanguageNameCount>0)
        BEGIN
        
           RAISERROR(50001,16,1,'Language')
           
         END
         ELSE
         BEGIN
       
                     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
                     IF (@HavePermission = '1')
                     BEGIN
                        
                        DECLARE @IsLatest BIT = (CASE WHEN @LanguageId  IS NULL 
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [Language] WHERE Id = @LanguageId ) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                     
                        IF(@IsLatest = 1)
                        BEGIN
                     
                             DECLARE @Currentdate DATETIME = GETDATE()
                             
                    IF( @LanguageId IS NULL)
					BEGIN

						SET @LanguageId = NEWID()
                             INSERT INTO [dbo].[Language](
                                         [Id],
                                         [CompanyId],
                                         [LanguageName],
                                         [InActiveDateTime],
                                         [CreatedDateTime],
                                         [CreatedByUserId]  )            
                                  SELECT @LanguageId,
                                         @CompanyId,
                                         @LanguageName,
                                         CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
                                         @Currentdate,
                                         @OperationsPerformedBy       
                        
						END
						ELSE
						BEGIN

								UPDATE [dbo].[Language]
									SET [CompanyId]					=   @CompanyId,
                                         [LanguageName]				=   @LanguageName,
                                         [InActiveDateTime]			=   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
                                         [UpdatedDateTime]			=   @Currentdate,
                                         [UpdatedByUserId]  		=   @OperationsPerformedBy       
										WHERE Id = @LanguageId
						END

                             SELECT Id FROM [dbo].[Language] WHERE Id = @LanguageId
                                   
                       END
                       ELSE
                     
                        RAISERROR (50008,11, 1)
                     
                     END
                     ELSE
                     BEGIN
                     
                            RAISERROR (@HavePermission,11, 1)
                            
                     END
           END
        END
        
    END TRY
    BEGIN CATCH
        
        THROW
    END CATCH
END
GO



