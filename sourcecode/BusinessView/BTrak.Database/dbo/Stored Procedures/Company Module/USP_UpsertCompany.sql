-------------------------------------------------------------------------------
-- Author       Ranadheer Rana
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      Save or update the company
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertCompany] @CompanyId=NULL,@CompanyName='Test Company',
 --@SiteAddress = 'http://testcompany.btrak.io', @WorkEmail = 'testcompany@testcompany.com' ,@Password = 'Test123!',
 --@IndustryId = 'C11D10CB-F287-4647-B2EA-A98D6A0373B5' , @MainUseCaseId = '74A838F4-F5F1-467C-A32B-FFE73ECB1EB4' , @TeamSize = 100,
 --@PhoneNumber = NULL, @CountryId = 'EAFDF9C6-C4D2-42D0-86EB-4B70197FF1BB',@TimeZoneId = '557C436A-5D19-4EEB-A677-93EA2609EAF1',
 --@CurrencyId = 'DF549957-74CC-4622-A094-05F64973F092' , @NumberFormatId =NULL , @DateFormatId = NULL, @TimeFormatId =NULL
CREATE PROCEDURE [dbo].[USP_UpsertCompany]
(
    @CompanyId UNIQUEIDENTIFIER = NULL,
    @CompanyName NVARCHAR(250) = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @SiteAddress NVARCHAR(250) = NULL,
    @WorkEmail NVARCHAR(250) = NULL,
    @Password NVARCHAR(250) = NULL,
    @IndustryId UNIQUEIDENTIFIER = NULL,
    @MainUseCaseId UNIQUEIDENTIFIER = NULL,
    @TeamSize BIGINT = NULL,
    @PhoneNumber NVARCHAR(100) = NULL,
    @CountryId UNIQUEIDENTIFIER = NULL,
    @TimeZoneId UNIQUEIDENTIFIER = NULL,
    @CurrencyId UNIQUEIDENTIFIER = NULL,
    @NumberFormatId UNIQUEIDENTIFIER = NULL,
    @DateFormatId UNIQUEIDENTIFIER = NULL,
    @TimeFormatId UNIQUEIDENTIFIER = NULL,
    @IsArchived BIT = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@IsSoftWare BIT = NULL,
    @CompanyAuthenticationId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
        IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
        IF(@CompanyId = '00000000-0000-0000-0000-000000000000') SET @CompanyId = NULL
		IF(@CompanyName =  '') SET @CompanyName = NULL
		IF(@MainUseCaseId = '00000000-0000-0000-0000-000000000000') SET @MainUseCaseId = NULL
        IF(@CountryId = '00000000-0000-0000-0000-000000000000') SET @CountryId = NULL
		IF(@TimeFormatId = '00000000-0000-0000-0000-000000000000') SET @TimeFormatId = NULL
		IF(@TimeZoneId = '00000000-0000-0000-0000-000000000000') SET @TimeZoneId = NULL
		IF(@CurrencyId = '00000000-0000-0000-0000-000000000000') SET @CurrencyId = NULL
		IF(@NumberFormatId = '00000000-0000-0000-0000-000000000000') SET @NumberFormatId = NULL
		IF(@DateFormatId = '00000000-0000-0000-0000-000000000000') SET @DateFormatId = NULL
		IF(@CompanyName IS NULL)
        BEGIN
           RAISERROR(50011,16,2,'CompanyName')
        END
        ELSE
        BEGIN
                
              IF(@CompanyId IS NULL) SET @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
              DECLARE @CompanyIdCount INT = (SELECT COUNT(1) FROM Company WHERE Id = @CompanyId)
              DECLARE @CompanyNameCount INT = (SELECT COUNT(1) FROM Company
                                               WHERE CompanyName = @CompanyName AND (@CompanyId IS NULL OR Id <> @CompanyId)
                                            )
                 IF(@CompanyIdCount = 0 AND @CompanyId IS NOT NULL)
                 BEGIN
                    RAISERROR(50002,16,1,'Company')
                 END
                 ELSE IF(@CompanyNameCount > 0)
                 BEGIN
                     RAISERROR(50001,16,1,'Company')
                 END
                 ELSE
                 BEGIN
                   DECLARE @IsLatest BIT = (CASE WHEN @CompanyId IS NULL
                                                   THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM [Company]
                                                                         WHERE Id = @CompanyId) = @TimeStamp
                                                                          THEN 1 ELSE 0 END END)
                     IF(@IsLatest = 1)
                     BEGIN
                         DECLARE @Currentdate DATETIME = GETDATE()
                     
					 IF(@CompanyId  IS NULL)
					 BEGIN
                     
                     IF(@CompanyAuthenticationId IS NULL)
                     BEGIN
					    SET @CompanyId = NEWID() 
                     END
                     ELSE
                     BEGIN
                        SET @CompanyId = @CompanyAuthenticationId
                     END

					 INSERT INTO [dbo].[Company](
                                                     [Id],
                                                     [CompanyName],
                                                     [SiteAddress],
                                                     [WorkEmail],
                                                     [Password],
                                                     [IndustryId],
                                                     [MainUseCaseId],
                                                     [TeamSize],
                                                     [PhoneNumber],
                                                     [CountryId],
                                                     [TimeZoneId],
                                                     [CurrencyId],
                                                     [NumberFormatId],
                                                     [DateFormatId],
                                                     [TimeFormatId],
                                                     [CreatedDateTime],
                                                     [InActiveDateTime],
													 [IsSoftWare],
                                                     CompanyAuthenticationId
                                                      )
                                              SELECT @CompanyId,
                                                     @CompanyName,
                                                     @SiteAddress,
                                                     @WorkEmail,
                                                     @Password,
                                                     @IndustryId,
                                                     @MainUseCaseId,
                                                     @TeamSize,
                                                     @PhoneNumber,
                                                     @CountryId,
                                                     @TimeZoneId,
                                                     @CurrencyId,
                                                     @NumberFormatId,
                                                     @DateFormatId,
                                                     @TimeFormatId,
                                                     @Currentdate,
                                                     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
													 @IsSoftWare,
                                                     @CompanyAuthenticationId

						END
						ELSE
						BEGIN

								UPDATE [dbo].[Company]
									            SET  [CompanyName]			=	    @CompanyName,
                                                     [SiteAddress]			=	    ISNULL(@SiteAddress,SiteAddress),
                                                     [WorkEmail]			=	    ISNULL(@WorkEmail,[WorkEmail]),
                                                     [Password]				=	    ISNULL(@Password,[Password]),
                                                     [IndustryId]			=	    ISNULL(@IndustryId,[IndustryId]),
                                                     [MainUseCaseId]		=	    @MainUseCaseId,
                                                     [TeamSize]				=	    @TeamSize,
                                                     [PhoneNumber]			=	    @PhoneNumber,
                                                     [CountryId]			=	    @CountryId,
                                                     [TimeZoneId]			=	    @TimeZoneId,
                                                     [CurrencyId]			=	    @CurrencyId,
                                                     [NumberFormatId]		=	    @NumberFormatId,
                                                     [DateFormatId]			=	    @DateFormatId,
                                                     [TimeFormatId]			=	    @TimeFormatId,
                                                     [UpdatedDateTime]		=	    @Currentdate,
                                                     [InActiveDateTime]		=	    CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
													 [IsSoftWare]           =       @IsSoftWare
											WHERE Id = @CompanyId

						END
                       SELECT Id FROM [dbo].[Company] WHERE Id = @CompanyId
                       END
                       ELSE
                             RAISERROR (50008,11, 1)
                       END
                       END
    END TRY
    BEGIN CATCH
       THROW
    END CATCH
END
