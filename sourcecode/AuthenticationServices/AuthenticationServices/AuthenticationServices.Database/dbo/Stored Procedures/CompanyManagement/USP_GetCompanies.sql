CREATE PROCEDURE [dbo].[USP_GetCompanies]
(
  @CompanyId UNIQUEIDENTIFIER = NULL,
  @SearchText NVARCHAR(500) = NULL,
  @IndustryId UNIQUEIDENTIFIER = NULL,  
  @MainUseCaseId UNIQUEIDENTIFIER = NULL,   
  @TeamSize INT = NULL, 
  @PhoneNumber NVARCHAR(100) = NULL,    
  @CountryId UNIQUEIDENTIFIER = NULL,   
  @TimeZoneId UNIQUEIDENTIFIER = NULL,  
  @CurrencyId UNIQUEIDENTIFIER = NULL,
  @NumberFormatId UNIQUEIDENTIFIER = NULL,
  @DateFormatId UNIQUEIDENTIFIER = NULL,
  @TimeFormatId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
  @UserCompanyId UNIQUEIDENTIFIER = NULL,
  @IsArchived BIT = NULL ,
  @ForSuperUser BIT = NULL,
  @PageNumber INT = 1,
  @PageSize INT = 10
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        IF(@ForSuperUser = 1)
	    BEGIN
	        SET @OperationsPerformedBy = (select Id from [User] Where UserName = 'Snovasys.Support@Support')
	    END

        DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,@UserCompanyId,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN
            
            IF(@CompanyId = '00000000-0000-0000-0000-000000000000') SET @CompanyId = NULL
               
			IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
               
			IF(@SearchText = '' OR @SearchText = 'null') SET  @SearchText = NULL

            IF(@IsArchived IS NULL) SET @IsArchived = 0
             
            SET @SearchText = '%'+ @SearchText +'%'

            SELECT C.[Id] AS CompanyId,
                      C.[CompanyName],
                      C.[TimeStamp],
                      C.[SiteAddress],    
                      C.[WorkEmail],  
                      C.[Password],   
                      C.[IndustryId], 
                      C.[MainUseCaseId],  
                      C.[TeamSize],   
                      C.[PhoneNumber] AS MobileNumber,    
                      C.[CountryId],  
                      C.[TimeZoneId], 
                      C.[CurrencyId],
                      C.[NumberFormatId],
                      C.[DateFormatId],
                      C.[TimeFormatId],
                      C.[CreatedDateTime] AS OriginalCreatedDateTime,
                      C.[Id],
                      C.[CreatedDateTime],    
					  C.IsRemoteAccess ,
					  C.IsDemoData,
					  C.ReDirectionUrl,
                      C.ResponsiblePersonName,
					  ISNULL(C.NoOfPurchasedLicences,0) AS NoOfPurchasedLicences,
                      C.TrailDays AS TrialPeriod,
					  --90 -( DATEDIFF(day,C.CreatedDateTime,getdate()) ) AS TrailDays,
					  ISNULL(C.TrailDays, 90) -( DATEDIFF(day,C.CreatedDateTime,getdate()) ) AS TrailDays,
					  C.[TimeStamp],	
					  ISNULL(C.[Language],'en') LanCode,
					  CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
					  C.VAT,
					  C.PrimaryCompanyAddress,
					  C.SiteDomain,
                      C.CompanyLogo,
                      C.UpdatedDateTime,
                      C.ConfigurationUrl,
                      ISNULL(C.TrailDays, 0) AS TrialPeriod,
                      C.ApiUrl,
		   			  TotalCount = COUNT(1) OVER()
                    
               FROM  [dbo].[Company] C WITH (NOLOCK)

               WHERE (@CompanyId IS NULL OR C.Id = @CompanyId)
                     AND (@IndustryId IS NULL OR C.IndustryId = @IndustryId)
                     AND (@MainUseCaseId IS NULL OR C.MainUseCaseId = @MainUseCaseId)
                     AND (@CountryId IS NULL OR C.CountryId = @CountryId)
                     AND (@CurrencyId IS NULL OR C.CurrencyId = @CurrencyId)
                     AND (@TimeZoneId IS NULL OR C.TimeZoneId = @TimeZoneId)
                     AND (@CurrencyId IS NULL OR C.CurrencyId = @CurrencyId)
                     AND (@NumberFormatId IS NULL OR C.NumberFormatId = @NumberFormatId)
                     AND (@DateFormatId IS NULL OR C.DateFormatId = @DateFormatId)
                     AND (@TimeFormatId IS NULL OR C.TimeFormatId = @TimeFormatId)
                     AND (@SearchText IS NULL OR 
                           ((CompanyName LIKE @SearchText)
                          OR (WorkEmail LIKE @SearchText)
                          ))
					AND (@IsArchived IS NULL OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))
					ORDER BY C.CompanyName ASC
                OFFSET ((@PageNumber - 1) * @PageSize) ROWS

          FETCH NEXT @PageSize ROWS ONLY
        END
        ELSE
            RAISERROR (@HavePermission,11, 1)

     END TRY
     BEGIN CATCH 
        
          THROW

     END CATCH
END