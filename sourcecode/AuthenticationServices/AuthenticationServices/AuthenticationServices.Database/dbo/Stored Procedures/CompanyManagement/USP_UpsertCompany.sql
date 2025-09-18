CREATE PROCEDURE [dbo].[USP_UpsertCompany]
(
    @CompanyId UNIQUEIDENTIFIER = NULL,
    @CompanyName NVARCHAR(250) = NULL,
    @FirstName NVARCHAR(250) = NULL,
    @LastName NVARCHAR(250) = NULL,
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
    @CompanyLogo NVARCHAR(250) = NULL,
    @TrialDays INT = NULL,
    @SiteDomain NVARCHAR(250) = NULL,
    @ApiUrl NVARCHAR(250) = NULL
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

					 SET @CompanyId = NEWID() 
					 INSERT INTO [dbo].[Company](
                                                     [Id],
                                                     [CompanyName],
                                                     [SiteAddress],
                                                     [SiteDomain],
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
                                                     [CompanyLogo],
                                                     [ApiUrl]
                                                      )
                                              SELECT @CompanyId,
                                                     @CompanyName,
                                                     @SiteAddress,
                                                     @SiteDomain,
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
                                                     @CompanyLogo,
                                                     @ApiUrl

						END
						ELSE
						BEGIN
                                DECLARE @ResponsiblePersonName NVARCHAR(500) = @FirstName + ' ' + @LastName
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
													 [IsSoftWare]           =       @IsSoftWare,
                                                     [ResponsiblePersonName] = @ResponsiblePersonName,
                                                     [CompanyLogo]          =  @CompanyLogo,
                                                     [TrailDays]            = @TrialDays,
                                                     [SiteDomain]           = @SiteDomain,
                                                     [ApiUrl]               = @ApiUrl
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
