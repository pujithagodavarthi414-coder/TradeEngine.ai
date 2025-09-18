-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2020-01-10 00:00:00.000'
-- Purpose      To check company registration details
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC USP_CheckValidationsForCompanyRegistration @CompanyName = 'Softonis',@IsActiveOnMobile = 1,@SiteAddress = 'www.softonic.com',@WorkEmail = 'softoniss@gmail.com',@Password = '1234567',@IndustryId = '744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71',@FirstName = 'Sai',@MobileNumber = '232984458053241'
-------------------------------------------------------------------------------
CREATE PROCEDURE USP_CheckValidationsForCompanyRegistration
(  
 @CompanyName NVARCHAR(250) = NULL,
 @SiteAddress NVARCHAR(250) = NULL,
 @WorkEmail NVARCHAR(250) = NULL,
 @TeamSize INT = NULL,
 @Password NVARCHAR(250) = NULL,
 @IndustryId UNIQUEIDENTIFIER = NULL,
 @MainUseCaseId UNIQUEIDENTIFIER = NULL,
 @CountryId UNIQUEIDENTIFIER = NULL,
 @IsActiveOnMobile BIT = NULL, 
 @TimeZoneId UNIQUEIDENTIFIER = NULL,
 @CurrencyId UNIQUEIDENTIFIER = NULL,
 @NumberFormatId UNIQUEIDENTIFIER = NULL,
 @DateFormatId UNIQUEIDENTIFIER = NULL,
 @TimeFormatId UNIQUEIDENTIFIER = NULL,
 @FirstName NVARCHAR(100) = NULL,
 @MobileNumber NVARCHAR(40) = NULL,
 @LastName NVARCHAR(100) = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
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
		
        --ELSE IF(@MobileNumber IS NULL)
        --BEGIN
           
        --   RAISERROR(50011,16,2,'MobileNumber')

        --END

        ELSE IF(@SiteAddress IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'SiteAddress')

        END 
		    
		ELSE IF(@SiteAddress LIKE '% %')
		BEGIN
           
           RAISERROR(50011,16,2,'SiteAddressSpace')

        END 
		
        ELSE IF(@WorkEmail IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'WorkMail')

        END 
		 
		ELSE IF((SELECT COUNT(@WorkEmail) WHERE @WorkEmail NOT LIKE '%_@_%.__%') > 0)
        BEGIN
           
           RAISERROR(50011,16,2,'WorkMailInVaild')

        END 

        ELSE IF(@Password IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'Password')

        END
		 
        ELSE IF(@FirstName IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'FirstNameProvide')

        END 
		ELSE IF(@LastName IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'LastName')

        END 
        ELSE IF(@IndustryId IS NULL)
        BEGIN
           
           RAISERROR(50011,16,2,'TypeofIndustry')

        END
        ELSE
        BEGIN
        
        DECLARE @CompanyNameCount INT = (SELECT COUNT(1) FROM Company WHERE CompanyName = @CompanyName AND InActiveDateTime IS NULL)

        DECLARE @SiteAddressCount INT = (SELECT COUNT(1) FROM Company WHERE SiteAddress = @SiteAddress AND InActiveDateTime IS NULL)

		DECLARE @RegisteredEmailCount INT = (SELECT COUNT(1) FROM Company WHERE WorkEmail = @WorkEmail AND InActiveDateTime IS NULL)

        DECLARE @MobileNumberCount INT = (SELECT COUNT(1) FROM [User] WHERE MobileNo = @MobileNumber AND InActiveDateTime IS NULL)
        
		--DECLARE @WorkEmailCount INT = (SELECT COUNT(1) FROM [User] WHERE UserName = @WorkEmail AND AsAtInactiveDateTime IS NULL AND InActiveDateTime IS NULL)
        
		IF (@CompanyNameCount > 0)
        BEGIN

            RAISERROR(50001,16,1,'CompanyName')

        END
        ELSE IF (@SiteAddressCount > 0)
        BEGIN

            RAISERROR(50001,16,1,'SiteAddress')

        END
        --ELSE IF (@RegisteredEmailCount > 0)
        --BEGIN

        --    RAISERROR(50001,16,1,'Email')

        --END
		ELSE IF (@MobileNumberCount > 0)
        BEGIN

            RAISERROR(50001,16,1,'MobileNumber')

        END
        --ELSE IF (@WorkEmailCount > 0)
        --BEGIN

        --    RAISERROR(50001,16,1,'Email')

        --END
        END
        END TRY
        BEGIN CATCH
            THROW
        END CATCH
END